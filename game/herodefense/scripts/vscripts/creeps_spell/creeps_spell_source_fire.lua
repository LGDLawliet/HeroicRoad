
--------------------------------------------------------------------------------
creeps_spell_source_fire = class({})
LinkLuaModifier( "modifier_creeps_spell_source_fire", "creeps_spell/creeps_spell_source_fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_source_fire_thinker", "creeps_spell/creeps_spell_source_fire", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------
-- Custom KV
-- Cast Range
function creeps_spell_source_fire:GetCastRange( vLocation, hTarget )
	return self:GetSpecialValueFor( "cast_range" ) + self:GetCaster():GetCastRangeBonus()
end





-- Ability Start
function creeps_spell_source_fire:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )
	
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	CreateModifierThinker(caster, self, "modifier_creeps_spell_source_fire_thinker", 
	{}, point, caster:GetTeamNumber(), false)

	caster:EmitSoundParams("Hero_Jakiro.Macropyre.Cast", 0, 0.55, 0)
end
--------------------------------------------------------------------------
--thinker
modifier_creeps_spell_source_fire_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_source_fire_thinker:IsHidden()     return false  end
function modifier_creeps_spell_source_fire_thinker:IsDebuff()     return false  end
function modifier_creeps_spell_source_fire_thinker:IsStunDebuff() return false end
function modifier_creeps_spell_source_fire_thinker:IsPurgable()   return false end
--------------------------------------------------------------------------------
-- Initializations


function modifier_creeps_spell_source_fire_thinker:OnCreated( kv )	
	if not IsServer() then return end

	self.damage_index = 1
	self.timer = 0
	
	self:StartIntervalThink( 0.5 )

	self:PlayEffects()
end
function modifier_creeps_spell_source_fire_thinker:OnRefresh( kv ) end
function modifier_creeps_spell_source_fire_thinker:OnRemoved()     end
function modifier_creeps_spell_source_fire_thinker:OnDestroy()
	if not IsServer() then return end
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end
	StopSoundOn( "hero_jakiro.macropyre", self:GetParent() )
	UTIL_Remove( self:GetParent() )
end


function modifier_creeps_spell_source_fire_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() then
		self:SafeDestroy()
		return
	end
	self.timer = self.timer +0.5
	if self.timer>=2 then
		self.timer = self.timer - 2
		self.damage_index  = self.damage_index  *1.01
	end
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,ability:GetSpecialValueFor("radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = ability:GetSpecialValueFor("bonus_damage")*caster:GetDamageMax() * self.damage_index 
	for _,enemy in pairs(enemies) do
	
		enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_creeps_spell_source_fire", -- modifier name
			{
				duration = 1,
				damage = damage,
			} -- kv
		)
 
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creeps_spell_source_fire_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/source_fire/source_fire.vpcf"
	
	local sound_cast = "hero_jakiro.macropyre"
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	local pos = self:GetParent():GetAbsOrigin()
	ParticleManager:SetParticleControl( self.effect_cast, 0, pos)
	ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 500, 0, 0 ) )

	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)


	self:GetParent():EmitSoundParams(sound_cast, 0, 0.4, 0)

end

------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_creeps_spell_source_fire = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_source_fire:IsHidden()return false end
function modifier_creeps_spell_source_fire:IsDebuff()

	return false

end

function modifier_creeps_spell_source_fire:IsStunDebuff()return false  end
function modifier_creeps_spell_source_fire:IsPurgable()return false end

function modifier_creeps_spell_source_fire:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creeps_spell_source_fire:OnCreated( kv )
	if not IsServer() then return end

	local damage = kv.damage

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_creeps_spell_source_fire:OnRefresh( kv )
	if not IsServer() then return end
	local damage = kv.damage
	self.damageTable.damage = damage
end
function modifier_creeps_spell_source_fire:OnRemoved() end
function modifier_creeps_spell_source_fire:OnDestroy() end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_creeps_spell_source_fire:OnIntervalThink()

	ApplyDamage( self.damageTable )

end


function modifier_creeps_spell_source_fire:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_creeps_spell_source_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
