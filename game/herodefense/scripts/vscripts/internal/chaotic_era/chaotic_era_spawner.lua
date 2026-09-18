chaotic_era_spawner = chaotic_era_spawner or class({})
print("chaotic_era_spawner load....")

function chaotic_era_spawner:init(bReload)
    

    print("chaotic_era_spawner checking1111")
    if not bReload then
		print("chaotic_era_spawner checking2222")
		self.map_effect ={

		}
		
		self.phase_state = false  --是否暂停

		self.time_offest = 0  --时间偏移  暂停回合时会增加时间偏移量来确保怪的属性正确

		self.high_prioritySpellList = {}

		


		self.task_id = 1  --ID 自增
		self.task_modify_functionIndex = 1
		self.task_modify_functionList = {}  --队列修饰列表
		self.task_modify_callBackList = {}  --队列修饰列表

		self.task_activeModifyCallbackList = {} --激活的修饰回调
			-- 符石生成进度
		self.rune_progress = {
			level1 = {
				current = 0,
				require = KeyValues.base_setting["Rune_Progress_Base_Require"].value,
				count = 0,
				level = 1,
			},
			level2 = {
				current =0,
				require = KeyValues.base_setting["Rune_Progress_Base_Require"].value,
				count = 0,
				level = 2,
			},
			level3 = {
				current = 0,
				require = KeyValues.base_setting["Rune_Progress_Base_Require"].value,
				count = 0,
				level = 3,
			},
			level4 = {
				current = 0,
				require = KeyValues.base_setting["Rune_Progress_Base_Require"].value,
				count = 0,
				level = 4,
			},
			level5 = {
				current = 0,
				require = KeyValues.base_setting["Rune_Progress_Base_Require"].value,
				count = 0,
				level = 5,
			},
		}

		self.creep_list = {}
		self.spawnList = {}  --生成工厂单子
		self.Bosses = {}

		self.is_warning = false  --处于警告中
		self.warningTime =  KeyValues.base_setting["Chaotic_Era_Game_Fail_coutDown"].value  --警告时间
		self.warning_timer = 0 --失败时间
		self.init_waveTime = 0

		print("map_effectCounter=",self.map_effectCounter)
		self.map_effectCounter = 0

	
		

	
	end

	



	
	
	self.baseSpawnDelay = KeyValues.base_setting["Chaotic_Era_monster_spawn_delay"].value --基础的怪物生延迟
	self.Chaotic_Era_Task_Time_Require = KeyValues.base_setting["Chaotic_Era_Task_Time_Require"].value --选择
	self.Chaotic_Era_GetTalentRound = KeyValues.base_setting["Chaotic_Era_GetTalentRound"].value


	-- local kv =  KeyValues.chaotic_era_creep_attribute[UnitName]
	self.taskList = {}
	-- 生成总表
	local dataList = KeyValues.chaotic_era_creep_attribute
	for key, value in pairs(dataList) do
		self.taskList[key] =  table.shallowCopy(value)
	end

	self.taskGenetateCount= KeyValues.base_setting["Chaotic_Era_Task_Count"].value 
	self.taskSelected = {
		currentIndex = 0,
		list = {},
	}  --可选怪列表
	self.currentTaskIndex = 0  --当前征召索引

	self.middle_map_effect_round = KeyValues.base_setting["Chaotic_era_middle_map_effect_round"].value --中阶词条出现的回合数
	self.advanced_map_effect_round = KeyValues.base_setting["Chaotic_era_advanced_map_effect_round"].value --高阶词条出现的回合数


	-- 奖励神器出现的回合
	self.Bonus_artifact_wave1 = KeyValues.base_setting["Bonus_artifact_wave"].value1 
	self.Bonus_artifact_wave2 = KeyValues.base_setting["Bonus_artifact_wave"].value2 
	-- self.Bonus_artifact_wave3 = KeyValues.base_setting["Bonus_artifact_wave"].value3 
	-- self.Bonus_artifact_wave4 = KeyValues.base_setting["Bonus_artifact_wave"].value4

	CustomUIEvent("SelectTargetTask", Dynamic_Wrap(self, "_SelectTargetTask"), self)
	CustomUIEvent("SelectTargetBuffCard", Dynamic_Wrap(self, "_SelectTargetBuffCard"), self)
	CustomUIEvent("ModifyTaskData_Event", Dynamic_Wrap(self, "_ModifyTaskData_Event"), self)


 

end

function chaotic_era_spawner:Enable()
	print("enable.........")
	
	local playerCount = GetPlayerCount()
	self.chaoticEraSpawnerData = {
		max_wave = KeyValues.base_setting["Chaotic_Era_Final_Wave"].value,
		current_unit_count = 0,
		max_unit_count = KeyValues.base_setting["Chaotic_Era_max_monster"].value + KeyValues.base_setting["Chaotic_Era_bonus_monster_per_player"].value * (playerCount-1),
		wave_count = 0,
		failTimer =-1,
		Chaotic_Era_upgrade_attribute = KeyValues.base_setting["Chaotic_Era_upgrade_attribute"].value,
		Chaotic_Era_upgrade_progress = KeyValues.base_setting["Chaotic_Era_upgrade_progress"].value,
	}
	
	


	self:InitCardEffect(1)


	self:UpdateNetTable()






    ListenToGameEvent("entity_killed", Dynamic_Wrap(self,"OnChaoticEraEntityKilled"), self)


	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("chatoc_era_update_default"), function()
		self:DefaultThink_general(1)
		return 1
	end, 0)
end


-- 获取当前场上的敌人数量
function chaotic_era_spawner:GetPlayerMissingCount()
	local iMissingCount = 0
	for i = #self.creep_list, 1, -1 do
		local hUnit = self.creep_list[i]
		if IsValid(hUnit) and hUnit:IsAlive() then
			if not hUnit:IsOutOfGame() then
				iMissingCount = iMissingCount + 1
			end
			
		else
			table.remove(self.creep_list, i)
		end
	end
	return iMissingCount
end

-- 更新单位数量 改变网表
function chaotic_era_spawner:UpdateMonsterCount()
	local count = self:GetPlayerMissingCount()
	self.chaoticEraSpawnerData.current_unit_count = count
	self:UpdateNetTable()
end


-- 创建新单位
function chaotic_era_spawner:CreatePortalSpawner(data,Delay,Pos)
    local Team = DOTA_MONSTER_TEAM_NUMBER  

	local name = "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf"
	local nWarningFX = ParticleManager:CreateParticle( name, PATTACH_CUSTOMORIGIN, nil )  
	ParticleManager:SetParticleControl( nWarningFX, 0, Vector(Pos.x,Pos.y,Pos.z+100) )
	ParticleManager:SetParticleControl( nWarningFX, 2, Vector(Pos.x,Pos.y,Pos.z+100) )
	ParticleManager:SetParticleControl( nWarningFX, 6, Vector(Pos.x,Pos.y,Pos.z+100) )
	-- ParticleManager:SetParticleControl( nWarningFX, 1, Vector(100,100, 100 ) );
	Timers:CreateTimer(Delay, function()
		if Game_State:IsGameEnd() or self:IsInBossState() then
			ParticleManager:DestroyParticle(nWarningFX,false)
			return
		end


		for a=1, data.count do
			local unit = CreateUnitByName( data.UnitName, Pos , false, nil, nil, Team )

			if GetPlayerCount()~=0 then
				local modifier = unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1})
				if modifier then
					modifier:SetStackCount(GetPlayerCount()) --提供增益
				end
			end
			if data.id then
				unit.sChaoticEraID = data.id
			end
			unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.5}) --提供相位，防止卡位
			-- 词条：超级精英
			local heroes = GetAllRealHeroes()
			for _, hero in pairs(heroes) do
				local elite = hero:FindModifierByName("modifier_super_elite_debuff")
				if elite then
					local ability = unit:AddAbility("creep_special_gain_life_stealer_feast")
					if ability then
						ability:SetLevel(1)
					end
					local ability2 = unit:AddAbility("creep_special_gain_Perseverance2")
					if ability2 then
						ability2:SetLevel(1)
					end
					break
				end
			end
			--
			self:InitUnitAttribute(unit,data)
			for index, modifier in ipairs(data.modifierData) do
				unit:AddNewModifier(unit, nil, modifier, {})
			end
			
			table.insert(self.creep_list,unit)
		end
		--生成单位并记录到列表中
		ParticleManager:DestroyParticle(nWarningFX,false)
		self:UpdateMonsterCount()
		print("创建了一个新的乱纪元单位")
	end)
end

