
modifier_super_normal = advanced_modifier({})

function modifier_super_normal:IsHidden()return false end
function modifier_super_normal:IsDebuff()return false end
function modifier_super_normal:IsPurgable()return false end
function modifier_super_normal:IsPurgeException() 	return false end
function modifier_super_normal:RemoveOnDeath() return true end
function modifier_super_normal:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_super_normal:GetTexture() return self.texture end

function modifier_super_normal:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.bonus1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.bonus2 = 1+GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)*0.01
        self.bonus3 = 1+GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)*0.01

    end
end


function modifier_super_normal:ModifyTaskData(data)
    -- print("处理符石")
    local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
    if kv then
        if kv.interval<=self.bonus1 then
            data.attribute.bonusHealth = data.attribute.bonusHealth*self.bonus2
            data.attribute.bonusAttackDamage = data.attribute.bonusAttackDamage*self.bonus2
            data.runeProgress.level2 = data.runeProgress.level2 *self.bonus3
        end
    end
	-- runeProgress = {
    --     level1 = value.RuneProgress_1 or 0,
    --     level2 = value.RuneProgress_2 or 0,
    --     level3 = value.RuneProgress_3 or 0,
    --     level4 = value.RuneProgress_4 or 0,
    --     level5 = value.RuneProgress_5 or 0,
        
    -- },

    -- level3获得加成 数值等于 level1的百分比
    -- data.runeProgress.level3 = data.runeProgress.level3 + data.runeProgress.level1*self.bonus3
    -- 不需要返回 因为data指向原来的地址
end


