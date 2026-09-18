
modifier_continuous_stream_of_trees = advanced_modifier({})

function modifier_continuous_stream_of_trees:IsHidden()return false end
function modifier_continuous_stream_of_trees:IsDebuff()return false end
function modifier_continuous_stream_of_trees:IsPurgable()return false end
function modifier_continuous_stream_of_trees:IsPurgeException() 	return false end
function modifier_continuous_stream_of_trees:RemoveOnDeath() return true end
function modifier_continuous_stream_of_trees:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_continuous_stream_of_trees:GetTexture() return self.texture end

function modifier_continuous_stream_of_trees:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        -- self.bonus = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local count =  GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local attribute =  GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        local rune =  GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

        local insertKeys = {
            attribute_index = attribute,
            rune_progressIndex = rune,
    
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
            chaotic_era_spawner:InsertMonsterSpawn__WithID("id18",insertKeys)
        end
        self:Destroy() 
    end
end



--每过回合征召怪物cy
-- function modifier_continuous_stream_of_trees:ADDeclareFunctions()
--     return 
--     {
--         MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
--     }
-- end



-- function modifier_continuous_stream_of_trees:OnChaoticEraRoundChange(keys)
-- 	if keys.round>=self.wave then
--         self:DecrementStackCount()
--         if self:GetStackCount()<=0 then
--             self:SetStackCount(self.wave_require)
            
--             local insertKeys = {
--                 attribute_index = self.value1,
--                 rune_progressIndex = self.value2,
        
--             }
--             chaotic_era_spawner:InsertMonsterSpawn__WithID("id18",insertKeys)

--         end
--     end
-- end
