
modifier_undeath_legion_hard = advanced_modifier({})

function modifier_undeath_legion_hard:IsHidden()return false end
function modifier_undeath_legion_hard:IsDebuff()return false end
function modifier_undeath_legion_hard:IsPurgable()return false end
function modifier_undeath_legion_hard:IsPurgeException() 	return false end
function modifier_undeath_legion_hard:RemoveOnDeath() return true end
function modifier_undeath_legion_hard:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_undeath_legion_hard:GetTexture() return self.texture end

function modifier_undeath_legion_hard:OnCreated(keys)
    if IsServer() then

        local taskCount = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        local count =  GetChaticEra_BuffCardSpecial(self,"count",keys.level or 1)
        local attribute =  GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        local bonus_rune = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

        local insertKeys = {
            attribute_index = attribute,
            rune_progressIndex = bonus_rune,
            overrideCount = count,
        }
        for i = 1, taskCount, 1 do
            chaotic_era_spawner:InsertMonsterSpawn__WithID("id_ex1",insertKeys)
        end

    end
end
