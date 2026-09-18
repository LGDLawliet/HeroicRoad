
Primary_Dual_Breath = class({})

LinkLuaModifier("modifier_Primary_Dual_Breath_debuff", "skills/Primary_Dual_Breath", LUA_MODIFIER_MOTION_NONE)

function Primary_Dual_Breath:IsHiddenWhenStolen() 		return false end
function Primary_Dual_Breath:IsRefreshable() 			return true  end
function Primary_Dual_Breath:IsStealable() 				return true  end
function Primary_Dual_Breath:IsNetherWardStealable() 	return true end
function Primary_Dual_Breath:GetCastRange()   return self:GetSpecialValueFor("Project_range") end 

function Primary_Dual_Breath:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self.direction = (pos - caster:GetAbsOrigin()):Normalized()
	self.direction.z = 0
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:EmitSound("Hero_Jakiro.DualBreath.Cast")
	local distance = self:GetSpecialValueFor("Project_range") + caster:GetCastRangeBonus() 
	distance = math.max(distance,100)
	local speed = self:GetSpecialValueFor("Project_speed")
	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("Project_radius"),
		fEndRadius = self:GetSpecialValueFor("Project_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = self.direction * speed,
		bProvidesVision = false,
		--ExtraData = {sound = sound:entindex()},
	}
	ProjectileManager:CreateLinearProjectile(info)
	local info2 = 
	{
		Ability = nil,
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_ice.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("Project_radius"),
		fEndRadius = self:GetSpecialValueFor("Project_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = self.direction * speed,
		bProvidesVision = false,
		--ExtraData = {sound = sound:entindex()},
	}
	ProjectileManager:CreateLinearProjectile(info2)
end

------------------------------------------------------------

function Primary_Dual_Breath:OnProjectileHit(target, pos)
	if not target or not IsServer() then
		return
	end
	local duration = self:GetSpecialValueFor("duration")
	--local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.5)
	target:AddNewModifier(self:GetCaster(), self, "modifier_Primary_Dual_Breath_debuff", {duration = duration })

end

modifier_Primary_Dual_Breath_debuff = class({})

function modifier_Primary_Dual_Breath_debuff:IsDebuff()			return true end
function modifier_Primary_Dual_Breath_debuff:IsHidden() 			return false end
function modifier_Primary_Dual_Breath_debuff:IsPurgable() 			return true end
function modifier_Primary_Dual_Breath_debuff:IsPurgeException() 	return true end
function modifier_Primary_Dual_Breath_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Primary_Dual_Breath_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Dual_Breath_debuff:GetModifierMoveSpeedBonus_Constant() return self.move_slow end
function modifier_Primary_Dual_Breath_debuff:GetModifierAttackSpeedBonus_Constant() return self.attack_slow  end

function modifier_Primary_Dual_Breath_debuff:OnCreated()
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
	self.attack_slow =  -self:GetAbility():GetSpecialValueFor("attack_speed_slow")
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_interval"))
	end
end

function modifier_Primary_Dual_Breath_debuff:OnIntervalThink()
	if self:GetParent():IsMagicImmune() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local kv_dmg = ability:GetSpecialValueFor("damage_per_second") + self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("intelligence_index")

	local dmg = kv_dmg
	local damage_type = ability:GetAbilityDamageType()
	ApplyDamage({
		victim = parent,
		attacker = caster,
		ability = ability,
		damage = dmg,
		damage_type = damage_type,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, dmg, nil)
end
