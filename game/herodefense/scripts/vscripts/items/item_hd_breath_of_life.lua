item_hd_breath_of_life = class({})
-- LinkLuaModifier("modifier_item_hd_breath_of_life_arua", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_breath_of_life_arua_effect", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_breath_of_life", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_breath_of_life_active", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_breath_of_life_effect", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_breath_of_life_effect2", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_breath_of_life_active_standby", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_breath_of_life_debuff", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_breath_of_life_thinker", "items/item_hd_breath_of_life", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_breath_of_life:GetIntrinsicModifierName()
	return "modifier_item_hd_breath_of_life"
end






modifier_item_hd_breath_of_life = advanced_modifier({})

function modifier_item_hd_breath_of_life:IsDebuff() return false end
function modifier_item_hd_breath_of_life:IsHidden() return true end
function modifier_item_hd_breath_of_life:IsPurgable() return false end
function modifier_item_hd_breath_of_life:IsAura() return true end
function modifier_item_hd_breath_of_life:GetAuraDuration() return 0.5 end
function modifier_item_hd_breath_of_life:GetModifierAura() return "modifier_item_hd_breath_of_life_active" end
function modifier_item_hd_breath_of_life:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_breath_of_life:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_breath_of_life:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_item_hd_breath_of_life:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_breath_of_life:OnCreated(keys)
    self.ability = self:GetAbility()

	
	self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
end





function modifier_item_hd_breath_of_life:AdvancedGetModifierConstantHealthRegenAmpPercentage() 	return self.bonus_regeneration_amplification end
function modifier_item_hd_breath_of_life:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_breath_of_life:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE


    }
end



modifier_item_hd_breath_of_life_active = class({})

function modifier_item_hd_breath_of_life_active:IsDebuff() return false end
function modifier_item_hd_breath_of_life_active:IsHidden() return false end
function modifier_item_hd_breath_of_life_active:IsPurgable() return false end
function modifier_item_hd_breath_of_life_active:GetTexture()return "item_breath_of_life" end

function modifier_item_hd_breath_of_life_active:DeclareFunctions()
	return {
			MODIFIER_EVENT_ON_DEATH
	

	}
end

function modifier_item_hd_breath_of_life_active:OnDeath(keys)
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		if keys.unit ~=parent then
			return
		end
		if keys.unit == caster then
			return
		end
		local gain = caster:GetModifierDurationGainIndex(1)
		if parent:IsRealHero() then
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_breath_of_life_effect", {duration = 20*gain,index = 10})
		else
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_breath_of_life_effect", {duration = 20*gain,index = 1})
		end
	end
end





modifier_item_hd_breath_of_life_effect = advanced_modifier({})

function modifier_item_hd_breath_of_life_effect:IsDebuff() return false end
function modifier_item_hd_breath_of_life_effect:IsHidden() return true end
function modifier_item_hd_breath_of_life_effect:IsPurgable() return false end
function modifier_item_hd_breath_of_life_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_breath_of_life_effect:OnCreated(table)
	if IsServer() then
		self:SetStackCount(table.index)
	end
end
function modifier_item_hd_breath_of_life_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,


    }
end

function modifier_item_hd_breath_of_life_effect:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount()*5 end