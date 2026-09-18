heroTalent_npc_dota_hero_earthshaker_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earthshaker_2", "heroTalent/heroTalent_npc_dota_hero_earthshaker_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_earthshaker_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_earthshaker_2"
end


function heroTalent_npc_dota_hero_earthshaker_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/after_shock/talent2/effect.vpcf", context )
end

function heroTalent_npc_dota_hero_earthshaker_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 250,
					to_level2_cost = 500,
					to_level3_cost = 750,
					upgrade_cost = 250,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"aftershock",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_earthshaker_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_earthshaker_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_earthshaker_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_2:RemoveOnDeath() return false end

