item_hd_monkey_king_bar = class({})
-- LinkLuaModifier("modifier_item_hd_monkey_king_bar_arua", "items/item_hd_monkey_king_bar", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_monkey_king_bar_arua_effect", "items/item_hd_monkey_king_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_monkey_king_bar", "items/item_hd_monkey_king_bar", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_monkey_king_bar:GetIntrinsicModifierName()
	return "modifier_item_hd_monkey_king_bar"
end






modifier_item_hd_monkey_king_bar = advanced_modifier({})

function modifier_item_hd_monkey_king_bar:IsDebuff() return false end
function modifier_item_hd_monkey_king_bar:IsHidden() return true end
function modifier_item_hd_monkey_king_bar:IsPurgable() return false end

function modifier_item_hd_monkey_king_bar:CheckState()
	local state = {}
	
	-- if self.pierce_proc then   --几率穿刺（无视闪避）
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	-- end

	return state
end


function modifier_item_hd_monkey_king_bar:OnCreated(keys)
    self.ability = self:GetAbility()
	self.pierce_records = {}

 

	
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	
end



function modifier_item_hd_monkey_king_bar:DeclareFunctions()
	return {
		
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力


		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
	
		MODIFIER_EVENT_ON_ATTACK_RECORD,                    --攻击降临
	
		

	}
end


function modifier_item_hd_monkey_king_bar:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
function modifier_item_hd_monkey_king_bar:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_monkey_king_bar:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and 0 or self.bonus_attack_range end


function modifier_item_hd_monkey_king_bar:GetModifierPreAttack_BonusDamagePostCrit(keys) 
	if not self:GetParent():IsIllusion() then
		self:GetParent():EmitSound("DOTA_Item.MKB.proc")
		return self:GetCaster():GetBaseDamageMax()*0.5
	end
	return 0
end



function modifier_item_hd_monkey_king_bar:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end