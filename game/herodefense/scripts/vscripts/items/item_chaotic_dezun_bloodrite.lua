LinkLuaModifier("modifier_item_chaotic_dezun_bloodrite_active", "items/item_chaotic_dezun_bloodrite", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_dezun_bloodrite_debuff", "items/item_chaotic_dezun_bloodrite", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_dezun_bloodrite_passive", "items/item_chaotic_dezun_bloodrite", LUA_MODIFIER_MOTION_NONE)

item_chaotic_dezun_bloodrite = item_chaotic_dezun_bloodrite or class({})

function item_chaotic_dezun_bloodrite:GetIntrinsicModifierName()
    return "modifier_item_chaotic_dezun_bloodrite_passive"
end
function item_chaotic_dezun_bloodrite:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", context)
end
function item_chaotic_dezun_bloodrite:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end
function item_chaotic_dezun_bloodrite:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end
function item_chaotic_dezun_bloodrite:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
    if caster:HasModifier("modifier_item_chaotic_dezun_bloodrite_active") then
        caster:RemoveModifierByName("modifier_item_chaotic_dezun_bloodrite_active")
    else
        caster:AddNewModifier(caster, self, "modifier_item_chaotic_dezun_bloodrite_active", {})
        local sound_cast = "Hero_Bloodseeker.Rupture"
        EmitSoundOn(sound_cast, caster)
    end
end

---
modifier_item_chaotic_dezun_bloodrite_passive = advanced_modifier({})

function modifier_item_chaotic_dezun_bloodrite_passive:IsHidden() return true end
function modifier_item_chaotic_dezun_bloodrite_passive:IsPurgable() return false end
function modifier_item_chaotic_dezun_bloodrite_passive:RemoveOnDeath() return false end

function modifier_item_chaotic_dezun_bloodrite_passive:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
    self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
    self.hp_threshold = self.ability:GetSpecialValueFor("line")  -- 使用line参数匹配本地化文件
end

function modifier_item_chaotic_dezun_bloodrite_passive:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_chaotic_dezun_bloodrite_passive:Advanced_GetModifierSpellAmplifyBonus()
    local spell_amp = self.bonus_spell_amp
    local parent = self:GetParent()
    if parent:GetHealthPercent() >= self.hp_threshold then
        spell_amp = self.bonus_spell_amp + self.spell_amp
    end
    return spell_amp
end
----
modifier_item_chaotic_dezun_bloodrite_active = advanced_modifier({})

function modifier_item_chaotic_dezun_bloodrite_active:IsHidden() return false end
function modifier_item_chaotic_dezun_bloodrite_active:IsPurgable() return false end
function modifier_item_chaotic_dezun_bloodrite_active:RemoveOnDeath() return true end
function modifier_item_chaotic_dezun_bloodrite_active:GetTexture() return "item_dezun_bloodrite" end
function modifier_item_chaotic_dezun_bloodrite_active:GetEffectName() return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf" end
function modifier_item_chaotic_dezun_bloodrite_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_chaotic_dezun_bloodrite_active:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.hp_cost = self.ability:GetSpecialValueFor("hp_cost")*0.01
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.think_interval = 1.0
    if IsServer() then
        self:StartIntervalThink(self.think_interval)
        self:OnIntervalThink()
    end
end

function modifier_item_chaotic_dezun_bloodrite_active:OnIntervalThink()
    if not self:GetAbility() or not self.parent:IsAlive() then self:Destroy() return end
    self.parent:ModifyHealth(self.parent:GetHealth()*(1-self.hp_cost), self.ability, false, 0)
end

function modifier_item_chaotic_dezun_bloodrite_active:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_item_chaotic_dezun_bloodrite_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(params)
    if IsServer() then
        local attacker = params.attacker
        local target = params.target
        
        if attacker == self.parent and target and target:IsAlive() and not target:IsMagicImmune() then
            local modifier = target:FindModifierByName("modifier_item_chaotic_dezun_bloodrite_debuff")
            if modifier then
                modifier:ForceRefresh()
                modifier:SetDuration(self.duration, true)
            else
                target:AddNewModifier(attacker, self.ability, "modifier_item_chaotic_dezun_bloodrite_debuff", {duration = self.duration})
            end
        end
        return 0
    end
end


modifier_item_chaotic_dezun_bloodrite_debuff = advanced_modifier({})

function modifier_item_chaotic_dezun_bloodrite_debuff:IsDebuff() return true end
function modifier_item_chaotic_dezun_bloodrite_debuff:IsHidden() return false end
function modifier_item_chaotic_dezun_bloodrite_debuff:IsPurgable() return false end
function modifier_item_chaotic_dezun_bloodrite_debuff:GetTexture() return "item_dezun_bloodrite" end

function modifier_item_chaotic_dezun_bloodrite_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.magicres_down = self.ability:GetSpecialValueFor("magicres_down")
end

function modifier_item_chaotic_dezun_bloodrite_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_item_chaotic_dezun_bloodrite_debuff:GetModifierMagicalResistanceBonus()
    if not self:GetAbility() then self:Destroy() return end
    return -self.magicres_down
end