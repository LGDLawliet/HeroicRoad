creeps_spell_Grow_Up = class({})

LinkLuaModifier("modifier_creeps_spell_Grow_Up", "creeps_spell/creeps_spell_Grow_Up", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Grow_Up_night", "creeps_spell/creeps_spell_Grow_Up", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Grow_Up_up", "creeps_spell/creeps_spell_Grow_Up", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Grow_Up:IsHiddenWhenStolen() 		return false end
function creeps_spell_Grow_Up:IsRefreshable() 			return true end
function creeps_spell_Grow_Up:IsStealable() 				return true end
function creeps_spell_Grow_Up:IsNetherWardStealable()		return true end
function creeps_spell_Grow_Up:GetIntrinsicModifierName() return "modifier_creeps_spell_Grow_Up" end



modifier_creeps_spell_Grow_Up = class({})

function modifier_creeps_spell_Grow_Up:IsDebuff()			return false end
function modifier_creeps_spell_Grow_Up:IsHidden() 			return false end
function modifier_creeps_spell_Grow_Up:IsPurgable() 		    return false end
function modifier_creeps_spell_Grow_Up:IsPurgeException() 	return false end

function modifier_creeps_spell_Grow_Up:OnCreated(table)
    if not IsServer()  then
        return
    end
	self.mode ="models/heroes/tiny/tiny_01/tiny_01.vmdl"
    self:StartIntervalThink(1)
	

end


function modifier_creeps_spell_Grow_Up:OnIntervalThink()

    if not IsServer()  then
        return
    end
   if self:GetParent():PassivesDisabled() then
	   return
   end
   local ability = self:GetAbility()
   local unit = self:GetParent()
   if self:GetParent():IsInNightTime()  then
	  unit:AddNewModifier(unit, ability, "modifier_creeps_spell_Grow_Up_night", {})
   end
	if self:GetStackCount()>180 then
		return
	end
   self:IncrementStackCount()
   if self:GetParent():IsInDayTime()  then
		self:IncrementStackCount()
   end
	local stack = self:GetStackCount()
	if stack==35 or stack == 36 and self.mode ~= "models/heroes/tiny/tiny_02/tiny_02.vmdl" then
		self.mode =  "models/heroes/tiny/tiny_02/tiny_02.vmdl"
		unit:AddNewModifier(unit, ability, "modifier_creeps_spell_Grow_Up_up", {})
		unit:AddNewModifier(unit, ability, "modifier_stun", {duration = 0.1})
		local pfx = ParticleManager:CreateParticle("particles/econ/taunts/tiny/ti9_tiny_taunt/tiny_03_taunt_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		unit:SetHealth(unit:GetMaxHealth())
	end
	if stack==70 or stack == 71 and self.mode ~= "models/heroes/tiny/tiny_03/tiny_03.vmdl" then
		self.mode =  "models/heroes/tiny/tiny_03/tiny_03.vmdl"
		unit:AddNewModifier(unit, ability, "modifier_creeps_spell_Grow_Up_up", {})
		unit:AddNewModifier(unit, ability, "modifier_stun", {duration = 0.1})
		local pfx = ParticleManager:CreateParticle("particles/econ/taunts/tiny/ti9_tiny_taunt/tiny_03_taunt_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		unit:SetHealth(unit:GetMaxHealth())
	end
	if stack==105 or stack == 106 and self.mode ~= "models/heroes/tiny/tiny_04/tiny_04.vmdl"  then
		self.mode =  "models/heroes/tiny/tiny_04/tiny_04.vmdl"
		unit:AddNewModifier(unit, ability, "modifier_creeps_spell_Grow_Up_up", {})
		unit:AddNewModifier(unit, ability, "modifier_stun", {duration = 0.1})
		local pfx = ParticleManager:CreateParticle("particles/econ/taunts/tiny/ti9_tiny_taunt/tiny_03_taunt_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		unit:SetHealth(unit:GetMaxHealth())

	end

end
function modifier_creeps_spell_Grow_Up:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end
function modifier_creeps_spell_Grow_Up:GetModifierModelChange()
	if self.mode ~= nil then
		return self.mode
	else
	    return "models/heroes/tiny/tiny_01/tiny_01.vmdl"
	end
end



modifier_creeps_spell_Grow_Up_night = class({})

function modifier_creeps_spell_Grow_Up_night:IsDebuff()			    return false end
function modifier_creeps_spell_Grow_Up_night:IsHidden() 			return false end
function modifier_creeps_spell_Grow_Up_night:IsPurgable() 		    return false end
function modifier_creeps_spell_Grow_Up_night:IsPurgeException() 	return false end

function modifier_creeps_spell_Grow_Up_night:OnCreated(table)
	self:IncrementStackCount()
end

function modifier_creeps_spell_Grow_Up_night:OnRefresh(table)
	self:IncrementStackCount()
end


function modifier_creeps_spell_Grow_Up_night:DeclareFunctions() return 
    {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,} end

function modifier_creeps_spell_Grow_Up_night:GetModifierBaseDamageOutgoing_Percentage() 
    return self:GetStackCount()
end


modifier_creeps_spell_Grow_Up_up = advanced_modifier({})

function modifier_creeps_spell_Grow_Up_up:IsDebuff()			    return false end
function modifier_creeps_spell_Grow_Up_up:IsHidden() 			return true end
function modifier_creeps_spell_Grow_Up_up:IsPurgable() 		    return false end
function modifier_creeps_spell_Grow_Up_up:IsPurgeException() 	return false end

function modifier_creeps_spell_Grow_Up_up:OnCreated(table)
	self:IncrementStackCount()
end

function modifier_creeps_spell_Grow_Up_up:OnRefresh(table)
	self:IncrementStackCount()
end


function modifier_creeps_spell_Grow_Up_up:DeclareFunctions() return 
    {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_creeps_spell_Grow_Up_up:GetModifierBaseAttack_BonusDamage() 
    return self:GetStackCount()*150
end

function modifier_creeps_spell_Grow_Up_up:GetModifierExtraHealthBonus() 
    return self:GetStackCount()*3000
end


function modifier_creeps_spell_Grow_Up_up:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end


function modifier_creeps_spell_Grow_Up_up:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_creeps_spell_Grow_Up_up:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetStackCount()*7-7
end