LinkLuaModifier("modifier_Primary_Untouchable", "skills/Primary_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Untouchable_slow", "skills/Primary_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Untouchable_spell_slow", "skills/Primary_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Untouchable_slow_stack", "skills/Primary_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Untouchable_Count", "skills/Primary_Untouchable", LUA_MODIFIER_MOTION_NONE)

Primary_Untouchable				= class({})


function Primary_Untouchable:GetIntrinsicModifierName() 
	return "modifier_Primary_Untouchable"
end

require("internal/timers")
--------------------------
-- UNTOUCHABLE MODIFIER --
--------------------------

modifier_Primary_Untouchable		= class({})

function modifier_Primary_Untouchable:IsHidden()		return true end
function modifier_Primary_Untouchable:IsPurgable() 		return false end
function modifier_Primary_Untouchable:IsPurgeException() 	return false end
function modifier_Primary_Untouchable:RemoveOnDeath()  return false end

function modifier_Primary_Untouchable:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
end



function modifier_Primary_Untouchable:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end




function modifier_Primary_Untouchable:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    if self.parent == keys.target and not self.parent:PassivesDisabled() and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then
        if keys.attacker:IsMagicImmune() then
            return
        end
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_Primary_Untouchable_slow", {})
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_Primary_Untouchable_slow_stack", {duration = 20})
    end
end



modifier_Primary_Untouchable_slow	= class({})


function modifier_Primary_Untouchable_slow:IsDebuff()			return true end
function modifier_Primary_Untouchable_slow:IsHidden() 			return true end
function modifier_Primary_Untouchable_slow:IsPurgable() 		  return false end
function modifier_Primary_Untouchable_slow:IsPurgeException() 	return false end
function modifier_Primary_Untouchable_slow:OnCreated()
    if not IsServer() then
        return
    end
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
   
	-- AbilitySpecials
	self.slow_attack_speed 			= -self.ability:GetSpecialValueFor("attack_slow")
	--self.slow_duration 			= self.ability:GetSpecialValueFor("slow_duration")

    local buffs = self.parent:FindAllModifiersByName("modifier_Primary_Untouchable_slow_stack")
    local stack = 1
    if #buffs>0 then
        stack = stack + buffs[1]:GetStackCount()*0.01
    end
	self.slow_attack_speed = self.slow_attack_speed *stack
    self:SetStackCount(self.slow_attack_speed)
end

function modifier_Primary_Untouchable_slow:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_Primary_Untouchable_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_enchantress_untouchable.vpcf"
end

function modifier_Primary_Untouchable_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_Primary_Untouchable_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

-- After the attack is complete, remove the slow after a short delay
function modifier_Primary_Untouchable_slow:OnAttack(keys)
	if self.parent == keys.attacker then
		-- Wait frame time to check if the target is not Enchantress or if she was not killed to properly apply Regret stacks
		Timers:CreateTimer(FrameTime(), function()
			if (keys.target ~= self.caster or self.caster:IsAlive()) and self and not self:IsNull() then
				if self:GetStackCount() > 1 then
					self:DecrementStackCount()
				else 
					self:SetDuration(keys.attacker:GetAttackAnimationPoint(), false) 
				end
			end
		end)
	end
end

modifier_Primary_Untouchable_slow_stack	= class({})


function modifier_Primary_Untouchable_slow_stack:IsDebuff()			return true end
function modifier_Primary_Untouchable_slow_stack:IsHidden() 			return false end
function modifier_Primary_Untouchable_slow_stack:IsPurgable() 		    return false end
function modifier_Primary_Untouchable_slow_stack:IsPurgeException() 	return false end
function modifier_Primary_Untouchable_slow_stack:OnRefresh(table)
    self:IncrementStackCount()
end



modifier_Primary_Untouchable_spell_slow	= class({})


function modifier_Primary_Untouchable_spell_slow:IsDebuff()			return true end
function modifier_Primary_Untouchable_spell_slow:IsHidden() 			return false end
function modifier_Primary_Untouchable_spell_slow:IsPurgable() 		    return false end
function modifier_Primary_Untouchable_spell_slow:IsPurgeException() 	return false end
function modifier_Primary_Untouchable_spell_slow:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_Primary_Untouchable_spell_slow:OnRefresh(table)
--     self:IncrementStackCount()
-- end

-- function modifier_Primary_Untouchable_spell_slow:DeclareFunctions()
--     return {
--         MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
--     }
-- end

function modifier_Primary_Untouchable_spell_slow:GetModifierPercentageCasttime()
    return -50
end



modifier_Primary_Untouchable_Count = class({})

function modifier_Primary_Untouchable_Count:IsDebuff()				return false end
function modifier_Primary_Untouchable_Count:IsHidden() 				return true end
function modifier_Primary_Untouchable_Count:IsPurgable() 			return false end
function modifier_Primary_Untouchable_Count:IsPurgeException() 		return false end
function modifier_Primary_Untouchable_Count:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Untouchable_Count:RemoveOnDeath() return true end

function modifier_Primary_Untouchable_Count:OnCreated()

    self.parent = self:GetParent()


    self:StartIntervalThink(1)

end

function modifier_Primary_Untouchable_Count:OnIntervalThink()
    if not IsServer() then
        return
    end
    local heal = self:GetStackCount() *0.03
    if heal<6 then
        -- print("destroy")
        self:SafeDestroy()
    end
    
    self.parent:Heal(heal, self.parent)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.parent, heal, nil) 
end