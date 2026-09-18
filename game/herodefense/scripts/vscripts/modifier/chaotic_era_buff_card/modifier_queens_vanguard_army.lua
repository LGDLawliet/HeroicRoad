
modifier_queens_vanguard_army = advanced_modifier({})

function modifier_queens_vanguard_army:IsHidden()return false end
function modifier_queens_vanguard_army:IsDebuff()return false end
function modifier_queens_vanguard_army:IsPurgable()return false end
function modifier_queens_vanguard_army:IsPurgeException() 	return false end
function modifier_queens_vanguard_army:RemoveOnDeath() return true end
function modifier_queens_vanguard_army:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_queens_vanguard_army:GetTexture() return self.texture end

function modifier_queens_vanguard_army:OnCreated(keys)
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
            chaotic_era_spawner:InsertMonsterSpawn__WithID("id7",insertKeys)
        end
        self:Destroy() 
    end
end

-- function modifier_queens_vanguard_army:ADDeclareFunctions()
--     return 
--     {
-- 		advanced_MODIFIER_PROPERTY_Chaotic_Era_SpanSpeed,
--     }
-- end



-- function modifier_queens_vanguard_army:Advanced_GetChaotic_Era_SpawnSpeedBonus()
-- 	return self.bonus
-- end
