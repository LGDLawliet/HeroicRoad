-- 重做完成
item_hd_normal_amulet_effects = class({})
LinkLuaModifier("modifier_item_hd_normal_amulet_effects", "player_artifact/item_hd_normal_amulet_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_normal_amulet_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_normal_amulet_effects"
end
function item_hd_normal_amulet_effects:Precache( context )
    PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_death.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", context )
end

modifier_item_hd_normal_amulet_effects = advanced_modifier({})

function modifier_item_hd_normal_amulet_effects:IsDebuff() return false end
function modifier_item_hd_normal_amulet_effects:IsHidden() return true end
function modifier_item_hd_normal_amulet_effects:IsPurgable() return false end
function modifier_item_hd_normal_amulet_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.cd_line = self.ability:GetArtifactSpecialValueFor("cd_line")
    self.mana = self.ability:GetArtifactSpecialValueFor("mana")

    self.atb_1 = 0 
    self.mana_2 = self.ability:GetArtifactSpecialValueFor("mana_2")
    self.spell_amp_3 = self.ability:GetArtifactSpecialValueFor("spell_amp_3")
    self.interval_7 = self.ability:GetArtifactSpecialValueFor("interval_7")
    self.regen_7 = self.ability:GetArtifactSpecialValueFor("regen_7")*0.01
    self.interval_10 = self.ability:GetArtifactSpecialValueFor("interval_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_normal_amulet_effects")
    
    if self.level >= 100 then
        self.interval_7 = self.interval_10
    end
    if IsServer() then
        self:StartIntervalThink(self.interval_7)
    end
    if self.level >= 10 then
        self.atb_1 = self.ability:GetArtifactSpecialValueFor("atb_1") 
    end
    if self.level >= 20 then
       self.mana = self.mana_2 
    end
    if self.level >= 30 then
       self.bonus_spell_amp = self.bonus_spell_amp + self.spell_amp_3 
    end
    if self.level >= 40 then
        if not IsServer() then return end
        if self:GetParent():GetLevel() < 6 then return end
        if self:GetParent():HasAbility("chaotic_rune3_tir") then return end
        if not self.checkingAbility then
			local parent = self:GetParent()
			local maxSlotNumber = skillshop:GetMaxSpellCount(parent)
			if not parent:IsAlive() then
                return
            end
            if skillshop:GetPlayerAbilityNumber(parent) >= maxSlotNumber then
				return
			end
			self.checkingAbility = true
			if parent:HasModifier("modifier_chaotic_rune3_tir") then
				return
			end
			chaotic_era:LearnChaoticEraSpell(parent,"chaotic_rune3_tir")
		end
    end
    
end

function modifier_item_hd_normal_amulet_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.cd_line = self.ability:GetArtifactSpecialValueFor("cd_line")
    self.mana = self.ability:GetArtifactSpecialValueFor("mana")

    self.atb_1 = 0 
    self.mana_2 = self.ability:GetArtifactSpecialValueFor("mana_2")
    self.spell_amp_3 = self.ability:GetArtifactSpecialValueFor("spell_amp_3")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_normal_amulet_effects")
    self.interval_7 = self.ability:GetArtifactSpecialValueFor("interval_7")
    self.regen_7 = self.ability:GetArtifactSpecialValueFor("regen_7")*0.01

    if self.level >= 10 then
        self.atb_1 = self.ability:GetArtifactSpecialValueFor("atb_1") 
    end
    if self.level >= 20 then
       self.mana = self.mana_2 
    end
    if self.level >= 30 then
       self.bonus_spell_amp = self.bonus_spell_amp + self.spell_amp_3 
    end
end

function modifier_item_hd_normal_amulet_effects:OnIntervalThink()
    if self.level < 70 then return end
    if not self:GetParent():IsAlive() then return end
    local parent = self:GetParent()
    local hppct = parent:GetHealthPercent()
    local mppct = parent:GetManaPercent()
    local hplost_regen = (parent:GetMaxHealth() - parent:GetHealth())*self.regen_7
    local mplost_regen = (parent:GetMaxMana() - parent:GetMana())*self.regen_7
    if hppct <= mppct then
        parent:Heal(hplost_regen, self.ability)
        self.particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_death.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particle, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, hplost_regen, nil) 
    else
        parent:GiveMana(mplost_regen)
        self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particle, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, parent, mplost_regen, nil)
    end	
end

function modifier_item_hd_normal_amulet_effects:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end


function modifier_item_hd_normal_amulet_effects:OnAbilityExecuted(keys)  
    if IsServer() then
        local unit = keys.unit
        if keys.ability:GetCooldown(keys.ability:GetLevel()) <= self.cd_line or unit ~= self:GetParent() then
            return
        end
        unit:GiveMana(self.mana)
        if self.level >= 20  then
            unit:Heal(0.5*self.mana, self.ability)
        end

        if self.level >= 100 then
            unit:GiveMana(self.mana)
            unit:Heal(0.5*self.mana, self.ability)
        end
    end
end

function modifier_item_hd_normal_amulet_effects:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp 
end

function modifier_item_hd_normal_amulet_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_normal_amulet_effects:Advanced_GetModifierBonusStats_Strength()
    return self.atb_1
end
function modifier_item_hd_normal_amulet_effects:Advanced_GetModifierBonusStats_Agility()
    return self.atb_1
end 
function modifier_item_hd_normal_amulet_effects:Advanced_GetModifierBonusStats_Intellect()
    return self.atb_1
end
