--
heroTalent_npc_dota_hero_obsidian_destroyer = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_obsidian_destroyer", "heroTalent/heroTalent_npc_dota_hero_obsidian_destroyer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active", "heroTalent/heroTalent_npc_dota_hero_obsidian_destroyer", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_obsidian_destroyer:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_obsidian_destroyer"
end
function heroTalent_npc_dota_hero_obsidian_destroyer:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf", context )
end
function heroTalent_npc_dota_hero_obsidian_destroyer:OnProjectileHit_ExtraData(target, location, keys)
	local caster = self:GetCaster()
	if not target or not target:IsAlive() then
		return
	end
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_ObsidianDestroyer.projectileImpact", caster)
	local damagetable= {
		victim =target,
		attacker =caster,
		damage = keys.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
		}
	ApplyDamage(damagetable)
end
-----
modifier_heroTalent_npc_dota_hero_obsidian_destroyer = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:DestroyOnExpire() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:OnCreated()
	self.ability = self:GetAbility()
	self.line = self.ability:GetSpecialValueFor("line")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.cd = self.ability:GetSpecialValueFor("cd")

	if IsServer() then
		self.talentgain = self.ability:GetTalentGain(1)
		self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")*self.talentgain*0.01
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local unit = keys.target
	if not IsEnemy(attacker,unit) then return end
	if not attacker:IsAlive() or self:GetRemainingTime() > 0 then return end
	if keys.inflictor == self.ability then return end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return end

	if unit:IsAlive() then
		self:OrbShoot(unit)

		attacker:GameTimer(0.03,function()
			self:SetDuration(self.cd, true)
		end)
	end
	return 0
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	local unit = self:GetParent()
	if unit:GetHealthPercent() <= self.line then
		if self.ability:IsCooldownReady() then
			if not unit:IsAlive() then
				unit:ModifyHealth(1, self.ability, false, 0)
			end
			unit:AddNewModifier(unit, self.ability, "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active", {duration = self.duration})
			self.ability:UseResources(true, true, true, true)
			return -200
		end
	end
	return 0
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:OrbShoot(target)
	if not IsServer() then return end
	if not target then return end
	local caster = self:GetCaster()
	self.talentgain = self.ability:GetTalentGain(1)
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")*self.talentgain*0.01*caster:GetLevel()
	self.damage_final = self.ability:GetSpecialValueFor("base_damage") + self.bonus_damage*caster:GetMaxMana()
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
		iMoveSpeed = 3500,
		-- sourceloc = pos,
		-- caster:GetProjectileSpeed()
		-- vSourceLoc = pos,
		bDrawsOnMinimap = false,  --？？
		bDodgeable = false,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = true, --提供视野
		ExtraData = {damage = self.damage_final}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)				
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus_damage*100
	end
end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:AddCustomTransmitterData( )
	return
	{
		bonus_damage = self.bonus_damage,
	}
end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer:HandleCustomTransmitterData( data )
	self.bonus_damage = data.bonus_damage
end
------
modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:IsStunDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:RemoveOnDeath()	return false end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:OnCreated( kv )
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	
	if not IsServer() then return end
	self.base_ability = self.parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_obsidian_destroyer")
	self:StartIntervalThink(self.interval)
	self.parent:AddNoDraw()
	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:OnRefresh( kv )
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.base_ability = self.parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_obsidian_destroyer")
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:OnIntervalThink()
	if not self.ability then self:Destroy() return end
	if not self.parent:IsAlive() then return end
	
	local i = 0
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, enemy in pairs(enemies) do
		if enemy:IsAlive() and self.base_ability then
			self.base_ability:OrbShoot(enemy)
			i = i + 1
			if i >= self.max then
				break 
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:OnDestroy()
	if not IsServer() then return end
	if not self.ability then return end

	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(400,0,0) )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	self.parent:RemoveNoDraw()
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	StopSoundOn( sound_loop, self.parent )
	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.End"
	EmitSoundOnLocationWithCaster( self.parent:GetOrigin(), sound_cast, self.parent )
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_active:PlayEffects()
	local particle_cast1 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf"
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"

	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self.parent:GetOrigin() )
	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self.parent:GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self.parent:GetOrigin() )

	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster(self.parent:GetOrigin(), sound_loop, self.parent)
end