-- 重写完成
item_hd_arcane_shard_effects = class({})
LinkLuaModifier("modifier_item_hd_arcane_shard_effects", "player_artifact/item_hd_arcane_shard_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_arcane_shard_effects_cd", "player_artifact/item_hd_arcane_shard_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_arcane_shard_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_shard_effects"
end
function item_hd_arcane_shard_effects:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/artifact/arcane_shard/maineffect.vpcf", context )
end
modifier_item_hd_arcane_shard_effects = advanced_modifier({})

function modifier_item_hd_arcane_shard_effects:IsDebuff() return false end
function modifier_item_hd_arcane_shard_effects:IsHidden() return self:GetRemainingTime() <= 0 end
function modifier_item_hd_arcane_shard_effects:IsPurgable() return false end
function modifier_item_hd_arcane_shard_effects:RemoveOnDeath() return false end
function modifier_item_hd_arcane_shard_effects:DestroyOnExpire() return false end
function modifier_item_hd_arcane_shard_effects:GetTexture() return "item_artifact_74" end
function modifier_item_hd_arcane_shard_effects:OnCreated(keys)
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.atb_1 = self.ability:GetArtifactSpecialValueFor("atb_1")
    self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
    self.spell_amp_2 = self.ability:GetArtifactSpecialValueFor("spell_amp_2")
    self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.outgoing_3 = self.ability:GetArtifactSpecialValueFor("outgoing_3")
    self.time_4 = self.ability:GetArtifactSpecialValueFor("time_4")
    self.magic_res_7 = self.ability:GetArtifactSpecialValueFor("magic_res_7")
    self.line_10 = self.ability:GetArtifactSpecialValueFor("line_10")
    self.spell_amp_10 = self.ability:GetArtifactSpecialValueFor("spell_amp_10")
    self.duration_10 = self.ability:GetArtifactSpecialValueFor("duration_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_arcane_shard_effects")


    if self.level >= 20 then
        self.bonus_spell_amp = self.bonus_spell_amp + self.spell_amp_2
    end
    if self.level >= 100 then
        self.line_3 = self.line_10
        self.bonus_spell_amp = self.bonus_spell_amp + self.spell_amp_10
    end
end

function modifier_item_hd_arcane_shard_effects:OnRefresh(keys)
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.atb_1 = self.ability:GetArtifactSpecialValueFor("atb_1")
    self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
    self.spell_amp_2 = self.ability:GetArtifactSpecialValueFor("spell_amp_2")
    self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.outgoing_3 = self.ability:GetArtifactSpecialValueFor("outgoing_3")
    self.time_4 = self.ability:GetArtifactSpecialValueFor("time_4")
    self.magic_res_7 = self.ability:GetArtifactSpecialValueFor("magic_res_7")
    self.line_10 = self.ability:GetArtifactSpecialValueFor("line_10")
    self.spell_amp_10 = self.ability:GetArtifactSpecialValueFor("spell_amp_10")
    self.duration_10 = self.ability:GetArtifactSpecialValueFor("duration_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_arcane_shard_effects")


    if self.level >= 20 then
        self.bonus_spell_amp = self.bonus_spell_amp + self.spell_amp_2
    end
    if self.level >= 100 then
        self.line_3 = self.line_10
        self.bonus_spell_amp = self.bonus_spell_amp + self.spell_amp_10
    end
end

function modifier_item_hd_arcane_shard_effects:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

    }
end

function modifier_item_hd_arcane_shard_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    local target = keys.target
    local damage_flags = keys.damage_flags
    local damage_category = keys.damage_category
    local outgoing = self.outgoing

    if not target or not IsEnemy(target,self.parent) then return end
    if damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
    if IsNotDirectDamage(keys) then return end
    local cd = target:FindModifierByName("modifier_item_hd_arcane_shard_effects_cd")
    if IsValid(cd) then return 0 end
    
    if self.level >= 10 then
        self:SetDuration(self.duration_1, true)
    end
    if self.level >= 30 and target:GetHealthPercent() >= self.line_3 then
        outgoing = self.outgoing_3
    end
    if self.level >= 100 then
        local keys = {
            -- IsBuff = true,迷宫那边的写法，破路没有
            duration = self.duration_10,
            BuffName = "modifier_stunned",
            caster = self.parent,
            target = target,
            ability = self.ability,
        }
        local duration = math.max(keys.duration * keys.target:GetHDStatusResistanceIndex(0.5),0.1)
        keys.target:AddNewModifier(keys.caster, keys.ability, keys.BuffName, {duration = duration})
    end
    local keys = {
        -- IsBuff = true,迷宫那边的写法，破路没有
        duration = self.level >= 40 and self.time_4 or -1,
        BuffName = "modifier_item_hd_arcane_shard_effects_cd",
        caster = self.parent,
        target = target,
        ability = self.ability,
    }
    keys.target:AddNewModifier(keys.caster, keys.ability, keys.BuffName, {duration = keys.duration})

    local particle = "particles/rebuild/artifact/arcane_shard/maineffect.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetOrigin(),true)
	ParticleManager:ReleaseParticleIndex(effect_cast)
    return outgoing
end
function modifier_item_hd_arcane_shard_effects:Advanced_GetModifierSpellAmplifyBonus() 
    return  self.bonus_spell_amp
end
function modifier_item_hd_arcane_shard_effects:Advanced_GetModifierBonusStats_Strength() 
    if self:GetRemainingTime() > 0 then
        return self.atb_1
    end
end
function modifier_item_hd_arcane_shard_effects:Advanced_GetModifierBonusStats_Agility() 
    if self:GetRemainingTime() > 0 then
        return self.atb_1
    end
end
function modifier_item_hd_arcane_shard_effects:Advanced_GetModifierBonusStats_Intellect() 
    if self:GetRemainingTime() > 0 then
        return self.atb_1
    end
end

-----
modifier_item_hd_arcane_shard_effects_cd = advanced_modifier({})

function modifier_item_hd_arcane_shard_effects_cd:IsDebuff() return true end
function modifier_item_hd_arcane_shard_effects_cd:IsHidden() return false end
function modifier_item_hd_arcane_shard_effects_cd:IsPurgable() return false end
function modifier_item_hd_arcane_shard_effects_cd:GetTexture() return "item_artifact_74" end
function modifier_item_hd_arcane_shard_effects_cd:OnCreated(keys)
    self.ability = self:GetAbility()
    self.magic_res_7 = self.ability:GetArtifactSpecialValueFor("magic_res_7")
    self.level  = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_arcane_shard_effects")
end

function modifier_item_hd_arcane_shard_effects_cd:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.magic_res_7 = self.ability:GetArtifactSpecialValueFor("magic_res_7")
    self.level  = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_arcane_shard_effects")
end

function modifier_item_hd_arcane_shard_effects_cd:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
    return funcs
end

function modifier_item_hd_arcane_shard_effects_cd:GetModifierMagicalResistanceBonus(keys)
    if not self:GetAbility() then self:Destroy() end
    if self.level < 70 then return 0 end
    return -self.magic_res_7
end