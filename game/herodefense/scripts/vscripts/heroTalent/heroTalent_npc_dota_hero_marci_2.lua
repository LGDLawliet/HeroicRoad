heroTalent_npc_dota_hero_marci_2 = class({})

-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_2", "heroTalent/heroTalent_npc_dota_hero_marci_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_2_effect", "heroTalent/heroTalent_npc_dota_hero_marci_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_marci_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_marci_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_marci_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_marci_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_marci_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"unleash",costKeys)
			end
		end)
	
	end

end