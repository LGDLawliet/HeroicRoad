--
heroTalent_npc_dota_hero_slardar_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slardar_2", "heroTalent/heroTalent_npc_dota_hero_slardar_2", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_slardar_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_slardar_2"
end

function heroTalent_npc_dota_hero_slardar_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"corrosive_haze",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_slardar_2 = class({})

function modifier_heroTalent_npc_dota_hero_slardar_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_slardar_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_slardar_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_slardar_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_slardar_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slardar_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_slardar_2:OnAttackLanded( keys )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		if keys.attacker~=caster then
			return false
		end
		if not IsEnemy(caster,keys.target) then
			return
		end
		if caster:HasModifier("modifier_Advanced_corrosive_haze_unlock3_active") then
			return
		end
		local ability = caster:FindAbilityByName("Advanced_corrosive_haze")
		if not ability then
			ability = caster:FindAbilityByName("Middle_corrosive_haze")
			if not ability then
				ability = caster:FindAbilityByName("Primary_corrosive_haze")
			end
		end
		if not ability then
			return
		end

		ability:TalentBuff(keys.target)





	end
end

