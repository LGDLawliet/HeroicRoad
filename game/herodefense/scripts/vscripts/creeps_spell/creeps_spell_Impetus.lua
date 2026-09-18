
creeps_spell_Impetus = class({})

LinkLuaModifier("modifier_creeps_spell_Impetus", "creeps_spell/creeps_spell_Impetus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Impetus_orb", "creeps_spell/creeps_spell_Impetus", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------
function creeps_spell_Impetus:IsHiddenWhenStolen() 		  return false end
function creeps_spell_Impetus:IsRefreshable() 			  return true end
function creeps_spell_Impetus:IsStealable() 				return false end
function creeps_spell_Impetus:IsNetherWardStealable() 	return false end
--下为自动施法
function creeps_spell_Impetus:GetIntrinsicModifierName() return "modifier_creeps_spell_Impetus_orb" end

function creeps_spell_Impetus:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) end
	Attack_SOUND = {
		"enchantress_ench_ability_impetus_01",
		"enchantress_ench_ability_impetus_02",
		"enchantress_ench_ability_impetus_03",
		"enchantress_ench_ability_impetus_04",
		"enchantress_ench_ability_impetus_05",
		"enchantress_ench_ability_impetus_06",
		"enchantress_ench_ability_impetus_07",

	}

function creeps_spell_Impetus:OnProjectileHit(target, location)
	if not target then
		return
	end
	if target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()
	local dis= GetDistanceBetweenTwoUnit(caster,target)
	if RandomInt(0, 99) < self:GetSpecialValueFor("bonus_chance") then
		dis = dis + self:GetSpecialValueFor("bonua_range_in_damage")
		local pfx = ParticleManager:CreateParticle("particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas_n.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
		caster:EmitSound(Attack_SOUND[RandomInt(1, 7)])
		
	end
	local damage = dis * (self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("intelligence_index") * caster:GetBaseDamageMax()) *0.01
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = self, --Optional.
		}
	ApplyDamage(damageTable)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Enchantress.ImpetusDamage", target)
end


modifier_creeps_spell_Impetus_orb = class({})

function modifier_creeps_spell_Impetus_orb:IsDebuff()			return false end
function modifier_creeps_spell_Impetus_orb:IsHidden() 			return true end
function modifier_creeps_spell_Impetus_orb:IsPurgable() 		return false end
function modifier_creeps_spell_Impetus_orb:IsPurgeException() 	return false end

function modifier_creeps_spell_Impetus_orb:Advanced_GetModifierAttackRangeBonus() return self:GetAbility():GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("bonua_range") end

function modifier_creeps_spell_Impetus_orb:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

function modifier_creeps_spell_Impetus_orb:OnCreated()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_creeps_spell_Impetus_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
	end
end
function modifier_creeps_spell_Impetus_orb:DeclareFunctions()
	 return 
	 {MODIFIER_EVENT_ON_ATTACK,
	  MODIFIER_EVENT_ON_ATTACK_LANDED,} end
function modifier_creeps_spell_Impetus_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsSilenced() or self:GetParent():IsIllusion()
	 or not self:GetAbility():IsCooldownReady()  then
		return
	end
	self:SetStackCount(1)
	self:GetParent():StartGesture(ACT_DOTA_ATTACK2)
	self:GetAbility():UseResources(true, true, true,true)
end
function modifier_creeps_spell_Impetus_orb:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() then
		return
	end
	if self:GetStackCount() ~= 1 then
		return
	end
	if keys.damage<=0 then
		return
	end
	self:SetStackCount(0)
	self:GetAbility():OnProjectileHit(keys.target, keys.target:GetAbsOrigin())
end

--------------------------------------------------------------------------------


