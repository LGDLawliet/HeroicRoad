LinkLuaModifier("modifier_chaotic_flurry_of_blows", "chaotic_spell/class_1/chaotic_flurry_of_blows.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_qi", "chaotic_spell/class_1/chaotic_flurry_of_blows.lua", LUA_MODIFIER_MOTION_NONE)
--疾风连击
if chaotic_flurry_of_blows == nil then
    chaotic_flurry_of_blows = class({})
end

function chaotic_flurry_of_blows:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster, self, "modifier_chaotic_flurry_of_blows", {duration = duration})
end

if modifier_chaotic_flurry_of_blows == nil then
    modifier_chaotic_flurry_of_blows = class({})
end

function modifier_chaotic_flurry_of_blows:OnCreated(params)
    if IsServer() then
        self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    end
end

function modifier_chaotic_flurry_of_blows:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_flurry_of_blows:OnAttackLanded(params)
    if IsServer() then
        if self:GetParent():IsInSpecialAttack() then
            return
        end
        local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 1,
		}
        local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
        if params.attacker == self:GetParent() and params.target:IsAlive() then
            self:GetParent():PerformAttack(params.target, false, true, true, false, false, false, true)
            if math.random(1, 100) <= 50 and self:GetParent():HasModifier("modifier_chaotic_qi") then
                damage_table = {
                    attacker = self:GetParent(),
                    damage = self:GetParent():GetAttackDamage() * self:GetStackCount() * 0.1,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    victim = params.target
                }
                ApplyDamage(damage_table)
                self:GetParent():FindModifierByName("modifier_chaotic_qi"):DecrementStackCount()
            elseif math.random(1, 100) <= 25 then
                if self:GetParent():HasModifier("modifier_chaotic_qi") then
                    self:GetParent():FindModifierByName("modifier_chaotic_qi"):IncrementStackCount()
                else
                    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_qi", {stacks = 1})
                end
            end
            
        end
        if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
    end
end

function modifier_chaotic_flurry_of_blows:OnTooltip()
    return self.bonus_attack
end

function modifier_chaotic_flurry_of_blows:GetEffectName()
    return "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash.vpcf"
end

function modifier_chaotic_flurry_of_blows:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


-----------------------------------------------------
if modifier_chaotic_qi == nil then
    ---@type CDOTA_Modifier_Lua
    modifier_chaotic_qi = class({})
end

function modifier_chaotic_qi:OnCreated(params)
    self.flag = 0
    self.magic_resist = 0
    self.armor = 0
    self.mana_regen = 0
    self.health_regen = 0
    self.interval_count_max = 3
    if params.stacks then
        self:SetStackCount(params.stacks)
    else
        self:SetStackCount(1)
    end
    self:StartIntervalThink(1)
    self:SetHasCustomTransmitterData(true)
end

function modifier_chaotic_qi:AddCustomTransmitterData()
    return {
        mana_regen = self.mana_regen,
        health_regen = self.health_regen,
        interval_count = self.interval_count,
        mana_regen_final = self.mana_regen_final,
        health_regen_final = self.health_regen_final

    }
end
function modifier_chaotic_qi:HandleCustomTransmitterData(tData)
    self.mana_regen = tData.mana_regen
    self.health_regen = tData.health_regen
    self.interval_count = tData.interval_count
    self.mana_regen_final = tData.mana_regen_final
    self.health_regen_final = tData.health_regen_final
end

function modifier_chaotic_qi:OnIntervalThink()
    self.flag = 1
    if IsServer() then
        self.mana_regen = self:GetParent():GetManaRegen()
        self.health_regen = self:GetParent():GetHealthRegen()
    end
    self.flag = 0
    local mana_regen_increase = self.mana_regen * self:GetStackCount() * 0.01
    local health_regen_increase = self.health_regen * self:GetStackCount() * 0.02

    if self.mana_regen < self.health_regen * 1.2 then
        self.mana_regen_final = health_regen_increase
        self.magic_resist = self:GetStackCount() * 0.5
        self.mode = 1
    elseif self.health_regen < self.mana_regen * 1.2 then
        self.health_regen_final = mana_regen_increase
        self.armor = self:GetStackCount() * 0.5
        self.mode = 2
    else
        local all_regen = mana_regen_increase + health_regen_increase
        self.mana_regen_final = all_regen * 0.6
        self.mode = 3
    end

    if not self.interval_count then
        self.interval_count = 0
    end

    if IsServer() then
        self.interval_count = self.interval_count + 1

        if self.interval_count >= self.interval_count_max then
            if self.mode == 1 then
                self:GetParent():GiveMana(self.mana_regen_final)
            elseif self.mode == 2 then
                self:GetParent():Heal(self.health_regen_final, self:GetAbility())
            elseif self.mode == 3 then
                self:GetParent():Heal(self.health_regen_final, self:GetAbility())
                self:GetParent():GiveMana(self.mana_regen_final)
            end
            self.interval_count = 0
        end    
    end
end

function modifier_chaotic_qi:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_chaotic_qi:GetModifierMagicalResistanceBonus()
    if self.flag == 0 then
        return self.magic_resist
    else
        return 0
    end
end

function modifier_chaotic_qi:GetModifierPhysicalArmorBonus()
    if self.flag == 0 then
        return self.armor
    else
        return 0
    end
end
