Middle_Counter_Helix = class({})

LinkLuaModifier("modifier_Middle_Counter_Helix", "skills/Middle_Counter_Helix", LUA_MODIFIER_MOTION_NONE)
require("internal.timers")
function Middle_Counter_Helix:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Middle_Counter_Helix:GetIntrinsicModifierName() return "modifier_Middle_Counter_Helix" end
function Middle_Counter_Helix:Spawn()
	if not IsServer() then return end
	self:GetCaster().Middle_Counter_Helix_bonus_damage = 0
	self:GetCaster().Middle_Counter_Helix_bonus_radius = 0
end


modifier_Middle_Counter_Helix = class({})

function modifier_Middle_Counter_Helix:IsDebuff()				return false end
function modifier_Middle_Counter_Helix:IsPurgable() 			return false end
function modifier_Middle_Counter_Helix:IsPurgeException() 	return false end
function modifier_Middle_Counter_Helix:IsHidden()				return true end

function modifier_Middle_Counter_Helix:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

function modifier_Middle_Counter_Helix:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self:GetParent():PassivesDisabled() or not self:GetAbility():IsCooldownReady() or not self:GetParent():IsAlive() then
		return
	end
	if keys.target == self:GetParent() then
		if not self:GetAbility():IsCooldownReady() or self:GetParent():IsHexed() then
			return
		end
		if not (self:GetCaster():GetRandomEffect(self:GetAbility():GetSpecialValueFor("proc_chance"),INT_TYPE,1)  >=RandomInt(1, 100)) then
			return
		end
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(pfx1)
		ParticleManager:ReleaseParticleIndex(pfx2)
		-- parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		parent:EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")
		local dmg = self:GetAbility():GetSpecialValueFor("damage") + parent:GetStrength() * self:GetAbility():GetSpecialValueFor("bonus_damage")
		dmg = dmg*(1+caster.Middle_Counter_Helix_bonus_damage)
		local radius = self:GetAbility():GetSpecialValueFor("radius")+ math.min(caster.Middle_Counter_Helix_bonus_radius ,500)
		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i,enemy in pairs(enemies) do
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = dmg,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
		caster.Middle_Counter_Helix_bonus_damage = caster.Middle_Counter_Helix_bonus_damage+0.05
		caster.Middle_Counter_Helix_bonus_radius = caster.Middle_Counter_Helix_bonus_radius +10
		self:GetAbility():UseResources(true, true, true,true)
		Timers:CreateTimer(15, function()
			caster.Middle_Counter_Helix_bonus_damage = caster.Middle_Counter_Helix_bonus_damage-0.05
			caster.Middle_Counter_Helix_bonus_radius = caster.Middle_Counter_Helix_bonus_radius -10
		end)
	end
end
