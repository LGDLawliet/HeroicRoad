if ClientRequest == nil then
	_G.ClientRequest = class({})
end

local public = ClientRequest

function public:init()
	self.tEvents = {}
	GameEvent("client_request_event", Dynamic_Wrap(public, "OnClientEvent"), public)
end

-- 注册事件
function public:RegisterClientEvent(sEvent, func, context)
	print("register")
	print(sEvent)
	print(func)
	print(context)
	self.tEvents[sEvent] = { callback = func, context = context }
end

-- 触发服务器事件
function public:FireClientEvent(sEvent, data)
	self:OnClientEvent({
		game_event_listener = -1,
		game_event_name = "",
		splitscreenplayer = GetLocalPlayerID(),
		event = sEvent,
		data = json.encode(data),
		_IsFire = true
	})
end

function public:OnClientEvent(tData)
	local tEventTable = self.tEvents[tData.event]
	if tEventTable == nil then
		return
	end
	local data = json.decode(tData.data)
	if data == nil then
		return
	end
	local result
	local func = tEventTable.callback
	if tEventTable.context ~= nil then
		result = func(tEventTable.context, data)
	else
		result = func(data)
	end
	if tData._IsFire ~= true and type(result) == "table" then
		local json_str = json.encode(result)
		_G.ClientRequestEventResult = json_str
	end
end

return public