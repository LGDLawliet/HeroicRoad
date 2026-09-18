Middle_take_aim = class({})
-- LinkLuaModifier("modifier_Middle_take_aim_arua", "skills/Middle_take_aim", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_take_aim_arua_effect", "skills/Middle_take_aim", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_take_aim", "skills/Middle_take_aim", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function Middle_take_aim:GetIntrinsicModifierName()
	return "modifier_Middle_take_aim"
end




modifier_Middle_take_aim = advanced_modifier({})

function modifier_Middle_take_aim:IsDebuff() return false end
function modifier_Middle_take_aim:IsHidden() return false end
function modifier_Middle_take_aim:IsPurgable() 		return false end
function modifier_Middle_take_aim:IsPurgeException() 	return false end
function modifier_Middle_take_aim:RemoveOnDeath()  return false end



function modifier_Middle_take_aim:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	

end

function modifier_Middle_take_aim:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				
	}
end

function modifier_Middle_take_aim:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.ability:GetSpecialValueFor("bonus_attack_range") end
function modifier_Middle_take_aim:GetModifierPreAttack_BonusDamage() return self.ability:GetSpecialValueFor("bonus_damage") * self:GetStackCount() end



function modifier_Middle_take_aim:OnAttack(keys)
	if IsServer() then

		if keys.attacker == self:GetParent()then
			if self.nowtarget and keys.target==self.nowtarget  then
				if self:GetStackCount()<5 then
					self:IncrementStackCount()
				end
			else
				self.nowtarget=keys.target
				self:SetStackCount(math.max(self:GetStackCount()-2,0))

			end
			

		end
	end
end


function modifier_Middle_take_aim:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end
