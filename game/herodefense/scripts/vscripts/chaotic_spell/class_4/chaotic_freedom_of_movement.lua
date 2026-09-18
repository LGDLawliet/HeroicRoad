
chaotic_freedom_of_movement = class({})
LinkLuaModifier("modifier_chaotic_freedom_of_movement", "chaotic_spell/class_4/chaotic_freedom_of_movement", LUA_MODIFIER_MOTION_NONE)

function chaotic_freedom_of_movement:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_start.vpcf", context )
end

function chaotic_freedom_of_movement:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end
function chaotic_freedom_of_movement:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	return cost
end

function chaotic_freedom_of_movement:Spawn()
	self.current_target = self:GetCaster()
end
function chaotic_freedom_of_movement:GetCastRange(vLocation, hTarget)
	if self:GetRuneType()==1 and hTarget==self.current_target then
		return 99999
	end
	return self.BaseClass.GetCastRange(self,vLocation, hTarget)
end
function chaotic_freedom_of_movement:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "Hero_Windrunner.ShackleshotCast"    
	EmitSoundOn(sound_cast, caster)    
	self:ApplyModifier(target)


	if self:GetRuneType()==1 then
		self.current_target = target
	end
end

function chaotic_freedom_of_movement:ApplyModifier(target, duration)
	local particle_cast = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_start.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,200,200))
	DestroyParticleByDelay(particle_cast_fx,1.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	local effect_gain= self:GetEffectGain()
	target:AddNewModifier(caster, self, "modifier_chaotic_freedom_of_movement", {duration =  self:GetSpecialValueFor("duration")*gain*effect_gain,effect_gain=effect_gain})


end


modifier_chaotic_freedom_of_movement = advanced_modifier({})

function modifier_chaotic_freedom_of_movement:IsHidden() return false end
function modifier_chaotic_freedom_of_movement:IsPurgable() return true end
function modifier_chaotic_freedom_of_movement:IsDebuff() return false end
function modifier_chaotic_freedom_of_movement:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()

		self.stun_disable_fGameTime = GameRules:GetGameTime() + ability:GetSpecialValueFor("stun_disable_duration")*keys.effect_gain
		self.disperse_fGameTime = GameRules:GetGameTime() + ability:GetSpecialValueFor("disperse_duration")*keys.effect_gain
		self:StartIntervalThink(0.1)
	end
end

function modifier_chaotic_freedom_of_movement:OnRefresh(keys)

	if IsServer() then
		local ability = self:GetAbility()

		self.stun_disable_fGameTime = GameRules:GetGameTime() + ability:GetSpecialValueFor("stun_disable_duration")*keys.effect_gain
		self.disperse_fGameTime = GameRules:GetGameTime() + ability:GetSpecialValueFor("disperse_duration")*keys.effect_gain
		self:StartIntervalThink(0.1)
	end
	
end

function modifier_chaotic_freedom_of_movement:OnIntervalThink()
	self:GetParent():Purge(false, true, false, false, false)
	if  GameRules:GetGameTime()>=self.disperse_fGameTime then
		self:StartIntervalThink(-1)
	end
end

function modifier_chaotic_freedom_of_movement:CheckState()
	local state = {

	}
	if self.stun_disable_fGameTime>=GameRules:GetGameTime() then
		state[MODIFIER_STATE_STUNNED] = false
	end
	return state
	

end



function modifier_chaotic_freedom_of_movement:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ImmuneDisadvantagedTerrain_Slow,

    }
end


function modifier_chaotic_freedom_of_movement:Advanced_GetModifier_ImmuneDisadvantagedTerrain_Slow()
	return 1
end

