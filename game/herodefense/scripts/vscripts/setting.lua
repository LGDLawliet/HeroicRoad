



-- 从苦难中获取的可靠经验与黄金会受到这个系数影响
_G.BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT = {
    1,
    0.8,
    0.65,
    0.5,
    0.4,
}
-- 技能书
_G.BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT__SpellBook = {
    1,
    0.9,
    0.8,
    0.7,
    0.6,
}



-- 试炼增加的倍率
_G.BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY = {
    1.3,
    1.8,
    1.9,
    1.9,
}

-- 技能书
_G.BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__SpellBook = {
    1.2,
    1.4,
    1.45,
    1.45,
}


-- 击败boss的金币奖励系数
_G.BONUS_GOLD_INDEX_FROM_CHALLENGE_BOSS = {
    1,
    0.9,
    0.8,
    0.7,
    0.6,
}

-- Boss技能书受到的试炼难度影响
_G.BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__BossSpellBook = {
    1.1,
    1.2,
    1.3,
}
-- Boss技能书受到基本难度影响
_G.BONUS_INDEX_FROM_DIFFICULTY__BossSpellBook ={
    1,
    1.1,
    1.2,
    1.3,
}

-- 根据玩家数平衡符石进度条
_G.Rune_Progress_BaseInPlayerCount = {
    KeyValues.base_setting["Rune_Progress_PlayerCountIndex"].value1,
    KeyValues.base_setting["Rune_Progress_PlayerCountIndex"].value2,
    KeyValues.base_setting["Rune_Progress_PlayerCountIndex"].value3,
    KeyValues.base_setting["Rune_Progress_PlayerCountIndex"].value4,
    KeyValues.base_setting["Rune_Progress_PlayerCountIndex"].value5,
}




-- 获取苦难奖励系数
function GetBonusIndex_Challenge()
    return BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT[math.min(GetPlayerCount() or 1,#BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT)]
end

function GetBonusIndex_Challenge__SpellBook()
    return BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT__SpellBook[math.min(GetPlayerCount() or 1,#BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT__SpellBook)]
end

-- 获取试炼奖励系数
function GetBonusIndex_ChallengeDifficulty()
    local diff = GetChallengeDifficulty()
    if diff>0 then
        return BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY[math.min(diff,#BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY)]
    else
        return 1
    end

    
end

function GetBonusIndex_ChallengeDifficulty_SpellBook()
    local diff = GetChallengeDifficulty()
    if diff>0 then
        return BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__SpellBook[math.min(diff,#BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__SpellBook)]
    else
        return 1
    end

    
end


function GetBonusIndex_Difficulty_BossSpellBook()
    local diff = GAME_DIFFICULTY
    if diff>0 then
        return BONUS_INDEX_FROM_DIFFICULTY__BossSpellBook[math.min(diff,#BONUS_INDEX_FROM_DIFFICULTY__BossSpellBook)]
    else
        return 1
    end

    
end

function GetBonusIndex_ChallengeDifficulty_BossSpellBook()
    local diff = GetChallengeDifficulty()
    if diff>0 then
        return BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__BossSpellBook[math.min(diff,#BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__BossSpellBook)]
    else
        return 1
    end
end



-- 怪的孵化速度
_G.MONSTER_SPAWN_RATE = {
    1,    --难度1
    1,    --难度2
    0.8,--难度3
    0.6,--难度4
    0.6,--难度5
    0.6,--难度6
    0.6,--难度7
    0.6,--难度8
    0.6,--难度9  百相
    0.6,--难度10  乱纪元

}


function SetMonsterSpawnSpeed(difficulty)
    GAME_internal_index = _G.MONSTER_SPAWN_RATE[difficulty]
end





-- 苦难boss的金币奖励随着人数减少
function GetBonusGoldIndex_ChallengeBoss()
    return BONUS_GOLD_INDEX_FROM_CHALLENGE_BOSS[math.min(GetPlayerCount() or 1,#BONUS_GOLD_INDEX_FROM_CHALLENGE_BOSS)]
end

function UpdatePlayerCount()
    _G.Game_Mode.player_count = GetPlayerCount()
    CustomNetTables:SetTableValue( "game_config", "hd_game_mode", _G.Game_Mode )
end

function UpdateChallenge_Difficulty()
    _G.Game_Mode.challenge_difficulty = GetChallengeDifficulty()
    CustomNetTables:SetTableValue( "game_config", "hd_game_mode", _G.Game_Mode )
end
function UpdateGameRound()
    CustomNetTables:SetTableValue( "game_config", "game_round", {value=GetCurrentRound()} )
end


function InitNetTable()
    CustomNetTables:SetTableValue( "game_config", "base_bonus_congig", {
        BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT = BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT,
        BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT__SpellBook = BONUS_INDEX_FROM_CHALLENGE_BY_PLAYER_COUNT__SpellBook,
        BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY = BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY,
        BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__SpellBook = BONUS_INDEX_FROM_CHANLLENGE_DIFFICULTY__SpellBook,
        BONUS_GOLD_INDEX_FROM_CHALLENGE_BOSS = BONUS_GOLD_INDEX_FROM_CHALLENGE_BOSS,

    } )

end










InitNetTable()