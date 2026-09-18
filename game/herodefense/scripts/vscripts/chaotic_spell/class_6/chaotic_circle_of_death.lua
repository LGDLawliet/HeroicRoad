
chaotic_circle_of_death = class({})

LinkLuaModifier( "modifier_chaotic_circle_of_death", "chaotic_spell/class_6/chaotic_circle_of_death", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_chaotic_circle_of_death_debuff", "chaotic_spell/class_6/chaotic_circle_of_death", LUA_MODIFIER_MOTION_NONE )



LinkLuaModifier( "modifier_chaotic_circle_of_death_rune_1_thinker", "chaotic_spell/class_6/chaotic_circle_of_death", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function chaotic_circle_of_death:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function chaotic_circle_of_death:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = 0.03

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_chaotic_circle_of_death", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end


function chaotic_circle_of_death:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_circle_of_death/effect_main/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_circle_of_death/rune1_effect/effect_effect.vpcf", context )
end





modifier_chaotic_circle_of_death = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_circle_of_death:IsHidden()	return true end
function modifier_chaotic_circle_of_death:IsPurgable()	return false end


function modifier_chaotic_circle_of_death:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()
	self.damage = ability:GetSpecialValueFor( "base_damage" ) +  (ability:GetSpecialValueFor( "bonus_damage" ))*self:GetCaster():HDGetPrimaryStatValue()
	self.radius = ability:GetSpecialValueFor( "radius" )
	self.magic_res_reduce_per_unit = ability:GetSpecialValueFor( "magic_res_reduce_per_unit" )
	self.magic_res_reduce_per_unit_max = ability:GetSpecialValueFor( "magic_res_reduce_per_unit_max" )
end


function modifier_chaotic_circle_of_death:OnDestroy()
	if not IsServer() then return end
	-- destroy trees
	
	local ability = self:GetAbility()
	if not ability then
		UTIL_Remove( self:GetParent() )
		return
	end

	local caster = self:GetCaster()

	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local effect_count = #enemies
	

	if ability:GetRuneType()==1 then
		
		local thinkers = Entities:FindAllByClassnameWithin("npc_dota_thinker", self:GetParent():GetOrigin(),  self.radius)
		for _, unit in ipairs(thinkers) do
			local modifier = unit:FindModifierByName("modifier_chaotic_circle_of_death_rune_1_thinker")
			if modifier then
				effect_count = effect_count + 1
			end
		end
	end
	local magic_res_reduce = effect_count*self.magic_res_reduce_per_unit
	magic_res_reduce =math.min( magic_res_reduce,self.magic_res_reduce_per_unit_max)
	local rune_1_duration = ability:GetSpecialValueFor("rune_1_duration")


	for _,enemy in pairs(enemies) do
		

		enemy:AddNewModifier(enemy, self:GetAbility(), "modifier_chaotic_circle_of_death_debuff", {duration = 0.1,reduce = magic_res_reduce})
		damageTable.victim = enemy
		ApplyDamage( damageTable )
		if IsValid(enemy) and enemy:IsAlive() then
			enemy:RemoveModifierByName("modifier_chaotic_circle_of_death_debuff")
		else
			if ability:GetRuneType()==1 and not enemy:IsAlive() then
				CreateModifierThinker(
					caster, -- player source
					ability, -- ability source
					"modifier_chaotic_circle_of_death_rune_1_thinker", -- modifier name
					{ duration = rune_1_duration }, -- kv
					enemy:GetAbsOrigin(),
					caster:GetTeamNumber(),
					false
				)
			end
		end

	end

	self:PlayEffects2()
	UTIL_Remove( self:GetParent() )
end


function modifier_chaotic_circle_of_death:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_circle_of_death/effect_main/effect.vpcf"
	local sound_cast = "chaotic_circle_of_death_target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 10, Vector( -self.radius, self.radius, self.radius*2 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end







modifier_chaotic_circle_of_death_debuff = class({})

function modifier_chaotic_circle_of_death_debuff:IsDebuff()			return true end
function modifier_chaotic_circle_of_death_debuff:IsHidden() 			return true end
function modifier_chaotic_circle_of_death_debuff:IsPurgable() 		return false end
function modifier_chaotic_circle_of_death_debuff:IsPurgeException() 	return false end
function modifier_chaotic_circle_of_death_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_chaotic_circle_of_death_debuff:GetModifierMagicalResistanceBonus() return self.reduce end
function modifier_chaotic_circle_of_death_debuff:OnCreated(keys)

	if IsServer() then
		self.reduce = -keys.reduce
	end
end






modifier_chaotic_circle_of_death_rune_1_thinker = class({})
function modifier_chaotic_circle_of_death_rune_1_thinker:IsHidden()	return true end
function modifier_chaotic_circle_of_death_rune_1_thinker:IsPurgable()	return false end


function modifier_chaotic_circle_of_death_rune_1_thinker:OnCreated( kv )
	if not IsServer() then return end
	local parent = self:GetParent()
	self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_circle_of_death/rune1_effect/effect_effect.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
	self:AddParticle(self.particle, false, false, -1, false, false)
end


function modifier_chaotic_circle_of_death_rune_1_thinker:OnDestroy()
	if not IsServer() then return end
	-- destroy trees
	
	local ability = self:GetAbility()
	if not ability then
		UTIL_Remove( self:GetParent() )
		return
	end

end

