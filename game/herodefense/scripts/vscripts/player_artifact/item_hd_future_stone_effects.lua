-- 重做完成
item_hd_future_stone_effects = class({})
LinkLuaModifier("modifier_item_hd_future_stone_effects", "player_artifact/item_hd_future_stone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_future_stone_effects_debuff", "player_artifact/item_hd_future_stone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_future_stone_effects_buff", "player_artifact/item_hd_future_stone_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_future_stone_effects_lv100", "player_artifact/item_hd_future_stone_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_future_stone_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_future_stone_effects"
end

function item_hd_future_stone_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/future_stone/eff_all.vpcf", context )

end

modifier_item_hd_future_stone_effects = advanced_modifier({})

function modifier_item_hd_future_stone_effects:IsDebuff() return false end
function modifier_item_hd_future_stone_effects:IsHidden() return true end
function modifier_item_hd_future_stone_effects:IsPurgable() return false end
function modifier_item_hd_future_stone_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    local caster = self:GetCaster()
    self.bonus_vision = self.ability:GetArtifactSpecialValueFor("bonus_vision")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.level = GetArtifactLevel(caster:GetPlayerOwnerID(),"item_hd_future_stone_effects")
    self.radius = caster:GetCurrentVisionRange()

    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.insight_time = self.ability:GetArtifactSpecialValueFor("insight_time_2")
    self.insight_time_3 = self.ability:GetArtifactSpecialValueFor("insight_time_3")
    self.incoming_3 = self.ability:GetArtifactSpecialValueFor("incoming_3")
    self.bonus_10 = self.ability:GetArtifactSpecialValueFor("bonus_10")

    if self.level >= 40 and caster:GetLevel() >= 20 then 
        self:LearnInsight()
    end

    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_future_stone_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    local caster = self:GetCaster()
    self.bonus_vision = self.ability:GetArtifactSpecialValueFor("bonus_vision")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.level = GetArtifactLevel(caster:GetPlayerOwnerID(),"item_hd_future_stone_effects")
    self.radius = caster:GetCurrentVisionRange()

    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.insight_time = self.ability:GetArtifactSpecialValueFor("insight_time_2")
    self.insight_time_3 = self.ability:GetArtifactSpecialValueFor("insight_time_3")
    self.incoming_3 = self.ability:GetArtifactSpecialValueFor("incoming_3")
    self.bonus_10 = self.ability:GetArtifactSpecialValueFor("bonus_10")
end

function modifier_item_hd_future_stone_effects:LearnInsight()
    if not IsServer() then return end
    local caster = self:GetCaster()
    if not caster:IsLowAttackPriority() then return end
    if self.already then return end

    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    for _ , hero in pairs(heroes) do
        
        if hero ~= self:GetParent() then
            local insight = hero:HasModifier("modifier_chaotic_insight") or hero:HasModifier("modifier_chaotic_insight_bonus_buff")
            if not insight then
                self:Learn(hero)
            end
            break
        end
    end

    local insight_caster = caster:HasModifier("modifier_chaotic_insight") or caster:HasModifier("modifier_chaotic_insight_bonus_buff")
    if not insight_caster then
        self:Learn(caster)
    end

    self.already = true
end

function modifier_item_hd_future_stone_effects:PlayEffects(parent)
    local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_era/future_stone/eff_all.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
    ParticleManager:SetParticleControl(effect_cast,0,parent:GetOrigin() )
    ParticleManager:SetParticleControl(effect_cast,1,parent:GetOrigin() )
    ParticleManager:SetParticleControlEnt(effect_cast,3,parent,PATTACH_POINT_FOLLOW,nil,parent:GetAbsOrigin(),true)
    ParticleManager:SetParticleControlForward(effect_cast, 3, parent:GetForwardVector())
    DestroyParticleByDelay(effect_cast,1.5)
    parent:EmitSound("CNY_Beast.HandOfGodHealHero")
end

function modifier_item_hd_future_stone_effects:Learn(unit)
    local parent = unit
    local maxSlotNumber = skillshop:GetMaxSpellCount(parent)
    if not parent:IsAlive() then
        return
    end
    if skillshop:GetPlayerAbilityNumber(parent) >= maxSlotNumber then
        return
    end
    chaotic_era:LearnChaoticEraSpell(parent,"chaotic_insight")
end

function modifier_item_hd_future_stone_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BONUS_VISION,
    }
end

function modifier_item_hd_future_stone_effects:Advanced_GetBonusVision()
    return self.bonus_vision 
