
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa", "heroTalent/heroTalent_npc_dota_hero_medusa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_effect", "heroTalent/heroTalent_npc_dota_hero_medusa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_stone", "heroTalent/heroTalent_npc_dota_hero_medusa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_delay", "heroTalent/heroTalent_npc_dota_hero_medusa", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
heroTalent_npc_dota_hero_medusa = class({})
function heroTalent_npc_dota_hero_medusa:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_medusa"
end

function heroTalent_npc_dota_hero_medusa:GetCastRange()
	local caster = self:GetCaster()
	return 500 - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_medusa = class({})

function modifier_heroTalent_npc_dota_hero_medusa:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_medusa:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_medusa:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_medusa:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_medusa:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_medusa:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_medusa:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_medusa_effect" end
function modifier_heroTalent_npc_dota_hero_medusa:GetAuraRadius()	return 500  end
function modifier_heroTalent_npc_dota_hero_medusa:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_medusa:GetAuraSearchType()	return DOTA_UNIT_TARGET_BASIC+ DOTA_UNIT_TARGET_HERO end

function modifier_heroTalent_npc_dota_hero_medusa:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

--------------------------------------------------------------------------------
-- Initializations
function modifier_heroTalent_npc_dota_hero_medusa:OnCreated( kv )

	if not IsServer() then return end
	if not self:GetParent():IsRealHero() then
		return false
	end
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/medusa_telet/medusa_stone.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(self.nFXIndex,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_head",Vector(0,0,0),true )
	self:AddParticle(self.nFXIndex,false, false, -1,false, false )

	self:StartIntervalThink(0.3)

end




function modifier_heroTalent_npc_dota_hero_medusa:OnIntervalThink()

	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive()  then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
			return
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/medusa_telet/medusa_stone.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt(self.nFXIndex,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_head",Vector(0,0,0),true )
			self:AddParticle(self.nFXIndex,false, false, -1,false, false )
		end
	end
end



modifier_heroTalent_npc_dota_hero_medusa_effect = class({})

function modifier_heroTalent_npc_dota_hero_medusa_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_effect:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_effect:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_medusa_effect:OnCreated( kv )
	self.stun_duration = 2
	self.face_duration = 3
	self.physical_bonus = 80
	self.radius = 500
	self.stone_angle = 85 
	self.parent = self:GetParent()
	self.facing = false
	self.counter = 0
	self.interval = 0.1

	if not IsServer() then return end
	self.center_unit = self:GetCaster()

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end


function modifier_heroTalent_npc_dota_hero_medusa_effect:OnIntervalThink()
	if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_medusa_delay") then
		return
	end
	
	local vector = self.center_unit:GetOrigin()-self.parent:GetOrigin()

	local center_angle = VectorToAngles( vector ).y
	local facing_angle = VectorToAngles( self.parent:GetForwardVector() ).y
	local distance = vector:Length2D()
	local prev_facing = self.facing
	self.facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) < self.stone_angle ) and (distance < self.radius )

	-- change effects only when the state changed
	if self.facing~=prev_facing then
		self:ChangeEffects( self.facing )
	end

	-- if facing and distance is less than radius, add to counter
	if self.facing then
		self.counter = self.counter + self.interval
	end

	-- if counter is more than face duration, stun and destroy
	if self.counter>=self.face_duration then
		self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(),"modifier_heroTalent_npc_dota_hero_medusa_stone", 
			{
				duration = self.stun_duration,
				physical_bonus = self.physical_bonus,
				center_unit = self.center_unit:entindex(),
			} 
		)
		self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(),"modifier_heroTalent_npc_dota_hero_medusa_delay", 
		{
			duration = 15
		} 
		)
		self.counter = 0


	end
end


function modifier_heroTalent_npc_dota_hero_medusa_effect:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.center_unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end
function modifier_heroTalent_npc_dota_hero_medusa_effect:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

function modifier_heroTalent_npc_dota_hero_medusa_effect:ChangeEffects( IsNowFacing )
	-- change cp based on facing or not
	local target = self.parent
	if IsNowFacing then
		target = self.center_unit

		-- play sound
		local sound_cast = "Hero_Medusa.StoneGaze.Target"
		EmitSoundOnClient( sound_cast, self:GetParent():GetPlayerOwner() )
	end

	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
end



modifier_heroTalent_npc_dota_hero_medusa_stone = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_medusa_stone:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_stone:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_stone:IsStunDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_stone:IsPurgable()	return true end


function modifier_heroTalent_npc_dota_hero_medusa_stone:OnCreated( kv )
	if not IsServer() then return end
	self.physical_bonus = kv.physical_bonus
	self.center_unit = EntIndexToHScript( kv.center_unit )
	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_medusa_stone:OnRefresh( kv )
	if not IsServer() then return end

	-- references
	self.physical_bonus = kv.physical_bonus
	self.center_unit = EntIndexToHScript( kv.center_unit )

	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_medusa_stone:Advanced_GetModifierIncomingDamage_Percentage( params )
	if IsClient() then
		return
	end
	if params.damage_type==DAMAGE_TYPE_PHYSICAL then
		return self.physical_bonus
	end
end

function modifier_heroTalent_npc_dota_hero_medusa_stone:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end


function modifier_heroTalent_npc_dota_hero_medusa_stone:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_heroTalent_npc_dota_hero_medusa_stone:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_heroTalent_npc_dota_hero_medusa_stone:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
	local sound_cast = "Hero_Medusa.StoneGaze.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.center_unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector( 0,0,0 ), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:GetParent():EmitSound(sound_cast)
end


function modifier_heroTalent_npc_dota_hero_medusa_stone:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end







modifier_heroTalent_npc_dota_hero_medusa_delay = class({})

function modifier_heroTalent_npc_dota_hero_medusa_delay:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_delay:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_delay:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_delay:IsPurgeException() return false end
