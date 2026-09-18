item_hd_assault = class({})
-- LinkLuaModifier("modifier_item_hd_assault_arua", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_assault_arua_effect", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_assault", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_assault_active", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_assault_effect", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_assault_effect2", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_assault_active_standby", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_assault_debuff", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_assault_thinker", "items/item_hd_assault", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_assault:GetIntrinsicModifierName()
	return "modifier_item_hd_assault"
end





modifier_item_hd_assault = advanced_modifier({})

function modifier_item_hd_assault:IsDebuff() return false end
function modifier_item_hd_assault:IsHidden() return true end
function modifier_item_hd_assault:IsPurgable() 		return false end
function modifier_item_hd_assault:IsPurgeException() 	return false end
function modifier_item_hd_assault:RemoveOnDeath()  return false end
-- function modifier_item_hd_assault:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_assault:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_assault:IsAura() return true end
function modifier_item_hd_assault:GetAuraDuration() return 0.5 end
function modifier_item_hd_assault:GetModifierAura() return "modifier_item_hd_assault_active" end
function modifier_item_hd_assault:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_assault:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_assault:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_item_hd_assault:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_assault:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end



function modifier_item_hd_assault:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end


function modifier_item_hd_assault:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_assault:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_assault:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



modifier_item_hd_assault_active = advanced_modifier({})

function modifier_item_hd_assault_active:IsDebuff() return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber() and true or false end
function modifier_item_hd_assault_active:IsHidden() return false end
function modifier_item_hd_assault_active:IsPurgable() return false end
function modifier_item_hd_assault_active:GetTexture()return "item_assault" end

function modifier_item_hd_assault_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度

	}
end


function modifier_item_hd_assault_active:GetModifierAttackSpeedBonus_Constant() 	return self:GetCaster():GetTeamNumber()==self:GetParent():GetTeamNumber() and 35 or 0 end



function modifier_item_hd_assault_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_assault_active:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetCaster():GetTeamNumber()==self:GetParent():GetTeamNumber() and 7 or -7 
end