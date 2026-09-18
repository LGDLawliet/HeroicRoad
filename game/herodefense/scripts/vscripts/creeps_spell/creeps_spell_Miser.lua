creeps_spell_Miser = class({})

LinkLuaModifier("modifier_creeps_spell_Miser", "creeps_spell/creeps_spell_Miser", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Miser:IsHiddenWhenStolen() 		return false end
function creeps_spell_Miser:IsRefreshable() 			return true end
function creeps_spell_Miser:IsStealable() 				return true end
function creeps_spell_Miser:IsNetherWardStealable()		return true end
function creeps_spell_Miser:GetIntrinsicModifierName() return "modifier_creeps_spell_Miser" end



modifier_creeps_spell_Miser = class({})

function modifier_creeps_spell_Miser:IsDebuff()			return false end
function modifier_creeps_spell_Miser:IsHidden() 			return false end
function modifier_creeps_spell_Miser:IsPurgable() 		    return false end
function modifier_creeps_spell_Miser:IsPurgeException() 	return false end
function modifier_creeps_spell_Miser:RemoveOnDeath()       return false end

function modifier_creeps_spell_Miser:OnCreated()      
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end
function modifier_creeps_spell_Miser:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:SetStackCount(_G.GAME_GOLDEN_DAMAGE)
end

function modifier_creeps_spell_Miser:OnTooltip()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus")
end

function modifier_creeps_spell_Miser:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_TOOLTIP,} end
    --_G.GAME_GOLDEN_DAMAGE定义在addon_game_mode了
function modifier_creeps_spell_Miser:OnAttackLanded(keys)
   if not IsServer() then
       return 
   end
   if keys.attacker ~= self:GetParent() or self:GetParent():IsSilenced() or self:GetParent():IsIllusion() then
       return
   end
   if not keys.target:IsHero() or self:GetParent():PassivesDisabled() then
       return
   end
   if keys.damage<=0 then
    return
    end

   local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus") * _G.GAME_GOLDEN_DAMAGE
   local damageTable = {
    victim = keys.target,
    attacker = self:GetParent(),
    damage = bonus_damage,
    damage_type = self:GetAbility():GetAbilityDamageType(),
    damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
    ability = self:GetAbility(), --Optional.
    }
    ApplyDamage(damageTable)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE , keys.target, bonus_damage, nil)
end




