heroTalent_npc_dota_hero_magnataur_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_2", "heroTalent/heroTalent_npc_dota_hero_magnataur_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_2_skewer", "heroTalent/heroTalent_npc_dota_hero_magnataur_2", LUA_MODIFIER_MOTION_HORIZONTAL  )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_magnataur_2_skewer_debuff", "heroTalent/heroTalent_npc_dota_hero_magnataur_2", LUA_MODIFIER_MOTION_HORIZONTAL  )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_magnataur_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_magnataur_2"
end
function heroTalent_npc_dota_hero_magnataur_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"empower",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_magnataur_2 = class({})

function modifier_heroTalent_npc_dota_hero_magnataur_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_magnataur_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_magnataur_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_magnataur_2:RemoveOnDeath() return false end


