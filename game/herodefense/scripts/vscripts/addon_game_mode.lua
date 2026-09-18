-- Generated from template
if CAddonTemplateGameMode == nil then
	_G.CAddonTemplateGameMode = class({})
end



require("key")
require("internal/keyvalues")
require( "constants" ) -- require constants first
require( "setting" )


local event = false      --活动开启
if event then
    _G.GAME_BOSS_SPELL_INDEX_2 = 2
    _G.GAME_END_BONUS_INDEX_EVENT = 1.35    
end


require("decrypt_f/toolsModeCheck")
require("internal/shop_list")
table.unpack = unpack;
require( "internal/player" )
require('internal/funcs2')
require("internal/string_utils")
require("decrypt_f/https")
require("internal/weather_controler")





require("internal/player_cdk")
-- LOCAL_DEBUG_TOOLS_REQUIRE
-- GameRules:Playtesting_UpdateAddOnKeyValues()


-- require("internal/Myspawner") --怪物生成器
require('decrypt_f/funcs')
require('decrypt_f/hdHeroFuncs')
require('internal/damage_modify')



require('internal/game_music')
require('internal/ability_funcs')
require('internal/notifications')
require("internal/json")

require('internal/util')
require("internal/notifications")



require('internal/timers')
-- require("challenge")  --苦难试炼
-- require("decrypt_f/BonusItems")  --道具奖励
require("internal/vector_target")  --道具奖励
-- require("internal/player_effect")  --特效
-- require("decrypt_f/fellOmen")
-- require("decrypt_f/particleManager")



require("internal/Egg_sound")
require( "internal/filters" )
-- require( "decrypt_f/customDataManager" )




-- require( "internal/custom_indicator" )
-- require("internal/better_cooldown")
xpTable  = require( "internal/xp_table" )

-- require("internal/problem")  --暂时方案

require("modifier/hd_modifier")
require("modifier/shrine_system")



require("internal/game_light_control")


require("modifier_link")

--预载入
function Precache( context )


    local tPrecacheList = require("precache")
	for sPrecacheMode, tList in pairs(tPrecacheList) do
		for _, sResource in pairs(tList) do
			PrecacheResource(sPrecacheMode, sResource, context)
		end
	end

    --道具
    PrecacheItemByNameSync("item_tombstone", context)
    
    
    PrecacheResource("model_folder", "models/development", context)
    PrecacheResource("model", "models/props_gameplay/tombstoneb01.vmdl", context)
    --关卡
    PrecacheResource( "particle", "particles/rebuild/boss/fight/stack.vpcf", context )--BOSS战倒计时
    PrecacheResource("particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect.vpcf", context)--虚空
    PrecacheResource("particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect_purple.vpcf", context)--虚空
    PrecacheResource( "particle", "particles/rebuild/creeps_spell/sf/final_end.vpcf", context )--SF
    PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", context )--圣物掉落特效
    

    --模型，傻逼V社，他妈的，今天是大年初二，你给我全搞坏了，我要杀了你
    -- PrecacheResource( "model", "models/items/techies/techies_ti9_immortal_prox_mine/techies_ti9_immortal_prox_mine.vmdl", context )
    -- PrecacheResource( "model", "", context )


    -- PrecacheResource( "model", "models/heroes/shadow_fiend/shadow_fiend.vmdl", context )--S1传说挑战月影魔
    -- PrecacheResource( "model", "models/heroes/storm_spirit/storm_spirit.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/queenofpain/queenofpain.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/darkreef/prisoner_crab/darkreef_prisoner_crab.vmdl", context )--水螃蟹
    -- PrecacheResource( "model", "models/monster/cyclops/cyclops.vmdl", context )--巨人
    -- PrecacheResource( "model", "models/monster/element/lava/lava_emental.vmdl", context )--中火
    -- PrecacheResource( "model", "models/monster/troll/troll.vmdl", context )--巨魔
    -- PrecacheResource( "model", "models/monster/harpy/sk_harpy.vmdl", context )--鹰身女妖
    -- PrecacheResource( "model", "models/monster/giant_crab/giant_crab.vmdl", context )--黑螃蟹
    -- PrecacheResource( "model", "models/rebuild/earthspirit/earthspirit_override.vmdl", context )--中土
    -- PrecacheResource( "model", "models/monster/monster_1/monster_001.vmdl", context )--脑虫
    -- PrecacheResource( "model", "models/items/rubick/rubick_arcana/rubick_arcana_cube_inverted.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/ursa/ursa.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_small.vmdl", context )
    -- PrecacheResource( "model", "models/items/broodmother/spiderling/araknarok_broodmother_araknarok_spiderling/araknarok_broodmother_araknarok_spiderling.vmdl", context )
    -- PrecacheResource( "model", "models/items/broodmother/spiderling/elder_blood_heir_of_elder_blood/elder_blood_heir_of_elder_blood.vmdl", context )
    -- PrecacheResource( "model", "models/items/broodmother/spiderling/thistle_crawler/thistle_crawler.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged_mega.vmdl", context )
    -- PrecacheResource( "model", "models/monster/giant_crab/giant_crab.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_a/n_creep_kobold_a.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_b/n_creep_kobold_b.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_frost.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/mega_greevil/mega_greevil.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/wisp/wisp.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/magnataur/magnataur.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/phantom_assassin/phantom_assassin.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/luna/luna.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/mirana/mirana.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/ogre_1/large_ogre.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant/treant_cis/treant_cis.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant/fungal_lord_shroomthing/fungal_lord_shroomthing.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/brewmaster/brewmaster_firespirit.vmdl", context )
    -- PrecacheResource( "model", "models/items/lycan/ultimate/frostivus2018_lycan_savage_beast_form/frostivus2018_lycan_savage_beast_form.vmdl", context )
    -- PrecacheResource( "model", "models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl", context )
    -- PrecacheResource( "model", "models/items/lycan/wolves/frostivus2018_lycan_winter_snow_wolf_wolves/frostivus2018_lycan_winter_snow_wolf_wolves.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/morphling/morphling.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/enchantress/enchantress.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/furion/furion.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/shadowshaman/shadowshaman.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/brewmaster/brewmaster_windspirit.vmdl", context )
    -- PrecacheResource( "model", "models/items/warlock/golem/greevil_master_greevil_golem/greevil_master_greevil_golem.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/brewmaster/brewmaster_voidspirit.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/brewmaster/brewmaster_earthspirit.vmdl", context )
    -- PrecacheResource( "model", "models/monster/werewolf/werewolf.vmdl", context )
    -- PrecacheResource( "model", "models/rebuild/earthspirit/earthspirit_override.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/tiny/tiny_01/tiny_01.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/razor/razor.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/ancient_apparition/ancient_apparition.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/treant_protector/treant_protector.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/antimage/antimage.vmdl", context )
    -- PrecacheResource( "model", "models/items/faceless_void/faceless_void_arcana/faceless_void_arcana_base.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/axe/axe.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/enchantress/enchantress.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/n_creep_crystal_kobold/kobold_c/n_creep_crystal_kobold.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_crystal_furbolg.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/dragon_knight_persona/dk_persona_dragon.vmdl", context )
    -- PrecacheResource( "model", "models/items/faceless_void/faceless_void_arcana/faceless_void_arcana_base.vmdl", context )
    -- --乱纪元
    -- PrecacheResource( "model", "models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/lane_creeps/ti9_crocodilian_dire/ti9_crocodilian_dire_ranged.vmdl", context )
    -- PrecacheResource( "model", "models/monster/element/molten/molten_emental.vmdl", context )
    -- PrecacheResource( "model", "models/items/broodmother/spiderling/the_glacial_creeper_creepling/the_glacial_creeper_creepling_dpc.vmdl", context )
    -- PrecacheResource( "model", "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl", context )
    -- PrecacheResource( "model", "models/monsters/monster00123/monster00123.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl", context )
    -- PrecacheResource( "model", "models/rebuild/creeps/chaotic_era_shielder/chaotic_era_shielder.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/mutant_croc/mutant_croc.vmdl", context )
    -- PrecacheResource( "model", "models/custom/creeps/golem/golem_lava.vmdl", context )
    -- PrecacheResource( "model", "models/custom/creeps/golem/golem.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/goblin/goblin.vmdl", context )
    -- PrecacheResource( "model", "models/monsters/monster00127/monster00127.vmdl", context )
    -- PrecacheResource( "model", "models/monsters/monster00129/monster00129.vmdl", context )
    -- PrecacheResource( "model", "models/monster/element/holy/holy_degenerate_emental.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant/np_desert_traveller_treant/np_desert_traveller_treant.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant/np_cute_cactus_treant/np_cute_cactus_treant.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant_flower_1.vmdl", context )
    -- PrecacheResource( "model", "models/items/furion/treant_stump.vmdl", context )
    -- PrecacheResource( "model", "models/rebuild/creeps/chaotic_era_chaoc_form/chaotic_era_chaoc_form.vmdl", context )
    -- PrecacheResource( "model", "models/items/warlock/golem/ti_8_warlock_darkness_apostate_golem/ti_8_warlock_darkness_apostate_golem.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/undying/undying_minion.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_small.vmdl", context )
    -- PrecacheResource( "model", "models/rebuild/creeps/chaotic_era_chaoc_form/chaotic_era_chaoc_form_particle.vmdl", context )
    -- PrecacheResource( "model", "models/rebuild/creeps/chaotic_era_chaoc_form/chaotic_era_chaoc_form_trail.vmdl", context )
    -- --苦难
    -- PrecacheResource( "model", "models/heroes/nevermore/nevermore.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/slark/slark.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/enigma/enigma.vmdl", context )
    -- PrecacheResource( "model", "models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/ice_biome/giant/ice_giant01.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/abyssal_underlord/abyssal_underlord_v2.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/luna/luna.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/razor/razor.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/leshrac/leshrac.vmdl", context )
    -- PrecacheResource( "model", "models/props_gameplay/donkey.vmdl", context )
    -- --召唤
    -- PrecacheResource( "model", "models/heroes/terrorblade/demon.vmdl", context )
    -- PrecacheResource( "model", "models/courier/aghanim_courier/aghanim_courier_flying.vmdl", context )
    -- PrecacheResource( "model", "models/creeps/darkreef/blob/darkreef_blob_01.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/abyssal_underlord/abyssal_underlord_portal_model.vmdl", context )
    -- PrecacheResource( "model", "models/monster/demon/demon_1/little_demon.vmdl", context )
    -- PrecacheResource( "model", "models/props_structures/tower_upgrade/tower_upgrade.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/venomancer/venomancer_ward.vmdl", context )
    -- PrecacheResource( "model", "models/heroes/juggernaut/juggernaut.vmdl", context )
    -- PrecacheResource( "model", "models/items/lycan/wolves/frostivus2018_lycan_winter_snow_wolf_wolves/frostivus2018_lycan_winter_snow_wolf_wolves.vmdl", context )
    -- PrecacheResource( "model", "models/items/broodmother/spiderling/dplus_malevolent_mother_malevoling/dplus_malevolent_mother_malevoling.vmdl", context )
    -- PrecacheResource( "model", "models/items/shadowshaman/serpent_ward/shaman_charmer_of_firesnake_ability/shaman_charmer_of_firesnake_ability.vmdl", context )
    -- PrecacheResource( "model", "models/hero_mount/chen/navi_combiend/the_wings_of_oberis.vmdl", context )

