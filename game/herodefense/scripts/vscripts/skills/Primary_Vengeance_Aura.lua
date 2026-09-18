Primary_Vengeance_Aura = class({})
LinkLuaModifier( "modifier_Primary_Vengeance_Aura", "skills/Primary_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Vengeance_Aura_effect", "skills/Primary_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function Primary_Vengeance_Aura:GetIntrinsicModifierName()
	return "modifier_Primary_Vengeance_Aura"
end


modifier_Primary_Vengeance_Aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Vengeance_Aura:IsHidden()	return true end
function modifier_Primary_Vengeance_Aura:IsDebuff()	return false end
function modifier_Primary_Vengeance_Aura:IsPurgable() 		return false end
function modifier_Primary_Vengeance_Aura:IsPurgeException() 	return false end
function modifier_Primary_Vengeance_Aura:RemoveOnDeath()  return false end
function modifier_Primary_Vengeance_Aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Vengeance_Aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Primary_Vengeance_Aura:GetModifierAura()	return "modifier_Primary_Vengeance_Aura_effect" end
function modifier_Primary_Vengeance_Aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Primary_Vengeance_Aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Primary_Vengeance_Aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_Vengeance_Aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_Primary_Vengeance_Aura_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Vengeance_Aura_effect:IsHidden()	return false end
function modifier_Primary_Vengeance_Aura_effect:IsDebuff()	return false end
function modifier_Primary_Vengeance_Aura_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Vengeance_Aura_effect:IsPurgable()	return false end
function modifier_Primary_Vengeance_Aura_effect:OnCreated( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )


end

function modifier_Primary_Vengeance_Aura_effect:OnRefresh( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Vengeance_Aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		-- MODIFIER_PROPERTY_BASE_MANA_REGEN,
	}

	return funcs
end
function modifier_Primary_Vengeance_Aura_effect:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage
end