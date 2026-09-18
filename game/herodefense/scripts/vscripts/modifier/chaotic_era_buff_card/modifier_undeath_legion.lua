
modifier_undeath_legion = advanced_modifier({})

function modifier_undeath_legion:IsHidden()return false end
function modifier_undeath_legion:IsDebuff()return false end
function modifier_undeath_legion:IsPurgable()return false end
function modifier_undeath_legion:IsPurgeException() 	return false end
function modifier_undeath_legion:RemoveOnDeath() return true end
function modifier_undeath_legion:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_undeath_legion:GetTexture() return self.texture end

function modifier_undeath_legion:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        -- self.bonus = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local taskCount = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local count =  GetChaticEra_BuffCardSpecial(self,"count",keys.level or 1)
        local attribute =  GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        local bonus_rune = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

        local insertKeys = {
            attribute_index = attribute,
            rune_progressIndex = bonus_rune,
            overrideCount = count,
            overrideBonusCount =  GetChaticEra_BuffCardSpecial(self,"value4",keys.level or 1),
    
        }

        local heroes = GetAllRealHeroes()
        for _, hero in ipairs(heroes) do
            local boss_rune = hero:FindModifierByName("modifier_boss_rune")
            self.boss_rune = GetChaticEra_BuffCardSpecial(self,"boss_rune",keys.level or 1)
            if boss_rune then
                boss_rune:SetStackCount(boss_rune:GetStackCount() + self.boss_rune) 
            end
        end
        for i = 1, taskCount, 1 do
            chaotic_era_spawner:InsertMonsterSpawn__WithID("id_ex1",insertKeys)
        end
        self:Destroy() 
    end
end

-- function modifier_undeath_legion:ADDeclareFunctions()
--     return 
--     {
-- 		advanced_MODIFIER_PROPERTY_Chaotic_Era_SpanSpeed,
--     }
-- end



-- function modifier_undeath_legion:Advanced_GetChaotic_Era_SpawnSpeedBonus()
-- 	return self.bonus
-- end
