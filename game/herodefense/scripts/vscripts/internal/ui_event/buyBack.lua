-- 0 正常
-- 1 死亡 待复活
-- 2 死亡 已复活就绪

_G.GAME_HERO_STATE={}
--检测玩家状态
function uimanager:_CheckAlive(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    local heroes = GetAllRealHeroes()
    _G.GAME_HERO_STATE={}
    for _, unit in pairs(heroes) do
        if unit:IsAlive() then
        else
            local time = unit:GetTimeUntilRespawn()
            if time>0 then --说明是处于重生技能中
            else --进行处理
                local playerID = unit:GetPlayerID()
                table.insert(_G.GAME_HERO_STATE,playerID)
            end
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "CheckAliveCallBack", {_G.GAME_HERO_STATE})
   
end


--买活
function uimanager:_BuyBackHero(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    local nTargetPlayerID =event_data.target_player_id
    if not nTargetPlayerID then
        return
    end
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end

    local Targetplayer = PlayerResource:GetPlayer(nTargetPlayerID)
    if not Targetplayer then
        return
    end
    local TargetPlayerHero = Targetplayer:GetAssignedHero() --被复活者
    -- local PlayerHero = player:GetAssignedHero()             --复活者
    self:TryBuyBack(nPlayerID,TargetPlayerHero)
   
end

--买回最近得
function uimanager:_BuyBackClosest(eventSourceIndex, event_data)
    local nPlayerID = event_data.player_id
    -- local nTargetPlayerID =event_data.target_player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end

    local heroes = GetAllRealHeroes()
    local PlayerHero = player:GetAssignedHero()             --复活者
    local target 
    local dis = 0
    for _, unit in pairs(heroes) do
       if unit~=PlayerHero and not unit:IsAlive() then
            if target==nil then
                target = unit
                dis = CalculateDistance(unit,PlayerHero)
            else
                local new_dis =CalculateDistance(unit,PlayerHero)
                if new_dis<=dis then
                    target = unit
                    dis = CalculateDistance(unit,PlayerHero)
                end
            end
       end
    end

    if not target then
        return
    end
    self:TryBuyBack(nPlayerID,target)
    
end

-- 尝试买活目标
function uimanager:TryBuyBack(nPlayerID,target)
    local player = PlayerResource:GetPlayer(nPlayerID)
    local TargetPlayerHero = target --被复活者
    local PlayerHero = player:GetAssignedHero()             --复活者

    -- 目标无法被复活
    if GeDisableReSpawn(TargetPlayerHero, nil)>=1 then
        
        SendCustomErrorToPlayer(PlayerHero:GetPlayerOwnerID(),"cant_buyback_disabled","General.Cancel")
        EmitSoundOnClient("General.Cancel", player)
		return
	end

     --已经被某人复活中
    if TargetPlayerHero:GetTimeUntilRespawn()>0 then
        SendCustomErrorToPlayer(PlayerHero:GetPlayerOwnerID(),"Already_buyback","General.Cancel")
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    --已经被某人复活中
    if not PlayerHero:IsAlive() or PlayerHero:HasModifier("modifier_item_hd_helm_of_the_undying_active") or PlayerHero:HasModifier("modifier_Advanced_reincarnation_active") then 
        SendCustomErrorToPlayer(PlayerHero:GetPlayerOwnerID(),"cant_buyback_dead","General.Cancel")
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    local modifier = PlayerHero:FindModifierByName("modifier_heroTalent_npc_dota_hero_phoenix")
    if modifier and modifier:GetAbility():GetAutoCastState() then
        --涅槃救人逻辑
        phoenixBuyBack(TargetPlayerHero,PlayerHero,nPlayerID,modifier)
        return

    end
    -- 距离不足
    if CalculateDistance(PlayerHero,TargetPlayerHero)>500 then
        SendCustomErrorToPlayer(PlayerHero:GetPlayerOwnerID(),"cant_buyback_too_far","General.Cancel")
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    -- 虚弱状态
    if PlayerHero:HasModifier("modifier_Respawn_weak") then
        -- Notifications:Top(nPlayerID, { text = "#cant_buyback_buying", duration = 4, style = { color = "red" } })
        SendCustomErrorToPlayer(PlayerHero:GetPlayerOwnerID(),"cant_buyback_buying","General.Cancel")
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    -- 虚弱状态
    if TargetPlayerHero:HasModifier("modifier_Respawn_weak_target") then
        -- Notifications:Top(nPlayerID, { text = "#cant_buyback_buying", duration = 4, style = { color = "red" } })
        SendCustomErrorToPlayer(PlayerHero:GetPlayerOwnerID(),"cant_buyback_target_weak","General.Cancel")
        EmitSoundOnClient("General.Cancel", player)
        return
    end
    local wakeTime = 40
    local time = 20
    local weak = true

    local baseReduction = GetUnitBuyBackTimeReduction(PlayerHero,TargetPlayerHero)
    time = math.max(time - baseReduction,0)

    if TargetPlayerHero:HasModifier("modifier_item_hd_cloak_of_endless_carnage") then

        weak = false
    end

    local item = PlayerHero:HDFindItemByNameNotInBag("item_hd_chrono_casket")
    if item then
        if  item:CheckBuyBack() then
            print("ok")
            time = math.min(3,time)
            weak = false
            wakeTime = 0
        end
    end


    local modifier =  TargetPlayerHero:FindModifierByName("modifier_Advanced_Shallow_Grave_unlock3_delay")
    if modifier then
        local gold =math.floor( TargetPlayerHero:GetGold()/5000)*0.3
        time = math.max(7-gold,0.5)
        modifier:GetAbility():TriggerUnlock3(time,TargetPlayerHero)
    end


    if TargetPlayerHero:HasAbility("heroTalent_npc_dota_hero_techies") then
        time = time * 0.5
    end

    --可以执行复活了
    local casterWeakModifier
    local ability = PlayerHero:FindAbilityByName("Default_Move")
    if weak then
       casterWeakModifier = PlayerHero:AddNewModifier(PlayerHero, ability or nil, "modifier_Respawn_weak", {duration = time})
    end
    
    uimanager:PlayBuyBackEffect(PlayerHero,TargetPlayerHero)

    -- 移除自身虚弱状态 放特效
    local modifier = PlayerHero:FindModifierByName("modifier_heroTalent_npc_dota_hero_oracle")
    if modifier then
        modifier:BuyBackTarget(TargetPlayerHero)
    end
    -- if weak then


    -- 正常流程买活
    local keys = {
        target = TargetPlayerHero,
        caster = PlayerHero,
        wakeTime = wakeTime,
        delay = time,
        
    }
    local ability = PlayerHero:FindAbilityByName("chaotic_true_resurrection")
    if ability and ability:CheckEnable(keys) then
        keys.delay = 0.03
        keys.wakeTime = 0
        local wave_time_fix = ability:GetSpecialValueFor("wave_time_fix")
        if casterWeakModifier then
            casterWeakModifier:SetDuration(casterWeakModifier:GetRemainingTime()*(1-wave_time_fix*0.01), true)
        end
        self:RespawnTargetInDelay(keys, function()
            ability:Rune1CallBack(TargetPlayerHero)
        end)
    else
        self:RespawnTargetInDelay(keys,nil)
    end
    --返回js信息
    self:UpdateBuyBack()

end
function phoenixBuyBack(TargetPlayerHero,PlayerHero,nPlayerID,modifier)
    local player = PlayerResource:GetPlayer(nPlayerID)
    uimanager:PlayBuyBackEffect(PlayerHero,TargetPlayerHero)

 

    local needTime = 10
    if TargetPlayerHero:HasAbility("heroTalent_npc_dota_hero_techies") then
        needTime = needTime * 0.5
    end
    local keys = {
        target = TargetPlayerHero,
        caster = PlayerHero,
        wakeTime = 0,
        delay = needTime,
        
    }
    uimanager:RespawnTargetInDelay(keys,function()
        modifier:BuyBackTarget(TargetPlayerHero)
	end)



    -- TargetPlayerHero:SetTimeUntilRespawn(needTime)
    -- local pos = TargetPlayerHero:GetAbsOrigin()
    -- Timers:CreateTimer(needTime, function()
    --     if not TargetPlayerHero:IsAlive() then --防止二次复活
    --      --2022.02.14 feedback:由于未知原因导致假死 在此状态下判断为存活状态 需要强制复活
    --         TargetPlayerHero:RespawnHero(false,false)
    --         FindClearSpaceForUnit( TargetPlayerHero, pos, true )
    --         TargetPlayerHero:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=1}) --提供无敌防止死亡
    --         modifier:BuyBackTarget(TargetPlayerHero)
    --     end
    -- end)


    TrueKill(PlayerHero, PlayerHero, modifier:GetAbility())
    local self_needTime =20
    -- 有涅槃成就10%自我复活时间
    if PlayerHero:HaveAchievement("Nirvana_1") then
        self_needTime = self_needTime *0.9
    end
    local keys = {
        target = PlayerHero,
        caster = PlayerHero,
        wakeTime = 0,
        delay = self_needTime,
        
    }
    uimanager:RespawnTargetInDelay(keys,function()
        modifier:BuyBackTarget(PlayerHero)
	end)

    -- local pos = PlayerHero:GetAbsOrigin()
    -- Timers:CreateTimer(0.5, function()
    --     if PlayerHero:GetTimeUntilRespawn()<=0 then
    --         PlayerHero:SetTimeUntilRespawn(self_needTime-0.5) 
    --         Timers:CreateTimer(self_needTime-0.5, function()
    --             if not PlayerHero:IsAlive() then --防止二次复活
    --                 --2022.02.14 feedback:由于未知原因导致假死 在此状态下判断为存活状态 需要强制复活
    --                 PlayerHero:RespawnHero(false,false)
    --                 FindClearSpaceForUnit( PlayerHero, pos, true )
    --                 TargetPlayerHero:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=1}) --提供无敌防止死亡
    --                 modifier:BuyBackTarget(PlayerHero)
    --             end
    --         end)
    --     end
        
    -- end)
    --回调
    uimanager:UpdateBuyBack()


    local modifier = PlayerHero:FindModifierByName("modifier_hero_custom_data_manager")
    if modifier then
        modifier:PhoenixBuyBack()
    end
    
