
chaotic_frostmourne = class({})

LinkLuaModifier( "modifier_chaotic_frostmourne", "chaotic_spell/class_4/chaotic_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_frostmourne_debuff", "chaotic_spell/class_4/chaotic_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_frostmourne_debuff_middle", "chaotic_spell/class_4/chaotic_frostmourne", LUA_MODIFIER_MOTION_NONE )

function chaotic_frostmourne:GetIntrinsicModifierName()
	return "modifier_chaotic_frostmourne"
end

modifier_chaotic_frostmourne = advanced_modifier({})

function modifier_chaotic_frostmourne:IsDebuff()	return false end
function modifier_chaotic_frostmourne:IsPurgable()	return false end
function modifier_chaotic_frostmourne:IsHidden()	return true end
function modifier_chaotic_frostmourne:OnCreated()
	self.ability = self:GetAbility()

	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_chaotic_frostmourne:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_frostmourne:Advanced_GetModifierAttackSpeedPercentage()
	return self.attack_speed
end

function modifier_chaotic_frostmourne:OnAttackLanded( keys )
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

	if attacker ~= self:GetParent() then return end
	if attacker:PassivesDisabled() then return end
	if attacker:IsInSpecialAttack() then return end
	if not target:IsAlive() or target:IsMagicImmune() then return end

	self:AddCurse(target, false, 1)
end

function modifier_chaotic_frostmourne:AddCurse(target, Canbemultiple, interval)
	if not target then return end
	local caster = self:GetCaster()
	local duration = self.duration

	if Canbemultiple == true then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self.ability, "modifier_chaotic_frostmourne_debuff_middle", 
		{	duration = duration*StatusResistance,
			interval = interval,
		})
	else
		local cursed = target:FindModifierByNameAndCaster("modifier_chaotic_frostmourne_debuff", caster)
		if cursed then
			return
		else
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
			local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, self.ability, "modifier_chaotic_frostmourne_debuff", 
			{	duration = duration*StatusResistance,
				interval = interval,
			})
			caster:EmitSound("Hero_Abaddon.Curse.Proc")
		end
	end
end
-------
modifier_chaotic_frostmourne_debuff = advanced_modifier({})

function modifier_chaotic_frostmourne_debuff:IsDebuff() return true end
function modifier_chaotic_frostmourne_debuff:IsHidden() return false end
function modifier_chaotic_frostmourne_debuff:IsPurgable() return false end
function modifier_chaotic_frostmourne_debuff:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_chaotic_frostmourne_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_frostmourne_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("rune_1_radius")
	self.max = self.ability:GetSpecialValueFor("rune_1_max")
	self.interval = self.ability:GetSpecialValueFor("rune_1_interval")

	if IsServer() then 
		self:StartIntervalThink(keys.interval)
		self.damagetable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			--damage = ,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self.ability,
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_DOT
		}
	end
end

function modifier_chaotic_frostmourne_debuff:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	
	local caster = self:GetCaster()
	self.damagetable.damage = caster:HDGetPrimaryStatValue() *self.damage 
	local final_damage = ApplyDamage(self.damagetable)
end

function modifier_chaotic_frostmourne_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_frostmourne_debuff:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
	return funcs
end

function modifier_chaotic_frostmourne_debuff:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	return -self.slow 
end

function modifier_chaotic_frostmourne_debuff:OnDeath(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local unit = keys.unit
	if unit ~= parent then return end
    if self.ability:GetRuneType() ~= 1 then return end
	local modifier = caster:FindModifierByName("modifier_chaotic_frostmourne")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i , enemy in ipairs(enemies) do
        if enemy:IsAlive() and enemy ~= parent then
			if modifier then
				modifier:AddCurse(enemy, true, self.interval)
			end
			if i >= self.max then
				break
			end
		end
    end
end
-------
modifier_chaotic_frostmourne_debuff_middle = advanced_modifier({})

function modifier_chaotic_frostmourne_debuff_middle:IsDebuff() return true end
function modifier_chaotic_frostmourne_debuff_middle:IsHidden() return false end
function modifier_chaotic_frostmourne_debuff_middle:IsPurgable() return false end
function modifier_chaotic_frostmourne_debuff_middle:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_chaotic_frostmourne_debuff_middle:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_frostmourne_debuff_middle:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_frostmourne_debuff_middle:OnCreated(keys)
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("rune_1_radius")
	self.max = self.ability:GetSpecialValueFor("rune_1_max")
	self.interval = self.ability:GetSpecialValueFor("rune_1_interval")


	if IsServer() then 
		self:StartIntervalThink(keys.interval)
		self.damagetable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			--damage = ,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self.ability,
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE
		}
	end
end

function modifier_chaotic_frostmourne_debuff_middle:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	
	local caster = self:GetCaster()
	self.damagetable.damage = caster:HDGetPrimaryStatValue() *self.damage
	local final_damage = ApplyDamage(self.damagetable)
end

function modifier_chaotic_frostmourne_debuff_middle:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_frostmourne_debuff_middle:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
	return funcs
end

function modifier_chaotic_frostmourne_debuff_middle:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	return -self.slow 
end



function modifier_chaotic_frostmourne_debuff_middle:OnDeath(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local unit = keys.unit
	if unit ~= parent then return end
	local modifier = caster:FindModifierByName("modifier_chaotic_frostmourne")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i , enemy in pairs(enemies) do
        if enemy:IsAlive() and enemy ~= parent then
			if modifier then
				modifier:AddCurse(enemy, true, self.interval)
			end
			if i >= self.max then
				break
			end
		end
    end
end

-- 当层数改变时cy
-- function modifier_chaotic_frostmourne_debuff_counter:OnStackCountChanged(iStackCount)
-- 	if not IsServer() then return end

-- 	if not self.pfx then
-- 		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
-- 	end

-- 	ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
-- end
