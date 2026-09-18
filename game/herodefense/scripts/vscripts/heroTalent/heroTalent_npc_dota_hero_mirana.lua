heroTalent_npc_dota_hero_mirana = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_mirana", "heroTalent/heroTalent_npc_dota_hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_mirana_active_luna", "heroTalent/heroTalent_npc_dota_hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight", "heroTalent/heroTalent_npc_dota_hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_mirana_active_marci", "heroTalent/heroTalent_npc_dota_hero_mirana", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_mirana_effect", "heroTalent/heroTalent_npc_dota_hero_mirana", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_mirana:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_mirana:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_mirana:IsStealable() 				return true end
function heroTalent_npc_dota_hero_mirana:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_mirana:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_mirana" end
function heroTalent_npc_dota_hero_mirana:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function heroTalent_npc_dota_hero_mirana:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("lvl_damage")*caster:GetLevel()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		if unit:GetUnitName() == "npc_dota_hero_luna" then
			caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_mirana_active_luna", {duration = 1})
			unit:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_mirana_active_luna", {duration = 1})
		end
		if unit:GetUnitName() == "npc_dota_hero_dragon_knight" then
			caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight", {duration = self:GetSpecialValueFor("incoming_duration")})
			unit:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight", {duration = self:GetSpecialValueFor("incoming_duration")})
		end
		if unit:GetUnitName() == "npc_dota_hero_marci" then
			caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_mirana_active_marci", {duration = self:GetSpecialValueFor("incoming_duration")})
			unit:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_mirana_active_marci", {duration = self:GetSpecialValueFor("incoming_duration")})
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for i ,enemy in pairs(enemies) do
			
			local pfx = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:ReleaseParticleIndex(pfx)
			Timers:CreateTimer(0.57, function()
				if not ability or ability:IsNull() then
					return
				end
				local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = self:GetAbilityDamageType(), --Optional.
							ability = ability, --Optional.
							}
			ApplyDamage(damageTable)
			enemy:EmitSound("Ability.StarfallImpact")
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
			end)
			if i >= self:GetSpecialValueFor("limit") then
				break
			end
		end
end

-------------------------------------月蚀可以用-------------------------------------------------
modifier_heroTalent_npc_dota_hero_mirana_active_luna = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_mirana_active_luna:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_mirana_active_luna:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_luna:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_luna:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_luna:GetTexture()return "luna_eclipse" end

function modifier_heroTalent_npc_dota_hero_mirana_active_luna:OnCreated(table)
	if IsServer() then
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for i,enemy in pairs(enemies) do

			local pfx = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			local pfx2 = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(pfx)
			ParticleManager:ReleaseParticleIndex(pfx2)
			local ability = self:GetAbility()
			Timers:CreateTimer(0.9, function()
				local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = math.min(enemy:GetMaxHealth()*ability:GetSpecialValueFor("moon_hp_damage")*0.01 , caster:GetAverageTrueAttackDamage(nil)*50),
							damage_type = DAMAGE_TYPE_PURE,
							damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
							ability = ability, --Optional.
							}
			ApplyDamage(damageTable)
			end)
			if i >= ability:GetSpecialValueFor("limit") then
				break
			end
		end
	end
end
function modifier_heroTalent_npc_dota_hero_mirana_active_luna:OnRefresh(table)
	if IsServer() then
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for i,enemy in pairs(enemies) do

			local pfx = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			local pfx2 = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(pfx)
			ParticleManager:ReleaseParticleIndex(pfx2)
			local ability = self:GetAbility()
			Timers:CreateTimer(0.9, function()
				local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = math.min(enemy:GetMaxHealth()*ability:GetSpecialValueFor("moon_hp_damage")*0.01 , 1000000),
							
							damage_type = DAMAGE_TYPE_PURE,
							damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
							ability = ability, --Optional.
							}
			ApplyDamage(damageTable)
			end)
			if i >= ability:GetSpecialValueFor("limit") then
				break
			end
		end
	end
end
-------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:GetTexture()return "dragon_knight/dk_persona/dragon_knight_dragon_blood_helm_persona1" end

function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:OnCreated(table)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	self:GetParent():EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
end
function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:OnRefresh(table)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	self:GetParent():EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
end
function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:ADDeclareFunctions(table)
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_heroTalent_npc_dota_hero_mirana_active_dragon_knight:Advanced_GetModifierIncomingDamage_Percentage(table)
	return	-self:GetAbility():GetSpecialValueFor("incoming_down")
end
-------------------------------------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_mirana_active_marci = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_mirana_active_marci:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:GetTexture()return "marci_unleash_upgrade" end

function modifier_heroTalent_npc_dota_hero_mirana_active_marci:OnCreated()
	if not IsServer() then
		return
	end
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("attack_speed_count"))
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:OnRefresh()
	if not IsServer() then
		return
	end
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("attack_speed_count"))
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_heroTalent_npc_dota_hero_mirana_active_marci:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:GetModifierAttackSpeedBonus_Constant()
	
	if self:GetStackCount() > 0 then
		return	1200
	end
	return 0 
end
function modifier_heroTalent_npc_dota_hero_mirana_active_marci:OnAttack()
	if self:GetParent() :IsInSpecialAttack() then
		return
	end
	if self:GetStackCount() > 0 then
		self:DecrementStackCount()
	end
	if self:GetStackCount()<=0 then
		self:SafeDestroy()

	end
end
-------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_mirana = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_mirana:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_mirana:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_mirana:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_mirana:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_mirana:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_mirana:DeclareFunctions()
	return {
	}
end
function modifier_heroTalent_npc_dota_hero_mirana:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},    
    }
end

function modifier_heroTalent_npc_dota_hero_mirana:OnCreated(keys)
    if not IsServer() then
        return
    end
	if not self:GetParent():IsRealHero() then
		return false
	end
	local heroes = GetAllRealHeroes()
	local table = {
		npc_dota_hero_dragon_knight = 1,
		npc_dota_hero_luna = 2,
		npc_dota_hero_marci = 4,
	}
	for _, unit in ipairs(heroes) do
		if table[unit:GetUnitName()] then
			self:SetStackCount(self:GetStackCount()+table[unit:GetUnitName()])
		end
	end
	table = nil
end

function modifier_heroTalent_npc_dota_hero_mirana:OnAttack(keys)
	if not IsServer() then 
		return 
	end
	if bit.band( self:GetStackCount(), 4 ) == 4 or bit.band( self:GetStackCount(), 2 ) == 2 or bit.band( self:GetStackCount(), 1 ) == 1 then
		return
	end
	if keys.target and not keys.attacker:IsInSpecialAttack() then	
		if self:GetAbility():GetSpecialValueFor("chance_self") >= RandomInt(0, 100) then
			self:GetAbility():OnSpellStart()
		end
	end
end
