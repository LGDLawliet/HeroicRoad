item_hd_phase_boots_2 = class({})
-- LinkLuaModifier("modifier_item_hd_phase_boots_2_arua", "items/item_hd_phase_boots_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_phase_boots_2_arua_effect", "items/item_hd_phase_boots_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phase_boots_2", "items/item_hd_phase_boots_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phase_boots_2_active", "items/item_hd_phase_boots_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phase_boots_2_void", "items/item_hd_phase_boots_2", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_phase_boots_2:GetIntrinsicModifierName()
	return "modifier_item_hd_phase_boots_2"
end






-- modifier_item_hd_phase_boots_2_arua = class({})

-- function modifier_item_hd_phase_boots_2_arua:IsHidden() return true end
-- function modifier_item_hd_phase_boots_2_arua:IsAura() return true end
-- function modifier_item_hd_phase_boots_2_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_phase_boots_2_arua:GetModifierAura() return "modifier_item_hd_phase_boots_2_arua_effect" end
-- function modifier_item_hd_phase_boots_2_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_phase_boots_2_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_phase_boots_2_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_phase_boots_2_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_phase_boots_2 = advanced_modifier({})

function modifier_item_hd_phase_boots_2:IsDebuff() return false end
function modifier_item_hd_phase_boots_2:IsHidden() return false end
function modifier_item_hd_phase_boots_2:IsPurgeException() return false end
function modifier_item_hd_phase_boots_2:IsPurgable() return false end
function modifier_item_hd_phase_boots_2:RemoveOnDeath() return false end
function modifier_item_hd_phase_boots_2:DestroyOnExpire() return false end
function modifier_item_hd_phase_boots_2:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_phase_boots_2:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_phase_boots_2:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

    if IsServer() then
		self:StartIntervalThink(0.1)
	end

end
function modifier_item_hd_phase_boots_2:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() then
		local ModifierStatusGain = self:GetParent():GetModifierDurationGainIndex(1)
		self.modifier =self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_phase_boots_2_active", {duration= 3*ModifierStatusGain})
		self:GetAbility():UseResources(true, true, true,true)
	end
end



function modifier_item_hd_phase_boots_2:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,           --伤害阻挡

	}
end


function modifier_item_hd_phase_boots_2:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_hd_phase_boots_2:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_phase_boots_2:GetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	if keys.damage >=  300 and self:GetRemainingTime()<=0 then
		self:SetDuration(15, true)
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_phase_boots_2_void", {duration = 1})
	end
	return 0
end

function modifier_item_hd_phase_boots_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_phase_boots_2:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_phase_boots_2_active = class({})

function modifier_item_hd_phase_boots_2_active:IsDebuff() return false end
function modifier_item_hd_phase_boots_2_active:IsHidden() return false end
function modifier_item_hd_phase_boots_2_active:IsPurgable() return true end
function modifier_item_hd_phase_boots_2_active:GetTexture()return "item_phase_boots" end
function modifier_item_hd_phase_boots_2_active:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_phase_boots_2_active:GetEffectName() 	  return "particles/econ/events/ti9/phase_boots_ti9.vpcf" end
function modifier_item_hd_phase_boots_2_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
	}
end
function modifier_item_hd_phase_boots_2_active:GetModifierMoveSpeedBonus_Percentage()return self:GetParent():IsRangedAttacker()and 10 or 20 end
function modifier_item_hd_phase_boots_2_active:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true} end



modifier_item_hd_phase_boots_2_void = advanced_modifier({})

function modifier_item_hd_phase_boots_2_void:IsDebuff() return false end
function modifier_item_hd_phase_boots_2_void:IsHidden() return false end
function modifier_item_hd_phase_boots_2_void:IsPurgable() return false end
function modifier_item_hd_phase_boots_2_void:IsPurgeException() return false end
function modifier_item_hd_phase_boots_2_void:GetTexture()return "item_phase_boots2" end
function modifier_item_hd_phase_boots_2_void:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return 0 
	end
	local parent = self:GetParent()
	if keys.damage >=  parent:GetHealth()*0.5 then
		self:Destroy()
		return 0
	end
	return -100
end

function modifier_item_hd_phase_boots_2_void:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
