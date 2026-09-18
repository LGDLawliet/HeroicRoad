LinkLuaModifier("modifier_creeps_spell_Inviolability", "creeps_spell/creeps_spell_Inviolability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Inviolability_slow", "creeps_spell/creeps_spell_Inviolability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Inviolability_spell_slow", "creeps_spell/creeps_spell_Inviolability", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Inviolability_slow_stack", "creeps_spell/creeps_spell_Inviolability", LUA_MODIFIER_MOTION_NONE)

creeps_spell_Inviolability				= class({})

function creeps_spell_Inviolability:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

function creeps_spell_Inviolability:GetIntrinsicModifierName() 
	return "modifier_creeps_spell_Inviolability"
end

require("internal/timers")
--------------------------
-- UNTOUCHABLE MODIFIER --
--------------------------

modifier_creeps_spell_Inviolability		= class({})

function modifier_creeps_spell_Inviolability:IsHidden()		return self:GetCaster() == self:GetParent() end
function modifier_creeps_spell_Inviolability:IsPurgable()		return self:GetCaster() ~= self:GetParent()  end
function modifier_creeps_spell_Inviolability:RemoveOnDeath()	return false end

function modifier_creeps_spell_Inviolability:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
end



function modifier_creeps_spell_Inviolability:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_creeps_spell_Inviolability:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end
    if keys.damage_category~=0 then
        return
    end
    if not self:GetParent().pattern_2 then
        return
    end
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    if keys.attacker.creeps_spell_Inviolability_trigger ==1 then
        return
    end
    keys.attacker:AddNewModifier(caster, ability, "modifier_creeps_spell_Inviolability_spell_slow", {duration = 20})
    keys.attacker.creeps_spell_Inviolability_trigger = 1
    Timers:CreateTimer(3, function()
        keys.attacker.creeps_spell_Inviolability_trigger = 0
    end)
    -----------------------------------------------

end



function modifier_creeps_spell_Inviolability:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    if self.parent == keys.target and not self.parent:PassivesDisabled() and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then
		keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_creeps_spell_Inviolability_slow", {})
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_creeps_spell_Inviolability_slow_stack", {duration = 20})
    end
end

-- --音效
-- function modifier_creeps_spell_Inviolability:OnAttackStart(keys)
-- 	if not IsServer() then return end
	
-- 	-- "Does not work against wards, buildings and allies."
--     if self.caster == keys.target then
--         self.caster:EmitSound("enchantress_ench_level_06")
--     end
-- end


-------------------------------
-- UNTOUCHABLE MODIFIER SLOW --
-------------------------------

modifier_creeps_spell_Inviolability_slow	= class({})


function modifier_creeps_spell_Inviolability_slow:IsDebuff()			return true end
function modifier_creeps_spell_Inviolability_slow:IsHidden() 			return true end
function modifier_creeps_spell_Inviolability_slow:IsPurgable() 		  return false end
function modifier_creeps_spell_Inviolability_slow:IsPurgeException() 	return false end
function modifier_creeps_spell_Inviolability_slow:OnCreated()
    if not IsServer() then
        return
    end
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
   
	-- AbilitySpecials
	self.slow_attack_speed 			= -30
	--self.slow_duration 			= self.ability:GetSpecialValueFor("slow_duration")
	self.kindred_spirits_multiplier = self.ability:GetSpecialValueFor("kindred_spirits_multiplier")
    local buffs = self.parent:FindAllModifiersByName("modifier_creeps_spell_Inviolability_slow_stack")
    local stack = 1
    if #buffs>0 then
        stack = stack + buffs[1]:GetStackCount()*0.01
    end
    
	self.slow_attack_speed = self.slow_attack_speed *stack
    self:SetStackCount(self.slow_attack_speed)
end

function modifier_creeps_spell_Inviolability_slow:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_creeps_spell_Inviolability_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_enchantress_untouchable.vpcf"
end

function modifier_creeps_spell_Inviolability_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_creeps_spell_Inviolability_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*2
end

-- After the attack is complete, remove the slow after a short delay
function modifier_creeps_spell_Inviolability_slow:OnAttack(keys)
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

modifier_creeps_spell_Inviolability_slow_stack	= class({})


function modifier_creeps_spell_Inviolability_slow_stack:IsDebuff()			return true end
function modifier_creeps_spell_Inviolability_slow_stack:IsHidden() 			return false end
function modifier_creeps_spell_Inviolability_slow_stack:IsPurgable() 		    return false end
function modifier_creeps_spell_Inviolability_slow_stack:IsPurgeException() 	return false end
function modifier_creeps_spell_Inviolability_slow_stack:OnRefresh(table)
    self:IncrementStackCount()
end



modifier_creeps_spell_Inviolability_spell_slow	= class({})


function modifier_creeps_spell_Inviolability_spell_slow:IsDebuff()			return true end
function modifier_creeps_spell_Inviolability_spell_slow:IsHidden() 			return false end
function modifier_creeps_spell_Inviolability_spell_slow:IsPurgable() 		    return false end
function modifier_creeps_spell_Inviolability_spell_slow:IsPurgeException() 	return false end
function modifier_creeps_spell_Inviolability_spell_slow:OnRefresh(table)
    self:IncrementStackCount()
end

function modifier_creeps_spell_Inviolability_spell_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
    }
end

function modifier_creeps_spell_Inviolability_spell_slow:GetModifierPercentageCasttime()
    return (self:GetStackCount()+1)*(-75)
end