Middle_split_earth = class({})
LinkLuaModifier( "modifier_Middle_split_earth", "skills/Middle_split_earth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_split_earth_debuff", "skills/Middle_split_earth", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function Middle_split_earth:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function Middle_split_earth:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_split_earth", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end



modifier_Middle_split_earth = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_split_earth:IsHidden()	return true end
function modifier_Middle_split_earth:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_split_earth:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	-- local damage = self:GetAbility():GetSpecialValueFor("damage")+self:GetAbility():GetSpecialValueFor("damage_index")*self:GetCaster():GetIntellect(false)


	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end


function modifier_Middle_split_earth:OnDestroy()
	if not IsServer() then return end

	local caster = self:GetCaster()
	-- find enemies
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
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.8)
	
	for _,enemy in pairs(enemies) do
		-- stun
		local StatusResistance = enemy:GetHDStatusResistanceIndex(0.2)*ModifierStatusNegativeGain
		--enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned",{ duration = self.duration*StatusResistance } )
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned",{ duration = self.duration*StatusResistance} )

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_split_earth_debuff",{ duration = 120*ModifierStatusNegativeGain } )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_split_earth:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end







modifier_Middle_split_earth_debuff = advanced_modifier({})

function modifier_Middle_split_earth_debuff:IsDebuff() return true end
function modifier_Middle_split_earth_debuff:IsHidden() return false end
function modifier_Middle_split_earth_debuff:IsPurgable() return false end
function modifier_Middle_split_earth_debuff:IsPurgeException() return true end

function modifier_Middle_split_earth_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if IsClient() then
		return 0
	end
	if keys.damage_type==DAMAGE_TYPE_MAGICAL  then
		return 3*self:GetStackCount() 
	end
	return 0
end




function modifier_Middle_split_earth_debuff:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Middle_split_earth_debuff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_Middle_split_earth_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


function modifier_Middle_split_earth_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
