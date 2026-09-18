
Middle_bulldoze = Middle_bulldoze or class({})
LinkLuaModifier( "modifier_Middle_bulldoze", "skills/Middle_bulldoze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_bulldoze_active", "skills/Middle_bulldoze", LUA_MODIFIER_MOTION_NONE )

function Middle_bulldoze:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", context )


end
function Middle_bulldoze:GetIntrinsicModifierName()
	return "modifier_Middle_bulldoze"
end

function Middle_bulldoze:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = 7

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_bulldoze_active", -- modifier name
		{ duration = duration *caster:GetModifierDurationGainIndex(1)} -- kv
	)
end

modifier_Middle_bulldoze = modifier_Middle_bulldoze or advanced_modifier({})
function modifier_Middle_bulldoze:IsHidden()	return true end
function modifier_Middle_bulldoze:IsDebuff()	return false end
function modifier_Middle_bulldoze:IsPurgable()	return false end
function modifier_Middle_bulldoze:IsPurgeException() return false end
function modifier_Middle_bulldoze:RemoveOnDeath() return false end
function modifier_Middle_bulldoze:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.modifier_Middle_bulldoze = self:GetAbility():GetSpecialValueFor( "status_resistance" )
end

function modifier_Middle_bulldoze:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Middle_bulldoze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

function modifier_Middle_bulldoze:GetModifierMoveSpeedBonus_Percentage()
	return self:GetParent():PassivesDisabled() and 0 or self.movespeed
end

function modifier_Middle_bulldoze:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Middle_bulldoze:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end




modifier_Middle_bulldoze_active = modifier_Middle_bulldoze_active or advanced_modifier({})
function modifier_Middle_bulldoze_active:IsHidden()	return false end
function modifier_Middle_bulldoze_active:IsDebuff()	return false end
function modifier_Middle_bulldoze_active:IsPurgable()	return true end
function modifier_Middle_bulldoze_active:IsPurgeException() return true end
function modifier_Middle_bulldoze_active:RemoveOnDeath() return true end
function modifier_Middle_bulldoze_active:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
	if not IsServer() then return end
	local sound_cast = "Hero_Spirit_Breaker.Bulldoze.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )

end

function modifier_Middle_bulldoze_active:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Middle_bulldoze_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

function modifier_Middle_bulldoze_active:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end



function modifier_Middle_bulldoze_active:GetEffectName()	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf" end
function modifier_Middle_bulldoze_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Middle_bulldoze_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Middle_bulldoze_active:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

