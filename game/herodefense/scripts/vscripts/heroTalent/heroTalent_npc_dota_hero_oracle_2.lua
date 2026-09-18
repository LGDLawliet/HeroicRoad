heroTalent_npc_dota_hero_oracle_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_oracle_2", "heroTalent/heroTalent_npc_dota_hero_oracle_2", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_oracle_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_oracle_2"
end
function heroTalent_npc_dota_hero_oracle_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", context )


end



modifier_heroTalent_npc_dota_hero_oracle_2 = class({})

function modifier_heroTalent_npc_dota_hero_oracle_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_oracle_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_oracle_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_oracle_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_oracle_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_oracle_2:DeclareFunctions()
	local decFuncs = {	
		-- MODIFIER_EVENT_ON_ATTACK_LANDED -- IMBAfication: Meditation
		-- MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		-- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,         --技能伤害
		-- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	    }

    return decFuncs
end
function modifier_heroTalent_npc_dota_hero_oracle_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 2 then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end

	local ability = keys.ability
	Timers:CreateTimer(1.5, function()
		if not ability or ability:IsNull() then
			return
		end
		
		local newCooldown = ability:GetCooldownTimeRemaining()
		if newCooldown>0 then
			newCooldown = newCooldown * RandomFloat(0.7, 1.1)
		else
			return
		end
		if newCooldown>ability:GetCooldownTimeRemaining() then
			local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_CUSTOMORIGIN, keys.unit )
			ParticleManager:SetParticleControl( effect_cast, 0, keys.unit:GetOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			keys.unit:EmitSound("Hero_Oracle.FalsePromise.Damaged")
		else
			local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe.vpcf", PATTACH_CUSTOMORIGIN, keys.unit )
			ParticleManager:SetParticleControl( effect_cast, 0, keys.unit:GetOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 3, keys.unit:GetOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			keys.unit:EmitSound("Hero_Oracle.FortunesEnd.Target")
		end
		ability:EndCooldown()
		if newCooldown>0 then
			ability:StartCooldown(newCooldown)
		end
	end)


end