end



-- Create the game mode when we activate
function Activate()

    _G.GAME_CHAOTIC_OFFERING_FORM = {
        "0",
        "0",
        "0",
        "0",
        "0",
    }
    
    _G.GAME_SHOP_HIDDEN = {
        "0",
        "0",
        "0",
        "0",
        "0",
    }
    --全局变量
    _G.GAME_CHANGING_TIME_OF_DAY = false        --当前世界时间是否被强制改变
    _G.GAME_CHANGING_NIGHT_WORLD_RULE = false  --当前世界时间处于强制黑夜
    _G.GAME_SUCCESS = false                  --游戏成功/失败
    _G.GAME_GAME_ENDING = false
    _G.GAME_debugTesting = false
    _G.GAME_ROUND =0 --游戏波数


    -- RegisterCustomAnimationScriptForModel("models/heroes/axe/axe.vmdl", "animation/axe.lua")


    _G.GAME_MONSTER_TABLE = {}
    _G.GAME_MONSTER_TABLE_number = 0
    _G.GAME_MONSTER_Triger = 0
    _G.GAME_END_WAVE = 0  --游戏结束波数
    _G.GAME_GOLDEN_DAMAGE = 0  --用于野怪技能
    _G.GAME_DIFFICULTY = 0      --游戏难度
    _G.GAME_CHANLLENGE_DIFFICULTY = 0      --试炼难度
    _G.GAME_CHANLLENGE_Contest_Type = 0      --比赛类型 0为不开启 1为竞速 2为无尽
    _G.GAME_Contest_send = true   --排行榜数据是否完成  由于不一定计算排行榜数据 所以默认是以完成
    _G.GAME_pre_gameTime = 0    --选人阶段时间 竞速这个得去除
    _G.GAME_pre_exDieTime = 0  --额外的死亡次数
    _G.GAME_ENDLESS_WAVE = 0   --无尽波数
    _G.GAME_ENDLESS_WAVE_COUNT = 0   --无尽波击杀数
    _G.GAME_internal_index = 1  --刷怪间隔系数
    _G.GAME_UPDATE_SUCCESS_INDEX = 0 --记录游戏结算时成功储存数据的玩家数量 当成功数小于玩家数量时不会结束游戏
    _G.GAME_LOGIN_SUCCESS_INDEX = 0 --记录游戏登录时成功储存数据的玩家数量 当成功数小于玩家数量时不会结算游戏奖励也无法使用商城
    _G.GAME_PREPARE_INDEX = 0  --踩踏板的玩家数量
    _G.GAME_PLAYER_number = 0  --游戏里的玩家数（英雄数）
    _G.GAME_WAVE_GOLD_BONUS = 1500  --每波金币奖励
    _G.GAME_FAIL_TIME = 0  --用于游戏失败倒计时
    _G.GAME_ENDLESSMODE_overtime = 0  --无尽模式超时
    _G.GAME_ENDLESSMODE_overtime_conter = 0  --无尽模式超时计数器
    _G.GAME_BONUS_INDEX = 1 --奖励系数（被新手玩家数量影响）
    _G.GAME_ORDER_TYPE = 2  --用于选择指令
    _G.GAME_Challenge_gold_bonus_index = 1  --苦难金币奖励系数(用于赏金猎人的天赋)
    _G.GAME_BOSS_SPELL_INDEX = 1 --BOSS技能产出几率因数
    _G.GAME_BOSS_SPELL_INDEX_2 = 1  --BOSS技能产出因数2  （活动）
    _G.GAME_END_BONUS_INDEX_EVENT = 1  --针对可靠经验与黄金的增幅
    _G.GAME_MAP_NAME  = GetMapName()
    _G.GAME_ISLASTDAY = false
    _G.GAME_Greevils_Greed = 0  --贪婪累计技能书奖励
    _G.GAME_TIME_SCALE = 1 --游戏时间系数
    _G.GAME_TIME_SCALE_SAVE = 1 --游戏时间系数暂存
    _G.GAME_mana_shield_unlock1_bonus = 0
    _G.GAME_MAP_WAVE_Localize = {
        camp_defense = "#DOTA_HUD_GAME_WAVE_CD_ROOM",

    }

    _G.BOSS_Defeated ={}  --击败的boss

    _G.GAME_GetServerTime = false --是否已经获得服务器时间 没获得将不会获取玩家数据
    _G.GAME_END_WAVE_Trigger = false  --是否开启无尽波
    _G.GAME_END_GAME = false
    _G.GAME_THE_LAST_ONE = true


    _G.Game_Mode = {
        difficulty = -1,
        game_shop_type = -1,
        player_count = -1,
        challenge_difficulty = -1,
        ChaoticEraMod = -1,
    }


    --玩家当前是否可以购买商品 用于互斥操作
    _G.GAME_CAN_BUY = {
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,

    }

    _G.Game_Item_ReRoll_chance ={
    
    }
    _G.Game_Challenge_ReRoll_chance ={
    
    }

    _G.GAME_LOGIN = {


    }
    _G.Game_timer = 0
    _G.Game_message = 0
    
    -- _G.GAME_HERO_NUMBER = 0  --游戏内玩家数
    _G.GAME_HERO_GROUP = {}  --存在的英雄单位表
    _G.GAME_IN = 0


	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()


 
    GameRules:SetFilterMoreGold(true)
    --攻击速度上限
    GameRules:GetGameModeEntity():SetMaximumAttackSpeed(3000)
    --控制是否使用正常的DOTA英雄重生规则。
    GameRules:SetHeroRespawnEnabled(false)
    --设置是否可以选择相同的英雄。
    -- GameRules:SetSameHeroSelectionEnabled(true)
    --设置tp格的道具
    GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride( "item_new_bottle" )  
    GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )  
 	GameRules:SetCustomGameAllowHeroPickMusic( false )
 	GameRules:SetCustomGameAllowBattleMusic( false )
	GameRules:SetCustomGameAllowMusicAtGameStart( false )
    --自定义最大团队数量
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS,5)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS,0)
    --初始金钱
    if IsInToolsMode() or _G.GAME_debugTesting then
        GameRules:SetStartingGold(90000) 
    else
        GameRules:SetStartingGold(2500)
    end
    
    -- 队伍选择阶段倒计时
    GameRules:SetCustomGameSetupAutoLaunchDelay(5)
    -- 默认锁定队伍
    GameRules:LockCustomGameSetupTeamAssignment(true)




    mode = GameRules:GetGameModeEntity()
    -- mode:SetFogOfWarDisabled(true)
    --基础属性配置
    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP,30)
    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR,0.1)
    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED,0.6)
    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN,0.15)
    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_ALL_DAMAGE,0.55)
    -- mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT,0.07)
    -- mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESIST,0)
    -- mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN ,0.01)
    --可以在任何地方出售装备
    mode:SetCanSellAnywhere(true)

    -- mode:SetCustomAttributeDerivedStatValue(10,0.15)
    -- mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESIST,0)

    --禁止玩家自己带天气特效
    mode:SetWeatherEffectsDisabled( true )
    mode:SetAnnouncerDisabled(true)

    -- mode:SetCustomTerrainWeatherEffect( "particles/new_effect/weather/new_snow.vpcf" )
    -- mode:SetCameraDistanceOverride(2000)
	mode:SetUseCustomHeroLevels(true)
    mode:SetCameraSmoothCountOverride(20)
	mode:SetCustomXPRequiredToReachNextLevel(xpTable)
    --https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Panorama/Javascript/API#DotaDefaultUIElement_t
    --隐藏夜靥Top英雄
    mode:SetHUDVisible(20, false)
    --隐藏信使
    mode:SetHUDVisible(9, false)
    --隐藏建议装备
    mode:SetHUDVisible(12, false)
	--是否启动买活。
	mode:SetBuybackEnabled(false)
    --设置玩家在策略阶段和进入赛前阶段之间的时间。
	GameRules:SetShowcaseTime(5)
	--设置玩家在选择英雄和进入展示阶段之间的时间。
	GameRules:SetStrategyTime(1)
    GameRules:SetHeroSelectionTime(180) --英雄选择时间
    GameRules:SetHeroSelectPenaltyTime(0)  --扣钱时间
    GameRules:SetUseUniversalShopMode(true)
    --启用或禁用看不见的战争迷雾。当启用地图的各个部分时，玩家从未见过的部分将被战争迷雾完全隐藏。
	mode:SetUnseenFogOfWarEnabled(false)
    --是否隐藏推荐物品
	mode:SetStickyItemDisabled(true)
    --用于禁用死亡时的黄金损失。
	mode:SetLoseGoldOnDeath(false)
	--设置单位的最低攻击速度。
	mode:SetMinimumAttackSpeed(70)
    --覆盖顶部游戏栏上的团队值。
	mode:SetTopBarTeamValuesOverride(true)
	--打开/关闭顶部游戏栏上的团队值。
	mode:SetTopBarTeamValuesVisible(true)
    mode:SetNeutralStashTeamViewOnlyEnabled(false)
    mode:SetStashPurchasingDisabled(false)
    --设置血条颜色
    SetTeamCustomHealthbarColor(DOTA_TEAM_GOODGUYS, 124, 249, 148 )
    SetTeamCustomHealthbarColor(1, 231,193, 61 )	

    if IsInToolsMode() then
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
            local m = collectgarbage('count')
            print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m/1024))
            player_database:UpdateAllPlayerParticleState()
            return 5
        end, 0)
    end

    if RandomInt(1, 10)==1 then
        _G.GAME_THE_LAST_ONE = false
    end
    Initialize(false)




    local hCaster = nil
	if IsInToolsMode() then
		hCaster = GameRules:GetGameModeEntity()
	end

    _G.MODIFIER_GLOBAL_DUMMY = CreateModifierThinker(hCaster, nil, "modifier_events", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
    _G.RECORD_SYSTEM_DUMMY = CreateModifierThinker(hCaster, nil, "modifier_record_system_dummy", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)



    -- print("_G.MODIFIER_GLOBAL_DUMMY=".._G.MODIFIER_GLOBAL_DUMMY)
    -- 定义需要预加载的单位列表
    local npc_list = {
        "npc_monster_wave_1_1",
        "npc_monster_wave_1_2",
        "npc_act1_gold",
        "npc_monster_wave_2_1",
        "npc_monster_wave_2_2",
        "npc_monster_wave_3_1",
        "npc_monster_wave_3_2",
        "npc_monster_wave_3_3",
        "npc_monster_wave_3_4",
        "npc_monster_wave_3_5",
        "npc_monster_wave_3_6",
        "npc_monster_darkreef_prisoner_crab",
        "npc_dota_creature_bear_cave_ursa",
        "npc_monster_wave_5_1",
        "npc_monster_wave_4_1",
        "npc_monster_wave_4_2",
        "npc_monster_wave_4_3",
        "npc_monster_wave_6_1",
        "npc_monster_wave_6_2",
        "npc_monster_big_crab",
        "npc_monster_wave_7_1",
        "npc_monster_wave_7_2",
        "npc_monster_wave_7_3",
        "npc_monster_little_greevil",
        "npc_monster_wave_8_1",
        "npc_monster_wave_8_2",
        "npc_dota_creature_cyclops",
        "npc_monster_wave_9_1",
        "npc_monster_wave_10_1",
        "npc_monster_wave_31_1",
        "npc_monster_wave_11_1",
        "npc_monster_wave_11_2",
        "npc_monster_wave_12_1",
        "npc_monster_wave_12_2",
        "npc_dota_creature_ogre_tank",
        "npc_monster_wave_13_1",
        "npc_monster_wave_13_2",
        "npc_monster_wave_13_3",
        "npc_monster_wave_22_1",
        "npc_monster_middle_fire_element",
        "npc_monster_wave_14_1",
        "npc_monster_wave_14_2",
        "npc_monster_wave_14_3",
        "npc_monster_wave_21_1",
        "npc_monster_Medium_water_element",
        "npc_dota_creature_troll",
        "npc_monster_wave_15_1",
        "npc_monster_harpy",
        "npc_monster_king_crab",
        "npc_monster_wave_16_1",
        "npc_monster_wave_16_2",
        "npc_monster_wave_23_1",
        "npc_monster_mega_greevil",
        "npc_monster_wave_24_1",
        "npc_monster_wave_26_1",
        "npc_monster_warewolf",
        "npc_monster_middle_earth_element",
        "npc_monster_wave_18_1",
        "npc_monster_wave_27_1",
        "npc_monster_wave_28_1",
        "npc_monster_Advanced_lackeys",
        "npc_monster_wave_17_1",
        "npc_monster_wave_25_1",
        "npc_hd_Claszian_Apostasy_phantom",
        "npc_monster_wave_19_1",
        "npc_hd_Brain_worm",
        "npc_monster_wave_20_1",
        "npc_monster_wave_34_1",
        "npc_monster_wave_35_1",
        "npc_monster_wave_36_1",
        "npc_monster_wave_31_1_clone",
        "npc_monster_wave_10_1_clone",
        "npc_hd_fire_dragon",
        "npc_hd_Claszian_Apostasy",
        "npc_hd_Supreme_Nevermore",
        "npc_hd_cadaver_collector",
        "npc_hd_wild_bear",
        "npc_hd_red_wolf",
        "npc_hd_Beast_King_Guard",
        "npc_hd_undead_archmage",
        "npc_hd_lightning_sphere_element",
        "npc_hd_advanced_lightning_sphere_element",
        "npc_hd_verdant_predator",
        "npc_hd_chaotic_executive",
        "npc_hd_astral_earth_element",
        "npc_hd_fanged_seeker",
        "npc_hd_unsee_unit",
        "npc_hd_healing_guard",
        "npc_hd_spirit_of_miyamoto",
        "npc_hd_chaotic_water",
        "npc_hd_chaotic_sprite_king",
        "npc_hd_spirit_of_sci_snake",
        "npc_hd_artifact_little_dragon",
        "npc_hd_artifact_sci_dragon",
        "npc_hd_doom_dummy",
        --苦难
        "npc_monster_challenge_001",
        "npc_monster_challenge_002",
        "npc_monster_challenge_003",
        "npc_monster_challenge_004",
        "npc_monster_challenge_005",
        "npc_monster_challenge_006",
        "npc_monster_challenge_007",
        "npc_monster_challenge_008",
        "npc_monster_challenge_009",
        "npc_shrine_1",
        "npc_shrine_2",
        "npc_shrine_3",
        "npc_shrine_4",
    }

    -- 遍历列表并预加载每个单位
    for _, unitName in ipairs(npc_list) do
        PrecacheUnitByNameAsync(unitName, function(...)
        end)
    end

end




--强制选一个随机英雄
function CAddonTemplateGameMode:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end
end







function CAddonTemplateGameMode:InitGameMode()

    --寒霜传送门
    require("internal/car_vectorability")
    if IsInToolsMode() then
        -- if IsServer() then
        --     Convars:RegisterCommand("reload_keyvalues", function()
        --         FireGameEvent("client_reload_game_keyvalues", {})
        --         GameRules:Playtesting_UpdateAddOnKeyValues()
        --     end, "Reload keyvalues", 67108864)
        --     Convars:RegisterCommand("reload_code", function()
        --         local watch_ability = Convars:GetStr("watch_ability")
                
        --         if watch_ability and watch_ability ~= "" and watch_ability ~= "no" then
        --             local t = GetAbilityKeyValuesByName(watch_ability)
        --             if t then
        --                 local scriptfile = t["ScriptFile"]
        --                 print(scriptfile)
        --                 if scriptfile then
        --                     SendToConsole("say 重载技能脚本:<" .. watch_ability .. ">")
        --                     SendToConsole("script_reload_code " .. scriptfile .. ";cl_script_reload_code " .. scriptfile .. ";")
        --                 else
        --                     SendToConsole("say 技能没有脚本:<" .. watch_ability .. ">")
        --                 end
        --             else
        --                 SendToConsole("say 没有这个技能:<" .. watch_ability .. ">")
        --             end
        --         else
        --             print("全重载了"..watch_ability)
        --             SendToConsole("say 重载全部代码")
        --             SendToConsole("script_reload;cl_script_reload;")
        --         end
        --     end, "Reload code", 67108864)
        --     Convars:RegisterConvar("watch_ability", "no", "Choose an ability to watch", FCVAR_REPLICATED)
        --     SendToConsole([[bind F5 "reload_code;"]])
        -- end
    end

    print( "Template addon is loaded." )
    --需要下面这个才能用GameRules:GetGameModeEntity().CAddonTemplateGameMode获取
    GameRules:GetGameModeEntity().CAddonTemplateGameMode = self

    self.spellsXPTable = {
        0,
        1000,
        2000,
        3000,
        4000,
        5000,
        6000,
        7000,
        8000,
        9000,
        10000,
        12000,
        14000,
        16000,
        18000,
        20000,
        22000,
        24000,
        26000,
        28000,
        30000,
        32000,
        34000,
        36000,
        45000,
    }





    -- GameRules:GetGameModeEntity():SetThink( "CheckPlayerAlive", self, "CheckPlayerState", 1 )
    GameRules:SetUseUniversalShopMode( true ) --设置全局商店 只要在商店范围即可购买所有物品
	--监听游戏进度
   ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CAddonTemplateGameMode,"OnGameRulesStateChange"), self)

   ListenToGameEvent( "player_chat", Dynamic_Wrap( CAddonTemplateGameMode, "OnPlayerChat" ), self )  --监听聊天信息输入

	--监听UI事件,这是新的事件管理器
    CustomGameEventManager:RegisterListener( "chaofengta", ChaoFeng )
    CustomGameEventManager:RegisterListener( "chaofengta2", ChaoFeng2 )
    SendToServerConsole("dota_max_physical_items_purchase_limit 9999")  --解决道具购买上限
    -- SendToServerConsole("dota_hud_healthbars 1")
    ---------技能上的的监听
    -- _G.holdout_card_points = holdout_card_points
    -- holdout_card_points:Init()

    -- _G.Game_State = Game_State
	-- Game_State:Init()


    	

    _G.player = player
    player:Init()

  


 

    _G.Egg_sound = Egg_sound
    Egg_sound:Init()

    _G.FilterManager = FilterManager
    FilterManager:Init()

    _G.player_database = player_database
    player_database:Init()

    _G.game_music = game_music
    game_music:Init()


    
    
    player_cdk:Init()
    -- LOCAL_DEBUG_TOOLS_INIT


	_G.game_light_control = game_light_control
	game_light_control:Init()



    
    -- _G.player_effect = player_effect
    -- _G.custom_indicator = custom_indicator
    -- custom_indicator:Init()

    --DPS
    self._nRoundNumber = 1
	self._currentRound = nil

	self._damagecount = {}
	self._damagecount[0] = 0
	self._damagecount[1] = 0
	self._damagecount[2] = 0
	self._damagecount[3] = 0
	self._damagecount[4] = 0
	self._physdamage = {}
	self._physdamage[0] = 1
	self._physdamage[1] = 1
	self._physdamage[2] = 1
	self._physdamage[3] = 1
	self._physdamage[4] = 1
	self._magdamage = {}
	self._magdamage[0] = 1
	self._magdamage[1] = 1
	self._magdamage[2] = 1
	self._magdamage[3] = 1
	self._magdamage[4] = 1
	self._puredamage = {}
	self._puredamage[0] = 1
	self._puredamage[1] = 1
	self._puredamage[2] = 1
	self._puredamage[3] = 1
	self._puredamage[4] = 1
	self._dpstick = 1
	self._playerNumber = 0
	self._goldRatio = 1
	self._expRatio = 1
	self._ischeckingdefeat = false
	self._defeatcounter = 5
    GameRules.GLOBAL_PLAYER_DATA = {}

    -- 怪的视野
    AddFOWViewer(3, Vector(1616,-1856,800), 5000, -1, false) --提供视野
    AddFOWViewer(3, Vector(-1856,-2944,800), 5000, -1, false) --提供视野
    AddFOWViewer(3, Vector(1216,1088,800), 5000, -1, false) --提供视野

    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(CAddonTemplateGameMode,"DamageFilter"), self)
    Timers:CreateTimer(2, function()
        GameRules:GetGameModeEntity():SetThink("OnUpdateThink", self, 2)
    end)
