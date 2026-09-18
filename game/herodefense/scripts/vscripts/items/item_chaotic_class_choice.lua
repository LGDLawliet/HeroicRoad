LinkLuaModifier( "modifier_item_chaotic_class_choice", "items/item_chaotic_class_choice.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_choice_active", "items/item_chaotic_class_choice.lua", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_choice = class({})

function item_chaotic_class_choice:OnSpellStart()
	local items = {}
	local itemData = {
		itemName = "item_chaotic_class_range_phy",
		itemType = "class",
	}
    local itemData2 = {
		itemName = "item_chaotic_class_melee_phy",
		itemType = "class",
	}
    -- local itemData3 = {
	-- 	itemName = "item_chaotic_class_tank",
	-- 	itemType = "class",
	-- }
    local itemData4 = {
		itemName = "item_chaotic_class_ass",
		itemType = "class",
	}
    -- local itemData5 = {
	-- 	itemName = "item_chaotic_class_spell",
	-- 	itemType = "class",
	-- }
	local itemData6 = {
		itemName = "item_chaotic_class_summon",
		itemType = "class",
	}
	local itemData7 = {
		itemName = "item_chaotic_class_gold",
		itemType = "class",
	}
	table.insert(items,itemData)
	table.insert(items,itemData2)
	--table.insert(items,itemData3)
	table.insert(items,itemData4)
	--table.insert(items,itemData5)
	table.insert(items,itemData6)
	table.insert(items,itemData7)
	--table.insert(items,itemData)
	local player = self:GetCaster():GetPlayerOwner()

	CustomGameEventManager:Send_ServerToPlayer(player, "showBossRewards", { item =  items,level = 0,chance = 0})
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_choice")
    if item ~=nil then
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end