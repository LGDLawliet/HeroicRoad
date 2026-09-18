item_hd_hermes_boots = class({})

LinkLuaModifier("modifier_item_hd_hermes_boots", "items/item_hd_hermes_boots", LUA_MODIFIER_MOTION_NONE)

function item_hd_hermes_boots:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/ti10/blink_dagger_start_ti10.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/ti10/blink_dagger_end_ti10_lvl2.vpcf", context )




    
end

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_hermes_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_hermes_boots"
end


function item_hd_hermes_boots:GetCastRange()
	local caster = self:GetCaster()
	return math.min(2000,1500 + caster:GetCastRangeBonus())-caster:GetCastRangeBonus()

end



function item_hd_hermes_boots:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_pos =caster:GetAbsOrigin()
	local cast_range = math.min(2000,1500 + caster:GetCastRangeBonus())-caster:GetCastRangeBonus()
	local distance 	= (pos - caster_pos):Length2D()
	distance = math.min(distance,cast_range)
	local dir = CalculateDirection(pos, caster_pos)
	pos = caster_pos +dir*distance

	caster:EmitSound("Blink_Layer.Arcane")

	local effect_cast = ParticleManager:CreateParticle( "particles/econ/events/ti10/blink_dagger_start_ti10.vpcf", PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, caster_pos )
	ParticleManager:ReleaseParticleIndex( effect_cast )




	

	ProjectileManager:ProjectileDodge(caster) --弹道躲闪
	FindClearSpaceForUnit( caster,pos, true )


	local effect_cast = ParticleManager:CreateParticle( "particles/econ/events/ti10/blink_dagger_end_ti10_lvl2.vpcf", PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
end


modifier_item_hd_hermes_boots = advanced_modifier({})

function modifier_item_hd_hermes_boots:IsDebuff() return false end
function modifier_item_hd_hermes_boots:IsHidden() return true end
function modifier_item_hd_hermes_boots:IsPurgable() return false end


function modifier_item_hd_hermes_boots:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_move = ability:GetSpecialValueFor("bonus_move_speed")
end



function modifier_item_hd_hermes_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end
function modifier_item_hd_hermes_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end


function modifier_item_hd_hermes_boots:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE
    }
end
function modifier_item_hd_hermes_boots:Advanced_GetModifier_DefaultMoveCastRange(keys)
	return 700
end
