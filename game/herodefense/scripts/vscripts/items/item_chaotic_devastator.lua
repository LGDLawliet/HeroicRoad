LinkLuaModifier("modifier_item_chaotic_devastator_passive", "items/item_chaotic_devastator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_devastator_debuff", "items/item_chaotic_devastator", LUA_MODIFIER_MOTION_NONE)

item_chaotic_devastator = class({})

function item_chaotic_devastator:GetIntrinsicModifierName()
	return "modifier_item_chaotic_devastator_passive"
end
-- 
modifier_item_chaotic_devastator_passive = advanced_modifier({})
function modifier_item_chaotic_devastator_passive:IsHidden() return true end
function modifier_item_chaotic_devastator_passive:IsPurgable() return false end
function modifier_item_chaotic_devastator_passive:RemoveOnDeath() return false end
function modifier_item_chaotic_devastator_passive:OnCreated()
	self.caster = self:GetParent()
    self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
    self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.line = self.ability:GetSpecialValueFor("line")
	self.poison = self.ability:GetSpecialValueFor("poison")
	self.magicres_down = self.ability:GetSpecialValueFor("magicres_down")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.index = self.ability:GetSpecialValueFor("index")*0.01
end
function modifier_item_chaotic_devastator_passive:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
	return funcs
end
function modifier_item_chaotic_devastator_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end
function modifier_item_chaotic_devastator_passive:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_amp
end
function modifier_item_chaotic_devastator_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack
end
function modifier_item_chaotic_devastator_passive:CheckState()  
    local funcs = {}
    if self.ability:IsCooldownReady() then
        funcs = {
            [MODIFIER_STATE_CANNOT_MISS] = true
        }
    else
        funcs = {}
    end
	return funcs
end

function modifier_item_chaotic_devastator_passive:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if attacker ~= self.parent then return end
    if not target or not target:IsAlive() or target:IsMagicImmune() then return end

	
    if self.ability:IsCooldownReady() and not attacker:IsInSpecialAttack() then
        self.ability:UseResources(true, true, true, true)
        local poison = attacker:HDGetPrimaryStatValue() * self.poison
        if target:GetHealthPercent() >= self.line then
            local spell_amp = attacker:GetSpellAmplification(false)
            if spell_amp>0 then
                poison = poison * (1+spell_amp*self.index)
            end
            target:Poison(attacker, self.ability, poison)
        end
    end

    local ModifierStatusNegativeGain = attacker:GetModifierStatusNegativeGainIndex(0.5)
    local StatusResistance = target:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
	local duration = self.duration*StatusResistance
	local debuff = target:FindModifierByName("modifier_item_chaotic_devastator_debuff")
	if debuff then
        debuff:ForceRefresh()
		debuff:SetDuration(duration, true)
	else
		target:AddNewModifier(attacker, self.ability, "modifier_item_chaotic_devastator_debuff", {duration = duration})
	end
end
-- 法力腐蚀debuff
modifier_item_chaotic_devastator_debuff = advanced_modifier({})

function modifier_item_chaotic_devastator_debuff:IsDebuff() return true end
function modifier_item_chaotic_devastator_debuff:IsHidden() return false end
function modifier_item_chaotic_devastator_debuff:IsPurgable() return false end
function modifier_item_chaotic_devastator_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.magicres_down = self.ability:GetSpecialValueFor("magicres_down")
end
function modifier_item_chaotic_devastator_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_item_chaotic_devastator_debuff:GetModifierMagicalResistanceBonus()
    if not self:GetAbility() then self:Destroy() return end
	return -self.magicres_down
end