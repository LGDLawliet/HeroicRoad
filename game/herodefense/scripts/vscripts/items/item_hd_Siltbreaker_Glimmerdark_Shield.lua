item_hd_Siltbreaker_Glimmerdark_Shield = class({})
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_arua", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_arua_effect", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect2", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active_standby", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_debuff", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Glimmerdark_Shield_thinker", "items/item_hd_Siltbreaker_Glimmerdark_Shield", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_Siltbreaker_Glimmerdark_Shield:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Glimmerdark_Shield"
end




function item_hd_Siltbreaker_Glimmerdark_Shield:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("DOTA_Item.IronTalon.Activate")
	caster:AddNewModifier(caster, self, "modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active", {duration = 10})
	caster:AddNewModifier(caster, self, "modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect", {duration = 10})
	self:StartCooldown(40)

end

modifier_item_hd_Siltbreaker_Glimmerdark_Shield = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:IsPurgable() return false end



function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:OnCreated(keys)
    self.ability = self:GetAbility()

 
  

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	
end



function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end


function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:IsHidden() return false end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:GetTexture()return "item_Siltbreaker_Glimmerdark_Shield" end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:GetEffectName() return "particles/econ/events/spring_2021/mjollnir_shield_spring_2021_rays.vpcf" end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
			-- print("physical")
			return	-100
		end
		if keys.damage_type==DAMAGE_TYPE_MAGICAL then
			-- print("magical")
			return	100
		end
		return 0
	end


end


function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect = class({})

function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Glimmerdark_Shield_effect:GetStatusEffectName() return "particles/new_effect/status/status_effect_glimmerdark_shield.vpcf" end
