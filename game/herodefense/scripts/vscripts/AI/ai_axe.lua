
require("internal/timers")
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	Timers:CreateTimer(0.5, function()
		thisEntity:SetOrigin(Vector(-300,-1053,896))
		thisEntity:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end)
end
