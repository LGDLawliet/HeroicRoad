LinkLuaModifier("modifier_item_act2_drop", "items/item_act2_choice.lua", LUA_MODIFIER_MOTION_NONE)
item_act2_choice = class({})

function item_act2_choice:OnSpellStart()
	local items = {}
	local itemData = {
		itemName = "item_act2_nevermore",
		itemType = "class",
	}
    local itemData2 = {
		itemName = "item_act2_wolf",
		itemType = "class",
	}
    local itemData3 = {
		itemName = "item_act2_enigma",
		itemType = "class",
	}
    local itemData4 = {
		itemName = "item_act2_slark",
		itemType = "class",
	}
    local itemData5 = {
		itemName = "item_act2_leshrac",
		itemType = "class",
	}
	local itemData6 = {
		itemName = "item_act2_razor",
		itemType = "class",
	}
	table.insert(items,itemData)
	table.insert(items,itemData2)
	table.insert(items,itemData3)
	table.insert(items,itemData4)
	table.insert(items,itemData5)
	table.insert(items,itemData6)
	--table.insert(items,itemData)
	local player = self:GetCaster():GetPlayerOwner()

	CustomGameEventManager:Send_ServerToPlayer(player, "showBossRewards", { item =  items,level = 0,chance = 0})
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_act2_choice")
    if item ~=nil then
		caster:AddNewModifier(caster, nil, "modifier_item_act2_drop", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

----
modifier_item_act2_drop = advanced_modifier({})

function modifier_item_act2_drop:IsHidden() return true end
function modifier_item_act2_drop:IsDebuff() return false end
function modifier_item_act2_drop:IsPurgable() return false end
function modifier_item_act2_drop:RemoveOnDeath() return false end
function modifier_item_act2_drop:OnCreated()
	if IsServer() then
		self.small_chance = 40
		self.book_chance = 70
		self.dice = 0
		self.parent = self:GetParent()
		self:SetStackCount(#GetAllRealHeroes())
	end
end
function modifier_item_act2_drop:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
    }
end

function modifier_item_act2_drop:OnDeath(params)
    if not IsServer() then return end
	local unit = params.unit
	local attacker = params.attacker
	if not attacker or attacker:GetPlayerOwnerID() ~= self:GetParent():GetPlayerOwnerID() then return end
	if not IsEnemy(unit, self:GetParent()) then return end

    --击杀非指名boss：
    if unit:GetUnitName() == "npc_monster_challenge_005" 
		or unit:GetUnitName() == "npc_monster_challenge_006" 
		or unit:GetUnitName() == "npc_monster_challenge_007" then

		self:Gainitems()
	end
	--击杀指名boss：
	if unit:GetUnitName() == "npc_monster_challenge_001" 
	or unit:GetUnitName() == "npc_monster_challenge_002"
	or unit:GetUnitName() == "npc_monster_challenge_003" 
	or unit:GetUnitName() == "npc_monster_challenge_004" 
	or unit:GetUnitName() == "npc_monster_challenge_008"  
	or unit:GetUnitName() == "npc_monster_challenge_009" then
		-- 这是谜团的分裂体,不掉落精髓
		if unit:GetUnitName() == "npc_monster_challenge_003"  then
			if unit:HasModifier("modifier_enigma_challenge_split_buff") then
				return
			end
		end
		if self.small_chance >= math.random(1,100) then
			self:Gainitems()
		end
	end
end

function modifier_item_act2_drop:OnAbilityFullyCast(params)
    if not IsServer() then return end
    if params.unit ~= self.parent then return end
	
	--使用知识之书：50
	--谁用的给谁
    if params.ability:GetName() == "item_secret_of_experience" 
		or params.ability:GetName() == "item_secret_of_experience_2" 
		or params.ability:GetName() == "item_secret_of_experience_3" then 
		if self.book_chance >= math.random(1,100) then
			self:GetParent():AddItemByName("item_act2_giant")
		end
	end
	--每使用10次风险骰子
	--谁用的给谁
	if params.ability:GetName() == "item_hd_risk_dice" then 
		self.dice = self.dice + 1
		if self.dice >= 10 then
			self:GetParent():AddItemByName("item_act2_giant")
			self.dice = 0
		end
	end 
end

function modifier_item_act2_drop:Gainitems()
	if not IsServer() then return end
	local heroes = GetAllRealHeroes()
	for _, hero in pairs(heroes) do
		if hero ~= self.parent then
			if 60 >= math.random(1,100) then
				hero:AddItemByName("item_act2_giant")
			end
		else
			hero:AddItemByName("item_act2_giant")
		end
	end
end