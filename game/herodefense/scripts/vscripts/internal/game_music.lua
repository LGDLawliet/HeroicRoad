-- require("internal/timers")

print("game_music load.....")
game_music = game_music or class({})

function game_music:Init()
  
    print("game_music init")
    --收到升级技能的请求
    self.WAVE_END_MUSIC = {
        "greevil_eventend_Stinger",
        "greevil_mega_spawn_Stinger",
        "greevil_loot_spawn_Stinger",
        "awolnation_01.music.ganked_lg",
        "awolnation_01.stinger.radiant_win",
        "deadmau5_01.stinger.dire_win",
        "deadmau5_01.stinger.radiant_win",
        "dsadowski_01.music.battle_01_end",
        "dsadowski_01.music.battle_02_end",
        "dsadowski_01.music.battle_03_end",
    
        "dsadowski_01.stinger.radiant_win",
        "dsadowski_01.stinger.dire_win",
        "dsadowski_02.stinger.radiant_win",
        "dsadowski_02.stinger.dire_win",
        "jboberg_01.stinger.radiant_win",
        "jboberg_01.stinger.dire_win",
        "shop_jbrice_01.stinger.radiant_win",
        "shop_jbrice_01.stinger.dire_win",
        "jlin_01.stinger.radiant_win",
        "jlin_01.stinger.dire_win",
        "mhawken_01.stinger.radiant_win", --1
        "mhawken_01.stinger.dire_win",
        "thefatrat_01.stinger.radiant_win",
        "thefatrat_01.stinger.dire_win",
        "valve_dota_001.stinger.radiant_win",
        "valve_dota_001.stinger.dire_win",
        "valve_ti10.stinger.radiant_win",
        "valve_ti10.stinger.dire_win",
        "valve_ti4.stinger.radiant_win",
        "valve_ti4.stinger.dire_win",
        "valve_ti5.stinger.radiant_win",
        "valve_ti5.stinger.dire_win",
        "valve_ti6.stinger.radiant_win",
        "valve_ti6.stinger.dire_win",
        "valve_ti7.stinger.radiant_win",
        "valve_ti7.stinger.dire_win",
        "valve_ti8.stinger.radiant_win",
        "valve_ti8.stinger.dire_win",
        "valve_ti9.stinger.radiant_win",
        "valve_ti9.stinger.dire_win",
        "valve_ti11.stinger.dire_win",
        "valve_ti11.stinger.radiant_win",
        "valve_2021.stinger.dire_win",
        "valve_2021.stinger.radiant_win",
    
    
        -- "announcer_dlc_gaben_killing_spree_gaben_ann_kill_double_03", --G胖的感谢
        -- "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_10", --G胖的感谢2
        -- "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_38", --G胖的感谢 你做得很好 我为你骄傲
        -- "announcer_dlc_gaben_killing_spree_gaben_ann_kill_welcome_01",--我是G胖欢迎来到dota2
    
    }
    
    self.WAVE_START_MUSIC = {
        -- "MegaCreeps.Radiant.Ancient",
        -- "MegaCreeps.Dire.Ancient",
        -- "MegaCreeps.Radiant",
        -- "GameStart.DireAncient",
        -- "GameStart.RadiantAncient",
    
    
        "Tutorial.Quest.complete_01",
        "underlord_debut_takeover_stinger",
        "PlusPopup.expired",
        "DOTAMusic_Stinger.004",
        "DOTAMusic_Stinger.04",
        "greevil_eventstart_Stinger",
        "diretide_sugarrush_Stinger",
        "valve_ti6.stinger.dire_lose",
        "valve_ti7.stinger.dire_lose",
        "valve_ti7.stinger.dire_win",
    
    
    
    }

    
    --24
    self.WAVE_BATTLE_MUSIC = {
        "valve_ti10.music.battle_01",
        "valve_ti10.music.battle_02",
        "valve_ti10.music.battle_03",
        "valve_ti9.music.battle_01",
        "valve_ti9.music.battle_02",
        "valve_ti9.music.battle_03",
        "valve_ti8.music.battle_01",
        "valve_ti8.music.battle_02",
        "valve_ti8.music.battle_03",
        "valve_ti6.music.battle_01",
        "valve_ti6.music.battle_02",
        "valve_ti6.music.battle_03",
        "valve_ti5.music.battle_01",
        "valve_ti5.music.battle_02",
        "valve_ti5.music.battle_03",
        "valve_herodefense.music.normal_battle_04",
        "valve_herodefense.music.normal_battle_05",
        "valve_herodefense.music.normal_battle_06",
        "valve_herodefense.music.normal_battle_07",
        "valve_herodefense.music.normal_battle_08",
        "valve_herodefense.music.normal_battle_09",
        "valve_ti11.music.battle_01",
        "valve_ti11.music.battle_02",
        "valve_2021.music.battle_01",
        "valve_2021.music.battle_02",
        "valve_2021.music.battle_03",
    
    
        -- "valve_herodefense.music.normal_battle_03",  --取消
        -- "valve_herodefense.music.normal_battle_01",
        -- "valve_herodefense.music.normal_battle_02",
    }
    --15
    self.WAVE_BOSS_MUSIC = {
        "valve_ti7.music.battle_01",
        "valve_ti7.music.battle_02",
        "valve_ti7.music.battle_03",
        "jlin_01.music.battle_01",
        "valve_herodefense.music.battle_01",
        "valve_herodefense.music.battle_02",
        "valve_herodefense.music.battle_03",
        "valve_herodefense.music.battle_04",
        "valve_herodefense.music.battle_05",
        "valve_herodefense.music.battle_06",
        "valve_herodefense.music.battle_07",
        "valve_herodefense.music.battle_08",
        "valve_herodefense.music.battle_09",
        "valve_herodefense.music.battle_10",
        "valve_herodefense.music.battle_11",
        "valve_herodefense.music.battle_12",
        "valve_herodefense.music.battle_13",
        "valve_herodefense.music.battle_14",
        "valve_herodefense.music.normal_battle_10",
       
    
    
    }
    --5
    self.WAVE_LAST_BOSS_MUSIC = {
        "valve_herodefense.music.last_battle_02",
        "valve_herodefense.music.last_battle_01",
        "valve_herodefense.music.last_battle_03",
        "valve_herodefense.music.last_battle_04",

    }
    self.WAVE_REST_MUSIC = {
        "valve_herodefense.music.rest_08",
        "valve_herodefense.music.rest_07",
        "valve_herodefense.music.rest_06",
        "valve_herodefense.music.rest_05",
        "valve_herodefense.music.rest_04",
        "valve_herodefense.music.rest_03",
        "valve_herodefense.music.rest_02",
        "valve_herodefense.music.rest_01",
        -- "valve_ti11.music.countdown",
        -- "valve_ti11.music.laning_02_layer_01",
    }
    
    
    self.HERO_DEATH_MUSIC = {
        "soundboard.gan_ma_ne_xiong_di",
        "soundboard.hu_lu_wa",
        "soundboard.next_level",
        "soundboard.ni_xing_ni",
        "soundboard.ow",
        "soundboard.piao_liang",
        "soundboard.sad_bone",
        "soundboard.ti10eventgame.reward2",
        "soundboard.ti10eventgame.reward4",
        "soundboard.ti9.crowd_groan",
        "soundboard.wan_bu_liao_la",
        "soundboard.zai_jian_le_bao_bei",
        "soundboard.zou_hao_bu_song",  -- 13
        "announcer_dlc_bastion_announcer_event_neg_11",
        "teamfandom.2.15.140198",  --それはどうかな
        "teamfandom.2.15.140200",  --nana nothing to say
        "teamfandom.2.39.140099",  --run run run run run
        "teamfandom.2.4.140163",   --他们说什么也不会去了
        "teamfandom.2.4.140164",   --到点了
        "teamfandom.2.6209166.140033", --哎哟
        "teamfandom.2.6209166.140034", --星辰永不灭
        "teamfandom.2.726228.140168",--人生有梦各自精彩
        "teamfandom.2.726228.140169",--朋友一生一起走
        "teamfandom.2.7407260.140176",--整点阳间的东西
        "teamfandom.2.7407260.140175",--我死不了
        "teamfandom.2.8180753.140040",--shame
        "teamfandom.2.8180753.140041",--お前はもう死んでいる
        "teamfandom.2.8261197.140269",--何？
        "teamfandom.2.8261197.140268",--u think u good?ah?
        "teamfandom.2.8204512.140239",--救大哥，救救救救
        "teamfandom.2.8204512.140238",--uwa
        "teamfandom.2.8204512.140237",--老子就跟你们五个打了怎么了？
        "teamfandom.2.1520578.140222",--感觉你是真的有点急了
        "teamfandom.2.1520578.140223",--诶我是真的有点烦了
        "teamfandom.2.1520578.140224",--回去吧你太老了
        "teamfandom.2.6209804.140228",--到点了到点了
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_06", --G胖：请联系我让我知道你的怒气
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_07", --G胖：这让我想起夏季促销
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_18", --G胖：又发生了一次
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_49", --G胖：这是一次很好的学习机会     45
        "hoodwink_hoodwink_acorn_en_10",  --小松鼠：应得的报应
        "hoodwink_hoodwink_acorn_en_11",  --小松鼠：真是个软蛋
        "hoodwink_hoodwink_arb_hit_07",  --小松鼠：不敢相信你就傻坐在那
        "hoodwink_hoodwink_arb_hit_12",  --小松鼠：你还是死一边去吧
        "hoodwink_hoodwink_arb_hit_19",  --小松鼠：现在你 要好自为之吼
        "hoodwink_hoodwink_win_04",  --小松鼠：这就是我说的 速战速决
        "hoodwink_hoodwink_shitwiz_01",  --小松鼠：垃圾魔法师
        "hoodwink_hoodwink_nomana_12",  --小松鼠：我需要魔法
        "hoodwink_hoodwink_net_miss_05",  --小松鼠：兄弟
        "hoodwink_hoodwink_kill_19",  --小松鼠：下次不要在内急的时候被逮住
        "teamfandom.ti2021.yuno", --你这么菜你队友不会生气吧哥哥
        "teamfandom.ti2021.yammers",--好好打好好打别送了兄弟们
        "teamfandom.ti2021.mrrr",--啊？不会吧
        "teamfandom.3.8204512.140628",--兄弟们出大事了
        "teamfandom.2.8261197.140269",--nani     -62
        "teamfandom.2.8230115.140360",---         63
        "teamfandom.2.8118983.140343",--hhhhh   64
        "teamfandom.2.4.140162",--要不下把？   65
        "teamfandom.5.8740972.141296", --发生什么事了？
    
    
    }
    self.HERO_BACK_MUSIC = {
        "soundboard.gan_ma_ne_xiong_di",
        "soundboard.what_just_happened",
        "soundboard.what_the_f_just_happened",
        "soundboard.youre_a_hero", --4
        "teamfandom.2.15.140199",--真有你的呀
        "teamfandom.2.2163.140018",--nice work bro
        "teamfandom.2.726228.140170",--不是，你怎么这么能装呢
        "teamfandom.2.6209166.140035",--又让你给装到了
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_18",--G：谁做了这些BUG
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_32",--G：你是个美丽的有着迷人的魅力的人
        "announcer_dlc_gaben_killing_spree_gaben_ann_kill_followup_38",--G：你做得很好，我为你自豪
        "teamfandom.2.8214850.140245", --你怕不怕嘛
        "teamfandom.3.8442622.140612",--听不懂
        "teamfandom.2.8261197.140269"--nani
        
    }
    
    self.achievement_receive = {
        "Loot_Drop_Stinger_Ancient",
        "ui.weekend_tournament_winner_screen",
        "UI.Bounty.Failed",
        "UI.Bounty.Reminder", 
        "versus_stinger_2022_dire",
        "versus_stinger_2022_radiant",
    
        
    }

