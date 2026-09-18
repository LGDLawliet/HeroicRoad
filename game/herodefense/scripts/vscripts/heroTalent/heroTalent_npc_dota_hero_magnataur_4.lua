heroTalent_npc_dota_hero_magnataur_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_4", "heroTalent/heroTalent_npc_dota_hero_magnataur_4", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_4_effect", "heroTalent/heroTalent_npc_dota_hero_magnataur_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_magnataur_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_magnataur_4"
end


modifier_heroTalent_npc_dota_hero_magnataur_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_magnataur_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_magnataur_4:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_magnataur_4:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local playerHero = self:GetParent()
		if playerHero:HasAbility("Middle_cook") or playerHero:HasAbility("Advanced_cook") then
			playerHero:SetAbilityPoints(playerHero:GetAbilityPoints()+2)
			playerHero:ModifyGoldFiltered(500,true,DOTA_ModifyGold_CreepKill )  --金币奖励
			SendOverheadEventMessage(playerHero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,playerHero, 500, nil)
			--再返还500块钱
			return
		end
		local ability = playerHero:FindAbilityByName("Primary_cook")
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
		local abilityName = "Primary_cook"
		local newAbility = playerHero:AddAbility(abilityName)
		
		newAbility:SetLevel(3)
		--被动技能自动靠后
		if newAbility:IsPassive() then
			PassiveAbilitySwap(playerHero,abilityName) 
		end
		--设置基础信息
		newAbility.classlevel = 1
		newAbility.level1_id = "Primary_cook"
		newAbility.level2_id = "Middle_cook"
		newAbility.level3_id = "Advanced_cook"
		newAbility.to_level2_cost = 1000
		newAbility.to_level3_cost = 1500
		newAbility.upgrade_cost = 500
		newAbility.totalcost = 500

		self:StartIntervalThink(0.1)


		
	end

end



function modifier_heroTalent_npc_dota_hero_magnataur_4:OnIntervalThink()
	local parent = self:GetParent()
	parent:SetOriginalModel("models/override_model/magnataur/magnataur_1_set_000.vmdl")
	parent:UpdateOriginModel()
	self:StartIntervalThink(-1)
	local model = parent:FirstMoveChild()
	-- self.modelName = self.hero:GetModelName()
	local model_list = {}
	while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" then
			-- print(model)
			-- PrintTable(model)
			-- print(model:GetModelName())

			table.insert(model_list,model)
			
		end
		model = model:NextMovePeer()
	end
	for _, model in ipairs(model_list) do
		UTIL_Remove(model)
	end	
end

function modifier_heroTalent_npc_dota_hero_magnataur_4:OnWaveEnd()
	self:GetParent():AddItemByName("item_hd_star_mace_2")
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_5)
end


function modifier_heroTalent_npc_dota_hero_magnataur_4:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end

