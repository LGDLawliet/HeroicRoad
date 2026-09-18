item_hd_circlet_of_dark_and_light = class({})

LinkLuaModifier("modifier_item_hd_circlet_of_dark_and_light", "items/item_hd_circlet_of_dark_and_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_circlet_of_dark_and_light_light", "items/item_hd_circlet_of_dark_and_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_circlet_of_dark_and_light_dark", "items/item_hd_circlet_of_dark_and_light", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_circlet_of_dark_and_light:GetIntrinsicModifierName()
	return "modifier_item_hd_circlet_of_dark_and_light"
end


function item_hd_circlet_of_dark_and_light:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", context )

end


function item_hd_circlet_of_dark_and_light:OnSpellStart()
	local caster = self:GetCaster()
	-- caster:EmitSound("Hero_Nightstalker.CripplingFear.Aura.TI10")
	if caster:HasModifier("modifier_item_hd_circlet_of_dark_and_light_light") then
		self:GetParent():RemoveModifierByName("modifier_item_hd_circlet_of_dark_and_light_light")
		caster:AddNewModifier(caster, self, "modifier_item_hd_circlet_of_dark_and_light_dark", {})
	else
		self:GetParent():RemoveModifierByName("modifier_item_hd_circlet_of_dark_and_light_dark")
		caster:AddNewModifier(caster, self, "modifier_item_hd_circlet_of_dark_and_light_light", {})
	end
end




modifier_item_hd_circlet_of_dark_and_light =modifier_item_hd_circlet_of_dark_and_light or class({})

function modifier_item_hd_circlet_of_dark_and_light:IsDebuff() return false end
function modifier_item_hd_circlet_of_dark_and_light:IsHidden() return true end
function modifier_item_hd_circlet_of_dark_and_light:IsPurgable() return false end
function modifier_item_hd_circlet_of_dark_and_light:IsPurgeException() return false end
function modifier_item_hd_circlet_of_dark_and_light:RemoveOnDeath() return false end
function modifier_item_hd_circlet_of_dark_and_light:DestroyOnExpire() return false end
function modifier_item_hd_circlet_of_dark_and_light:OnCreated(keys)

	self.bonus_damage =  self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed =  self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

	if IsServer() then
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_item_hd_circlet_of_dark_and_light_light", {})

	end
end

function modifier_item_hd_circlet_of_dark_and_light:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_item_hd_circlet_of_dark_and_light:GetModifierPreAttack_BonusDamage()return self.bonus_damage end
function modifier_item_hd_circlet_of_dark_and_light:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
function modifier_item_hd_circlet_of_dark_and_light:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_hd_circlet_of_dark_and_light_light")
		self:GetParent():RemoveModifierByName("modifier_item_hd_circlet_of_dark_and_light_dark")
	end
end



modifier_item_hd_circlet_of_dark_and_light_light = advanced_modifier({})

function modifier_item_hd_circlet_of_dark_and_light_light:IsHidden() return false end
function modifier_item_hd_circlet_of_dark_and_light_light:IsPurgable() return false end
function modifier_item_hd_circlet_of_dark_and_light_light:IsPurgeException() return false end
function modifier_item_hd_circlet_of_dark_and_light_light:RemoveOnDeath() return false end
function modifier_item_hd_circlet_of_dark_and_light_light:GetTexture() return "item_circlet_of_light" end
function modifier_item_hd_circlet_of_dark_and_light_light:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf" end

function modifier_item_hd_circlet_of_dark_and_light_light:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		
		

	}
end
function modifier_item_hd_circlet_of_dark_and_light_light:OnTooltip()
	return self:Advanced_GetModifierAttackSpeedPercentage()
end

-- adva
function modifier_item_hd_circlet_of_dark_and_light_light:Advanced_GetModifierAttackSpeedPercentage()
	return 20
end


function modifier_item_hd_circlet_of_dark_and_light_light:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end



modifier_item_hd_circlet_of_dark_and_light_dark = class({})

function modifier_item_hd_circlet_of_dark_and_light_dark:IsHidden() return false end
function modifier_item_hd_circlet_of_dark_and_light_dark:IsPurgable() return false end
function modifier_item_hd_circlet_of_dark_and_light_dark:IsPurgeException() return false end
function modifier_item_hd_circlet_of_dark_and_light_dark:RemoveOnDeath() return false end
function modifier_item_hd_circlet_of_dark_and_light_dark:GetTexture() return "item_circlet_of_dark" end
function modifier_item_hd_circlet_of_dark_and_light_dark:GetEffectName() return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf" end
function modifier_item_hd_circlet_of_dark_and_light_dark:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_item_hd_circlet_of_dark_and_light_dark:GetModifierBaseDamageOutgoing_Percentage() 
    return 35
end