
modifier_base_attack_damage_bonus = class({})

function modifier_base_attack_damage_bonus:IsDebuff()			return false end
function modifier_base_attack_damage_bonus:IsHidden() 			return true end
function modifier_base_attack_damage_bonus:IsPurgable() 		return false end
function modifier_base_attack_damage_bonus:IsPurgeException() 	return false end
function modifier_base_attack_damage_bonus:RemoveOnDeath() return false end
function modifier_base_attack_damage_bonus:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	} 
	
	return funcs

end
function modifier_base_attack_damage_bonus:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+keys.stack)
    end
end
function modifier_base_attack_damage_bonus:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+keys.stack)
    end
end


function modifier_base_attack_damage_bonus:GetModifierBaseAttack_BonusDamage() return self:GetStackCount() end
