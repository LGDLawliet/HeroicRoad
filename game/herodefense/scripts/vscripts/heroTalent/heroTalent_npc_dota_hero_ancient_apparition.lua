heroTalent_npc_dota_hero_ancient_apparition = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ancient_apparition", "heroTalent/heroTalent_npc_dota_hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ancient_apparition_effect", "heroTalent/heroTalent_npc_dota_hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_ancient_apparition:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_ancient_apparition"
end

function heroTalent_npc_dota_hero_ancient_apparition:GetCastRange()
	local caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor("radius")
	return self.radius - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_ancient_apparition = class({})

function modifier_heroTalent_npc_dota_hero_ancient_apparition:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_ancient_apparition:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_ancient_apparition_effect" end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:GetAuraRadius()	return self.radius  end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_ancient_apparition:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_ancient_apparition:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_heroTalent_npc_dota_hero_ancient_apparition:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		if not self:GetParent():IsRealHero() then
			return
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/ice_blast/ice_blast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self.radius,1,1) )
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)

		self:StartIntervalThink(0.5)
		
	end

end

function modifier_heroTalent_npc_dota_hero_ancient_apparition:OnIntervalThink()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/ice_blast/ice_blast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self.radius,1,1) )
			ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
			ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end


modifier_heroTalent_npc_dota_hero_ancient_apparition_effect = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:OnCreated()
	self.move_down = -self:GetAbility():GetSpecialValueFor("move_down")
	self.damage_incoming = self:GetAbility():GetSpecialValueFor("damage_incoming")
end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:GetModifierMoveSpeedBonus_Constant()	return self.move_down end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:Advanced_GetModifierIncomingDamage_Percentage()	return self.damage_incoming end

function modifier_heroTalent_npc_dota_hero_ancient_apparition_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
