
item_hd_gold_bag = class({})
--------------------------------------------------------------------------------

-- function item_hd_gold_bag:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_gold_bag:OnSpellStart()
	if IsServer() then

		self:GetCaster():ModifyGoldFiltered(750,true,DOTA_ModifyGold_CreepKill )
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self:GetCaster(), 750, nil)

		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------