-- 乱纪元初始回合载入
function chaotic_era_spawner:InitFirstWave()
	self.init_waveTime = GameRules:GetGameTime()
	CustomNetTables:SetTableValue( "game_config", "chaoticEra_RecordTime", {time=self.init_waveTime} )

	-- 强制选天赋
	talentManager:OnFirstWaveStart()  --乱纪元天赋选择延后

	--Notifications:TopToAll({ text = "国庆活动开启中，期间圣物经验获取总增30%", duration = 10, style = { color = "white" } ,class="Fix_NotificationLine"})--劳动节活动
    print("wave get ready......")
    GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_Start_info1", 1, -1)
    Timers:CreateTimer(1, function()
        -- self:SendWaveInfo()
        GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_Start_info2", 1, -1)
        game_music:PlayStartMusic()
        game_event:PlayWaveMusic()
        Game_State:SetBattleState(true)  --设置当前状态——在战斗
        game_event:HeroWaveStartSetUp()
        game_event:OpenTPGate()
    end)

	local playerCount = GetPlayerCount()
	if true then
		local creepKV = self:GetUnitAttribute("id1")
		local spawnSpped =  creepKV.interval   --每几秒生成一只
	
		spawnSpped = spawnSpped / ( 1+  (playerCount-1)*KeyValues.base_setting["Chaotic_Era_bonus_monster_general_rate"].value)

		local bonusSpeed = GetGloabal_ChaoticEra__SpanSpeed()
		spawnSpped = spawnSpped / (1+bonusSpeed*0.01)


		self:InsertMonsterSpawn("id1",1,spawnSpped,RandomFloat(0.5, 3),-1,false,0,{})
		self:InsertMonsterSpawn("id2",1,spawnSpped,RandomFloat(0.5, 3),-1,false,0,{})
	end
	if true then
		local creepKV = self:GetUnitAttribute("id4")
		local spawnSpped =  creepKV.interval   --每几秒生成一只
	
		spawnSpped = spawnSpped / ( 1+  (playerCount-1)*KeyValues.base_setting["Chaotic_Era_bonus_monster_general_rate"].value)

		local bonusSpeed = GetGloabal_ChaoticEra__SpanSpeed()
		spawnSpped = spawnSpped / (1+bonusSpeed*0.01)


		self:InsertMonsterSpawn("id4",1,spawnSpped,RandomFloat(0.5, 3),-1,false,0,{})
	end
	if true then
		local creepKV = self:GetUnitAttribute("id3")
		local eliteSpawnSpeed = creepKV.interval/ ( 1+  (playerCount-1)*KeyValues.base_setting["Chaotic_Era_bonus_monster_general_rate"].value)
		local bonusSpeed = GetGloabal_ChaoticEra__SpanSpeed()
		eliteSpawnSpeed = eliteSpawnSpeed / (1+bonusSpeed*0.01)


		self:InsertMonsterSpawn("id3",1,eliteSpawnSpeed,0,-1,false,0,{})
	end
	


	
	-- 开启计时器来生成乱纪元小怪
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("chatoc_era_update"), function()
        self:DefaultThink(1)
        return 1
    end, 0)

	local freeSpellCount = KeyValues.base_setting["Chaotic_Era_InitSpellCount"].value
    player:EachPlayer(function(n, playerID)
        local Targetplayer = PlayerResource:GetPlayer(playerID)
        if Targetplayer then
            
            for i = 1, freeSpellCount, 1 do
                chaotic_era:GenerateSpellList_Genaral(playerID)
            end
        end
    end)
    

	-- talentManager:SpawnTalent____ChaoticEraMod()
	
end

-- 是否可以进度第一回合
function chaotic_era_spawner:CheckFirstWaveEnter()
	print("self.map_effectCounter=",self.map_effectCounter)
	if self.map_effectCounter<1 then
		return false
	end
	return true
end

function chaotic_era_spawner:GetCurrentWave()
	return  self.chaoticEraSpawnerData.wave_count
end


-- runeProgressKey是符石生成的速率 最大可以生成不朽等级
--  0.01的效率 到达1后可以生成一个符石
function chaotic_era_spawner:InsertMonsterSpawn(id,iCount,fInterval,fDelay,nPlaerId,bOnlyOnce,bounus_count,keys)
	local kv =  KeyValues.chaotic_era_creep_attribute[id]
	if not kv then
		print("重大错误：未能查询到单位的乱纪元属性kv，无法插入队列",id)
		return
	end
	local unitKv = KeyValues.UnitKV[kv.UnitName]


	local attribute_Index = 1
	local progress_Index = 1
	if keys.isUpgrade then
		-- print("1111111111111")
		attribute_Index = attribute_Index+self.chaoticEraSpawnerData.Chaotic_Era_upgrade_attribute*0.01
		progress_Index = progress_Index+self.chaoticEraSpawnerData.Chaotic_Era_upgrade_progress*0.01
	end
	if keys.attribute_index then
		attribute_Index = attribute_Index*keys.attribute_index
	end
	if keys.rune_progressIndex then
		-- print("222222222222")
		progress_Index = progress_Index*keys.rune_progressIndex
	end
	-- 修饰器加成
	local moveSpeedBonusPercentage = 1+GetGloabal_ChaoticEra__MoveSpeedPercentage()*0.01
	local attackDamageBonusPercentage = 1 +GetGloabal_ChaoticEra__AttackDamagePercentage()*0.01


	-- print("progress_Index=",progress_Index)
	-- 乱纪元怪物插入队列时的datacy
	local data = {
		id = id,
		taskId = self.task_id,
		UnitName = kv.UnitName,
		count = iCount or 1,
		interval = fInterval or -1,
		nextTime = GameRules:GetGameTime()+fInterval+(fDelay or 0),
		summonPlayerId = nPlaerId or -1,
		delOnSpawn = bOnlyOnce,
		bonus_count = bounus_count or 0,
		isCopy = false,

		-- 符石生成加成
		runeProgress = {
			level1 = (kv.RuneProgress_1 or 0)*progress_Index,
			level2 = (kv.RuneProgress_2 or 0)*progress_Index,
			level3 = (kv.RuneProgress_3 or 0)*progress_Index,
			level4 = (kv.RuneProgress_4 or 0)*progress_Index,
			level5 = (kv.RuneProgress_5 or 0)*progress_Index,
			
		},
		attribute = {
			baseHealth = kv.baseHealth,
			bonusHealth = kv.bonusHealth*attribute_Index,
			HealthPow = kv.HealthPow,
			baseAttackDamage = kv.baseAttackDamage*attackDamageBonusPercentage,
			bonusAttackDamage = kv.bonusAttackDamage*attribute_Index*attackDamageBonusPercentage,
			DamagePow = kv.DamagePow,
			bounty = kv.bounty,
			bonusBounty = kv.bonusBounty,
			move_speed =(unitKv['MovementSpeed'] or 100) * moveSpeedBonusPercentage
		},
		modifierData = {},
		modifyCallBackList = {},
		disableTimer = 0, --被遗忘时间 如果当前游戏时间小于这个值 那么只会产生符石进度 不会生成怪物
	}
	self.task_id = self.task_id + 1
	if keys.isUpgrade then
		local modifyKeys = {
			icon = "file://{images}/custom_game/chaotic_era/hud/artifact/super_summon.png",
			title = "HUD_Task_Upgtade",
			text = "HUD_Task_Upgrade_1_info",
			keys={
				upgrade_value = {
					text=self.chaoticEraSpawnerData.Chaotic_Era_upgrade_attribute,
					bLocalize = 0,
				},
				progress_bonus = {
					text=self.chaoticEraSpawnerData.Chaotic_Era_upgrade_progress,
					bLocalize = 0,
				},
			},
			callBackId = -1,
		}
		table.insert(data.modifyCallBackList,modifyKeys)

	end
	-- PrintTable(data.runeProgress)

	local modifiers = MODIFIER_GLOBAL_DUMMY:FindAllModifiers()
	for index, hModifier in ipairs(modifiers) do
		if IsValid(hModifier) and hModifier.ModifyTaskData then
			hModifier:ModifyTaskData(data)
		end
	end
	-- PrintTable("-------------")

	-- PrintTable(data.runeProgress)
	
	

	for i = 1, 10, 1 do
		local modifierName = "Chaotic_Era_modifier"..i
		if kv[modifierName] then
			table.insert(data.modifierData,kv[modifierName])
		end
	end


	self.chaoticEraSpawnerData.max_unit_count = self.chaoticEraSpawnerData.max_unit_count +bounus_count

	table.insert(self.spawnList,data)
	chaotic_era_spawner:UpdateSpawnList()



	local gameEvent = {}
	gameEvent["player_id"] = -1
	gameEvent["teamnumber"] = -1
	gameEvent["locstring_value"] = "#"..kv.UnitName
	if keys.isUpgrade then
		gameEvent["message"] = "#New_AdvancedTask_Added"
	else
		gameEvent["message"] = "#New_Task_Added"
	end
	
	FireGameEvent( "dota_combat_event_message", gameEvent )


end


function chaotic_era_spawner:CopySpawnData(data)
	

	local newData = {
		id = id,
		taskId = self.task_id,
		UnitName = data.UnitName,
		count = data.iCount or 1,
		interval = data.fInterval or -1,
		nextTime = GameRules:GetGameTime()+data.interval+(fDelay or 0),
		summonPlayerId = data.summonPlayerId or -1,
		delOnSpawn = data.bOnlyOnce,
		bonus_count = data.bonus_count or 0,
		isCopy = true,

		-- 符石生成加成
		runeProgress = {
			level1 = data.runeProgress.level1,
			level2 = data.runeProgress.level2,
			level3 = data.runeProgress.level3,
			level4 = data.runeProgress.level4,
			level5 = data.runeProgress.level5,
			
		},
		attribute = {
			baseHealth = data.attribute.baseHealth,
			bonusHealth = data.attribute.bonusHealth,
			HealthPow = data.attribute.HealthPow,
			baseAttackDamage = data.attribute.baseAttackDamage,
			bonusAttackDamage = data.attribute.bonusAttackDamage,
			DamagePow = data.attribute.DamagePow,
			bounty = data.attribute.bounty,
			bonusBounty = data.attribute.bonusBounty,
			move_speed =data.move_speed,
		},
		modifierData = data.modifierData,
		modifyCallBackList = data.modifyCallBackList,
		disableTimer = data.disableTimer, --被遗忘时间 如果当前游戏时间小于这个值 那么只会产生符石进度 不会生成怪物
	}
	self.task_id = self.task_id + 1



	self.chaoticEraSpawnerData.max_unit_count = self.chaoticEraSpawnerData.max_unit_count +data.bonus_count

	table.insert(self.spawnList,data)
	chaotic_era_spawner:UpdateSpawnList()



	local gameEvent = {}
	gameEvent["player_id"] = -1
	gameEvent["teamnumber"] = -1
	gameEvent["locstring_value"] = "#"..data.UnitName
	gameEvent["message"] = "#New_Task_Copied"
	
	FireGameEvent( "dota_combat_event_message", gameEvent )


