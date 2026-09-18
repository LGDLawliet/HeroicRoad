--重做完成
item_hd_holy_staff_effects = class({})
LinkLuaModifier("modifier_item_hd_holy_staff_effects", "player_artifact/item_hd_holy_staff_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_staff_effects_buff", "player_artifact/item_hd_holy_staff_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_staff_effects_lv100", "player_artifact/item_hd_holy_staff_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_holy_staff_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_holy_staff_effects"
end

function item_hd_holy_staff_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context )
end

modifier_item_hd_holy_staff_effects = advanced_modifier({})

function modifier_item_hd_holy_staff_effects:IsDebuff() return false end
function modifier_item_hd_holy_staff_effects:IsHidden() return true end
function modifier_item_hd_holy_staff_effects:IsPurgable() return false end
function modifier_item_hd_holy_staff_effects:GetTexture() return "item_artifact_27" end
function modifier_item_hd_holy_staff_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    
    self.bonus_all_attribute = self.ability:GetArtifactSpecialValueFor("bonus_all_attribute")
    self.ass_atb = self.ability:GetArtifactSpecialValueFor("ass_atb")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.atb = self.ability:GetArtifactSpecialValueFor("atb")
    self.atb_index = self.ability:GetArtifactSpecialValueFor("atb_index")*0.01

    self.cost_get_1 = self.ability:GetArtifactSpecialValueFor("cost_get_1")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_holy_staff_effects")
    if self.level >= 10 then
        self.interval = self.ability:GetArtifactSpecialValueFor("interval_1")
    end
    self.class = self:GetParent():HasModifier("modifier_item_chaotic_class_ass")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_holy_staff_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    
    self.bonus_all_attribute = self.ability:GetArtifactSpecialValueFor("bonus_all_attribute")
    self.ass_atb = self.ability:GetArtifactSpecialValueFor("ass_atb")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.atb = self.ability:GetArtifactSpecialValueFor("atb")
    self.atb_index = self.ability:GetArtifactSpecialValueFor("atb_index")*0.01

    self.cost_get_1 = self.ability:GetArtifactSpecialValueFor("cost_get_1")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_holy_staff_effects")
    self.class = self:GetParent():HasModifier("modifier_item_chaotic_class_ass")
end

function modifier_item_hd_holy_staff_effects:CheckState()
    if self.level >=40 and self:GetParent():HasModifier("modifier_item_chaotic_class_ass") then
        return{[MODIFIER_STATE_LOW_ATTACK_PRIORITY]=true,}
    end
    return
end