end



function uimanager:UpdateBuyBack()
    local heroes = GetAllRealHeroes()
    _G.GAME_HERO_STATE={}
    for _, unit in pairs(heroes) do
        if unit:IsAlive() then
        else
            local time = unit:GetTimeUntilRespawn()
            if time>0 then --说明是处于重生技能中
            else --进行处理
                local playerID = unit:GetPlayerID()
                table.insert(_G.GAME_HERO_STATE,playerID)
            end
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "CheckAliveCallBack", {_G.GAME_HERO_STATE})
end

-- 表现
function uimanager:PlayBuyBackEffect(PlayerHero,TargetPlayerHero)
    local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PlayerHero), PATTACH_CUSTOMORIGIN, PlayerHero)
    ParticleManager:SetParticleControlEnt(pfx1, 0, PlayerHero, PATTACH_POINT_FOLLOW, "attach_attack1", PlayerHero:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 2, TargetPlayerHero, PATTACH_CUSTOMORIGIN_FOLLOW, nil, TargetPlayerHero:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 3, TargetPlayerHero, PATTACH_CUSTOMORIGIN_FOLLOW, nil, TargetPlayerHero:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(pfx1)
    PlayerHero:EmitSound("Greevil.Bloodlust.Cast")
    TargetPlayerHero:EmitSound("Greevil.Bloodlust.Cast")
end


-- 复活一个单位
function uimanager:RespawnTargetInDelay(keys,callBack)

    if keys.wakeTime>0 then
        keys.target:SetHealth(1)
        keys.target:AddNewModifier(keys.caster, keys.ability or nil, "modifier_Respawn_weak_target", {duration = keys.delay+keys.wakeTime})
        keys.target:SetHealth(0)
    end

    keys.target:SetTimeUntilRespawn(keys.delay)
    local pos = keys.target:GetAbsOrigin()
    local timer =  GameRules:GetGameTime() + keys.delay
    keys.target:GameTimer(0.1, function()
        if keys.target:IsAlive() then
            keys.target:RespawnHero(false,false)
            return
        end
        local time =  GameRules:GetGameTime()
        if time>=timer then
            keys.target:RespawnHero(false,false)
            FindClearSpaceForUnit( keys.target, pos, true )
            keys.target:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=1}) --提供无敌防止死亡
            if callBack then
                callBack()
            end
            return
        end
        return 0.1

    end)


end