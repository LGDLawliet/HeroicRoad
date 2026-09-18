Middle_Poison_Sting = class({})

LinkLuaModifier("modifier_Middle_Poison_Sting_passive", "skills/Middle_Poison_Sting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Poison_Sting", "skills/Middle_Poison_Sting", LUA_MODIFIER_MOTION_NONE)

function Middle_Poison_Sting:GetIntrinsicModifierName() return "modifier_Middle_Poison_Sting_passive" end
function Middle_Poison_Sting:IsHiddenWhenStolen() return true end
function Middle_Poison_Sting:GetAssociatedPrimaryAbilities() return "imba_venomancer_plague_ward" end

function Middle_Poison_Sting:OnTalentSummon(unit)
	unit:AddNewModifier(self:GetCaster(), self, "modifier_Middle_Poison_Sting_passive", {})

end

modifier_Middle_Poison_Sting_passive = class({})

function modifier_Middle_Poison_Sting_passive:IsDebuff()			return false end
function modifier_Middle_Poison_Sting_passive:IsHidden() 			return true end
function modifier_Middle_Poison_Sting_passive:IsPurgable() 		return false end
function modifier_Middle_Poison_Sting_passive:IsPurgeException() 	return false end
function modifier_Middle_Poison_Sting_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_Middle_Poison_Sting_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self:GetParent():PassivesDisabled() or keys.attacker ~= self:GetParent() or keys.target:IsOther() or keys.target:IsBuilding() or keys.target:IsCourier() or self:GetAbility():IsStolen() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local stacks = keys.target:HasModifier("modifier_Middle_Poison_Sting") and ability:GetSpecialValueFor("caster_stacks") or ability:GetSpecialValueFor("initial_stacks")
	local buff = keys.target:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Poison_Sting", {})
	if not buff or buff:IsNull() then
		return
	end
	if buff:GetStackCount()>=100 then
		return
	end
	buff:SetStackCount(buff:GetStackCount() + stacks)
end

modifier_Middle_Poison_Sting = class({})

function modifier_Middle_Poison_Sting:IsDebuff()			return true end
function modifier_Middle_Poison_Sting:IsHidden() 			return false end
function modifier_Middle_Poison_Sting:IsPurgable() 		return true end
function modifier_Middle_Poison_Sting:IsPurgeException() 	return true end
function modifier_Middle_Poison_Sting:IsPoisonDeBuff() return true end
-- function modifier_Middle_Poison_Sting:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
-- function modifier_Middle_Poison_Sting:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetStackCount() * self:GetAbility():GetSpecialValueFor("slow_per_stack")) end

function modifier_Middle_Poison_Sting:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_Middle_Poison_Sting:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local dmg = self:GetStackCount() * (ability:GetSpecialValueFor("dmg_per_stack")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false))
	-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), dmg, nil)
	-- ApplyDamage({
	-- 	victim = self:GetParent(), 
	-- 	attacker = self:GetCaster(), 
	-- 	damage = dmg, 
	-- 	damage_type = ability:GetAbilityDamageType(), 
	-- 	damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, 
	-- 	ability = ability
	-- })

	self:GetParent():Poison(self:GetCaster(), self:GetAbility(), dmg)

	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end
