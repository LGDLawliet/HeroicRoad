heroTalent_npc_dota_hero_nevermore_2 = class({})
function heroTalent_npc_dota_hero_nevermore_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"necromastery",costKeys)
			end
		end)
	
	end

end