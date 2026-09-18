heroTalent_npc_dota_hero_alchemist_2 =heroTalent_npc_dota_hero_alchemist_2 or class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_alchemist_2", "heroTalent/heroTalent_npc_dota_hero_alchemist_2", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_alchemist_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_alchemist_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_alchemist_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_alchemist_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_alchemist_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_alchemist_2" end

function heroTalent_npc_dota_hero_alchemist_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Chemical_Rage",costKeys)



			end
		end)
	
	end

end



modifier_heroTalent_npc_dota_hero_alchemist_2 =modifier_heroTalent_npc_dota_hero_alchemist_2 or class({})

function modifier_heroTalent_npc_dota_hero_alchemist_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_alchemist_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_alchemist_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_alchemist_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_alchemist_2:RemoveOnDeath() return false end

