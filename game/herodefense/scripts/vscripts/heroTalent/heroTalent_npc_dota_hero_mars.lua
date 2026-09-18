heroTalent_npc_dota_hero_mars = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_mars", "heroTalent/heroTalent_npc_dota_hero_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_mars_effect", "heroTalent/heroTalent_npc_dota_hero_mars", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_mars:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_mars"
end

function heroTalent_npc_dota_hero_mars:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/mars/effect.vpcf", context )

end


modifier_heroTalent_npc_dota_hero_mars = class({})

function modifier_heroTalent_npc_dota_hero_mars:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_mars:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_mars:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_mars:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_mars:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_mars:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_mars:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_mars_effect" end
function modifier_heroTalent_npc_dota_hero_mars:GetAuraRadius()	return 500  end
function modifier_heroTalent_npc_dota_hero_mars:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_mars:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end

function modifier_heroTalent_npc_dota_hero_mars:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end

function modifier_heroTalent_npc_dota_hero_mars:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/mars/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(500,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
	end

end

function modifier_heroTalent_npc_dota_hero_mars:OnIntervalThink()
	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/mars/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(500,0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end


modifier_heroTalent_npc_dota_hero_mars_effect = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_mars_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_mars_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_mars_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_mars_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_mars_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end


function modifier_heroTalent_npc_dota_hero_mars_effect:AdvancedGetModifierConstantHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("heal")
end

