------
---激励光环
creeps_spell_Commander = class({})

LinkLuaModifier("modifier_creeps_spell_Commander_passive", "creeps_spell/creeps_spell_Commander", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Commander_effect", "creeps_spell/creeps_spell_Commander", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Commander:GetIntrinsicModifierName() return "modifier_creeps_spell_Commander_passive" end

modifier_creeps_spell_Commander_passive = class({})

function modifier_creeps_spell_Commander_passive:IsHidden() return true end
function modifier_creeps_spell_Commander_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Commander_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Commander_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Commander_passive:IsAura() return true end
function modifier_creeps_spell_Commander_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Commander_passive:GetModifierAura() return "modifier_creeps_spell_Commander_effect" end
function modifier_creeps_spell_Commander_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Commander_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Commander_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Commander_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
modifier_creeps_spell_Commander_effect = advanced_modifier({})

function modifier_creeps_spell_Commander_effect:IsDebuff()			    return false end
function modifier_creeps_spell_Commander_effect:IsHidden() 			return false end
function modifier_creeps_spell_Commander_effect:IsPurgable() 		    return false end
function modifier_creeps_spell_Commander_effect:IsPurgeException() 	return false end

function modifier_creeps_spell_Commander_effect:DeclareFunctions() return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP,
    } 
end
function modifier_creeps_spell_Commander_effect:GetModifierMoveSpeedBonus_Percentage() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.move ==nil then
        return  30
    else 
        return self.move
    end
end
function modifier_creeps_spell_Commander_effect:GetModifierAttackSpeedBonus_Constant() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.attack_speed ==nil then
        return  40
    else 
        return self.attack_speed
    end
end
function modifier_creeps_spell_Commander_effect:GetModifierBaseDamageOutgoing_Percentage() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.attack ==nil then
        return  30
    else 
        return self.attack
    end
end
function modifier_creeps_spell_Commander_effect:AdvancedGetModifierConstantHealthRegen() 
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.health_Regeneration ==nil then
        return  100
    else 
        return self.health_Regeneration
    end
end






function modifier_creeps_spell_Commander_effect:OnCreated(table)
    if not IsServer() then
        return
    end
    self.move = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
    self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.health_Regeneration = self:GetAbility():GetSpecialValueFor("bonus_health_Regeneration")
end


function modifier_creeps_spell_Commander_effect:OnDestroy()
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    if caster:GetUnitName() ~= "npc_monster_wave_14_1" then
        return
    end
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, enemy in pairs(enemies) do
		if enemy:GetUnitName() == "npc_monster_wave_14_2" then
            local ability = enemy:AddAbility("creeps_spell_Commander")
            ability:SetLevel(1)
            return
        end
	end


end


function modifier_creeps_spell_Commander_effect:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_creeps_spell_Commander_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end
function modifier_creeps_spell_Commander_effect:Advanced_GetModifierPhysicalArmorBonus()
    
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    if self.armor ==nil then
        return  10
    else 
        return self.armor
    end
end