function modifier_item_hd_holy_staff_effects:OnIntervalThink()
    local atb = self.atb
    if self:GetParent():HasModifier("modifier_item_chaotic_class_ass") then
       atb = atb* (1+self.atb_index)
    end
    local particle_aoe = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
    local heroes = GetAllRealHeroes()
    for _,hero in pairs(heroes) do
        hero:AddNewModifier(self:GetCaster(), self.ability, "modifier_item_hd_holy_staff_effects_buff", {stack = atb})
        if self.level >= 10 then
           hero:AddNewModifier(self:GetCaster(),self.ability,"modifier_hd_trigger",{cost_get = self.cost_get_1}) 
        end
        if self.level >= 100 then
            hero:AddNewModifier(self:GetCaster(),self.ability,"modifier_item_hd_holy_staff_effects_lv100",{stack = atb})
        end

        local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControl(particle_aoe_fx, 0, hero:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(300, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_aoe_fx)    
    end
end

function modifier_item_hd_holy_staff_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_holy_staff_effects:Advanced_GetModifierBonusStats_Strength()
    local atb = self.bonus_all_attribute
    if self.class then
        atb  = atb + self.ass_atb
    end
    return atb
end
function modifier_item_hd_holy_staff_effects:Advanced_GetModifierBonusStats_Agility()
    local atb = self.bonus_all_attribute
    if self.class then
        atb  = atb + self.ass_atb
    end
    return atb
end
function modifier_item_hd_holy_staff_effects:Advanced_GetModifierBonusStats_Intellect()
    local atb = self.bonus_all_attribute
    if self.class then
        atb  = atb + self.ass_atb
    end
    return atb
end
---------------------------------------------

modifier_item_hd_holy_staff_effects_buff = advanced_modifier({})

function modifier_item_hd_holy_staff_effects_buff:IsDebuff() return false end
function modifier_item_hd_holy_staff_effects_buff:IsHidden() return false end
function modifier_item_hd_holy_staff_effects_buff:IsPurgable() return false end
function modifier_item_hd_holy_staff_effects_buff:RemoveOnDeath() return false end
function modifier_item_hd_holy_staff_effects_buff:GetTexture() return "item_artifact_27" end

function modifier_item_hd_holy_staff_effects_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    self.atb_max = self:GetAbility():GetSpecialValueFor("atb_max")
    self.atb_max_7 = self:GetAbility():GetSpecialValueFor("atb_max_7")
    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_holy_staff_effects")

    if self.level >= 70 then
       self.atb_max = self.atb_max_7 
    end
    if IsServer() then
       self.stack = keys.stack or 1 
       self:SetStackCount(math.min(self:GetStackCount()+self.stack ,self.atb_max))
    end
end
function modifier_item_hd_holy_staff_effects_buff:OnRefresh(keys)
    if not self:GetAbility() then return end
    self.atb_max = self:GetAbility():GetSpecialValueFor("atb_max")
    self.atb_max_7 = self:GetAbility():GetSpecialValueFor("atb_max_7")
    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_holy_staff_effects")

    if self.level >= 70 then
       self.atb_max = self.atb_max_7 
    end
    if IsServer() then
       self.stack = keys.stack or 1 
       self:SetStackCount(math.min(self:GetStackCount()+self.stack ,self.atb_max))
    end
end

function modifier_item_hd_holy_staff_effects_buff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_holy_staff_effects_buff:Advanced_GetModifierBonusStats_Strength()
    return self:GetStackCount()
end
function modifier_item_hd_holy_staff_effects_buff:Advanced_GetModifierBonusStats_Agility()
    return self:GetStackCount()
end
function modifier_item_hd_holy_staff_effects_buff:Advanced_GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end

---------------------------------------------

modifier_item_hd_holy_staff_effects_lv100 = advanced_modifier({})

function modifier_item_hd_holy_staff_effects_lv100:IsDebuff() return false end
function modifier_item_hd_holy_staff_effects_lv100:IsHidden() return false end
function modifier_item_hd_holy_staff_effects_lv100:IsPurgable() return false end
function modifier_item_hd_holy_staff_effects_lv100:RemoveOnDeath() return false end
function modifier_item_hd_holy_staff_effects_lv100:GetTexture() return "item_artifact_27" end

function modifier_item_hd_holy_staff_effects_lv100:OnCreated(keys)
    if not self:GetAbility() then return end
    self.profic_10 = self:GetAbility():GetSpecialValueFor("profic_10")
    self.profic_max_10 = self:GetAbility():GetSpecialValueFor("profic_max_10")

    if IsServer() then
       self.stack = keys.stack or 1 
       self:SetStackCount(math.min(self:GetStackCount()+self.stack ,self.profic_max_10))
    end
end
function modifier_item_hd_holy_staff_effects_lv100:OnRefresh(keys)
    if not self:GetAbility() then return end
    self.profic_10 = self:GetAbility():GetSpecialValueFor("profic_10")
    self.profic_max_10 = self:GetAbility():GetSpecialValueFor("profic_max_10")

    if IsServer() then
       self.stack = keys.stack or 1 
       self:SetStackCount(math.min(self:GetStackCount()+self.stack ,self.profic_max_10))
    end
end

function modifier_item_hd_holy_staff_effects_lv100:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
    }
    return funcs
end
function modifier_item_hd_holy_staff_effects_lv100:Advanced_GetModifier_TalentEffectGain()
    return self:GetStackCount()
end
