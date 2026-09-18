heroTalent_npc_dota_hero_bristleback_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bristleback_2", "heroTalent/heroTalent_npc_dota_hero_bristleback_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bristleback_2_effect", "heroTalent/heroTalent_npc_dota_hero_bristleback_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_bristleback_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bristleback_2"
end
function heroTalent_npc_dota_hero_bristleback_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/bristleback_2/effect.vpcf", context )
end


function heroTalent_npc_dota_hero_bristleback_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 600,
					to_level3_cost = 900,
					upgrade_cost = 300,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Bristle_Back",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_bristleback_2 = class({})

function modifier_heroTalent_npc_dota_hero_bristleback_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_bristleback_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bristleback_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bristleback_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bristleback_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_bristleback_2:GetEffectName()
	return 	"particles/rebuild/talent/bristleback_2/effect.vpcf"
end
