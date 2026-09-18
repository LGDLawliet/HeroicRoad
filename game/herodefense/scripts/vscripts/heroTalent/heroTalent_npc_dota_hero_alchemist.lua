heroTalent_npc_dota_hero_alchemist = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_alchemist", "heroTalent/heroTalent_npc_dota_hero_alchemist", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_alchemist:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_alchemist:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_alchemist:IsStealable() 				return true end
function heroTalent_npc_dota_hero_alchemist:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_alchemist:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_alchemist" end


modifier_heroTalent_npc_dota_hero_alchemist = class({})

function modifier_heroTalent_npc_dota_hero_alchemist:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_alchemist:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_alchemist:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_alchemist:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_alchemist:RemoveOnDeath() return false end

