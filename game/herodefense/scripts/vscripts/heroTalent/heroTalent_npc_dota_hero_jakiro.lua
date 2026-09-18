heroTalent_npc_dota_hero_jakiro = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_jakiro", "heroTalent/heroTalent_npc_dota_hero_jakiro", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_jakiro:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_jakiro:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_jakiro:IsStealable() 				return true end
function heroTalent_npc_dota_hero_jakiro:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_jakiro:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_jakiro"
end

function heroTalent_npc_dota_hero_jakiro:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Liquid_Fire",costKeys)
				skillshop:LearnTalentDefaultAbility(caster,"Liquid_Frost",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_jakiro = class({})

function modifier_heroTalent_npc_dota_hero_jakiro:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_jakiro:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_jakiro:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_jakiro:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_jakiro:RemoveOnDeath() return false end
