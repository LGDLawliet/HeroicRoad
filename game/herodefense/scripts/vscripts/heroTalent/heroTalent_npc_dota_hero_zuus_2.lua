heroTalent_npc_dota_hero_zuus_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus_2", "heroTalent/heroTalent_npc_dota_hero_zuus_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus_2_effect", "heroTalent/heroTalent_npc_dota_hero_zuus_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_zuus_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_zuus_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_zuus_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_zuus_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_zuus_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_zuus_2" end
-- function heroTalent_npc_dota_hero_zuus_2:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_zuus_2")
--     if modifier then
--         modifier.count = modifier.count +1
--     end
-- end

function heroTalent_npc_dota_hero_zuus_2:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end

function heroTalent_npc_dota_hero_zuus_2:Unlockachievement()
	-- print("oooooooooooook")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_zuus_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("disaster_surviver_1")
		end
	end

end

function heroTalent_npc_dota_hero_zuus_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Lightning_Bolt",costKeys)
			end
		end)
	
	end

end






modifier_heroTalent_npc_dota_hero_zuus_2 = class({})

function modifier_heroTalent_npc_dota_hero_zuus_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_zuus_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_zuus_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_zuus_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_zuus_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_zuus_2:OnCreated()
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.current_unit = nil
        self.current_count = 0
        self.base_cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())
        if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"disaster_surviver_1") then
			print("achievement ok")
			self.base_cooldown = self.base_cooldown -2
		end
        self:StartIntervalThink(0.2)
    end
end



function modifier_heroTalent_npc_dota_hero_zuus_2:OnIntervalThink()
	local ability = self:GetAbility()
    if ability:IsCooldownReady() then
        local caster = self:GetParent()
        if not caster:IsAlive() then
            return
        end
        if caster:PassivesDisabled() then
            return
        end
        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, unit in ipairs(units) do
            local lighiting_ability = caster:FindAbilityByName("Primary_Lightning_Bolt") or caster:FindAbilityByName("Middle_Lightning_Bolt")
            if lighiting_ability then
                caster:SetCursorCastTarget(unit)
                self:CheckCount(unit)
                lighiting_ability:OnSpellStart()
                local base_cooldown = self.base_cooldown
                ability:StartCooldown(base_cooldown* self:GetParent():GetCooldownReduction( ))
                -- ability:UseResources(true, true, true, true)
                break
            else
                lighiting_ability = caster:FindAbilityByName("Advanced_Lightning_Bolt") 
                if lighiting_ability then
                    if lighiting_ability.unlock3 then
                        caster:SetCursorPosition(unit:GetOrigin())
                        self:CheckCount(unit)
                        lighiting_ability:OnSpellStart()
                        local base_cooldown = self.base_cooldown*2
                        ability:StartCooldown(base_cooldown* self:GetParent():GetCooldownReduction( ))
                        break
                    else
                        caster:SetCursorCastTarget(unit)
                        self:CheckCount(unit)
                        lighiting_ability:OnSpellStart()
                        if lighiting_ability.unlock1 or lighiting_ability.unlock2 then
                            local base_cooldown = self.base_cooldown*2
                            ability:StartCooldown(base_cooldown* self:GetParent():GetCooldownReduction( ))
                            break
                        end
                        local base_cooldown = self.base_cooldown
                        ability:StartCooldown(base_cooldown* self:GetParent():GetCooldownReduction( ))
                        -- ability:UseResources(true, true, true, true)
                        break
                    end
                   
                end
            end
            
            ability:UseResources(true, true, true, true)
            break
        end


        
    end
	
	
end

function modifier_heroTalent_npc_dota_hero_zuus_2:CheckCount(unit)
    if self.current_unit~=unit then
        self.current_unit = unit
        self.current_count = 0
    else
        self.current_count = self.current_count + 1
    end

    if self.current_count>=5  then
        if 15>=RandomInt(1, 100) then
            self:GetAbility():Unlockachievement()
        end
    end

    
end