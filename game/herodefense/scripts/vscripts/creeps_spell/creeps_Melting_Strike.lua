
creeps_Melting_Strike = class({})
LinkLuaModifier("modifier_creeps_Melting_Strike", "creeps_spell/creeps_Melting_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_Melting_Strike_debuff", "creeps_spell/creeps_Melting_Strike", LUA_MODIFIER_MOTION_NONE)


function creeps_Melting_Strike:GetIntrinsicModifierName()
	return "modifier_creeps_Melting_Strike"
end



modifier_creeps_Melting_Strike = class({})
function modifier_creeps_Melting_Strike:IsDebuff()return false end
function modifier_creeps_Melting_Strike:IsHidden()return true end
function modifier_creeps_Melting_Strike:IsPurgable() return false end

function modifier_creeps_Melting_Strike:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_creeps_Melting_Strike:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	local ability = self:GetAbility()
	keys.target:AddNewModifier(self:GetCaster(), ability, "modifier_creeps_Melting_Strike_debuff", {duration = ability:GetSpecialValueFor("duration")})
end




modifier_creeps_Melting_Strike_debuff = advanced_modifier({})


function modifier_creeps_Melting_Strike_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_creeps_Melting_Strike_debuff:IsDebuff() return true end
function modifier_creeps_Melting_Strike_debuff:IsHidden() return false end
function modifier_creeps_Melting_Strike_debuff:IsPurgable() 		return false end
function modifier_creeps_Melting_Strike_debuff:IsPurgeException() 	return false end
function modifier_creeps_Melting_Strike_debuff:OnCreated()
	self.armor = self:GetAbility():GetSpecialValueFor("armor_reduce")

	if self:GetCaster():HasModifier("modifier_Advanced_summon_Forge_Spirit_buff") then
		self.armor = self.armor * 2
	end
	if IsServer() then
		self:SetStackCount(1)
		self.max = self:GetAbility():GetSpecialValueFor("max_stack")
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_summon_Forge_Spirit_buff")
		if modifier and modifier:GetAbility() and modifier:GetAbility().advanced_level>=10 then
			self.max = self.max +20
		end
		if self:GetCaster():HasModifier("modifier_Advanced_summon_Forge_Spirit_big") then
			self:SetStackCount(self.max)
		end

	end
end

function modifier_creeps_Melting_Strike_debuff:OnRefresh()

	if IsServer() then
		if self:GetCaster():HasModifier("modifier_Advanced_summon_Forge_Spirit_big") then
			self:SetStackCount(self.max)
		else
			self:SetStackCount(math.min(self:GetStackCount()+1,self.max))
		end
		
	end
end
function modifier_creeps_Melting_Strike_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_creeps_Melting_Strike_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_creeps_Melting_Strike_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_creeps_Melting_Strike_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()*self.armor
end