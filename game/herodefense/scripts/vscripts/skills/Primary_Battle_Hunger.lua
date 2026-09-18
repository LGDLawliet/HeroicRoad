Primary_Battle_Hunger = class({})

LinkLuaModifier("modifier_Primary_Battle_Hunger_caster", "skills/Primary_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Battle_Hunger_enemy", "skills/Primary_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)

function Primary_Battle_Hunger:IsHiddenWhenStolen() 		return false end
function Primary_Battle_Hunger:IsRefreshable() 			return true end
function Primary_Battle_Hunger:IsStealable() 				return true end
function Primary_Battle_Hunger:IsNetherWardStealable() 	return true end

function Primary_Battle_Hunger:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	return true
end

function Primary_Battle_Hunger:OnAbilityPhaseInterrupted() self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_2) end

function Primary_Battle_Hunger:GetIntrinsicModifierName() return "modifier_Primary_Battle_Hunger_caster" end

function Primary_Battle_Hunger:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if target:TriggerStandardTargetSpell(self) then
		return
	end

	target:AddNewModifier(self:GetCaster(), self, "modifier_Primary_Battle_Hunger_enemy", {duration=self:GetSpecialValueFor("duration")})
	target:EmitSound("Hero_Axe.Battle_Hunger")
end

modifier_Primary_Battle_Hunger_caster =class({})

function modifier_Primary_Battle_Hunger_caster:IsDebuff()				return false end
function modifier_Primary_Battle_Hunger_caster:IsPurgable() 			return false end
function modifier_Primary_Battle_Hunger_caster:IsPurgeException() 		return false end
function modifier_Primary_Battle_Hunger_caster:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

function modifier_Primary_Battle_Hunger_caster:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,}
end

function modifier_Primary_Battle_Hunger_caster:GetModifierMoveSpeedBonus_Constant() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("speed_bonus")) end


modifier_Primary_Battle_Hunger_enemy = class({})

function modifier_Primary_Battle_Hunger_enemy:IsDebuff()				return true end
function modifier_Primary_Battle_Hunger_enemy:IsPurgable() 			return true end
function modifier_Primary_Battle_Hunger_enemy:IsPurgeException() 		return false end
function modifier_Primary_Battle_Hunger_enemy:IsHidden()				return false end
function modifier_Primary_Battle_Hunger_enemy:GetEffectName() return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf" end
function modifier_Primary_Battle_Hunger_enemy:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Primary_Battle_Hunger_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Battle_Hunger_enemy:ShouldUseOverheadOffset() return true end
function modifier_Primary_Battle_Hunger_enemy:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

	} 
end
function modifier_Primary_Battle_Hunger_enemy:GetModifierMoveSpeedBonus_Constant() return self.bonus_speed end



function modifier_Primary_Battle_Hunger_enemy:OnCreated()
	self.bonus_speed = -self:GetAbility():GetSpecialValueFor("speed_bonus")
	if not IsServer() then
		return 
	end
	-- self:SetStackCount(self:GetAbility():GetSpecialValueFor("kill_need"))
	self.dmg = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("extra_damage") / 100)
	if self:GetCaster():HasModifier("modifier_Primary_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_Primary_Battle_Hunger_caster"):IncrementStackCount()
	end
	self:StartIntervalThink(1.0)
end

-- function modifier_Primary_Battle_Hunger_enemy:OnRefresh()
-- 	if IsServer() then
-- 		self:SetStackCount(self:GetAbility():GetSpecialValueFor("kill_need"))
-- 	end
-- end

function modifier_Primary_Battle_Hunger_enemy:OnIntervalThink()
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
							ability = ability, --Optional.\
							hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
							}
	self:GetParent():ApplyMergeDamage(damageTable)
end

function modifier_Primary_Battle_Hunger_enemy:OnDestroy()
	if not IsServer() then
		return 
	end
	if self:GetCaster():HasModifier("modifier_Primary_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_Primary_Battle_Hunger_caster"):DecrementStackCount()
	end
end
