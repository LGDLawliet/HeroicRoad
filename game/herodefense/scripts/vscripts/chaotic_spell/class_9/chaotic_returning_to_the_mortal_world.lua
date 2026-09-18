chaotic_returning_to_the_mortal_world = class({})
LinkLuaModifier("modifier_chaotic_returning_to_the_mortal_world", "chaotic_spell/class_9/chaotic_returning_to_the_mortal_world", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_returning_to_the_mortal_world_buff", "chaotic_spell/class_9/chaotic_returning_to_the_mortal_world", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_returning_to_the_mortal_world_debuff", "chaotic_spell/class_9/chaotic_returning_to_the_mortal_world", LUA_MODIFIER_MOTION_NONE)



function chaotic_returning_to_the_mortal_world:GetIntrinsicModifierName() return "modifier_chaotic_returning_to_the_mortal_world" end

function chaotic_returning_to_the_mortal_world:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_returning_to_the_mortal_world/effect_pos/effect_defense.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_returning_to_the_mortal_world/buff/pangolier_ti8_immortal_shield_buff.vpcf", context )
end
function chaotic_returning_to_the_mortal_world:IsSpellCanBeSell()
    return false
end
modifier_chaotic_returning_to_the_mortal_world = advanced_modifier({})

function modifier_chaotic_returning_to_the_mortal_world:IsDebuff()			return false end
function modifier_chaotic_returning_to_the_mortal_world:IsHidden() 		return false end
function modifier_chaotic_returning_to_the_mortal_world:IsPurgable() 		return false end
function modifier_chaotic_returning_to_the_mortal_world:IsPurgeException() return false end

function modifier_chaotic_returning_to_the_mortal_world:ADDeclareFunctions()
    return 
    {
        MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
    }
end

function modifier_chaotic_returning_to_the_mortal_world:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.respawn_chance =  math.floor(self.ability:GetSpecialValueFor("respawn_chance"))
    if IsServer() then
        self:SetStackCount(self.respawn_chance)
    end
end




function modifier_chaotic_returning_to_the_mortal_world:AdvancedGetModifierReincarnate(keys)
	if self:GetStackCount()>=1 then
		local data = {
			modifier = self,
			time = 1,
			priority = 1000,
			invulnerable_time = 2,
		}
		return data
    else
        local caster = self:GetCaster()
        if self:GetAbility():GetRuneType()==1 then
            return nil
        end
        if not caster:HasModifier("modifier_chaotic_returning_to_the_mortal_world_debuff") then
            caster:RemoveModifierByName("modifier_chaotic_returning_to_the_mortal_world_buff")
            caster:SetHealth(1)
            caster:AddNewModifier(caster, self:GetAbility(), "modifier_chaotic_returning_to_the_mortal_world_debuff", {})
            caster:SetHealth(0) 
        end
	end

	return nil
	
end

function modifier_chaotic_returning_to_the_mortal_world:OnReincarnateTrigger(keys)
	self:DecrementStackCount()
    local caster = self:GetCaster()
    caster:SetHealth(1)
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_chaotic_returning_to_the_mortal_world_buff", {})
    caster:SetHealth(0)



end




function modifier_chaotic_returning_to_the_mortal_world:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_returning_to_the_mortal_world:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

    if self._tooltip == 1 then
        if self:GetStackCount() > self.respawn_chance then
            return 0
        end
        return self:GetStackCount()
    end

end











modifier_chaotic_returning_to_the_mortal_world_buff = advanced_modifier({})

function modifier_chaotic_returning_to_the_mortal_world_buff:IsDebuff()			return false end
function modifier_chaotic_returning_to_the_mortal_world_buff:IsHidden() 		return false end
function modifier_chaotic_returning_to_the_mortal_world_buff:IsPurgable() 		return false end
function modifier_chaotic_returning_to_the_mortal_world_buff:IsPurgeException() return false end
function modifier_chaotic_returning_to_the_mortal_world_buff:RemoveOnDeath() return false end
function modifier_chaotic_returning_to_the_mortal_world_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_chaotic_returning_to_the_mortal_world_buff:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.respawn_chance =  math.floor(self.ability:GetSpecialValueFor("respawn_chance"))
    self.bonus_all_attribute =  self.ability:GetSpecialValueFor("bonus_all_attribute")
    self.bonus_attack_damage =  self.ability:GetSpecialValueFor("bonus_attack_damage")
    self.damage_reduction =  -self.ability:GetSpecialValueFor("damage_reduction")
    self.total_damage =  self.ability:GetSpecialValueFor("total_damage")
    if IsServer() then
        self:IncrementStackCount()
    end

