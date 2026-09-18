--
heroTalent_npc_dota_hero_spirit_breaker = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spirit_breaker", "heroTalent/heroTalent_npc_dota_hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_spirit_breaker:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_spirit_breaker"
end



modifier_heroTalent_npc_dota_hero_spirit_breaker = class({})

function modifier_heroTalent_npc_dota_hero_spirit_breaker:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spirit_breaker:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_spirit_breaker:GetEffectName() return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_debut_ambient_ground_arcs_pnt.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_spirit_breaker:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_heroTalent_npc_dota_hero_spirit_breaker:OnCreated()
	
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.caster = self:GetCaster()
		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		self:StartIntervalThink(0.5)
		
	end
end
function modifier_heroTalent_npc_dota_hero_spirit_breaker:OnIntervalThink()
	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
			
		end
		return
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		end
	end


end

function modifier_heroTalent_npc_dota_hero_spirit_breaker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker:GetModifierPreAttack_BonusDamagePostCrit(params) 
	self.move_index = self:GetAbility():GetSpecialValueFor("move_index")*0.01
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return self:GetParent():GetIdealSpeed()*self.move_index
end



function modifier_heroTalent_npc_dota_hero_spirit_breaker:GetActivityTranslationModifiers( params )
	return "charge"
end
function modifier_heroTalent_npc_dota_hero_spirit_breaker:GetModifierIgnoreMovespeedLimit()        
	if not self:GetParent():IsRealHero() then
		return 0
	end 
	return  1  
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_move")
end