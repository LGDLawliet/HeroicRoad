heroTalent_npc_dota_hero_centaur_3 = class({})


function heroTalent_npc_dota_hero_centaur_3:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"hoof_stomp",costKeys)
				skillshop:LearnTalentDefaultAbility(caster,"double_edge",costKeys)
			end
		end)
	
	end

end