end





function chaotic_era_spawner:UpdateSpawnList()
	CustomNetTables:SetTableValue( "game_config", "chaoticEra_spawnList", self.spawnList )
end

function chaotic_era_spawner:InsertMonsterSpawn__WithID(id,insertKeys)
	local kv =  KeyValues.chaotic_era_creep_attribute[id]
	if not kv then
		print("重大错误：未能查询到单位的乱纪元属性kv，无法插入队列",id)
		return
	end

	local playerCount = GetPlayerCount()
	local spawnSpped = kv.interval
	-- print("spawnSpped=",spawnSpped)
	spawnSpped = spawnSpped / ( 1+  (playerCount-1)*KeyValues.base_setting["Chaotic_Era_bonus_monster_general_rate"].value)
	local bonusSpeed = GetGloabal_ChaoticEra__SpanSpeed()
	spawnSpped = spawnSpped / (1+bonusSpeed*0.01)
	-- print("spawnSpped=",spawnSpped)
	if insertKeys.spawnIndex then
		-- spawnSpped = spawnSpped / (1+insertKeys.spawnIndex*0.01)
	end

	-- local keys = {
	-- 	attribute_index = insertKeys.attribute_index or 1,
	-- 	rune_progressIndex = insertKeys.rune_progressIndex or 1,

	-- }
	local count = kv.count or -1
	if insertKeys.overrideCount then
		count = insertKeys.overrideCount
	end
	local bonusCount = kv.bounus_count or 0
	if insertKeys.overrideBonusCount then
		bonusCount = insertKeys.overrideBonusCount
	end
	self:InsertMonsterSpawn(id,count,spawnSpped,RandomFloat(1, 5),-1,false,bonusCount,insertKeys)
	
end



-- 每秒计时器
function chaotic_era_spawner:DefaultThink(inteval)
	-- print(" thinkg 111111111")
	local time =  GameRules:GetGameTime()
	if Game_State:IsGameEnd() then
		-- 暂停孵化
		return
	end
	if self:IsInBossState() then
		return
	end
	if self:IsChaoticEraPhased() then
		return
	end
	-- print(" thinkg 222222222")
	for index, data in ipairs(self.spawnList) do
		if data.nextTime<=time then
			-- print("时间ok")
			-- 开始孵化流程
			data.nextTime = data.nextTime + data.interval
			if data.nextTime<=time then
				-- 标准化
				data.nextTime = time + data.interval
			end
			if data.disableTimer<time then
				-- 处于被遗忘阶段
				local pos = Myspawner:GetRandomSpawnPos()
				self:CreatePortalSpawner(data,self.baseSpawnDelay,pos)
			end
			
			self:UpdateRuneProgress(data)
			if data.delOnSpawn==true then
				-- 移除只生成一次的孵化订单
				table.remove(self.spawnList,index)
			end
		end
	end
	-- print(" thinkg 3333333333")
	local wave = math.floor((time-self.init_waveTime-self.time_offest)/60)
	if IsInToolsMode() then
		-- wave = wave + 10
	end
	if self.chaoticEraSpawnerData.wave_count~=wave then
		self.chaoticEraSpawnerData.wave_count = wave
		_G.GAME_ROUND = wave
		self:UpdateNetTable()
		self:OnChaoticEraRoundChange()
		-- 回合产生变化
	end
	-- print(" thinkg 4444444")
	self:CheckingTaskProgress(inteval)
	self:CheckingBuffCardProgress(inteval)
	self:UpdateNetTable__RuneProgress()
	-- print(" thinkg 555555555")
end

function chaotic_era_spawner:DefaultThink_general(inteval)
	self:UpdateNetTable()
	self:CheckingBuffCardProgress(inteval)
end








function chaotic_era_spawner:UpdateNetTable()
	if Game_State:IsGameEnd() then
		-- 游戏结束就没必要了
		return
	end

	local iMissingCount = self.chaoticEraSpawnerData.current_unit_count
	local iMaxMissingCount = self.chaoticEraSpawnerData.max_unit_count

	-- print("iMissingCount=",iMissingCount,iMaxMissingCount,self:CheckingAlive(),self.is_warning)
	if (iMissingCount >= iMaxMissingCount or self:CheckingAlive() )and not self.is_warning then
		self.is_warning = true
		self.warning_timer = GameRules:GetGameTime() + self.warningTime + GetGloabal_ChaoticEra__FailCountDown()
		self.chaoticEraSpawnerData.failTimer = self.warning_timer
		-- if IsValid(hHero) then
			GameRules:GetGameModeEntity():SetContextThink("MissingCount", function()
				-- print("检测游戏失败")
				if self:IsChaoticEraPhased() then
					return 0
				end
				if GameRules:GetGameTime() >= self.warning_timer then
					-- DotaTD:Defeat()
					print("self.warning_timer=",self.warning_timer)
					print("游戏失败")
					self:EndGameAndCreateBonus(false)
					return nil
				end
				return 0
			end, 0)
		-- end
	elseif (iMissingCount < iMaxMissingCount and not self:CheckingAlive()) and self.is_warning then
		self.is_warning = false
		self.warning_timer = 0
		self.chaoticEraSpawnerData.failTimer = -1
		if IsValid(GameRules:GetGameModeEntity()) then
			GameRules:GetGameModeEntity():SetContextThink("MissingCount", nil, 0)
		end
	end


	



	-- print("self.chaoticEraSpawnerData.failTimer=",self.chaoticEraSpawnerData.failTimer)

	CustomNetTables:SetTableValue( "game_config", "chaoticEraSpawnerData", self.chaoticEraSpawnerData )

end

function chaotic_era_spawner:CheckingAlive()

    for _, unit in pairs(_G.GAME_HERO_GROUP) do
        if unit:IsAlive() then
			return false
        end
    end
	return true

end

-- 是否触发了警戒线
function chaotic_era_spawner:IsWarning()
	if self.is_warning  then
		return true
	else
		return false
	end

end

-- 延迟所有生产任务一段时间
function chaotic_era_spawner:DelaySpawner(delay)
	for index, data in ipairs(self.spawnList) do
		data.nextTime = data.nextTime + delay
	end

end

