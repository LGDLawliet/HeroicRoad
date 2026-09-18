
item_chaotic_gold_bag = class({})

function item_chaotic_gold_bag:OnSpellStart()
	if IsServer() then
        local gold = self:GetSpecialValueFor("gold")
		self:GetCaster():ModifyGoldFiltered(gold,true,DOTA_ModifyGold_CreepKill )
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self:GetCaster(), gold, nil)
		self:SpendCharge(0)
	end
end

