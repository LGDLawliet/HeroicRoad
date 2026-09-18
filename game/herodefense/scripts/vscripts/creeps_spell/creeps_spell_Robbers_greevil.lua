creeps_spell_Robbers_greevil = class({})

LinkLuaModifier("modifier_creeps_spell_Robbers_greevil", "creeps_spell/creeps_spell_Robbers_greevil", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Robbers_greevil:IsHiddenWhenStolen() 		return false end
function creeps_spell_Robbers_greevil:IsRefreshable() 			return true end
function creeps_spell_Robbers_greevil:IsStealable() 				return true end
function creeps_spell_Robbers_greevil:IsNetherWardStealable()		return true end
function creeps_spell_Robbers_greevil:GetIntrinsicModifierName() return "modifier_creeps_spell_Robbers_greevil" end



modifier_creeps_spell_Robbers_greevil = class({})

function modifier_creeps_spell_Robbers_greevil:IsDebuff()			return false end
function modifier_creeps_spell_Robbers_greevil:IsHidden() 			return true end
function modifier_creeps_spell_Robbers_greevil:IsPurgable() 		    return false end
function modifier_creeps_spell_Robbers_greevil:IsPurgeException() 	return false end
function modifier_creeps_spell_Robbers_greevil:RemoveOnDeath()       return false end



function modifier_creeps_spell_Robbers_greevil:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
} end

function modifier_creeps_spell_Robbers_greevil:OnAttackLanded(keys)
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
    local gold = -math.max(target_unit:GetGold()*0.001,1)
   target_unit:ModifyGoldFiltered(gold,true,DOTA_ModifyGold_Buyback  )  --金币奖励
   target_unit:EmitSound("Miniboss_Greevil.PreAttack")
end


