item_hd_ballista = class({})

LinkLuaModifier("modifier_item_hd_ballista", "items/item_hd_ballista", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ballista_active", "items/item_hd_ballista", LUA_MODIFIER_MOTION_NONE)


function item_hd_ballista:GetIntrinsicModifierName()
	return "modifier_item_hd_ballista"
end




modifier_item_hd_ballista = advanced_modifier({})

function modifier_item_hd_ballista:IsDebuff() return false end
function modifier_item_hd_ballista:IsHidden() return true end
function modifier_item_hd_ballista:IsPurgable() 		return false end
function modifier_item_hd_ballista:IsPurgeException() 	return false end
function modifier_item_hd_ballista:RemoveOnDeath()  return false end



function modifier_item_hd_ballista:OnCreated(keys)
    self.ability = self:GetAbility()


	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
end

function modifier_item_hd_ballista:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算


	}
end

function modifier_item_hd_ballista:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_ballista:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.bonus_attack_range or 0 end




function modifier_item_hd_ballista:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.attacker:IsInSpecialAttack() then
			if self:GetStackCount()>=5 then
				keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_ballista_active", {duration = 0.1})
				self:SetStackCount(0)
			else
				self:IncrementStackCount()
			end
		end
	end
end


function modifier_item_hd_ballista:OnDamageCalculated(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			if self:GetStackCount()==0 then
				local modifier = keys.target:FindAllModifiersByName("modifier_item_hd_ballista_active")
				if #modifier>0 then
					modifier[1]:Destroy()
				end
			end

		end
	end
end


function modifier_item_hd_ballista:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end


modifier_item_hd_ballista_active = advanced_modifier({})

function modifier_item_hd_ballista_active:IsDebuff() return true end
function modifier_item_hd_ballista_active:IsHidden() return true end
function modifier_item_hd_ballista_active:IsPurgable() return false end


function modifier_item_hd_ballista_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_ballista_active:Advanced_GetModifierPhysicalArmorBonus()
    return -999
end
