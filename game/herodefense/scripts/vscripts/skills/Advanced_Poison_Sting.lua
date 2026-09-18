--特效优化 √
Advanced_Poison_Sting = class({})

LinkLuaModifier("modifier_Advanced_Poison_Sting_passive", "skills/Advanced_Poison_Sting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Poison_Sting", "skills/Advanced_Poison_Sting", LUA_MODIFIER_MOTION_NONE)

function Advanced_Poison_Sting:GetIntrinsicModifierName() return "modifier_Advanced_Poison_Sting_passive" end
function Advanced_Poison_Sting:IsHiddenWhenStolen() return true end
function Advanced_Poison_Sting:GetAssociatedPrimaryAbilities() return "imba_venomancer_plague_ward" end
function Advanced_Poison_Sting:CheckKV(key)
	local table = {

	


		dmg_per_stack = 0.2,
		bonus_damage = 0.002,

	}
	local value = table[key] or -1
	return value

end


function Advanced_Poison_Sting:UnlockFirstCore(key)
	return true
end
function Advanced_Poison_Sting:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end
function Advanced_Poison_Sting:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end

function Advanced_Poison_Sting:OnTalentSummon(unit)
	unit:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Poison_Sting_passive", {})

end


modifier_Advanced_Poison_Sting_passive = class({})

function modifier_Advanced_Poison_Sting_passive:IsDebuff()			return false end
function modifier_Advanced_Poison_Sting_passive:IsHidden() 			return true end
function modifier_Advanced_Poison_Sting_passive:IsPurgable() 		return false end
function modifier_Advanced_Poison_Sting_passive:IsPurgeException() 	return false end
function modifier_Advanced_Poison_Sting_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_Advanced_Poison_Sting_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end

	if self:GetParent():PassivesDisabled() or keys.attacker ~= self:GetParent() or keys.target:IsOther() or keys.target:IsBuilding() or keys.target:IsCourier() or self:GetAbility():IsStolen() then
		return
	end
	local level = ability.advanced_level
	--LV5解锁聚合+
	local caster_stacks = self:GetAbility():GetSpecialValueFor("caster_stacks")
	if level>=5 then
		caster_stacks = 3
	end
	local stacks = keys.target:HasModifier("modifier_Advanced_Poison_Sting") and caster_stacks or ability:GetSpecialValueFor("initial_stacks")
	local buff = keys.target:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Poison_Sting", {})
	if not buff or buff:IsNull() then
		return
	end
	if buff:GetStackCount()>=100 then
		return
	end
	buff:SetStackCount(buff:GetStackCount() + stacks)
end

modifier_Advanced_Poison_Sting = class({})

function modifier_Advanced_Poison_Sting:IsDebuff()			return true end
function modifier_Advanced_Poison_Sting:IsHidden() 			return false end
function modifier_Advanced_Poison_Sting:IsPurgable() 		return false end
function modifier_Advanced_Poison_Sting:IsPurgeException() 	return false end
function modifier_Advanced_Poison_Sting:IsPoisonDeBuff() return true end
function modifier_Advanced_Poison_Sting:DeclareFunctions() return {
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
} end
function modifier_Advanced_Poison_Sting:GetModifierMagicalResistanceBonus() return (self:GetStackCount()*self.MagicalResistance) end

function modifier_Advanced_Poison_Sting:OnCreated()
	self.MagicalResistance = 0
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	--LV10解锁强性
	if self.advanced_level>=10 then
		self.MagicalResistance = -0.3
	end


	if IsServer() then
		self.bonus_damage = 1  --成长
		
		self:StartIntervalThink(1.0)
	end
end

function modifier_Advanced_Poison_Sting:OnIntervalThink()
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local level = self.advanced_level
	local caster = self:GetCaster()
	local stack =  self:GetStackCount()
	local dmg = stack * (ability:GetSpecialValueFor("dmg_per_stack")+(ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false))
	--LV15解锁融合
	if level>=15 then
		local max_damage = caster:GetIntellect(false)*15
		dmg =dmg +math.min(self:GetParent():GetDamageMax()*0.3,max_damage)
	end
	dmg = dmg *self.bonus_damage
	if ability.unlock2 then
		dmg = dmg + caster:GetMaxMana()*0.003*stack
	elseif ability.unlock3 then
		dmg = dmg + caster:GetMaxHealth()*0.002*stack
	end
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
	--LV20解锁成长
	if level>=20 then
		self.bonus_damage = math.min(self.bonus_damage +0.005,1.5)
	end
end
