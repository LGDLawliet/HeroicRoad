LinkLuaModifier("modifier_Middle_Untouchable", "skills/Middle_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Untouchable_slow", "skills/Middle_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Untouchable_spell_slow", "skills/Middle_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Untouchable_slow_stack", "skills/Middle_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Untouchable_Count", "skills/Middle_Untouchable", LUA_MODIFIER_MOTION_NONE)

Middle_Untouchable				= class({})


function Middle_Untouchable:GetIntrinsicModifierName() 
	return "modifier_Middle_Untouchable"
end

require("internal/timers")
--------------------------
-- UNTOUCHABLE MODIFIER --
--------------------------

modifier_Middle_Untouchable		= class({})

function modifier_Middle_Untouchable:IsHidden()		return true end
function modifier_Middle_Untouchable:IsPurgable() 		return false end
function modifier_Middle_Untouchable:IsPurgeException() 	return false end
function modifier_Middle_Untouchable:RemoveOnDeath()  return false end

function modifier_Middle_Untouchable:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
end



function modifier_Middle_Untouchable:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_Middle_Untouchable:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end
    if not IsEnemy(keys.unit,keys.attacker) then
        return
    end
    	--不对刃甲伤害做出反映
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end


    if (bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS) then
        return
	end

    if keys.damage_category~=0 then
        return
    end
    if  keys.attacker:IsMagicImmune() then
        return
    end
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    if keys.attacker.Middle_Untouchable_trigger ==1 then
        return
    end
    keys.attacker:AddNewModifier(caster, ability, "modifier_Middle_Untouchable_spell_slow", {duration = 20})
    keys.attacker.Middle_Untouchable_trigger = 1
    Timers:CreateTimer(3, function()
        keys.attacker.Middle_Untouchable_trigger = 0
    end)
    -----------------------------------------------

end



function modifier_Middle_Untouchable:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    if self.parent == keys.target and not self.parent:PassivesDisabled() and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then
        if keys.attacker:IsMagicImmune() then
            return
        end
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_Middle_Untouchable_slow", {})
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_Middle_Untouchable_slow_stack", {duration = 20})
    end
end



modifier_Middle_Untouchable_slow	= class({})


function modifier_Middle_Untouchable_slow:IsDebuff()			return true end
function modifier_Middle_Untouchable_slow:IsHidden() 			return true end
function modifier_Middle_Untouchable_slow:IsPurgable() 		  return false end
function modifier_Middle_Untouchable_slow:IsPurgeException() 	return false end
function modifier_Middle_Untouchable_slow:OnCreated()
    if not IsServer() then
        return
    end
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
   
	-- AbilitySpecials
	self.slow_attack_speed 			= -self.ability:GetSpecialValueFor("attack_slow")
	--self.slow_duration 			= self.ability:GetSpecialValueFor("slow_duration")

    local buffs = self.parent:FindAllModifiersByName("modifier_Middle_Untouchable_slow_stack")
    local stack = 1
    if #buffs>0 then
        stack = stack + buffs[1]:GetStackCount()*0.01
    end
	self.slow_attack_speed = self.slow_attack_speed *stack
    self:SetStackCount(self.slow_attack_speed)
end

function modifier_Middle_Untouchable_slow:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_Middle_Untouchable_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_enchantress_untouchable.vpcf"
end

function modifier_Middle_Untouchable_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_Middle_Untouchable_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

-- After the attack is complete, remove the slow after a short delay
function modifier_Middle_Untouchable_slow:OnAttack(keys)
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

modifier_Middle_Untouchable_slow_stack	= class({})


function modifier_Middle_Untouchable_slow_stack:IsDebuff()			return true end
function modifier_Middle_Untouchable_slow_stack:IsHidden() 			return false end
function modifier_Middle_Untouchable_slow_stack:IsPurgable() 		    return false end
function modifier_Middle_Untouchable_slow_stack:IsPurgeException() 	return false end
function modifier_Middle_Untouchable_slow_stack:OnRefresh(table)
    self:IncrementStackCount()
end



modifier_Middle_Untouchable_spell_slow	= advanced_modifier({})


function modifier_Middle_Untouchable_spell_slow:IsDebuff()			return true end
function modifier_Middle_Untouchable_spell_slow:IsHidden() 			return false end
function modifier_Middle_Untouchable_spell_slow:IsPurgable() 		    return false end
function modifier_Middle_Untouchable_spell_slow:IsPurgeException() 	return false end
function modifier_Middle_Untouchable_spell_slow:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Middle_Untouchable_spell_slow:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_CastPoint

    }

	return funcs

end

function modifier_Middle_Untouchable_spell_slow:Advanced_GetModifier_CastPoint() return -40 end


modifier_Middle_Untouchable_Count = class({})

function modifier_Middle_Untouchable_Count:IsDebuff()				return false end
function modifier_Middle_Untouchable_Count:IsHidden() 				return true end
function modifier_Middle_Untouchable_Count:IsPurgable() 			return false end
function modifier_Middle_Untouchable_Count:IsPurgeException() 		return false end
function modifier_Middle_Untouchable_Count:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Untouchable_Count:RemoveOnDeath() return true end

function modifier_Middle_Untouchable_Count:OnCreated()

    self.parent = self:GetParent()


    self:StartIntervalThink(1)

end

function modifier_Middle_Untouchable_Count:OnIntervalThink()
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