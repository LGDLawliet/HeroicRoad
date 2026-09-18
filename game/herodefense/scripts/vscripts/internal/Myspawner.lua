


--v1.2
--created:2021.02.05
--使用此生成器生成的单位都会自动添加至怪物列表中，并由game_mode进行剩余判定，当_G.GAME_MONSTER_TABLE_number到达0且
--_G.GAME_MONSTER_Triger归零（所有生成已完毕）时进入下一波
require("internal/timers")


Myspawner = class({})
print("challenge load....")




--怪物列表
--地图-上古庭院
--包含：
--怪物名，每次生成数(min-max),生成次数，开始生成时间点，生成间隔,生成所需时间
-- name = "npc_monster_wave_1_1",  对应单位KV
-- number_min ='1',                一个传送门随机生成最小数量
-- number_max = '1',               一个传送门随机生成最大数量
-- wave = 80,                      生成波数
-- startTime = 10,                 回合开始后的第一次产卵时间 每1单位为1秒
-- interval = 1,                   产卵间隔
-- needTime = 5,                   孵化所需时间
-- StartPoint = 3,                 该组单位所在的坐标组（已弃用，改为随机产生点）
-- haveGain   = 1,                 该组单位是否获得难度增益
-- SpecialGain_index_min = 0,      该组单位词条系数最小值
-- SpecialGain_index_max = 50,     该组单位词条系数最大值
-- ------------------------------------------
--随机生成该局的怪物
function Myspawner:init(bReload)

    if not bReload then
		_G.GAME_Units = {}
		self.WaveId = {}
		--波数选择 每波给出几个可选 在里面随机
		local ROUND_UNITS_Ancient_Courtyard = {}
		-- local new_ROUND_UNITS_Ancient_Courtyard = {}
		local kv = KeyValues.general_wave_setting
		local wave_index = 1
		-- print("-----------------")
		while true do
			-- print("---------check--------")
			local data = {
				-- 存储一个回合的所有可能关卡的数据
			}
	
			for key, value in pairs(kv) do
				-- print("aaaaaaaaaaaaaaa")
				-- 拿到一行数据
				if value.Disable and value.Disable==1 then
					goto continue
				end
				if value.wave_count==wave_index then
					-- 如果这一行数据跟当前的回合索引匹配 那么则开始处理
					local pass = false
					for _, single_data in ipairs(data) do
						-- 检测是否已经有一组回合数据 如果有就插入 如果没有就新建
						if single_data.waveID==value.waveID then
							-- 如果已经建立 那就插进去
							pass = true
							table.insert(single_data,table.shallowCopy(value))
							break
						end
					end
					if not pass then
						-- 找不到数据 那就新建一组
						local newData = {
							waveID = value.waveID,
							wave_class = value.wave_class
						}
						table.insert(newData,table.shallowCopy(value))
						table.insert(data,newData)
					end
				end
				::continue::
			end
			DeepPrint(data)
			table.insert(ROUND_UNITS_Ancient_Courtyard,data)
			wave_index = wave_index + 1
			if wave_index>=26 then
				break
			end
		end
		--第4，8，14，18为精英  9 19为奖励  10 20为boss
		for i = 1, 25, 1 do
			local target_index = RandomInt(1, #ROUND_UNITS_Ancient_Courtyard[i])
			table.insert(_G.GAME_Units,ROUND_UNITS_Ancient_Courtyard[i][target_index])
			table.insert(self.WaveId,ROUND_UNITS_Ancient_Courtyard[i][target_index].waveID)
		end
	
		ROUND_UNITS_Ancient_Courtyard = nil

    end



end
function Myspawner:GetWaveID(wave)
	return self.WaveId[wave]
end

--怪物列表见最下

-- _G.GAME_ROUND = 0
-- _G.GAME_MONSTER_TABLE = {}
-- _G.GAME_MONSTER_TABLE_number = 0
-- _G.GAME_MONSTER_Triger = 0

--记录当前是否创建完所有单位
--如果全部创建完 则可以开启定时器以判断是否结束回合
_G.GAME_MONSTER_Triger_END_WAVE = false

VECTOR_FOR_SPAWNER={
    Vector(-672,-1700,128),
    Vector(-241,-2524,128),
    Vector(-346,-2588,128),
    Vector(-279,-1813,128),
}
--记录初始点



_G.GAME_START_POINT ={
	{-------------start_point_for_hero
	--_G.GAME_START_POINT[1][N].Vector
		{
			Vector =  Vector(-5655,5347,256),
		},
	},
		{-------------start_point_for_Crystal_Bridge
		--_G.GAME_START_POINT[2][N].Vector
		{
			Vector =  Vector(-3997,-2282,256),
		},
		{
			Vector = Vector(-3825,-2629,256),
		},
		{
			Vector = Vector(-3643,-3052,256),
		},
		{
			Vector = Vector(-3541,-3190,256),
		},
		{
			Vector = Vector(-4237,-2750,256),
		},
		{
			Vector = Vector(-4021,-2698,256),
		},
		{
			Vector = Vector(-3960,-3067,256),
		},
		{
			Vector = Vector(-3743,-2976,256),
		},
		{
			Vector = Vector(-3985,-2453,256),
		},
		{
			Vector = Vector(-3709,-3188,256),
		},
	},		
	{-------------start_point_for_Green_Bridge
         --_G.GAME_START_POINT[3][N].Vector
		 {
    		Vector = Vector(3416,-4965,256),
	    },
    	{
    		Vector = Vector(3822,-4729,256),
		},
		{
			Vector = Vector(4249,-4465,256),
		},
		{
			Vector = Vector(4492,-4081,256),
		},
		{
			Vector = Vector(4578,-3785,256),
		},
		{
			Vector = Vector(4108,-3957,256),
		},
		{
			Vector = Vector(3934,-4581,256),
		},

	},
			{-------------start_point_for_Void_Bridge
         --_G.GAME_START_POINT[4][N].Vector
		 {
			Vector = Vector(3909,2560,256),
		},
		{
			Vector = Vector(4364,1820,256),
		},
		{
			Vector = Vector(4351,2373,256),
		},
		{
			Vector = Vector(4445,1642,256),
		},
		{
			Vector = Vector(3787,2059,256),
		},
		{
			Vector = Vector(4427,1573,256),
		},
		{
			Vector = Vector(4547,2393,256),
		},
		{
			Vector = Vector(3974,2611,256),
		},
		{
			Vector = Vector(4422,1760,256),
		},
	},

}



--创建传送门
--传入数据，生成单位名，延迟，数量，位置，所属团队（默认是badguys）传送门大小 是否获得增益  词条min系数 词条max系数  苦难等级
function CreatePortalSPawner(UnitName,Delay,Number,Pos,Team,side,gain,min_index,max_index,gain_class,challenge_level,endlessLevel,health_bar_type,endlessWave)
	if Team == nil then
		Team = DOTA_MONSTER_TEAM_NUMBER  
	end

	local name = "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf"
	if side and side>=400 then
		name = "particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_ambient.vpcf"
	end
	local nWarningFX = ParticleManager:CreateParticle( name, PATTACH_CUSTOMORIGIN, nil )  
	ParticleManager:SetParticleControl( nWarningFX, 0, Vector(Pos.x,Pos.y,Pos.z+100) )
	ParticleManager:SetParticleControl( nWarningFX, 2, Vector(Pos.x,Pos.y,Pos.z+100) )
	ParticleManager:SetParticleControl( nWarningFX, 6, Vector(Pos.x,Pos.y,Pos.z+100) )
	ParticleManager:SetParticleControl( nWarningFX, 1, Vector(side,side, side ) );
	Timers:CreateTimer(Delay, function()
		for a=1, Number do
			local unit = CreateUnitByName( UnitName, Pos , false, nil, nil, Team )
			--添加苦难等级
			if challenge_level then
				unit.challenge_level = challenge_level
			end
			if endlessLevel then
	

				unit.endlessLevel = endlessLevel
			end

			-- print(_G.Game_Creeps_Gain)
			--已转移到公共事件
			if GetPlayerCount()~=0 and gain ~= 0 then
				local modifier = unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1})
				if modifier then
					modifier:SetStackCount(GetPlayerCount()) --提供增益
				end
			end
			unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.5}) --提供相位，防止卡位
			unit:AddNewModifier(nil, nil, "modifier_chaotic_era_buffskill_fix", {})
			if  health_bar_type and health_bar_type>=1 then
				unit:AddNewModifier(unit, nil, "modifier_health_bar", {health_bar_type=health_bar_type})
			end
			if _G.GAME_DIFFICULTY~=0 and gain ~= 0 then
				local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
				ability:SetLevel(_G.GAME_DIFFICULTY)
				-- ability:SetHidden(true)
			end
			if GetChallengeDifficulty()~=0 and gain ~= 0 then
				local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
				ability:SetLevel(GetChallengeDifficulty())
				-- ability:SetHidden(true)
			end
			--词条处理
			if GetChallengeDifficulty()>=1 then
				local table = CreateSpecialGainForUnit(unit,min_index,max_index,gain_class,endlessWave)  --为产生的单位添加词条
				-- Boss_entry_send(table)
				-- print("已发送")
			end


			
			_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
			unit = nil
		end
		--生成单位并记录到列表中
		_G.GAME_MONSTER_Triger = _G.GAME_MONSTER_Triger -1 --生成器完成，使数字减1
		_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + Number
		ParticleManager:DestroyParticle(nWarningFX,false)
		-- ParticleManager:ReleaseParticleIndex(nWarningFX)
		print("create units success")

		if _G.GAME_MONSTER_Triger == 0 then
			--全部单位创建完毕
			_G.GAME_MONSTER_Triger_END_WAVE = true


			--在非工具模式下将移除表以节约资源
			if not IsInToolsMode() and not _G.GAME_debugTesting then
				--10秒后移除第一个table以节约空间
				Timers:CreateTimer(10, function()
					table.remove(_G.GAME_Units,1)
				end)
			end
	
			
			print("All units have been created")

			local time = 0
			--由于未知原因使得回合不结束 可能怪物卡位 也可能死了没计算 添加了以下计时器
			--产生计时器 如果搜寻不到单位 即可结束回合
            Timers:CreateTimer(0.5, function()
				time = time +0.5
				local heroes = GetAllRealHeroes()
				local caster = heroes[1]
				local nearby_enemy_units = FindUnitsInRadius(
					caster:GetTeamNumber(), 
					Vector(0,0,0) , 
					nil, 
					50000, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , 
					FIND_CLOSEST, 
					false
				)
				local alive = 0
				local nearby_friendly_units = FindUnitsInRadius(
					caster:GetTeamNumber(), 
					Vector(0,0,0) , 
					nil, 
					50000, 
					DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , 
					FIND_CLOSEST, 
					false
				)
				--对于敌军
				for _, unit in pairs(nearby_enemy_units) do
					if unit:IsAlive() and not unit:HasModifier("modifier_thinker_INVULNERABLE") then
						--当长时间不结束 将野怪重置位置
						if time >=600 then
							unit:SetOrigin(Vector(0,0,256))
							unit:AddNewModifier(nil, nil, "modifier_phased", {duration=1.5}) --提供相位，防止卡位
							GameRules:SendCustomMessage("count + 1", 1, -1)
						end
						alive = alive +1
					end
					
				end


				--对于友军
				for _, unit in pairs(nearby_friendly_units) do
					if unit:IsAlive() and unit:GetUnitName()=="npc_monster_wave_9_1" then
						--当长时间不结束 将野怪重置位置
						if time >=600 then
							unit:SetOrigin(Vector(0,0,0))
							unit:AddNewModifier(nil, nil, "modifier_phased", {duration=1.5}) --提供相位，防止卡位
						end
						alive = alive +1
					end
					
				end


				if time >=600 then
					GameRules:SendCustomMessage("DOTA_CUSTOM_Wave_Start_reset", 1, -1)
					time = 0
				end

				if _G.GAME_MONSTER_Triger_END_WAVE==false then
					heroes = nil
					caster = nil
					nearby_enemy_units = nil
					nearby_friendly_units = nil
					alive = nil
					time = nil
					return nil
				end
				print("alive ="..alive)
				if alive==0 then
					game_event:EndWave_And_Create_Bonus()
				end

				heroes = nil
				caster = nil
				nearby_enemy_units = nil
				nearby_friendly_units = nil
				alive = nil
				return 0.5



            end)

			--所有怪产生
		end
		-- hPortalEnt:ForceKill(false)
	end)
