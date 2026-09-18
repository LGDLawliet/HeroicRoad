heroTalent_npc_dota_hero_tidehunter_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tidehunter_2", "heroTalent/heroTalent_npc_dota_hero_tidehunter_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_water_zoom", "modifier/generic/modifier_generic_water_zoom", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_tidehunter_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_tidehunter_2"
end



function heroTalent_npc_dota_hero_tidehunter_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"kraken_shell",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_tidehunter_2 = class({})

function modifier_heroTalent_npc_dota_hero_tidehunter_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tidehunter_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tidehunter_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tidehunter_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_tidehunter_2:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_heroTalent_npc_dota_hero_tidehunter_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel())
	if cooldown <= 3 then
		return
	end


	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:HasModifier("modifier_generic_water_zoom_buff") then
		CreateModifierThinker(parent, ability, "modifier_generic_water_zoom", {duration = cooldown*2,radius=700,team =DOTA_UNIT_TARGET_TEAM_FRIENDLY  }, parent:GetOrigin(), parent:GetTeamNumber(), false)

	end
	
end
