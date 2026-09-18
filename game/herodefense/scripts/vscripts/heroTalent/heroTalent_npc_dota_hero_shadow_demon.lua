
heroTalent_npc_dota_hero_shadow_demon		= heroTalent_npc_dota_hero_shadow_demon or class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_demon", "heroTalent/heroTalent_npc_dota_hero_shadow_demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_demon_debuff", "heroTalent/heroTalent_npc_dota_hero_shadow_demon", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_shadow_demon:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_shadow_demon"
end
function heroTalent_npc_dota_hero_shadow_demon:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_shadow_poison_flow.vpcf", context )
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_shadow_demon	= advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_shadow_demon:DestroyOnExpire()	return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon:IsPurgable()		return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon:RemoveOnDeath()	return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon:IsHidden()			return true end
function modifier_heroTalent_npc_dota_hero_shadow_demon:ADDeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
		
	}
end


function modifier_heroTalent_npc_dota_hero_shadow_demon:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if attacker:PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(attacker,ability, "modifier_heroTalent_npc_dota_hero_shadow_demon_debuff", {duration = ability:GetSpecialValueFor("duration")})

 
    end 
end


modifier_heroTalent_npc_dota_hero_shadow_demon_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:OnCreated(keys)
	self.status_reduce = self:GetAbility():GetSpecialValueFor("status_reduce")
    self.atk_reduce = self:GetAbility():GetSpecialValueFor("atk_reduce")
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:ADDeclareFunctions()
	return {
 
		advanced_MODIFIER_PROPERTY_StatusResistance,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,

	}
end

function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:Advanced_GetModifier_StatusResistance()return -self.status_reduce end
function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:Advanced_GetModifierBaseDamageOutgoing_Percentage()return -self.atk_reduce end


function modifier_heroTalent_npc_dota_hero_shadow_demon_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_shadow_poison_flow.vpcf"

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
		3,
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