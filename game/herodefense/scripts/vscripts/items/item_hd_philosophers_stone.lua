

item_hd_philosophers_stone = class({})

--------------------------------------------------------------------------------

-- function item_hd_philosophers_stone:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_philosophers_stone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )
		caster.Bonus_gold = caster.Bonus_gold+150

		self:SpendCharge(0)
	end
end
