
chaotic_banishment = class({})
LinkLuaModifier("modifier_chaotic_banishment", "chaotic_spell/class_4/chaotic_banishment", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_banishment_rune_1_debuff", "chaotic_spell/class_4/chaotic_banishment", LUA_MODIFIER_MOTION_NONE)



function chaotic_banishment:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_banishment/effect.vpcf", context )

end

function chaotic_banishment:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_banishment:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	return cost
end



function chaotic_banishment:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_banishment_cast")  

	local duration = self:GetSpecialValueFor("duration")*self:GetEffectGain()
	
	self:ApplyModifier(target, duration)
	if self:GetAutoCastState() then
		local count = self:GetSpecialValueFor("count")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(enemies) do
			if not unit:HasModifier("modifier_chaotic_banishment") then
				count = count - 1
				self:ApplyModifier(unit, duration)
				if count<=0 then
					break
				end
			end
		end
	end



	
end

function chaotic_banishment:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_banishment", {duration = duration*StatusResistance})

end




modifier_chaotic_banishment = modifier_chaotic_banishment or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_banishment:IsHidden()	return false end
function modifier_chaotic_banishment:IsDebuff()	return true end
function modifier_chaotic_banishment:IsStunDebuff()	return true end
function modifier_chaotic_banishment:IsPurgable()	return true end
function modifier_chaotic_banishment:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_banishment:OnCreated( kv )
	

	if not IsServer() then return end
	self:PlayEffects()
end


function modifier_chaotic_banishment:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end


function modifier_chaotic_banishment:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if ability and ability:GetRuneType()==1 then
			parent:AddNewModifier(self:GetCaster(),ability, "modifier_chaotic_banishment_rune_1_debuff", {duration = self:GetAbility():GetSpecialValueFor("rune_1_duration")})
		end
		

		
	end
end






function modifier_chaotic_banishment:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/rebuild/chaotic_spell/chaotic_banishment/effect.vpcf"
	self:GetParent():EmitSound("chaotic_banishment_target")
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_CUSTOMORIGIN, self:GetParent() )
	
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin()+Vector(0,0,64) )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end


function modifier_chaotic_banishment:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_chaotic_banishment:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return -100
end




modifier_chaotic_banishment_rune_1_debuff = modifier_chaotic_banishment_rune_1_debuff or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_banishment_rune_1_debuff:IsHidden()	return false end
function modifier_chaotic_banishment_rune_1_debuff:IsDebuff()	return true end
function modifier_chaotic_banishment_rune_1_debuff:IsStunDebuff()	return true end
function modifier_chaotic_banishment_rune_1_debuff:IsPurgable()	return true end
function modifier_chaotic_banishment_rune_1_debuff:RemoveOnDeath()	return false end
function modifier_chaotic_banishment_rune_1_debuff:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
end
function modifier_chaotic_banishment_rune_1_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_chaotic_banishment_rune_1_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.bonus_damage
end

function modifier_chaotic_banishment_rune_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_banishment_rune_1_debuff:OnTooltip()

	return self:Advanced_GetModifierIncomingDamage_Percentage()

end		