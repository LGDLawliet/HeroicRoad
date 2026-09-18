heroTalent_npc_dota_hero_rubick_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_rubick_3", "heroTalent/heroTalent_npc_dota_hero_rubick_3", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_rubick_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_rubick_3"
end

function heroTalent_npc_dota_hero_rubick_3:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Arc_Lightning",costKeys)
		
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_rubick_3 = class({})

function modifier_heroTalent_npc_dota_hero_rubick_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_rubick_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_rubick_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_rubick_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_rubick_3:RemoveOnDeath() return false end




