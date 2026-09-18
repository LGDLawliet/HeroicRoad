heroTalent_npc_dota_hero_terrorblade_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_2", "heroTalent/heroTalent_npc_dota_hero_terrorblade_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_2_effect", "heroTalent/heroTalent_npc_dota_hero_terrorblade_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_terrorblade_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_terrorblade_2"
end


modifier_heroTalent_npc_dota_hero_terrorblade_2 = class({})

function modifier_heroTalent_npc_dota_hero_terrorblade_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_terrorblade_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_terrorblade_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local playerHero = self:GetParent()
		if playerHero:HasAbility("Middle_metamorphosis") or playerHero:HasAbility("Advanced_metamorphosis") or playerHero:HasAbility("Primary_metamorphosis") then
			playerHero:ModifyGoldFiltered(750,true,DOTA_ModifyGold_CreepKill )  --金币奖励
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,unit, 750, nil)
			return
		end
		local abilityName = "Primary_metamorphosis"
		local newAbility = playerHero:AddAbility(abilityName)
		
		newAbility:SetLevel(1)

		--设置基础信息
		newAbility.classlevel = 1
		newAbility.level1_id = "Primary_metamorphosis"
		newAbility.level2_id = "Middle_metamorphosis"
		newAbility.level3_id = "Advanced_metamorphosis"
		newAbility.to_level2_cost = 1500*0.6
		newAbility.to_level3_cost = 2200*0.6
		newAbility.upgrade_cost = 750*0.6
		newAbility.totalcost = 750*0.6
	end

end