-- 载入属性
function chaotic_era_spawner:InitUnitAttribute(unit,data)
	local wave = math.max(math.floor(self.chaoticEraSpawnerData.wave_count + GetGloabal_ChaoticEra__Wave_Bonus()), 1)

	local attribute = data.attribute
	-- local UnitName = unit:GetUnitName()
	-- 计算来自修饰器的增幅
	local keys = {
		unit = unit
	}
	local healthPercentage = math.max(1 - GetGloabal_ChaoticEra__HealthPercentageReduction_Mul(keys)*0.01,0.001)

	local health = (attribute.baseHealth + attribute.bonusHealth*wave) * math.pow(attribute.HealthPow,wave) 
	local kv = {
		health = math.min(    health  * healthPercentage               ,2147483646),
		attackDamage = ((attribute.baseAttackDamage + attribute.bonusAttackDamage*wave)* math.pow(attribute.DamagePow,wave)),
		bounty = (attribute.bounty + attribute.bonusBounty*wave),
	}
	
	if tModifierEvents and tModifierEvents[MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData] then
		local tModifiers = tModifierEvents[MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.AdvancedModifyChaoticEraSpwnData then
				hModifier:AdvancedModifyChaoticEraSpwnData(kv,unit)
			else
				table.remove(tModifiers, i)
			end
		end
	end





	unit:SetMaxHealth(1)
	unit:SetBaseMaxHealth(1)
	unit:SetBaseDamageMax(0)
	unit:SetBaseDamageMin(0)
	unit:SetBaseMoveSpeed(attribute.move_speed)
	
	unit:AddNewModifier(unit, nil, "modifier_chaotic_era_attribute", kv)
	unit:SetHealth(unit:GetMaxHealth())
	for index, value in ipairs(data.modifyCallBackList) do
		-- 触发修饰
		local callBackId = value.callBackId
		if self.task_activeModifyCallbackList[callBackId] then
			self.task_activeModifyCallbackList[callBackId](unit,kv)
		end
	end


end





-- 增加符石生成进度
function chaotic_era_spawner:UpdateRuneProgress(data)
	local heroes = GetAllRealHeroes()
	local progressBonus = 0
	local keys = data
	for _, hero in ipairs(heroes) do
		progressBonus = SubtractionMultiplicationPercentage(progressBonus, GetUnit_ChaoticEraRuneProgressBonus(hero,keys))
		-- progressBonus = progressBonus +  GetUnit_ChaoticEraRuneProgressBonus(hero,keys)  
	end
	progressBonus = progressBonus +  GetUnit_ChaoticEraRuneProgressBonus(MODIFIER_GLOBAL_DUMMY,keys)
	progressBonus = 1  + progressBonus*0.01

	-- print("progressBonus=",progressBonus)
	
	
	for key, value in pairs(self.rune_progress) do
		value.current = value.current + tonumber(data.runeProgress[key]) * progressBonus
		if value.current>= value.require then
			value.current = value.current - value.require
			value.count = value.count + 1  --增加一个符石奖励
			value.require = math.floor(value.require * KeyValues.base_setting["Rune_Progress_Base_Require_Pow"].value*100)/100
			
			self:OnRuneCreated(value.level)
			-- local string_list =  Split(key, "level")
			-- PrintTable(string_list)
			if value.count>=5 and value.level<5 then
				value.count = value.count -  5
				local nextLevel = value.level+1
				self.rune_progress["level"..nextLevel].count = self.rune_progress["level"..nextLevel].count + 1
				self:OnRuneCreated(nextLevel)
			end
		end
	end
	

end


function chaotic_era_spawner:AddRuneCount(level)
	local id = "level"..level
	if self.rune_progress[id] then
		self.rune_progress[id].count = self.rune_progress[id].count + 1
		self:OnRuneCreated(level)
		self:UpdateNetTable__RuneProgress()
	else
		print("增加符石数量失败 id=",id)
	end


end




-- 更新网表
function chaotic_era_spawner:UpdateNetTable__RuneProgress()
	CustomNetTables:SetTableValue( "game_config", "chaoticEra_RuneProgress", self.rune_progress )
end




-- 生成一组可选怪物
function chaotic_era_spawner:GenetateTask(bForceRefresh)

	if bForceRefresh then
		self.taskSelected.list = {

		}
	end
	if #self.taskSelected.list>=1 then
        -- 延迟一段时间后再次尝试即可
        Timers:CreateTimer(1, function()
			self:GenetateTask()
		end)
        return
    end
	if not bForceRefresh then
		self.currentTaskIndex = self.currentTaskIndex + 1
	end
	
	self.taskSelected.currentIndex = self.currentTaskIndex

	-- CustomGameEventManager:Send_ServerToAllClients( "RefreshTaskSelect", {})

	
	--self.taskSelected 
	self.taskSelected.list = {}
	local temporaryTaslkList = table.deepCopy(self.taskList)


	
	local bonusList = {}
    local totalWeight = 0
	-- PrintTable(temporaryTaslkList)
	-- print("------------")
	local function generateList()
		bonusList = {}
        totalWeight = 0
		for id, value in pairs(temporaryTaslkList) do
			-- print("checking")
			if value.wave_require and value.wave_require_end then
				--举例：下限回合6 > 当前回合（6）吗，不，所以添加入表
				if value.wave_require > self.chaoticEraSpawnerData.wave_count then
					goto continue;
				end
				--举例：上限回合12 <= 当前回合（12）吗，是，所以禁止入表
				if value.wave_require_end <= self.chaoticEraSpawnerData.wave_count then
					goto continue;
				end
			end

            if value.weight then
				-- print("插入")
                -- 满足所有条件 插入表
                local data = table.deepCopy(value)
                data.id = id
				data.weightRequire_min = totalWeight
                totalWeight = totalWeight + value.weight
                data.weightRequire = totalWeight
                table.insert(bonusList,data)
            end
            ::continue::
		end
		-- PrintTable(bonusList)
	end

    local heroes = GetAllRealHeroes()
	local selecterData = {}
	for _, hero in ipairs(heroes) do
		local id = hero:GetPlayerOwnerID()
		if id~=-1 then
			selecterData[tostring(PlayerResource:GetSteamAccountID(id))] = 0
		end
		
	end

	local shouldHide = 0
	if MODIFIER_GLOBAL_DUMMY:HasModifier("modifier_destiny_fade") then
		shouldHide = 1
	end
	
	for i = 1, self.taskGenetateCount, 1 do
		-- print("step 1")
		generateList()
        local iRandom = RandomInt(1, totalWeight) --生成权重
		-- print("iRandom=",iRandom)
        for _, value in ipairs(bonusList) do
            if iRandom>=value.weightRequire_min and  iRandom<=value.weightRequire then
				-- print("okkkkkkkkkkkk")
				-- local data = table.shallowCopy(value)
				-- PrintTable(data)
				local data = {
					id = value.id,
					UnitName = value.UnitName,
					count = value.count or 1,
					interval = value.interval or -1,
					bonus_count = value.bonusCount or 0,
					shouldHide = shouldHide,
					-- 符石生成加成
					runeProgress = {
						level1 = value.RuneProgress_1 or 0,
						level2 = value.RuneProgress_2 or 0,
						level3 = value.RuneProgress_3 or 0,
						level4 = value.RuneProgress_4 or 0,
						level5 = value.RuneProgress_5 or 0,
						
					},
					attribute = {
						baseHealth = value.baseHealth,
						bonusHealth = value.bonusHealth,
						HealthPow = value.HealthPow,
						baseAttackDamage = value.baseAttackDamage,
						bonusAttackDamage = value.bonusAttackDamage,
						DamagePow = value.DamagePow,
						bounty = value.bounty,
						bonusBounty = value.bonusBounty,

					},
					selecter = table.shallowCopy(selecterData), --选择了的玩家
					progress = 0,   --进度
					timer = 0, 
				}

				local playerCount = GetPlayerCount()
				local spawnSpped = value.interval / ( 1+  (playerCount-1)*KeyValues.base_setting["Chaotic_Era_bonus_monster_general_rate"].value)
				local bonusSpeed = GetGloabal_ChaoticEra__SpanSpeed()
				spawnSpped = spawnSpped / (1+bonusSpeed*0.01)
				data.interval = math.floor(spawnSpped*10)/10



                table.insert(self.taskSelected.list,data)
				temporaryTaslkList[value.id] = nil
                break
            end
        end

	end

	-- print("okk")

	CustomNetTables:SetTableValue( "game_config", "chaoticEra_TaskList", self.taskSelected )


end
-- 征召是否可刷新（如果处于冷却阶段无法刷新）
function chaotic_era_spawner:CheckTaskCanBeReroll()
	if #self.taskSelected.list>=1 then
		return true
	end
	return false
end

Task_Noraml = 1
Task_Advanced = 2
-- 有玩家选择了某项任务
function chaotic_era_spawner:_SelectTargetTask(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id
	local targetId = event_data.id
	for _, value in ipairs(self.taskSelected.list) do
		if value.id==targetId then
			if value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))]~=Task_Noraml and value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))]~=Task_Advanced then
				local gameEvent = {}
				gameEvent["player_id"] = nPlayerID
				gameEvent["teamnumber"] = -1
				gameEvent["message"] = "#HUD_ChaoticEra_PlayerSelectTask"
				FireGameEvent( "dota_combat_event_message", gameEvent )
			end
			value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))] = Task_Noraml
			if event_data.advanced and event_data.advanced==1 then
				value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))] = Task_Advanced
			end
			
		else
			value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))] = 0
		end
	end
	-- PrintTable(self.taskSelected)
	CustomNetTables:SetTableValue( "game_config", "chaoticEra_TaskList", self.taskSelected )
end








-- 检测进度
function chaotic_era_spawner:CheckingTaskProgress(inteval)
	local playerCount = GetPlayerCount()
	for _, value in ipairs(self.taskSelected.list) do
		local count = 0
		local advanced_select = 0
		-- print("1111111111")
		for key, value in pairs(value.selecter) do
			if value>=Task_Noraml then
				-- print("2222222")
				count = count + 1
				if value==Task_Advanced then
					advanced_select = advanced_select + 1
				end
			end
			
		end
		value.timer =value.timer +  inteval * (count/playerCount)
		value.progress = math.min(value.timer/ self.Chaotic_Era_Task_Time_Require,1)
		if value.timer>=self.Chaotic_Era_Task_Time_Require then
			print("选择ok")

			local isUpgrade = false
			if advanced_select>=(count*0.5) then
				print("怪物升阶已确立")
				isUpgrade = true
			end


			local spawnSpped = value.interval  --每几秒生成一只
			local keys = {
				isUpgrade = isUpgrade,
			}
			self:InsertMonsterSpawn(value.id,value.count,spawnSpped,RandomFloat(0.5, 3),-1,false,value.bonus_count,keys)
			
			self:UpdateNetTable()
			self.taskSelected.list = {}
			-- CustomGameEventManager:Send_ServerToAllClients( "RefreshTaskSelect", {})




			break
		end


	end

	CustomNetTables:SetTableValue( "game_config", "chaoticEra_TaskList", self.taskSelected )

end


