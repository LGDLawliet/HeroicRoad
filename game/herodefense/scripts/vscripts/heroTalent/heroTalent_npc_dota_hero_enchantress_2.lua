heroTalent_npc_dota_hero_enchantress_2 = heroTalent_npc_dota_hero_enchantress_2 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_enchantress_2", "heroTalent/heroTalent_npc_dota_hero_enchantress_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_enchantress_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_enchantress_2" end

function heroTalent_npc_dota_hero_enchantress_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Impetus",costKeys)


			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_enchantress_2 =  modifier_heroTalent_npc_dota_hero_enchantress_2 or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_enchantress_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_enchantress_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_enchantress_2:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_enchantress_2:IsPurgeException() 	return false end

function modifier_heroTalent_npc_dota_hero_enchantress_2:Advanced_GetModifierAttackRangeBonus() 
	return 200
end


function modifier_heroTalent_npc_dota_hero_enchantress_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end
