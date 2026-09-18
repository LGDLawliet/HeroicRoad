slark_challenge_essence_shift = class({})
LinkLuaModifier( "modifier_slark_challenge_essence_shift", "creeps_spell/slark_challenge_essence_shift", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_challenge_essence_shift_debuff", "creeps_spell/slark_challenge_essence_shift", LUA_MODIFIER_MOTION_NONE )

function slark_challenge_essence_shift:GetIntrinsicModifierName()
	return "modifier_slark_challenge_essence_shift"
end



modifier_slark_challenge_essence_shift = advanced_modifier({})

function modifier_slark_challenge_essence_shift:IsHidden()	return false end
function modifier_slark_challenge_essence_shift:IsDebuff()	return false end
function modifier_slark_challenge_essence_shift:IsPurgable()	return false end
function modifier_slark_challenge_essence_shift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end
function modifier_slark_challenge_essence_shift:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then

		local target = params.target
		self:AddStack( duration )
		self:PlayEffects( params.target )
		if (not target:IsHero()) or target:IsIllusion() then
			return
		end
		if target:IsHero() then
					local debuff = params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_slark_challenge_essence_shift_debuff",
			{	duration = 60,}
		)
		end





	end
end

function modifier_slark_challenge_essence_shift:Advanced_GetModifierAttackSpeedPercentage()
	return self:GetParent():PassivesDisabled() and self:GetStackCount()*0.5 or self:GetStackCount()
end


function modifier_slark_challenge_essence_shift:AddStack( duration )
	self:IncrementStackCount()
end



function modifier_slark_challenge_essence_shift:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end





function modifier_slark_challenge_essence_shift:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end




modifier_slark_challenge_essence_shift_debuff = class({})

function modifier_slark_challenge_essence_shift_debuff:IsHidden()	return false end
function modifier_slark_challenge_essence_shift_debuff:IsDebuff()	return true end
function modifier_slark_challenge_essence_shift_debuff:IsPurgable()	return false end
function modifier_slark_challenge_essence_shift_debuff:OnCreated( kv )
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_slark_challenge_essence_shift_debuff:OnRefresh( kv )
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_slark_challenge_essence_shift_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_slark_challenge_essence_shift_debuff:GetModifierBonusStats_Strength()	return -self:GetStackCount() end
function modifier_slark_challenge_essence_shift_debuff:GetModifierBonusStats_Agility()	return -self:GetStackCount() end
function modifier_slark_challenge_essence_shift_debuff:GetModifierBonusStats_Intellect()	return -self:GetStackCount() end