-- 回合变化
function chaotic_era_spawner:OnChaoticEraRoundChange()
	if Game_State:IsGameEnd() then
		-- 防止重复结算
		return
	end
	if self:IsInBossState() then
		return
	end
	print("self.chaoticEraSpawnerData.max_wave=",self.chaoticEraSpawnerData.max_wave)
	if self.chaoticEraSpawnerData.wave_count>=self.chaoticEraSpawnerData.max_wave then
		-- TODO:击败boss后才能取胜
		self:EnterBossState()
		-- self:EndGameAndCreateBonus(true)
		return
	end
	if self.chaoticEraSpawnerData.wave_count%2==0 then
		game_event:FireWaveStart()
		game_event:FireWaveEnd()
	end
	-- 选怪废弃，变为随机出现怪物，详见modifier_diff_1/2/3/4
	-- if self.chaoticEraSpawnerData.wave_count%3==0 then
	-- 	self:GenetateTask()
	-- end
	-- 固定间隔的休息时间，休息时间需要和神器、diff等对齐
	if self.chaoticEraSpawnerData.wave_count%4==0 then
		self:PhaseChaoticEra(10)
	end
	-- 原10回合、20回合词条选择部分
	-- if self.middle_map_effect_round~=-1 and  self.chaoticEraSpawnerData.wave_count>=self.middle_map_effect_round then
	-- 	self:InitCardEffect(2)
	-- 	self.middle_map_effect_round = -1
	-- 	self:PhaseChaoticEra(60)

	-- elseif self.advanced_map_effect_round~=-1 and  self.chaoticEraSpawnerData.wave_count>=self.advanced_map_effect_round then
	-- 	self:InitCardEffect(3)
	-- 	self.advanced_map_effect_round = -1
	-- 	self:PhaseChaoticEra(60)
	-- end
	-- 原10回合、20回合神奇选择部分
	-- if self.Bonus_artifact_wave1~=-1 and  self.chaoticEraSpawnerData.wave_count>=self.Bonus_artifact_wave1 then
	-- 	self.Bonus_artifact_wave1 = -1
	-- 	player:EachPlayer(function(n, playerID)
	-- 		local Targetplayer = PlayerResource:GetPlayer(playerID)
	-- 		if Targetplayer then
	-- 			chaotic_era_shop:GenetateArtifactForPlayer(playerID,false)
	-- 		end
	-- 	end)
	-- end
	-- if self.Bonus_artifact_wave2~=-1 and  self.chaoticEraSpawnerData.wave_count>=self.Bonus_artifact_wave2 then
	-- 	self.Bonus_artifact_wave2 = -1
	-- 	player:EachPlayer(function(n, playerID)
	-- 		local Targetplayer = PlayerResource:GetPlayer(playerID)
	-- 		if Targetplayer then
	-- 			chaotic_era_shop:GenetateArtifactForPlayer(playerID,false)
	-- 		end
	-- 	end)
	-- end
	-- if  not self.talentInit  and self.chaoticEraSpawnerData.wave_count==self.Chaotic_Era_GetTalentRound then
	-- 	self.talentInit = true
	-- 	talentManager:SpawnTalent() 
	-- end

	
	player:EachPlayer(function(n, playerID)
        local Targetplayer = PlayerResource:GetPlayer(playerID)
        if Targetplayer then
			-- 每回合升1级
			local playerHero = Targetplayer:GetAssignedHero()   --由此拿到了玩家的英雄
			playerHero:HeroLevelUp(true)
			if self.chaoticEraSpawnerData.wave_count%2==0 then
				playerHero:HeroLevelUp(true)
			end
			-- 每回合获得1点商店经验
			chaotic_era_shop:UpgradePlayerShop(playerID)
			local data = chaotic_era_shop.baseConfig.playerShop[tostring(playerID)]
			-- if self.chaoticEraSpawnerData.wave_count%2==0 then
				if data.currentExp==0 and data.currentLevel~=chaotic_era_shop.baseConfig.chaoticEraShopMaxLevel then
					-- 每两回合刷新一次商店 如果经验是0且不是最高商店等级 说明刚升级商店 就不需要刷新商店
					print("刚升级商店无需刷新道具")
				else
					print("刷新装备")
					chaotic_era_shop:GenerateChaoticEraItem(playerID)
					chaotic_era_shop:OnShopRefreshed(playerID)
				end
			-- end

			if self.chaoticEraSpawnerData.wave_count%3==0 then
				chaotic_era:GenerateSpellList_Genaral(playerID)
			end

			local item = playerHero:FindItemInInventory("item_new_bottle")
			if item ~=nil then
				-- 恢复魔瓶
				local charge = item:GetCurrentCharges()
				if charge<item:GetBottleMaxCharge() then
					item:SetCurrentCharges(charge+1)
				end
	
			end

		end
	end)


	local keys = {
		round = self.chaoticEraSpawnerData.wave_count,

	}
	game_event:FireChaoticEraRoundChange(keys)
	player_artifact:OnChaoticEraWaveFinish()
	

end








-- 怪物死亡时刷新
function chaotic_era_spawner:OnChaoticEraEntityKilled( keys )
    local unit = EntIndexToHScript(keys.entindex_killed)
	self:UpdateMonsterCount()

end

function chaotic_era_spawner:ClearAllMonster()
	for i = #self.creep_list, 1, -1 do
		local hUnit = self.creep_list[i]
		if IsValid(hUnit) and hUnit:IsAlive() then
			hUnit:ForceKill(false)
		end
	end
end


