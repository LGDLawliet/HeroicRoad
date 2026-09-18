
chaotic_darkvision = class({})
LinkLuaModifier("modifier_chaotic_darkvision", "chaotic_spell/class_2/chaotic_darkvision", LUA_MODIFIER_MOTION_NONE)



function chaotic_darkvision:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", context )

end

function chaotic_darkvision:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end




function chaotic_darkvision:GetManaCostGain()
	local caster = self:GetCaster()
	local keys = {
		ability=self,
		caster = caster,
	}
	local value = GetChaoticSpellManaCostGain(caster,keys)
	return value
end


function chaotic_darkvision:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "Hero_DarkWillow.Shadow_Realm.Damage"    
	EmitSoundOn(sound_cast, caster)    

	local duration =  self:GetSpecialValueFor("duration")*self:GetEffectGain()
	if self:GetRuneType()==1 then
		duration = duration * (1+0.01*self:GetSpecialValueFor("rune_1_bonus_gain"))

	end

	self:ApplyModifier(target,duration)
end

function chaotic_darkvision:ApplyModifier(target, duration)
	local particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 2, Vector(200,200,200))
	-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,3)

	local gain = caster:GetModifierDurationGainIndex(1)
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_darkvision", {duration = duration*gain})

end


modifier_chaotic_darkvision = advanced_modifier({})

function modifier_chaotic_darkvision:IsHidden() return false end
function modifier_chaotic_darkvision:IsPurgable() return true end
function modifier_chaotic_darkvision:IsDebuff() return false end

function modifier_chaotic_darkvision:OnCreated(keys)
	self.min_vision = self:GetAbility():GetSpecialValueFor("min_vision")

end
function modifier_chaotic_darkvision:CheckState()
	if self:GetAbility() and self:GetAbility():GetRuneType()==2 then
		return{
			[MODIFIER_STATE_FORCED_FLYING_VISION] = true
		}
	end
end

function modifier_chaotic_darkvision:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_darkvision:OnTooltip() return self:Advanced_GetBonusNightVision_Min() end
function modifier_chaotic_darkvision:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION_MIN,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,

	
    }
end
function modifier_chaotic_darkvision:Advanced_GetBonusNightVision_Min()
	return self.min_vision
end

function modifier_chaotic_darkvision:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if not IsServer() then
		return
	end
	if not self:GetAbility() then self:Destroy() return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if self:GetAbility():GetRuneType()~=3 then
		return
	end
	if not self:GetParent():CanEntityBeSeenByMyTeam(keys.target) then
		return
	end
	--print("攻击者判定完毕，距离符合")
	local target_pos = keys.target:GetAbsOrigin()
	local pos = keys.attacker:GetAbsOrigin()
	local distance = (target_pos - pos):Length2D()
	--print(target_pos)
	--print(pos)
	--print(distance)
	if distance <= self:GetParent():GetCurrentVisionRange() then
		--print("生效")
		return self:GetAbility():GetSpecialValueFor("rune_3_damage_up")
	end
	return 0
end