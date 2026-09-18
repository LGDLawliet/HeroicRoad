item_hd_song_shield_effects = class({})
LinkLuaModifier("modifier_item_hd_song_shield_effects", "player_artifact/item_hd_song_shield_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_song_shield_effects_fire", "player_artifact/item_hd_song_shield_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_song_shield_effects_fire_lv20", "player_artifact/item_hd_song_shield_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_song_shield_effects_fire_lv40", "player_artifact/item_hd_song_shield_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_song_shield_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_song_shield_effects"
end

function item_hd_song_shield_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/dragon_knight/dk_2022_immortal/dk_2022_immortal_dragon_tail_dragon.vpcf", context )
end
-------------------------------------------------------------------
modifier_item_hd_song_shield_effects = advanced_modifier({})

function modifier_item_hd_song_shield_effects:IsDebuff() return false end
function modifier_item_hd_song_shield_effects:IsHidden() return true end
function modifier_item_hd_song_shield_effects:IsPurgable() return false end

function modifier_item_hd_song_shield_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.armor = self.ability:GetArtifactSpecialValueFor("armor")
    self.magic_res = self.ability:GetArtifactSpecialValueFor("magic_res")
    self.bonus_health = self.ability:GetArtifactSpecialValueFor("bonus_health")
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")
    self.move_2 = self.ability:GetArtifactSpecialValueFor("move_2")
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.armor_3 = self.ability:GetArtifactSpecialValueFor("armor_3")
    self.magic_res_3 = self.ability:GetArtifactSpecialValueFor("magic_res_3")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.armor_4 = self.ability:GetArtifactSpecialValueFor("armor_4")
    self.magic_res_4 = self.ability:GetArtifactSpecialValueFor("magic_res_4")
    self.status_7 = self.ability:GetArtifactSpecialValueFor("status_7")
    self.armor_10 = self.ability:GetArtifactSpecialValueFor("armor_10")
    self.magic_res_10 = self.ability:GetArtifactSpecialValueFor("magic_res_10")
    
    self.armor_final = 0
    self.magic_res_final = 0
    self.incoming_final = 0

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_song_shield_effects")
    self:StartIntervalThink(0.5)

    if self.level >= 100 then
        self.armor_3 = self.armor_10
        self.magic_res_3 = self.magic_res_10
    end
end

function modifier_item_hd_song_shield_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.armor = self.ability:GetArtifactSpecialValueFor("armor")
    self.magic_res = self.ability:GetArtifactSpecialValueFor("magic_res")
    self.bonus_health = self.ability:GetArtifactSpecialValueFor("bonus_health")
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")
    self.move_2 = self.ability:GetArtifactSpecialValueFor("move_2")
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.armor_3 = self.ability:GetArtifactSpecialValueFor("armor_3")
    self.magic_res_3 = self.ability:GetArtifactSpecialValueFor("magic_res_3")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.armor_4 = self.ability:GetArtifactSpecialValueFor("armor_4")
    self.magic_res_4 = self.ability:GetArtifactSpecialValueFor("magic_res_4")
    self.status_7 = self.ability:GetArtifactSpecialValueFor("status_7")
    self.armor_10 = self.ability:GetArtifactSpecialValueFor("armor_10")
    self.magic_res_10 = self.ability:GetArtifactSpecialValueFor("magic_res_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_song_shield_effects")

    if self.level >= 100 then
        self.armor_3 = self.armor_10
        self.magic_res_3 = self.magic_res_10
    end
end

function modifier_item_hd_song_shield_effects:OnIntervalThink()
    local losthp = (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())/self:GetParent():GetMaxHealth()--在0.01~0.99之间
    self.armor_final = self.armor*losthp
    self.magic_res_final = self.magic_res*losthp
    self.incoming_final = 0
    
    if self.level >= 10 then
        self.incoming_final = self.incoming_final + self.incoming_1
    end

    if (self.level >= 20 and self:GetParent():GetHealthPercent() < self.line_2) or self.level >= 100 then
        self.trigger = true
        self.incoming_final = self.incoming_final + self.incoming_2
    else
        self.trigger = nil
    end

    if self.level >= 30 then
       self.armor_final = math.max(self.armor_final , self.armor_3) 
       self.magic_res_final = math.max(self.magic_res_final , self.magic_res_3)
    end
    
    if self.level >= 40 then 
        local stone = self:GetParent():HasModifier("modifier_chaotic_stoneskin")
        local aid = self:GetParent():HasModifier("modifier_chaotic_aid")
        if (stone and not aid) or (aid and not stone) then 
            self:SetStackCount(1)
        end
        if stone and aid then
            self:SetStackCount(2)
        end
        if not stone and not aid then
            self:SetStackCount(0)
            self.armor_final = self.armor_final + self.armor_4
            self.magic_res_final = self.magic_res_final + self.magic_res_4
        end
    else
        self:SetStackCount(0)
    end

    self.incoming_final = self.incoming_final + self.incoming_4*self:GetStackCount()
end

function modifier_item_hd_song_shield_effects:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_hd_song_shield_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_StatusResistance
    }
end

function modifier_item_hd_song_shield_effects:Advanced_GetModifierIncomingDamage_Percentage()
    
    return  -self.incoming_final
end
function modifier_item_hd_song_shield_effects:AdvancedGetModifierHealthBonus()
    return  self.bonus_health
end
function modifier_item_hd_song_shield_effects:Advanced_GetModifierPhysicalArmorBonus()
    return  self.armor_final
end
function modifier_item_hd_song_shield_effects:GetModifierMagicalResistanceBonus()
    return  self.magic_res_final
end
function modifier_item_hd_song_shield_effects:Advanced_GetModifier_StatusResistance()
    return  self.status_7
end
function modifier_item_hd_song_shield_effects:GetModifierMoveSpeedBonus_Percentage()
    if self.trigger then
        return  self.move_2
    end
    return 
end

