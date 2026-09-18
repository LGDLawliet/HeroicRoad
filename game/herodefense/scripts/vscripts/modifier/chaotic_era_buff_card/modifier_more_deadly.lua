
modifier_more_deadly = advanced_modifier({})

function modifier_more_deadly:IsHidden()return false end
function modifier_more_deadly:IsDebuff()return false end
function modifier_more_deadly:IsPurgable()return false end
function modifier_more_deadly:IsPurgeException() 	return false end
function modifier_more_deadly:RemoveOnDeath() return true end
function modifier_more_deadly:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_more_deadly:GetTexture() return self.texture end

function modifier_more_deadly:OnCreated(keys)
    if IsServer() then
        self.bonus1 = 1+GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)*0.01
        self.bonus2 = 1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01

        local heroes = GetAllRealHeroes()
        for _, hero in ipairs(heroes) do
            local boss_rune = hero:FindModifierByName("modifier_boss_rune")
            self.boss_rune = GetChaticEra_BuffCardSpecial(self,"boss_rune",keys.level or 1)
            if boss_rune then
                boss_rune:SetStackCount(boss_rune:GetStackCount() + self.boss_rune) 
            end
        end
    end
end


function modifier_more_deadly:ModifyTaskData(data)

    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        data.attribute.bonusHealth = data.attribute.bonusHealth*self.bonus1
        data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage*self.bonus1

        data.runeProgress.level1 = data.runeProgress.level1 *self.bonus2
        data.runeProgress.level2 = data.runeProgress.level2 *self.bonus2
        data.runeProgress.level3 = data.runeProgress.level3 *self.bonus2
        data.runeProgress.level4 = data.runeProgress.level4 *self.bonus2
        data.runeProgress.level5 = data.runeProgress.level5 *self.bonus2
    end

end