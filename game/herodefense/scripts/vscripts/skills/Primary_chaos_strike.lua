
Primary_chaos_strike = class({})
LinkLuaModifier( "modifier_Primary_chaos_strike", "skills/Primary_chaos_strike", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function Primary_chaos_strike:GetIntrinsicModifierName()
	return "modifier_Primary_chaos_strike"
end



function Primary_chaos_strike:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf", context )

	
end

modifier_Primary_chaos_strike = advanced_modifier({})


function modifier_Primary_chaos_strike:IsHidden()	return true end
function modifier_Primary_chaos_strike:IsPurgable()	return false end
function modifier_Primary_chaos_strike:IsPurgeException() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_chaos_strike:OnCreated( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_damage_min = self:GetAbility():GetSpecialValueFor( "crit_damage_min" )
	self.crit_damage_max = self:GetAbility():GetSpecialValueFor( "crit_damage_max" )
	self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal" )
	self.record = {}

end

function modifier_Primary_chaos_strike:OnRefresh( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_damage_min = self:GetAbility():GetSpecialValueFor( "crit_damage_min" )
	self.crit_damage_max = self:GetAbility():GetSpecialValueFor( "crit_damage_max" )
	self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal" )
end


function modifier_Primary_chaos_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_Primary_chaos_strike:Advanced_GetModifierCriticalStrike( keys )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		local ability = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_chaos_knight_4")
		if ability then
			local chance = self.crit_chance+ability:GetBonusChance()
			if chance>=RandomInt(1, 100) then
				ability:ReSetStack()
				self.record[keys.record] = true
				local damage = RandomInt(self.crit_damage_min, self.crit_damage_max) 
				damage = damage * RandomInt(ability:GetSpecialValueFor("min_damage"), ability:GetSpecialValueFor("max_damage"))*0.01
	
				return damage
			else
				ability:InCreaseModifierStack()
			end
			

		else
			if self.crit_chance>=RandomInt(1, 100) then
				self.record[keys.record] = true
				local damage = RandomInt(self.crit_damage_min, self.crit_damage_max)
	
				return damage
			end
		end

	end
end

function modifier_Primary_chaos_strike:OnTakeDamage( params )
	if IsServer() then
		-- filter
		local pass = false
		if self.record[params.record] then
			pass = true
			self.record[params.record]= nil
		end

		-- logic
		if pass then
			-- get heal value
			local heal = params.damage * self.lifesteal/100


			local gain = self:GetParent():GetModifierLifeStealGain(1)
			local flLifesteal =heal*gain
			self:GetParent():Heal( flLifesteal, self:GetAbility() )
			self:PlayEffects( params.unit )
		end
	end
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_chaos_strike:PlayEffects( target )
	-- get resource
	local sound_cast = "Hero_ChaosKnight.ChaosStrike"
	local pfx_name = "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end




function modifier_Primary_chaos_strike:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
