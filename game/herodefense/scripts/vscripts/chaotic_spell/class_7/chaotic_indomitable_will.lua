chaotic_indomitable_will = class({})
LinkLuaModifier("modifier_chaotic_indomitable_will", "chaotic_spell/class_7/chaotic_indomitable_will", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_indomitable_will_buff", "chaotic_spell/class_7/chaotic_indomitable_will", LUA_MODIFIER_MOTION_NONE)

function chaotic_indomitable_will:GetIntrinsicModifierName() return "modifier_chaotic_indomitable_will" end



function chaotic_indomitable_will:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_indomitable_will/chaotic_indomitable_will_1.vpcf", context )
end


function chaotic_indomitable_will:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end

function chaotic_indomitable_will:CheckKVFixedOverride(key)
	if key=="AbilityCharges" then
		if self:GetRuneType()==1 then
			return self:GetSpecialValueFor("rune_1_bonus") +1
		end
	end


	return -999999

end


function chaotic_indomitable_will:GetAbilityChargeRestoreTime(key)
	return self:GetCooldown(-1)
end





modifier_chaotic_indomitable_will = advanced_modifier({})

function modifier_chaotic_indomitable_will:IsDebuff()			return false end
function modifier_chaotic_indomitable_will:IsHidden() 		return true end
function modifier_chaotic_indomitable_will:IsPurgable() 		return false end
function modifier_chaotic_indomitable_will:IsPurgeException() return false end

function modifier_chaotic_indomitable_will:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		-- advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},  --生命汲取

    }
end

function modifier_chaotic_indomitable_will:OnCreated() 

	self.parent = self:GetParent()

    self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen") * 0.01
	self.health_regen_gain =  self.health_regen*(1+self:GetAbility():GetSpecialValueFor("health_regen_gain") * 0.01)

end

function modifier_chaotic_indomitable_will:OnRefresh()

	self.parent = self:GetParent()

    self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen") * 0.01
	self.health_regen_gain = self.health_regen* (1+self:GetAbility():GetSpecialValueFor("health_regen_gain") * 0.01)

end




function modifier_chaotic_indomitable_will:AdvancedGetModifierConstantHealthRegenPercentage()

	if self:GetParent():HasModifier("modifier_chaotic_indomitable_will_buff") then

		return (100-self.parent:GetHealthPercent()) *self.health_regen_gain
	else
		return  (100-self.parent:GetHealthPercent()) *self.health_regen
	end
	
end


function modifier_chaotic_indomitable_will:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit
		if unit~=self:GetParent() then	return end
		local ability = self:GetAbility()
		if not ability:IsCooldownReady() then
			return 
		end
		if unit:HasModifier("modifier_chaotic_indomitable_will_buff") then
			return
		end
		if unit:GetHealth()<=0 then
			unit:SetHealth(1)
			if ability:GetRuneType()==1 then
				if ability and ability:GetCurrentAbilityCharges()>=1 then
					ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
				end
			else
				ability:UseResources(true,true,true,true)
			end
			
			local duration = ability:GetSpecialValueFor("duration")
			unit:AddNewModifier(unit,ability,"modifier_chaotic_indomitable_will_buff",{duration = duration})
		end
    end 
end


modifier_chaotic_indomitable_will_buff = advanced_modifier({})

function modifier_chaotic_indomitable_will_buff:IsDebuff()			return false end
function modifier_chaotic_indomitable_will_buff:IsHidden() 		return false end
function modifier_chaotic_indomitable_will_buff:IsPurgable() 		return false end
function modifier_chaotic_indomitable_will_buff:IsPurgeException() return false end
function modifier_chaotic_indomitable_will_buff:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_indomitable_will/chaotic_indomitable_will_1.vpcf" end
function modifier_chaotic_indomitable_will_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_chaotic_indomitable_will_buff:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Axe.BerserkersCall.Item.Shoutmask")
		self:GetParent():EmitSound("Hero_Axe.JungleWeapon.Dunk")
	end
end

function modifier_chaotic_indomitable_will_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end

function modifier_chaotic_indomitable_will_buff:Advanced_GetModifierIncomingDamage_Percentage( keys )
	return -100
end

