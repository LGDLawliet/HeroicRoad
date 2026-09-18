

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	-- thisEntity:AddWearable("models/items/phantom_assassin/armor_reprisal_head/armor_reprisal_head.vmdl")
	-- WearableManager:AddNewWearable(thisEntity, {ID = "12345"}, nil)
	-- thisEntity:AddWearable("models/items/vengefulspirit/fallenprincess_head_s2/fallenprincess_head_s2.vmdl","attach_hitloc")
	-- thisEntity:AddWearable("models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl")

	-- Ability1 = thisEntity:FindAbilityByName( "creeps_spell_Electrostatic_Armor_Wake" )
	-- -- ultAbility = thisEntity:FindAbilityByName( "culling_blade_datadriven" )
	-- thisEntity:SetContextThink( "AIThink", AIThink, 0.5 )
end

