Middle_frost_arrows = class({})

LinkLuaModifier("modifier_Middle_frost_arrows_attack", "skills/Middle_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_frost_arrows_slow", "skills/Middle_frost_arrows", LUA_MODIFIER_MOTION_NONE)

function Middle_frost_arrows:GetIntrinsicModifierName()   return "modifier_Middle_frost_arrows_attack" end

modifier_Middle_frost_arrows_attack = advanced_modifier({})

function modifier_Middle_frost_arrows_attack:IsPassive()          return true end
function modifier_Middle_frost_arrows_attack:IsBuff()				return true end
function modifier_Middle_frost_arrows_attack:IsPurgable()     	return false end
function modifier_Middle_frost_arrows_attack:IsPurgeException() 	return false end
function modifier_Middle_frost_arrows_attack:IsHidden()			return true end
function modifier_Middle_frost_arrows_attack:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return  "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf" 
    end	
   
end 

function modifier_Middle_frost_arrows_attack:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.freezing = self.ability:GetSpecialValueFor("freezing")
end

function modifier_Middle_frost_arrows_attack:OnRefresh(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.freezing = self.ability:GetSpecialValueFor("freezing")
end

function modifier_Middle_frost_arrows_attack:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        -- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
	}
end

function modifier_Middle_frost_arrows_attack:ADDeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}
end

function modifier_Middle_frost_arrows_attack:OnAttackLanded(keys)
    if not IsServer() then return end  
	
	if not self.parent:IsRangedAttacker() or self.parent:PassivesDisabled() or not self.parent:IsAlive() or self.parent:IsIllusion() then return end
    local attacker = keys.attacker
    local target = keys.target
    if not target or not target:IsAlive() or target:IsMagicImmune() then return end

    local damagetable = {
        damage = self.damage*attacker:GetAverageTrueAttackDamage(nil),
        apply_damage_init = false, --在第一次施加时立即结算第一次伤害
        apply_damage_interval = 0.1, --伤害结算间隔
        ability = self.ability, --伤害来源
        attacker = attacker, --伤害来源
        damage_type = self.ability:GetAbilityDamageType(), --伤害类型
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --伤害标志
        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE, 
    }
    target:ApplyMergeDamage(damagetable)

    if not target:IsAlive() then return end
    local freezing = self.freezing*attacker:GetAverageTrueAttackDamage(nil)
    target:Freezing(attacker, self.ability, freezing)
    local duration = keys.target:GetHDStatusResistanceIndex(1)*attacker:GetModifierStatusNegativeGainIndex(1) * self.duration
    if duration > 0 then
        local debuff = target:FindModifierByName("modifier_Middle_frost_arrows_slow")
        if debuff then
            debuff:ForceRefresh()
            debuff:SetDuration(duration, true)
        else
            target:AddNewModifier(self.caster, self.ability, "modifier_Middle_frost_arrows_slow", {duration = duration}) 
        end
    end
end  


modifier_Middle_frost_arrows_slow = advanced_modifier({})
function modifier_Middle_frost_arrows_slow:IsDebuff()				return true  end
function modifier_Middle_frost_arrows_slow:IsPurgable() 			return true end
function modifier_Middle_frost_arrows_slow:IsPurgeException() 	    return true end
function modifier_Middle_frost_arrows_slow:IsHidden()				return false end
function modifier_Middle_frost_arrows_slow:OnCreated()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("move_slow")
end

function modifier_Middle_frost_arrows_slow:OnRefresh()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("move_slow")
end

function modifier_Middle_frost_arrows_slow:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    } 
end

function modifier_Middle_frost_arrows_slow:GetModifierMoveSpeedBonus_Constant() 
    if not self:GetAbility() then self:Destroy() return end
    return -self.slow 
end


