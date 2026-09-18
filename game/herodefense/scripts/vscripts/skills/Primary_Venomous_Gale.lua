Primary_Venomous_Gale = class({})

LinkLuaModifier("modifier_Primary_Venomous_Gale_slow", "skills/Primary_Venomous_Gale", LUA_MODIFIER_MOTION_NONE)

function Primary_Venomous_Gale:IsHiddenWhenStolen() 	return false end
function Primary_Venomous_Gale:IsRefreshable() 			return true end
function Primary_Venomous_Gale:IsStealable() 			return true end
function Primary_Venomous_Gale:IsNetherWardStealable()	return true end

function Primary_Venomous_Gale:GetCastRange()
	if IsServer() then
		return 0
	else
		return self:GetSpecialValueFor("distance")
	end
end

function Primary_Venomous_Gale:OnSpellStart()
	local caster = self:GetCaster()
	local pos0 = caster:GetAbsOrigin()
	pos0.z = pos0.z + 100
	local pos = self:GetCursorPosition()
	if pos==caster:GetOrigin() then
		pos = pos + caster:GetForwardVector()*100
	end
	local sound = CreateUnitByName("npc_dummy_unit", pos0, false, nil, nil, 0)
	sound:EmitSound("Hero_Venomancer.VenomousGale")
	sound:ForceKill(false)
	local distance = self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus()
	distance = math.max(distance,100)
	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		Source = caster,
		vSpawnOrigin = pos0,
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("radius"),
		fEndRadius = self:GetSpecialValueFor("radius"),
		-- Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 3,
		bDeleteOnHit = false,
		vVelocity = (pos - pos0):Normalized() * self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
		--ExtraData = {}
	}
	ProjectileManager:CreateLinearProjectile(info)
end


function Primary_Venomous_Gale:OnProjectileHit(target, location)
	if not target then
		return
	end
	target:EmitSound("Hero_Venomancer.VenomousGaleImpact")

	local poison = self:GetSpecialValueFor("poison") + self:GetSpecialValueFor("bonus_poison")*self:GetCaster():HDGetPrimaryStatValue()

	target:Poison(self:GetCaster(), self, poison)
	target:AddNewModifier(self:GetCaster(), self, "modifier_Primary_Venomous_Gale_slow", {duration = (self:GetSpecialValueFor("duration"))})
end


modifier_Primary_Venomous_Gale_slow = advanced_modifier({})

function modifier_Primary_Venomous_Gale_slow:IsDebuff()			return true end
function modifier_Primary_Venomous_Gale_slow:IsHidden() 			return false end
function modifier_Primary_Venomous_Gale_slow:IsPurgable() 			return false end
function modifier_Primary_Venomous_Gale_slow:IsPurgeException() 	return false end
function modifier_Primary_Venomous_Gale_slow:GetEffectName() return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf" end
function modifier_Primary_Venomous_Gale_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Venomous_Gale_slow:IsPoisonDeBuff() return true end

function modifier_Primary_Venomous_Gale_slow:OnCreated()
	self.initial_slow = self:GetAbility():GetSpecialValueFor("initial_slow")
end

function modifier_Primary_Venomous_Gale_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end

function modifier_Primary_Venomous_Gale_slow:GetModifierMoveSpeedBonus_Constant() 
	return (0 - self.initial_slow*(self:GetRemainingTime()/self:GetDuration())) 
end








