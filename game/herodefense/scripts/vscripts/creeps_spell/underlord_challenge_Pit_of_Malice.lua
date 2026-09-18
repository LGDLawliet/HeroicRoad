
underlord_challenge_Pit_of_Malice = class({})

LinkLuaModifier("modifier_underlord_challenge_Pit_of_Malice_passive", "creeps_spell/underlord_challenge_Pit_of_Malice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_underlord_challenge_Pit_of_Malice_effect", "creeps_spell/underlord_challenge_Pit_of_Malice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_underlord_challenge_Pit_of_Malice_cooldown", "creeps_spell/underlord_challenge_Pit_of_Malice", LUA_MODIFIER_MOTION_NONE)


function underlord_challenge_Pit_of_Malice:GetIntrinsicModifierName() return "modifier_underlord_challenge_Pit_of_Malice_passive" end
function underlord_challenge_Pit_of_Malice:Precache( context )

	
	-- PrecacheResource( "particle", "particles/items2_fx/teleport_end.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/underlord_pit_of_malice/pit_of_malice.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/underlord_pitofmalice_pre.vpcf", context )
	

	

end
modifier_underlord_challenge_Pit_of_Malice_passive = class({})

function modifier_underlord_challenge_Pit_of_Malice_passive:IsHidden() return true end
function modifier_underlord_challenge_Pit_of_Malice_passive:IsPurgable() 			return false end
function modifier_underlord_challenge_Pit_of_Malice_passive:IsPurgeException() 	return false end
-- function modifier_underlord_challenge_Pit_of_Malice_passive:RemoveOnDeath() return false end
-- function modifier_underlord_challenge_Pit_of_Malice_passive:GetAuraEntityReject(hEntity)

-- 	if hEntity:GetUnitName()=="npc_monster_challenge_004" then
-- 		return true
-- 	end
-- 	return false
-- end

function modifier_underlord_challenge_Pit_of_Malice_passive:OnCreated(keys)
	if IsServer() then
		local particle_cast = "particles/units/heroes/heroes_underlord/underlord_pitofmalice_pre.vpcf"
		-- local sound_cast = "Hero_AbyssalUnderlord.PitOfMalice.Start"
		self.radius = 600
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		self.duration = 2

		if not IsServer() then return end

		-- start interval
		self:StartIntervalThink( 0.05 )
		-- self:OnIntervalThink()

		-- play effects
		self:PlayEffects()
	end
end



function modifier_underlord_challenge_Pit_of_Malice_passive:OnIntervalThink()
	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() or caster:PassivesDisabled() then
		return
	end
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	
	for _,enemy in pairs(enemies) do
		-- check if not cooldown
	
		local modifier = enemy:FindModifierByNameAndCaster( "modifier_underlord_challenge_Pit_of_Malice_cooldown", caster )
		if not caster:IsAlive() then
			return
		end
		if not modifier then
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			-- apply modifier
			enemy:AddNewModifier(
				caster, -- player source
				self:GetAbility(), -- ability source
				"modifier_underlord_challenge_Pit_of_Malice_effect", -- modifier name
				{ duration = self.duration*StatusResistance } -- kv
			)
		end
	end
end



function modifier_underlord_challenge_Pit_of_Malice_passive:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/underlord_pit_of_malice/pit_of_malice.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.PitOfMalice"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 99999, 0, 0 ) )

	-- buff particle
	self:AddParticle(effect_cast,false, false, -1, false, false )
	EmitSoundOn( sound_cast, parent )
end



modifier_underlord_challenge_Pit_of_Malice_effect = advanced_modifier({})

function modifier_underlord_challenge_Pit_of_Malice_effect:IsDebuff()			return true end
function modifier_underlord_challenge_Pit_of_Malice_effect:IsHidden() 			return false end
function modifier_underlord_challenge_Pit_of_Malice_effect:IsPurgable() 			return false end
function modifier_underlord_challenge_Pit_of_Malice_effect:IsPurgeException() 	return false end
function modifier_underlord_challenge_Pit_of_Malice_effect:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE  end
function modifier_underlord_challenge_Pit_of_Malice_effect:OnCreated( kv )
	-- references
	local interval = 5

	if not IsServer() then return end

	-- create cooldown modifier
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_underlord_challenge_Pit_of_Malice_cooldown", -- modifier name
		{
			duration = interval,
		} -- kv
	)

	local hero = self:GetParent():IsHero()
	local sound_cast = "Hero_AbyssalUnderlord.Pit.TargetHero"
	if not hero then
		sound_cast = "Hero_AbyssalUnderlord.Pit.Target"
	end
	EmitSoundOn( sound_cast, self:GetParent() )

end


function modifier_underlord_challenge_Pit_of_Malice_effect:Advanced_GetModifierIncomingDamage_Percentage() return 20 end
function modifier_underlord_challenge_Pit_of_Malice_effect:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_underlord_challenge_Pit_of_Malice_effect:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_underlord_challenge_Pit_of_Malice_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_underlord_challenge_Pit_of_Malice_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_underlord_challenge_Pit_of_Malice_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.target == self:GetCaster() then
		return -60
	end
end






modifier_underlord_challenge_Pit_of_Malice_cooldown = class({})

function modifier_underlord_challenge_Pit_of_Malice_cooldown:IsHidden()	return true end
function modifier_underlord_challenge_Pit_of_Malice_cooldown:IsDebuff()	return true end
function modifier_underlord_challenge_Pit_of_Malice_cooldown:IsPurgable()	return false end
function modifier_underlord_challenge_Pit_of_Malice_cooldown:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE  end

