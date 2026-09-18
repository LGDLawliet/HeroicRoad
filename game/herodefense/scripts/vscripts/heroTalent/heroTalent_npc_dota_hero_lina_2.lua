heroTalent_npc_dota_hero_lina_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lina_2", "heroTalent/heroTalent_npc_dota_hero_lina_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lina_2_buff", "heroTalent/heroTalent_npc_dota_hero_lina_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_lina_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_lina_2"
end

function heroTalent_npc_dota_hero_lina_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"laguna_blade",costKeys)





		
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_lina_2 = class({})

function modifier_heroTalent_npc_dota_hero_lina_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_lina_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_lina_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_lina_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_lina_2:RemoveOnDeath() return false end




