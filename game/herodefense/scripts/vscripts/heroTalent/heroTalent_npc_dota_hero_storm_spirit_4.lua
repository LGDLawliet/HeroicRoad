heroTalent_npc_dota_hero_storm_spirit_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_storm_spirit_4", "heroTalent/heroTalent_npc_dota_hero_storm_spirit_4", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_storm_spirit_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_storm_spirit_4"
end

function heroTalent_npc_dota_hero_storm_spirit_4:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"summon_wind_element",costKeys)
		
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_storm_spirit_4 = class({})

function modifier_heroTalent_npc_dota_hero_storm_spirit_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_4:RemoveOnDeath() return false end




