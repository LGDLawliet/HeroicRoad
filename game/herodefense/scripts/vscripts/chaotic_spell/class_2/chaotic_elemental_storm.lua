LinkLuaModifier( "modifier_chaotic_elemental_storm_thinker", "chaotic_spell/class_2/chaotic_elemental_storm.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_elemental_storm_fire", "chaotic_spell/class_2/chaotic_elemental_storm.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_elemental_storm_ice", "chaotic_spell/class_2/chaotic_elemental_storm.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_elemental_storm_lightning", "chaotic_spell/class_2/chaotic_elemental_storm.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_elemental_storm_wind", "chaotic_spell/class_2/chaotic_elemental_storm.lua", LUA_MODIFIER_MOTION_NONE )
--元素风暴
--Abilities
if chaotic_elemental_storm == nil then
	chaotic_elemental_storm = class({})
end

function chaotic_elemental_storm:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("storm_duration")
	local radius = self:GetSpecialValueFor("radius")

	CreateModifierThinker(
		caster,
		self,
		"modifier_chaotic_elemental_storm_thinker",
		{ duration = duration },
		point,
		caster:GetTeamNumber(),
		false
	)

	-- 添加范围特效
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(tostring(radius), 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)
end

---------------------------------------------------------------------
--Modifiers
if modifier_chaotic_elemental_storm_thinker == nil then
	modifier_chaotic_elemental_storm_thinker = class({})
end

function modifier_chaotic_elemental_storm_thinker:IsHidden()
	return true
end

function modifier_chaotic_elemental_storm_thinker:IsPurgable()
	return false
end

function modifier_chaotic_elemental_storm_thinker:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_elemental_storm_thinker:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("radius")
		local random_effect = RandomInt(1, 4)

		if random_effect == 1 then
			self:ApplyFireEffect(caster, ability, radius)
		elseif random_effect == 2 then
			self:ApplyIceEffect(caster, ability, radius)
		elseif random_effect == 3 then
			self:ApplyLightningEffect(caster, ability, radius)
		elseif random_effect == 4 then
			self:ApplyWindEffect(caster, ability, radius)
		end
	end
end

function modifier_chaotic_elemental_storm_thinker:ApplyFireEffect(caster, ability, radius)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_chaotic_elemental_storm_fire", { duration = 3 })
	end
end

function modifier_chaotic_elemental_storm_thinker:ApplyIceEffect(caster, ability, radius)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_chaotic_elemental_storm_ice", { duration = 1 })
	end
end

function modifier_chaotic_elemental_storm_thinker:ApplyLightningEffect(caster, ability, radius)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		ApplyDamage({
			victim = enemy,
			attacker = caster,
			damage = 150,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		})
	end
end

function modifier_chaotic_elemental_storm_thinker:ApplyWindEffect(caster, ability, radius)
	local allies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, ally in pairs(allies) do
		ally:AddNewModifier(caster, ability, "modifier_chaotic_elemental_storm_wind", { duration = 5 })
	end
end

if modifier_chaotic_elemental_storm_fire == nil then
	modifier_chaotic_elemental_storm_fire = class({})
end

function modifier_chaotic_elemental_storm_fire:IsHidden()
	return false
end

function modifier_chaotic_elemental_storm_fire:IsPurgable()
	return true
end

function modifier_chaotic_elemental_storm_fire:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_elemental_storm_fire:OnIntervalThink()
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor("base_damage")
		local damage_table = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage(damage_table)
	end
end

if modifier_chaotic_elemental_storm_ice == nil then
	modifier_chaotic_elemental_storm_ice = class({})
end

function modifier_chaotic_elemental_storm_ice:IsHidden()
	return false
end

function modifier_chaotic_elemental_storm_ice:IsPurgable()
	return true
end

function modifier_chaotic_elemental_storm_ice:OnCreated(params)
	if IsServer() then
		self.slow = self:GetAbility():GetSpecialValueFor("move_speed_slow")
		self.attack_slow = self:GetAbility():GetSpecialValueFor("attack_speed_slow")
		self:SetStackCount(self.slow+self.attack_slow*1000)
	end
end

function modifier_chaotic_elemental_storm_ice:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_chaotic_elemental_storm_ice:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()%1000
end

function modifier_chaotic_elemental_storm_ice:GetModifierAttackSpeedBonus_Constant()
	return math.floor(self:GetStackCount()/1000)
end

if modifier_chaotic_elemental_storm_lightning == nil then
	modifier_chaotic_elemental_storm_lightning = class({})
end

function modifier_chaotic_elemental_storm_lightning:IsHidden()
	return false
end

function modifier_chaotic_elemental_storm_lightning:IsPurgable()
	return true
end

function modifier_chaotic_elemental_storm_lightning:OnCreated(params)
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		local damage_table = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage(damage_table)
	end
end

if modifier_chaotic_elemental_storm_wind == nil then
	modifier_chaotic_elemental_storm_wind = class({})
end

function modifier_chaotic_elemental_storm_wind:IsHidden()
	return false
end

function modifier_chaotic_elemental_storm_wind:IsPurgable()
	return true
end

function modifier_chaotic_elemental_storm_wind:OnCreated(params)
	if IsServer() then
		self.bonus_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
		self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_chaotic_elemental_storm_wind:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_chaotic_elemental_storm_wind:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_speed
end

function modifier_chaotic_elemental_storm_wind:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end