end

function modifier_chaotic_returning_to_the_mortal_world_buff:OnRefresh()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.respawn_chance =  math.floor(self.ability:GetSpecialValueFor("respawn_chance"))
    self.bonus_all_attribute =  self.ability:GetSpecialValueFor("bonus_all_attribute")
    self.bonus_attack_damage =  self.ability:GetSpecialValueFor("bonus_attack_damage")
    self.damage_reduction =  -self.ability:GetSpecialValueFor("damage_reduction")
    self.total_damage =  self.ability:GetSpecialValueFor("total_damage")
    if IsServer() then
        self:IncrementStackCount()
    end

end

function modifier_chaotic_returning_to_the_mortal_world_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if self:GetStackCount() >=self.respawn_chance then
        return self.damage_reduction
    end
    return 0
end




function modifier_chaotic_returning_to_the_mortal_world_buff:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus_all_attribute * self:GetStackCount()
end
function modifier_chaotic_returning_to_the_mortal_world_buff:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus_all_attribute * self:GetStackCount()
end
function modifier_chaotic_returning_to_the_mortal_world_buff:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus_all_attribute * self:GetStackCount()
end

function modifier_chaotic_returning_to_the_mortal_world_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if self:GetStackCount() >= self.respawn_chance then
        return self.total_damage
    end
	return 0
end

function modifier_chaotic_returning_to_the_mortal_world_buff:Advanced_GetModifierBaseAttack_BonusDamage()
	return self.bonus_attack_damage * self:GetStackCount()
end

function modifier_chaotic_returning_to_the_mortal_world_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_returning_to_the_mortal_world_buff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 4 + 1

    if self._tooltip == 1 then
        return self.bonus_all_attribute * self:GetStackCount()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierBaseAttack_BonusDamage()
    end   
    if self._tooltip == 3 then
        return self:Advanced_GetModifierIncomingDamage_Percentage()
    end 
    if self._tooltip == 4 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    end               
    
end








modifier_chaotic_returning_to_the_mortal_world_debuff = advanced_modifier({})

function modifier_chaotic_returning_to_the_mortal_world_debuff:IsDebuff()			return true end
function modifier_chaotic_returning_to_the_mortal_world_debuff:IsHidden() 		return false end
function modifier_chaotic_returning_to_the_mortal_world_debuff:IsPurgable() 		return false end
function modifier_chaotic_returning_to_the_mortal_world_debuff:IsPurgeException() return false end
function modifier_chaotic_returning_to_the_mortal_world_debuff:RemoveOnDeath() return false end
function modifier_chaotic_returning_to_the_mortal_world_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_chaotic_returning_to_the_mortal_world_debuff:OnCreated()
    self.all_attribute_reduction =  -self:GetAbility():GetSpecialValueFor("all_attribute_reduction")
end


function modifier_chaotic_returning_to_the_mortal_world_debuff:Advanced_GetModifierBonusStats_Strength()	
	return self.all_attribute_reduction 
end
function modifier_chaotic_returning_to_the_mortal_world_debuff:Advanced_GetModifierBonusStats_Agility()	
	return self.all_attribute_reduction 
end
function modifier_chaotic_returning_to_the_mortal_world_debuff:Advanced_GetModifierBonusStats_Intellect()	
	return self.all_attribute_reduction 
end


function modifier_chaotic_returning_to_the_mortal_world_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_returning_to_the_mortal_world_debuff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

    if self._tooltip == 1 then
        return self.all_attribute_reduction
    end               
    
end