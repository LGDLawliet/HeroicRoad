heroTalent_npc_dota_hero_void_spirit_2 = class({})

-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_void_spirit_2", "heroTalent/heroTalent_npc_dota_hero_void_spirit_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_void_spirit_2_effect", "heroTalent/heroTalent_npc_dota_hero_void_spirit_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_void_spirit_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_void_spirit_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_void_spirit_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_void_spirit_2:IsNetherWardStealable()		return true end


function heroTalent_npc_dota_hero_void_spirit_2:Spawn()
    self.achievement_count = 0
    if IsServer() then
        if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"plane_shuttle_1") then
			self.plane_shuttle_1 = true
		end

		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 750,
					to_level2_cost = 1500,
					to_level3_cost = 2200,
					upgrade_cost = 750,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"astral_step",costKeys)



			end
		end)
    end
end
function heroTalent_npc_dota_hero_void_spirit_2:AddCount()
    self.achievement_count =  self.achievement_count+  1
end



function heroTalent_npc_dota_hero_void_spirit_2:OnCustomDataSettlement()
    if not self.plane_shuttle_1 then
        local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomDataWithValue("plane_shuttle_1",self.achievement_count)
		end
    end
	-- if self.customAchievement then
		-- local caster = self:GetCaster()
		-- local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		-- if modifier then
		-- 	modifier:UnlockCustomDataWithValue("plane_shuttle_1",self.achievement_count)
		-- end
	-- end

end

function heroTalent_npc_dota_hero_void_spirit_2:OnCostCharge()
    if self.plane_shuttle_1 and 5>=RandomInt(1, 100) then
        -- print("+1")
        self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges()+1)
    end
end


-- 

-- 







-- function heroTalent_npc_dota_hero_void_spirit_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_void_spirit_2" end
-- -- function heroTalent_npc_dota_hero_void_spirit_2:OnSpellStart()
-- --     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_void_spirit_2")
-- --     if modifier then
-- --         modifier.count = modifier.count +1
-- --     end
-- -- end


-- modifier_heroTalent_npc_dota_hero_void_spirit_2 = class({})

-- function modifier_heroTalent_npc_dota_hero_void_spirit_2:IsDebuff()			return false end
-- function modifier_heroTalent_npc_dota_hero_void_spirit_2:IsHidden() 			return false end
-- function modifier_heroTalent_npc_dota_hero_void_spirit_2:IsPurgable() 		    return false end
-- function modifier_heroTalent_npc_dota_hero_void_spirit_2:IsPurgeException() return false end
-- function modifier_heroTalent_npc_dota_hero_void_spirit_2:RemoveOnDeath() return false end
