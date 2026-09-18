heroTalent_npc_dota_hero_dragon_knight = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dragon_knight", "heroTalent/heroTalent_npc_dota_hero_dragon_knight", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_dragon_knight:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dragon_knight"
end


function heroTalent_npc_dota_hero_dragon_knight:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"dragon_blood",costKeys)
			end
		end)
	
	end


end



modifier_heroTalent_npc_dota_hero_dragon_knight = class({})

function modifier_heroTalent_npc_dota_hero_dragon_knight:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dragon_knight:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight:RemoveOnDeath() return false end

