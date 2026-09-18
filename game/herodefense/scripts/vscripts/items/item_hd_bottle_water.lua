
item_hd_bottle_water = class({})

--------------------------------------------------------------------------------

-- function item_hd_bottle_water:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_bottle_water:OnSpellStart()


	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		if caster.hd_bottle_water==nil then
			caster.hd_bottle_water = 1
		end
		caster.hd_bottle_water = caster.hd_bottle_water +0.5

		self:SpendCharge(0)
	end
end

