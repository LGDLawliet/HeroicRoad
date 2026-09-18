
modifier_diviners_portent = advanced_modifier({})

function modifier_diviners_portent:IsHidden()return false end
function modifier_diviners_portent:IsDebuff()return false end
function modifier_diviners_portent:IsPurgable()return false end
function modifier_diviners_portent:IsPurgeException() 	return false end
function modifier_diviners_portent:RemoveOnDeath() return true end
function modifier_diviners_portent:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_diviners_portent:GetTexture() return self.texture end

function modifier_diviners_portent:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.value2 = GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)
        self.value3 = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)


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



function modifier_diviners_portent:OnChaoticEraRoundChange(keys)
    if Game_State:IsGameEnd() then
		-- 防止重复结算
		return
	end
	self.value1 = self.value1 - 1
    if self.value1<=0 then
        -- 结算符石
        local count  =self.value3
        local heroes = GetAllRealHeroes()
        for _, hero in ipairs(heroes) do
            for i = 1, count, 1 do
                local name = chaotic_era:GetRandomRune_BySpell(hero:GetPlayerOwnerID(),hero)
                if name then
                    print("插入")
                    chaotic_era_spawner:InsetSpellRune_HighPriority(hero:GetPlayerOwnerID(),name)
                end
                
            end
        end
       

        self:Destroy()
    end
end


function modifier_diviners_portent:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Chaotic_Era_AttackDamage_Percentage,
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
    }
end




function modifier_diviners_portent:Advanced_GetChaotic_Era_AttackDamage_Percentage()
	return self.bonus2
end