--------------------------------------------------------
end

function CAddonTemplateGameMode:OnUpdateThink()
	for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID(playerID) then
			local bossDamage = player_data_get_value(playerID, "bossDamage")
            -- print("damage="..bossDamage)
			CustomGameEventManager:Send_ServerToAllClients("dps_update", {damage = formated_number((bossDamage - self._damagecount[playerID])/self._dpstick ), id = playerID})
			CustomGameEventManager:Send_ServerToAllClients("heal_update", {damage = formated_number(PlayerResource:GetHealing(playerID)), id = playerID})
			CustomGameEventManager:Send_ServerToAllClients("damage_type_update", {physical = self._physdamage[playerID],magical = self._magdamage[playerID],pure = self._puredamage[playerID],id = playerID})
			CustomGameEventManager:Send_ServerToAllClients("damage_update", {damage = formated_number(bossDamage), id = playerID})
			CustomGameEventManager:Send_ServerToAllClients("damage_taken_update", {damage = formated_number(player_data_get_value(playerID, "damageTaken")), id = playerID})
			
		end
	end
	self._dpstick = self._dpstick + 1
	if self._dpstick > 15   then
		self._dpstick = 1
        for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            if PlayerResource:IsValidPlayerID(playerID) then
                local bossDamage = player_data_get_value(playerID, "bossDamage")
                self._damagecount[playerID] = bossDamage
            end
        end
        
	end
	return 0.66
