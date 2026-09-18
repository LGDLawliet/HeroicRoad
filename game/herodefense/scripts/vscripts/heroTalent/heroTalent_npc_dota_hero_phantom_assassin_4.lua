heroTalent_npc_dota_hero_phantom_assassin_4 = heroTalent_npc_dota_hero_phantom_assassin_4 or class({})
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_4", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_4", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_4_debuff", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_phantom_assassin_4:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_phantom_assassin_4"
-- end

function heroTalent_npc_dota_hero_phantom_assassin_4:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_dagger.vpcf", context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives_debuff.vpcf", context )
end
function heroTalent_npc_dota_hero_phantom_assassin_4:CritEffect(target)
	local caster = self:GetCaster()
	local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_dagger.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
	caster:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
	ParticleManager:ReleaseParticleIndex(pfx)
end

function heroTalent_npc_dota_hero_phantom_assassin_4:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Coup_De_Grace",costKeys)
			end
		end)
	
	end

end
