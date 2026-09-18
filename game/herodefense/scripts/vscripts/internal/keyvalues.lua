KEYVALUES_VERSION = "1.00"

-- Change to false to skip loading the base files
LOAD_BASE_FILES = false

if not KeyValues then
    KeyValues = {}
end

local split = function(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}; i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Load all the necessary key value files
function LoadGameKeyValues()
    

    local scriptPath = "scripts/npc/"
    local override = LoadKeyValues(scriptPath .. "npc_abilities_override.txt")
    local files = {
        AbilityKV = { base = "npc_abilities", custom = "npc_abilities_custom" },
        ItemKV = { base = "items", custom = "npc_items_custom" },
        UnitKV = { base = "npc_units", custom = "npc_units_custom" },
        HeroKV = { base = "npc_heroes", custom = "npc_heroes_custom" }
    }

    -- Load and validate the files
    for k, v in pairs(files) do
        local file = {}
        if LOAD_BASE_FILES then
            file = LoadKeyValues(scriptPath .. v.base .. ".txt")
        end

        -- Replace main game keys by any match on the override file
        for k, v in pairs(override) do
            if file[k] then
                file[k] = v
            end
        end

        local custom_file = LoadKeyValues(scriptPath .. v.custom .. ".txt")
        if custom_file then
            for k, v in pairs(custom_file) do
                file[k] = v
            end
        else
            print("[KeyValues] Critical Error on " .. v.custom .. ".txt")
            return
        end

        GameRules[k] = file --backwards compatibility
        KeyValues[k] = file
    end

    -- Merge All KVs
    KeyValues.All = {}
    for name, path in pairs(files) do
        for key, value in pairs(KeyValues[name]) do
            if not KeyValues.All[key] then
                KeyValues.All[key] = value
            end
        end
    end

    -- Merge units and heroes (due to them sharing the same class CDOTA_BaseNPC)
    for key, value in pairs(KeyValues.HeroKV) do
        if not KeyValues.UnitKV[key] then
            KeyValues.UnitKV[key] = value
        else
            if type(KeyValues.All[key]) == "table" then
                print("[KeyValues] Warning: Duplicated unit/hero entry for " .. key)
            end
        end
    end


    if IsServer() then
        -- 技能商店配置
        KeyValues.spell_shop_physical = LoadKeyValues("scripts/npc/game_config/spell_shop/spell_shop_physical.kv")
        KeyValues.spell_shop_magical = LoadKeyValues("scripts/npc/game_config/spell_shop/spell_shop_magical.kv")
        KeyValues.spell_shop_summon = LoadKeyValues("scripts/npc/game_config/spell_shop/spell_shop_summon.kv")
        KeyValues.spell_shop_defense = LoadKeyValues("scripts/npc/game_config/spell_shop/spell_shop_defense.kv")
        KeyValues.spell_shop_assist = LoadKeyValues("scripts/npc/game_config/spell_shop/spell_shop_assist.kv")
        KeyValues.spell_shop_other = LoadKeyValues("scripts/npc/game_config/spell_shop/spell_shop_other.kv")

        -- 商店配置
        KeyValues.game_shop_general = LoadKeyValues("scripts/npc/game_config/game_shop/game_shop_general.kv")
        KeyValues.game_shop_chaotic_era = LoadKeyValues("scripts/npc/game_config/game_shop/game_shop_chaotic_era.kv")
   

        -- 乱纪元技能配置
        KeyValues.chaotic_spell_class_1 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_1.kv")
        KeyValues.chaotic_spell_class_2 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_2.kv")
        KeyValues.chaotic_spell_class_3 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_3.kv")
        KeyValues.chaotic_spell_class_4 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_4.kv")
        KeyValues.chaotic_spell_class_5 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_5.kv")
        KeyValues.chaotic_spell_class_6 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_6.kv")
        KeyValues.chaotic_spell_class_7 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_7.kv")
        KeyValues.chaotic_spell_class_8 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_8.kv")
        KeyValues.chaotic_spell_class_9 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_9.kv")
        KeyValues.chaotic_spell_class_10 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_10.kv")
        KeyValues.chaotic_spell_class_11 = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_class_11.kv")
        KeyValues.chaotic_spell_talent = LoadKeyValues("scripts/npc/game_config/chaotic_spell_list/chaotic_spell_talent.kv")
        -- 乱纪元怪物属性配置

        KeyValues.chaotic_era_creep_attribute = LoadKeyValues("scripts/npc/game_config/base_setting/chaotic_era_creep_attribute.kv")
        KeyValues.chaotic_era_boss_attribute = LoadKeyValues("scripts/npc/game_config/base_setting/chaotic_era_boss_attribute.kv")

        -- 基础游戏配置
        KeyValues.base_setting = LoadKeyValues("scripts/npc/game_config/base_setting/game_base_config.kv")
        KeyValues.general_wave_setting = LoadKeyValues("scripts/npc/game_config/base_setting/general_wave_setting.kv")
   

        

        --圣物
 

    end
    KeyValues.palyer_artifactKV = LoadKeyValues("scripts/npc/item/item_player_artifact.kv")

    KeyValues.playerArtifact_expSetting = LoadKeyValues("scripts/npc/game_config/base_setting/player_artifact_exp.kv")
       
    KeyValues.game_shop_chaotic_era_potion = LoadKeyValues("scripts/npc/game_config/game_shop/game_shop_chaotic_era_potion.kv")

        
    KeyValues.challenge_info = LoadKeyValues("scripts/npc/game_config/challenge/challenge_info.kv")

    KeyValues.chaotic_spell_runeData = LoadKeyValues("scripts/npc/game_config/chaotic_spell_rune/chaotic_spell_runeData.kv")

    KeyValues.chatic_era_creep_buff = LoadKeyValues("scripts/npc/game_config/modifier_kv/chatic_era_creep_buff.kv")

    -- 乱纪元神器
    KeyValues.map_effect = LoadKeyValues("scripts/npc/game_config/chaotic_buff_card/chaotic_era_map_effect.kv")
    KeyValues.artifact = LoadKeyValues("scripts/npc/game_config/chaotic_buff_card/chaotic_era_artifact.kv")

    

    KeyValues.ability_bonus_info = LoadKeyValues("scripts/npc/game_config/base_setting/ability_bonus_info.kv")

