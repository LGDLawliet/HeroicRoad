heroTalent_npc_dota_hero_phantom_assassin_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_2", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_2_effect", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_phantom_assassin_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_phantom_assassin_2"
end

function heroTalent_npc_dota_hero_phantom_assassin_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_ambient.vpcf", context )
end


function heroTalent_npc_dota_hero_phantom_assassin_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Blur",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_phantom_assassin_2 = class({})

function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:RemoveOnDeath() return false end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_2:OnDeath(keys)
    if not IsServer() then
        return
    end
	-- local ability = self:GetAbility()
    if keys.attacker == self:GetParent() then
		if keys.attacker:PassivesDisabled() then
			return
		end
	
		local ability = keys.attacker:FindAbilityByName("Advanced_Blur") or keys.attacker:FindAbilityByName("Middle_Blur") or keys.attacker:FindAbilityByName("Primary_Blur")
		if ability then
			ability:OnSpellStart()
		end
	end

end