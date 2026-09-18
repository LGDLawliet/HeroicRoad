achievement = achievement or class({})
require("internal/timers")

-- bronze_coach_popout_bg_png
-- coaching/null_coach_popout_bg_png
-- silver_coach_popout_bg_png

_G.SPELL_UPGRADE_TO_ADVANCED =  {}
function achievement:init(bReload)
    
    -- custom_key 为在数据库的字段名 
    self.nornal = {

        {
            -- 1.首通系列
            {
                name = "AT_pass_difficulty_1",
                custom_key = "pass_diff_1",
                value_require_1 = 1,
                bonus ={
                    exp = 2000,
                    -- aurum = 0,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_1_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_2",
                custom_key = "pass_diff_2",
                value_require_1 = 1,
                bonus ={
                    exp = 5000,
                    -- aurum = 0,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_level_1_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_3",
                custom_key = "pass_diff_3",
                value_require_1 = 1,
                bonus ={
                    exp = 10000,
                    aurum = 25,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_2_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_4",
                custom_key = "pass_diff_4",
                value_require_1 = 1,
                bonus ={
                    exp = 15000,
                    aurum = 50,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_level_2_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_5",
                custom_key = "pass_diff_5",
                value_require_1 = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_3_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_6",
                custom_key = "pass_diff_6",
                value_require_1 = 1,
                bonus ={
                    exp = 30000,
                    aurum = 150,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_level_3_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_7",
                custom_key = "pass_diff_7",
                value_require_1 = 1,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/battlecup_winter_champions_png.vtex')",
                    RelicGlow_WashColor = "#41d9ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_pass_difficulty_8",
                custom_key = "pass_diff_8",
                value_require_1 = 1,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/battlecup_winter_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
             -- 内卷之王
            {
                name = "AT_king_of_involution",
                custom_key = "king_of_involution_1",
                value_require_1 = 1,
                bonus ={
                    exp = 100000,
                    aurum = 1000,
                    platinum = 1000,
                    coreRollTime = 2,  --产生次数
                    coreCount = 4,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_6_png.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
    
                }
            },
            -- 内卷之神
            {
                name = "AT_god_of_involution",
                custom_key = "king_of_involution_2",
                value_require_1 = 10,
                bonus ={
                    exp = 0,
                    aurum = 10000,
                    platinum = 4000,
                    coreRollTime = 10,  --产生次数
                    coreCount = 4,      --每次个数
                    secret = 1,   --1有 0无
                    -- 秘密奖励:个人百相分配点数+4
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_6_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/silver_coach_popout_bg_png.vtex')",
    
                }
            },
           
        },

        {
            -- 2024.12传说挑战月
           {
                name = "AT_legend_nevermore",
                custom_key = "legend_talent_1",
                value_require_1 = 1,
                bonus ={
                    exp = 50000,
                    aurum = 1000,
                    platinum = 500,
                    coreRollTime = 5,  --产生次数
                    coreCount = 3,      --每次个数
                    secret = 0,   --1有 0无
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_6_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/silver_coach_popout_bg_png.vtex')",
    
                }
            },
        },
        {   -- 2025.06传说挑战月
           {
            name = "AT_legend_slark",
            custom_key = "legend_talent_2",
            value_require_1 = 1,
            bonus ={
                exp = 50000,
                aurum = 1000,
                platinum = 500,
                coreRollTime = 5,  --产生次数
                coreCount = 3,      --每次个数
                secret = 0,   --1有 0无
                },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_6_png.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/silver_coach_popout_bg_png.vtex')",

                }
            },
        },
        {
            -- 2025.12传说挑战月
           {
            name = "AT_legend_rattletrap",
            custom_key = "legend_talent_3",
            value_require_1 = 1,
            bonus ={
                exp = 50000,
                aurum = 1000,
                platinum = 500,
                coreRollTime = 5,  --产生次数
                coreCount = 3,      --每次个数
                secret = 0,   --1有 0无
                },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_mmr_6_png.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/silver_coach_popout_bg_png.vtex')",

                }
            },
        },


        {
            -- 自我挑战者
           {
               name = "AT_self_challenger_1",
               custom_key = "self_challenger_1",
               value_require_1 = 1,
               hide = 1,
               bonus ={
                --    exp = 0,
                --    aurum = 0,
                   platinum = 400,
                --    coreRollTime = 2, 
                --    coreCount = 4,   
                   -- secret = 1, 
               },
               style = {
                   RelicImageInternal_image = "url('s2r://panorama/images/trophies/allhero_1_png.vtex')",
                   RelicGlow_WashColor = "#ffbb41",
                --    Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
   
               }
           },
           
       },

        
    }

    self.kill = {
        {
            {
                -- 染血之刃
                name = "AT_bloodly_blade_1",
                custom_key = "enemy_kill_1",
                value_require_1 = 10000,
                bonus ={
                    exp = 80000,
                    aurum = 1000,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                -- 染血之刃2
                name = "AT_bloodly_blade_2",
                custom_key = "enemy_kill_2",
                value_require_1 = 100000,
                bonus ={
                    -- exp = 0,
                    aurum = 2000,
                    platinum = 300,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    -- secret = 1, 
                    
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress2_psd.vtex')",
                    RelicGlow_WashColor = "#ff4141",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
        },
      
    }

    self.characteristic = {
       {
        -- 召唤师系列
        {
            name = "AT_summoner_1",
            custom_key = "summon_1",
            value_require_1 = 500,
            bonus ={
                exp = 20000,
                aurum = 100,
                -- platinum = 0,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_earthshaker/earthshaker_arcana_progress_1_psd.vtex')",
                RelicGlow_WashColor = "#ffffff",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
        {
            name = "AT_summoner_2",
            custom_key = "summon_2",
            value_require_1 = 3000,
            bonus ={
                exp = 40000,
                aurum = 200,
                -- platinum = 0,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_earthshaker/earthshaker_arcana_progress_2_psd.vtex')",
                RelicGlow_WashColor = "#c2e8ff",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
        {
            name = "AT_summoner_3",
            custom_key = "summon_3",
            value_require_1 = 10000,
            hide = 1,
            bonus ={
                exp = 100000,
                aurum = 500,
                -- platinum = 0,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_earthshaker/earthshaker_arcana_progress_4_psd.vtex')",
                RelicGlow_WashColor = "#6fc8ff",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
        {
            name = "AT_summoner_4",
            custom_key = "summon_4",
            value_require_1 = 50000,
            hide = 1,
            bonus ={
                exp = 0,
                aurum = 0,
                platinum = 500,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                secret = 1, 
                --召唤增强增加2%
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_earthshaker/earthshaker_arcana_progress_5_psd.vtex')",
                RelicGlow_WashColor = "#24abff",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
       },
       {
        -- 阿斗系列
        {
            name = "AT_idle_about_1",
            custom_key = "idle_about_1",
            value_require_1 = 1,
            hide = 1,
            bonus ={
                exp = 10000,
                aurum = 50,
                -- platinum = 0,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/banners/halloween2015/earthshaker_psd.vtex')",
                RelicGlow_WashColor = "#ffffff",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                -- RelicImageInternal_image_margin_top = "80px";
            }
        },
        {
            name = "AT_idle_about_2",
            custom_key = "idle_about_2",
            value_require_1 = 10,
            hide = 1,
            bonus ={
                exp = 30000,
                aurum = 100,
                -- platinum = 0,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/banners/halloween2015/earthshaker_psd.vtex')",
                RelicGlow_WashColor = "#717a55",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
        {
            name = "AT_idle_about_3",
            custom_key = "idle_about_3",
            value_require_1 = 50,
            hide = 1,
            bonus ={
                exp = 80000,
                aurum = 300,
                -- platinum = 0,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/banners/halloween2015/earthshaker_psd.vtex')",
                RelicGlow_WashColor = "#9ea044",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
        {
            name = "AT_idle_about_4",
            custom_key = "idle_about_4",
            value_require_1 = 100,
            hide = 1,
            bonus ={
                -- exp = 0,
                -- aurum = 50,
                platinum = 500,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                secret = 1, 
                -- 暂定：回合结算金币增加2%
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/banners/halloween2015/earthshaker_psd.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },

       },

   
       {
        -- 原石收藏
        {
            name = "AT_core_collector_1",
            custom_key = "core_collector_1",
            value_require_1 = 1,
            hide = 1,
            bonus ={
                -- exp = 0,
                -- aurum = 0,
                platinum = 500,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                secret = 1, 
                -- 暂定：如果三种原石库存大于500，则百相难度可以额外购买一颗原石
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/aghslab2021_battle_pass_cavern_level_3_png.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
       },


   
       {
        -- 黄金大富豪
        {
            name = "AT_aurum_millionaire_1",
            custom_key = "aurum_millionaire_1",
            value_require_1 = 1,
            hide = 1,
            bonus ={
                -- exp = 0,
                -- aurum = 0,
                platinum = 500,
                -- coreRollTime = 0,  --产生次数
                -- coreCount = 0,      --每次个数
                secret = 1, 
                -- 暂定：苦难与装备可以重随次数加1
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/bagit_3_png.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
       },
   

       {
        -- 富哥
        {
            -- 仅记录
            name = "AT_platinum_millionaire_1",
            custom_key = "platinum_millionaire_1",
            -- value_require_1 = 50000,
            value_require_1 = 999999999,
            hide = 1,
            bonus ={
                -- exp = 0,
                -- aurum = 0,
                platinum = 500,
                -- coreRollTime = 0,
                -- coreCount = 0,
                secret = 1, 
                -- 暂定：一个专属的周身特效
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/bagit_2_png.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
       },
       {
        -- rich_guy_1
            {
                -- 仅记录
                name = "AT_rich_guy_1",
                custom_key = "rich_guy_1",
                -- value_require_1 = 50000,
                value_require_1 = 1,
                hide = 1,
                bonus ={
                    -- exp = 0,
                    -- aurum = 0,
                    platinum = 0,
                    -- coreRollTime = 0,
                    -- coreCount = 0,
                    secret = 1, 
                    -- 暂定：一个专属的周身特效
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/mvp_level_1_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

       },
       
       {
        -- 经验宝宝
        {
            name = "AT_exp_millionaire_1",
            custom_key = "exp_millionaire_1",
            value_require_1 = 1,
            hide = 1,
            bonus ={
                -- exp = 0,
                -- aurum = 0,
                platinum = 500,
                -- coreRollTime = 0,
                -- coreCount = 0,
                secret = 1, 
                -- 暂定：升级技能到25级时有20%几率升到26级
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/bagit_1_png.vtex')",
                RelicGlow_WashColor = "#ffbb41",
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
            }
        },
       },

       {
        -- 两袖清风
        {
            name = "AT_remain_uncorrupted_1",
            custom_key = "remain_uncorrupted_1",
            value_require_1 = 1,
            hide = 1,
            bonus ={
                exp = 20000,
                aurum = 100,
                -- platinum = 0,
                -- coreRollTime = 0,
                -- coreCount = 0,
                -- secret = 1, 
            },
            style = {
                RelicImageInternal_image = "url('s2r://panorama/images/trophies/fall_majors_2015_trophy_wager_coins_level_1_png.vtex')",
                RelicGlow_WashColor = "#ffffff",
                RelicImageInternal_image_margin_top = "10px"
                -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",

            }
        },

        },

        {
            -- 贪婪的化身
            {
                name = "AT_avatar_of_greed_1",
                custom_key = "avatar_of_greed_1",
                value_require_1 = 100,
                hide = 1,
                bonus ={
                    -- exp = 20000,
                    -- aurum = 100,
                    platinum = 300,
                    -- coreRollTime = 0,
                    -- coreCount = 0,
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/alchemist_goblins_greed_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- RelicImageInternal_image_margin_top = "10px"
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
    
                }
            },
    
        },


        {
            -- 最强之矛
            {
                name = "AT_the_strongest_spear_1",
                custom_key = "the_strongest_spear_1",
                value_require_1 = 100,
                hide = 1,
                bonus ={
                    -- exp = 20000,
                    -- aurum = 100,
                    platinum = 300,
                    -- coreRollTime = 0,
                    -- coreCount = 0,
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pwrdlinkdota1_level_5_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- RelicImageInternal_image_margin_top = "10px"
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
    
                }
            },
    
        },
       
        {
            -- 最强之盾
            {
                name = "AT_the_strongest_shield_1",
                custom_key = "the_strongest_shield_1",
                value_require_1 = 100,
                hide = 1,
                bonus ={
                    -- exp = 20000,
                    -- aurum = 100,
                    platinum = 300,
                    -- coreRollTime = 0,
                    -- coreCount = 0,
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/pa_contracts_won_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- RelicImageInternal_image_margin_top = "10px"
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
    
                }
            },
    
        },
               
        {
            -- 最强医者
            {
                name = "AT_the_strongest_heal_1",
                custom_key = "the_strongest_heal_1",
                value_require_1 = 100,
                hide = 1,
                bonus ={
                    -- exp = 20000,
                    -- aurum = 100,
                    platinum = 300,
                    -- coreRollTime = 0,
                    -- coreCount = 0,
                    -- secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/trophies/fall_majors_2015_trophy_compendium_level_7_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- RelicImageInternal_image_margin_top = "10px"
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
    
                }
            },
    
        },


        {
            -- 通关乱纪元次数
            {
                name = "AT_chaotic_era_1",
                custom_key = "chaotic_era_1",
                value_require_1 = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/game_modes/dark_moon_popup_psd.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_2",
                custom_key = "chaotic_era_2",
                value_require_1 = 3,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/game_modes/dark_moon_popup_psd.vtex')",
                    RelicGlow_WashColor = "#caa7e9",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_3",
                custom_key = "chaotic_era_3",
                value_require_1 = 10,
                bonus ={
                    exp = 60000,
                    aurum = 300,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/game_modes/dark_moon_popup_psd.vtex')",
                    RelicGlow_WashColor = "#9d5cf2",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_4",
                custom_key = "chaotic_era_4",
                value_require_1 = 30,
                bonus ={
                    exp = 80000,
                    aurum = 400,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/game_modes/dark_moon_popup_psd.vtex')",
                    RelicGlow_WashColor = "#8437e8",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_5",
                custom_key = "chaotic_era_5",
                value_require_1 = 50,
                bonus ={
                    exp = 100000,
                    aurum = 500,
                    platinum = 100,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/game_modes/dark_moon_popup_psd.vtex')",
                    RelicGlow_WashColor = "#6f0cef",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
           
         
        },

        {
            -- 踏实积累
            {
                name = "AT_chaotic_era_base_rune_1",
                custom_key = "chaotic_era_base_rune_1",
                value_require_1 = 5,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_base_rune_2",
                custom_key = "chaotic_era_base_rune_2",
                value_require_1 = 30,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#caa7e9",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_base_rune_3",
                custom_key = "chaotic_era_base_rune_3",
                value_require_1 = 100,
                bonus ={
                    exp = 60000,
                    aurum = 300,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#9d5cf2",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
        },

        {
            -- 符石大亨
            {
                name = "AT_chaotic_era_rune_1",
                custom_key = "chaotic_era_rune_1",
                value_require_1 = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_2",
                custom_key = "chaotic_era_rune_2",
                value_require_1 = 5,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {

                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#caa7e9",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_3",
                custom_key = "chaotic_era_rune_3",
                value_require_1 = 30,
                bonus ={
                    exp = 60000,
                    aurum = 300,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#9d5cf2",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_4",
                custom_key = "chaotic_era_rune_4",
                value_require_1 = 100,
                bonus ={
                    exp = 80000,
                    aurum = 400,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#8437e8",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_5",
                custom_key = "chaotic_era_rune_5",
                value_require_1 = 200,
                bonus ={
                    exp = 100000,
                    aurum = 500,
                    platinum = 100,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#6f0cef",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_6",
                custom_key = "chaotic_era_rune_6",
                value_require_1 = 400,
                bonus ={
                    exp = 100000,
                    aurum = 500,
                    platinum = 200,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/chaotic_era_library_icon.png')",
                    RelicGlow_WashColor = "#6f0cef",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
           
         
        },

        {
            -- 向上走的第一步
            {
                name = "AT_chaotic_era_rune_single_get_1",
                custom_key = "chaotic_era_rune_single_get_1",
                value_require_1 = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/rune/level4.png')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_single_get_2",
                custom_key = "chaotic_era_rune_single_get_2",
                value_require_1 = 1,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {

                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/rune/level4.png')",
                    RelicGlow_WashColor = "#caa7e9",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_single_get_3",
                custom_key = "chaotic_era_rune_single_get_3",
                value_require_1 = 1,
                bonus ={
                    exp = 60000,
                    aurum = 300,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/rune/level5.png')",
                    RelicGlow_WashColor = "#9d5cf2",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_single_get_4",
                custom_key = "chaotic_era_rune_single_get_4",
                value_require_1 = 1,
                bonus ={
                    exp = 80000,
                    aurum = 400,
                    platinum = 100,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/custom_game/chaotic_era/rune/level5.png')",
                    RelicGlow_WashColor = "#8437e8",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

           
         
        },

        {
            -- 乱纪元击杀
            {
                name = "AT_chaotic_era_rune_killer_1",
                custom_key = "chaotic_era_rune_killer_1",
                value_require_1 = 150,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#ffffff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_killer_2",
                custom_key = "chaotic_era_rune_killer_2",
                value_require_1 = 500,
                bonus ={
                    exp = 40000,
                    aurum = 200,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#caa7e9",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_killer_3",
                custom_key = "chaotic_era_rune_killer_3",
                value_require_1 = 1500,
                bonus ={
                    exp = 60000,
                    aurum = 300,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#9d5cf2",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_killer_4",
                custom_key = "chaotic_era_rune_killer_4",
                value_require_1 = 5000,
                bonus ={
                    exp = 80000,
                    aurum = 400,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#8437e8",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_killer_5",
                custom_key = "chaotic_era_rune_killer_5",
                value_require_1 = 15000,
                bonus ={
                    exp = 100000,
                    aurum = 500,
                    platinum = 100,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#6f0cef",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_chaotic_era_rune_killer_6",
                custom_key = "chaotic_era_rune_killer_6",
                value_require_1 = 50000,
                bonus ={
                    exp = 100000,
                    aurum = 500,
                    platinum = 200,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/leaf_pages/debut_arcana_spectre/spectre_arcana_progress_psd.vtex')",
                    RelicGlow_WashColor = "#6f0cef",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
           
         
        },


    }

    self.hero_unlock = {
        {
            -- 凤凰涅槃
            {
                name = "AT_Nirvana_1",
                custom_key = "Nirvana_1",
                value_require_1 = 1,
                hide = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    --减少自身复活时间10%
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/phoenix_supernova_png.vtex')",
                    RelicGlow_WashColor = "#ff2424",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
        },

        {
            -- 神拳
            {
                name = "AT_Walrus_punch_1",
                custom_key = "Walrus_punch_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 暂定：天赋的暴击伤害提高20%（线性）
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/tusk_walrus_punch_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
            {
                name = "AT_Walrus_punch_2",
                custom_key = "Walrus_punch_2",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 暂定：天赋的触发几率提升1%（线性）
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/tusk_walrus_punch_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },
        },

        {
            -- 孤胆英雄
            {
                name = "AT_lonely_hero_1",
                custom_key = "lonely_hero_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 全属性奖励+3
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/sven/cyclopean_marauder_ability_icons/sven_warcry_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },
        {
            -- 加速模式
            {
                name = "AT_acceleration_mode_1",
                custom_key = "acceleration_mode_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 可以进行1.7倍的加速
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/tinker_rearm_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },
        {
            -- 极致的贪婪
            {
                name = "AT_extremely_greed_1",
                custom_key = "extremely_greed_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 奖励提高10%
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/bounty_hunter_jinada_ti9_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

            {
                -- 金色传说
                name = "AT_golden_legend_1",
                custom_key = "golden_legend_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 上限提升500
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/bounty_hunter_jinada_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

            

        },

        {
            -- 静电抽取器
            {
                name = "AT_electrostatic_extractor_1",
                custom_key = "electrostatic_extractor_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 加成持续时间提升3秒
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/razor_static_link_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 自我衰退
            {
                name = "AT_self_decline_1",
                custom_key = "self_decline_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 每次加成提升0.2%
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/abyssal_underlord_atrophy_aura_png.vtex')",
                    RelicGlow_WashColor = "#00ff37",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },


        {
            -- 天才
            {
                name = "AT_genius_1",
                custom_key = "genius_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 检测间隔减少0.05秒
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/silencer_glaives_of_wisdom_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 移动地震源
            {
                name = "AT_mobile_earthquake_source_1",
                custom_key = "mobile_earthquake_source_1",
                value_require_1 = 5000,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 每层状态减少时间-0.05
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/sandking_epicenter_png.vtex')",
                    RelicGlow_WashColor = "#6e5100",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 如意金箍棒
            {
                name = "AT_monkey_king_power_1",
                custom_key = "monkey_king_power_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 每次攻击减少的基础冷却时间增加至0.15秒
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/monkey_king_jingu_mastery_png.vtex')",
                    RelicGlow_WashColor = "#ffbb41",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 变体精灵 波
            {
                name = "AT_wave_1",
                custom_key = "wave_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 跌浪状态持续时间增加1.5秒
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/morphling_waveform_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        
        {
            -- 激流勇进
            {
                name = "AT_rip_tide_rush_1",
                custom_key = "rip_tide_rush_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 伤害继承增加2%
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/naga_siren_rip_tide_png.vtex')",
                    RelicGlow_WashColor = "#24c1ff",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 捆绑者
            {
                name = "AT_binder_1",
                custom_key = "binder_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 移动速度加15点
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/batrider_flaming_lasso_png.vtex')",
                    RelicGlow_WashColor = "#ff8800",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },


        {
            -- 主人公
            {
                name = "AT_hero_time_1",
                custom_key = "hero_time_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 属性加成+7%
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/abaddon_borrowed_time_alliance_png.vtex')",
                    RelicGlow_WashColor = "#41dae5",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

            -- 弼马温
            {
                name = "AT_horse_trainer_1",
                custom_key = "horse_trainer_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 伤害加成10%
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/abaddon_death_coil_alliance_png.vtex')",
                    RelicGlow_WashColor = "#8041e5",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 狂乱
            {
                name = "AT_madness_1",
                custom_key = "madness_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 加2秒
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/bloodseeker/bloodseeker_ti_immortal/bloodseeker_thirst_alt_png.vtex')",
                    RelicGlow_WashColor = "#e54141",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 蜘蛛
            {
                -- 火焰抗性
                name = "AT_flame_resistance_1",
                custom_key = "flame_resistance_1",
                value_require_1 = 20,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 不会被烧毁
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/broodmother_spin_web_png.vtex')",
                    RelicGlow_WashColor = "#5b96b3",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 人马
            {
                -- 24小时营业
                name = "AT_24_hours_1",
                custom_key = "24_hours_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 退热程度降低
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/centaur_stampede_png.vtex')",
                    RelicGlow_WashColor = "#ca5b59",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 小黑
            {
                -- 沉淀
                name = "AT_precipitate_1",
                custom_key = "precipitate_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 累计速度加快
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/drow_ranger/dragons_touch_ability_icons/drow_ranger_wave_of_silence_png.vtex')",
                    RelicGlow_WashColor = "#598cca",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },



        {
            -- 宙斯
            {
                -- 沉淀
                name = "AT_disaster_surviver_1",
                custom_key = "disaster_surviver_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 冷却加快
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/zuus_lightning_bolt_immortal_png.vtex')",
                    RelicGlow_WashColor = "#598cca",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },
        


        {
            -- 小精灵 艾欧
            {
                -- 沉淀
                name = "AT_gay_chain_1",
                custom_key = "gay_chain_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 效率增加
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/wisp_tether_png.vtex')",
                    RelicGlow_WashColor = "#598cca",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        
        {
            -- 风行 
            {
                -- 家人侠
                name = "AT_family_man_1",
                custom_key = "family_man_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 效率增加
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/windrunner_gale_force_png.vtex')",
                    RelicGlow_WashColor = "#8cca59",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },
        
        {
            -- 紫猫 
            {
                -- 位面穿梭者
                name = "AT_plane_shuttle_1",
                custom_key = "plane_shuttle_1",
                value_require_1 = 500,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 效率增加
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/void_spirit/vs_2021_immortal_ability_icon/vs_2021_immortal_astral_step_png.vtex')",
                    RelicGlow_WashColor = "#ca5959",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },


        {
            -- TA 圣堂刺客
            {
                -- 绝地武士
                name = "AT_jedi_knight_1",
                custom_key = "jedi_knight_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 攻速加成增加
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/templar_assassin/focal_resonance/templar_assassin_psi_blades_png.vtex')",
                    RelicGlow_WashColor = "#cab059",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },
        {
            -- 幽鬼
            {
                -- 幻影猎杀者
                name = "AT_phantom_hunter_1",
                custom_key = "phantom_hunter_1",
                value_require_1 = 15,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 效率增加
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/spectre/spectre_arcana/spectre_desolate_arcana_png.vtex')",
                    RelicGlow_WashColor = "#5962ca",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },

        {
            -- 小小
            {
                -- 巨物
                name = "AT_giant_1",
                custom_key = "giant_1",
                value_require_1 = 1,
                hide = 1,
                notBreak = 1,
                bonus ={
                    exp = 20000,
                    aurum = 100,
                    -- platinum = 0,
                    -- coreRollTime = 0,  --产生次数
                    -- coreCount = 0,      --每次个数
                    secret = 1, 
                    -- 攻击增加
                },
                style = {
                    RelicImageInternal_image = "url('s2r://panorama/images/spellicons/tiny_tree_grab_png.vtex')",
                    RelicGlow_WashColor = "#caa859",
                    -- Achievement_StateInfoIcon = "url('s2r://panorama/images/coaching/null_coach_popout_bg_png.vtex')",
                }
            },

        },
        
        
        
    }

 




    CustomUIEvent("GetAchievementList", Dynamic_Wrap(self, "_GetAchievementList"), self)
	CustomUIEvent("GetAchievementBonus", Dynamic_Wrap(self, "_GetAchievementBonus"), self)
    
end


function achievement:_GetAchievementList(eventSourceIndex, keys)
    local nPlayerID = keys.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local data = {
        type = keys.type,
        -- list = self.nornal,

    }
    if tonumber(keys.type)==1 then
        data.list = self.nornal
    elseif tonumber(keys.type)==2 then
        data.list = self.kill
    elseif tonumber(keys.type)==3 then
        data.list = self.characteristic
    elseif tonumber(keys.type)==4 then
        data.list = self.hero_unlock
    end
    if keys.getCustomData then
        data.customData = customDataManager:GetPlayerCustomData(tostring(PlayerResource:GetSteamID(nPlayerID)))
    end
   
    CustomGameEventManager:Send_ServerToPlayer(player, "GetAchievementList_FeedBack",  data)
end
function achievement:RefreshAchievementList(nPlayerID,type)
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    local data = {
        type = type,
        customData = customDataManager:GetPlayerCustomData(tostring(PlayerResource:GetSteamID(nPlayerID)))

    }
    if tonumber(type)==1 then
        data.list = self.nornal
    elseif tonumber(type)==2 then
        data.list = self.kill
    elseif tonumber(type)==3 then
        data.list = self.characteristic
    elseif tonumber(type)==4 then
        data.list = self.hero_unlock
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "GetAchievementList_FeedBack",  data)
end

-- 注意 排行榜难度不生效
function achievement:InitAchievementModifier(unit)
    local nPlayerID = unit:GetPlayerOwnerID()
    local player = PlayerResource:GetPlayer(nPlayerID)
    local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
    if not player then
        return
    end
    local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))

    local modifier = unit:FindModifierByName("modifier_hero_achievement_bonus")
    if modifier then
        if customDataManager:IsAchievementUnlocked(steamID,"summon_4") then
            modifier:InitSummonAchievement()
        end
    end
    if customDataManager:IsAchievementUnlocked(steamID,"idle_about_4") then
        unit:InitAchievement("idle_about_4")
    end
    -- 原石收藏家
    if customDataManager:IsAchievementUnlocked(steamID,"core_collector_1") or customDataManager:IsAchievementUnlocked(steamID,"rich_guy_1") then
        -- 需要是百相难度 且 三种原石大于500
        if _G.GAME_Reincarnation_Wave>=1 then
            if spellmap.playerinfo.core1>=500 and spellmap.playerinfo.core2 >=500 and spellmap.playerinfo.core3>=500 then
                -- print("原石收藏家奖励")
                _G.CORE_CHANCE_bonus = 1 
            end
        end
        
    end

    -- 黄金大富豪
    if customDataManager:IsAchievementUnlocked(steamID,"aurum_millionaire_1") then
        -- 黄金大富豪加重随次数
        if _G.Game_Item_ReRoll_chance[nPlayerID] then
            _G.Game_Item_ReRoll_chance[nPlayerID] =  _G.Game_Item_ReRoll_chance[nPlayerID] + 1
            _G.Game_Challenge_ReRoll_chance[nPlayerID] = _G.Game_Challenge_ReRoll_chance[nPlayerID] + 1
        end  
    end

    -- 经验宝宝  功能在skillshop中
    if customDataManager:IsAchievementUnlocked(steamID,"exp_millionaire_1") then
        unit:InitAchievement("exp_millionaire_1")
    end

    if customDataManager:IsAchievementUnlocked(steamID,"platinum_millionaire_1") then
        unit:InitAchievement("exp_millionaire_1")
        local modifierHeroLight = unit:FindModifierByName("modifier_hero_light")
        if modifierHeroLight then
            modifierHeroLight:attach_particle_platinum_millionaire()
        end
    end


    

end



-- 别忘了领取奖励时禁止领取
function achievement:_GetAchievementBonus(eventSourceIndex, keys)
    local nPlayerID = keys.player_id
    local player = PlayerResource:GetPlayer(nPlayerID)
    if not player then
        return
    end
    if _G.GAME_CAN_BUY[nPlayerID]==false then --互斥操作 当前无法购买物品
        Notifications:Top(nPlayerID, { text = "#buy_failed_Order_not_completed", duration = 4, style = { color = "red" } })
        EmitSoundOnClient("General.Cancel", player)
        return
    end

    local targetList
    if tonumber(keys.type)==1 then
        targetList = self.nornal
    elseif tonumber(keys.type)==2 then
        targetList = self.kill
    elseif tonumber(keys.type)==3 then
        targetList = self.characteristic
    elseif tonumber(keys.type)==4 then
        targetList = self.hero_unlock
    end
    print("开始判断")
    if targetList then
        local first_index = tonumber(keys.first_index)
        -- print("first_index="..first_index)
        if first_index then
            targetList = targetList[first_index]
            if targetList then
                local second_index = tonumber(keys.second_index)
                if second_index then
                    targetList = targetList[second_index]
                    if targetList then
                        -- 现在我们拿到了目标
                        -- 看一下名字是否对的上
                        print("好的 现在检查名字")
                        if keys.Name==targetList.name then
                            -- 现在查看是否拥有领取条件
                            local steamID = tostring(PlayerResource:GetSteamID(nPlayerID))
                            local custom_key = targetList.custom_key
                            local data = customDataManager:GetTargetAchievementData(steamID,custom_key)
                            if data then
                                print("获取到数据了")
                                if data.recordDate then
                                    print("已经存在解锁日期 不再解锁")
                                else
                                    -- 现在检查数值是否达标
                                    if data.valueOne>=targetList.value_require_1 then
                                        _G.GAME_CAN_BUY[nPlayerID] = false
                                        local newData = {}
                                        newData.token = _G.GAME_GLOBAL_KEY
                                        newData.customizeList  = {}
                                        newData.steamId = steamID
                                         -- 平均游戏时间数据必定变动
                                        local customizeData = {
                                            steamId = steamID,
                                            season = "-1",
                                            customizeKey = targetList.custom_key,
                                            complete = 1,
                                            valueOne =  data.valueOne,
                                            valueTwo =  data.valueTwo,
                                        }
                                        table.insert(newData.customizeList,customizeData)
                                        newData.isEncourage = 1

                                        local achievementBonus = targetList.bonus
                                        local spellmap = GameRules:GetGameModeEntity().CAddonTemplateGameMode.spellMap[nPlayerID]  --获取到数据表
                                        local newDataTable = {}
                                        if achievementBonus then
                                            if achievementBonus.exp then
                                                newData.reliableExp = spellmap.playerinfo.reliableExp + achievementBonus.exp
                                                newDataTable.reliableExp = newData.reliableExp
                                            end
                                            if achievementBonus.aurum then
                                                newData.gold = spellmap.playerinfo.gold + achievementBonus.aurum
                                                newDataTable.gold = newData.gold
                                            end
                                            if achievementBonus.platinum then
                                                newData.platinum = spellmap.playerinfo.platinum + achievementBonus.platinum
                                                newDataTable.platinum = newData.platinum
                                            end
                                            if achievementBonus.coreRollTime then
                                                -- 产生原石奖励
                                                local coreBonus = {0,0,0}
                                                for i = 1, achievementBonus.coreRollTime, 1 do
                                                    local randomIndex =RandomInt(1, 3)
                                                    coreBonus[randomIndex] = coreBonus[randomIndex] + achievementBonus.coreCount
                                                end
                                                -- print("coreBonus[1]="..coreBonus[1])
                                                -- print("coreBonus[2]="..coreBonus[2])
                                                -- print("coreBonus[3]="..coreBonus[3])
                                                if coreBonus[1]>0 then
                                                    newData.core1 = spellmap.playerinfo.core1 + coreBonus[1]
                                                    newDataTable.core1 =  newData.core1
                                                end
                                                if coreBonus[2]>0 then
                                                    newData.core2 = spellmap.playerinfo.core2 + coreBonus[2]
                                                    newDataTable.core2 = newData.core2
                                                end
                                                if coreBonus[3]>0 then
                                                    newData.core3 = spellmap.playerinfo.core3 + coreBonus[3]
                                                    newDataTable.core3 =newData.core3
                                                end
                                            end
                                        end
                                        local encoded = json.encode(newData)
                                        -- print(encoded)
                                        -- 发送数据
                                        player_database:SavePlayerCustomData_GetBonus(nPlayerID,encoded,newDataTable,data,keys.type,targetList)
                                    end
                                end
                            else
                                print("错误：获取不到目标自定义字段数据")
                            end
                        else
                            print("错误：成就名字对不上")
                        end
                    else
                        print("很奇怪 没有targetList 2ed")
                    end
                else
                    print("很奇怪 没有secondindex")
                end
            else
                print("很奇怪 没有targetList  1st")
            end
        else
            print("很奇怪 没有firstindex")
            
        end
    end
end





function CDOTA_BaseNPC:InitAchievement(name)
    if not self.achievementUnlock then
        self.achievementUnlock = {}
    end
    self.achievementUnlock[name] = true
end



function CDOTA_BaseNPC:HaveAchievement(name)
    if not self.achievementUnlock then
        return false
    end
    if  self.achievementUnlock[name] then
        return true
    end
    return false
end


return achievement