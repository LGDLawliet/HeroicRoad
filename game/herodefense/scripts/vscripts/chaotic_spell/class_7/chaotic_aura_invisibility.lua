
chaotic_aura_invisibility = class({})
LinkLuaModifier("modifier_chaotic_aura_invisibility", "chaotic_spell/class_7/chaotic_aura_invisibility", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_aura_invisibility_cooldown", "chaotic_spell/class_7/chaotic_aura_invisibility", LUA_MODIFIER_MOTION_NONE)



function chaotic_aura_invisibility:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_greater_invisibility/effect_cast/effect_loadout.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_aura_invisibility/effect_cast/effect_hunter_windwalk.vpcf", context )

end

function chaotic_aura_invisibility:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_aura_invisibility:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()


	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_aura_invisibility/effect_cast/effect_hunter_windwalk.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, caster:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,1.5)


	-- local target = self:GetCursorTarget() 
	local sound_cast = "Hero_Riki.Invisibility"    
	EmitSoundOn(sound_cast, caster)    
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	-- local count = self:GetSpecialValueFor("count")
	for _, unit in ipairs(units) do
		if not unit:IsInInvisibilityCooldown() then
			self:ApplyModifier(unit)
		end
		
	end
end

function chaotic_aura_invisibility:ApplyModifier(target)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_greater_invisibility/effect_cast/effect_loadout.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,200,200))
	DestroyParticleByDelay(particle_cast_fx,1.5)
	target:AddNewModifier(caster, self, "modifier_chaotic_aura_invisibility", {duration =  self:GetSpecialValueFor("duration")})
	target:AddNewModifier(caster, self, "modifier_chaotic_aura_invisibility_cooldown", {duration =  self:GetSpecialValueFor("debuff_duration")})

	

end



modifier_chaotic_aura_invisibility = advanced_modifier({})

function modifier_chaotic_aura_invisibility:IsHidden() return false end
function modifier_chaotic_aura_invisibility:IsPurgable() return true end
function modifier_chaotic_aura_invisibility:IsDebuff() return false end
function modifier_chaotic_aura_invisibility:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.attack_chance = ability:GetSpecialValueFor("attack_chance")
		self.attack_chance_gain = ability:GetSpecialValueFor("attack_chance_gain")
		self.cast_chance = ability:GetSpecialValueFor("cast_chance")
		self.cast_chance_gain = ability:GetSpecialValueFor("cast_chance_gain")
	end
end


function modifier_chaotic_aura_invisibility:GetModifierInvisibilityLevel()return 1 end
function modifier_chaotic_aura_invisibility:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end



function modifier_chaotic_aura_invisibility:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if self.attack_chance>=RandomInt(1, 100) then
				self:SafeDestroy()
			else
				self.attack_chance = self.attack_chance + math.max(self.attack_chance_gain,1)
			end
			
		end
	end
end

function modifier_chaotic_aura_invisibility:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		if keys.unit == parent then
			if self.cast_chance>=RandomInt(1, 100) then
				self:SafeDestroy()
			else
				self.cast_chance = self.cast_chance + math.max(self.cast_chance_gain,1)
			end
		end
	end
end




function modifier_chaotic_aura_invisibility:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	if self:GetAbility():GetRuneType()==1 then
		self.move_speed = self:GetAbility():GetSpecialValueFor("rune_1_bonus_move")
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE)
	end
	return funcs

end


function modifier_chaotic_aura_invisibility:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ABILITY_EXECUTED = {self:GetParent(),nil},

    }
end

function modifier_chaotic_aura_invisibility:GetModifierMoveSpeedBonus_Percentage() 
    return self.move_speed
end





modifier_chaotic_aura_invisibility_cooldown = advanced_modifier({})

function modifier_chaotic_aura_invisibility_cooldown:IsHidden() return false end
function modifier_chaotic_aura_invisibility_cooldown:IsPurgable() return false end
function modifier_chaotic_aura_invisibility_cooldown:IsDebuff() return false end
function modifier_chaotic_aura_invisibility_cooldown:RemoveOnDeath() return false end