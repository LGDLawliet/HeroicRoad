

Game_State = Game_State or  class( { })

require('internal/timers')




function Game_State:init(bReload)
    print("Game_State init")
    if not bReload then
        self.InBattle = false  --处于战斗中
        self.gameEnd = false --游戏结束
        self.ChaoticEraMod = false
    
        self.enable_shop_on_battle = false
    end

end

--是否在战斗中
function Game_State:IsInBattle()
    return self.InBattle
end

function Game_State:SetBattleState(state)
    self.InBattle = state
end



function Game_State:IsGameEnd()
    return self.gameEnd
end

function Game_State:SetGameEnd(state)
    self.gameEnd = state
end


function Game_State:IsInChaoticEra()
    return self.ChaoticEraMod
end

function Game_State:EnableChaoticEraMod()
    self.ChaoticEraMod = true
    _G.Game_Mode.ChaoticEraMod = 1
    _G.Game_Mode.game_shop_type = Game_Shop_Type_ChaoticEra

    
    -- 初始化
    _G.chaotic_era_spawner = chaotic_era_spawner
	chaotic_era_spawner:Enable()

	chaotic_era_shop:Enable()


    CustomNetTables:SetTableValue( "game_config", "hd_game_mode", _G.Game_Mode )
    -- print("oooooooooooo")

    customDataManager:InitChaoticEraBonusEffect()
end



function Game_State:IsShopOpen()
    if self:IsInBattle() and not self.enable_shop_on_battle then
        return false
    else
        return true
    end
end

return Game_State
