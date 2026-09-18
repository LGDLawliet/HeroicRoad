chaotic_doom_execution = class({})


LinkLuaModifier("modifier_chaotic_doom_execution", "chaotic_spell/class_7/chaotic_doom_execution", LUA_MODIFIER_MOTION_NONE)




function chaotic_doom_execution:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_doom_execution/main_effect/effect_doom.vpcf", context )
end
function chaotic_doom_execution:GetIntrinsicModifierName()
	return "modifier_chaotic_doom_execution"
end




modifier_chaotic_doom_execution = advanced_modifier({})

function modifier_chaotic_doom_execution:IsDebuff() return false end
function modifier_chaotic_doom_execution:IsHidden() return true end
function modifier_chaotic_doom_execution:IsPurgable() 		return false end
function modifier_chaotic_doom_execution:IsPurgeException() 	return false end
function modifier_chaotic_doom_execution:RemoveOnDeath()  return false end
function modifier_chaotic_doom_execution:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
	

		self.health_cost = ability:GetSpecialValueFor("health_cost")
		self.health_cost_percentage = ability:GetSpecialValueFor("health_cost_percentage")*0.01
		self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")

		self:StartIntervalThink(0.5)
	end
end



function modifier_chaotic_doom_execution:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
	

		self.health_cost = ability:GetSpecialValueFor("health_cost")
		self.health_cost_percentage = ability:GetSpecialValueFor("health_cost_percentage")*0.01
		self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")

	end
end


function modifier_chaotic_doom_execution:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

function modifier_chaotic_doom_execution:OnIntervalThink()
	local pass = false
	local ability = self:GetAbility()
	if ability:GetAutoCastState() and not self:GetParent():PassivesDisabled() then
		pass = true
	end
	if pass then
		if not self.nFXIndex then
			local caster = self:GetCaster()
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_doom_execution/main_effect/effect_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
			self:AddParticle(self.nFXIndex,  false, false, -1,  false, false)
		end
	else
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex,true)
			self.nFXIndex = nil
		end

	end
end



function modifier_chaotic_doom_execution:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
		if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then
			return
		end
		local ability = self:GetAbility()
		local parent = self:GetParent()
		if ability:GetAutoCastState() and not parent:PassivesDisabled() and parent:IsAlive() then
			
			local cost = self.health_cost + parent:GetHealth() * self.health_cost_percentage 
			parent:ModifyHealth(parent:GetHealth() - cost,ability,false, 0)
			return self.bonus_damage
		end
	end
	return 0
end
