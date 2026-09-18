function GameEvent(eventName, func, context)
	local iListenerID = ListenToGameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, iListenerID)
	return iListenerID
end

if IsClient() then
    _G.GAME_DIFFICULTY = 0 
    _G.GameEventListenerIDs = {}
    -- require("internal/problem")  --暂时方案
    -- require('key')
    -- require('internal/funcs2')


    _G.json = require("game/dkjson")
    require("internal/string_utils")
    require("internal/keyvalues")
    require( "constants" ) -- require constants first
    require("internal/client_funcs")
    require('decrypt_f/hdHeroFuncs')
    -- require( "internal/custom_indicator" )
    require( "internal/client/client_request" )
    require("modifier/hd_modifier")

    
    require("modifier_link")


    require('internal/Artifact/artifact_funcs')

    -- require("challenge")  --苦难试炼
    ClientRequest:init()
    -- SendToConsole("dota_hud_disable_damage_numbers 1")  --不显示伤害数字
    -- GameEvent("hd_get_modifier_property", OnGetModifierProperty, nil)
    -- print("aaaaaaaaaaaaaaaaabbbbbbbbb")
    
    -- ClientRequest:RegisterClientEvent("get_modifier_property", OnGetModifierProperty)

end
function init()
    ListenToGameEvent("hd_get_unit_data", OnGetUnitData, nil)
    ListenToGameEvent("hd_data_syn", OnClientDataSYN, nil)
    ListenToGameEvent("hd_data_syn_abilityCustomValue", OnClientDataSYN_abilityCustomValue, nil)

    
end

-- 注意 玩家重连后将丢失这些数据 所以不要用这个方法来显示重要数据

-- 同步客户端全局变量
function OnClientDataSYN(keys)
    local data_name =  keys.data_name
    local value = keys.value
    if data_name and value then
        _G[data_name] = value
    end
end
-- 同步客户端技能自定义变量
function OnClientDataSYN_abilityCustomValue(keys)
    local abilityIndex = keys.ability
    local data_name =  keys.data_name
    local value = keys.value
    local ability = EntIndexToHScript(abilityIndex)
    if ability then
        if data_name and value then
            ability[data_name] = value
        end
    end
  
end


-- function OnGetModifierProperty(tEvents)
--     print("gooooooaa")
-- 	local hModifier = EntIndexToHScript(tEvents.modifier_ent_index)
-- 	local sFunctionName = tEvents.function_name
-- 	local value
-- 	local func = _G[sFunctionName]
-- 	if IsValid(hModifier) and type(func) == "function" then
-- 		value = func(hModifier)
-- 	end
--     print("gooo222")
-- 	return { value = value }
-- end

_G.GetUnitData_UnitEntIndex = -1
-- _G.GetUnitData_ModifierEntIndex = -1
_G.GetUnitData_FunctionName = ""
function OnGetUnitData(tEvents)
	_G.GetUnitData_UnitEntIndex = tEvents.unit_ent_index
    -- _G.GetUnitData_ModifierEntIndex = tEvents.modifier_ent_index
	_G.GetUnitData_FunctionName = tEvents.function_name
end



init()




