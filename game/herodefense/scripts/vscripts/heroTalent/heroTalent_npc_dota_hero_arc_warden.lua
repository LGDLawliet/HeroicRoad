heroTalent_npc_dota_hero_arc_warden = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_arc_warden", "heroTalent/heroTalent_npc_dota_hero_arc_warden", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_arc_warden_effect", "heroTalent/heroTalent_npc_dota_hero_arc_warden", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_arc_warden:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_arc_warden"
end

function heroTalent_npc_dota_hero_arc_warden:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_arc_warden = class({})

function modifier_heroTalent_npc_dota_hero_arc_warden:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_arc_warden:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_arc_warden:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_arc_warden:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_arc_warden:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_arc_warden:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_arc_warden:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_arc_warden_effect" end
function modifier_heroTalent_npc_dota_hero_arc_warden:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_heroTalent_npc_dota_hero_arc_warden:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_arc_warden:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_arc_warden:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_heroTalent_npc_dota_hero_arc_warden:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/zet_telent/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"),1,1) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)
	end

end

function modifier_heroTalent_npc_dota_hero_arc_warden:OnIntervalThink()
	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/zet_telent/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(350,1,1) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end


modifier_heroTalent_npc_dota_hero_arc_warden_effect = class({})
function modifier_heroTalent_npc_dota_hero_arc_warden_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_arc_warden_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_arc_warden_effect:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_arc_warden_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_arc_warden_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))	
	end
end

function modifier_heroTalent_npc_dota_hero_arc_warden_effect:OnIntervalThink()
	if self:GetAbility():GetSpecialValueFor("chance") >= RandomInt(1, 100) then
		-- print("闪避")
		ProjectileManager:ProjectileDodge(self:GetParent()) --弹道躲闪
	end
end

function modifier_heroTalent_npc_dota_hero_arc_warden_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_EVASION_CONSTANT,       --移动速度百分比


	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_arc_warden_effect:GetModifierEvasion_Constant()	return self:GetAbility():GetSpecialValueFor("evasion") end


