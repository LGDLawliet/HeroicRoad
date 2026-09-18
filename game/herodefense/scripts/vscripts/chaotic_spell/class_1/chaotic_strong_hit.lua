LinkLuaModifier( "modifier_chaotic_strong_hit", "chaotic_spell/class_1/chaotic_strong_hit.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_strong_hit = class({})

function chaotic_strong_hit:GetIntrinsicModifierName()
	return "modifier_chaotic_strong_hit"
end
function chaotic_strong_hit:OnSpellStart()
	local caster = self:GetCaster()
	local count = self:GetSpecialValueFor("count")
	if self:GetRuneType() == 1 then
		count = self:GetSpecialValueFor("rune_1_count")
	end

	local buff = caster:FindModifierByName("modifier_chaotic_strong_hit")
	if buff then
		buff:SetStackCount(count)
	end
end
---------------------------------------------------------------------

modifier_chaotic_strong_hit = advanced_modifier({})
function modifier_chaotic_strong_hit:IsHidden() return self:GetStackCount() <= 0 end
function modifier_chaotic_strong_hit:IsDebuff() return false end
function modifier_chaotic_strong_hit:IsPurgable() return false end
function modifier_chaotic_strong_hit:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.passive_attack = self.ability:GetSpecialValueFor("passive_attack")
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.count = self.ability:GetSpecialValueFor("count")
	self.rune_1_count = self.ability:GetSpecialValueFor("rune_1_count")
	self.rune_1_bonus = self.ability:GetSpecialValueFor("rune_1_bonus")*0.01

	self.type = self.ability:GetRuneType()
	self:SetStackCount(0)

	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_chaotic_strong_hit:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability and caster:IsAlive() then
		if HDCanAutoCast(caster, ability)==true then
			caster:CastAbilityNoTarget(ability, caster:GetPlayerOwnerID())
		end
	end
end
function modifier_chaotic_strong_hit:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
	}
end
function modifier_chaotic_strong_hit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
	}
end
function modifier_chaotic_strong_hit:Advanced_GetModifierPreAttack_BonusDamage()
	return self.passive_attack
end
function modifier_chaotic_strong_hit:GetModifierPreAttack_BonusDamagePostCrit()
	if self:GetStackCount() <= 0 then return 0 end
	local attack = self.attack + self.bonus_attack*self.parent:GetAverageTrueAttackDamage(nil)
	if self.type == 1 then
		local bonus = (self.rune_1_bonus - 1)/self:GetStackCount() 
		attack = attack*(1 + bonus)
	end
	return attack
end
function modifier_chaotic_strong_hit:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	if not attacker:IsAlive() then return end
	if self:GetStackCount() <= 0 then return end

	self:SetStackCount(math.max(self:GetStackCount() - 1, 0))
end
