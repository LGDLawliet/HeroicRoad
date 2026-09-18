
Advanced_frostmourne = class({})

LinkLuaModifier( "modifier_Advanced_frostmourne", "skills/Advanced_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frostmourne_debuff", "skills/Advanced_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frostmourne_debuff_middle", "skills/Advanced_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frostmourne_lv15", "skills/Advanced_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_frostmourne_unlock3", "skills/Advanced_frostmourne", LUA_MODIFIER_MOTION_NONE )
function Advanced_frostmourne:UnlockFirstCore(key)
	return true
end
function Advanced_frostmourne:UnlockSecondCore(key)
	return true
end
function Advanced_frostmourne:UnlockThirdCore(key)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_frostmourne_unlock3", {})
	return true
end

function Advanced_frostmourne:CheckKV(key)
	local table = {
		attack_speed = 0.2,
		damage = 0.1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_frostmourne:GetIntrinsicModifierName()
	return "modifier_Advanced_frostmourne"
end

modifier_Advanced_frostmourne = advanced_modifier({})

function modifier_Advanced_frostmourne:IsDebuff()	return false end
function modifier_Advanced_frostmourne:IsPurgable()	return false end
function modifier_Advanced_frostmourne:IsHidden()	return true end
function modifier_Advanced_frostmourne:OnCreated()
	self.ability = self:GetAbility()
	self.level = self.ability:GetSpecialValueFor("advanced_level")

	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_Advanced_frostmourne:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end

function modifier_Advanced_frostmourne:Advanced_GetModifierAttackSpeedPercentage()
	return self.attack_speed
end

function modifier_Advanced_frostmourne:OnAttackLanded( keys )
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

	if attacker ~= self:GetParent() then return end
	if attacker:PassivesDisabled() then return end
	if attacker:IsInSpecialAttack() then return end
	if not target:IsAlive() or target:IsMagicImmune() then return end
	self.level = self.ability:GetSpecialValueFor("advanced_level")

	self:AddCurse(target, false, 1)
end

function modifier_Advanced_frostmourne:AddCurse(target, Canbemultiple, interval)
	if not target then return end
	local level = self.level
	local caster = self:GetCaster()
	local duration = self.duration

	if Canbemultiple == true then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self.ability, "modifier_Advanced_frostmourne_debuff_middle", 
		{	duration = duration*StatusResistance,
			interval = interval,
			level = level
		})
	else
		local cursed = target:FindModifierByNameAndCaster("modifier_Advanced_frostmourne_debuff", caster)
		if cursed then
			if level >= 10 then
				local stack = 1
				if self.ability:GetUnlock(1) == 1 then
					stack = 5	
				end
				cursed:SetStackCount(cursed:GetStackCount() + stack)
			end
			return
		else
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
			local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, self.ability, "modifier_Advanced_frostmourne_debuff", 
			{	duration = duration*StatusResistance,
				interval = interval,
				level = level
			})
			caster:EmitSound("Hero_Abaddon.Curse.Proc")
		end
	end
end
-------
modifier_Advanced_frostmourne_debuff = advanced_modifier({})

function modifier_Advanced_frostmourne_debuff:IsDebuff() return true end
function modifier_Advanced_frostmourne_debuff:IsHidden() return false end
function modifier_Advanced_frostmourne_debuff:IsPurgable() return false end
function modifier_Advanced_frostmourne_debuff:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_Advanced_frostmourne_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_frostmourne_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.max = self.ability:GetSpecialValueFor("max")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.steal = self.ability:GetSpecialValueFor("steal")*0.01
	self.index = self.ability:GetSpecialValueFor("index")*0.01
	self.index_10 = self.ability:GetSpecialValueFor("index_10")*0.01
	self.duration_15 = self.ability:GetSpecialValueFor("duration_15")
	self.stack_20 = self.ability:GetSpecialValueFor("stack_20")
	self.level = self.ability:GetSpecialValueFor("advanced_level")

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

		self:SetStackCount(0)
		if self.level >= 20 then
			self:SetStackCount(self.stack_20)
		end
	end
end

function modifier_Advanced_frostmourne_debuff:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	
	local caster = self:GetCaster()
	self.damagetable.damage = caster:HDGetPrimaryStatValue() *self.damage *(1+self:GetStackCount()*self.index_10)

	if self.damagetable.victim == caster then
		self.damagetable.damage = self.damagetable.damage*0.05
	end

	if self.ability:GetUnlock(2) == 2 then
		if self:GetParent():GetHealthPercent() > 60 then
			self.damagetable.damage = self.damagetable.damage*1.6
		elseif self:GetParent():GetHealthPercent() < 30 then
			self.damagetable.damage = self.damagetable.damage*1.4
		end
	end

	local final_damage = ApplyDamage(self.damagetable)

	if caster:IsAlive() then
		--吸血增强
		local life_steal_gain = caster:GetModifierLifeStealGain(1)
		local hp_steal = final_damage*life_steal_gain*self.steal
		caster:Heal(hp_steal, self.ability)
		caster:GiveMana(hp_steal*self.index)
		if self.level >= 15 and caster:GetHealthPercent() >= 100 and caster:GetManaPercent() >= 100 then
			caster:AddNewModifier(caster, self.ability, "modifier_Advanced_frostmourne_lv15", {duration = self.duration_15})
		end
	end