end



function CAddonTemplateGameMode:DamageFilter(damageTable)
    -- PrintTable(damageTable)
    local victim = EntIndexToHScript(damageTable.entindex_victim_const or -1)
    local damageType = damageTable.damagetype_const
    local attacker_index = damageTable.entindex_attacker_const
    if not attacker_index then
        return true
    end
	local victim_index = damageTable.entindex_victim_const
    local ability =  EntIndexToHScript(damageTable.entindex_inflictor_const or -1)
    local attacker = EntIndexToHScript(attacker_index)
    -- local victim = EntIndexToHScript(victim_index)

    ----冰封路径伤害加深
    local have_modifier = victim:FindAllModifiersByName("modifier_Advanced_Ice_Path_debuff")
    if #have_modifier ~= 0  and damageType == 2 then
        damageTable.damage = damageTable.damage * (1 + have_modifier[1]:GetAbility():GetSpecialValueFor("bonus_damage") *0.01)
    end



    --dps处理


	if victim_index then
	
		if attacker and victim then
			if attacker.GetPlayerOwnerID then
				local attackerPlayerId = attacker:GetPlayerOwnerID()

				if victim  then
                    -- print("cal damage")
					if attackerPlayerId and attackerPlayerId >= 0 and IsEnemy(attacker, victim) then
                        -- print("modifier damage")
						player_data_modify_value(attackerPlayerId, "bossDamage", damageTable.damage)
						if damageTable.damagetype_const == DAMAGE_TYPE_MAGICAL then
							self._magdamage[attackerPlayerId] = self._magdamage[attackerPlayerId] + damageTable.damage
						elseif damageTable.damagetype_const == DAMAGE_TYPE_PHYSICAL  then
							self._physdamage[attackerPlayerId] = self._physdamage[attackerPlayerId] + damageTable.damage
                            
                        else
							self._puredamage[attackerPlayerId] = self._puredamage[attackerPlayerId] + damageTable.damage
						end
					end
				end

			end
		end
	end
    if damageTable.damage>1 then
        if attacker and victim then
            if attacker.GetPlayerOwnerID then
				local attackerPlayerId = attacker:GetPlayerOwnerID()
                if PlayerResource:IsValidPlayerID(attackerPlayerId) then
                    local player = PlayerResource:GetPlayer(attackerPlayerId)
                    if attacker== victim then
                        fHDSendCustomOverheadEventMessageForPlayer(player,"hd_damage", victim, math.floor(damageTable.damage), 1,  Vector(0,0,-150), DAMAGE_TAKE_COLOR_NORMAL, 0)
                        return true
                    end
                    local color = DAMAGE_COLOR_NORMAL
                    if ability then
                        if damageType==DAMAGE_TYPE_PHYSICAL  then
                            color = DAMAGE_COLOR_PHYSICAL
                        elseif damageType==DAMAGE_TYPE_MAGICAL  then
                            color = DAMAGE_COLOR_MAGICAL
                        elseif damageType==DAMAGE_TYPE_PURE  then
                            color = DAMAGE_COLOR_PURE
                        end
                    end
                  
                    fHDSendCustomOverheadEventMessageForPlayer(player,"hd_damage", victim, math.floor(damageTable.damage), 1, Vector(0,0,-100), color, 0)
                    return true
                end
            end
            if victim.GetPlayerOwnerID then
                local attackerPlayerId = victim:GetPlayerOwnerID()
                if PlayerResource:IsValidPlayerID(attackerPlayerId) then
                    local player = PlayerResource:GetPlayer(attackerPlayerId)
                    fHDSendCustomOverheadEventMessageForPlayer(player,"hd_damage", victim, math.floor(damageTable.damage), 1, Vector(0,0,-150), DAMAGE_TAKE_COLOR_NORMAL, 0)
                    return true
                end
               
            end
        end
    end

    



    return true
end

function CAddonTemplateGameMode:RecordDamage()
    self.damageTable_record = {
        damagecount ={
          
        },
        physdamage={
         
        },
        magdamage={
          
        },
        puredamage={
          
        },
        bossdamage = {
 
       
        }
    
    }

    for i = 0, 4, 1 do
        table.insert( self.damageTable_record.damagecount,0+self._damagecount[i] )
        table.insert( self.damageTable_record.physdamage,0+self._physdamage[i] )
        table.insert( self.damageTable_record.magdamage,0+self._magdamage[i] )
        table.insert( self.damageTable_record.puredamage,0+self._puredamage[i] )
        table.insert( self.damageTable_record.bossdamage, 0+player_data_get_value(i, "bossDamage"))
    end
end
function CAddonTemplateGameMode:ReSetDamageTable()
    if self.damageTable_record then
        for i = 0, 4, 1 do
            self._damagecount[i] = 0+self.damageTable_record.damagecount[i+1]
            self._physdamage[i] = 0+self.damageTable_record.physdamage[i+1]
            self._magdamage[i] = 0+self.damageTable_record.magdamage[i+1]
            self._puredamage[i] = 0+self.damageTable_record.puredamage[i+1]
            player_data_set_value(i, "bossDamage", 0+self.damageTable_record.bossdamage[i+1])
        end

    end

   
  
end





-- local type = 1
local index1 = 1
local host_time = 0.5
--个人嘲讽

function ChaoFeng( index,keys )
    -- local result = SendToServerConsole("status")
    -- print(result)
    --player_database:sendEffect(1,"heroTalent_npc_dota_hero_axe_4")   --送特效
    --player_database:sendEffect(10,"heroTalent_npc_dota_hero_ogre_magi_3")   --送特效
    -- customDataManager:SaveTestData(0)
    -- local steamID = tostring(PlayerResource:GetSteamID(0))
    -- customDataManager:ModifySingleCustomData(steamID,"pass_diff_1",3,1)


    if  _G.GAME_ORDER_TYPE==3 then
           --提供视野
        local heroes = GetAllRealHeroes()
        local caster
        for _, unit in pairs(heroes) do
            if tonumber(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())))==76561198284686620 or tonumber(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())))==76561198828335572 then
                caster = unit
                break
            end
        end
        local ability = caster:FindAbilityByName("Default_Move")

        local nearby_enemy_units = FindUnitsInRadius(
            caster:GetTeamNumber(), 
            Vector(0,0,0) , 
            nil, 
            15000, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            FIND_CLOSEST, 
            false
        )
        for _, unit in pairs(nearby_enemy_units) do
            unit:AddNewModifier(caster, ability, "modifier_debug_1", {})
        end 
    end



    if _G.GAME_ORDER_TYPE==4 then
        SpawnChallenge(keys.PlayerID,true)
     
    end
    if _G.GAME_ORDER_TYPE==5 then
        skillshop:RollBonusCore(50000)
     
    end



    


