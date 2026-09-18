LinkLuaModifier( "modifier_chaotic_brain_sap_rune_1", "chaotic_spell/class_6/chaotic_brain_sap.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_brain_sap = class({})

function chaotic_brain_sap:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_sap.vpcf", context )
end

function chaotic_brain_sap:GetIntrinsicModifierName()
	if self:GetRuneType() == 1 then
		return "modifier_chaotic_brain_sap_rune_1"
	end
end

function chaotic_brain_sap:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_brain_sap:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()


    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i , enemy in pairs(enemies) do
        self:BrainSuck(enemy,1)
		i = i + 1
		if i > self:GetSpecialValueFor("max")+1 then
			break
		end
	end
end

function chaotic_brain_sap:BrainSuck(target, index)
	if not IsServer() then return end
	if not target then return end
	local index = index or 1
	local caster = self:GetCaster()
	local damage = (self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())*index
	local steal_hp = self:GetSpecialValueFor("steal_hp")*0.01
	local steal_mp = self:GetSpecialValueFor("steal_mp")*0.01

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
	}

	local real_damage = ApplyDamage(damageTable)
	if real_damage>0 then
		local gain = caster:GetModifierLifeStealGain(1)
		local flLifesteal = math.min(real_damage *steal_hp*gain, caster:GetMaxHealth()*0.04)
		local flManasteal = math.min(real_damage *steal_mp*gain, caster:GetMaxMana()*0.04)
		caster:Heal( flLifesteal, self )
		caster:GiveMana(flManasteal)
	end

	self:PlayEffects( target )
end
--------------------------------------------------------------------------------
function chaotic_brain_sap:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_bane/bane_sap.vpcf"
	local sound_cast = "Hero_Bane.BrainSap"
	local sound_target = "Hero_Bane.BrainSap.Target"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end


modifier_chaotic_brain_sap_rune_1 = advanced_modifier({})

function modifier_chaotic_brain_sap_rune_1:IsDebuff() return false end
function modifier_chaotic_brain_sap_rune_1:IsHidden() return true end
function modifier_chaotic_brain_sap_rune_1:IsPurgable() 		return false end
function modifier_chaotic_brain_sap_rune_1:IsPurgeException() 	return false end
    
function modifier_chaotic_brain_sap_rune_1:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.radius = self.ability:GetSpecialValueFor("rune_1_radius")
	self.chance = self.ability:GetSpecialValueFor("rune_1_chance")
	self.index = self.ability:GetSpecialValueFor("rune_1_damage")*0.01
    if IsServer() then 
        self:StartIntervalThink(1)
    end
end

function modifier_chaotic_brain_sap_rune_1:OnIntervalThink()
	local random = math.random
	if self.chance < random(1,100) then return end
	
    local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _ , unit in pairs(units) do
        if unit:IsAlive() then
            local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.ability:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    		for i , enemy in pairs(enemies) do
        		self.ability:BrainSuck(enemy,self.index)
				i = i + 1
				if i > self.ability:GetSpecialValueFor("max")+1 then
					break
				end
			end
			break
        end
    end
end