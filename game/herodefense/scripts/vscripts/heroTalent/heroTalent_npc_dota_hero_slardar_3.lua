LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slardar_3", "heroTalent/heroTalent_npc_dota_hero_slardar_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slardar_3_debuff", "heroTalent/heroTalent_npc_dota_hero_slardar_3.lua", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_slardar_3 = class({})

function heroTalent_npc_dota_hero_slardar_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_slardar_3"
end
function heroTalent_npc_dota_hero_slardar_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
end
---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_slardar_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_slardar_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slardar_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slardar_3:DestroyOnExpire() return false end

function modifier_heroTalent_npc_dota_hero_slardar_3:OnCreated(params)
	self.ability = self:GetAbility()
	self.cleave_index = self.ability:GetSpecialValueFor("cleave_index")*0.01
	
	self.summon = self.ability:GetSpecialValueFor("summon")
	self.bonus_summon = self.ability:GetSpecialValueFor("bonus_summon")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.summon_index = self.ability:GetSpecialValueFor("summon_index")*0.01


	self.level = 0
	self.self_summon = 0
	self.index = self.cleave_index
	self.last_summon = 0
	if IsServer() then
		if self:GetParent():IsHero() then
			self:StartIntervalThink(2)
		end
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end

function modifier_heroTalent_npc_dota_hero_slardar_3:OnIntervalThink()
	local parent = self:GetParent()
	self.level = parent:GetLevel()
	self.self_summon = GetSummonIntensity(parent)*0.01
	

	self.last_summon = self.level*self.bonus_summon + self.summon
	self.index = self.cleave_index*(1 + self.self_summon*self.summon_index)

end

function modifier_heroTalent_npc_dota_hero_slardar_3:OnSummonUnit(keys)
	if not IsServer() then return end
	if not self:GetParent():IsHero() then return end

	keys.target:AddNewModifier(self:GetCaster(), self.ability, "modifier_heroTalent_npc_dota_hero_slardar_3", {})
end

function modifier_heroTalent_npc_dota_hero_slardar_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP, -- 处理输出伤害
	}
end

function modifier_heroTalent_npc_dota_hero_slardar_3:ADDeclareFunctions()
	local funcs =  {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}

	if self:GetParent():IsHero() then
		funcs = {
			advanced_MODIFIER_PROPERTY_Summon_Intensity,
			MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
		}
	end

	return funcs
end
function modifier_heroTalent_npc_dota_hero_slardar_3:Advanced_GetModifier_Summon_Intensity()
	return self.summon + self.bonus_summon*self:GetParent():GetLevel()
end
function modifier_heroTalent_npc_dota_hero_slardar_3:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self.ability then return end
	if self:GetRemainingTime() >= 0 then return end
	
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end

	if self:GetParent():IsDisableCleave() then
		return
	end
	local target = keys.target

	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,0,0))
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	local particle_cast_fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx2, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx2)

	local cleave_damage = keys.damage * self.index
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = cleave_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
								ability = self.ability, --Optional.
								hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT
								}
			ApplyDamage(damageTable)
			if enemy:IsAlive() then
				enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_heroTalent_npc_dota_hero_slardar_3_debuff", {duration = self.duration})
			end
		end
	end
	if target:IsAlive() then
		target:AddNewModifier(self:GetCaster(), self.ability, "modifier_heroTalent_npc_dota_hero_slardar_3_debuff", {duration = self.duration})
	end
	self:SetDuration(self.ability:GetCooldown(1), true)
end

function modifier_heroTalent_npc_dota_hero_slardar_3:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.index*100
	end
end
function modifier_heroTalent_npc_dota_hero_slardar_3:AddCustomTransmitterData( )
	return
	{
		index = self.index,
		last_summon = self.last_summon
	}
end

function modifier_heroTalent_npc_dota_hero_slardar_3:HandleCustomTransmitterData( data )
	self.index = data.index
	self.last_summon = data.last_summon
end


---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_slardar_3_debuff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:IsDebuff() return true end

function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if not self.ability then return end
	self.armor = self.ability:GetSpecialValueFor("armor")
end
function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:OnRefresh(params)
	self.ability = self:GetAbility()
	if not self.ability then return end
	self.armor = self.ability:GetSpecialValueFor("armor")
end
function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:ADDeclareFunctions()
	local funcs =  {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_slardar_3_debuff:Advanced_GetModifierPhysicalArmorBonus()
	if not self.ability then return end
	return -self.armor
end