end

-- index_music = 5
function ChaoFeng2( index,keys )
    customDataManager:CheckAllCustomData(0)
    if _G.GAME_ORDER_TYPE==1 then
        -- CAddonTemplateGameMode:testBonus()  --内测结算
    end

end






function ReSetMusic(playerID)
    local player =PlayerResource:GetPlayer(playerID)
    Timers:CreateTimer(5, function()

        if  Game_State:IsInBattle() then
            if _G.GAME_ROUND==4 or _G.GAME_ROUND==8 or _G.GAME_ROUND==10 or _G.GAME_ROUND==14 or _G.GAME_ROUND==18 or _G.GAME_ROUND>=20 then
                print("boss music")
                if _G.GAME_ROUND>=_G.GAME_END_WAVE then
                    --播放最终boss音乐
                    game_music:PlayLastBossMusic()
                    -- EmitSoundOnClient(WAVE_LAST_BOSS_MUSIC[bossmusic],player)
           
                    
        
                    
                    
                else
                    --播放boss音乐
                    game_music:PlayBossMusic()
                    
                    
                end 
            else
                    --播放战斗音乐
                    game_music:PlayBattleMusic()
                    print("play battle music="..MUSIC)
            end
        end
    end)    

end

_G.xxx = 0
_G.yyy = 0
_G.zzz = 0
--玩家输入指令相关
function CAddonTemplateGameMode:OnPlayerChat(keys) 
	local text = keys.text
	local playerid = keys.playerid

    local hero = player:GetPlayerHero(playerid)
    local keys = {
        unit = hero,
        playerid = playerid,
        text = text,
    }
    FirePlayerChatEvent(keys)
    if string.sub(text,1,1)=="x" then
        local number = string.sub(text,2,17)
        number = tonumber(number)
        _G.xxx = number
    end
    if string.sub(text,1,1)=="y" then
        local number = string.sub(text,2,17)
        number = tonumber(number)
        _G.yyy = number
    end
    if string.sub(text,1,1)=="z" then
        local number = string.sub(text,2,17)
        number = tonumber(number)
        _G.zzz = number
    end



    -- '-setcamera int'
    if string.sub(text,1,10)=="-setcamera" then
       
        local number = string.sub(text,12,17)
        number = tonumber(number)
        -- print(number)
        
        if number~=nil then
            if number >=1500 then
                number = 1500
            elseif number<=0 then
                number = 0
            end
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "spells_menu_update_camera_dis", {dis=number })

            
        end
    end

    -- '-setcamera int'
    -- if string.sub(text,1,9)=="LUOGUODUO" then
       
    --     _G.GAME_CAN_TEST = true
    -- end


    if string.sub(text,1,9)=="-setorder" then
       
        _G.GAME_ORDER_TYPE =  tonumber(string.sub(text,10,10))
        print(_G.GAME_ORDER_TYPE)

    end
    if string.sub(text,1,9)=="-GetUnit" then
       
        local j = 0
        for i=0,9999,1 do 
            if EntIndexToHScript(i ) ~=nil then
             j=1 +j
            end 
        end 
        local m = collectgarbage('count')
        GameRules:SendCustomMessage("debug "..j.."单位存在", 1, -1)
        GameRules:SendCustomMessage(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m/1024), 1, -1)

        -- print(j)

    end
    if string.sub(text,1,9)=="-GetUnit2" then
       


        local m = collectgarbage('count')
        GameRules:SendCustomMessage(string.format("回收前[Lua Memory]  %.3f KB  %.3f MB", m, m/1024), 1, -1)
        collectgarbage("collect")
        local m = collectgarbage('count')
        GameRules:SendCustomMessage(string.format("回收后[Lua Memory]  %.3f KB  %.3f MB", m, m/1024), 1, -1)

        -- print(j)

    end

    if string.sub(text,1,13)=="ILoveThisGame" then
        game_event:GiftBonusBase(playerid,50,4000,20,DOTA_CUSTOM_GiftIndex_1)
    end

    

    


    if playerid and string.sub(text,1,20)=="爸爸我没钱了" or string.sub(text,1,20)=="DadINeedMoney" then
        -- print("pass")
        local hPlayerHero = PlayerResource:GetSelectedHeroEntity(playerid)
        if hPlayerHero  then
            local modifier = hPlayerHero:FindModifierByName("modifier_Advanced_Greevils_Greed_have_father")
            if modifier then
                modifier:CallFather()
            end
        end
    end

    if string.sub(text,1,30)=="-forcerelease" then
        for i = 1, 50000, 1 do
            ParticleManager:DestroyParticle(i,true)
            ParticleManager:ReleaseParticleIndex(i)
        end
    end


    if playerid and string.sub(text,1,20)=="we r a family" or string.sub(text,1,20)=="我们是一家人" then
        -- print("pass")
        local hPlayerHero = PlayerResource:GetSelectedHeroEntity(playerid)
        if hPlayerHero  then
            local modifier = hPlayerHero:FindModifierByName("modifier_heroTalent_npc_dota_hero_windrunner_2")
            if modifier then
                modifier:OnSendMessage()
            end
        end
    end

    -- if string.sub(text,1,12)=="checkCode" then
        
    --     if tonumber(tostring(PlayerResource:GetSteamID(playerid)))==76561198284686620 then
    --         -- GameRules:SendCustomMessage(_G.GAME_GLOBAL_KEY, 1, -1)
    --         -- GameRules:SendCustomMessage(_G.GAME_GLOBAL_KEY2, 1, -1)

    --         GameRules:SendCustomMessage(_G.GAME_TEST_KEY, 1, -1)

    --     end
       

    -- end


    -- if string.sub(text,1,25)=="npc_dota_hero_phoenix" then

    --     local heroes = GetAllRealHeroes()
        
    --     for _, hero in ipairs(heroes) do
    --         if hero:GetUnitName()=="npc_dota_hero_phoenix" then
    --             hero:AddAbility("heroTalent_npc_dota_hero_phoenix_3"):SetLevel(1)
    --         end
    --     end
    --     -- CAddonTemplateGameMode:GiftBonus2(playerid)

    -- end

    -- if string.sub(text,1,8)=="BETATEST" then

    --     game_event:GiftBonusBase(playerid,200,0,0,DOTA_CUSTOM_GiftIndex_BETA)
    -- end

    -- if string.sub(text,1,8)=="BREAK" then

    --     game_event:GiftBonusBase(playerid,500,100000,0,DOTA_CUSTOM_GiftIndex_NICEFIX12)
    -- end


    -- if string.sub(text,1,10)=="wohaoshuai" then

    --     game_event:GiftBonusBase(playerid,100,20000,0,DOTA_CUSTOM_GiftIndex_NICEFIX6)

    -- end

    -- if string.sub(text,1,20)=="DoYouLoveMe" then

    --     game_event:GiftBonusBase(playerid,400,40000,0,DOTA_CUSTOM_GiftIndex_NICEFIX7)

    -- end

    -- if string.sub(text,1,20)=="NICEFIX2022" then

    --     game_event:GiftBonusBase(playerid,100,20000,0,DOTA_CUSTOM_GiftIndex_NICEFIX8)

    -- end

    -- if string.sub(text,1,20)=="NICEFIX731" then

    --     game_event:GiftBonusBase(playerid,1000,100000,0,DOTA_CUSTOM_GiftIndex_NICEFIX9)

    -- end
    -- if string.sub(text,1,20)=="FengKuangZhouWu" then

    --     game_event:GiftBonusBase(playerid,100,15000,0,DOTA_CUSTOM_GiftIndex_NICEFIX10)

    -- end
    -- if string.sub(text,1,20)=="325" then

    --     game_event:GiftBonusBase(playerid,100,20000,0,DOTA_CUSTOM_GiftIndex_NICEFIX11)

    -- end
    -- if string.sub(text,1,20)=="LGD" then

    --     game_event:GiftBonusBase(playerid,500,100000,0,DOTA_CUSTOM_GiftIndex_NICEFIX13)

    -- end

    if string.sub(text,1,8)=="Newstage" then
        game_event:GiftBonusBase(playerid,500,20000,15,DOTA_CUSTOM_GiftIndex_NICEFIX14)
    end


    if string.sub(text,1,8)=="-settype" then
        _G.GAME_CHAOTIC_OFFERING_FORM[playerid+1]  =  string.sub(text,9,10)
    end

    if string.sub(text,1,8)=="-sethide" then
        _G.GAME_SHOP_HIDDEN[playerid+1]  =  string.sub(text,9,10)
    end

    
    --[[if string.sub(text,1,8)=="-givelvl" then
        if not IsServer() then
            return
        end
        local player = PlayerResource:GetPlayer(playerid)
        local playerHero = player:GetAssignedHero()
        if not playerHero then
            return
        end
        GameRules:SendCustomMessage("等级效果发生", 1, -1)
        local caster = playerHero
        local heroes = FindUnitsInRadius(
            caster:GetTeamNumber(), 
            Vector(0,0,0) , 
            nil, 
            15000, 
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
            DOTA_UNIT_TARGET_HERO, 
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
            FIND_CLOSEST, 
            false
        )
        for _, unit in pairs(heroes) do
            unit:SetLevel(unit:GetLevel()+10)
        end 
    end]]
    
    -- if string.sub(text,1,9)=="-fixmodel" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     if not playerHero then
    --         return
    --     end
    --     GameRules:SendCustomMessage("当你发现怪物模型消失了请尝试一下输入此指令看看能不能解决,注意此举可能造成卡顿，没必要不要使用。", 1, -1)
    --     -- local heroes = GetAllRealHeroes()
    --     local caster = playerHero
    --     local ability = caster:FindAbilityByName("Default_Move")
    --     local nearby_enemy_units = FindUnitsInRadius(
    --         caster:GetTeamNumber(), 
    --         Vector(0,0,0) , 
    --         nil, 
    --         15000, 
    --         DOTA_UNIT_TARGET_TEAM_ENEMY, 
    --         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    --         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
    --         FIND_CLOSEST, 
    --         false
    --     )
    --     for _, unit in pairs(nearby_enemy_units) do
    --         unit:AddNewModifier(caster, ability, "modifier_debug_2", {duration = 20})
    --     end 
    -- end




    -- if string.sub(text,1,8)=="-fixbug1" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     if not playerHero then
    --         return
    --     end
       
    --     local caster = playerHero
    --     local bottle = caster:AddItemByName("item_ward_sentry")
      
    -- end

    -- if string.sub(text,1,8)=="-fixbug2" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     if not playerHero then
    --         return
    --     end
    --     local caster = playerHero
       
    --     local nearby_enemy_units = FindUnitsInRadius(
    --         caster:GetTeamNumber(), 
    --         Vector(0,0,0) , 
    --         nil, 
    --         15000, 
    --         DOTA_UNIT_TARGET_TEAM_ENEMY, 
    --         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    --         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
    --         FIND_CLOSEST, 
    --         false
    --     )
    --     for _, unit in pairs(nearby_enemy_units) do
    --         unit:SetTeam(2)
    --         Timers:CreateTimer(0.05, function()
    --             unit:SetTeam(1)
    --         end)
    --     end 
      
    -- end

    -- if string.sub(text,1,20)=="-kill" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     if not playerHero then
    --         return
    --     end
        
    --     playerHero:Kill(nil,playerHero)
    -- end
    -- if string.sub(text,1,8)=="-fixbug3" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     if not playerHero then
    --         return
    --     end
    --     local caster = playerHero
       
    --     local nearby_enemy_units = FindUnitsInRadius(
    --         caster:GetTeamNumber(), 
    --         Vector(0,0,0) , 
    --         nil, 
    --         15000, 
    --         DOTA_UNIT_TARGET_TEAM_ENEMY, 
    --         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    --         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
    --         FIND_CLOSEST, 
    --         false
    --     )
    --     for _, unit in pairs(nearby_enemy_units) do
    --         unit:SetTeam(4)
          
    --     end 
      
    -- end


    -- if string.sub(text,1,8)=="-fixbug4" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     if not playerHero then
    --         return
    --     end
    --     local caster = playerHero
       
    --     local nearby_enemy_units = FindUnitsInRadius(
    --         caster:GetTeamNumber(), 
    --         Vector(0,0,0) , 
    --         nil, 
    --         15000, 
    --         DOTA_UNIT_TARGET_TEAM_ENEMY, 
    --         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    --         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
    --         FIND_CLOSEST, 
    --         false
    --     )
    --     for _, unit in pairs(nearby_enemy_units) do
    --         unit:SetTeam(1)
    --     end 
      
    -- end
    -- if string.sub(text,1,5)=="-kill" then
    --     local player = PlayerResource:GetPlayer(playerid)
    --     local playerHero = player:GetAssignedHero()
    --     playerHero:ForceKill(false)
    -- end
    
