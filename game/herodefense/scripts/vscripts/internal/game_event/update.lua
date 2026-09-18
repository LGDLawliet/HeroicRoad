--一个全局计时器 用于不让挂机判定成立（如果长时间没得到经验会被判定为挂机）
-- 2023.10.23 把addon_info设置一下就没这个问题了 因此废弃
function game_event:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            hero:AddExperience(1, 1, false, true)
        end
    end

	return 60
end



