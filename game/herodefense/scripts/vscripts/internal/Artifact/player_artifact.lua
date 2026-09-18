
player_artifact = player_artifact or  class( { })

require('internal/Artifact/artifact_funcs')
function player_artifact:init(bReload)
    print("player_artifact init")
	if not bReload then
        self.defaultArtifactSlot = 4
        self.playerArtifact = {}

		self.Staging_exp = {}
    end

    -- CustomGameEventManager:RegisterListener("TryTakeArtifact", function(...)
    --     return self:_TakePlayerArtifact(...)
    -- end)
	-- CustomGameEventManager:RegisterListener("TryClearArtifact", function(...)
    --     return self:_TryClearArtifact(...)
    -- end)
	CustomUIEvent("TryTakeArtifact", Dynamic_Wrap(self, "_TakePlayerArtifact"), self)
	CustomUIEvent("TryClearArtifact", Dynamic_Wrap(self, "_TryClearArtifact"), self)
	GameEvent("dota_player_gained_level", Dynamic_Wrap(self, "OnHeroLevelUp"), self)


	self.Drop_ArtifactChance_RuneUpgrade = {
		KeyValues.base_setting["Drop_ArtifactChance_RuneUpgrade"].value1,
		KeyValues.base_setting["Drop_ArtifactChance_RuneUpgrade"].value2,
		KeyValues.base_setting["Drop_ArtifactChance_RuneUpgrade"].value3,
		KeyValues.base_setting["Drop_ArtifactChance_RuneUpgrade"].value4,
		KeyValues.base_setting["Drop_ArtifactChance_RuneUpgrade"].value5,
		KeyValues.base_setting["Drop_ArtifactChance_RuneUpgrade"].value6,
	}
	self.Staging_exp_pct = KeyValues.base_setting["Staging_exp_pct"].value*0.01
	self.player_artifact_exp_bonus_wave_con = KeyValues.base_setting["player_artifact_exp_bonus_wave"].value   -- 每回合奖励圣物经验 基础
	self.player_artifact_exp_bonus_wave_index = KeyValues.base_setting["player_artifact_exp_bonus_wave"].value1  --每回合奖励圣物经验  每回合的指数

	


	self.artifact_drop = {}
	for key, value in pairs(KeyValues.palyer_artifactKV) do
		-- print("load 11111")
		if value.DropRule~="General" then
			goto continue
		end
		-- print("load 2222")
		if not value.weight or value.weight <= 0 then
			goto continue
		end
		-- print("load 3333")
		self.artifact_drop[key] = {
			weight = value.weight,
			DropWaveRangeFrom = value.DropWaveRangeFrom,
			DropWaveRangeEnd = value.DropWaveRangeEnd,
		}
		:: continue ::
	end
end

