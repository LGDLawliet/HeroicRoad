Advanced_moon_glaive = class({})
LinkLuaModifier( "modifier_Advanced_moon_glaive", "skills/Advanced_moon_glaive", LUA_MODIFIER_MOTION_NONE )
function Advanced_moon_glaive:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/moon_glavive/moon_glaive_bounce.vpcf", context )
end
function Advanced_moon_glaive:CheckKV(key)
	local table = {
		bounce = 0.04,
	}
	local value = table[key] or -1
	return value

end

function Advanced_moon_glaive:UnlockFirstCore(key)

	return false
end
function Advanced_moon_glaive:UnlockSecondCore(key)

	return false
end
function Advanced_moon_glaive:UnlockThirdCore(key)

	return false
end

function Advanced_moon_glaive:GetIntrinsicModifierName()
	return "modifier_Advanced_moon_glaive"
end

function Advanced_moon_glaive:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	if not IsServer() then return end
	local caster = self:GetCaster()
	local damage_index = 1-self:GetSpecialValueFor("damage_down")*0.01
	if self.advanced_level >= 10 then
		damage_index = 0.95
		if self.advanced_level >= 20 then
			if not caster:IsInNightTime() then
				damage_index = 0.98
			end
		end
	end
	local damageTable = {
		victim = target,
		attacker =caster,
		damage =keys.dmg,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT
	}

	ApplyDamage(damageTable)

	local bounce = keys.bounce
	local radius = 200+caster:Script_GetAttackRange()*0.8
	if self.advanced_level >= 15 then
		radius = 200+caster:Script_GetAttackRange()*1.5
	end
	if bounce>=1 and IsValid(target) then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false
		)
		if #enemies==1 then
			if self.advanced_level >= 5 then
				local unit = enemies[1]
				local self_index = damage_index*0.6
				self:GlaiveAttck(target,unit,keys.dmg*self_index,bounce)
			end
			caster:GiveMana(caster:GetMaxMana()*self:GetSpecialValueFor("mana")*0.01)
			caster:Heal(caster:GetMaxMana()*self:GetSpecialValueFor("mana")*0.01,self)
			return
		end
		
		
		local newTarget
		for _, unit in ipairs(enemies) do
			if unit~=target then
				newTarget=unit
			end
		end
		if newTarget then
			self:GlaiveAttck(target,newTarget,keys.dmg*damage_index,bounce)
		end
	end
end

function Advanced_moon_glaive:GlaiveAttck(srouce,target, damage, bounce)
	local caster = self:GetCaster()
	local attach_point = srouce:ScriptLookupAttachment( "attach_hitloc" )
	local effect = "particles/rebuild/spell/moon_glavive/moon_glaive_bounce.vpcf"
	local effect_speed = 1500
	local info = 
	{
		Target =target,
		-- Source = srouce,
		vSourceLoc = srouce:GetAttachmentOrigin(attach_point),
		Ability = self,	
		EffectName = effect,
		iMoveSpeed = effect_speed,
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {bounce = bounce-1, dmg = damage}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
---------------------------------------------------------------------------------------------------------

modifier_Advanced_moon_glaive = advanced_modifier({})

function modifier_Advanced_moon_glaive:IsHidden()	return true end
function modifier_Advanced_moon_glaive:IsDebuff()	return false end
function modifier_Advanced_moon_glaive:IsPurgable()	return false end
function modifier_Advanced_moon_glaive:IsPurgeException() return false end
function modifier_Advanced_moon_glaive:RemoveOnDeath() return false end
-- function Advanced_moon_glaive:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_Advanced_moon_glaive:ADDeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_Advanced_moon_glaive:Advanced_GetModifierIncomingDamage_Percentage(event)
    if event.inflictor and event.inflictor:GetName() == "Advanced_moon_glaive" then
        return -100
    end
    return 0
end

function modifier_Advanced_moon_glaive:OnAttackLanded(keys)
	if not IsServer() then return end
	local arrow = self:GetParent():HasModifier("modifier_Primary_split_shot") or  self:GetParent():HasModifier("modifier_Middle_split_shot") or  self:GetParent():HasModifier("modifier_Advanced_split_shot")
	if arrow then
		return
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() then	
		if not self:GetParent():IsRealHero() then
			return false
		end

		local caster = keys.attacker
		local bounce = self:GetAbility():GetSpecialValueFor("bounce")
		local chance = self:GetAbility():GetSpecialValueFor("chance")
		local bonus = 1
		if self:GetAbility().advanced_level >= 20 then
			chance = 100
			bonus = 2
		end
        if self:GetParent():IsInNightTime() and chance >= math.random(1,100) then
            bounce = bounce + bonus
        end

		local damage_index = 1-self:GetAbility():GetSpecialValueFor("damage_down")*0.01
		if self:GetAbility().advanced_level >= 10 then
			damage_index = 0.92
			if self:GetAbility().advanced_level >= 20 then
				if not caster:IsInNightTime() then
					damage_index = 0.95
				end
			end
		end

		if caster:IsDisableSplit() or not caster:IsApplyModifier() then
			return
		end
		local damage = keys.damage
		local radius = 200+caster:Script_GetAttackRange()*0.8
		if self:GetAbility().advanced_level >= 15 then
			radius = 200+caster:Script_GetAttackRange()*1.5
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false
		)
		if #enemies==1 then
			if self:GetAbility().advanced_level >= 5 then
				local unit = enemies[1]
				local self_index = damage_index*0.5
				self:GetAbility():GlaiveAttck(keys.target,unit,damage*self_index,bounce)
			end
			caster:GiveMana(caster:GetMaxMana()*self:GetAbility():GetSpecialValueFor("mana")*0.01)
			caster:Heal(caster:GetMaxMana()*self:GetAbility():GetSpecialValueFor("mana")*0.01,self:GetAbility())
			return
		end
		local target
		for _, unit in ipairs(enemies) do
			if unit~=keys.target then
				target=unit
			end
		end

		if target then
			self:GetAbility():GlaiveAttck(keys.target,target,damage*damage_index,bounce)
		end
	end
end
