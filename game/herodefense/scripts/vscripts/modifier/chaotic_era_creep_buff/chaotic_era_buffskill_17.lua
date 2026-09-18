LinkLuaModifier( "modifier_chaotic_era_buffskill_17", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_17.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_era_buffskill_17 = class({})

function chaotic_era_buffskill_17:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_17"
end
function chaotic_era_buffskill_17:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/unrivaled_cleave/unrivaled_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/unrivaled_cleave/unrivaled_impact_b.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/unrivaled/particle_15/effect_ambient.vpcf", context )
end
---------------------------------------------------------------------

modifier_chaotic_era_buffskill_17 = advanced_modifier({})
function modifier_chaotic_era_buffskill_17:IsPurgable() return false end

function modifier_chaotic_era_buffskill_17:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
    self.move = self.ability:GetSpecialValueFor("move")
	self.no_armor = self.ability:GetSpecialValueFor("no_armor")
    self.line = self.ability:GetSpecialValueFor("line")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.start_stack = self.ability:GetSpecialValueFor("start_stack")
	if IsServer() then 
		self:StartIntervalThink(1)
		self:SetStackCount(-self.start_stack)

		local parent = self:GetParent()
		local particle = "particles/rebuild/spell/unrivaled/particle_15/effect_ambient.vpcf"
		parent:EmitSound("unrivaled.saiyazin_Start")
		parent:EmitSound("unrivaled.saiyazin_Loop")
		
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end
function modifier_chaotic_era_buffskill_17:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_chaotic_era_buffskill_17:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
	}
end
function modifier_chaotic_era_buffskill_17:OnIntervalThink()
	if not self.parent:IsAlive() then return end
	if self.parent:PassivesDisabled() then
		local random = math.random
		if 40 >= random(1,100) then return end
	end

	self:SetStackCount(self:GetStackCount()+1)
end
function modifier_chaotic_era_buffskill_17:GetModifierMoveSpeedBonus_Constant()
	return math.max(self.move*self:GetStackCount(),0)
end
function modifier_chaotic_era_buffskill_17:GetModifierAttackSpeedBonus_Constant()
	return math.max(self.attack_speed*self:GetStackCount(),0)
end
function modifier_chaotic_era_buffskill_17:Advanced_GetModifierAttackArmor_Ignore()
	return math.max(self.no_armor*self:GetStackCount(),0)
end
function modifier_chaotic_era_buffskill_17:Advanced_GetModifier_TalentEffectGain_Mul()
	return (self:GetStackCount() >= self.line and self.outgoing) or 0
end

function modifier_chaotic_era_buffskill_17:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self:GetModifierMoveSpeedBonus_Constant()
	end
	if self._tooltip == 2 then
		return  self:GetModifierAttackSpeedBonus_Constant()
	end
	if self._tooltip == 3 then
		return  self:Advanced_GetModifierAttackArmor_Ignore()
	end
	if self._tooltip == 4 then
		return self:Advanced_GetModifier_TalentEffectGain_Mul()
	end
end