end


function game_music:PlayEndMusic()
    local music = RandomInt(1, #self.WAVE_END_MUSIC)
    print("music:")
    print(music)
    print("--------------------")
    EmitGlobalSound(self.WAVE_END_MUSIC[music])
end



function game_music:PlayStartMusic()
    local music = RandomInt(1, #self.WAVE_START_MUSIC)
    print("start music:"..music)
    print("--------------------")
    EmitGlobalSound(self.WAVE_START_MUSIC[music])
end


function game_music:PlayGameStartMusic()
    -- local index = RandomInt(1, #self.GAME_START_MUSIC)
    -- EmitGlobalSound(self.GAME_START_MUSIC[index])
end


function game_music:PlayBattleMusic()
    local MUSIC =RandomInt(1, #self.WAVE_BATTLE_MUSIC)
    EmitGlobalSound(self.WAVE_BATTLE_MUSIC[MUSIC])
end

function game_music:PlayBossMusic()
    local bossmusic =RandomInt(1, #self.WAVE_BOSS_MUSIC)
    print("play boss music="..bossmusic)
    EmitGlobalSound(self.WAVE_BOSS_MUSIC[bossmusic])
end

function game_music:PlayLastBossMusic()
    local bossmusic =RandomInt(1, #self.WAVE_LAST_BOSS_MUSIC)
    print("play boss music="..bossmusic)
    EmitGlobalSound(self.WAVE_LAST_BOSS_MUSIC[bossmusic])
end

function game_music:PlayRestMusic()
    local MUSIC =RandomInt(1, #self.WAVE_REST_MUSIC)
    EmitGlobalSound(self.WAVE_REST_MUSIC[MUSIC])
    print("play rest music="..MUSIC)
end

function game_music:PlayDeathMusic()
    EmitGlobalSound(self.HERO_DEATH_MUSIC[RandomInt(1, #self.HERO_DEATH_MUSIC)])
end

function game_music:PlayBackMusic()
    EmitGlobalSound(self.HERO_BACK_MUSIC[RandomInt(1, #self.HERO_BACK_MUSIC)])
end


function game_music:GetAchievementSound()
    return self.achievement_receive[RandomInt(1, #self.achievement_receive)]
    -- EmitGlobalSound(self.HERO_BACK_MUSIC[RandomInt(1, #self.HERO_BACK_MUSIC)])
end


