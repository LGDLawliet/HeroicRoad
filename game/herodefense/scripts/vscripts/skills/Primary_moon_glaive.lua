Primary_moon_glaive = class({})
LinkLuaModifier( "modifier_Primary_moon_glaive", "skills/Primary_moon_glaive", LUA_MODIFIER_MOTION_NONE )

function Primary_moon_glaive:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/moon_glavive/moon_glaive_bounce.vpcf", context )
end
function Primary_moon_glaive:GetIntrinsicModifierName()
	return "modifier_Primary_moon_glaive"
end

function Primary_moon_glaive:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	if not IsServer() then return end
	local caster = self:GetCaster()
	local damage_index = 1-self:GetSpecialValueFor("damage_down")*0.01
	local damageTable = {
		victim = target,
		attacker =caster,
		damage =keys.dmg,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
	}
	ApplyDamage(damageTable)

	local bounce = keys.bounce
	if bounce>=1 and IsValid(target) then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, 200+caster:Script_GetAttackRange()*0.8,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false
		)
		
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

function Primary_moon_glaive:GlaiveAttck(srouce,target, damage, bounce)
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

modifier_Primary_moon_glaive = advanced_modifier({})

function modifier_Primary_moon_glaive:IsHidden()	return true end
function modifier_Primary_moon_glaive:IsDebuff()	return false end
function modifier_Primary_moon_glaive:IsPurgable()	return false end
function modifier_Primary_moon_glaive:IsPurgeException() return false end
function modifier_Primary_moon_glaive:RemoveOnDeath() return false end
-- function Primary_moon_glaive:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_Primary_moon_glaive:ADDeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_Primary_moon_glaive:OnAttackLanded(keys)
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
		local damage_index = 1-self:GetAbility():GetSpecialValueFor("damage_down")*0.01

		if caster:IsDisableSplit() or not caster:IsApplyModifier() then
			return
		end
		local damage = keys.damage

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 200+caster:Script_GetAttackRange()*0.8,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false
		)
		
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
