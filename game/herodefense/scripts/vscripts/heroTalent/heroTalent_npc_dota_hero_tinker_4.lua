heroTalent_npc_dota_hero_tinker_4 = heroTalent_npc_dota_hero_tinker_4 or  class({})
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_4_thinker", "heroTalent/heroTalent_npc_dota_hero_tinker_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_4", "heroTalent/heroTalent_npc_dota_hero_tinker_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_tinker_4:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/cast_effect/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/effect.vpcf", context )

	

-- end
function heroTalent_npc_dota_hero_tinker_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_tinker_4"
end



function heroTalent_npc_dota_hero_tinker_4:Spawn()
    self.achievement_count = 0
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
				skillshop:LearnTalentDefaultAbility(caster,"laser",costKeys)
			end
		end)
	
	end

end








modifier_heroTalent_npc_dota_hero_tinker_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tinker_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tinker_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tinker_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tinker_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tinker_4:RemoveOnDeath() return false end

-- function modifier_heroTalent_npc_dota_hero_tinker_4:OnCreated(keys)
-- 	if IsServer() then
-- 		if not self:GetParent():IsRealHero() then
-- 			return false
-- 		end
-- 		local playerHero = self:GetParent()
-- 		if playerHero:HasAbility("Middle_laser") or playerHero:HasAbility("Advanced_laser") then
-- 			playerHero:ModifyGoldFiltered(500,true,DOTA_ModifyGold_CreepKill )  --金币奖励
-- 			SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, 500, nil)
-- 			--返还500块钱
-- 			return
-- 		end
-- 		local ability = playerHero:FindAbilityByName("Primary_laser")
-- 		if ability  then
-- 			playerHero:ModifyGoldFiltered(500,true,DOTA_ModifyGold_CreepKill )  --金币奖励
-- 			SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, 500, nil)
-- 			--再返还500块钱
-- 			return
-- 		end
-- 		local abilityName = "Primary_laser"
-- 		local newAbility = playerHero:AddAbility(abilityName)
-- 		newAbility:SetLevel(1)
-- 		--设置基础信息
-- 		newAbility.classlevel = 1
-- 		newAbility.level1_id = "Primary_laser"
-- 		newAbility.level2_id = "Middle_laser"
-- 		newAbility.level3_id = "Advanced_laser"
-- 		newAbility.to_level2_cost = 1000
-- 		newAbility.to_level3_cost = 1500
-- 		newAbility.upgrade_cost = 500
-- 		newAbility.totalcost = 500
-- 	end

-- end
function modifier_heroTalent_npc_dota_hero_tinker_4:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
	}
end




function modifier_heroTalent_npc_dota_hero_tinker_4:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) < 3 then
		return
	end
	if string.match(keys.ability:GetAbilityName(), "_laser") then
		return
	end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		local newCooldown = ability:GetCooldownTimeRemaining() - ability:GetSpecialValueFor("cooldown_reduction")
		
		ability:EndCooldown()
		if newCooldown>=0 then
			ability:StartCooldown(newCooldown)
		end
	end
end
