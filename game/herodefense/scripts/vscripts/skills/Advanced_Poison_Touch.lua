LinkLuaModifier("modifier_Advanced_Poison_Touch", "skills/Advanced_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Poison_Touch_stack", "skills/Advanced_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Poison_Touch_unlock2", "skills/Advanced_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Poison_Touch_attack", "skills/Advanced_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
Advanced_Poison_Touch = class({})

function Advanced_Poison_Touch:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_poison_dazzle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf", context )
end

function Advanced_Poison_Touch:CheckKV(key)
	local table = {
		poison = 1,
		bonus_poison = 0.005
	}
	local value = table[key] or -1
	return value
end

function Advanced_Poison_Touch:UnlockFirstCore(key)
	return true
end
function Advanced_Poison_Touch:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_Poison_Touch_unlock2", {})
	return true
end
function Advanced_Poison_Touch:UnlockThirdCore(key)
	return true
end

function Advanced_Poison_Touch:GetAOERadius() return (self:GetSpecialValueFor("attack_radius")) end
function Advanced_Poison_Touch:GetIntrinsicModifierName()
	return "modifier_Advanced_Poison_Touch_attack"
end

function Advanced_Poison_Touch:OnSpellStart(victim)
	local target = self:GetCursorTarget()
	self:CastEffect(target)
end
function Advanced_Poison_Touch:CastEffect(target)
	local caster = self:GetCaster()
	local attack_radius = self:GetSpecialValueFor("attack_radius")
	local target = target
	local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		target:GetAbsOrigin(), 
		nil, 
		attack_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)

	local attack_amount = self:GetSpecialValueFor("attack_amount")

	if #enemy > 0 then
		caster:EmitSound("Hero_Dazzle.Poison_Cast")
	end
	
	for i=1, #enemy do
		if i > attack_amount then
			return			
		end

		self:CreateProjectile({
			target = enemy[i],
		})
	end
end

--target
--stack
function Advanced_Poison_Touch:CreateProjectile(keys)
	local caster = self:GetCaster()
	local target = keys.target
	local stack = keys.stack or 1
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {
			stack = stack,
		},
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function Advanced_Poison_Touch:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	if not target or not target:IsAlive() then return end
	if target:IsMagicImmune() then return end

	local stack = keys.stack
	target:AddNewModifier(caster, self, "modifier_Advanced_Poison_Touch", {
		duration = self:GetSpecialValueFor("duration"),
		stack = stack,
	})
	target:EmitSound("Hero_Dazzle.Poison_Touch")
end
-----
modifier_Advanced_Poison_Touch = advanced_modifier({})

function modifier_Advanced_Poison_Touch:IsDebuff()				return true end
function modifier_Advanced_Poison_Touch:IsHidden() 			return false end
function modifier_Advanced_Poison_Touch:IsPurgable() 			return false end
function modifier_Advanced_Poison_Touch:IsPurgeException() 	return false end
function modifier_Advanced_Poison_Touch:StatusEffectPriority() return 15 end
function modifier_Advanced_Poison_Touch:GetStatusEffectName()  return "particles/status_fx/status_effect_poison_dazzle.vpcf" end
function modifier_Advanced_Poison_Touch:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end
function modifier_Advanced_Poison_Touch:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Poison_Touch:OnCreated(kv)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.poison = self.ability:GetSpecialValueFor("poison")
	self.bonus_poison = self.ability:GetSpecialValueFor("bonus_poison")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.slow = self.ability:GetSpecialValueFor("move_slow")
	self.max_count = self.ability:GetSpecialValueFor("max_count")
	self.index = self.ability:GetSpecialValueFor("index")*0.01
	self.death_stack_max = self.ability:GetSpecialValueFor("death_stack_max")
	self.radius = self.ability:GetSpecialValueFor("radius")

	self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")

	if self.advanced_level >= 15 then
		self.index = self.index + 0.25
	end
	if IsServer() then
		if self.ability.unlock1 then
			self.max_count = self.max_count + 50
		end
		self:AddStackDuration(kv.stack, self:GetDuration(), self.max_count)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Advanced_Poison_Touch:OnRefresh(kv)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.poison = self.ability:GetSpecialValueFor("poison")
	self.bonus_poison = self.ability:GetSpecialValueFor("bonus_poison")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.slow = self.ability:GetSpecialValueFor("move_slow")
	self.index = self.ability:GetSpecialValueFor("index")*0.01
	self.max_count = math.max(self.ability:GetSpecialValueFor("max_count"), self:GetStackCount())
	self.death_stack_max = self.ability:GetSpecialValueFor("death_stack_max")
	self.radius = self.ability:GetSpecialValueFor("radius")

	self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")

	if self.advanced_level >= 15 then
		self.index = self.index + 0.25
	end
	if IsServer() then
		if self.ability.unlock1 then
			self.max_count = self.ability:GetSpecialValueFor("max_count") + 50
		end
		self:AddStackDuration(kv.stack, self:GetDuration(), self.max_count)
		if self.advanced_level >= 20 then
			self:RefreshAllStacksDuration(self:GetDuration())
		end
	end
