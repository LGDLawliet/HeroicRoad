--战意
Primary_Warpath = class({})


LinkLuaModifier("modifier_Primary_Warpath_passive", "skills/Primary_Warpath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Warpath", "skills/Primary_Warpath", LUA_MODIFIER_MOTION_NONE)


function Primary_Warpath:GetIntrinsicModifierName() return "modifier_Primary_Warpath_passive" end
function Primary_Warpath:IsHiddenWhenStolen() 		return false end
function Primary_Warpath:IsRefreshable() 			return true  end
function Primary_Warpath:IsStealable() 			return true  end
function Primary_Warpath:IsNetherWardStealable()	return true end



modifier_Primary_Warpath= advanced_modifier({})

function modifier_Primary_Warpath:IsDebuff()			return false end
function modifier_Primary_Warpath:IsHidden() 			return false end
function modifier_Primary_Warpath:IsPurgable() 		return false end
function modifier_Primary_Warpath:IsPurgeException() 	return false end
function modifier_Primary_Warpath:DeclareFunctions() return 
	{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_MODEL_SCALE,} end
function modifier_Primary_Warpath:GetModifierMoveSpeedBonus_Percentage() return self.ms*self:GetStackCount() end
function modifier_Primary_Warpath:Advanced_GetModifierPhysicalArmorBonus() return self.armor*self:GetStackCount() end
function modifier_Primary_Warpath:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()*self.att
end
function modifier_Primary_Warpath:GetModifierModelScale() 
    return 2*self:GetStackCount()
end
function modifier_Primary_Warpath:OnCreated()
	self.att = self:GetAbility():GetSpecialValueFor("damage_per_stack") 
	self.ms = self:GetAbility():GetSpecialValueFor("move_speed_per_stack") 
	self.armor = self:GetAbility():GetSpecialValueFor("armor_per_stack") 
	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
	end
end
function modifier_Primary_Warpath:OnRefresh()
	if IsServer() then
		self:SetStackCount( math.min( self:GetStackCount() + 1, self:GetAbility():GetSpecialValueFor("max_stacks")) ) 

	end
end

function modifier_Primary_Warpath:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end





function modifier_Primary_Warpath:OnWaveEnd()
    if IsServer() then
		self:Destroy()
	end
end




modifier_Primary_Warpath_passive = class({})

function modifier_Primary_Warpath_passive:IsDebuff()			return false end
function modifier_Primary_Warpath_passive:IsHidden() 			return true end
function modifier_Primary_Warpath_passive:IsPurgable() 		return false end
function modifier_Primary_Warpath_passive:IsPurgeException() 	return false end
function modifier_Primary_Warpath_passive:RemoveOnDeath()  return false end
function modifier_Primary_Warpath_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Primary_Warpath_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end
	if self:GetParent():PassivesDisabled() then
		return
	end

	local ModifierStatusGain = keys.unit:GetModifierDurationGainIndex(1)
	keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"modifier_Primary_Warpath",{duration = self:GetAbility():GetSpecialValueFor("duration_warpath")*ModifierStatusGain})	

end


