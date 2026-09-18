heroTalent_npc_dota_hero_riki = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_riki", "heroTalent/heroTalent_npc_dota_hero_riki", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_riki:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_riki"
end



modifier_heroTalent_npc_dota_hero_riki = class({})

function modifier_heroTalent_npc_dota_hero_riki:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_riki:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_riki:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_riki:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_riki:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_riki:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_riki:OnCreated(keys)
	if IsServer() then
		self:GetParent():SetHullRadius(0.01)
	end
end


-- function modifier_heroTalent_npc_dota_hero_riki:OnIntervalThink()

-- 	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() or not self:GetAbility():IsCooldownReady() then
-- 		if self.nFXIndex then
-- 			ParticleManager:DestroyParticle(self.nFXIndex, false)
-- 			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
-- 			self.nFXIndex = nil
-- 			return
-- 		end
-- 	else
-- 		if not self.nFXIndex then
-- 			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/kunkka_talent/kunkka_talent_ghost_ship_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
-- 			local pos = self:GetCaster():GetAbsOrigin()
-- 			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_portrait", pos, true )
-- 			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
-- 		end
-- 	end
-- end

function modifier_heroTalent_npc_dota_hero_riki:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_heroTalent_npc_dota_hero_riki:OnAttackStart(keys)
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	local target =  keys.target
	if keys.attacker == self:GetParent() and target and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() and self:GetAbility():GetAutoCastState() then	
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local endpos = target:GetAbsOrigin() + (target:GetForwardVector() * -1) * 120
		if endpos~=caster:GetAbsOrigin() then
			local pfx_name1 = "particles/units/heroes/hero_riki/riki_blink_strike_start.vpcf"
			local pfx_name2 = "particles/units/heroes/hero_riki/riki_blink_strike_end.vpcf"
		
			local pfx1 = ParticleManager:CreateParticle(pfx_name1, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx1)

			FindClearSpaceForUnit(caster, endpos, true)
			-- :UseResources(true, true, true, true)
			ability:StartCooldown(0.1)
			caster:SetForwardVector(target:GetForwardVector())
			local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx2)

		end
	end
end

-- function modifier_heroTalent_npc_dota_hero_riki:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
-- 	}

-- 	return state
	

-- end