function player_artifact:_TakePlayerArtifact(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
  
    local artifactName = event_data.artifactName

    local player = PlayerResource:GetPlayer(nPlayerID)
    local hUnit = player:GetAssignedHero()
    if not hUnit then
        return
    end
    if type(hUnit._tEquipmentSlot) ~= "table" then
		hUnit._tEquipmentSlot = {}
	end
	local kv = KeyValues.palyer_artifactKV[artifactName]
	if not kv then
		return
	end
	-- local cost =kv.AurumCost--（花费）
	-- -- 活动，圣物黄金消费减半
	-- local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
	-- local now_gold = tonumber(map.playerinfo.gold)  --拿到当前的金币
	-- if cost>now_gold then
	-- 	SendCustomErrorToPlayer(nPlayerID,"Black_Market_spell_buy_failed_not_enough_good","General.Cancel")
	-- 	return
	-- end

	for iSlot, data in ipairs(hUnit._tEquipmentSlot) do
        local hItem = EntIndexToHScript(data.index or -1)
		if (IsValid(hItem)) and data.name==artifactName then
			SendCustomErrorToPlayer(nPlayerID,"HUD_player_artifact_same_artifact","General.Cancel")
			return
		end
    end
	local currentCount = 0
	for iSlot, data in ipairs(hUnit._tEquipmentSlot) do
        local hItem = EntIndexToHScript(data.index or -1)
		if (IsValid(hItem))  then
			currentCount = currentCount + 1
		end
    end
	if currentCount>=4 then
		SendCustomErrorToPlayer(nPlayerID,"HUD_player_artifact_max","General.Cancel")
		return
	end

	


	-- local newData ={
	-- 	token= _G.GAME_GLOBAL_KEY,
	-- 	playerInfo = {
	-- 		steamId = tostring(PlayerResource:GetSteamID(nPlayerID)),
	-- 		steamName = PlayerResource:GetSteamAccountID(nPlayerID),
	-- 		gold =-cost,
	-- 	}
	-- }
	-- local encoded = json.encode(newData)
	-- player_database:UpdateUserData_with_steamID_ReRoll(encoded)



    -- local artifact = playerHero:AddItemByName(artifactName)

    local hItem = CreateItem( artifactName, nil, nil )
    local hContainer = hItem:GetContainer()
	if IsValid(hContainer) then
		hContainer:Remove()
	end

    local hParent = hItem:GetParent()
	if IsValid(hParent) then
		hParent:TakeItem(hItem)
	end
	local _hItem = hUnit:GetItemInSlot(0)
	local bIsEquip = 0
	if IsValid(_hItem) then
		hUnit:SetStashEnabled(true)
		local iStash = -1
		for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
			local h = hUnit:GetItemInSlot(i)
			if not IsValid(h) then
				iStash = i
				break
			end
		end
		if iStash == -1 then
			hUnit:SetStashEnabled(false)
			return false
		end
		hUnit:TakeItem(_hItem)
		hUnit:AddItem(hItem)
		hUnit:SwapItems(hItem:GetItemSlot(), iStash)
		hUnit:SetStashEnabled(false)
		hUnit:AddItem(_hItem)
		if hItem:IsArtifactEquip() then
			bIsEquip = 1
		end
		hUnit:GameTimer(0.03, function()
			if IsValid(hItem) then
				hUnit:SetStashEnabled(true)
				hUnit:TakeItem(hItem)
				hUnit:SetStashEnabled(false)

				hItem:SetParent(hUnit, nil)
				CustomNetTables:SetTableValue("artifactParentRecord", tostring(hItem:entindex()),  {
					index=hUnit:entindex()
				})

				-- 符合装备等级才给modifier
				if bIsEquip==1 then

					hUnit:GameTimer(0.1, function()
						-- 等待客户端同步到施法者数据再给
						hItem:RefreshIntrinsicModifier()
					end)
				end
				
				-- 
				
				-- hUnit:CalculateItemProperties()
				hItem:SetCanBeUsedOutOfInventory(true)
				hItem:SetItemState(1)
			end
		end)
	else
		hUnit:SetStashEnabled(true)
		local iStash = -1
		for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
			local h = hUnit:GetItemInSlot(i)
			if not IsValid(h) then
				iStash = i
				break
			end
		end
		if iStash == -1 then
			hUnit:SetStashEnabled(false)
			return false
		end
		hUnit:AddItem(hItem)
		if hItem:IsArtifactEquip() then
			bIsEquip = 1
		end
		hUnit:SwapItems(hItem:GetItemSlot(), iStash)
		hUnit:SetStashEnabled(false)
		hUnit:GameTimer(0.03, function()
			if IsValid(hItem) then
				hUnit:SetStashEnabled(true)
				hUnit:TakeItem(hItem)
				hUnit:SetStashEnabled(false)

				hItem:SetParent(hUnit, nil)
				CustomNetTables:SetTableValue("artifactParentRecord", tostring(hItem:entindex()),  {
					index=hUnit:entindex()
				})
				if bIsEquip==1 then
					hUnit:GameTimer(0.1, function()
						-- 等待客户端同步到施法者数据再给
						hItem:RefreshIntrinsicModifier()
					end)
				end
				-- hUnit:CalculateItemProperties()
				hItem:SetCanBeUsedOutOfInventory(true)
				hItem:SetItemState(1)
			end
		end)
	end

    table.insert(hUnit._tEquipmentSlot,{
        index = hItem:entindex(),
        name = artifactName,
		bIsEquip = bIsEquip,

    })
	self:UpdateEquipmentSlot(hUnit)


end
function player_artifact:_TryClearArtifact(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
  
    local ClearIndex = event_data.ClearIndex
	local artifactName = event_data.name

    local player = PlayerResource:GetPlayer(nPlayerID)
    local hUnit = player:GetAssignedHero()
    if not hUnit then
        return
    end
    if type(hUnit._tEquipmentSlot) ~= "table" then
		hUnit._tEquipmentSlot = {}
	end



	-- SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")


	local itemData = hUnit._tEquipmentSlot[ClearIndex]
	if itemData then
		local hItem = EntIndexToHScript(itemData.index)
		if IsValid(hItem) and artifactName==hItem:GetAbilityName() then
			if artifactName == "item_hd_onlyone_effects" then
				local hModifier = hUnit:FindModifierByName("modifier_item_hd_onlyone_effects")
				if IsValid(hModifier) then
					hModifier:GoodBye()
				end
			end

			if type(hItem.GetIntrinsicModifierName) == "function" then
				local tModifiers = hUnit:FindAllModifiersByName(hItem:GetIntrinsicModifierName() or "")
				for k, hModifier in pairs(tModifiers) do
					if hModifier:GetAbility() == hItem then
						hModifier:Destroy()
					end
				end
			end
			hItem:SetParent(nil, nil)
			CustomNetTables:SetTableValue("artifactParentRecord", tostring(hItem:entindex()),  nil)

			UTIL_Remove(hItem)
	
			table.remove(hUnit._tEquipmentSlot,ClearIndex)
		end
		
	end

	self:UpdateEquipmentSlot(hUnit)
	


end

function player_artifact:UpdateEquipmentSlot(hUnit)
    for iSlot, data in ipairs(hUnit._tEquipmentSlot) do
        local hItem = EntIndexToHScript(data.index or -1)
		if not (IsValid(hItem) and hItem.IsItem and hItem:IsItem()) then
			hUnit._tEquipmentSlot[iSlot] = -1
		end
    end
	-- for iSlot, iItemIndex in pairs(hUnit._tEquipmentSlot) do
	-- 	local hItem = EntIndexToHScript(iItemIndex or -1)
	-- 	if not (IsValid(hItem) and hItem.IsItem and hItem:IsItem()) then
	-- 		hUnit._tEquipmentSlot[iSlot] = -1
	-- 	end
	-- end
	CustomNetTables:SetTableValue("equipment_slot", tostring(hUnit:entindex()), hUnit._tEquipmentSlot)

	
end

function player_artifact:OnChaoticEraWaveFinish()
	local wave = chaotic_era_spawner:GetCurrentWave()
	local bonus = self.player_artifact_exp_bonus_wave_con * math.pow(self.player_artifact_exp_bonus_wave_index,math.max(wave-1,0))

	
	--print("产生回合圣物经验：",bonus)

	player:EachPlayer(function(n, playerID)
		self:AddArtifactExp_Auto(playerID,bonus)
	end)

end


-- 随机发送圣物经验
function player_artifact:AddArtifactExp_Auto(nPlayerID,expValue)
	-- 小月卡加成：30%+持有小月卡人数x10%
	-- 中月卡加成：240%+持有中月卡人数x30%
	-- 大月卡加成：600%+大月卡x50%
	local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
	if map then
		local heroes = GetAllRealHeroes()
		local count_small = 0
		local count_big = 0
		for _,hero in pairs(heroes) do
			local playerid = hero:GetPlayerOwnerID()
			if playerid then
				local viptable = map[playerid].vip
				if viptable["Shop_artifact_bonus_exp"] then
					--有小月卡的人数
					count_small = count_small + 1
				end
				if viptable["Shop_artifact_bonus_exp_2"] then
					--有中月卡的人数
					count_big = count_big + 1
				end
				if viptable["Shop_artifact_bonus_exp_3"] then
					--有大月卡的人数
					count_big = count_big + 1
				end
			end
		end
		local bonus = 1
		local viptable = map[nPlayerID].vip
		if viptable["Shop_artifact_bonus_exp"] then
			--有小月卡，基础值30%，小月卡人数每人贡献10%
			bonus = bonus + 0.3 + count_small * 0.1
		end
		if viptable["Shop_artifact_bonus_exp_2"] then
			--有中月卡，基础值210%，中月卡人数每人贡献30%
			bonus = bonus + 2.1 + count_big * 0.3
		end
		if viptable["Shop_artifact_bonus_exp_3"] then
			--有大月卡，基础值600%，大月卡人数每人贡献50%
			bonus = bonus + 8.7 + count_big * 0.5
		end
		-- print("基础圣物经验"..expValue)
		expValue = expValue * bonus
		-- print("放大倍数"..bonus.."加成后经验"..expValue)
	end
	--国庆活动，经验总增30%
	--expValue = expValue * 1.3--劳动节活动 
	
	local Targetplayer = PlayerResource:GetPlayer(nPlayerID)
	if Targetplayer then
		local playerHero = Targetplayer:GetAssignedHero()   --由此拿到了玩家的英雄
		if playerHero then
			--圣物：破路成长指南,这里有一个假kv，需要对应他的exp_4记得改
			local book_100 = GetArtifactLevel(nPlayerID,"item_hd_exp_book_effects")
			if book_100 and book_100 >= 100 then
				expValue = expValue*1.2
			end
			local artifact_68 = playerHero:FindModifierByName("modifier_item_hd_exp_book_effects")
			if (not book_100 or book_100 < 100) and artifact_68 then
				if artifact_68.level >= 40 and artifact_68:GetStackCount() >= artifact_68.check4 then
					expValue = expValue*(1+artifact_68.exp_4*0.01)
					--print("圣物经验被破路成长指南增加！")
				end
			end
			--检查圣物列表
			local artifactList = {}
			if not playerHero._tEquipmentSlot then
				if not self.Staging_exp[nPlayerID] then
					self.Staging_exp[nPlayerID] = 0
				end
				self.Staging_exp[nPlayerID] = self.Staging_exp[nPlayerID] + self.Staging_exp_pct*expValue
				return
			end
			for iSlot, data in ipairs(playerHero._tEquipmentSlot) do
				local artifactName = data.name
				local level = GetArtifactLevel(nPlayerID,artifactName)
				print(artifactName.."的等级为"..level)
				if level < 100 then
					table.insert(artifactList,artifactName)
				end
			end
			if #artifactList<=0 then
				-- 如果没带任何圣物 则转化为暂存
				if not self.Staging_exp[nPlayerID] then
					self.Staging_exp[nPlayerID] = 0
				end
				self.Staging_exp[nPlayerID] = self.Staging_exp[nPlayerID] + self.Staging_exp_pct*expValue
				return
			end

			local bonus = expValue 
			if self.Staging_exp[nPlayerID] then
				-- 提取暂存经验
				bonus = bonus + self.Staging_exp[nPlayerID]
				self.Staging_exp[nPlayerID] = nil
			end

			-- 分配随机经验
			-- 本次分配会给最低圣物经验的圣物50%的经验 随后再平均分配
			if #artifactList>=2 then
				local targetArtifact
				for index, name in ipairs(artifactList) do
					if not targetArtifact then
						targetArtifact = name
					else
						if customDataManager:GetCurrentArtifactExp(nPlayerID,name)<customDataManager:GetCurrentArtifactExp(nPlayerID,targetArtifact) then
							targetArtifact = name
						end
					end
				end
				local _bonusExp = math.floor(bonus*0.5)
				bonus = bonus - _bonusExp
				self:AddArtifactExp(nPlayerID,targetArtifact,_bonusExp)

				local _pct = 1/(#artifactList-1)
				local each_bonus = math.floor(bonus*_pct+0.5)
				for index, name in ipairs(artifactList) do
					if name~=targetArtifact then
						self:AddArtifactExp(nPlayerID,name,each_bonus)
					end
				end
			else
				-- 全部分配到一个圣物上
				self:AddArtifactExp(nPlayerID,artifactList[1],math.floor(bonus))
			end
		
	
		end
		

	end
end







-- 为某件圣物经验
function player_artifact:AddArtifactExp(nPlayerID,artifactName,expValue)
	-- if chaotic_era_spawner:GetCurrentWave()>=33 then
	-- 	-- 防止结算冲突 到最后是预存
	-- 	customDataManager:ModifyPlayerArtifactExp_Final(nPlayerID,artifactName,expValue)
	-- end
	-- customDataManager:ModifyPlayerArtifactExp(nPlayerID,artifactName,expValue)

	customDataManager:ModifyPlayerArtifactExp_Final(nPlayerID,artifactName,expValue)
end

-- 生成或符石升级时  几率掉落圣物
function player_artifact:OnRuneDropOrUpgrade(rarity)
	local chance = self.Drop_ArtifactChance_RuneUpgrade[rarity]
	-- 困难模式总增：60%
	if chance then
		-- chance = chance*1.3--劳动节活动
		--print("圣物掉落开始，基础掉落率为"..chance)
		local heroes = GetAllRealHeroes()
		chance = chance*(1+(#heroes-1)*0.6)
		
		chance = chance * 1000 
		local roll = RandomInt(1, 100*1000)
		--print("判定阶段：chance=",chance)															
		--print("判定要求：roll=",roll)
		if chance>=roll then
			--print("圣物掉落成功")
			-- 掉落圣物  挑选一名随机玩家
			local bonusTable = {}
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
				local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
				local player = PlayerResource:GetPlayer(nPlayerID)
				if player and steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED  and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_DISCONNECTED   then
					--如果该名玩家在游戏内
					table.insert(bonusTable,nPlayerID)
				end
			end
			if #bonusTable<=0 then
				print("Error:没有任何玩家？")
				return
			end
			local nPlayerID = bonusTable[RandomInt(1, #bonusTable)] --幸运玩家产生了
			local wave = chaotic_era_spawner:GetCurrentWave()
			local bonusListReturn = {}  --总之先复制一个来备用

			local buffList = {}
			local totalWeight = 0
			for bonusName, value in pairs(self.artifact_drop) do
				-- 需要满足到达回合需求 且在等级要求区间内
				-- print("check开始")
				if value.weight and value.weight > 0 then
					-- print("checking 2")
					if value.DropWaveRangeFrom and value.DropWaveRangeFrom > wave then
						-- print("???????")
						goto continue
					end
					if value.DropWaveRangeEnd and value.DropWaveRangeEnd < wave then
						-- print("222")
						goto continue
					end
					-- print("checking 3")
					-- if removeList and removeList[bonusName] then
					-- 	goto continue
					-- end
					--print("weight判定完成")
					local data =table.shallowCopy(value)
					data.bonusName = bonusName
					totalWeight = totalWeight + value.weight
					data.weightRequire = totalWeight
					table.insert(buffList, data)
				end
				:: continue ::
			end

			-- print("11111111111111",#buffList)
			local iRandom = RandomInt(1, totalWeight) --生成权重
			for _, value in ipairs(buffList) do
				if iRandom <= value.weightRequire then
					-- print("22222222222222")
					local dropArtifactName = value.bonusName --掉落的圣物名
					local player = PlayerResource:GetPlayer(nPlayerID)
					local hero = player:GetAssignedHero()
					local hero_pos = hero:GetAbsOrigin()
					local weight = value.weight

					local effectname 
					local effectradius 
					if weight >= 90 then
						effectname = "particles/econ/events/killbanners/screen_killbanner_compendium16_triplekill.vpcf"--黄
						effectradius = 300
					elseif weight == 70 then
						effectname = "particles/econ/events/killbanners/screen_killbanner_compendium14_doublekill.vpcf"--紫
						effectradius = 500
					elseif weight == 50 then
						effectname = "particles/econ/events/killbanners/screen_killbanner_compendium14_triplekill.vpcf"--小蓝
						effectradius = 750
					elseif weight == 30 then
						effectname = "particles/econ/events/killbanners/screen_killbanner_compendium14_rampage.vpcf"--大蓝
						effectradius = 1000
					elseif weight <= 10 then
						effectname = "particles/econ/events/killbanners/screen_killbanner_compendium16_rampage.vpcf"--彩色
						effectradius = 1300
					end

					local effect_cast1 = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl(effect_cast1, 0, hero_pos)
					
					hero:GameTimer(4,function ()
						self:DropArtifact(nPlayerID,dropArtifactName)
						if effect_cast1 then
							ParticleManager:DestroyParticle(effect_cast1, false)
						end
						hero_pos = hero:GetAbsOrigin()
						-- 播放音效
						EmitSoundOnLocationWithCaster(hero_pos, "Hero_Crystal.CrystalNova", hero)
						-- 创建特效
						local particle0 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, hero)
						ParticleManager:SetParticleControl(particle0, 0, Vector(hero_pos.x, hero_pos.y, hero_pos.z+2000))
						ParticleManager:SetParticleControl(particle0, 1, Vector(hero_pos.x, hero_pos.y, hero_pos.z))
						ParticleManager:SetParticleControl(particle0, 2, Vector(hero_pos.x, hero_pos.y, hero_pos.z))
						ParticleManager:ReleaseParticleIndex(particle0)

						local particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",PATTACH_WORLDORIGIN,nil)
						ParticleManager:SetParticleControl(particle, 0, hero_pos)
						ParticleManager:SetParticleControl(particle, 1, Vector(1.3*effectradius, effectradius, effectradius))
						hero:GameTimer(3,function ()
						ParticleManager:DestroyParticle(particle, true)
						end)
					end)
					break
				end
			end






		end
	end
end


function player_artifact:DropArtifact(nPlayerID,dropArtifactName)
	-- 如果已解锁 那么转化为1000圣物经验
	

	if customDataManager:IsArtifactUnlock(nPlayerID,dropArtifactName) then
		customDataManager:ModifyPlayerArtifactExp_Final(nPlayerID,dropArtifactName,1000)

		local gameEvent = {}
		gameEvent["player_id"] = nPlayerID
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#HUD_ArtifactDrop_Exp"
		gameEvent["locstring_value"] = "#DOTA_Tooltip_ability_"..dropArtifactName
		gameEvent["locstring_value2"] = "1000"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	else
		customDataManager:UnlockArtifact(nPlayerID,dropArtifactName)


		local gameEvent = {}
		gameEvent["player_id"] = nPlayerID
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#HUD_ArtifactDrop"
		gameEvent["locstring_value"] = "#DOTA_Tooltip_ability_"..dropArtifactName
		FireGameEvent( "dota_combat_event_message", gameEvent )
		
	end

	
end
-- 强制解锁圣物 并覆盖经验
function player_artifact:ForceUnlockArtifactWithExp(nPlayerID,dropArtifactName,exp)
	customDataManager:ForceUnlockArtifactWithExp(nPlayerID,dropArtifactName,exp)
end

function player_artifact:OnHeroLevelUp(keys)
	local hUnit = EntIndexToHScript(keys.hero_entindex)
	local nPlayerID = keys.player_id
	if hUnit._tEquipmentSlot then
		for iSlot, data in ipairs(hUnit._tEquipmentSlot) do
			local hItem = EntIndexToHScript(data.index or -1)
			if IsValid(hItem) then
				if type(hItem.GetIntrinsicModifierName) == "function" then
					if hItem:IsArtifactEquip() then
						local pass = false
						local tModifiers = hUnit:FindAllModifiersByName(hItem:GetIntrinsicModifierName() or "")
						for k, hModifier in pairs(tModifiers) do
							if hModifier:GetAbility() == hItem then
								hModifier:ForceRefresh()
								pass = true
								break
							end
						end
						if pass==false then
							-- print("checking")
							data.bIsEquip = 1
							self:UpdateEquipmentSlot(hUnit)


		
							hUnit:GameTimer(0.1, function()
								-- 等待客户端同步到施法者数据再给
								
								hItem:RefreshIntrinsicModifier()
								
							end)
						end
					end
				end
			end
		end
	end
end

function player_artifact:OnArtifactExpChance(nPlayerID,name)
	local player = PlayerResource:GetPlayer(nPlayerID)
    local hUnit = player:GetAssignedHero()
    if not hUnit then
        return
    end
	if hUnit._tEquipmentSlot then
		for iSlot, data in ipairs(hUnit._tEquipmentSlot) do
			local hItem = EntIndexToHScript(data.index or -1)
			if IsValid(hItem) and hItem:GetAbilityName()==name then
				if type(hItem.GetIntrinsicModifierName) == "function" then
					if hItem:IsArtifactEquip() then
						local pass = false
						local tModifiers = hUnit:FindAllModifiersByName(hItem:GetIntrinsicModifierName() or "")
						for k, hModifier in pairs(tModifiers) do
							if hModifier:GetAbility() == hItem then
								hModifier:ForceRefresh()
								pass = true
								break
							end
						end
						if  pass==false then
			
							hUnit:GameTimer(0.1, function()
								-- 等待客户端同步到施法者数据再给
								hItem:RefreshIntrinsicModifier()
							end)
							data.bIsEquip = 1
							self:UpdateEquipmentSlot(hUnit)

						end
					end
					
				end
			end
		end
	end

end

return player_artifact