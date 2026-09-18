item_hd_nian_flag_trap = class({})
LinkLuaModifier("modifier_item_hd_nian_flag_trap_arua", "items/item_hd_nian_flag_trap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_nian_flag_trap", "items/item_hd_nian_flag_trap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_nian_flag_trap_disarm", "items/item_hd_nian_flag_trap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_nian_flag_trap_active_lifesteal", "items/item_hd_nian_flag_trap", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_nian_flag_trap:GetIntrinsicModifierName()
	return "modifier_item_hd_nian_flag_trap_arua"
end



modifier_item_hd_nian_flag_trap_arua = class({})

function modifier_item_hd_nian_flag_trap_arua:IsHidden() return true end
function modifier_item_hd_nian_flag_trap_arua:IsAura() return true end
function modifier_item_hd_nian_flag_trap_arua:GetAuraDuration() return 0.5 end
function modifier_item_hd_nian_flag_trap_arua:GetModifierAura() return "modifier_item_hd_nian_flag_trap" end
function modifier_item_hd_nian_flag_trap_arua:GetAuraRadius() return self.radius end
function modifier_item_hd_nian_flag_trap_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_nian_flag_trap_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_nian_flag_trap_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_hd_nian_flag_trap_arua:OnCreated(keys)
    self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end



modifier_item_hd_nian_flag_trap = advanced_modifier({})

function modifier_item_hd_nian_flag_trap:IsDebuff() return false end
function modifier_item_hd_nian_flag_trap:IsHidden() return false end
function modifier_item_hd_nian_flag_trap:IsPurgable() return false end
-- function modifier_item_hd_nian_flag_trap:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_nian_flag_trap:GetTexture()return "item_nian_flag_trap" end


function modifier_item_hd_nian_flag_trap:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self:StartIntervalThink(1)
end

function modifier_item_hd_nian_flag_trap:OnIntervalThink(keys)
	if not IsValid(self.ability) then
		return
	end
    if self:GetCaster():FindAbilityByName("Primary_Inner_Beast") or self:GetCaster():FindAbilityByName("Middle_Inner_Beast") or self:GetCaster():FindAbilityByName("Advanced_Inner_Beast") then
		self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed_override")
		self.bonus_move = self.ability:GetSpecialValueFor("bonus_move_override")
    else
		self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
    end
end

function modifier_item_hd_nian_flag_trap:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
	}
end


function modifier_item_hd_nian_flag_trap:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_item_hd_nian_flag_trap:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move
end
