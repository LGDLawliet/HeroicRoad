LinkLuaModifier("modifier_iron_fog_goldmine_easy_buff", "modifier/chaotic_era_buff_card/modifier_iron_fog_goldmine_easy", LUA_MODIFIER_MOTION_NONE)
modifier_iron_fog_goldmine_easy = advanced_modifier({})

function modifier_iron_fog_goldmine_easy:IsHidden()return false end
function modifier_iron_fog_goldmine_easy:IsDebuff()return false end
function modifier_iron_fog_goldmine_easy:IsPurgable()return false end
function modifier_iron_fog_goldmine_easy:IsPurgeException() 	return false end
function modifier_iron_fog_goldmine_easy:RemoveOnDeath() return true end
function modifier_iron_fog_goldmine_easy:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_iron_fog_goldmine_easy:GetTexture() return self.texture end

function modifier_iron_fog_goldmine_easy:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.value2 = GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)
        self.bonus3 = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)

        self:SetStackCount(self.bonus3)

        self:StartIntervalThink(1)
        self.heroRecord = {}
        self.heroCount = 0

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

function modifier_iron_fog_goldmine_easy:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus,
        advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus,
    }
end

function modifier_iron_fog_goldmine_easy:Advanced_GetChaotic_Era_RunePorgressBonus()
	return self.value2
end

function modifier_iron_fog_goldmine_easy:Advanced_GetChaotic_Era_BountyBonus()
	return self.value1
end


function modifier_iron_fog_goldmine_easy:OnIntervalThink()
    local heroes = GetAllRealHeroes()
    for index, unit in ipairs(heroes) do
        if not self.heroRecord[unit] then
            local modifier = unit:AddNewModifier(unit, nil, "modifier_iron_fog_goldmine_easy_buff", {stack = self.bonus3})
            if modifier then
                self.heroRecord[unit] = true
                self.heroCount = self.heroCount + 1
            end
        end
        
    end
    if self.heroCount>=#heroes then
        self:StartIntervalThink(-1)
    end

end

modifier_iron_fog_goldmine_easy_buff = advanced_modifier({})

function modifier_iron_fog_goldmine_easy_buff:IsHidden()return true end
function modifier_iron_fog_goldmine_easy_buff:IsDebuff()return true end
function modifier_iron_fog_goldmine_easy_buff:IsPurgable()return false end
function modifier_iron_fog_goldmine_easy_buff:IsPurgeException() 	return false end
function modifier_iron_fog_goldmine_easy_buff:RemoveOnDeath() return false end
function modifier_iron_fog_goldmine_easy_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_iron_fog_goldmine_easy_buff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
        self:StartIntervalThink(1)
    end
end
function modifier_iron_fog_goldmine_easy_buff:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end

function modifier_iron_fog_goldmine_easy_buff:OnIntervalThink()
    if Game_State:IsInBattle() then
        chaotic_era_spawner:PlayerGetGoldBounty(self:GetParent(),self:GetStackCount(),nil) 
    end
end

-- function modifier_iron_fog_goldmine_easy_buff:ADDeclareFunctions()
--     return 
--     {
-- 		advanced_MODIFIER_PROPERTY_BONUS_ATTRIBUTE_LEVEL,
--     }
-- end


-- function modifier_iron_fog_goldmine_easy_buff:Advanced_GetModifierBonusAttributeLevel()
-- 	return -self:GetStackCount()
-- end

