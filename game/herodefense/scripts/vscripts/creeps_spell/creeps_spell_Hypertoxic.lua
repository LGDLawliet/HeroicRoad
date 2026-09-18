creeps_spell_Hypertoxic = class({})

LinkLuaModifier("modifier_creeps_spell_Hypertoxic_thinker", "creeps_spell/creeps_spell_Hypertoxic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Hypertoxic_debuff", "creeps_spell/creeps_spell_Hypertoxic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Hypertoxic", "creeps_spell/creeps_spell_Hypertoxic", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Hypertoxic:IsHiddenWhenStolen() 		return false end
function creeps_spell_Hypertoxic:IsRefreshable() 			return true end
function creeps_spell_Hypertoxic:IsStealable() 				return true end
function creeps_spell_Hypertoxic:IsNetherWardStealable()		return true end
function creeps_spell_Hypertoxic:GetIntrinsicModifierName() return "modifier_creeps_spell_Hypertoxic" end


modifier_creeps_spell_Hypertoxic = class({})

function modifier_creeps_spell_Hypertoxic:IsDebuff()			return false end
function modifier_creeps_spell_Hypertoxic:IsHidden() 			return true end
function modifier_creeps_spell_Hypertoxic:IsPurgable() 		    return false end
function modifier_creeps_spell_Hypertoxic:IsPurgeException() 	return false end
function modifier_creeps_spell_Hypertoxic:RemoveOnDeath()       return false end

function modifier_creeps_spell_Hypertoxic:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,} 
end

function modifier_creeps_spell_Hypertoxic:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then
        local pos = keys.unit:GetAbsOrigin()
        CreateModifierThinker(keys.unit, self:GetAbility(), "modifier_creeps_spell_Hypertoxic_thinker", 
        {duration = self:GetAbility():GetSpecialValueFor('duration')}, pos, keys.unit:GetTeamNumber(), false)
    end
end



modifier_creeps_spell_Hypertoxic_thinker = class({})

function modifier_creeps_spell_Hypertoxic_thinker:RemoveOnDeath() return true end

function modifier_creeps_spell_Hypertoxic_thinker:OnCreated()
    if IsServer() then
		local ability = self:GetAbility()
		self.damage_index = ability:GetSpecialValueFor("damage") * 0.01 
        self.radius = ability:GetSpecialValueFor("radius")
        self.damagetype = ability:GetAbilityDamageType()
        self:StartIntervalThink(0.5)
        local radius = ability:GetSpecialValueFor("radius")
        self.caster = ability:GetCaster()
        self.ability = ability
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_nethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
        ParticleManager:SetParticleControl(pfx, 3, Vector(radius, radius, radius))
		self:AddParticle(pfx, false, false, 15, false, false)
        self.team = self.caster:GetTeamNumber()

	end
end

function modifier_creeps_spell_Hypertoxic_thinker:OnIntervalThink()
	local caster = self.caster
    local ability = self.ability

	
	local enemy = FindUnitsInRadius(self.team, self:GetParent():GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      --不选中魔免的的单位
	
    for i=1, #enemy do
        local damageTable = {
            victim = enemy[i],
            attacker = caster,
            damage = self.damage_index * enemy[i]:GetMaxHealth()*0.5,
            damage_type = self.damagetype,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
            ability = nil, --Optional.
            }
        ApplyDamage(damageTable)
        enemy[i]:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Hypertoxic_debuff", {duration = 1})

	end
end



function modifier_creeps_spell_Hypertoxic_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

modifier_creeps_spell_Hypertoxic_debuff= class({})

function modifier_creeps_spell_Hypertoxic_debuff:IsDebuff()			   return true end
function modifier_creeps_spell_Hypertoxic_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Hypertoxic_debuff:IsPurgable() 	        return true end
function modifier_creeps_spell_Hypertoxic_debuff:IsPurgeException() 	return true end
function modifier_creeps_spell_Hypertoxic_debuff:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end--破坏被动
