player_effect = player_effect or class({})
print("player_effect load....")






LinkLuaModifier("modifier_ranking_top1", "modifier/ranking_effect/modifier_ranking_top10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ranking_top3", "modifier/ranking_effect/modifier_ranking_top10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ranking_top10", "modifier/ranking_effect/modifier_ranking_top10", LUA_MODIFIER_MOTION_NONE)


function player_effect:AddRankingParticles()
    local map = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        local nPlayerID = hero:GetPlayerID()
        local targetMap = map[nPlayerID]
            local ranking = targetMap.playerinfo.ranking
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
