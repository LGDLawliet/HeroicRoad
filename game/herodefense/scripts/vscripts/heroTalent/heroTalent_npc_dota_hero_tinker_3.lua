heroTalent_npc_dota_hero_tinker_3 = heroTalent_npc_dota_hero_tinker_3 or  class({})
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_3_thinker", "heroTalent/heroTalent_npc_dota_hero_tinker_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tinker_3_buff", "heroTalent/heroTalent_npc_dota_hero_tinker_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_tinker_3:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/cast_effect/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/arc_warden_2/effect.vpcf", context )

	

-- end


function heroTalent_npc_dota_hero_tinker_3:Spawn()
    self.achievement_count = 0
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
				skillshop:LearnTalentDefaultAbility(caster,"heat_seeking_missile",costKeys)
			end
		end)
	
	end

end




-- function heroTalent_npc_dota_hero_tinker_3:OnSpellStart()
-- 	local caster = self:GetCaster()
-- 	uimanager:ChegeTimeScaleOrder(caster:GetPlayerOwnerID(),1.6)
-- 	caster:EmitSound("Hero_Tinker.Rearm")

-- end
