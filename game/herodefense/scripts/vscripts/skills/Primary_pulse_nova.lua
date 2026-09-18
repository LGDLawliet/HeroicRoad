Primary_pulse_nova = class({})
LinkLuaModifier( "modifier_Primary_pulse_nova", "skills/Primary_pulse_nova", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Primary_pulse_nova:OnSpellStart()

	local caster    =   self:GetCaster()

	local modifier = caster:FindModifierByName("modifier_Primary_pulse_nova")
	if modifier then
		modifier:SafeDestroy()
		return
	end

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	self.modifier = caster:AddNewModifier(caster, self, "modifier_Primary_pulse_nova", {})

end
function Primary_pulse_nova:GetCastRange()
	
	--去拿施法时的施法距离

	local caster =self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_Primary_pulse_nova = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_pulse_nova:IsHidden()	return false end
function modifier_Primary_pulse_nova:IsDebuff()	return false end
function modifier_Primary_pulse_nova:IsPurgable()	return false end
-- function modifier_Primary_pulse_nova:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_PERMANENT 
-- end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_pulse_nova:OnCreated( kv )
	if not IsServer() then return end
	-- references
	
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.manacost = self:GetAbility():GetSpecialValueFor( "mana_cost_per_second" )*self:GetCaster():GetIntellect(false)
	local interval = 1

	-- precache
	self.parent = self:GetParent()

	-- ApplyDamage(damageTable)

	-- Start interval
	self:Burn()
	self:StartIntervalThink( interval )

	-- play effects
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_Primary_pulse_nova:OnRefresh( kv )
end

function modifier_Primary_pulse_nova:OnRemoved()
end

function modifier_Primary_pulse_nova:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	StopSoundOn( sound_loop, self.parent )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_pulse_nova:OnIntervalThink()
	-- check mana
	local mana = self.parent:GetMana()
	if mana < self.manacost then
		-- turn off
		self:SafeDestroy()
		return
	end

	-- damage
	self:Burn()
end

function modifier_Primary_pulse_nova:Burn()
	-- spend mana
	local ability = self:GetAbility()
	
	self.manacost =ability:GetSpecialValueFor( "mana_cost_per_second" )*self:GetCaster():GetIntellect(false)
	self.parent:SpendMana( self.manacost, ability )

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damage = ability:GetSpecialValueFor( "damage" )+ability:GetSpecialValueFor( "bonus_damage" )*self.parent:GetIntellect(false)
	if self.parent:HasAbility("heroTalent_npc_dota_hero_leshrac_2") then
		local spell_amp = self.parent:GetSpellAmplification(false)
		if spell_amp>0 then
			damage = damage * (1+spell_amp*0.3)
		end
	end
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		self:PlayEffects( enemy )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_pulse_nova:GetEffectName()
	return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
end

function modifier_Primary_pulse_nova:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_pulse_nova:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
	local sound_cast = "Hero_Leshrac.Pulse_Nova_Strike"

	-- radius
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOn( sound_cast, target )
end
