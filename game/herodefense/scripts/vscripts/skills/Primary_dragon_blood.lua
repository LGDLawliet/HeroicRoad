Primary_dragon_blood = class({})
-- LinkLuaModifier("modifier_Primary_dragon_blood_arua", "items/Primary_dragon_blood", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_dragon_blood_arua_effect", "items/Primary_dragon_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_dragon_blood", "skills/Primary_dragon_blood", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function Primary_dragon_blood:GetIntrinsicModifierName()
	return "modifier_Primary_dragon_blood"
end




modifier_Primary_dragon_blood = advanced_modifier({})

function modifier_Primary_dragon_blood:IsDebuff() return false end
function modifier_Primary_dragon_blood:IsHidden() return true end
function modifier_Primary_dragon_blood:IsPurgable() return false end




function modifier_Primary_dragon_blood:AdvancedGetModifierConstantHealthRegen()	
	local bonus_health_regeneration = self:GetAbility():GetSpecialValueFor("bonus_health_regeneration") 
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_dragon_knight") then
		bonus_health_regeneration = bonus_health_regeneration *1.4 
	end

	return bonus_health_regeneration
end
function modifier_Primary_dragon_blood:Advanced_GetModifierPhysicalArmorBonus() 
	local bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor") 
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_dragon_knight") then
		bonus_armor = bonus_armor *1.4 
	end
	return bonus_armor
end

function modifier_Primary_dragon_blood:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end