-- 结算游戏奖励
function chaotic_era_spawner:EndGameAndCreateBonus(bSuccess)
	if Game_State:IsGameEnd() then
		-- 防止重复结算
		return
	end
	

	Game_State:SetGameEnd(true)
	self:ClearAllMonster()

	local goldBonus = 0
	local reliableExpBonus = 0
	-- 贪婪原效果cy
	-- local _modifier_greedy = MODIFIER_GLOBAL_DUMMY:FindModifierByName("modifier_greedy")
	-- if _modifier_greedy then
	-- 	goldBonus = goldBonus + _modifier_greedy:InitAurumBonus(#self.spawnList)
	-- end
	local modifiers = MODIFIER_GLOBAL_DUMMY:FindAllModifiers()
	for index, hModifier in ipairs(modifiers) do
		if IsValid(hModifier) and hModifier.UpdateGameSettlementData then
			hModifier:UpdateGameSettlementData(self.rune_progress)
		end
	end
	if bSuccess then
		-- 胜利符石奖励
		local bonusIndex =  KeyValues.base_setting["Chaotic_era_success_bonus_index"].value
		local heroes = GetAllRealHeroes()
		for _,hero in pairs(heroes) do
			local boss_rune = hero:FindModifierByName("modifier_boss_rune")
			if boss_rune then
				bonusIndex = boss_rune:GetStackCount()
			end
			break
		end
		print("游戏完成！巴尔的奖励修正为百分之"..bonusIndex)

		for key, value in pairs(self.rune_progress) do
			
			local currentCount = value.count
			value.count = value.count * (1+bonusIndex*0.01)
			if value.count%1>0 then
				local bonus = value.count%1*100
				if bonus>=RandomInt(1, 100) then
					value.count =  math.floor(value.count) + 1
				else
					value.count = math.floor(value.count)
				end
			end
			local addCount = currentCount - value.count
			if addCount>=1 then
				for i = 1, addCount, 1 do
					self:OnRuneCreated(value.level)
				end
			end

			
		end


		
	end

	

	-- 最后更新一下所有符石数量
	self:UpdateRuneCount()
	-- for key, value in pairs(self.rune_progress) do
	-- 	-- local string_list =  Split(key, "level")
	-- 	if value.count>=5 and value.level<5 then
	-- 		-- 满5进1  5个低级符石会变成一个高级的
	-- 		local nextCount = math.floor(value.count/5)
	-- 		value.count = value.count -  nextCount*5
	-- 		local nextLevel = value.level+nextCount
	-- 		self.rune_progress["level"..nextLevel].count = self.rune_progress["level"..nextLevel].count + nextCount
	-- 	end
	-- end
	self:UpdateNetTable__RuneProgress()

	-- 生成奖励
	local dataList = {

	}
	local rune_to_exp =  KeyValues.base_setting["Chaotic_Era_Rune_To_Exp"]
	local rune_to_aurum =  KeyValues.base_setting["Chaotic_Era_Rune_To_Aurum"]
	local rune_turn_1 =  KeyValues.base_setting["Rune_Del_return_1"]
	local rune_turn_2 =  KeyValues.base_setting["Rune_Del_return_2"]
	local rune_turn_3 =  KeyValues.base_setting["Rune_Del_return_3"]
	for key, value in pairs(self.rune_progress) do
		local string_list =  Split(key, "level")
		if value.count>=1 and tonumber(string_list[2])<=5 then
			table.insert(dataList,{
				count = value.count,
				rarity = tonumber(string_list[2]),
			})
		end
	end


	-- 发放奖励
	local playernumber = 0
	local progress = 0
	local runeCount = 0 --普通符石的计算量   一个罕见=5 稀有=25 神话=125  不朽=625


	for index, value in ipairs(dataList) do
		-- 计算经验与黄金奖励
		-- 2025-8-11：3级以下符石直接转化为经验和黄金
		reliableExpBonus = reliableExpBonus + value.count * (rune_to_exp["value"..value.rarity] or 0)
		goldBonus = goldBonus + value.count * (rune_to_aurum["value"..value.rarity] or 0)
		runeCount = runeCount + value.count * math.pow(5,value.rarity-1)
		print("原黄金"..goldBonus..",原经验"..reliableExpBonus)
		local currentRarity = 2
		local count = value.count
		local rarity = value.rarity
		for i = 1, 3, 1 do
			if rarity==currentRarity then
				if count>0 then
					if rarity == 3 then
						goldBonus = goldBonus + count*(rune_turn_3.value2 or 0)
						reliableExpBonus = reliableExpBonus + count*(rune_turn_3.value1 or 0)
						-- print("3级符石"..count"个，转化黄金"..count*(rune_turn_3.value2 or 0).."，转化经验"..count*(rune_turn_3.value1 or 0))
					elseif rarity == 2 then
						goldBonus = goldBonus + count*(rune_turn_2.value2 or 0)
						reliableExpBonus = reliableExpBonus + count*(rune_turn_2.value1 or 0)
						-- print("2级符石"..count.."个，转化黄金"..count*(rune_turn_2.value2 or 0).."，转化经验"..count*(rune_turn_2.value1 or 0))
					elseif rarity == 1 then
						goldBonus = goldBonus + count*(rune_turn_1.value2 or 0)
						reliableExpBonus = reliableExpBonus + count*(rune_turn_1.value1 or 0)
						-- print("1级符石"..count.."个，转化黄金"..count*(rune_turn_1.value2 or 0).."，转化经验"..count*(rune_turn_1.value1 or 0))
					end
				end
			end
			currentRarity = currentRarity - 1
		end
	end
	goldBonus = math.floor(goldBonus)
	reliableExpBonus = math.floor(reliableExpBonus)
	-- print("最终黄金"..goldBonus..",最终经验"..reliableExpBonus)
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		
		local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
		if steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED then
			playernumber = playernumber + 1
			
		end
	end
	

	local function CheckSettlementProgress()
		if progress>=playernumber  then
			local gameEvent = {}
			gameEvent["teamnumber"] = -1
			gameEvent["message"] = "#HUD_Settlement_Done"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end
	

	-- 结算
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		
		local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
		if bSuccess then
			customDataManager:ModifySingleCustomData(steamID,"chaotic_era_1",1,nil)
			customDataManager:ModifySingleCustomData(steamID,"chaotic_era_2",1,nil)
			customDataManager:ModifySingleCustomData(steamID,"chaotic_era_3",1,nil)
			customDataManager:ModifySingleCustomData(steamID,"chaotic_era_4",1,nil)
			customDataManager:ModifySingleCustomData(steamID,"chaotic_era_5",1,nil)
		end
		if steamID ~= "0" and PlayerResource:GetConnectionState(nPlayerID)~=DOTA_CONNECTION_STATE_ABANDONED then
			local data ={

				token = _G.GAME_GLOBAL_KEY,  --合法性
				runeInfos={},
				playerInfo ={
					steamId = steamID,
					reliableExp = reliableExpBonus,
					gold = goldBonus,
				}
			}
			-- self.high_prioritySpellList[playerID]
			-- 先结算高稀有度的 再结算低的
			-- 2025-8-11:不再发放稀有以下符石，转化为经验和黄金，成就相关仍然计算，或许后续需要修改
			local currentRarity = 5
			local rune_progress_count = 0 --符石大亨成就
			local base_rune_progress_count = 0 --踏实积累成就
			for i = 1, 5, 1 do
				for _, value in ipairs(dataList) do
					local count = value.count
					local rarity = value.rarity
					if rarity >= 4 and rarity==currentRarity then
						if count>0 then
							for i = 1, count, 1 do

								if self.high_prioritySpellList[nPlayerID] and #self.high_prioritySpellList[nPlayerID]>=1 then
									chaotic_era:CreateRune__WithName(data,nPlayerID,rarity,self.high_prioritySpellList[nPlayerID][1])
									table.remove(self.high_prioritySpellList[nPlayerID],1)
								else
									chaotic_era:CreateRandomRune(data,nPlayerID,rarity,true,true)
								end
								
							end
						end
					end
					
					
			
				end
				currentRarity = currentRarity - 1
			end
			for _, value in ipairs(dataList) do
				local count = value.count
				local rarity = value.rarity
				if rarity==5 then
					rune_progress_count = rune_progress_count + count*5
					base_rune_progress_count = base_rune_progress_count + count*25
					if count>=1 then
						customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_single_get_1",1,nil)
						customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_single_get_2",1,nil)
						customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_single_get_3",1,nil)
						if count>=2 then
							customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_single_get_4",1,nil)
						end
					end
				elseif rarity==4 then
					rune_progress_count = rune_progress_count + count
					base_rune_progress_count = base_rune_progress_count + count*5
					if count>=2 then
						customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_single_get_1",1,nil)
						if count>=4 then
							customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_single_get_2",1,nil)
						end
					end
				elseif rarity==3 then
					base_rune_progress_count = base_rune_progress_count + count
				end
				if rarity==currentRarity then
					if count>0 then
						for i = 1, count, 1 do

							if self.high_prioritySpellList[nPlayerID] and #self.high_prioritySpellList[nPlayerID]>=1 then
								chaotic_era:CreateRune__WithName(data,nPlayerID,rarity,self.high_prioritySpellList[nPlayerID][1])
								table.remove(self.high_prioritySpellList[nPlayerID],1)
							else
								chaotic_era:CreateRandomRune(data,nPlayerID,rarity,true,true)
							end
							
						end
					end
				end
				
				
		
			end
			if rune_progress_count>=1 then
				rune_progress_count = math.floor(rune_progress_count)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_1",rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_2",rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_3",rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_4",rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_5",rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_rune_6",rune_progress_count,nil)
			end
			if base_rune_progress_count>=1 then
				base_rune_progress_count = math.floor(base_rune_progress_count)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_base_rune_1",base_rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_base_rune_2",base_rune_progress_count,nil)
				customDataManager:ModifySingleCustomData(steamID,"chaotic_era_base_rune_3",base_rune_progress_count,nil)
			end
			
			
		   
			local encoded = json.encode(data)
			-- 2025-8-11：基于不朽符石数量发放技能书(TODO)
			local skillbook = 0
			for _, value in ipairs(dataList) do
				local count = value.count
				local rarity = value.rarity
				if rarity == 5 then
					skillbook = skillbook + count
				end
			end

			local function updateFinish(runeInfos)

				local runeList = chaotic_era:UpdateRuneData(nPlayerID,runeInfos)
				chaotic_era:UpdateRuneJsData(nPlayerID)
				-- PrintTable(runeInfos)
				local data = {
					sMessage={},
					playerinfo = {
						reliableExp = reliableExpBonus,
						gold = goldBonus,
					},
					runeList = runeList,
				}
				local player = PlayerResource:GetPlayer(nPlayerID) 
				CustomGameEventManager:Send_ServerToPlayer(player, "SetBonus", data)  --给出奖励提示
				progress = progress + 1
				CheckSettlementProgress()
				-- 更新货币
				local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]
				map.playerinfo.reliableExp = tonumber(map.playerinfo.reliableExp) + reliableExpBonus
				map.playerinfo.gold = tonumber(map.playerinfo.gold) + goldBonus
			end

			local bonus_ArtifactExp = KeyValues.base_setting["Chaotic_Era_Rune_To_ArtifactExp"].value * runeCount

			-- print("根据符石产生的经验=",bonus_ArtifactExp)
			player_artifact:AddArtifactExp_Auto(nPlayerID,bonus_ArtifactExp)
			-- TODO:更新技能书获取
			-- chaotic_era:RuneToSkillBook(nPlayerID, skillbook)
			if true then
				_G.Check_Settlement_Request[nPlayerID] = {
					base = false,          --基础数据
					customData = false,          --自定义数据
				}
				customDataManager:GameEndUpdateAllCustomData(nPlayerID) --进行数据更新
				local customDataList = customDataManager:CheckAllCustomData(nPlayerID)
				if customDataList then
					local customData_encoded = json.encode(customDataList)
					-- 发送数据
					player_database:SavePlayerCustomData(nPlayerID,customData_encoded,function ()
						chaotic_era:SaveNewRune(nPlayerID,encoded,function (runeInfos)
							updateFinish(runeInfos)
						end)
					end)
				else
					chaotic_era:SaveNewRune(nPlayerID,encoded,function (runeInfos)
						updateFinish(runeInfos)
					end)
	
				end

			end
			
		end
	end

	

	
end

function chaotic_era_spawner:UpdateRuneCount()
	for i = 1, 4, 1 do
		local data = self.rune_progress["level"..i]
		if data and data.count>=5  then
			-- 满5进1  5个低级符石会变成一个高级的
			local nextCount = math.floor(data.count/5)
			data.count = data.count -  nextCount*5
			local nextLevel = data.level+1
			self.rune_progress["level"..nextLevel].count = self.rune_progress["level"..nextLevel].count + nextCount
			self:OnRuneCreated(nextLevel)
		end
	end
end
-- 每个来自于游戏内符石的生成/升级
function chaotic_era_spawner:OnRuneCreated(rarity)
	player_artifact:OnRuneDropOrUpgrade(rarity)
end



-- 插入高优先级符石
function chaotic_era_spawner:InsetSpellRune_HighPriority(playerID,abilityName)
	if not self.high_prioritySpellList[playerID] then
		self.high_prioritySpellList[playerID] = {}
	end
	-- print("abilityName=",abilityName)
	-- print("playerID",playerID)
	table.insert(self.high_prioritySpellList[playerID],abilityName)
end
	

function chaotic_era_spawner:GetUnitAttribute(id)
	local kv = KeyValues.chaotic_era_creep_attribute[id]
	return kv
end







-- 初始化乱纪元词条
function chaotic_era_spawner:InitCardEffect(level)
	if not self.card_index then
		self.card_index = 0
	end
	self.card_index = self.card_index + 1



	self.map_effect = {
		-- selecter = {},
		-- timer = -1,
		list = {},
		level = level,
		card_index = self.card_index,
	}

    local kvList = table.shallowCopy(KeyValues.map_effect)  --总之先复制一个来备用
	local totalWeight = 0
    local bonusList  ={}  --这里面是可被生成出来的词条
    local heroes = GetAllRealHeroes()
	local selecterData = {}
	for _, hero in ipairs(heroes) do
		local id = hero:GetPlayerOwnerID()
		if id~=-1 then
			selecterData[tostring(PlayerResource:GetSteamAccountID(id))] = 0
		end
		-- 神谕天赋刷新
		local oracle_talent = hero:FindAbilityByName("heroTalent_npc_dota_hero_oracle_3")
		if oracle_talent and not oracle_talent.oracle_used and self.map_effect.level == 3 then
			oracle_talent:SetActivated(true)
		end
		
	end


    -- 生成一个表
    local function generateList()
		bonusList = {}
		totalWeight = 0 
        for bonusName, value in pairs(kvList) do
            if value.weight then
				if level==1 and value.disable_primary and value.disable_primary==1 then
					goto continue
				end
				if level==2 and value.disable_middle and value.disable_middle==1 then
					goto continue
				end
				if level==3 and value.disable_advanced and value.disable_advanced==1 then
					goto continue
				end
               
                local data = table.shallowCopy(value)
				data.weightRequire_min = totalWeight
				totalWeight = totalWeight + value.weight
                data.bonusName = bonusName
                data.weightRequire = totalWeight
                table.insert(bonusList,data)
            end

			::continue::
        end
	end

	local count = KeyValues.base_setting["Chaotic_era_primary_map_effect_count"].value
    local selectedCards = {}  -- 存储选中的卡片
    for i = 1, count, 1 do
        generateList()
        -- DeepPrint(bonusList)
        local iRandom = RandomInt(1, totalWeight) --生成权重
        for _, value in ipairs(bonusList) do
            if iRandom>=value.weightRequire_min and  iRandom<=value.weightRequire then
				local data = {
					name = value.bonusName,
					level = level,
					selecter = table.shallowCopy(selecterData), --选择了的玩家
					progress = 0,   --进度
					timer = 0,
                    weight = value.weight  -- 保存权重用于排序
				}
				table.insert(selectedCards, data)
				kvList[value.bonusName] = nil
                break
             end
        end
    end

    -- 按权重排序选中的卡片
    table.sort(selectedCards, function(a, b)
        return a.weight < b.weight
    end)

    -- 将排序后的卡片添加到map_effect.list中
    for _, card in ipairs(selectedCards) do
        table.insert(self.map_effect.list, card)
    end
	
	CustomNetTables:SetTableValue( "game_config", "chaoticEra_mapEffect", self.map_effect )
	