end



-- When game state changes set state in script
function CAddonTemplateGameMode:OnGameRulesStateChange()
    local nNewState = GameRules:State_Get()
    if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        game_music:PlayGameStartMusic()
        self:SetUpPlayerShop()  --设置商店
        --设置服务器时间
        self.serverTime = "2021-08-30 19:16:20"
        print("获取黑市与时间")
        player_database:GetBlackMarket(self.PlayerShop)
        self.freeSpellMap = {}
        player_database:GetFreeSpell()

    elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        print("玩家数据初始化")
        self:GeSpellsDataFromServer() --从服务器读取数据
        -- PauseGame(true)
        -- Convars:SetFloat("host_timescale", 0.2)
    elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        -- 为没选英雄的玩家随机选择英雄
        for i = 0, PlayerResource:GetPlayerCount() - 1 do
            if PlayerResource:IsValidPlayer(i) and not PlayerResource:HasSelectedHero(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
                PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
                PlayerResource:SetCanRepick(i, false)
            end
        end
    elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
    elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

    end
end




--商城内容 js与lua为相同的一份 但js仅用于展示 处理需要利用lua里的数据
function CAddonTemplateGameMode:SetUpPlayerShop()
    print("set up shop")
    self.PlayerShop = {

        --白金购买
        {
            Exchange_for_platinum_01={   
                item_name="Exchange_for_platinum_01",
                cost_class = 0,
                cost=10,   --10
                bonustype = 1,
                bonus = 100,
            },
            Exchange_for_platinum_02={   
                item_name="Exchange_for_platinum_02",
                cost_class = 0,
                cost=19,--19
                bonustype = 1,
                bonus = 200,
            },
            Exchange_for_platinum_03={   
                item_name="Exchange_for_platinum_03",
                cost_class = 0,
                cost=40,--40
                bonustype = 1,
                bonus = 500,
            },
            Exchange_for_platinum_04={   
                item_name="Exchange_for_platinum_04",
                cost_class = 0,
                cost=75,--75
                bonustype = 1,
                bonus = 1000,
            },
            Exchange_for_platinum_05={   
                item_name="Exchange_for_platinum_05",
                cost_class = 0,
                cost=140,--140
                bonustype = 1,
                bonus = 2000,
            },
            Exchange_for_platinum_06={   
                item_name="Exchange_for_platinum_06",
                cost_class = 0,
                cost=260,--260
                bonustype = 1,
                bonus = 4000,
            },
            Exchange_for_platinum_07={   
                item_name="Exchange_for_platinum_07",
                cost_class = 0,
                cost=530,--530
                bonustype = 1,
                bonus = 10000,
            },
    
        },
    
    
        --特权
        {
            Shop_Fast_learning={   
                item_name="Shop_Fast_learning",
                cost_class = 2,
                cost=100,
                addday = "30",
            },
            Shop_Alchemy={   
                item_name="Shop_Alchemy",
                cost_class = 2,
                cost=100,
                addday = "30",
            },
            Shop_Metallurgy={   
                item_name="Shop_Metallurgy",
                cost_class = 2,
                cost=100,
                addday = "30",
            },
            Shop_Metallurgy_2={   
                item_name="Shop_Metallurgy",
                cost_class = 2,
                cost=1000,
                addday = "36500",
            },
            -- Shop_fool={   
            --     item_name="Shop_fool",
            --     cost_class = 2,
            --     cost=1000,
            --     addday = "36500",
            -- },
            Shop_ban_fellOmen={   
                item_name="Shop_ban_fellOmen",
                cost_class = 2,
                cost=150,
                addday = "30",
            },

            Shop_Refresh_Chaoticera_spell={   
                item_name="Shop_Refresh_Chaoticera_spell",
                cost_class = 2,
                cost=200,
                addday = "30",
            },

            Shop_artifact_bonus_exp={   
                item_name="Shop_artifact_bonus_exp",
                cost_class = 2,
                cost=300,
                addday = "30",
            },
            Shop_artifact_bonus_exp_2={   
                item_name="Shop_artifact_bonus_exp_2",
                cost_class = 2,
                cost=1700,
                addday = "30",
            },
            Shop_artifact_bonus_exp_3={   
                item_name="Shop_artifact_bonus_exp_3",
                cost_class = 2,
                cost=4000,
                addday = "30",
            },
        },
    
    
        --特殊技能
        {
          
            
    
    
        
            -- Advanced_cold_embrace={   
            --     item_name="Advanced_cold_embrace",
            --     cost_class = 2,
            --     cost=100,
            -- }, 


        },
    
    
        --黑市
        {
    
        },
    
        --其他
        {
            Shop_buy_gold_by_platinum_1={   
                item_name="Shop_buy_gold_by_platinum_1",
                cost_class = TYPE_COST_Platinum,
                cost=20,
                bonus = 60,      --奖励值
                goods_class = TYPE_BUY_Aurum,   --换金币
            },
            Shop_buy_gold_by_platinum_2={   
                item_name="Shop_buy_gold_by_platinum_2",
                cost_class = TYPE_COST_Platinum,
                cost=50,
                bonus = 160,      --奖励值
                goods_class = TYPE_BUY_Aurum,   --换金币
            },
            Shop_buy_gold_by_platinum_3={   
                item_name="Shop_buy_gold_by_platinum_3",
                cost_class = TYPE_COST_Platinum,
                cost=100,
                bonus = 350,      --奖励值
                goods_class = TYPE_BUY_Aurum,   --换金币
            },
            Shop_buy_gold_by_platinum_4={   
                item_name="Shop_buy_gold_by_platinum_4",
                cost_class = TYPE_COST_Platinum,
                cost=200,
                bonus = 750,      --奖励值
                goods_class = TYPE_BUY_Aurum,   --换金币
            },
            Shop_buy_gold_by_platinum_5={   
                item_name="Shop_buy_gold_by_platinum_5",
                cost_class = TYPE_COST_Platinum,
                cost=450,
                bonus = 1700,      --奖励值
                goods_class = TYPE_BUY_Aurum,   --换金币
            },


    
            Shop_buy_exp_1={   
                item_name="Shop_buy_exp_1",
                cost_class = TYPE_COST_Platinum,
                cost=20,
                bonus = 1500,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_2={   
                item_name="Shop_buy_exp_2",
                cost_class = TYPE_COST_Platinum,
                cost=50,
                bonus = 4000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_3={   
                item_name="Shop_buy_exp_3",
                cost_class = TYPE_COST_Platinum,
                cost=100,
                bonus = 10000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_4={   
                item_name="Shop_buy_exp_4",
                cost_class = TYPE_COST_Platinum,
                cost=200,
                bonus = 25000,      --经验值奖励
                goods_class =TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_5={   
                item_name="Shop_buy_exp_5",
                cost_class = TYPE_COST_Platinum,
                cost=450,
                bonus = 60000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
    
    
    
    
            
            Shop_buy_exp_by_gold_1={   
                item_name="Shop_buy_exp_by_gold_1",
                cost_class = TYPE_COST_Aurum,
                cost=100,
                bonus = 1500,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_by_gold_2={   
                item_name="Shop_buy_exp_by_gold_2",
                cost_class = TYPE_COST_Aurum,
                cost=200,
                bonus = 4000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_by_gold_3={   
                item_name="Shop_buy_exp_by_gold_3",
                cost_class = TYPE_COST_Aurum,
                cost=400,
                bonus = 10000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_by_gold_4={   
                item_name="Shop_buy_exp_by_gold_4",
                cost_class =TYPE_COST_Aurum,
                cost=800,
                bonus = 25000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },
            Shop_buy_exp_by_gold_5={   
                item_name="Shop_buy_exp_by_gold_5",
                cost_class = TYPE_COST_Aurum,
                cost=1800,
                bonus = 60000,      --经验值奖励
                goods_class = TYPE_BUY_EXP,   --换经验
            },

            Shop_buy_spell_by_platinum={    
                item_name="Shop_buy_spell_by_platinum",
                cost_class = TYPE_COST_Platinum,
                cost=200,
                bonus = 10,      --技能数量
                goods_class = TYPE_BUY_Spell_Book,   --换技能书
            },
    
            Shop_buy_spell_by_platinum2={    
                item_name="Shop_buy_spell_by_platinum2",
                cost_class = TYPE_COST_Platinum,
                cost=950,
                bonus = 50,      --技能数量
                goods_class = TYPE_BUY_Spell_Book,   --换技能书
            },

            buy_core_5={    
                item_name="buy_core_5",
                cost_class = TYPE_COST_Platinum,
                cost=300,
                bonus = 5,      --原石数量
                goods_class = TYPE_BUY_CORE,   --购买原石
            },
            buy_core_20={    
                item_name="buy_core_20",
                cost_class = TYPE_COST_Platinum,
                cost=1000,
                bonus = 20,      --原石数量
                goods_class = TYPE_BUY_CORE,   --购买原石
            },

            buy_core_5_2={    
                item_name="buy_core_5_2",
                cost_class = TYPE_COST_EXP,
                cost=35000,
                bonus = 5,      --原石数量
                goods_class = TYPE_BUY_CORE,   --购买原石
            },
            buy_core_20_2={    
                item_name="buy_core_20_2",
                cost_class = TYPE_COST_EXP,
                cost=120000,
                bonus = 20,      --原石数量
                goods_class = TYPE_BUY_CORE,   --购买原石
            },
            attach_particle_1={    
                item_name="attach_particle_1",
                cost_class = TYPE_COST_Platinum,
                bonus = 30, --天数
                cost=250,
                goods_class = TYPE_BUY_ParticleEffect, 
            },
            heroTalent_npc_dota_hero_silencer_2={    
                item_name="heroTalent_npc_dota_hero_silencer_2",
                cost_class = TYPE_COST_Platinum,
                bonus = 36500, --天数
                cost=250,
                goods_class = TYPE_BUY_ParticleEffect, 
            },
            ability_particle_3={    
                item_name="ability_particle_3",
                cost_class = TYPE_COST_Platinum,
                bonus = 36500, --天数
                cost=2000,
                goods_class = TYPE_BUY_ParticleEffect, 
            },

            buy_rune_level1={   
                item_name="buy_rune_level1",
                cost_class = TYPE_COST_Platinum,
                cost=500,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,
                level = 1,
                goods_class = TYPE_BUY_Rune,   
            },

            buy_rune_level2={   
                item_name="buy_rune_level2",
                cost_class = TYPE_COST_Platinum,
                cost=550,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,
                level = 2,
                goods_class = TYPE_BUY_Rune,   
            },
            buy_rune_level3={   
                item_name="buy_rune_level3",
                cost_class = TYPE_COST_Platinum,
                cost=600,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,    
                level = 3,
                goods_class = TYPE_BUY_Rune, 
            },

            buy_rune_level4={   
                item_name="buy_rune_level4",
                cost_class = TYPE_COST_Platinum,
                cost=650,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,     
                level = 4,
                goods_class = TYPE_BUY_Rune, 
            },

            buy_rune_level5={   
                item_name="buy_rune_level5",
                cost_class = TYPE_COST_Platinum,
                cost=700,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,
                level = 5,
                goods_class = TYPE_BUY_Rune, 
            },

            buy_rune_level6={   
                item_name="buy_rune_level6",
                cost_class = TYPE_COST_Platinum,
                cost=750,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,  
                level = 6,
                goods_class = TYPE_BUY_Rune,  
            },
            buy_rune_level7={   
                item_name="buy_rune_level7",
                cost_class = TYPE_COST_Platinum,
                cost=750,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,  
                level = 7,
                goods_class = TYPE_BUY_Rune,
            },
            buy_rune_level8={   
                item_name="buy_rune_level8",
                cost_class = TYPE_COST_Platinum,
                cost=750,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2, 
                level = 8,
                goods_class = TYPE_BUY_Rune,  
            },
            buy_rune_level9={   
                item_name="buy_rune_level9",
                cost_class = TYPE_COST_Platinum,
                cost=750,
                bonus = 20,      
                level4_chance = 32,
                level5_chance = 11,
                level5_min = 2,     
                level = 9,
                goods_class = TYPE_BUY_Rune, 
            },


            
        },
    
    }
    print("set up shop  ok")
end

--玩家数据初始化

function CAddonTemplateGameMode:GeSpellsDataFromServer()  --从服务器读取玩家的技能数据表

    --如果服务器时间没更新好 延迟2秒获取数据
    if _G.GAME_GetServerTime==false then
        Timers:CreateTimer(0.5, function()
            print("need get time")
            CAddonTemplateGameMode:GeSpellsDataFromServer()
        end)
        return
    end
    
    -- local steamIDs
    self.spellMap = {}
    
    _G.GAME_LOGIN_SUCCESS_INDEX = 0  --初始化玩家数量
    -- local playernumber = 0 --记录玩家数量
    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        
        local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
        if steamID ~= "0" then
            self.spellMap[nPlayerID] = {}
            self.spellMap[nPlayerID].steamID = steamID
            self.spellMap[nPlayerID].playerinfo = {}  --基础信息表
            self.spellMap[nPlayerID].spells = {}      --技能表
            self.spellMap[nPlayerID].vip ={}          --特权表
            self.spellMap[nPlayerID].bonus={}       --补偿奖励
            --载入的时候 如果前缀为ability 那么为技能特效 particleManager:GetSpellParticleSpellName(name)可获取其对应技能名
            --拿到技能名后如果  self.spellMap[nPlayerID].Particle.SpellParticle 中没有存在这个名字 那么进行创建
            -- SpellParticle.name = {
            --     on_Particle = "ability_particle_0",   默认特效
            --     ParticleSet = {
            --         名字 ="日期",
            --     },
            -- }
            --如果这个特效为装备状态 那么替换on_Particle
            --如果存在相同名 那么插入到ParticleSet中 并判断装备状态
            --由此完成技能特效的初始配置
            self.spellMap[nPlayerID].Particle = {
                SpellParticle = {
                    -- Advanced_Starbreaker = {
                    --     on_Particle = "ability_particle_1",
                    --     ParticleSet = {
                    --         ability_particle_1 ="2022-05-06 12:33:24",
                    --         ability_particle_2 ="2022-05-06 12:33:24",
                    --     },
                    -- }
                },
                -- RangeAttack = {},
                Attach = {
                    on_Particle = "ability_particle_0",
                    ParticleSet = {
                        -- attach_particle_1 ="2022-05-06 12:33:24",
                        -- attach_particle_2 ="2022-05-06 12:33:24",
                        -- attach_particle_3 ="2022-05-06 12:33:24",
                    },
                },
                MeleeAttack = {
                    on_Particle = "ability_particle_0",
                    ParticleSet = {},
                },
                RangeAttack = {
                    on_Particle = "ability_particle_0",
                    ParticleSet = {},
                },
                Talent ={
                    on_Particle = "ability_particle_0",
                    ParticleSet = {},
                },
                SoundWheel={
                    on_Particle = "ability_particle_0",
                    ParticleSet = {},
                }
            }


            self.spellMap[nPlayerID].chaoticEraSpellRune={
                -- chaotic_death_cloud = {
                --     {
                --         chaotic_uniqueID = "000001",  --独特ID
                --         steamID = "76561198284686620",  --拥有者id
                --         rarity = "1",                  --稀有度等级
                --         identification_number = "1",   --识别号
                --         specialValue = {   --键值对
                --             radius = 55,
                --             duration = 1,
                --             base_damage = 5,
                --             bonus_damage_index = 0.1,
                --         },
                --         isEquip = 0,  --是否装备
                --         generation_date = "2023-09-17 14:01", --生成日期
                --         last_modify_date = "2023-09-17 14:01",  --最后修改日期
                --         modify_count = 0,             --重铸次数


                --     },
                --     {
                --         chaotic_uniqueID = "000002",
                --         steamID = "76561198284686620",
                --         rarity = "2",
                --         identification_number = "3",
                --         specialValue = {
                --             radius = 105,
                --             duration = 2,
                --             base_damage = 15,
                --             bonus_damage_index = 0.3,
                --         },
                --         isEquip = 1,
                --         generation_date = "2023-09-17 14:01",
                --         last_modify_date = "2023-09-17 15:04",
                --         modify_count = 3,


                --     },
                -- }
            }

            local progress = {
                baseData = false,
                runeData = false
            }
            local function CheckProgress()
                if progress.baseData==true and progress.runeData==true  then
                    _G.GAME_CAN_BUY[nPlayerID] = true   --设置更新数据成功
                    _G.GAME_LOGIN[nPlayerID] = true --登录成功
                    _G.GAME_LOGIN_SUCCESS_INDEX = _G.GAME_LOGIN_SUCCESS_INDEX + 1 --更新成功登录玩家数
                    uimanager:SendLoginProgress()
                    print("登录成功")
                end
            end

            print("进行登录")

            game_event:GetPlayerData(nPlayerID,self.spellMap,function ()
                print("进行登录1111111")
                GameRules:SendCustomMessage("DOTA_CUSTOM_LoginSuccess", DOTA_TEAM_GOODGUYS, nPlayerID)
         
                progress.baseData = true
                CheckProgress()
                print("进行登录2222222222")
                chaotic_era:GetPlayerRuneData(nPlayerID,function ()
                    print("进行登录3333333333")
                    GameRules:SendCustomMessage("DOTA_CUSTOM_LoginSuccess2", DOTA_TEAM_GOODGUYS, nPlayerID)
                    progress.runeData = true
                    CheckProgress()
                end)
               
            end)
       
            
            _G.GAME_PLAYER_number = _G.GAME_PLAYER_number +1

           
            
        end

    end
    UpdatePlayerCount() --计算完玩家人数后设置一下王表



end





function removeItems()
    for i=0,GameRules:NumDroppedItems()-1 do
        local hDroppedItem = GameRules:GetDroppedItem(i)  --这里获取到的是道具绑定的单位
        PrintTable(hDroppedItem)
        if hDroppedItem then
            local hContainedItem = hDroppedItem:GetContainedItem()  --由绑定单位获取到道具实体
            local item = hContainedItem:GetContainer()
            if hContainedItem  then

                local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/neutralitem_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil ) 
                ParticleManager:SetParticleControl( nFXIndex, 0, hDroppedItem:GetAbsOrigin() )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
                EmitSoundOn( "NeutralItem.TeleportToStash", hDroppedItem )
                UTIL_Remove( hDroppedItem )
            end
        end
        
    end
    
end






function GameRules:AttachWearable(unit, modelPath,part)
    local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = modelPath, DefaultAnim=animation, targetname=DoUniqueString("prop_dynamic")})

    wearable:FollowEntity(unit, true)
    
    if part ~= nil then
        local mask1_particle = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN_FOLLOW, wearable )
        ParticleManager:SetParticleControlEnt( mask1_particle, 0, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 1, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 2, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
    end
    
    unit.wearables = unit.wearables or {}
    table.insert(unit.wearables, wearable)

    return wearable
end

--绑定饰品 可以设置大小 但不绑定骨骼 需要些计时器绑定角度
function GameRules:AttachWearableWithScale(unit, modelPath,part,scale)
    local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = modelPath, DefaultAnim=animation, targetname=DoUniqueString("prop_dynamic")})
    wearable:SetModelScale(scale)
    wearable:FollowEntity(unit, false)
    
    if part ~= nil then
        local mask1_particle = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN_FOLLOW, wearable )
        ParticleManager:SetParticleControlEnt( mask1_particle, 0, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 1, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 2, wearable, PATTACH_POINT_FOLLOW, "attach_part" , unit:GetOrigin(), true )
    end
    
    unit.wearables = unit.wearables or {}
    table.insert(unit.wearables, wearable)

    return wearable
end



function CustomUIEvent(eventName, func, context)
	local f = func
	if context ~= nil then
		f = function(...)
			return func(context, ...)
		end
	end
	local id = CustomGameEventManager:RegisterListener(eventName, f)
	table.insert(CustomUIEventListenerIDs, id)
	return id
end
function UnregisterUIEventListener(id)
	for i = #CustomUIEventListenerIDs, 1, -1 do
		if CustomUIEventListenerIDs[i] == id then
			table.remove(CustomUIEventListenerIDs, i)
		end
	end
	CustomGameEventManager:UnregisterListener(id)
end

_G.CustomUIEvent = CustomUIEvent

function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end
_G.GameEvent = GameEvent

function GameTimerEvent(startInterval, func, context)
	local hGameMode = GameRules:GetGameModeEntity()
	table.insert(TimerEventListenerIDs, hGameMode:GameTimer(startInterval, function()
		if context ~= nil then
			return func(context)
		end
		return func()
	end))
end
_G.GameTimerEvent = GameTimerEvent

function _ClearEventListenerIDs()
	for i = #CustomUIEventListenerIDs, 1, -1 do
		CustomGameEventManager:UnregisterListener(CustomUIEventListenerIDs[i])
	end
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
	local hGameMode = GameRules:GetGameModeEntity()
	for i = #TimerEventListenerIDs, 1, -1 do
		hGameMode:SetContextThink(TimerEventListenerIDs[i], nil, -1)
	end
end


function Require(requireList, bReload)
	for k, v in pairs(requireList) do
		local t = require(v)


		if t ~= nil and type(t) == "table" then
			if type(k) == "string" then
				_G[k] = t
			end
			print(k)
			print(v)

			if t.init ~= nil then
				print("init")
				t:init(bReload)
			end
			print("---")
		end
	end
end

function Initialize(bReload)
    if not bReload then
        Timers:CreateTimer(10, function()
            -- print("_G.GAME_PREPARE_INDEX=".._G.GAME_PREPARE_INDEX)
            -- print("_G.GAME_IN==".._G.GAME_IN)
            local timer = 0
            local message = 0
            if _G.GAME_IN  == 1 and _G.GAME_PREPARE_INDEX>=GetPlayerCount() then
     
    
                if _G.GAME_DIFFICULTY~=0 then
                    _G.GAME_pre_gameTime = GameRules:GetGameTime()
                    -- print("11111111111")
                    if Game_State:IsInChaoticEra() then
                        -- print("222222222")
                        if chaotic_era_spawner:CheckFirstWaveEnter() then
                            chaotic_era_spawner:InitFirstWave()
                        else
                            return 2
                        end
                    else
                        game_event:Go_next_wave()
                    end
                    
                else
                    Notifications:TopToAll({ text = "#DOTA_HUD_difficulty_not_selected_info", duration = 3, style = { color = "red" } })
                    return 3
                end
    
                
            else
     
    
                if _G.GAME_IN  == 1 and not IsInToolsMode() and GameRules:IsCheatMode() then
                    -- Notifications:TopToAll({ text = "not allow cheat", duration = 3, style = { color = "red" } })
                    GameRules:SendCustomMessage("作弊模式不被允许", 1, -1)
                    GameRules:SendCustomMessage("not allow to cheat", 1, -1)
                    GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
                end
    
                
                --print("wait")
                return 1
            end
        end)
    
        Timers:CreateTimer(10, function()
            if _G.GAME_IN  == 1 and not (_G.GAME_PREPARE_INDEX>=GetPlayerCount())then
                GameRules:SendCustomMessage("DOTA_CUSTOM_Game_Start_info_bonus", 1, -1)
                GameRules:SendCustomMessage("DOTA_CUSTOM_Game_Start_info", 1, -1)
                
            else
                if _G.GAME_IN  == 0 then
                    --print("wait 2")
                    return 1
                end
            end
    
        end)
    end

	_G.CustomUIEventListenerIDs = {}
	_G.GameEventListenerIDs = {}
	_G.TimerEventListenerIDs = {}
	_G.Activated = true
	-- Require({
	-- 	Request = "libraries/request",

	-- 	"libraries/util",
	-- 	"libraries/md5",
	-- 	"libraries/custom_net_data",

	-- -- "class/weight_pool",
	-- }, bReload)
	-- Require({
	-- 	Settings = "settings",
	-- -- Filters = "filters",
	-- -- DotaTD = "dota_td",
	-- }, bReload)
    print("require 111")
	Require({
		internal = "internal/main",
	}, bReload)
end


function Reload()
	local state = GameRules:State_Get()
	if state > DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		_ClearEventListenerIDs()

		GameRules:Playtesting_UpdateAddOnKeyValues()
		FireGameEvent("client_reload_game_keyvalues", {})

		local tUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)
		local tBuffsNeedReload = {
			"modifier_common",
			"modifier_base_ability_value",
		}
		for n, hUnit in pairs(tUnits) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				for k, sBuff in pairs(tBuffsNeedReload) do
					if hUnit:HasModifier(sBuff) then
						hUnit:RemoveModifierByName(sBuff)
						hUnit:AddNewModifier(hUnit, nil, sBuff, nil)
					end
				end

				for i = 0, hUnit:GetAbilityCount() - 1, 1 do
					local hAbility = hUnit:GetAbilityByIndex(i)
					if IsValid(hAbility) then
						local sBuff = hAbility:GetIntrinsicModifierName()
						if sBuff ~= nil and string.len(sBuff) > 0 then
							hUnit:RemoveModifierByName(sBuff)
							if hAbility:GetLevel() > 0 then
								hAbility:RefreshIntrinsicModifier()
							end
						end
					end
				end
			end
		end

		if IsValid(_G.MODIFIER_GLOBAL_DUMMY) then
			UTIL_Remove(_G.MODIFIER_GLOBAL_DUMMY)
		end
        if IsValid(_G.RECORD_SYSTEM_DUMMY) then
			UTIL_Remove(_G.RECORD_SYSTEM_DUMMY)
		end
		local hCaster = nil
		if IsInToolsMode() then
			hCaster = GameRules:GetGameModeEntity()
		end
        _G.MODIFIER_GLOBAL_DUMMY = CreateModifierThinker(hCaster, nil, "modifier_events", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
        _G.RECORD_SYSTEM_DUMMY = CreateModifierThinker(hCaster, nil, "modifier_record_system_dummy", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
    
	

		print("Reload Scripts")

		Initialize(true)
	end
end

if Activated == true then
	Reload()
end














