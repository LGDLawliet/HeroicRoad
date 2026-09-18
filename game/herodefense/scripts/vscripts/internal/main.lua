if internalMain == nil then
	internalMain = class({})
end

local mechanics = {
	
	require("internal/Artifact/player_artifact"),
	require("internal/Game_State"),
	require("internal/talentManager"),
	require("internal/fellOmen"),
	require("internal/particleManager"),
	require("internal/game_event/game_event"),
	require("internal/BonusItems"),
	require("internal/challenge"),
	require("internal/chaotic_era/chaotic_era"),
	require("internal/chaotic_era/chaotic_era_spawner"),
	require("internal/chaotic_era/chaotic_era_shop"),
	require("internal/customDataManager"),
	require("internal/Myspawner"),
	require("internal/achievement"),

	require("internal/skillshop"),
	require("internal/ui_event/uimanager"),
	require("internal/weather_controler"),



}

-- local classes = {
-- 	require("class/building"),
-- }

function internalMain:init(bReload)
	print("internalMain init")
	-- 初始化类
	-- for k, v in pairs(classes) do
	-- 	_G[k] = v
	-- 	if v.init ~= nil then v.init(bReload) end
	-- end

	-- 初始化系统
	for k, v in pairs(mechanics) do
		if type(k) == "string" then
			_G[k] = v
		end
		if type(v) == "table" then
			if v.init ~= nil then
				v:init(bReload)
			end
		else
			-- error("missing return in end of file", k)
			print("missing return in end of file", k)
		end
	end
end



return internalMain