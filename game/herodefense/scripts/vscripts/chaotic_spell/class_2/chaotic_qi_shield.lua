LinkLuaModifier("modifier_chaotic_qi_shield", "chaotic_spell/class_2/chaotic_qi_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_qi", "chaotic_spell/class_1/chaotic_flurry_of_blows.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if chaotic_qi_shield == nil then
	chaotic_qi_shield = class({})
end

function chaotic_qi_shield:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_chaotic_qi_shield", {duration = self:GetSpecialValueFor("duration")})
end

---------------------------------------------------------------------
-- Modifiers
if modifier_chaotic_qi_shield == nil then
	modifier_chaotic_qi_shield = class({})
end

function modifier_chaotic_qi_shield:OnCreated(params)
	if IsServer() then
		self.absorb = self:GetAbility():GetSpecialValueFor("absorb")*0.01
		self.qi_cost = self:GetAbility():GetSpecialValueFor("qi_cost")*0.01
		self:SetStackCount(self.absorb)
	end
end

function modifier_chaotic_qi_shield:OnRefresh(params)
	if IsServer() then
		self.absorb = self:GetAbility():GetSpecialValueFor("absorb")*0.01
		self.absorb_extra = self:GetAbility():GetSpecialValueFor("absorb_extra")*0.01
		self:SetStackCount(self.absorb)
	end
end

function modifier_chaotic_qi_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end

function modifier_chaotic_qi_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local qi = self:GetCaster():FindModifierByName("modifier_chaotic_qi")
		if qi then
			qi = qi:GetStackCount()
		else
			qi = 0
		end
		local block
		if qi > 0 then
			self:GetCaster():SetModifierStackCount("modifier_chaotic_qi", self:GetCaster(), qi - 1)
			block = (self.absorb + self.absorb_extra)*params.damage
		else
			block = self.absorb * params.damage
		end
		return block
	end
end