end

function modifier_Advanced_Poison_Touch:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsMagicImmune() then return end



	local poison = (self.poison + self.bonus_poison*self.caster:HDGetPrimaryStatValue())*self:GetStackCount()
	local spell_amp = 1 + math.max(self.caster:GetSpellAmplification(false)*self.index,0)
	poison = poison*spell_amp
	self.parent:Poison(self.caster, self.ability, poison)

	EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_Dazzle.Poison_Tick", self.parent)
end

function modifier_Advanced_Poison_Touch:DeclareFunctions()
	local decfuncs = {
	 	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
	if self:GetAbility():GetUnlock(3) == 3 then
		table.insert(decfuncs, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS)
	end
	return decfuncs
end

function modifier_Advanced_Poison_Touch:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent()},
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_Advanced_Poison_Touch:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	if keys.target ~= self.parent or (not keys.attacker:IsHero()) then return end

	self:RefreshAllStacksDuration(self:GetDuration())
end

function modifier_Advanced_Poison_Touch:OnDeath(keys)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	local unit = keys.unit
	if unit ~= self.parent then return end
	local count = 1
	if self.advanced_level >= 10 then
		count = count + 1
	end


	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
		self.parent:GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)
	for i, enemy in pairs(enemies) do
		self.ability:CreateProjectile({
			target = enemy,
			stack = math.min(self:GetStackCount(), self.death_stack_max),
		})

		if i >= count then break end
	end
end

function modifier_Advanced_Poison_Touch:GetModifierMoveSpeedBonus_Percentage() 
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsMagicImmune() then return 0 end
	return -self.slow*self:GetStackCount() 
end

function modifier_Advanced_Poison_Touch:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsMagicImmune() then return 0 end
	return self:GetStackCount() * 1
end

function modifier_Advanced_Poison_Touch:GetModifierMagicalResistanceBonus()
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsMagicImmune() then return 0 end
	return -self:GetStackCount() * 8
end

function modifier_Advanced_Poison_Touch:OnTooltip()
	 self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then return self:GetModifierMoveSpeedBonus_Percentage() end
	if self._tooltip == 2 then return self:Advanced_GetModifierIncomingDamage_Percentage() end
end

modifier_Advanced_Poison_Touch_unlock2 = advanced_modifier({})

function modifier_Advanced_Poison_Touch_unlock2:IsHidden() return true end
function modifier_Advanced_Poison_Touch_unlock2:IsDebuff() return false end
function modifier_Advanced_Poison_Touch_unlock2:IsPurgable() return false end
function modifier_Advanced_Poison_Touch_unlock2:IsPurgeException() return false end
function modifier_Advanced_Poison_Touch_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Poison_Touch_unlock2:OnCreated()
	self.ability = self:GetAbility()
	self.caster  = self:GetCaster()
	self.parent = self:GetParent()
	if IsServer() then
		self.poison_touch = self.caster:FindAbilityByName("Advanced_Poison_Touch")
		self:StartIntervalThink(3)
	end
end

function modifier_Advanced_Poison_Touch_unlock2:OnIntervalThink()
	if not self.poison_touch then self:Destroy() return end
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
		self.parent:GetAbsOrigin(), 
		nil,
		1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)

	for _, enemy in pairs(enemies) do
		self.poison_touch:CreateProjectile({
			target = enemy,
		})
	end
end

-------
modifier_Advanced_Poison_Touch_attack = advanced_modifier({})

function modifier_Advanced_Poison_Touch_attack:IsDebuff()				return false end
function modifier_Advanced_Poison_Touch_attack:IsHidden() 			return true end
function modifier_Advanced_Poison_Touch_attack:IsPurgable() 			return false end
function modifier_Advanced_Poison_Touch_attack:IsPurgeException() 	return false end
function modifier_Advanced_Poison_Touch_attack:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(), nil},
	}
end
function modifier_Advanced_Poison_Touch_attack:OnAttack(keys)
	if not IsServer() then return end
	local ability = self:GetAbility()
	local attacker = keys.attacker
	local target = keys.target
	if not ability or not ability:IsCooldownReady() or not ability:GetAutoCastState() then return end
	if not target or not target:IsAlive() then return end
	if target:IsMagicImmune() then return end

	ability:CastEffect(target)
	ability:UseResources(true, true, true, true)
end