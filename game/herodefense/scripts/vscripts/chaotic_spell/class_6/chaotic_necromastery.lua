LinkLuaModifier( "modifier_chaotic_necromastery", "chaotic_spell/class_6/chaotic_necromastery.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_necromastery_rune_2", "chaotic_spell/class_6/chaotic_necromastery.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_necromastery = class({})
function chaotic_necromastery:GetIntrinsicModifierName()
	return "modifier_chaotic_necromastery"
end
function chaotic_necromastery:GetBehavior()
	if self:GetRuneType() == 2 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT +DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end
function chaotic_necromastery:GetCooldown()
	if self:GetRuneType() == 2 then
		return self:GetSpecialValueFor("rune_2_cd")
	end
	return 0
end
function chaotic_necromastery:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Ursa.Overpower")
	caster:AddNewModifier(caster, self, "modifier_chaotic_necromastery_rune_2", {duration = self:GetSpecialValueFor("rune_2_duration")})
end

modifier_chaotic_necromastery = advanced_modifier({})

function modifier_chaotic_necromastery:IsHidden()	return false end
function modifier_chaotic_necromastery:IsDebuff()	return false end
function modifier_chaotic_necromastery:IsPurgable()	return false end
function modifier_chaotic_necromastery:RemoveOnDeath()	return false end

function modifier_chaotic_necromastery:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
	self.max = self.ability:GetSpecialValueFor("max")
	self.loss = self.ability:GetSpecialValueFor("loss")*0.01

	self.type = self.ability:GetRuneType()
	self.rune_1_max = self.ability:GetSpecialValueFor("rune_1_max")
	self.rune_1_outgoing = self.ability:GetSpecialValueFor("rune_1_outgoing")
	self.rune_1_loss = self.ability:GetSpecialValueFor("rune_1_loss")
	self.rune_2_duration = self.ability:GetSpecialValueFor("rune_2_duration")

	self:SetStackCount(0)

	if IsServer() then
		if self.type == 1 then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_chaotic_necromastery:OnIntervalThink()
	if self:GetStackCount() > self.max then
		self:SetStackCount(self:GetStackCount() - self.rune_1_loss)
		if self:GetStackCount() < self.max then
			self:SetStackCount(self.max)
		end
	end
end
function modifier_chaotic_necromastery:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
function modifier_chaotic_necromastery:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
	}
	if self:GetAbility():GetRuneType() == 1 then
		table.insert(funcs, advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs
end
function modifier_chaotic_necromastery:Advanced_GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()*self.attack
end
function modifier_chaotic_necromastery:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()*self.spell_amp
end
function modifier_chaotic_necromastery:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return math.max(self:GetStackCount()-self.max,0)*self.rune_1_outgoing
end
function modifier_chaotic_necromastery:OnDeath(keys)
	if not IsServer() then return end
	local unit = keys.unit
	local attacker = keys.attacker
	--死的是自己，且没有复活保险
	if unit == self.parent and keys.reincarnate == false then
		local after_death = math.floor(self:GetStackCount()*(1-self.loss))
		self:SetStackCount(math.max(after_death,1))
		return

	elseif attacker and attacker:GetPlayerOwnerID() == self.parent:GetPlayerOwnerID() and unit ~= self.parent and self.parent:IsAlive() then
		local get = 1
		if unit:IsChaoticEraElite() then
			get = 10
		end

		self:AddStack(get)
		self:PlayEffects( unit )
	end
end
function modifier_chaotic_necromastery:AddStack( value )
	if self.parent:HasModifier("modifier_chaotic_necromastery_rune_2") then
		return
	end

	local final_max = self.max
	if self.type == 1 then
		final_max = self.max + self.rune_1_max
	end
	self:SetStackCount( math.min(self:GetStackCount()+value,final_max) )
end
function modifier_chaotic_necromastery:PlayEffects( target )
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 600,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function modifier_chaotic_necromastery:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierPreAttack_BonusDamage()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
    end
    if self._tooltip == 3 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    end
end
---
modifier_chaotic_necromastery_rune_2 = advanced_modifier({})

function modifier_chaotic_necromastery_rune_2:IsHidden()	return false end
function modifier_chaotic_necromastery_rune_2:IsDebuff()	return false end
function modifier_chaotic_necromastery_rune_2:IsPurgable()	return false end

function modifier_chaotic_necromastery_rune_2:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.rune_2_attack_speed = self.ability:GetSpecialValueFor("rune_2_attack_speed")
	self.rune_2_move = self.ability:GetSpecialValueFor("rune_2_move")
	self.rune_2_loss = self.ability:GetSpecialValueFor("rune_2_loss")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_necromastery_rune_2:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	local modifier = self.parent:FindModifierByName("modifier_chaotic_necromastery")
	if modifier then
		modifier:SetStackCount(math.max(modifier:GetStackCount() - self.rune_2_loss, 0))
	end
end
function modifier_chaotic_necromastery_rune_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_chaotic_necromastery_rune_2:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then self:Destroy() return end
	return self.rune_2_attack_speed
end
function modifier_chaotic_necromastery_rune_2:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	return self.rune_2_move
end