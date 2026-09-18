heroTalent_npc_dota_hero_wisp_5 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_wisp_5", "heroTalent/heroTalent_npc_dota_hero_wisp_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_wisp_5_effect", "heroTalent/heroTalent_npc_dota_hero_wisp_5", LUA_MODIFIER_MOTION_NONE )





function heroTalent_npc_dota_hero_wisp_5:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/wisp_talent/talent_5/effect.vpcf", context )

end






function heroTalent_npc_dota_hero_wisp_5:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_wisp_5"
end

function heroTalent_npc_dota_hero_wisp_5:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end


modifier_heroTalent_npc_dota_hero_wisp_5 = class({})

function modifier_heroTalent_npc_dota_hero_wisp_5:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_wisp_5:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_wisp_5:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_wisp_5:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_wisp_5:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_wisp_5:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_wisp_5:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_wisp_5_effect" end
function modifier_heroTalent_npc_dota_hero_wisp_5:GetAuraRadius()	return self.radius  end
function modifier_heroTalent_npc_dota_hero_wisp_5:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_wisp_5:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_wisp_5:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_heroTalent_npc_dota_hero_wisp_5:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		local ability = self:GetAbility()
		self.radius = ability:GetSpecialValueFor("radius")

		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/wisp_talent/talent_5/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
	end

end
function modifier_heroTalent_npc_dota_hero_wisp_5:OnRefresh(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

	end
end

function modifier_heroTalent_npc_dota_hero_wisp_5:OnIntervalThink()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/wisp_talent/talent_5/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
			-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
			-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
			-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end


modifier_heroTalent_npc_dota_hero_wisp_5_effect = class({})
function modifier_heroTalent_npc_dota_hero_wisp_5_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_wisp_5_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_wisp_5_effect:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_wisp_5_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_wisp_5_effect:OnCreated()
	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow")
	if IsServer() then
		self.damage_index =self:GetAbility():GetSpecialValueFor("damage_index") *0.01
 		self.damageTable = {
			victim = self:GetParent(),
			attacker =self:GetCaster(),
			-- damage = caster:GetStrength(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), 
		}
		self:StartIntervalThink(1)
	end
end
function modifier_heroTalent_npc_dota_hero_wisp_5_effect:OnIntervalThink()
	self.damageTable.damage = self:GetCaster():GetAverageTrueAttackDamage(nil) * self.damage_index
	ApplyDamage(self.damageTable)
end




function modifier_heroTalent_npc_dota_hero_wisp_5_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_wisp_5_effect:GetModifierMoveSpeedBonus_Constant()	return self.move_slow end
