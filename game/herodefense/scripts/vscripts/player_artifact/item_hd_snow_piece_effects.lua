item_hd_snow_piece_effects = class({})
LinkLuaModifier("modifier_item_hd_snow_piece_effects", "player_artifact/item_hd_snow_piece_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_snow_piece_effects_lv40", "player_artifact/item_hd_snow_piece_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_snow_piece_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_snow_piece_effects"
end
function item_hd_snow_piece_effects:Precache( context )
    PrecacheResource("particle", "particles/rebuild/artifact/snow_piece/effect.vpcf", context)
end
modifier_item_hd_snow_piece_effects = advanced_modifier({})

function modifier_item_hd_snow_piece_effects:IsDebuff() return false end
function modifier_item_hd_snow_piece_effects:IsHidden() return true end
function modifier_item_hd_snow_piece_effects:IsPurgable() return false end
function modifier_item_hd_snow_piece_effects:RemoveOnDeath() return false end
function modifier_item_hd_snow_piece_effects:GetTexture() return "item_artifact_69" end
function modifier_item_hd_snow_piece_effects:DestroyOnExpire() return false end

function modifier_item_hd_snow_piece_effects:OnCreated()
    self.ability = self:GetAbility()
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.cd_reduce = self.ability:GetArtifactSpecialValueFor("cd_reduce")
    self.index = self.ability:GetArtifactSpecialValueFor("index")*0.01
    self.norefresh_index = self.ability:GetArtifactSpecialValueFor("norefresh_index")*0.01
    self.manacost_reduction = self.ability:GetArtifactSpecialValueFor("manacost_reduction")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_snow_piece_effects")
    
    -- Additional effects
    self.spell_1 = self.ability:GetArtifactSpecialValueFor("spell_1")
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")
    self.cd_reduce_2 = self.ability:GetArtifactSpecialValueFor("cd_reduce_2")*0.01
    self.cd_3 = self.ability:GetArtifactSpecialValueFor("cd_3")
    self.stack_3 = self.ability:GetArtifactSpecialValueFor("stack_3")
    self.line_4 = self.ability:GetArtifactSpecialValueFor("line_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.line_7 = self.ability:GetArtifactSpecialValueFor("line_7")
    
    self.total_cd_reduced = 0
    self.ice_spells_count = 0
    
    if self.level >= 70 then
       self.line_4 = self.line_7 
    end
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_item_hd_snow_piece_effects:OnRefresh()
    self.ability = self:GetAbility()
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.cd_reduce = self.ability:GetArtifactSpecialValueFor("cd_reduce")
    self.index = self.ability:GetArtifactSpecialValueFor("index")*0.01
    self.norefresh_index = self.ability:GetArtifactSpecialValueFor("norefresh_index")*0.01
    self.manacost_reduction = self.ability:GetArtifactSpecialValueFor("manacost_reduction")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_snow_piece_effects")
    
    -- Additional effects
    self.spell_1 = self.ability:GetArtifactSpecialValueFor("spell_1")
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")
    self.cd_reduce_2 = self.ability:GetArtifactSpecialValueFor("cd_reduce_2")*0.01
    self.cd_3 = self.ability:GetArtifactSpecialValueFor("cd_3")
    self.stack_3 = self.ability:GetArtifactSpecialValueFor("stack_3")
    self.line_4 = self.ability:GetArtifactSpecialValueFor("line_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.line_7 = self.ability:GetArtifactSpecialValueFor("line_7")
    if self.level >= 70 then
        self.line_4 = self.line_7 
     end
end

function modifier_item_hd_snow_piece_effects:OnIntervalThink()
    if not IsServer() then return end
    
    local parent = self:GetParent()
    local ice_num = GetIceSpellCount(parent)

    self.ice_spells_count = ice_num
    self:SetStackCount(self.ice_spells_count)
end

function modifier_item_hd_snow_piece_effects:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
    }
end

function modifier_item_hd_snow_piece_effects:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
    }
end

function modifier_item_hd_snow_piece_effects:GetModifierPercentageManacostStacking()
    return self.manacost_reduction
end

function modifier_item_hd_snow_piece_effects:OnAbilityFullyCast(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    local ability = keys.ability
    if ability:GetCooldown(ability:GetLevel()) <= 1 or ability:IsItem() or ability:IsToggle() then return end
    
    local parent = self:GetParent()
    local abilities = {}
    
    -- Find abilities with cooldown > line
    for i = 0, parent:GetAbilityCount() - 1 do
        local ability = parent:GetAbilityByIndex(i)
        if ability and ability:GetCooldownTimeRemaining() > self.line then
            -- 检查技能是否可用
            if not ability:IsCooldownReady() and not ability:IsHidden() then
                table.insert(abilities, ability)
            end
        end
    end
    
    if #abilities > 0 then
        local target_ability = abilities[math.random(1, #abilities)]
        local is_ice_spell = target_ability:IsIceSpell()
        local is_norefreshable = (not target_ability:IsRefreshable())
        local reduction = self.cd_reduce
        
        if self.level >= 30 then
            reduction = reduction + (self.cd_3 * self.ice_spells_count)
        end
        
        if is_ice_spell then
            reduction = reduction * self.index
        end

        if is_norefreshable then
            reduction = reduction * self.norefresh_index
        end
        
        
        local remaining_cd = target_ability:GetCooldownTimeRemaining()
        if remaining_cd > 0 then
            target_ability:EndCooldown()
            target_ability:StartCooldown(remaining_cd - reduction)
            --print("被减少冷却的技能为 " .. target_ability:GetName() .. "，由" .. remaining_cd .. "秒到" .. (remaining_cd - reduction))
        end

        if self.level >= 20 and target_ability:GetCooldownTimeRemaining() > self.line_2 then
            remaining_cd = target_ability:GetCooldownTimeRemaining()
            if remaining_cd > 0 then
                target_ability:EndCooldown()
                target_ability:StartCooldown(remaining_cd * (1-self.cd_reduce_2))
                --print("被LV30减少冷却的技能为" .. target_ability:GetName() .. "，由" .. remaining_cd .. "秒到" .. (remaining_cd * (1-self.cd_reduce_2)))
            end
        end
        
        -- Additional effect 4
        if self.level >= 40 then
            self.total_cd_reduced = self.total_cd_reduced + reduction
            if self.total_cd_reduced >= self.line_4 then
                local duration = self.duration_4
                if self.level >= 70 then
                    duration = duration*parent:GetModifierStatusNegativeGainIndex(1.2)
                end
                local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius_4, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                if #units >= 1 then
                    for _, unit in ipairs(units) do
                        unit:AddNewModifier(parent, self.ability, "modifier_item_hd_snow_piece_effects_lv40", {
                            duration = duration
                        })
                    end

                    local pfx2 = ParticleManager:CreateParticle("particles/rebuild/artifact/snow_piece/effect.vpcf", PATTACH_ABSORIGIN, parent)
                    ParticleManager:SetParticleControl(pfx2, 1, Vector(self.radius_4, 1, self.radius_4))
                    ParticleManager:ReleaseParticleIndex(pfx2)

                    self.total_cd_reduced = 0
                end
            end
        end
    end
end

function modifier_item_hd_snow_piece_effects:Advanced_GetModifierSpellAmplifyBonus()
    if self.level >= 10 then
        return self:GetStackCount()*self.spell_1
    end
    return 0
end

-- Level 40 freeze effect modifier
modifier_item_hd_snow_piece_effects_lv40 = advanced_modifier({})

function modifier_item_hd_snow_piece_effects_lv40:IsDebuff() return true end
function modifier_item_hd_snow_piece_effects_lv40:IsHidden() return false end
function modifier_item_hd_snow_piece_effects_lv40:IsPurgable() return true end
function modifier_item_hd_snow_piece_effects_lv40:GetTexture() return "item_artifact_69" end
function modifier_item_hd_snow_piece_effects_lv40:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_item_hd_snow_piece_effects_lv40:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_snow_piece_effects_lv40:OnCreated()
    self.ability = self:GetAbility()
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
end

function modifier_item_hd_snow_piece_effects_lv40:CheckState()
    return {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_item_hd_snow_piece_effects_lv40:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_hd_snow_piece_effects_lv40:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DISABLE_HEALING,
    }
end

function modifier_item_hd_snow_piece_effects_lv40:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.incoming_4
end

function modifier_item_hd_snow_piece_effects_lv40:GetDisableHealing()
    return 1
end
