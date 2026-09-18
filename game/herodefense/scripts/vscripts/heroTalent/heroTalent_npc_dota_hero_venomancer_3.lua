heroTalent_npc_dota_hero_venomancer_3 = class({})
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_3_arua", "skills/heroTalent_npc_dota_hero_venomancer_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_3_arua_effect", "skills/heroTalent_npc_dota_hero_venomancer_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_3", "heroTalent/heroTalent_npc_dota_hero_venomancer_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_3_active", "heroTalent/heroTalent_npc_dota_hero_venomancer_3", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_venomancer_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_venomancer_3"
end


function heroTalent_npc_dota_hero_venomancer_3:GetPoison_Sting()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Poison_Sting")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Poison_Sting")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Poison_Sting")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_Poison_Sting")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_Poison_Sting")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_Poison_Sting")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end


function heroTalent_npc_dota_hero_venomancer_3:Spawn()
    self.achievement_count = 0
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 350,
					to_level2_cost = 700,
					to_level3_cost = 1050,
					upgrade_cost = 350,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Poison_Sting",costKeys)
				skillshop:LearnTalentDefaultAbility(caster,"Plague_Ward",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_venomancer_3 = class({})




function modifier_heroTalent_npc_dota_hero_venomancer_3:IsHidden() 	return true end
function modifier_heroTalent_npc_dota_hero_venomancer_3:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_venomancer_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_venomancer_3:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_venomancer_3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local name = unit:GetUnitName()
		if name=="npc_Advanced_Plague_Ward" or name=="npc_Advanced_Plague_Ward_2" then
			local ability = self:GetAbility():GetPoison_Sting()
			if ability then
				ability:OnTalentSummon(unit)
			end
		end


	end
end
