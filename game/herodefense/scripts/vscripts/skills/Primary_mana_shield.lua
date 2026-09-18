
LinkLuaModifier("modifier_Primary_mana_shield_meditate", "skills/Primary_mana_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_mana_shield", "skills/Primary_mana_shield", LUA_MODIFIER_MOTION_NONE)

Primary_mana_shield = class({})


function Primary_mana_shield:GetIntrinsicModifierName()
	return "modifier_Primary_mana_shield_meditate"
end

function Primary_mana_shield:ProcsMagicStick() return false end

function Primary_mana_shield:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Primary_mana_shield:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Primary_mana_shield:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_mana_shield", {})
	else
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Primary_mana_shield", self:GetCaster())
	end
end
------------------------------------------------------------------------------------------------------------------
modifier_Primary_mana_shield_meditate = advanced_modifier({})

function modifier_Primary_mana_shield_meditate:IsHidden()	return true end
function modifier_Primary_mana_shield_meditate:IsPurgable() 		return false end
function modifier_Primary_mana_shield_meditate:IsPurgeException() 	return false end
function modifier_Primary_mana_shield_meditate:RemoveOnDeath()  return false end
function modifier_Primary_mana_shield_meditate:DeclareFunctions()
	local decFuncs = {	
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,                       --魔法值
    }
    return decFuncs
end

function modifier_Primary_mana_shield_meditate:ADDeclareFunctions()
	local decFuncs = {	
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,                       --魔法值
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return decFuncs
end

function modifier_Primary_mana_shield_meditate:OnCreated(table)
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	self:SetStackCount(0)
	--if IsServer() then
		self:StartIntervalThink(0.5)
	--end
end

function modifier_Primary_mana_shield_meditate:OnIntervalThink()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")

	if self:GetParent():HasModifier("modifier_Primary_mana_shield") then
		self:SetStackCount(self.incoming)
	else
		self:SetStackCount(0)
	end
end

function modifier_Primary_mana_shield_meditate:GetModifierExtraManaPercentage()	return self.bonus_mana end
function modifier_Primary_mana_shield_meditate:Advanced_GetModifierSpellAmplifyBonus()	return self.bonus_spell_amp end
function modifier_Primary_mana_shield_meditate:Advanced_GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()
end
-------------------------------------------------------------------------------------------------------------------
modifier_Primary_mana_shield = advanced_modifier({})
function modifier_Primary_mana_shield:GetEffectName()return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf" end
function modifier_Primary_mana_shield:IsHidden() return false end
function modifier_Primary_mana_shield:IsDebuff() return false end
function modifier_Primary_mana_shield:IsPurgable() 		return false end
function modifier_Primary_mana_shield:RemoveOnDeath()	return false end

function modifier_Primary_mana_shield:OnCreated()
	self.per_mana = self:GetAbility():GetSpecialValueFor("per_mana")
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")

	if not IsServer() then return end
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	self:StartIntervalThink(0.5)
end

function modifier_Primary_mana_shield:OnIntervalThink()
	self.per_mana = self:GetAbility():GetSpecialValueFor("per_mana")
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
end

function modifier_Primary_mana_shield:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


function modifier_Primary_mana_shield:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if self:GetParent().GetMana then
		local mana_to_block	= keys.original_damage * self.absorption_tooltip * 0.01 / self.per_mana
		if mana_to_block >= self:GetParent():GetMana() then
			self:GetParent():EmitSound("Hero_Medusa.ManaShield.Proc")
			
			local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(shield_particle)
		end			
		local block =math.min(self.absorption_tooltip, self.absorption_tooltip * self:GetParent():GetMana() / math.max(mana_to_block, 1)) * (-1)
		mana_to_block = math.min(mana_to_block,self:GetParent():GetMaxMana()*0.4)
		self:GetParent():Script_ReduceMana(mana_to_block,self:GetAbility())

		return block
	end
end


