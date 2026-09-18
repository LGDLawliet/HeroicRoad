heroTalent_npc_dota_hero_enigma = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_enigma", "heroTalent/heroTalent_npc_dota_hero_enigma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_enigma_effect", "heroTalent/heroTalent_npc_dota_hero_enigma", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_enigma:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_enigma:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_enigma:IsStealable() 				return true end
function heroTalent_npc_dota_hero_enigma:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_enigma:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_enigma"
end

function heroTalent_npc_dota_hero_enigma:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Malefice",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_enigma = class({})

function modifier_heroTalent_npc_dota_hero_enigma:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_enigma:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_enigma:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_enigma:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_enigma:RemoveOnDeath() return false end