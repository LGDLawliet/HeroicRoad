
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_meepo_3", "heroTalent/heroTalent_npc_dota_hero_meepo_3", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_meepo_3 = class({})

function heroTalent_npc_dota_hero_meepo_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_meepo_3"
end


modifier_heroTalent_npc_dota_hero_meepo_3 = class({})

function modifier_heroTalent_npc_dota_hero_meepo_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_meepo_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_meepo_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_meepo_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_meepo_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_meepo_3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_heroTalent_npc_dota_hero_meepo_3:OnIntervalThink()
	self:UpdateInventory()
end
function modifier_heroTalent_npc_dota_hero_meepo_3:UpdateInventory()
	local hParent = self:GetParent()
	local iExtraInventoryNum = 2
	for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_SLOT_9 do
		local hItem = hParent:GetItemInSlot(i)
		if IsValid(hItem) then
			if i < DOTA_ITEM_SLOT_7 + iExtraInventoryNum then
				hItem:SetCanBeUsedOutOfInventory(true)
				hItem:SetItemState(1)
				hItem:RefreshIntrinsicModifier()
			else
				hItem:SetItemState(-1)
				hItem:SetCanBeUsedOutOfInventory(false)
				local sModifierName = hItem:GetIntrinsicModifierName()
				local tModifiers = hParent:FindAllModifiersByName(sModifierName)
				for _, hBuff in pairs(tModifiers) do
					if hBuff:GetAbility() == hItem then
						hBuff:Destroy()
					end
				end
			end
		end
	end
end