end

-- 选择乱纪元词条
function chaotic_era_spawner:_SelectTargetBuffCard(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id
	local target_name = event_data.name
	-- print("111111111111")
	if not self.map_effect.list then
		return
	end
	-- print("222222222222")
	-- self.map_effect = {
	-- 	selecter = {},
	-- 	timer = -1,
	-- 	list = {},
	-- 	level = level,
	-- }
	for _, value in ipairs(self.map_effect.list) do
		if value.name==target_name then
			value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))] = 1
		else
			value.selecter[tostring(PlayerResource:GetSteamAccountID(nPlayerID))] = 0
		end
	end
	CustomNetTables:SetTableValue( "game_config", "chaoticEra_mapEffect", self.map_effect )
end


-- 检测乱纪元进度
function chaotic_era_spawner:CheckingBuffCardProgress(inteval)
	if not self.map_effect.list then
		return
	end
	local playerCount = GetPlayerCount()
	
	for _, value in ipairs(self.map_effect.list) do
		local count = 0
		for key, value in pairs(value.selecter) do
			if value>=1 then
				count = count + 1
			end
			
		end
		value.timer =value.timer +  inteval * (count/playerCount)
		value.progress = math.min(value.timer/ self.Chaotic_Era_Task_Time_Require,1)
		if value.timer>=self.Chaotic_Era_Task_Time_Require then
			print("选择ok")
			-- 神谕天赋刷新
			local heroes = GetAllRealHeroes()
			for _, hero in ipairs(heroes) do
				local oracle_talent = hero:FindAbilityByName("heroTalent_npc_dota_hero_oracle_3")
				if oracle_talent then
					oracle_talent:SetActivated(false)
				end
			end
			local name = value.name
			KeyValues.map_effect[name].weight = 0  --在池子里移除这个词条
			local level = self.map_effect.level
			self.map_effect_record = self.map_effect_record or {}

			local data = {
				name = name,
				level = level,
			}
			table.insert(self.map_effect_record,data)
			CustomNetTables:SetTableValue( "game_config", "chaoticEra_mapEffect_record",self.map_effect_record )

	
			MODIFIER_GLOBAL_DUMMY:AddNewModifier(MODIFIER_GLOBAL_DUMMY, nil, "modifier_"..name, {level = level})
			self.map_effect = {}
			local gameEvent = {}
            gameEvent["player_id"] = -1
            gameEvent["teamnumber"] = -1
			gameEvent["locstring_value"] = "#"..name
			gameEvent["message"] = "#New_BuffCardInit"
            
            FireGameEvent( "dota_combat_event_message", gameEvent )
			self.map_effectCounter = self.map_effectCounter +1
		
			break
		end


	end

	CustomNetTables:SetTableValue( "game_config", "chaoticEra_mapEffect", self.map_effect )

end




-- 是否暂停了
function chaotic_era_spawner:IsChaoticEraPhased()
	local heroes = GetAllRealHeroes()
	for _, hero in ipairs(heroes) do
		local value = GetGloabal_ChaoticEra__Wave_Stop(hero)
		if value>=1 then
			return true
		end
	end

	
	return self.phase_state
end


-- 开启时停
function chaotic_era_spawner:PhaseChaoticEra(delay)
    if self.phase_state then
        -- 延迟一段时间后再次尝试即可
        Timers:CreateTimer(1, function()
			self:PhaseChaoticEra(delay)
		end)
        return
    end
	self.phase_state = true
	self.time_offest = self.time_offest + delay

	local modifier = MODIFIER_GLOBAL_DUMMY:AddNewModifier(MODIFIER_GLOBAL_DUMMY, nil, "modifier_time_stop_aura", {duration = delay})

    local gameEvent = {}
    -- gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["locstring_value"] = tostring(delay)
    gameEvent["message"] = "#HUD_ChaoticEra_Phase_with_delay"
    FireGameEvent( "dota_combat_event_message", gameEvent )

	


	modifier:SetEndCallback(function()
		self.phase_state = false
		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#HUD_ChaoticEra_Phase_end"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	
		
	end)

	
	for index, data in ipairs(chaotic_era_spawner.spawnList) do
		if data.nextTime then
			data.nextTime = data.nextTime + delay
		end
	end

end




function chaotic_era_spawner:PlayerGetGoldBounty(hero,bonus,ability)
	if not hero:IsRealHero() then
		local playerID = hero:GetPlayerOwnerID()
		local Targetplayer = PlayerResource:GetPlayer(playerID)
        if Targetplayer then
			hero = Targetplayer:GetAssignedHero() 
		end
	end
	-- print("1111111111111111")
	local bonusIndex = 1+GetGloabal_ChaoticEra__BountyBonus(hero)*0.01
	-- print("22222222")
	bonus = math.floor(bonus*bonusIndex)
	hero:ModifyGoldFiltered(bonus,true,DOTA_ModifyGold_CreepKill )  --金币奖励

end


-- 插入队列修饰
function chaotic_era_spawner:InsetTaskModifyOption(nPlayerID,keys,checkingCallback,delCallback,callBack)
	if not self.task_modify_functionList[nPlayerID] then
		self.task_modify_functionList[nPlayerID] = {
		}
	end
	self.task_modify_functionList[nPlayerID][tostring(self.task_modify_functionIndex)] = keys
	
	self.task_modify_callBackList[tostring(self.task_modify_functionIndex)] = {
		checkingCallback = checkingCallback,
		delCallback= delCallback,
		callBack = callBack,
	}
	self.task_modify_functionIndex = self.task_modify_functionIndex + 1
	local keyID = "chaotic_era_task_modify_"..nPlayerID
    CustomNetTables:SetTableValue( "chaoticEraData", keyID, self.task_modify_functionList[nPlayerID] )
end

-- 进行队列修饰
function chaotic_era_spawner:_ModifyTaskData_Event(eventSourceIndex, event_data)
	local nPlayerID = event_data.player_id
	local taskId = event_data.taskId
	local modifyId = event_data.modifyId
	if not self.task_modify_functionList[nPlayerID] then
		return
	end
	if not self.task_modify_functionList[nPlayerID][tostring(modifyId)]  then
		SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
        return
	end

	-- PrintTable(self.task_modify_callBackList)

	for index, data in ipairs(self.spawnList) do
		if data.taskId == taskId then
			print("找到目标队列")
			local callBackList = self.task_modify_callBackList[tostring(modifyId)]
			-- 检测是否目标可以被修饰
			if callBackList.checkingCallback then
				if not callBackList.checkingCallback(data) then
					return
				end
			end
			--那么成功 可以插入队列了
			-- data.modifyCallBackList
			local modifyKeys =  table.shallowCopy(self.task_modify_functionList[nPlayerID][tostring(modifyId)])

			modifyKeys.callBackId = tostring(modifyId)
			if callBackList.callBack then
				self.task_activeModifyCallbackList[tostring(modifyId)] = callBackList.callBack
			else
				modifyKeys.callBackId  = -1
			end
			table.insert(data.modifyCallBackList,modifyKeys)
			
			if true then
				local gameEvent = {}
				gameEvent["player_id"] = nPlayerID
				gameEvent["teamnumber"] = -1
				gameEvent["locstring_value"] = "#"..data.UnitName
				gameEvent["locstring_value2"] = "#"..modifyKeys.title
				gameEvent["message"] = "#HUD_Chaotic_Era_TaskModify_Active"
				FireGameEvent( "dota_combat_event_message", gameEvent )
			end

			if callBackList.delCallback and callBackList.delCallback() then
				self.task_modify_callBackList[tostring(modifyId)] = nil
				self.task_modify_functionList[nPlayerID][tostring(modifyId)] = nil
			end
			self:UpdateSpawnList()
			break
		end
	end


	local keyID = "chaotic_era_task_modify_"..nPlayerID
    CustomNetTables:SetTableValue( "chaoticEraData", keyID, self.task_modify_functionList[nPlayerID] )




	-- self.spawnList
	-- local data = {
	-- 	id = id,
	-- 	UnitName = kv.UnitName,
	-- 	count = iCount or 1,
	-- 	interval = fInterval or -1,
	-- 	nextTime = GameRules:GetGameTime()+fInterval+(fDelay or 0),
	-- 	summonPlayerId = nPlaerId or -1,
	-- 	delOnSpawn = bOnlyOnce,
	-- 	bonus_count = bounus_count or 0,

	-- 	-- 符石生成加成
	-- 	runeProgress = {
	-- 		level1 = (kv.RuneProgress_1 or 0)*progress_Index,
	-- 		level2 = (kv.RuneProgress_2 or 0)*progress_Index,
	-- 		level3 = (kv.RuneProgress_3 or 0)*progress_Index,
	-- 		level4 = (kv.RuneProgress_4 or 0)*progress_Index,
	-- 		level5 = (kv.RuneProgress_5 or 0)*progress_Index,
			
	-- 	},
	-- 	attribute = {
	-- 		baseHealth = kv.baseHealth,
	-- 		bonusHealth = kv.bonusHealth*attribute_Index,
	-- 		HealthPow = kv.HealthPow,
	-- 		baseAttackDamage = kv.baseAttackDamage*attackDamageBonusPercentage,
	-- 		bonusAttackDamage = kv.bonusAttackDamage*attribute_Index*attackDamageBonusPercentage,
	-- 		DamagePow = kv.DamagePow,
	-- 		bounty = kv.bounty,
	-- 		bonusBounty = kv.bonusBounty,
	-- 		move_speed =(unitKv['MovementSpeed'] or 100) * moveSpeedBonusPercentage
	-- 	},
	-- 	modifierData = {}
	-- }
