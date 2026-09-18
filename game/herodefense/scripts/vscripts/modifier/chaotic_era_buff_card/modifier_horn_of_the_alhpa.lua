
modifier_horn_of_the_alhpa = advanced_modifier({})

function modifier_horn_of_the_alhpa:IsHidden()return false end
function modifier_horn_of_the_alhpa:IsDebuff()return false end
function modifier_horn_of_the_alhpa:IsPurgable()return false end
function modifier_horn_of_the_alhpa:IsPurgeException() 	return false end
function modifier_horn_of_the_alhpa:RemoveOnDeath() return true end
function modifier_horn_of_the_alhpa:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_horn_of_the_alhpa:GetTexture() return self.texture end

function modifier_horn_of_the_alhpa:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        -- self.bonus = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local count =  GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local attribute =  GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01

        local insertKeys = {
            attribute_index = attribute,
            rune_progressIndex = attribute,
    
        }

        local heroes = GetAllRealHeroes()
        for _, hero in ipairs(heroes) do
            local boss_rune = hero:FindModifierByName("modifier_boss_rune")
            self.boss_rune = GetChaticEra_BuffCardSpecial(self,"boss_rune",keys.level or 1)
            if boss_rune then
                boss_rune:SetStackCount(boss_rune:GetStackCount() + self.boss_rune) 
            end
        end
        for i = 1, count, 1 do
            chaotic_era_spawner:InsertMonsterSpawn__WithID("id3",insertKeys)
        end
        self:Destroy() 
    end
end

-- function modifier_horn_of_the_alhpa:ADDeclareFunctions()
--     return 
--     {
-- 		advanced_MODIFIER_PROPERTY_Chaotic_Era_SpanSpeed,
--     }
-- end



-- function modifier_horn_of_the_alhpa:Advanced_GetChaotic_Era_SpawnSpeedBonus()
-- 	return self.bonus
-- end
