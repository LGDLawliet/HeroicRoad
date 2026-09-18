creeps_spell_Robbers = class({})

LinkLuaModifier("modifier_creeps_spell_Robbers", "creeps_spell/creeps_spell_Robbers", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Robbers:IsHiddenWhenStolen() 		return false end
function creeps_spell_Robbers:IsRefreshable() 			return true end
function creeps_spell_Robbers:IsStealable() 				return true end
function creeps_spell_Robbers:IsNetherWardStealable()		return true end
function creeps_spell_Robbers:GetIntrinsicModifierName() return "modifier_creeps_spell_Robbers" end



modifier_creeps_spell_Robbers = class({})

function modifier_creeps_spell_Robbers:IsDebuff()			return false end
function modifier_creeps_spell_Robbers:IsHidden() 			return true end
function modifier_creeps_spell_Robbers:IsPurgable() 		    return false end
function modifier_creeps_spell_Robbers:IsPurgeException() 	return false end
function modifier_creeps_spell_Robbers:RemoveOnDeath()       return false end



function modifier_creeps_spell_Robbers:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE,} end
    --_G.GAME_GOLDEN_DAMAGE定义在addon_game_mode了
function modifier_creeps_spell_Robbers:OnAttackLanded(keys)
   if not IsServer() then
       return 
   end
   if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() then
       return
   end
--    if not keys.target:IsHero() then
--        return
--    end
   if keys.damage<=0 then
        return
    end
    local target_unit = keys.target
    if not keys.target:IsRealHero() then
        local nPlayerID = keys.target:GetPlayerOwnerID()
        if not nPlayerID  then
            return
        end
        local player = PlayerResource:GetPlayer(nPlayerID)
        if player and PlayerResource:HasSelectedHero(nPlayerID) then
            target_unit = player:GetAssignedHero()
        else
            return
        end
    end
   local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus") * target_unit:GetGold()
   
   if bonus_damage > keys.attacker:GetBaseDamageMax() *3 then
    bonus_damage = keys.attacker:GetBaseDamageMax() *3
   end
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
    if bonus_damage > 50 then
        _G.GAME_GOLDEN_DAMAGE = _G.GAME_GOLDEN_DAMAGE + 4
    else
        _G.GAME_GOLDEN_DAMAGE = _G.GAME_GOLDEN_DAMAGE + 1 
    end
end