end



-- 检测是否相同修饰词
function chaotic_era_spawner:CheckHaveSameIdKey(data, idKey)
	for index, value in ipairs(data.modifyCallBackList) do
		if value.idKey==idKey then
			return true
		end
	end
	return false
end




function chaotic_era_spawner:IsInBossState()
	if self.bInBossState then
		return  true
	end
	return false
end



function chaotic_era_spawner:EnterBossState()
	-- print("111111111111111111")
	if self.bInBossState then
		return
	end
	-- print("22222222222")
	self.bInBossState = true

	local gameEvent = {}
	gameEvent["player_id"] = -1
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#HUD_Chaotic_era_boss_warning"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	local function try_spawn_boss()
		local monster_number = self:GetPlayerMissingCount()
		if monster_number == 0 then

			local Team = DOTA_MONSTER_TEAM_NUMBER  
			local centerPos =  GetGroundPosition(Vector(0,0,0),nil)
			local Delay = 3

			local name = "particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_ambient.vpcf"
			local nWarningFX = ParticleManager:CreateParticle( name, PATTACH_CUSTOMORIGIN, nil )  
			ParticleManager:SetParticleControl( nWarningFX, 0, Vector(centerPos.x,centerPos.y,centerPos.z+100) )
			ParticleManager:SetParticleControl( nWarningFX, 0, Vector(500,1,1) )
			ParticleManager:SetParticleControl( nWarningFX, 2, Vector(centerPos.x,centerPos.y,centerPos.z+100) )
			ParticleManager:SetParticleControl( nWarningFX, 6, Vector(centerPos.x,centerPos.y,centerPos.z+100) )

			Timers:CreateTimer(Delay, function()
				ParticleManager:DestroyParticle(nWarningFX,false)
				local unit = CreateUnitByName( "npc_monster_boss_chaoc_form_real_one", centerPos , false, nil, nil, Team )
				if GetPlayerCount()~=0 then
					local modifier = unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1})
					if modifier then
						modifier:SetStackCount(GetPlayerCount()) --提供增益
					end
				end
				-- if data.id then
				-- 	unit.sChaoticEraID = data.id
				-- end
				local duration = 4
				unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.5}) --提供相位，防止卡位
				
				table.insert(self.Bosses,unit)

				local netTable = {}
				netTable[ "boss_ent_index" ] = unit:entindex()
				netTable["BossName"] = unit:GetUnitName()
				netTable["BossEntIndex"] = unit:entindex()
				netTable["BossIntroTime"] = duration
				netTable["CameraPitch"] = 40
				netTable["CameraDistance"] =1800
				netTable["CameraLookAtHeight"] = 400
				netTable["camera_yaw_rotate_speed"] = 0.1
				netTable["camera_inital_yaw"] = 345

				local units = FindUnitsInRadius( unit:GetTeamNumber(), unit:GetOrigin(), hBoss, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
				-- local hFriendlyHero = nil
				for _,unit in pairs ( units ) do
					if unit ~= nil and unit ~= hBoss then
						unit:AddNewModifier( hBoss, nil, "modifier_hd_boss_intro", { duration = duration } )
						-- if unit:IsRealHero() and unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						-- 	hFriendlyHero = unit
						-- end
					end
				end

				-- unit:AddNewModifier( hFriendlyHero, nil, "modifier_provide_vision", {} )
				unit:AddNewModifier(nil, nil, "modifier_hd_boss_intro", {duration=duration}) 
				unit:AddNewModifier( unit, nil, "modifier_followthrough", { duration = duration + 1.0 } )
				self:InitBossAttribute(unit)

				self.flBossIntroEndTime = GameRules:GetGameTime() + duration

				AddFOWViewer(DOTA_TEAM_GOODGUYS , Vector(0,-0,0), 1500, 10, false) --提供视野
				CustomGameEventManager:Send_ServerToAllClients( "boss_intro_begin", netTable )

				Timers:CreateTimer(duration, function()
					self:StartBossFight()
				end)
				-- self:InitUnitAttribute(unit,data)
				-- for index, modifier in ipairs(data.modifierData) do
				-- 	unit:AddNewModifier(unit, nil, modifier, {})
				-- end
			end)
		else
			return 0.5
		end
	end

	Timers:CreateTimer(try_spawn_boss)
end

function chaotic_era_spawner:StartBossFight()
	local weakTime = GameRules:GetGameTime() + KeyValues.base_setting["Chaotic_Era_Weak_Time"].value 
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("chatoc_era_CheckingBoss"), function()
		local count = 0
        for _,hBoss in pairs ( self.Bosses ) do
			count = count + 1
			if not IsValid(hBoss) or not hBoss:IsAlive() then
				count = count - 1
			end
		end
		if count<=0 then
			-- 结算游戏
			print("完成任务")
			self:EndGameAndCreateBonus(true)
			return nil
		else
			if GameRules:GetGameTime()>=weakTime then
				-- 添加虚弱buff
				local heroes = GetAllRealHeroes()
				for index, unit in ipairs(heroes) do
					unit:AddNewModifier(unit, nil, "modifier_chaotic_era_weak", {}) 
				end

				
			end
		end

        return 0.5
    end, 0)

	CustomGameEventManager:Send_ServerToAllClients( "boss_intro_end", netTable )	
	for _,hBoss in pairs ( self.Bosses ) do
		--hBoss:RemoveModifierByName( "modifier_boss_intro" 
		local hBuff = hBoss:FindModifierByName( "modifier_hd_boss_intro" )
		if hBuff then
			hBuff:SetDuration( 1.0, false )
		end
	end

	for nPlayerID = 0,DOTA_MAX_TEAM_PLAYERS-1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:RemoveModifierByName( "modifier_hd_boss_intro" )
		end

	end

	

	
end


-- 载入Boss属性
function chaotic_era_spawner:InitBossAttribute(unit)
	local wave = self:GetRuneCount()

	local kv = KeyValues.chaotic_era_boss_attribute
	local unitName = unit:GetUnitName()
	-- print("1111111111111111111111")
	if kv[unitName] then
		local attribute = kv[unitName]
		-- local UnitName = unit:GetUnitName()
		-- 计算来自修饰器的增幅
		-- local keys = {
		-- 	unit = unit
		-- }
		-- local healthPercentage = math.max(1 - GetGloabal_ChaoticEra__HealthPercentageReduction_Mul(keys)*0.01,0.001)
		local healthPercentage = 1
		-- print("22222222222222")
		local health = (attribute.baseHealth + attribute.bonusHealth*wave) * math.pow(attribute.HealthPow,wave) 
		local kv = {
			health = math.min(    health  * healthPercentage               ,2147483646),
			attackDamage = ((attribute.baseAttackDamage + attribute.bonusAttackDamage*wave)* math.pow(attribute.DamagePow,wave)),
			bounty = 0,
		}
		
		-- if tModifierEvents and tModifierEvents[MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData] then
		-- 	local tModifiers = tModifierEvents[MODIFIER_SPECIAL_ChaoticEra_MadifySpawnData]
		-- 	for i = #tModifiers, 1, -1 do
		-- 		local hModifier = tModifiers[i]
		-- 		if IsValid(hModifier) and hModifier.AdvancedModifyChaoticEraSpwnData then
		-- 			hModifier:AdvancedModifyChaoticEraSpwnData(kv,unit)
		-- 		else
		-- 			table.remove(tModifiers, i)
		-- 		end
		-- 	end
		-- end





		unit:SetMaxHealth(1)
		unit:SetBaseMaxHealth(1)
		unit:SetBaseDamageMax(0)
		unit:SetBaseDamageMin(0)
		-- unit:SetBaseMoveSpeed(attribute.move_speed)
		-- for index, value in ipairs(data.modifyCallBackList) do
		-- 	-- 触发修饰
		-- 	local callBackId = value.callBackId
		-- 	if self.task_activeModifyCallbackList[callBackId] then
		-- 		self.task_activeModifyCallbackList[callBackId](unit,kv)
		-- 	end
		-- end
		unit:AddNewModifier(unit, nil, "modifier_chaotic_era_attribute", kv)
		unit:SetHealth(unit:GetMaxHealth())
		-- print("33333333333333")
	end

	


end



function chaotic_era_spawner:GetRuneCount()
	local count = 0
	for key, value in pairs(self.rune_progress) do
		count = count + value.count * math.pow(5,value.level-1)
	end
	-- print("rune count=",count)
	return count
end



return chaotic_era_spawner

