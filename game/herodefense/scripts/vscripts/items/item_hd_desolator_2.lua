item_hd_desolator_2 = class({})
-- LinkLuaModifier("modifier_item_hd_desolator_2_arua", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_desolator_2_arua_effect", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_desolator_2", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_desolator_2_active", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_desolator_2_effect", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_desolator_2_effect2", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_desolator_2_active_standby", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_desolator_2_debuff", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_desolator_2_thinker", "items/item_hd_desolator_2", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_desolator_2:GetIntrinsicModifierName()
	return "modifier_item_hd_desolator_2"
end




modifier_item_hd_desolator_2 = class({})

function modifier_item_hd_desolator_2:IsDebuff() return false end
function modifier_item_hd_desolator_2:IsHidden() return true end
function modifier_item_hd_desolator_2:IsPurgable() return false end
-- function modifier_item_hd_desolator_2:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_desolator_2:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_item_hd_desolator_2:IsAura() return true end
-- function modifier_item_hd_desolator_2:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_desolator_2:GetModifierAura() return "modifier_item_hd_desolator_2_active" end
-- function modifier_item_hd_desolator_2:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_desolator_2:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_desolator_2:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_item_hd_desolator_2:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_item_hd_desolator_2:CheckState()
-- 	local state = {}
	
-- 	if self.pierce_proc then   --几率穿刺（无视闪避）
-- 		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
-- 	end

-- 	return state
-- end


function modifier_item_hd_desolator_2:OnCreated(keys)
    self.ability = self:GetAbility()

 
  
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	
end


function modifier_item_hd_desolator_2:DeclareFunctions()
	return {
		
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end


function modifier_item_hd_desolator_2:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_desolator_2:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent()then
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_desolator_2_active", {duration = 7})
		end
	end
end



modifier_item_hd_desolator_2_active = advanced_modifier({})

function modifier_item_hd_desolator_2_active:IsDebuff() return true end
function modifier_item_hd_desolator_2_active:IsHidden() return false end
function modifier_item_hd_desolator_2_active:IsPurgable() return true end
function modifier_item_hd_desolator_2_active:GetTexture()return "item_desolator_2" end
function modifier_item_hd_desolator_2_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end


function modifier_item_hd_desolator_2_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_desolator_2_active:Advanced_GetModifierPhysicalArmorBonus()
    return -13
end