end
-- _G.Game_Player_Number = 0
-- _G.Game_Creeps_Gain = 0
-- GameRules:GetGameTime() + 
GAME_ENDLESS_BOSS ={
	"npc_monster_challenge_001",
	"npc_monster_challenge_002",
	"npc_monster_challenge_003",
	"npc_monster_challenge_005",
	"npc_monster_challenge_004",
	"npc_monster_challenge_006",
	"npc_monster_challenge_007",
	"npc_monster_challenge_008",
	"npc_monster_challenge_009",

}
GAIN_CLASS_ENDLESS = 8
function WaveStart_ON()
	print(_G.GAME_ROUND)
	print("_G.GAME_END_WAVE=".._G.GAME_END_WAVE)
	print(_G.GAME_END_WAVE_Trigger)
	if _G.GAME_ROUND>_G.GAME_END_WAVE and _G.GAME_END_WAVE_Trigger==true  then
		local pos_index = 2  --产生传送门数
		pos_index = math.min(math.max(pos_index,GetPlayerCount()+1),4)
		_G.GAME_MONSTER_Triger = 99999
		local wave = _G.GAME_ENDLESS_WAVE

		--基准4秒一个怪。从这里开始给英雄上虚弱，为防止没挂上，一开始在unit_event里面就要给上，这里只是打开开关
		--20分钟计时，计时完毕后死亡。15分钟开始衰弱
		local base_interval = 4
		local heroes = GetAllRealHeroes()
		for _, hero in pairs(heroes) do
			local endless_tired = hero:FindModifierByName("modifier_hd_endless_tired")
			if endless_tired and _G.GAME_CHANLLENGE_Contest_Type == 2 then
				endless_tired:SetStackCount(0)
				endless_tired:SetDuration(1200,true)
				endless_tired:StartIntervalThink(1)
			end
		end
		-- print("开始无尽")
		Timers:CreateTimer(base_interval, function()	
			local side = 300
			local number = 1 --设置怪物生成数量
			local min_index = 1000  --词条强化最小系数
			local max_index =1000  --词条强化最大系数
			local gain_class = GAIN_CLASS_ENDLESS           --词条库
			local health_bar_type = 0
			CreatePortalSPawner("npc_monster_wave_33_1",1,number,
			_G.GAME_START_POINT[RandomInt(2, pos_index)][RandomInt(1, 7)].Vector,--这是坐标点 第一个随机是哪个区域（水晶，森林，虚空），第二个参数随机1-7，然后取表中的KV
			nil,side,0,--生成传送门
			min_index,max_index,        --词条强化最小系数与最大系数
			gain_class,             --词条的库
			4,  --难度系数，通常由苦难挑战添加
			nil,
			0,--血条类型
			wave--无尽波数
			) --生成传送门
			if wave~= 0 and wave%20==0 then
				local level = wave/10
				-- 月底上限
				-- if wave>=150 then
				-- 	level =level + (wave-150)/15
				-- 	if wave>=450 then
				-- 		level =level+ (wave-450)/10
				-- 	end
				-- end
				CreatePortalSPawner(GAME_ENDLESS_BOSS[RandomInt(1, #GAME_ENDLESS_BOSS)],1,1,_G.GAME_START_POINT[RandomInt(2, pos_index)][RandomInt(1, 7)].Vector,
				nil,side,0,min_index,max_index,gain_class,nil,level,nil,wave)
			end
			wave = wave +1

			local units = FindUnitsInRadius(
				DOTA_MONSTER_TEAM_NUMBER , 
				Vector(0,0,0) , 
				nil, 
				50000, 
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , 
				FIND_ANY_ORDER, 
				false
			)
			if #units <= 1 then
				return 0.7
			elseif #units<=3 then
				return 1.2
			elseif #units<=5 then
				return 1.7
			elseif #units<=9 then
				return 2.5
			end
			return 3
		end)
	else
		--在非工具模式下将移除表以节约资源
		--移除表操作位于CreatePortalSPawner(...)中
		local gameWave_index = 1
		local pos_index = 2  --产生传送门数
		pos_index = math.min(math.max(pos_index,GetPlayerCount()+1),4)
		if IsInToolsMode() or _G.GAME_debugTesting then
			gameWave_index = _G.GAME_ROUND
		end
		print("gameWave_index="..gameWave_index)
		for i=1,   #_G.GAME_Units[gameWave_index] do  --由此获取到了当前波数需要生成的类的数量
		
			local num = i
			local time = {}
			local first = _G.GAME_Units[gameWave_index][num].startTime - _G.GAME_Units[gameWave_index][num].interval

			for i = 1, _G.GAME_Units[gameWave_index][num].wave do    --由此计算出了怪物传送门出现时间点
				time[i] =first + _G.GAME_Units[gameWave_index][num].interval*i*_G.GAME_internal_index
			end
			for a=1, _G.GAME_Units[gameWave_index][num].wave do  --开始安排队列
				
				Timers:CreateTimer(time[a], function()
					-- print("go into next...")
					if not _G.GAME_Units[gameWave_index][num] then
						return
					end
					local side = 300
					local number = RandomInt(tonumber(_G.GAME_Units[gameWave_index][num].number_min), tonumber(_G.GAME_Units[gameWave_index][num].number_max))  --设置怪物生成数量
					local min_index = _G.GAME_Units[gameWave_index][num].SpecialGain_index_min  --词条强化最小系数
					local max_index = _G.GAME_Units[gameWave_index][num].SpecialGain_index_max  --词条强化最大系数
					local gain_class = _G.GAME_Units[gameWave_index][num].gain_class            --词条库
					local health_bar_type = 0
					if _G.GAME_Units[gameWave_index][num].have_health_bar then
						health_bar_type = _G.GAME_Units[gameWave_index][num].health_bar_type or 0
					end

					if _G.GAME_Units[gameWave_index][num].side ~=nil then
						side = _G.GAME_Units[gameWave_index][num].side
					end
					CreatePortalSPawner(_G.GAME_Units[gameWave_index][num].name,_G.GAME_Units[gameWave_index][num].needTime,number,
					_G.GAME_START_POINT[RandomInt(2, pos_index)][RandomInt(1, 7)].Vector,--这是坐标点 第一个随机是哪个区域（水晶，森林，虚空），第二个参数随机1-7，然后取表中的KV
					nil,side,_G.GAME_Units[gameWave_index][num].haveGain,--生成传送门
					min_index,max_index,        --词条强化最小系数与最大系数
					gain_class,             --词条的库
					_G.GAME_Units[gameWave_index][num].challenge_level,  --难度系数，通常由苦难挑战添加
					nil,
					health_bar_type  --血条类型
					) --生成传送门

				end)
				_G.GAME_MONSTER_Triger = _G.GAME_MONSTER_Triger + 1 --记录这个传送门，生成结束后再-1
			end
			--完成生成队列排序，进入下一个排列

			-- print("fnish"..num)
		end
	end

	
	--所有排列设置完成
	-- print("set up finished")
	-- print("total Portals:".._G.GAME_MONSTER_Triger)
	

end

--词条产生系数
-- _G.GAME_CHANLLENGE_GAIN_INDEX

--强化词条产生
--参数：单位 单位词条min系数 单位词条max系数  词条库
---comment
---@return table
function CreateSpecialGainForUnit(unit,min_index,max_index,gain_class,endlessWave)
	if fellOmen and _G.GAME_Reincarnation_Wave >=1 then --如果在百相模式九触发一下百相逻辑
		fellOmen:MonsterSpawn(unit,min_index,max_index)
	end
	local difficulty_GAIN_INDEX = GetChallengeDifficulty()*0.2   --难度系数
	local unit_GAIN_INDEX = RandomInt(min_index, max_index)      --单位系数
	local gain_index = difficulty_GAIN_INDEX*unit_GAIN_INDEX     --计算词条值
	local gain_amount = gain_index/100
	local gain_table = {}
	gain_amount = gain_amount-gain_amount%1    --整数化
	gain_index = gain_index - gain_amount*100  --得出剩余的数值
	--概率加一
	if gain_index>=RandomInt(1, 100) then
		gain_amount = gain_amount +1
	end
	if gain_amount<=0 then
		return gain_table
	end
	-- print("b")
	local gain_library = table.shallowCopy(Special_Gain_Library[gain_class])
	-- table.insert(gain_library,Special_Gain_Library[gain_class])
	-- gain_library = Special_Gain_Library[gain_class]  --拿到词条库进行处理
	-- PrintTable(gain_library)  --打印一次
	local Counttable = {
		1,
		3,
		4,
	}

	-- print("create gain_amount with "..gain_amount)
	-- print("GetChallengeDifficulty()]="..GetChallengeDifficulty())
	gain_amount = math.min(gain_amount,Counttable[GetChallengeDifficulty()])
	-- print("create gain_amount with "..gain_amount)
	-- print("create gain with "..gain_amount)


	for i = 1, gain_amount, 1 do
		-- print("give gain")
		local target_index = RandomInt(1, #gain_library)
		-- print(gain_library[target_index])  --打印技能名
		local newAbility = unit:AddAbility(gain_library[target_index])  --添加技能
        newAbility:SetLevel(1)
		-- print("give gain end ")
		table.remove(gain_library,target_index)  --从表里移除以不随机到重复的
		-- print("remove")
		table.insert(gain_table,gain_library[target_index])
	end

	gain_library = nil
	if gain_class==GAIN_CLASS_ENDLESS and endlessWave and endlessWave>=300 then
		-- if not unit:HasAbility("creep_special_gain_axe_culling_blade") then
		-- 	local newAbility = unit:AddAbility("creep_special_gain_axe_culling_blade")  --添加技能
        -- 	newAbility:SetLevel(1)
		-- end
		-- if endlessWave>=400 and 30>=RandomFloat(1, 100) then
		-- 	local newAbility = unit:AddAbility("creep_special_gain_pierce_the_veil")  --添加技能
        -- 	newAbility:SetLevel(1)
		-- end
		

		
	end

	return gain_table
	
	
end



function Myspawner:CheckAliveToEndGame()
	local heroes = GetAllRealHeroes()
	local caster = heroes[1]
	local nearby_enemy_units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		Vector(0,0,0) , 
		nil, 
		50000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , 
		FIND_CLOSEST, 
		false
	)
	local alive = 0
	local nearby_friendly_units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		Vector(0,0,0) , 
		nil, 
		50000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , 
		FIND_CLOSEST, 
		false
	)
	--对于敌军
	for _, unit in pairs(nearby_enemy_units) do
		if unit:IsAlive() and not unit:HasModifier("modifier_thinker_INVULNERABLE") then
			alive = alive +1
		end
	end
	--对于友军
	for _, unit in pairs(nearby_friendly_units) do
		if unit:IsAlive() and unit:GetUnitName()=="npc_monster_wave_9_1" then
			alive = alive +1
		end
		
	end
	return alive
end

function Myspawner:GetRandomSpawnPos()
	--注解：下面这个玩意会在1~5人时返回2，3，4，4，4，2是左下口，3是右下口，4是上口，将mathmin后面最后这个4更改为2，3，就可以限制多人的出怪口
	local pos_index = math.min(math.max(2,GetPlayerCount()+1),3)
	return _G.GAME_START_POINT[RandomInt(2, pos_index)][RandomInt(1, 7)].Vector
end



Special_Gain_Library = {
	--class 1
	--词库分类：所有低阶怪物
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		--"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		--"creep_special_gain_StatusGain_reduce",      --福佑损毁
		--"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		--"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		--"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		--"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		--"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		--"creep_special_gain_back",--新增：回光返照
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改

	},
		--class 2
	--词库分类：带技能伤害的 低阶怪物
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		--"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		--"creep_special_gain_StatusGain_reduce",      --福佑损毁
		--"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		--"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		--"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		--"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		--"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		--"creep_special_gain_back",--新增：回光返照
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改
		
	},
		--class 3
	--词库分类：小型统领
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		--"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		"creep_special_gain_StatusGain_reduce",      --福佑损毁
		"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		--"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		----"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		--"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		"creep_special_gain_back",--新增：回光返照
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改
	},
			--class 4
	--词库分类：带伤害技能的 小型统领
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		--"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		"creep_special_gain_StatusGain_reduce",      --福佑损毁
		"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		--"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		----"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		--"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		"creep_special_gain_back",--新增：回光返照
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改
	},
		--class 5
	--词库分类：精英单位
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		--"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		--"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		--"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		--"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		"creep_special_gain_StatusGain_reduce",      --福佑损毁
		"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		--"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		----"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		--"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		"creep_special_gain_back",--新增：回光返照
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改
	},
		--class 6
	--词库分类：带技能伤害的精英单位
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		--"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		--"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		--"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		--"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		"creep_special_gain_StatusGain_reduce",      --福佑损毁
		"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		--"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		----"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		--"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		"creep_special_gain_back",--新增：回光返照
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改
	},
	--class 7
	--词库分类：BOSS
	{
		"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		"creep_special_gain_Agility_Gain",    --加速 突破移速
		--"creep_special_gain_Damage_Gain",     --绿字攻击力
		--"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		-- "creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		--"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		--"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		--"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		--"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_Perseverance2",       --坚毅2
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		--"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		--"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：40%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		"creep_special_gain_StatusGain_reduce",      --福佑损毁
		"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		--"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		----"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		--"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		"creep_special_gain_back",--新增：回光返照
		--"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		----"creep_special_gain_act1_oil",-- 赛季1:焦油改
		----"creep_special_gain_act1_angry",-- 赛季1：我怒了改
	},
		--class 8
	--词库分类：无尽怪
	{
		--"creep_special_gain_Energy_Gain",     --重做完成：+200%血量，受到伤害+1%易伤
		"creep_special_gain_Agility_Gain",    --加速 突破移速
		"creep_special_gain_Damage_Gain",     --绿字攻击力
		"creep_special_gain_Rage",            --暴躁 暴击
		"creep_special_gain_Armor_Gain",      --重做完成：物理减伤15%，破坏后+20%，可以破坏
		"creep_special_gain_Shrink",          --100护甲 -400移动速度
		"creep_special_gain_nihility",        --重做完成：特殊虚无，可以破坏，可以沉默
		"creep_special_gain_phase",           --相位
		"creep_special_gain_insulator",        --重做完成：魔法减伤15%，破坏后+20%，可以破坏
		--"creep_special_gain_heal_suppression_aura", --失效力场
		"creep_special_gain_heal_death_delay",   --重做完成：背水一战，绿魂
		--"creep_special_gain_gods_bless",  --重做完成：亡语持续治疗强驱散
		"creep_special_gain_soul_transfer",  --重做完成：20%最大生命值，10%基础攻击力移魂
		-- "creep_special_gain_mana_gain",          --魔力特化
		"creep_special_gain_shallow_grave",    --薄葬
		"creep_special_gain_enraged",   --重做完成，现在吃50%正面，40%进入狂暴，可强驱散，可以破坏
		--"creep_special_gain_good_climber",  --攀爬好手
		"creep_special_gain_last_word",   --重做完成，亡语魔耗增加100%，可弱驱散
		--"creep_special_gain_saurian_fasciculus",  --束缚
		"creep_special_gain_Perseverance",       --坚毅
		"creep_special_gain_bloodseeker_bloodrage", --重做完成，破坏倒计时，范围破坏，可强驱散，可以破坏
		--"creep_special_gain_earthshaker_echo_slam",  --反分裂领域
		--"creep_special_gain_life_essence",           --重做完成，获得伤害来源的50%最大生命值
		--"creep_special_gain_vengefulspirit_command_aura",  --重做完成：10%不被修正的伤害亡语，附加4秒禁疗，可弱驱散，可以破坏
		--"creep_special_gain_life_stealer_feast", --盛宴
		"creep_special_gain_counterspell",         --重做完成：30%技能减伤，抵挡一次指向性后失效
		-- "creep_special_gain_counterspell_reflect",   --法术抵抗
		"creep_special_gain_eva_Gain",            --模糊
		"creep_special_gain_StatusGain_reduce",      --福佑损毁
		"creep_special_gain_StatusNegativeGain_reduce", --诅咒损毁
		"creep_special_gain_LifeStealGain_reduce",      --嗜血损毁
		"creep_special_gain_Invalidation_of_split_attack",      --分裂箭无效化
		"creep_special_gain_Invalidation_of_life_steal",     --生命摄取无效化
		"creep_special_gain_Invalidation_of_Shield",     --护盾破坏
		"creep_special_gain_Invalidation_of_health_regen",     --生命禁用
		"creep_special_gain_Invalidation_magic",            --魔力反噬
		"creep_special_gain_fake_message", --虚假情报
		"creep_special_gain_anti_time_arua",--反时间领域 
		--"creep_special_gain_Painful_last_wish", --死亡遗愿
		"creep_special_gain_cleave",    --分裂攻击
		--"creep_special_gain_Magic_Conversion",  --魔力攻击
		--"creep_special_gain_Expansion_flame",  --膨胀烈焰
		-- "creep_special_gain_Magic_Conversion",  --魔力攻击

		--新增
		----"creep_special_fear_alone",--新增：存活友军单位时双增益，否则双减益--【不能给精英】
		--"creep_special_gain_super",--新增：超级精英，体型增大，移动速度降低，生命值，护甲，魔抗大幅提高。一定具有“坚毅”“背水一战”“濒死狂暴”，击杀后为击杀者提供金币
		-- "creep_special_gain_axe_culling_blade",  --淘汰之刃
		"creep_special_gain_death_poison",--新增：剧毒尸爆，4秒每秒3%最大生命值的毒，可以破坏
		--"creep_special_gain_act1_oil",-- 赛季1:焦油改
		--"creep_special_gain_act1_angry",-- 赛季1：我怒了改
		
	},
}






return Myspawner


