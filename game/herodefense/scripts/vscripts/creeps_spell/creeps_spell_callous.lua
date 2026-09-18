creeps_spell_callous = class({})

LinkLuaModifier("modifier_creeps_spell_callous", "creeps_spell/creeps_spell_callous", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_callous_effect", "creeps_spell/creeps_spell_callous", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_callous_debuff", "creeps_spell/creeps_spell_callous", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_callous:IsHiddenWhenStolen() 		return false end
function creeps_spell_callous:IsRefreshable() 			return true end
function creeps_spell_callous:IsStealable() 				return true end
function creeps_spell_callous:IsNetherWardStealable()		return true end
function creeps_spell_callous:GetIntrinsicModifierName() return "modifier_creeps_spell_callous" end


function creeps_spell_callous:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    self:StartCooldown(self:GetCooldownTimeRemaining() + RandomInt(0, 5))
    local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)
    target:AddNewModifier(caster, self, "modifier_creeps_spell_callous_effect", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
	target:EmitSound("n_creep_OgreMagi.FrostArmor")
end


modifier_creeps_spell_callous = class({})

function modifier_creeps_spell_callous:IsDebuff()			return false end
function modifier_creeps_spell_callous:IsHidden() 			return true end
function modifier_creeps_spell_callous:IsPurgable() 		    return false end
function modifier_creeps_spell_callous:IsPurgeException() 	return false end
function modifier_creeps_spell_callous:RemoveOnDeath()       return false end
function modifier_creeps_spell_callous:GetStatusEffectName() return "particles/basic_extend/status_effect_onblue.vpcf" end
function modifier_creeps_spell_callous:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



modifier_creeps_spell_callous_effect = advanced_modifier({})

function modifier_creeps_spell_callous_effect:IsDebuff()			return false end
function modifier_creeps_spell_callous_effect:IsHidden() 			return false end
function modifier_creeps_spell_callous_effect:IsPurgable() 			return true end
function modifier_creeps_spell_callous_effect:IsPurgeException() 	return true end
function modifier_creeps_spell_callous_effect:GetEffectName() return "particles/new_effect/new_effect/ogre_magi_blue_shield_bubble.vpcf" end
function modifier_creeps_spell_callous_effect:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_creeps_spell_callous_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		

	}
end


function modifier_creeps_spell_callous_effect:OnTooltip()	
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end

function modifier_creeps_spell_callous_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_creeps_spell_callous_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return self.incoming
end

function modifier_creeps_spell_callous_effect:GetTexture()  return "ancient_apparition/shatterblast_crown/ancient_apparition_ice_blast" end

function modifier_creeps_spell_callous_effect:OnCreated(table)
    self.incoming = -self:GetAbility():GetSpecialValueFor("incoming")
    --性能优化：提高减伤，移除减速效果
    if IsServer() then
        
        self:StartIntervalThink(1)
    end
end

function modifier_creeps_spell_callous_effect:OnIntervalThink(table)
    if IsServer() then
       -- if self.radius == nil then
         --   self.radius = self:GetAbility():GetSpecialValueFor("radius")
           -- self.caster = self:GetAbility():GetCaster()
            --self.ability = self:GetAbility()
        --end
        local parent = self:GetParent()
        if not self:GetAbility() then
            return
        end
        --local enemies = FindUnitsInRadius( parent:GetTeamNumber(), parent:GetOrigin(), nil, self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        -- for _, enemy in pairs(enemies) do
        --    if enemy:IsMagicImmune()  then
        --        return
        --    end
        --    enemy:AddNewModifier(self.caster, self.ability, "modifier_creeps_spell_callous_debuff", {duration = 3})
        --end
        local heal = (parent:GetMaxHealth() - parent:GetHealth()) * self:GetAbility():GetSpecialValueFor("losehp_heal")*0.01
        local healing = HealWithGain(heal,self:GetCaster(),parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
    end
end

------------------------------------------------------------------------------------------------------------------------
modifier_creeps_spell_callous_debuff = advanced_modifier({})

function modifier_creeps_spell_callous_debuff:IsDebuff()			return true end
function modifier_creeps_spell_callous_debuff:IsHidden() 			return false end
function modifier_creeps_spell_callous_debuff:IsPurgable() 			return true end
function modifier_creeps_spell_callous_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_callous_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_creeps_spell_callous_debuff:GetTexture()  return "ancient_apparition/shatterblast_crown/ancient_apparition_ice_blast" end


function modifier_creeps_spell_callous_debuff:GetModifierMoveSpeedBonus_Percentage() 
    if self:GetAbility() ~= nil then
        return (0 - self:GetAbility():GetSpecialValueFor("move_slow"))
    else
        return -30
    end
end

function modifier_creeps_spell_callous_debuff:GetModifierAttackSpeedBonus_Constant() 
    if self:GetAbility() ~= nil then
        return (0 - self:GetAbility():GetSpecialValueFor("attack_slow"))
    else
        return -40
    end
end
