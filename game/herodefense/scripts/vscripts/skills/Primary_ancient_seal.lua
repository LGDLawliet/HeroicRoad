
LinkLuaModifier("modifier_Primary_ancient_seal", "skills/Primary_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_ancient_seal_debuff", "skills/Primary_ancient_seal", LUA_MODIFIER_MOTION_NONE)

Primary_ancient_seal		= Primary_ancient_seal or class({})


function Primary_ancient_seal:GetIntrinsicModifierName()
	return "modifier_Primary_ancient_seal"
end
function Primary_ancient_seal:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf", context )
end

modifier_Primary_ancient_seal	= modifier_Primary_ancient_seal or class({})

function modifier_Primary_ancient_seal:DestroyOnExpire()	return false end
function modifier_Primary_ancient_seal:IsPurgable()		return false end
function modifier_Primary_ancient_seal:RemoveOnDeath()	return false end
function modifier_Primary_ancient_seal:IsPurgeException() return false end
function modifier_Primary_ancient_seal:IsHidden()			return true end
function modifier_Primary_ancient_seal:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE
		
	}
end




function modifier_Primary_ancient_seal:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end
		if keys.damage<=30 then return	end
		if keys.damage_type~=DAMAGE_TYPE_MAGICAL  then
			return
		end
		if attacker:PassivesDisabled() then
			return
		end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

		if unit:HasModifier("modifier_Primary_ancient_seal_debuff") then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(attacker,ability, "modifier_Primary_ancient_seal_debuff", {duration = ability:GetSpecialValueFor('duration')})
 
    end 
end


modifier_Primary_ancient_seal_debuff = modifier_Primary_ancient_seal_debuff or class({})

function modifier_Primary_ancient_seal_debuff:IsDebuff() return true end
function modifier_Primary_ancient_seal_debuff:IsHidden() return false end
function modifier_Primary_ancient_seal_debuff:IsPurgable() return false end
function modifier_Primary_ancient_seal_debuff:IsPurgeException() return false end
function modifier_Primary_ancient_seal_debuff:OnCreated(keys)
	self.magical_res_reduce = -self:GetAbility():GetSpecialValueFor("res_reduce")
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_Primary_ancient_seal_debuff:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
end

function modifier_Primary_ancient_seal_debuff:GetModifierMagicalResistanceBonus()return self.magical_res_reduce end


function modifier_Primary_ancient_seal_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf"
	local sound_cast = "Hero_SkywrathMage.AncientSeal.Target"

	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"",
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

	-- Create Sound
	EmitSoundOn( sound_cast, parent )
end