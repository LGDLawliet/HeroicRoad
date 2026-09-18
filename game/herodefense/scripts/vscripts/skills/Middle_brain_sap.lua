
-- require('internal/timers')   --计时器功能
Middle_brain_sap = class({})
LinkLuaModifier( "modifier_Middle_brain_sap_debuff", "skills/Middle_brain_sap", LUA_MODIFIER_MOTION_NONE )
function Middle_brain_sap:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_sap.vpcf", context )
end
function Middle_brain_sap:GetCastRange(vLocation, hTarget)
	local base_range = self.BaseClass.GetCastRange(self,vLocation, hTarget)
	if self.talent or self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_bane_2") then
		self.talent = true
		base_range = base_range +200
	end
	return base_range
end
function Middle_brain_sap:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local damage = self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_bane_2") then
		damage = damage *1.2
	end


	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	local real_damage = ApplyDamage(damageTable)
	if real_damage>0 then
		local gain = caster:GetModifierLifeStealGain(1)
		local flLifesteal = real_damage *gain
		caster:Heal( flLifesteal, self )
		target:AddNewModifier(caster, self, "modifier_Middle_brain_sap_debuff", {duration =5,max_stack =real_damage*2 })
	end
	
		
	
	-- Play effects
	self:PlayEffects( target )
end

--------------------------------------------------------------------------------
function Middle_brain_sap:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_bane/bane_sap.vpcf"
	local sound_cast = "Hero_Bane.BrainSap"
	local sound_target = "Hero_Bane.BrainSap.Target"

	-- Create Particle
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

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end





modifier_Middle_brain_sap_debuff= class({})

function modifier_Middle_brain_sap_debuff:IsDebuff()			return true end
function modifier_Middle_brain_sap_debuff:IsHidden() 			return false end
function modifier_Middle_brain_sap_debuff:IsPurgable() 		return false end
function modifier_Middle_brain_sap_debuff:IsPurgeException() 	return false end
function modifier_Middle_brain_sap_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_brain_sap_debuff:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end

function modifier_Middle_brain_sap_debuff:OnCreated(keys)
	if IsServer() then
		self.max_stack = keys.max_stack
		self:SetStackCount(0)
	end
end

function modifier_Middle_brain_sap_debuff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local damageTable = {
			victim = parent,
			attacker = caster,
			damage = self:GetStackCount(),
			damage_type = DAMAGE_TYPE_PURE,
			ability = ability, --Optional.
			
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
			hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
		}
		ApplyDamage(damageTable)
		ability:PlayEffects(parent)
	end
end


function modifier_Middle_brain_sap_debuff:OnTakeDamage( params )
	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent()  then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		self:SetStackCount(math.min(self.max_stack,self:GetStackCount()+flDamage))
		if self:GetStackCount()>=(self.max_stack-1) then
			self:SafeDestroy()
		end
	end
	return 0.0
end