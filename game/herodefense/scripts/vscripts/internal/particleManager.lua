print("particleManager load....")
particleManager = particleManager or class({})
require("internal/timers")
--备注 如果添加了新的技能 需要完成的事情：
--1.在particleTypeInfo中添加该技能对应的特效类型
function particleManager:init(bReload)
    -- 各种特效所对应的索引
    -- 技能类型的特效都以1为开头
    -- 其他以2为开头
    
    if not bReload then
        self.particleChange = {} 
        self.playSoundTimer ={}
    end
    self.particleTypeInfo = {
        SpellParticle = {
            Advanced_Starbreaker = 1001,
            Advanced_chaos_form = 1002,
            Advanced_Life_Drain = 1003,
            Advanced_Midnight_Pulse = 1004,
            Advanced_laguna_blade=1005,
            Advanced_Demonic_Conversion = 1006,
            Advanced_pulse_nova = 1007,
            Advanced_shapeshift = 1008,
            Advanced_Chronosphere = 1009,
            Advanced_Plague_Ward = 1010,
            Advanced_summon_earth_element = 1011,
            Advanced_unrivaled = 1012,
            Advanced_astral_step = 1013,
            Advanced_Electrostatic_Armor = 1014,
        },
        Attach = 2001,
        MeleeAttack = 2002,
        RangeAttack = 2003,
        Telent = 2004,
        SoundWheel = 2005,

    }

    -- 填写了spell_name的即为技能特效
    -- 只写了type的为其他类型
    self.particleSet = {
        ability_particle_1 = {
            spell_name = "Advanced_Starbreaker",
        },
        ability_particle_2 = {
            spell_name = "Advanced_Starbreaker",
        },
        ability_particle_3 = {
            spell_name = "Advanced_chaos_form",
        },
        ability_particle_4 = {
            spell_name = "Advanced_chaos_form",
        },
        ability_particle_5 = {
            spell_name = "Advanced_Life_Drain",
        },
        ability_particle_6 = {
            spell_name = "Advanced_Midnight_Pulse",
        },
        ability_particle_7 = {
            spell_name = "Advanced_laguna_blade",
        },
        ability_particle_8 = {
            spell_name = "Advanced_Demonic_Conversion",
        },
        ability_particle_9 = {
            spell_name = "Advanced_pulse_nova",
        },
        ability_particle_10 = {
            spell_name = "Advanced_shapeshift",
        },

        ability_particle_11 = {
            spell_name = "Advanced_Chronosphere",
        },
        ability_particle_12 = {
            spell_name = "Advanced_Plague_Ward",
        },
        ability_particle_13 = {
            spell_name = "Advanced_Plague_Ward",
        },
        ability_particle_14 = {
            spell_name = "Advanced_summon_earth_element",
        },
        ability_particle_15 = {
            spell_name = "Advanced_unrivaled",
        },
        ability_particle_16 = {
            spell_name = "Advanced_astral_step",
        },
        ability_particle_17 = {
            spell_name = "Advanced_Electrostatic_Armor",
        },


        
        -- heroTalent_npc_dota_hero_antimage_2 = {
        --     type = 2004,
        -- },

        -- attach_particle_1 = {
        --     type = 2001,
        -- },

    }


    --记录改变的特效

    -- print("遍历一下")
    -- for key, value in pairs(self.particleSet) do
    --     -- print(key)  -- ability_particle_1
    --     -- print(value) --table

    -- end
    -- for _, key in ipairs(self.particleSet) do
        
    -- end
    -- print("name=")
    -- print(self:GetSpellParticleSpellName("ability_particle_2"))

    CustomUIEvent("ShiftParticle", Dynamic_Wrap(self, "_ShiftParticle"), self)

    CustomUIEvent("ShiftNormalParticle", Dynamic_Wrap(self, "_ShiftNormalParticle"), self)

    CustomUIEvent("GetPlayerSoundWheel", Dynamic_Wrap(self, "_GetPlayerSoundWheel"), self)

    CustomUIEvent("PlaySoundWheel", Dynamic_Wrap(self, "_PlaySoundWheel"), self)



    -- CustomGameEventManager:RegisterListener("ShiftParticle", function(...)
    --     return self:_ShiftParticle(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("ShiftNormalParticle", function(...)
    --     return self:_ShiftNormalParticle(...)
    -- end)
    -- CustomGameEventManager:RegisterListener("GetPlayerSoundWheel", function(...)
    --     return self:_GetPlayerSoundWheel(...)
    -- end)
    
    -- CustomGameEventManager:RegisterListener("PlaySoundWheel", function(...)
    --     return self:_PlaySoundWheel(...)
    -- end)
    

    
end

-- 获取该特效在spellMap中应该放的位置
function particleManager:GetTablePos(spellMap,particleName)
    local targetPos = spellMap.Particle         
    local name =particleName
    if string.sub(name,1,7)=="ability" then --技能类型
        targetPos = targetPos.SpellParticle
        local abilityName = particleManager:GetSpellParticleSpellName(name)
        --为空创建默认
        if not targetPos[abilityName] then
            targetPos[abilityName]  ={
                on_Particle =  "ability_particle_0",
                ParticleSet = {}
            }
        end
        targetPos = targetPos[abilityName]
    else
        local type = self:GetParticleTypeIndex(particleName)
        if type==2001 then
            targetPos = targetPos.Attach
            -- print("放Attach里")
        elseif type==2002 then
            targetPos = targetPos.MeleeAttack
            -- print("放MeleeAttack里")
        elseif type==2003 then
            targetPos = targetPos.RangeAttack
            -- print("放RangeAttack里")
        elseif type==2004 then
            targetPos = targetPos.Talent
        elseif type==2005 then
            targetPos = targetPos.SoundWheel
        end
    end
    return targetPos
  
    -- targetPos[name] = info.endDate
end





--返回对应特效名的特效索引
function particleManager:GetParticleTypeIndex(name)
    local target = self.particleSet
    if string.match(name, "sound_wheel")  then
        return 2005
    end
    if string.match(name, "heroTalent")  then
        return 2004
    end
    if string.match(name, "attach_particle")  then
        return 2001
    end
    if string.match(name, "melee_attack")  then
        return 2002
    end



    if target[name] then
        if target[name].type then
            return target[name].type
        else
            local spellName = target[name].spell_name
            if spellName then
                target = self.particleTypeInfo.SpellParticle[spellName]
                if target then
                    return target
                else
                    print("Error:没配置技能特效类型:"..name)
                    return -1
                end
            else
                print("Error:没配置技能名:"..name)
                return -1
            end
        end
    end

    return -1
end

-- 返回特效名所对应技能名
function particleManager:GetSpellParticleSpellName(name)
    local target = self.particleSet
    if target[name] and target[name].spell_name then
        return target[name].spell_name
    end

    return "none"
end


function particleManager:GetSpellParticleType(spellName)
    local targetTable = self.particleTypeInfo.SpellParticle
    if targetTable[spellName] then
        return targetTable[spellName]
    end
    return -1


end

-- 在查询不到的情况下都会返回 ability_particle_0
-- 如果解锁了特效 那么返回目前的佩戴特效
function particleManager:GetSpellParticle(nPlayerID,spellName)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        print("Error:没有spellmap")
        return "ability_particle_0"
    end
    local map = spellmap[nPlayerID]
    if not map then
        return "ability_particle_0"
    end
    local target = map.Particle.SpellParticle
    if not target or not target[spellName] then
        -- 没有该技能的特效解锁
        return "ability_particle_0"
    end
    return target[spellName].on_Particle

end


-- 切换技能特效的佩戴
function particleManager:_ShiftParticle(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        print("Error:没有spellmap")
        return
    end
    
    local map = spellmap[nPlayerID]

    local target = map.Particle.SpellParticle
    -- PrintTable(target)
    local ParticleName = event_data.particleName  --拿到触发的特效名
    local spellName = event_data.spellName --拿到触发的技能名
    if not target or not target[spellName] then
        print("Error:切换特效时候发生错误")
        return
    end
    local target_Spell_Particle = target[spellName]
    -- print("------------------------------")
    -- print(target_Spell_Particle.on_Particle)
    -- PrintTable(target_Spell_Particle.ParticleSet)
    -- print("------------------------------")
    if ParticleName=="ability_particle_0" then 
        --默认特效的切换 如果是装备 那就正常切换上去 如果是卸下 那不给予处理
        if target_Spell_Particle.on_Particle ==ParticleName then
            --已装备的情况 不进行处理
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Particle_error1","General.Cancel")
            -- print("已经装备")
            return
        else
            --切换到默认特效
            -- print("切换默认")
            target_Spell_Particle.on_Particle = ParticleName
        end
    else
        --如果是其他特效 那么判断是不是卸下 如果是卸下那么就替换成默认特效
        if not target_Spell_Particle.ParticleSet[ParticleName] then
            print("Error:尝试装备未拥有的特效")
            return
        end
        if target_Spell_Particle.on_Particle ==ParticleName then
            --卸下的情况 替换到默认特效
            print("卸下切换回默认")
            target_Spell_Particle.on_Particle = "ability_particle_0" 
        else
            --装备上
            print("切换特效")
            target_Spell_Particle.on_Particle = ParticleName
        end
    end
    local type = self:GetSpellParticleType(spellName)
    if type~= -1 then
        self:AddParticleChange(nPlayerID,target_Spell_Particle.on_Particle,type)
    end

    -- print(target[spellName].on_Particle)
    -- PrintTable(target)
    local feedbackData = {spellParticle = target}
    
    --反馈技能表
    CustomGameEventManager:Send_ServerToPlayer(player, "ShiftSpellParticleFeedBack", feedbackData)
end




function particleManager:_ShiftNormalParticle(eventSourceIndex, event_data)

    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        print("Error:没有spellmap")
        return
    end
    if not player then
        print("Error:不合法玩家")
        return
    end
    
    local map = spellmap[nPlayerID]

    local target = map.Particle

    local ParticleName = event_data.particleName  --拿到触发的特效名
    local index = event_data.index --拿到触发类型索引
    -- 转到相对应的特效仓库
    if index==2001 or index=="2001" then
        target =  target.Attach
    elseif index==2002 or index=="2002" then
        target =  target.MeleeAttack
    elseif index==2003 or index=="2003" then
        target =  target.RangeAttack
    end
    -- print(ParticleName)
    -- print(index)
    if not target  then
        print("Error:切换特效时候发生错误")
        return
    end
 
    if ParticleName=="ability_particle_0" then 
        --默认特效的切换 如果是装备 那就正常切换上去 如果是卸下 那不给予处理
        if target.on_Particle ==ParticleName then
            --已装备的情况 不进行处理
            -- print("已经装备")
            SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Particle_error1","General.Cancel")
            return
        else
            --切换到默认特效
            print("切换默认")
            target.on_Particle = ParticleName
        end
    else
        --如果是其他特效 那么判断是不是卸下 如果是卸下那么就替换成默认特效
        if not target.ParticleSet[ParticleName] then
            print("Error:尝试装备未拥有的特效")
            return
        end
        if target.on_Particle ==ParticleName then
            --卸下的情况 替换到默认特效
            print("卸下切换回默认")
            target.on_Particle = "ability_particle_0" 
        else
            --装备上
            print("切换特效")
            target.on_Particle = ParticleName
        end
    end
    self:RefreshParticle(   player:GetAssignedHero(), target.on_Particle,index)

    self:AddParticleChange(nPlayerID,target.on_Particle,index)
   
    local feedbackData = {Particle = map.Particle}
    
    -- 反馈
    CustomGameEventManager:Send_ServerToPlayer(player, "ShiftNormalParticleFeedBack", feedbackData)
end



function particleManager:SetUpDefaultParticle(unit)
    local modifier = unit:FindModifierByName("modifier_hero_light")
    if not modifier then
        return
    end
    if not unit:IsOwnedByAnyPlayer() then
        print("Error:不是玩家的单位")
        return
    end
    --获取该玩家的几个需要配置的特效名
    local nPlayerID = unit:GetPlayerOwnerID()
   
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        print("Error:没有spellmap")
        return
    end
    modifier:Del(-1)
    local map = spellmap[nPlayerID].Particle
    local particleTable = {}
    table.insert(particleTable,map.Attach.on_Particle)
    table.insert(particleTable,map.MeleeAttack.on_Particle)
    table.insert(particleTable,map.RangeAttack.on_Particle)
    for _, name in ipairs(particleTable) do
        if name~="ability_particle_0" then --默认是没有特效的
            if modifier[name] then
                modifier[name](modifier)
            else
                print("Error:缺失的特效函数")
            end
        end
    end

end


function particleManager:RefreshParticle(unit,name,type)
    if not unit then
        print("Error:没有传入单位")
        return
    end
    local modifier = unit:FindModifierByName("modifier_hero_light")
    if not modifier then
        return
    end
    if not unit:IsOwnedByAnyPlayer() then
        print("Error:不是玩家的单位")
        return
    end
    --获取该玩家的几个需要配置的特效名
    local nPlayerID = unit:GetPlayerOwnerID()
    -- local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellmap then
        print("Error:没有spellmap")
        return
    end
    if name=="ability_particle_0" then --默认是没有特效的
        modifier:Del(type)
    else
        if modifier[name] then
            modifier:Del(type)
            modifier[name](modifier)
        else
            print("Error:缺失的特效函数")
        end
    end
end





function particleManager:AddParticleChange(nPlayerID,name,type)
    if not self.particleChange[nPlayerID] then
        self.particleChange[nPlayerID] = {}
    end
    local targetTable = self.particleChange[nPlayerID]
    if not targetTable[tostring(type)] then
        targetTable[tostring(type)] = {}
    end
    targetTable[tostring(type)] = {
        name = name,
        type = type,
    }
    -- PrintTable(self.particleChange)
end



function particleManager:SetUpParticles()
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        self:SetUpDefaultParticle( hero) --配置默认特效
        local nPlayerID = hero:GetPlayerID()
        local targetMap = map[nPlayerID]
        local ranking = targetMap.playerinfo.ranking
        -- 配置赛季状态
        if  ranking and ranking<=10  then
            --添加效果
            if ranking<=1 then
                _G.Game_Ranking_bonus_chance = 1.1
                hero:AddNewModifier(hero, nil, "modifier_ranking_top1", {})
            elseif ranking<=3 then
                _G.Game_Ranking_bonus_chance = 1.1
                hero:AddNewModifier(hero, nil, "modifier_ranking_top3", {})
            else
                hero:AddNewModifier(hero, nil, "modifier_ranking_top10", {})
            end
            
        end
      

 
    end
end











function particleManager:_GetPlayerSoundWheel(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellMap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    if not spellMap then
        return
    end
    spellMap =spellMap[nPlayerID]
    local sound_list = spellMap.Particle.SoundWheel.ParticleSet  --获取到所有天赋

    --反馈
    CustomGameEventManager:Send_ServerToPlayer(player, "GetPlayerSoundWheel_feedback", sound_list)
end

function particleManager:_PlaySoundWheel(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
  

    if not self.playSoundTimer[nPlayerID]   then
        self.playSoundTimer[nPlayerID]   = 0
    end
    if self.playSoundTimer[nPlayerID]<2 then
        self.playSoundTimer[nPlayerID] =  self.playSoundTimer[nPlayerID] + 1
        Timers:CreateTimer(10, function()
            self.playSoundTimer[nPlayerID] =  self.playSoundTimer[nPlayerID] -1
        end)
    else
		SendCustomErrorToPlayer(nPlayerID,"DOTA_HUD_Wheel_info_6","General.Cancel")
        return
    end
   
    
    local gameEvent = {}
    gameEvent["player_id"] = nPlayerID
    gameEvent["teamnumber"] = -1
    gameEvent["message"] = "#DOTA_Tooltip_ability_"..event_data.soundName.."_play"
    FireGameEvent( "dota_combat_event_message", gameEvent )
    EmitGlobalSound(event_data.soundName)
end





return particleManager