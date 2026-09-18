creeps_spell_Overwhelm = class({})

LinkLuaModifier("modifier_creeps_spell_Overwhelm", "creeps_spell/creeps_spell_Overwhelm", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Overwhelm:IsHiddenWhenStolen() 		return false end
function creeps_spell_Overwhelm:IsRefreshable() 			return true end
function creeps_spell_Overwhelm:IsStealable() 				return true end
function creeps_spell_Overwhelm:IsNetherWardStealable()		return true end
function creeps_spell_Overwhelm:GetIntrinsicModifierName() return "modifier_creeps_spell_Overwhelm" end



modifier_creeps_spell_Overwhelm = class({})

function modifier_creeps_spell_Overwhelm:IsDebuff()			return false end
function modifier_creeps_spell_Overwhelm:IsHidden() 			return false end
function modifier_creeps_spell_Overwhelm:IsPurgable() 		    return false end
function modifier_creeps_spell_Overwhelm:IsPurgeException() 	return false end
function modifier_creeps_spell_Overwhelm:RemoveOnDeath()       return false end

function modifier_creeps_spell_Overwhelm:OnCreated()      
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end
function modifier_creeps_spell_Overwhelm:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:SetStackCount(_G.GAME_MONSTER_TABLE_number)
end

function modifier_creeps_spell_Overwhelm:OnTooltip()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus")
end

function modifier_creeps_spell_Overwhelm:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_TOOLTIP,} end
    --_G.GAME_MONSTER_TABLE_number定义在addon_game_mode了
function modifier_creeps_spell_Overwhelm:OnAttackLanded(keys)
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

   local bonus_damage = math.min(self:GetAbility():GetSpecialValueFor("bonus") * _G.GAME_MONSTER_TABLE_number, 2000)
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




