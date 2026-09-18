Primary_Windrun = class({})
LinkLuaModifier("modifier_Primary_Windrun_buff", "skills/Primary_Windrun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Windrun_walk_motion", "skills/Primary_Windrun", LUA_MODIFIER_MOTION_NONE)


function Primary_Windrun:IsHiddenWhenStolen()         return false end
function Primary_Windrun:IsStealable()                return true end
function Primary_Windrun:IsNetherWardStealable()      return true end
function Primary_Windrun:IsRefreshable() 			    return true end
function Primary_Windrun:ProcsMagicStick() 			return true end
function Primary_Windrun:OnSpellStart() 			
    local caster=self:GetCaster()
    if caster:IsAlive() then
    EmitSoundOn("Ability.Windrun", caster)    
    local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.3)
    caster:AddNewModifier(caster, self, "modifier_Primary_Windrun_buff", {duration= self:GetSpecialValueFor("duration")*ModifierStatusGain}) 
    end
end

modifier_Primary_Windrun_buff = class({})

function modifier_Primary_Windrun_buff:IsBuff()                return true end
function modifier_Primary_Windrun_buff:IsPurgable() 			return false end
function modifier_Primary_Windrun_buff:IsPurgeException() 		return true end
function modifier_Primary_Windrun_buff:IsHidden()				return false end

function modifier_Primary_Windrun_buff:RemoveOnDeath() 	    return true end


function modifier_Primary_Windrun_buff:GetEffectName()         return "particles/new_effect/coup_de_grace/new_windrun_big.vpcf" end
function modifier_Primary_Windrun_buff:GetEffectAttachType()   return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Primary_Windrun_buff:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end
function modifier_Primary_Windrun_buff:GetModifierEvasion_Constant() return 90 end
function modifier_Primary_Windrun_buff:GetModifierMoveSpeedBonus_Percentage() return   self:GetAbility():GetSpecialValueFor("bonus_move_speed") end

----------------------------------------------------------------------------------------------------

