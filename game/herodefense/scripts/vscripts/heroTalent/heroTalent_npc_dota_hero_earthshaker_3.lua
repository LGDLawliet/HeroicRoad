heroTalent_npc_dota_hero_earthshaker_3 = class({})


LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earthshaker_3_passive", "heroTalent/heroTalent_npc_dota_hero_earthshaker_3", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earthshaker_3_thinker", "heroTalent/heroTalent_npc_dota_hero_earthshaker_3", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earthshaker_3_stun", "heroTalent/heroTalent_npc_dota_hero_earthshaker_3", LUA_MODIFIER_MOTION_NONE )



function heroTalent_npc_dota_hero_earthshaker_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/earthshaker_3/earthshaker_fissure.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/talent/earthshaker_3/fissure_stunned.vpcf", context )
end

function heroTalent_npc_dota_hero_earthshaker_3:GetCastRange( vLocation, hTarget )
	if IsClient() then
		return 99999
	end
	return self:GetSpecialValueFor( "fissure_range" ) - self:GetCaster():GetCastRangeBonus()
end

function heroTalent_npc_dota_hero_earthshaker_3:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self,iLevel)/(math.max(self:GetCaster():GetCooldownReduction(),0.001))
end
function heroTalent_npc_dota_hero_earthshaker_3:IsRefreshable() return false end
function heroTalent_npc_dota_hero_earthshaker_3:RefreshOnWaveStart() return true end

function heroTalent_npc_dota_hero_earthshaker_3:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- local damage =  self:GetSpecialValueFor("health_damage")*caster:GetMaxHealth()*0.01
	local distance = self:GetCastRange( point, caster )
	local duration = self:GetSpecialValueFor("fissure_duration")
	local radius = self:GetSpecialValueFor("fissure_radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")


	-- 墙体宽高参数
	local block_width = 24
	local block_delta = 8.5

	-- 墙体位置延伸
	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local wall_vector = direction * distance

	-- Create blocker along path
	local block_spacing = (block_delta+2*block_width)
	local blocks = distance/block_spacing
	local block_pos = caster:GetHullRadius() + block_delta + block_width
	local start_pos = caster:GetOrigin() + direction*block_pos

	for i=1,blocks do
		local block_vec = caster:GetOrigin() + direction*block_pos
		local blocker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_heroTalent_npc_dota_hero_earthshaker_3_thinker", -- modifier name
			{ duration = duration }, -- kv
			block_vec,
			caster:GetTeamNumber(),
			true
		)
		blocker:SetHullRadius( block_width )
		block_pos = block_pos + block_spacing
	end

	local end_pos = start_pos + wall_vector
	local units = FindUnitsInLine(
		caster:GetTeamNumber(),
		start_pos,
		end_pos,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0
	)

	-- local damageTable = {
	-- 	-- victim = target,
	-- 	attacker = caster,
	-- 	damage = damage,
	-- 	damage_type = DAMAGE_TYPE_PURE,
	-- 	damage_flags = DOTA_DAMAGE_FLAG_NONE,
	-- 	ability = self, --Optional.
	-- }
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)	
	for _,unit in pairs(units) do
		FindClearSpaceForUnit( unit, unit:GetOrigin(), true )
		if unit:GetTeamNumber()~=caster:GetTeamNumber() then
			-- 伤害
			-- damageTable.victim = unit
			-- ApplyDamage(damageTable)
			if IsValid(unit) and unit:IsAlive() then
				local resistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				unit:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_heroTalent_npc_dota_hero_earthshaker_3_stun",
					{ duration = stun_duration*resistance} -- kv
				)
			end
		

		end
	end

	self:PlayEffects( start_pos, end_pos, duration )
end

--------------------------------------------------------------------------------
function heroTalent_npc_dota_hero_earthshaker_3:PlayEffects( start_pos, end_pos, duration )
	-- 特效和音效
	local particle_cast = "particles/rebuild/talent/earthshaker_3/earthshaker_fissure.vpcf"
	local sound_cast = "Hero_EarthShaker.Fissure"

	local caster = self:GetCaster()

	--创建特效
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, start_pos )
	ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	--创建音效
	EmitSoundOnLocationWithCaster( start_pos, sound_cast, caster )
	EmitSoundOnLocationWithCaster( end_pos, sound_cast, caster )
end



function heroTalent_npc_dota_hero_earthshaker_3:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end


function heroTalent_npc_dota_hero_earthshaker_3:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end
function heroTalent_npc_dota_hero_earthshaker_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_heroTalent_npc_dota_hero_earthshaker_3_passive",
			{} -- kv
		)
	end
end

function heroTalent_npc_dota_hero_earthshaker_3:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function heroTalent_npc_dota_hero_earthshaker_3:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("fissure_range")
	local radius = self:GetSpecialValueFor("fissure_radius")

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(radius,radius,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function heroTalent_npc_dota_hero_earthshaker_3:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end





modifier_heroTalent_npc_dota_hero_earthshaker_3_passive = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:RemoveOnDeath() return false end



function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:OnWaveStart()
	self:GetAbility():EndCooldown()

end



function modifier_heroTalent_npc_dota_hero_earthshaker_3_passive:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end








modifier_heroTalent_npc_dota_hero_earthshaker_3_thinker = class({})
function modifier_heroTalent_npc_dota_hero_earthshaker_3_thinker:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_thinker:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_thinker:OnDestroy( kv )
	if IsServer() then
		-- Effects
		local sound_cast = "Hero_EarthShaker.FissureDestroy"
		EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end






modifier_heroTalent_npc_dota_hero_earthshaker_3_stun = class({})

function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:isHidden() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:IsStunDebuff() return true end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:IsPurchasable() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:IsPurgeException() return true end

function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:GetEffectName()
	return "particles/rebuild/talent/earthshaker_3/fissure_stunned.vpcf"
end

function modifier_heroTalent_npc_dota_hero_earthshaker_3_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

