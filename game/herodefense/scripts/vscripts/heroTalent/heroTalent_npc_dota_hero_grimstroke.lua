heroTalent_npc_dota_hero_grimstroke = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_grimstroke", "heroTalent/heroTalent_npc_dota_hero_grimstroke", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_grimstroke:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_grimstroke:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_grimstroke:IsStealable() 				return true end
function heroTalent_npc_dota_hero_grimstroke:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_grimstroke:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_grimstroke" end
function heroTalent_npc_dota_hero_grimstroke:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"stroke_of_fate",costKeys)
		
			end
		end)
	
	end

end



modifier_heroTalent_npc_dota_hero_grimstroke = class({})

function modifier_heroTalent_npc_dota_hero_grimstroke:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_grimstroke:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_grimstroke:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_grimstroke:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_grimstroke:RemoveOnDeath() return false end
