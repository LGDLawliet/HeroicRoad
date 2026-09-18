Middle_Battle_Hunger = class({})

LinkLuaModifier("modifier_Middle_Battle_Hunger_caster", "skills/Middle_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Battle_Hunger_enemy", "skills/Middle_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)

function Middle_Battle_Hunger:IsHiddenWhenStolen() 		return false end
function Middle_Battle_Hunger:IsRefreshable() 			return true end
function Middle_Battle_Hunger:IsStealable() 				return true end
function Middle_Battle_Hunger:IsNetherWardStealable() 	return true end

function Middle_Battle_Hunger:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	return true
end

function Middle_Battle_Hunger:OnAbilityPhaseInterrupted() self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_2) end

function Middle_Battle_Hunger:GetIntrinsicModifierName() return "modifier_Middle_Battle_Hunger_caster" end

function Middle_Battle_Hunger:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if target:TriggerStandardTargetSpell(self) then
		return
	end

	target:AddNewModifier(self:GetCaster(), self, "modifier_Middle_Battle_Hunger_enemy", {duration=self:GetSpecialValueFor("duration")})
	target:EmitSound("Hero_Axe.Battle_Hunger")
end

modifier_Middle_Battle_Hunger_caster =advanced_modifier({})

function modifier_Middle_Battle_Hunger_caster:IsDebuff()				return false end
function modifier_Middle_Battle_Hunger_caster:IsPurgable() 		return false end
function modifier_Middle_Battle_Hunger_caster:IsPurgeException() 	return false end
function modifier_Middle_Battle_Hunger_caster:RemoveOnDeath()  return false end
function modifier_Middle_Battle_Hunger_caster:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end
function modifier_Middle_Battle_Hunger_caster:OnCreated(table)
	self.parent = self:GetParent()
	self.regen = self:GetAbility():GetSpecialValueFor("regen")*0.01
end
function modifier_Middle_Battle_Hunger_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_Middle_Battle_Hunger_caster:GetModifierMoveSpeedBonus_Constant() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("speed_bonus")) end
function modifier_Middle_Battle_Hunger_caster:AdvancedGetModifierConstantHealthRegen() 
	local losthp = self.parent:GetMaxHealth() - self.parent:GetHealth()
	return (self:GetStackCount() * losthp*self.regen)
	
end

function modifier_Middle_Battle_Hunger_caster:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end

modifier_Middle_Battle_Hunger_enemy = class({})

function modifier_Middle_Battle_Hunger_enemy:IsDebuff()				return true end
function modifier_Middle_Battle_Hunger_enemy:IsPurgable() 			return true end
function modifier_Middle_Battle_Hunger_enemy:IsPurgeException() 		return false end
function modifier_Middle_Battle_Hunger_enemy:IsHidden()				return false end
function modifier_Middle_Battle_Hunger_enemy:GetEffectName() return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf" end
function modifier_Middle_Battle_Hunger_enemy:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Middle_Battle_Hunger_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Battle_Hunger_enemy:ShouldUseOverheadOffset() return true end
function modifier_Middle_Battle_Hunger_enemy:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	-- MODIFIER_EVENT_ON_DEATH,
} end
function modifier_Middle_Battle_Hunger_enemy:GetModifierMoveSpeedBonus_Constant() return (0-self:GetAbility():GetSpecialValueFor("speed_bonus")) end

-- function modifier_Middle_Battle_Hunger_enemy:OnDeath(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if keys.attacker ~= self:GetParent() or keys.unit:IsIllusion() then
-- 		return
-- 	end
-- 	self:SetStackCount(self:GetStackCount() - 1)
-- 	if self:GetStackCount() <= 0 then
-- 		self:SafeDestroy()
-- 	end
-- end

function modifier_Middle_Battle_Hunger_enemy:OnCreated()
	if not IsServer() then
		return 
	end
	-- self:SetStackCount(self:GetAbility():GetSpecialValueFor("kill_need"))
	self.dmg = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("extra_damage") / 100)
	if self:GetCaster():HasModifier("modifier_Middle_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_Middle_Battle_Hunger_caster"):IncrementStackCount()
	end
	self:StartIntervalThink(1.0)
end

-- function modifier_Middle_Battle_Hunger_enemy:OnRefresh()
-- 	if IsServer() then
-- 		self:SetStackCount(self:GetAbility():GetSpecialValueFor("kill_need"))
-- 	end
-- end

function modifier_Middle_Battle_Hunger_enemy:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if IsNearEnemyFountain(self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), 1100) then
		self:SafeDestroy()
	end
	
	local damageTable = {
							victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = self.dmg,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
							ability = ability, --Optional.
							hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
							}
	self:GetParent():ApplyMergeDamage(damageTable)
end

function modifier_Middle_Battle_Hunger_enemy:OnDestroy()
	if not IsServer() then
		return 
	end
	if self:GetCaster():HasModifier("modifier_Middle_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_Middle_Battle_Hunger_caster"):DecrementStackCount()
	end
end