end

if IsServer() then
    -- Works for heroes and units on the same table due to merging both tables on game init
    function CDOTA_BaseNPC:GetKeyValue(key, level)
        if level then
            return GetUnitKV(self:GetUnitName(), key, level)
        else
            return GetUnitKV(self:GetUnitName(), key)
        end
    end

    -- Dynamic version of CDOTABaseAbility:GetAbilityKeyValues()
    function CDOTABaseAbility:GetKeyValue(key, level)
        if level then
            return GetAbilityKV(self:GetAbilityName(), key, level)
        else
            return GetAbilityKV(self:GetAbilityName(), key)
        end
    end

    -- Item version
    function CDOTA_Item:GetKeyValue(key, level)
        if level then
            return GetItemKV(self:GetAbilityName(), key, level)
        else
            return GetItemKV(self:GetAbilityName(), key)
        end
    end

    function CDOTABaseAbility:GetAbilitySpecial(key)
        return GetAbilitySpecial(self:GetAbilityName(), key, self:GetLevel())
    end

    -- Global functions
    -- Key is optional, returns the whole table by omission
    -- Level is optional, returns the whole value by omission
    function GetKeyValue(name, key, level, tbl)
        local t = tbl or KeyValues.All[name]
        if key and t then
            if t[key] and level then
                local s = split(t[key])
                if s[level] then
                    return tonumber(s[level]) or s[level]          -- Try to cast to number
                else
                    return tonumber(s[#s]) or s[#s]
                end
            else
                return t[key]
            end
        else
            return t
        end
    end

    function GetUnitKV(unitName, key, level)
        return GetKeyValue(unitName, key, level, KeyValues.UnitKV[unitName])
    end

    function GetAbilityKV(abilityName, key, level)
        return GetKeyValue(abilityName, key, level, KeyValues.AbilityKV[abilityName])
    end

    function GetItemKV(itemName, key, level)
        return GetKeyValue(itemName, key, level, KeyValues.ItemKV[itemName])
    end

    function GetAbilitySpecial(name, key, level)
        local t = KeyValues.All[name]
        if key and t then
            local tspecial = t["AbilitySpecial"]
            if tspecial then
                -- Find the key we are looking for
                for _, values in pairs(tspecial) do
                    if values[key] then
                        if not level then
                            return values[key]
                        else
                            local s = split(values[key])
                            if s[level] then
                                return tonumber(s[level])          -- If we match the level, return that one
                            else
                                return tonumber(s[#s])
                            end                                    -- Otherwise, return the max
                        end
                        break
                    end
                end
            end
        else
            return t
        end
    end
end


-- if not KeyValues.All then LoadGameKeyValues() end
LoadGameKeyValues()
