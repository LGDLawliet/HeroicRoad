heroTalent_npc_dota_hero_rubick_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_rubick_2", "heroTalent/heroTalent_npc_dota_hero_rubick_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_rubick_2_effect", "heroTalent/heroTalent_npc_dota_hero_rubick_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_rubick_2:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_rubick_2"
-- end
-- particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_rubick.vpcf
function heroTalent_npc_dota_hero_rubick_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_rubick.vpcf", context )
end
function heroTalent_npc_dota_hero_rubick_2:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	caster:AddActivityModifier("wall")
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5,2)
	caster:ClearActivityModifiers()

	return true -- if success
end


--------------------------------------------------------------------------------
-- Ability Start
function heroTalent_npc_dota_hero_rubick_2:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_rubick_2", {duration=3})

	local sound_cast = "Hero_Rubick.SpellSteal.Cast"
	EmitSoundOn( sound_cast, caster )


	-- self:StaticEffect(caster:GetAbsOrigin())
end

modifier_heroTalent_npc_dota_hero_rubick_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_rubick_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_rubick_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_rubick_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_rubick_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_rubick_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_rubick_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_rubick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		-- self:StartIntervalThink(0.5)

		-- self:StartIntervalThink(0.5)
		
	end

end

function modifier_heroTalent_npc_dota_hero_rubick_2:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
	}
end


function modifier_heroTalent_npc_dota_hero_rubick_2:Advanced_GetAdvancedLevelBonus(keys)
	return 12
end