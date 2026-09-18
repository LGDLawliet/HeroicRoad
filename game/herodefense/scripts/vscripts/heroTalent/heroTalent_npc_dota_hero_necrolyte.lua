heroTalent_npc_dota_hero_necrolyte = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_necrolyte", "heroTalent/heroTalent_npc_dota_hero_necrolyte", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_necrolyte_effect", "heroTalent/heroTalent_npc_dota_hero_necrolyte", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_necrolyte:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_necrolyte"
end

function heroTalent_npc_dota_hero_necrolyte:GetCastRange()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	return radius - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_necrolyte = class({})

function modifier_heroTalent_npc_dota_hero_necrolyte:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_necrolyte:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_necrolyte:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_necrolyte_effect" end
function modifier_heroTalent_npc_dota_hero_necrolyte:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")  
end
function modifier_heroTalent_npc_dota_hero_necrolyte:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_necrolyte:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_necrolyte:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_heroTalent_npc_dota_hero_necrolyte:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/necrolyte_telent/necrolyte.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
	end

end

function modifier_heroTalent_npc_dota_hero_necrolyte:OnIntervalThink()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/necrolyte_telent/necrolyte.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_necrolyte_effect = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_necrolyte_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_necrolyte_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_effect:OnCreated()
	self.heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
end
-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_necrolyte_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_StatusResistance,
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_necrolyte_effect:Advanced_GetModifier_StatusResistance(keys)
	return -self.heal_amp
end
function modifier_heroTalent_npc_dota_hero_necrolyte_effect:Advanced_GetModifierHealAMP_Percentage()
	return -self.heal_amp
end

