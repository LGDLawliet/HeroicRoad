item_hd_power_treads_2 = class({})
-- LinkLuaModifier("modifier_item_hd_power_treads_2_arua", "items/item_hd_power_treads_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_power_treads_2_arua_effect", "items/item_hd_power_treads_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_2", "items/item_hd_power_treads_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_2_agi", "items/item_hd_power_treads_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_2_str", "items/item_hd_power_treads_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_power_treads_2_int", "items/item_hd_power_treads_2", LUA_MODIFIER_MOTION_NONE)


function item_hd_power_treads_2:GetIntrinsicModifierName()
	return "modifier_item_hd_power_treads_2"
end



modifier_item_hd_power_treads_2 = class({})

function modifier_item_hd_power_treads_2:IsDebuff() return false end
function modifier_item_hd_power_treads_2:IsHidden() return true end
function modifier_item_hd_power_treads_2:IsPurgable() return false end

function modifier_item_hd_power_treads_2:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
    if IsServer() then
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_power_treads_2_agi", {})
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_power_treads_2_str", {})
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_power_treads_2_int", {})
		self:StartIntervalThink(0.1)


	end

end

function modifier_item_hd_power_treads_2:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local modifiers1 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_2_str")
		local modifiers2 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_2_agi")
		local modifiers3 = caster:FindAllModifiersByName("modifier_item_hd_power_treads_2_int")
		if #modifiers1>0 then	modifiers1[1]:SafeDestroy()	end
		if #modifiers2>0 then	modifiers2[1]:SafeDestroy()	end
		if #modifiers3>0 then	modifiers3[1]:SafeDestroy()	end
	end
end


function modifier_item_hd_power_treads_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度

	}
end


function modifier_item_hd_power_treads_2:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end
function modifier_item_hd_power_treads_2:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end


modifier_item_hd_power_treads_2_str = class({})

function modifier_item_hd_power_treads_2_str:IsDebuff() return false end
function modifier_item_hd_power_treads_2_str:IsHidden() return false end
function modifier_item_hd_power_treads_2_str:IsPurgable() return true end
function modifier_item_hd_power_treads_2_str:GetTexture()return "item_power_treads_str_2" end
function modifier_item_hd_power_treads_2_str:RemoveOnDeath() return false end
function modifier_item_hd_power_treads_2_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
	}
end
function modifier_item_hd_power_treads_2_str:GetModifierBonusStats_Strength()	return 15 end
function modifier_item_hd_power_treads_2_str:GetModifierMagicalResistanceBonus() return 15 end

modifier_item_hd_power_treads_2_agi = class({})

function modifier_item_hd_power_treads_2_agi:IsDebuff() return false end
function modifier_item_hd_power_treads_2_agi:IsHidden() return false end
function modifier_item_hd_power_treads_2_agi:IsPurgable() return true end
function modifier_item_hd_power_treads_2_agi:GetTexture()return "item_power_treads_agi_2" end
function modifier_item_hd_power_treads_2_agi:RemoveOnDeath() return false end
function modifier_item_hd_power_treads_2_agi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
	}
end
function modifier_item_hd_power_treads_2_agi:GetModifierBonusStats_Agility()	return 15 end
function modifier_item_hd_power_treads_2_agi:GetModifierAttackSpeedBonus_Constant() return 30 end


modifier_item_hd_power_treads_2_int = advanced_modifier({})

function modifier_item_hd_power_treads_2_int:IsDebuff() return false end
function modifier_item_hd_power_treads_2_int:IsHidden() return false end
function modifier_item_hd_power_treads_2_int:IsPurgable() return true end
function modifier_item_hd_power_treads_2_int:GetTexture()return "item_power_treads_int_2" end
function modifier_item_hd_power_treads_2_int:RemoveOnDeath() return false end
function modifier_item_hd_power_treads_2_int:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
	}
end
function modifier_item_hd_power_treads_2_int:GetModifierBonusStats_Intellect()	return 15 end
function modifier_item_hd_power_treads_2_int:Advanced_GetModifierSpellAmplifyBonus() return 12 end


function modifier_item_hd_power_treads_2_int:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
