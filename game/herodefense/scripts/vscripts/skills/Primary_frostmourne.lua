
Primary_frostmourne = class({})

LinkLuaModifier( "modifier_Primary_frostmourne", "skills/Primary_frostmourne", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_frostmourne_debuff", "skills/Primary_frostmourne", LUA_MODIFIER_MOTION_NONE )

function Primary_frostmourne:GetIntrinsicModifierName()
	return "modifier_Primary_frostmourne"
end

modifier_Primary_frostmourne = advanced_modifier({})

function modifier_Primary_frostmourne:IsDebuff()	return false end
function modifier_Primary_frostmourne:IsPurgable()	return false end
function modifier_Primary_frostmourne:IsHidden()	return true end
function modifier_Primary_frostmourne:OnCreated()
	self.ability = self:GetAbility()

	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_Primary_frostmourne:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end

function modifier_Primary_frostmourne:Advanced_GetModifierAttackSpeedPercentage()
	return self.attack_speed
end

function modifier_Primary_frostmourne:OnAttackLanded( keys )
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

	if attacker ~= self:GetParent() then return end
	if attacker:PassivesDisabled() then return end
	if attacker:IsInSpecialAttack() then return end
	if not target:IsAlive() or target:IsMagicImmune() then return end

	self:AddCurse(target, false, 1)
end

function modifier_Primary_frostmourne:AddCurse(target, Canbemultiple, interval)
	if not target then return end
	local caster = self:GetCaster()
	local duration = self.duration

	if Canbemultiple == true then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self.ability, "modifier_Primary_frostmourne_debuff_middle", 
		{	duration = duration*StatusResistance,
			interval = interval,
		})
	else
		local cursed = target:FindModifierByNameAndCaster("modifier_Primary_frostmourne_debuff", caster)
		if cursed then
			return
		else
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
			local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, self.ability, "modifier_Primary_frostmourne_debuff", 
			{	duration = duration*StatusResistance,
				interval = interval,
			})
			caster:EmitSound("Hero_Abaddon.Curse.Proc")
		end
	end
end
-------
modifier_Primary_frostmourne_debuff = advanced_modifier({})

function modifier_Primary_frostmourne_debuff:IsDebuff() return true end
function modifier_Primary_frostmourne_debuff:IsHidden() return false end
function modifier_Primary_frostmourne_debuff:IsPurgable() return false end
function modifier_Primary_frostmourne_debuff:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_Primary_frostmourne_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_frostmourne_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("slow")
	self.damage = self.ability:GetSpecialValueFor("damage")

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

function modifier_Primary_frostmourne_debuff:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	
	local caster = self:GetCaster()
	self.damagetable.damage = caster:HDGetPrimaryStatValue() *self.damage 
	local final_damage = ApplyDamage(self.damagetable)
end

function modifier_Primary_frostmourne_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_Primary_frostmourne_debuff:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then self:Destroy() return end
	return -self.slow 
end

-- 当层数改变时cy
-- function modifier_Primary_frostmourne_debuff_counter:OnStackCountChanged(iStackCount)
-- 	if not IsServer() then return end

-- 	if not self.pfx then
-- 		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
-- 	end

-- 	ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
-- end
