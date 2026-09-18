item_hd_silver_strike_blade = class({})
-- LinkLuaModifier("modifier_item_hd_silver_strike_blade_arua", "items/item_hd_silver_strike_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_silver_strike_blade_arua_effect", "items/item_hd_silver_strike_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_silver_strike_blade", "items/item_hd_silver_strike_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_silver_strike_blade_active", "items/item_hd_silver_strike_blade", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_silver_strike_blade:GetIntrinsicModifierName()
	return "modifier_item_hd_silver_strike_blade"
end






modifier_item_hd_silver_strike_blade = class({})

function modifier_item_hd_silver_strike_blade:IsDebuff() return false end
function modifier_item_hd_silver_strike_blade:IsHidden() return true end
function modifier_item_hd_silver_strike_blade:IsPurgable() return false end



function modifier_item_hd_silver_strike_blade:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	
end



function modifier_item_hd_silver_strike_blade:DeclareFunctions()
	return {
		
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end



function modifier_item_hd_silver_strike_blade:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_silver_strike_blade:GetModifierPreAttack_BonusDamage() return self.bonus_damage end



function modifier_item_hd_silver_strike_blade:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	local caster = self:GetCaster()

	if not caster:HasModifier("modifier_item_hd_silver_strike_blade_active") and  self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100)then
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_silver_strike_blade_active", {duration = 5})
	end
	



end



if modifier_item_hd_silver_strike_blade_active == nil then
	modifier_item_hd_silver_strike_blade_active = class({})
end
function modifier_item_hd_silver_strike_blade_active:IsHidden()return true end
function modifier_item_hd_silver_strike_blade_active:IsDebuff()return false end
function modifier_item_hd_silver_strike_blade_active:IsPurgable()return false end
function modifier_item_hd_silver_strike_blade_active:IsPurgeException()return false end
function modifier_item_hd_silver_strike_blade_active:AllowIllusionDuplicate()return false end
function modifier_item_hd_silver_strike_blade_active:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_EVENT_ON_ATTACK_LANDED,
				MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
	}
end
function modifier_item_hd_silver_strike_blade_active:OnCreated(table)
	if IsServer() then
		self.bonus_damage = self:GetParent():GetAverageTrueAttackDamage(nil)*0.3
	end
end

function modifier_item_hd_silver_strike_blade_active:GetModifierPreAttack_BonusDamagePostCrit(params) 
	return self.bonus_damage
end

function modifier_item_hd_silver_strike_blade_active:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent()  then
		return
	end
	if self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100) then
		return
	end

	self:SafeDestroy()
end