
LinkLuaModifier("modifier_Middle_ancient_seal", "skills/Middle_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_ancient_seal_debuff", "skills/Middle_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_ancient_seal_debuff_mark", "skills/Middle_ancient_seal", LUA_MODIFIER_MOTION_NONE)

Middle_ancient_seal		= Middle_ancient_seal or class({})


function Middle_ancient_seal:GetIntrinsicModifierName()
	return "modifier_Middle_ancient_seal"
end
function Middle_ancient_seal:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf", context )
end

modifier_Middle_ancient_seal	= modifier_Middle_ancient_seal or class({})

function modifier_Middle_ancient_seal:DestroyOnExpire()	return false end
function modifier_Middle_ancient_seal:IsPurgable()		return false end
function modifier_Middle_ancient_seal:RemoveOnDeath()	return false end
function modifier_Middle_ancient_seal:IsPurgeException() return false end
function modifier_Middle_ancient_seal:IsHidden()			return true end
function modifier_Middle_ancient_seal:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE
		
	}
end




function modifier_Middle_ancient_seal:OnTakeDamage(keys)
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

		if unit:HasModifier("modifier_Middle_ancient_seal_debuff") then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(attacker,ability, "modifier_Middle_ancient_seal_debuff", {duration = ability:GetSpecialValueFor('duration')})
 
    end 
end


modifier_Middle_ancient_seal_debuff = modifier_Middle_ancient_seal_debuff or class({})

function modifier_Middle_ancient_seal_debuff:IsDebuff() return true end
function modifier_Middle_ancient_seal_debuff:IsHidden() return false end
function modifier_Middle_ancient_seal_debuff:IsPurgable() return false end
function modifier_Middle_ancient_seal_debuff:IsPurgeException() return false end
function modifier_Middle_ancient_seal_debuff:OnCreated(keys)
	
	local ability = self:GetAbility()
	self.magical_res_reduce = -ability:GetSpecialValueFor("res_reduce")
	if IsServer() then
		self:PlayEffects()
		local parnet = self:GetParent()
		local caster = self:GetCaster()
		parnet:AddNewModifier(caster,ability, "modifier_Middle_ancient_seal_debuff_mark", {})
 
	end
end
function modifier_Middle_ancient_seal_debuff:OnRefresh(keys)
	
	local ability = self:GetAbility()
	self.magical_res_reduce = -ability:GetSpecialValueFor("res_reduce")
	if IsServer() then
		local parnet = self:GetParent()
		local caster = self:GetCaster()
		parnet:AddNewModifier(caster,ability, "modifier_Middle_ancient_seal_debuff_mark", {})
 
	end
end
function modifier_Middle_ancient_seal_debuff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		local parnet = self:GetParent()
		local caster = self:GetCaster()
		parnet:AddNewModifier(caster,ability, "modifier_Middle_ancient_seal_debuff_mark", {})
 
	end
end


function modifier_Middle_ancient_seal_debuff:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
end

function modifier_Middle_ancient_seal_debuff:GetModifierMagicalResistanceBonus()return self.magical_res_reduce end


function modifier_Middle_ancient_seal_debuff:PlayEffects()
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








modifier_Middle_ancient_seal_debuff_mark	= modifier_Middle_ancient_seal_debuff_mark or class({})
function modifier_Middle_ancient_seal_debuff_mark:IsDebuff() return true end
function modifier_Middle_ancient_seal_debuff_mark:DestroyOnExpire()	return false end
function modifier_Middle_ancient_seal_debuff_mark:IsPurgable()		return false end
-- function modifier_Middle_ancient_seal_debuff_mark:RemoveOnDeath()	return false end
function modifier_Middle_ancient_seal_debuff_mark:IsPurgeException() return false end
function modifier_Middle_ancient_seal_debuff_mark:IsHidden()			return false end
function modifier_Middle_ancient_seal_debuff_mark:OnCreated(keys)
	
	-- local ability = self:GetAbility()
	self.bonus_per_stack = 1
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_Middle_ancient_seal_debuff_mark:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(1+self:GetStackCount(),35))
	end
end
function modifier_Middle_ancient_seal_debuff_mark:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
		
	}
end


function modifier_Middle_ancient_seal_debuff_mark:GetModifierIncomingSpellDamageConstant(keys)
	if IsServer() then
		if not keys.damage_type==DAMAGE_TYPE_MAGICAL  then
			return
		end
		if keys.attacker:HasModifier("modifier_Middle_ancient_seal") then
			return keys.damage * self:GetStackCount()*0.01*self.bonus_per_stack
		end
	end

end
function modifier_Middle_ancient_seal_debuff_mark:OnTooltip()
	return self:GetStackCount()*self.bonus_per_stack
end