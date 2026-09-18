LinkLuaModifier( "modifier_item_hd_eden_blacksmith", "items/item_hd_eden_blacksmith.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hd_eden_blacksmith == nil then
	item_hd_eden_blacksmith = class({})
end
function item_hd_eden_blacksmith:GetIntrinsicModifierName()
	return "modifier_item_hd_eden_blacksmith"
end

-- function item_hd_eden_blacksmith:OnSpellStart()
-- 	-- self.pull_list = {}

-- 	local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_eden_blacksmith")
-- 	if modifier then
-- 		modifier:OnWaveEnd()
-- 	end




-- end

modifier_item_hd_eden_blacksmith =  modifier_item_hd_eden_blacksmith or advanced_modifier({})

function modifier_item_hd_eden_blacksmith:IsDebuff() return false end
function modifier_item_hd_eden_blacksmith:IsHidden() return true end
function modifier_item_hd_eden_blacksmith:IsPurgable() return false end
function modifier_item_hd_eden_blacksmith:IsPurgeException()return false end
function modifier_item_hd_eden_blacksmith:RemoveOnDeath() return false end
function modifier_item_hd_eden_blacksmith:OnCreated(keys)
	if IsServer() then
		self.count = 0
	end
end
function modifier_item_hd_eden_blacksmith:OnWaveEnd()
	if IsServer() then

		local chance = 17 + self.count
		if chance>=RandomInt(1, 100) then
			local item = self:GetCaster():AddItemByName("item_hd_Treasure4")
			if item then
				local gameEvent = {}
				gameEvent["player_id"] = self:GetCaster():GetPlayerOwnerID()
				gameEvent["message"] = "#DOTA_HUD_eden_blacksmith_platform_info"
				gameEvent["locstring_value"] = "#DOTA_Tooltip_ability_item_hd_eden_blacksmith"
				gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..item:GetAbilityName()
				gameEvent["teamnumber"] = -1
				FireGameEvent( "dota_combat_event_message", gameEvent )
			end
			self.count = 0
		else
			local gameEvent = {}
			gameEvent["player_id"] = self:GetCaster():GetPlayerOwnerID()
			gameEvent["message"] = "#DOTA_HUD_eden_blacksmith_platform_info2"
			gameEvent["teamnumber"] = -1
			FireGameEvent( "dota_combat_event_message", gameEvent )
			self.count = self.count + 5
		end

	end

end




function modifier_item_hd_eden_blacksmith:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end