end

function modifier_item_hd_future_stone_effects:OnIntervalThink()
    local caster = self:GetCaster()
    if self.level >= 30 and caster:IsLowAttackPriority() then
        self.insight_time = self.insight_time_3
        self.incoming = self.incoming_3
    end

    if self.level >= 10 then
        local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
        for _ , hero in ipairs(heroes) do
            if hero ~= caster and not hero:HasModifier("modifier_item_hd_future_stone_effects_buff") then
                hero:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_future_stone_effects_buff",{stack = self.incoming_1}) 
                self:PlayEffects(hero)
            end

            if self.level >= 20 then
                if self.level < 70 then
                    if hero ~= caster then
                        local modifier = hero:FindModifierByName("modifier_chaotic_insight")
                        if modifier then           
                            local time = math.max(modifier:GetRemainingTime() - self.insight_time, 0.03)
                            --local time = Clamp(modifier:GetRemainingTime() - self.insight_time, 0, modifier:GetRemainingTime()) 
                            modifier:SetDuration(time, true)
                            self:PlayEffects(hero)
                        end
                    end
                else
                    local modifier = hero:FindModifierByName("modifier_chaotic_insight")
                    if modifier then              
                        local time = math.max(modifier:GetRemainingTime() - self.insight_time, 0.03)
                        modifier:SetDuration(time, true)
                        self:PlayEffects(hero)
                    end
                end
            end
        end
    end

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for i , enemy in pairs(enemies) do
        enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_future_stone_effects_debuff",{stack = self.incoming}) 
        self:PlayEffects(enemy)

        i = i + 1 
        if i >= self.max then
            break
        end

    end
end
-----------------------------
modifier_item_hd_future_stone_effects_debuff = advanced_modifier({})
function modifier_item_hd_future_stone_effects_debuff:IsDebuff() return true end
function modifier_item_hd_future_stone_effects_debuff:IsHidden() return false end
function modifier_item_hd_future_stone_effects_debuff:IsPurgable() return false end
    function modifier_item_hd_future_stone_effects_debuff:GetTexture() return "item_artifact_23" end
function modifier_item_hd_future_stone_effects_debuff:OnCreated(keys)
    if IsServer() then
       self.stack = keys.stack or 0
       self:SetStackCount(self.stack)
    end
end
function modifier_item_hd_future_stone_effects_debuff:OnRefresh(keys)
    if IsServer() then
       self.stack = keys.stack or 0
       self:SetStackCount(self.stack)
    end
end
function modifier_item_hd_future_stone_effects_debuff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_future_stone_effects_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then
        self:Destroy()
        return
    end
    return self:GetStackCount()
end
------------------------------------
modifier_item_hd_future_stone_effects_buff = advanced_modifier({})
function modifier_item_hd_future_stone_effects_buff:IsDebuff() return false end
function modifier_item_hd_future_stone_effects_buff:IsHidden() return false end
function modifier_item_hd_future_stone_effects_buff:IsPurgable() return false end
function modifier_item_hd_future_stone_effects_buff:GetTexture() return "item_artifact_23" end
function modifier_item_hd_future_stone_effects_buff:OnCreated(keys)
    if IsServer() then
       self.stack = keys.stack or 0
       self:SetStackCount(self.stack)
    end
end
function modifier_item_hd_future_stone_effects_buff:OnRefresh(keys)
    if IsServer() then
       self.stack = keys.stack or 0
       self:SetStackCount(self.stack)
    end
end
function modifier_item_hd_future_stone_effects_buff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_future_stone_effects_buff:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then
        self:Destroy()
        return
    end
    return -self:GetStackCount()
end

------------------------------------
modifier_item_hd_future_stone_effects_lv100 = advanced_modifier({})
function modifier_item_hd_future_stone_effects_lv100:IsDebuff() return false end
function modifier_item_hd_future_stone_effects_lv100:IsHidden() return false end
function modifier_item_hd_future_stone_effects_lv100:IsPurgable() return false end
function modifier_item_hd_future_stone_effects_lv100:RemoveOnDeath() return false end
function modifier_item_hd_future_stone_effects_lv100:GetTexture() return "item_artifact_23" end

function modifier_item_hd_future_stone_effects_lv100:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_future_stone_effects_lv100:Advanced_GetModifier_TalentEffectGain()
    return self:GetStackCount() or 25
end
function modifier_item_hd_future_stone_effects_lv100:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self:GetStackCount() or 25
end