end

function modifier_Advanced_frostmourne_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_Advanced_frostmourne_debuff:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
	return funcs
end

function modifier_Advanced_frostmourne_debuff:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	return -self.slow 
end

function modifier_Advanced_frostmourne_debuff:OnDeath(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local unit = keys.unit
	if unit ~= parent then return end
	local modifier = caster:FindModifierByName("modifier_Advanced_frostmourne")

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
modifier_Advanced_frostmourne_debuff_middle = advanced_modifier({})

function modifier_Advanced_frostmourne_debuff_middle:IsDebuff() return true end
function modifier_Advanced_frostmourne_debuff_middle:IsHidden() return false end
function modifier_Advanced_frostmourne_debuff_middle:IsPurgable() return false end
function modifier_Advanced_frostmourne_debuff_middle:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_Advanced_frostmourne_debuff_middle:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_frostmourne_debuff_middle:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_frostmourne_debuff_middle:OnCreated(keys)
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.max = self.ability:GetSpecialValueFor("max")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.steal = self.ability:GetSpecialValueFor("steal")*0.01
	self.index = self.ability:GetSpecialValueFor("index")*0.01
	self.magic_res_5 = self.ability:GetSpecialValueFor("magic_res_5")
	self.index_10 = self.ability:GetSpecialValueFor("index_10")*0.01
	self.duration_15 = self.ability:GetSpecialValueFor("duration_15")
	self.stack_20 = self.ability:GetSpecialValueFor("stack_20")

	self.level = self.ability:GetSpecialValueFor("advanced_level")

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

function modifier_Advanced_frostmourne_debuff_middle:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	
	local caster = self:GetCaster()
	self.damagetable.damage = caster:HDGetPrimaryStatValue() *self.damage

	if self.damagetable.victim == caster then
		self.damagetable.damage = self.damagetable.damage*0.05
	end

	if self.ability:GetUnlock(2) == 2 then
		if self:GetParent():GetHealthPercent() > 60 then
			self.damagetable.damage = self.damagetable.damage*1.6
		elseif self:GetParent():GetHealthPercent() < 30 then
			self.damagetable.damage = self.damagetable.damage*1.4
		end
	end

	local final_damage = ApplyDamage(self.damagetable)

	if caster:IsAlive() then
		caster:Heal(final_damage*self.steal, self.ability)
		caster:GiveMana(final_damage*self.steal*self.index)
		if self.level >= 15 and caster:GetHealthPercent() >= 100 and caster:GetManaPercent() >= 100 then
			caster:AddNewModifier(caster, self.ability, "modifier_Advanced_frostmourne_lv15", {duration = self.duration_15})
		end
	end
end

function modifier_Advanced_frostmourne_debuff_middle:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 5 then
		table.insert(funcs,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS)
	end
	return funcs
end

function modifier_Advanced_frostmourne_debuff_middle:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
	return funcs
end

function modifier_Advanced_frostmourne_debuff_middle:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	return -self.slow 
end

function modifier_Advanced_frostmourne_debuff_middle:GetModifierMagicalResistanceBonus()
	if not self:GetAbility() then self:Destroy() return end
	return -self.magic_res_5
end

function modifier_Advanced_frostmourne_debuff_middle:OnDeath(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local unit = keys.unit
	if unit ~= parent then return end
	local modifier = caster:FindModifierByName("modifier_Advanced_frostmourne")

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
-------
modifier_Advanced_frostmourne_lv15 = advanced_modifier({})

function modifier_Advanced_frostmourne_lv15:IsDebuff() return false end
function modifier_Advanced_frostmourne_lv15:IsHidden() return false end
function modifier_Advanced_frostmourne_lv15:IsPurgable() return false end

function modifier_Advanced_frostmourne_lv15:OnCreated(keys)
	self.ability = self:GetAbility()
	self.outgoing_15 = self.ability:GetSpecialValueFor("outgoing_15")
end

function modifier_Advanced_frostmourne_lv15:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
	return funcs
end

function modifier_Advanced_frostmourne_lv15:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not self:GetAbility() then return end
	return self.outgoing_15
end

-----
modifier_Advanced_frostmourne_unlock3 = advanced_modifier({})

function modifier_Advanced_frostmourne_unlock3:IsDebuff()	return true end
function modifier_Advanced_frostmourne_unlock3:IsPurgable()	return false end
function modifier_Advanced_frostmourne_unlock3:IsHidden()	return false end
function modifier_Advanced_frostmourne_unlock3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_frostmourne_unlock3:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_frostmourne")

	if caster:IsAlive() then
		if modifier then
			modifier:AddCurse(caster, false, 1)
		end
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i , enemy in ipairs(enemies) do
        if enemy:IsAlive() then
			if modifier then
				modifier:AddCurse(enemy, false, 1)
			end
		end
    end
end
-- 当层数改变时cy
-- function modifier_Advanced_frostmourne_debuff_counter:OnStackCountChanged(iStackCount)
-- 	if not IsServer() then return end

-- 	if not self.pfx then
-- 		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
-- 	end

-- 	ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
-- end
