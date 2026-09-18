heroTalent_npc_dota_hero_enchantress = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_enchantress", "heroTalent/heroTalent_npc_dota_hero_enchantress", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_enchantress:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_enchantress"
end


modifier_heroTalent_npc_dota_hero_enchantress = class({})

function modifier_heroTalent_npc_dota_hero_enchantress:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_enchantress:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_enchantress:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_enchantress:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_enchantress:RemoveOnDeath() return false end
