heroTalent_npc_dota_hero_faceless_void_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void_2", "heroTalent/heroTalent_npc_dota_hero_faceless_void_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void_2_move", "heroTalent/heroTalent_npc_dota_hero_faceless_void_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_faceless_void_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_faceless_void_2"
end

function heroTalent_npc_dota_hero_faceless_void_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Void_time_walk",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_faceless_void_2 = class({})

function modifier_heroTalent_npc_dota_hero_faceless_void_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_faceless_void_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_2:RemoveOnDeath() return false end
