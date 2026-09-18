
Primary_bulldoze = Primary_bulldoze or class({})
LinkLuaModifier( "modifier_Primary_bulldoze", "skills/Primary_bulldoze", LUA_MODIFIER_MOTION_NONE )

function Primary_bulldoze:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", context )


end
function Primary_bulldoze:GetIntrinsicModifierName()
	return "modifier_Primary_bulldoze"
end

modifier_Primary_bulldoze = modifier_Primary_bulldoze or advanced_modifier({})
function modifier_Primary_bulldoze:IsHidden()	return true end
function modifier_Primary_bulldoze:IsDebuff()	return false end
function modifier_Primary_bulldoze:IsPurgable()	return false end
function modifier_Primary_bulldoze:IsPurgeException() return false end
function modifier_Primary_bulldoze:RemoveOnDeath() return false end
function modifier_Primary_bulldoze:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
	if not IsServer() then return end

end

function modifier_Primary_bulldoze:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Primary_bulldoze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

function modifier_Primary_bulldoze:GetModifierMoveSpeedBonus_Percentage()
	return self:GetParent():PassivesDisabled() and 0 or self.movespeed
end

function modifier_Primary_bulldoze:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Primary_bulldoze:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

