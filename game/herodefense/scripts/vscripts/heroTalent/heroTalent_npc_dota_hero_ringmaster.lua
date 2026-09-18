LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ringmaster", "heroTalent/heroTalent_npc_dota_hero_ringmaster.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_new_bottle_1", "items/item_new_bottle_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_1_active", "items/item_new_bottle_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_2", "items/item_new_bottle_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_2_active", "items/item_new_bottle_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_3", "items/item_new_bottle_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_3_active", "items/item_new_bottle_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_4", "items/item_new_bottle_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_4_active", "items/item_new_bottle_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_5", "items/item_new_bottle_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_5_active", "items/item_new_bottle_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_5_break", "items/item_new_bottle_5", LUA_MODIFIER_MOTION_NONE)
--Abilitiesmodifier_item_new_bottle_4
if heroTalent_npc_dota_hero_ringmaster == nil then
	heroTalent_npc_dota_hero_ringmaster = class({})
end
function heroTalent_npc_dota_hero_ringmaster:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_ringmaster"
end
local function new_bottle_modify(self)
	self.bottle_heal_modifier.mul = 2
	self.tmpmodifier = self.tmpmodifier or nil
	print("ok?")
	local random = math.random(5)
	local modifiername = "modifier_item_new_bottle_"..random
	if self.tmpmodifier then
		self.tmpmodifier:SafeDestroy()
	end
	self.tmpmodifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, modifiername, {})
	print(self:GetCaster():GetUnitName().."::"..tostring(self.tmpmodifier))
	-- print(self:GetCaster():FindModifierByName(modifiername).."::"..modifiername)

end
function heroTalent_npc_dota_hero_ringmaster:OnSpellStart()
	
end

---------------------------------------------------------------------
--Modifiers
if modifier_heroTalent_npc_dota_hero_ringmaster == nil then
	modifier_heroTalent_npc_dota_hero_ringmaster = advanced_modifier({})
end
function modifier_heroTalent_npc_dota_hero_ringmaster:OnCreated(params)
	if IsServer() then
		local parent = self:GetParent()
		local item = parent:GetItemInSlot(15)
		InsertModelModify(item,"OnSpellStart",new_bottle_modify)
	end
	
end
function modifier_heroTalent_npc_dota_hero_ringmaster:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_ringmaster:OnDestroy()
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_ringmaster:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_heroTalent_npc_dota_hero_ringmaster:OnDeath(keys)
	if IsServer() then
		print("触发")
		if keys.unit:GetTeam() == 2 then
			return 
		end


		local parent = self:GetParent()
		local item = parent:GetItemInSlot(15)
		if item:GetCurrentCharges() == 0 then
			item:SetCurrentCharges(1)
		end
	end
end
