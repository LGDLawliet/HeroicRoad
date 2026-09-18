LinkLuaModifier("modifier_Primary_Poison_Touch", "skills/Primary_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Poison_Touch_stack", "skills/Primary_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Poison_Touch_attack", "skills/Primary_Poison_Touch", LUA_MODIFIER_MOTION_NONE)
Primary_Poison_Touch = class({})

function Primary_Poison_Touch:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_poison_dazzle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf", context )
end
function Primary_Poison_Touch:GetAOERadius() return (self:GetSpecialValueFor("attack_radius")) end

function Primary_Poison_Touch:GetIntrinsicModifierName()
	return "modifier_Primary_Poison_Touch_attack"
end

function Primary_Poison_Touch:OnSpellStart(victim)
	local target = self:GetCursorTarget()
	self:CastEffect(target)
end

function Primary_Poison_Touch:CastEffect(target)
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

--taregt
function Primary_Poison_Touch:CreateProjectile(keys)
	local caster = self:GetCaster()
	local target = keys.target
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
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function Primary_Poison_Touch:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	if not target or not target:IsAlive() then return end
	if target:IsMagicImmune() then return end

	target:AddNewModifier(caster, self, "modifier_Primary_Poison_Touch", {duration = self:GetSpecialValueFor("duration")})
	target:EmitSound("Hero_Dazzle.Poison_Touch")
end
-----
modifier_Primary_Poison_Touch = advanced_modifier({})

function modifier_Primary_Poison_Touch:IsDebuff()				return true end
function modifier_Primary_Poison_Touch:IsHidden() 			return false end
function modifier_Primary_Poison_Touch:IsPurgable() 			return false end
function modifier_Primary_Poison_Touch:IsPurgeException() 	return false end
function modifier_Primary_Poison_Touch:StatusEffectPriority() return 15 end
function modifier_Primary_Poison_Touch:GetStatusEffectName()  return "particles/status_fx/status_effect_poison_dazzle.vpcf" end
function modifier_Primary_Poison_Touch:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end
function modifier_Primary_Poison_Touch:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_Poison_Touch:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.poison = self.ability:GetSpecialValueFor("poison")
	self.bonus_poison = self.ability:GetSpecialValueFor("bonus_poison")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.slow = self.ability:GetSpecialValueFor("move_slow")
	self.max_count = self.ability:GetSpecialValueFor("max_count")
	if IsServer() then
		self:AddStackDuration(1, self:GetDuration(), self.max_count)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Primary_Poison_Touch:OnRefresh()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.poison = self.ability:GetSpecialValueFor("poison")
	self.bonus_poison = self.ability:GetSpecialValueFor("bonus_poison")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.slow = self.ability:GetSpecialValueFor("move_slow")
	self.max_count = math.max(self.ability:GetSpecialValueFor("max_count"), self:GetStackCount())
	if IsServer() then
		self:AddStackDuration(1, self:GetDuration(), self.max_count)
	end
end

function modifier_Primary_Poison_Touch:DeclareFunctions()
	return {
	 	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_Primary_Poison_Touch:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent()},
	}
end

function modifier_Primary_Poison_Touch:GetModifierMoveSpeedBonus_Percentage() 
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsMagicImmune() then return 0 end
	return -self.slow*self:GetStackCount() 
end

function modifier_Primary_Poison_Touch:OnTooltip()
	return self:GetModifierMoveSpeedBonus_Percentage()
end

function modifier_Primary_Poison_Touch:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	if keys.target ~= self.parent or (not keys.attacker:IsHero()) then return end

	self:RefreshAllStacksDuration(self:GetDuration())
end

function modifier_Primary_Poison_Touch:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsMagicImmune() then return end

	local poison = (self.poison + self.bonus_poison*self.caster:HDGetPrimaryStatValue())*self:GetStackCount()
	self.parent:Poison(self.caster, self.ability, poison)

	EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_Dazzle.Poison_Tick", self.parent)
end
-------
modifier_Primary_Poison_Touch_attack = advanced_modifier({})

function modifier_Primary_Poison_Touch_attack:IsDebuff()				return false end
function modifier_Primary_Poison_Touch_attack:IsHidden() 			return true end
function modifier_Primary_Poison_Touch_attack:IsPurgable() 			return false end
function modifier_Primary_Poison_Touch_attack:IsPurgeException() 	return false end
function modifier_Primary_Poison_Touch_attack:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(), nil},
	}
end
function modifier_Primary_Poison_Touch_attack:OnAttack(keys)
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