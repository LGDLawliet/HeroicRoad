heroTalent_npc_dota_hero_bristleback = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bristleback", "heroTalent/heroTalent_npc_dota_hero_bristleback", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bristleback_effect", "heroTalent/heroTalent_npc_dota_hero_bristleback", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_bristleback:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bristleback"
end


modifier_heroTalent_npc_dota_hero_bristleback = class({})

function modifier_heroTalent_npc_dota_hero_bristleback:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_bristleback:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bristleback:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bristleback:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bristleback:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_bristleback:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local playerHero = self:GetParent()
		if playerHero:HasAbility("Middle_Bristle_Back") or playerHero:HasAbility("Advanced_Bristle_Back") then
			playerHero:SetAbilityPoints(playerHero:GetAbilityPoints()+2)
			playerHero:ModifyGoldFiltered(500,true,DOTA_ModifyGold_CreepKill )  --金币奖励
			SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, 500, nil)
			--再返还500块钱
			return
		end
		local ability = playerHero:FindAbilityByName("Primary_Bristle_Back")
		if ability  then
			local level = ability:GetLevel()-3
			if level>=0 then
				playerHero:SetAbilityPoints(playerHero:GetAbilityPoints()+2)
			else
				level = ability:GetLevel()
				if level==1 then
					ability:SetLevel(3)
				elseif level==2 then
					ability:SetLevel(3)
					playerHero:SetAbilityPoints(playerHero:GetAbilityPoints()+1)
				end
		
			end
			playerHero:ModifyGoldFiltered(500,true,DOTA_ModifyGold_CreepKill )  --金币奖励
			SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, 500, nil)
			--再返还500块钱
			return
		end
		local abilityName = "Primary_Bristle_Back"
		local newAbility = playerHero:AddAbility(abilityName)
		
		newAbility:SetLevel(3)
		--被动技能自动靠后
		if newAbility:IsPassive() then
			PassiveAbilitySwap(playerHero,abilityName) 
		end
		--设置基础信息
		newAbility.classlevel = 1
		newAbility.level1_id = "Primary_Bristle_Back"
		newAbility.level2_id = "Middle_Bristle_Back"
		newAbility.level3_id = "Advanced_Bristle_Back"
		newAbility.to_level2_cost = 1000
		newAbility.to_level3_cost = 1500
		newAbility.upgrade_cost = 500
		newAbility.totalcost = 500
	end

end
