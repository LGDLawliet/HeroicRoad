

--提供工具模式下的测试功能
--这个文件不加密

if IsInToolsMode() or _G.GAME_debugTesting then
    _G.GAME_ROUND =0--游戏波数
    -- SetCurrentRound(1)
    _G.GAME_ENDLESS_WAVE = 0   --无尽波数
    _G.GAME_ENDLESS_WAVE_COUNT = 0   --无尽波击杀数

    -- function CDOTA_PlayerResource:GetSteamID(nPlayerID)
    --     if nPlayerID==0 then
    --         return "76561198097596443"
    --     end
    --     return "0"
    -- end

    -- function CDOTA_PlayerResource:GetSteamAccountID(nPlayerID)
    --     if nPlayerID==0 then
    --         return "137330715"
    --     end
    --     return "0"
    -- end

    --圣物经验简述：lv40：61446 lv100:
    --樱小路露娜：76561198200656253，240390525
    --少年一梦：76561198101659620，141393892
    --测试员王子：76561199010267578 1050001850
    --复读机：76561198097596443 137330715
    --搬屎王：76561198340659423 380393695
    
end
--给unit添加一个modifier_novice_player
-- function AddNoviceModifier(unit)
--     local modifier = unit:FindModifierByName("modifier_novice_player")
--     if modifier == nil then
--         unit:AddNewModifier(unit, nil, "modifier_novice_player", {})
--     end
-- end
    



function CheckToolSpell(unit)
    -- AddNoviceModifier(unit)
    --[[for i = 1, 5, 1 do
        unit:HeroLevelUp(false)
    end]]
   -- UnlockSpell(unit,"Advanced_Burning_Spear",3)
    -- UnlockSpell(unit,"Advanced_Soul_Link",1)
    -- AddTestItem(unit,"item_hd_blight_stone")
    --unit:AddAbility("Advanced_Burning_Spear")
end


function UnlockSpell(unit,name,unlock)
    local unlock = unlock
    local name = name
    local newAbility =  unit:AddAbility(name)  --添加下一个阶级
    -- newAbility.level3_id = ability.level3_id    --设置阶级三
    newAbility:SetLevel(1)
    newAbility.classlevel = 3                   --设置为三阶   
    newAbility.advanced_level = 25          --设置初始的高阶等级
    newAbility.upgrade_cost = 0  --设置升级花费
    newAbility.totalcost = 0
    newAbility.CoreUnlock = true
    local NetTable_key = tostring(unit:GetPlayerID()).."_"..name
    CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {level =25 } )  --更新网表

    if unlock==1 then

        newAbility:UnlockFirstCore()
        newAbility.unlock1 = true
    elseif unlock==2 then

        newAbility.unlock2 = true
        newAbility:UnlockSecondCore()
    else

        newAbility:UnlockThirdCore()
        newAbility.unlock3 = true
    end
    

    local NetTable_key = tostring(unit:GetPlayerID()).."_"..name.."_unlock"
    CustomNetTables:SetTableValue( "playerSpellLevelInfo", NetTable_key, {coreUnlock =unlock } )  --更新网表

end

--joker 添加测试物品
function AddTestItem(unit,name)
    local item = CreateItem(name, unit, unit)
    unit:AddItem(item)
    print("AddTestItem",name)
end


























































-- [url=https://docs.qq.com/doc/DSU1FRW1ER0dLV2hT?] 2.0N Update [/url]
-- [url=https://docs.qq.com/doc/DSWpaYWtrbm5PRlZW] 2.0M更新[/url]