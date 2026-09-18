heroTalent_npc_dota_hero_meepo_2 = class({})
function heroTalent_npc_dota_hero_meepo_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 750,
					to_level2_cost = 1500,
					to_level3_cost = 2200,
					upgrade_cost = 750,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Einherjar",costKeys)



			end
		end)
	
	end

end