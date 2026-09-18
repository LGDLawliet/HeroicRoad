item_hd_jack_the_rippers_claw = class({})
-- 开膛手杰克之爪
LinkLuaModifier("modifier_item_hd_jack_the_rippers_claw", "items/item_hd_jack_the_rippers_claw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_jack_the_rippers_claw_active", "items/item_hd_jack_the_rippers_claw", LUA_MODIFIER_MOTION_NONE)

function item_hd_jack_the_rippers_claw:GetIntrinsicModifierName()
	return "modifier_item_hd_jack_the_rippers_claw"
end





modifier_item_hd_jack_the_rippers_claw = advanced_modifier({})

function modifier_item_hd_jack_the_rippers_claw:IsDebuff() return false end
function modifier_item_hd_jack_the_rippers_claw:IsHidden() return true end
function modifier_item_hd_jack_the_rippers_claw:IsPurgable() return false end


function modifier_item_hd_jack_the_rippers_claw:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.line = self.ability:GetSpecialValueFor("line")
end

function modifier_item_hd_jack_the_rippers_claw:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage, --攻击伤害吸血
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
    }
end

function modifier_item_hd_jack_the_rippers_claw:Advanced_GetModifier_LifeSteal_AttackDamage(keys)
	return self.bonus_life_steal
end

function modifier_item_hd_jack_the_rippers_claw:OnTakeDamage(keys)
	if IsServer() then
		if self:GetParent():GetHealthPercent() <= self.line and self:GetAbility():IsCooldownReady() then
			keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_jack_the_rippers_claw_active", {duration = self.duration})
			self:GetAbility():UseResources(true, true, true, true)
		end	
	end
end

------

modifier_item_hd_jack_the_rippers_claw_active = advanced_modifier({})

function modifier_item_hd_jack_the_rippers_claw_active:IsDebuff() return false end
function modifier_item_hd_jack_the_rippers_claw_active:IsHidden() return true end
function modifier_item_hd_jack_the_rippers_claw_active:IsPurgable() return false end


function modifier_item_hd_jack_the_rippers_claw_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")
end
function modifier_item_hd_jack_the_rippers_claw_active:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.active = self.ability:GetSpecialValueFor("active")
end
function modifier_item_hd_jack_the_rippers_claw_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage, --攻击伤害吸血
    }
end
function modifier_item_hd_jack_the_rippers_claw_active:Advanced_GetModifier_LifeSteal_AttackDamage(keys)
	return self.active
end