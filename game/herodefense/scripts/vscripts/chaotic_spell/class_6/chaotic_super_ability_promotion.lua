LinkLuaModifier("modifier_chaotic_super_ability_promotion", "chaotic_spell/class_6/chaotic_super_ability_promotion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_super_ability_promotion_rune2", "chaotic_spell/class_6/chaotic_super_ability_promotion", LUA_MODIFIER_MOTION_NONE)
chaotic_super_ability_promotion = class({})
function chaotic_super_ability_promotion:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_super_ability_promotion/eff_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_super_ability_promotion/eff_light.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_super_ability_promotion/eff_particle.vpcf.vpcf", context )
end

function chaotic_super_ability_promotion:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function chaotic_super_ability_promotion:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function chaotic_super_ability_promotion:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetToggleState() then
		if self:GetRuneType() == 1 then
			duration = duration + self:GetSpecialValueFor("rune_1_duration")
		end
		if self:GetRuneType() == 2 then
			duration = -1
			caster:AddNewModifier(caster, self, "modifier_chaotic_super_ability_promotion_rune2", {duration = duration})
		end
		caster:AddNewModifier(caster, self, "modifier_chaotic_super_ability_promotion", {duration = duration})

		local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_super_ability_promotion/eff_crit.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControlEnt(effect_cast1, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(effect_cast1)
		caster:EmitSound("chaotic_ability_promotion_cast")
	else
		if self:GetRuneType() == 2 then
			caster:RemoveModifierByName("modifier_chaotic_super_ability_promotion_rune2")
		end
		caster:RemoveModifierByName("modifier_chaotic_super_ability_promotion")
		caster:EmitSound("Hero_Axe.Battle_Hunger")
	end
	
end

modifier_chaotic_super_ability_promotion = advanced_modifier({})

function modifier_chaotic_super_ability_promotion:IsHidden() return false end
function modifier_chaotic_super_ability_promotion:IsPurgable() return false end
function modifier_chaotic_super_ability_promotion:IsDebuff() return false end

function modifier_chaotic_super_ability_promotion:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.all_attribute_bonus = self.ability:GetSpecialValueFor("all_attribute_bonus")
	self.bonus_spell_damage = self.ability:GetSpecialValueFor("bonus_spell_damage")
	self.cooldown_time_mul = self.ability:GetSpecialValueFor("cooldown_time_mul")*0.01

	self.type = self.ability:GetRuneType()
	self.rune_2_cd_max = self.ability:GetSpecialValueFor("rune_2_cd_max")
	if self.type == 1 then
		self:StartIntervalThink(self.ability:GetSpecialValueFor("duration"))
	end
	
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_super_ability_promotion/eff_light.vpcf", PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, -1, false, false)
		local effect_particle = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_super_ability_promotion/eff_particle.vpcf.vpcf", PATTACH_CUSTOMORIGIN, self.parent )
		ParticleManager:SetParticleControlEnt(effect_particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(effect_particle, false, false, -1, false, false)

	end
end


function modifier_chaotic_super_ability_promotion:OnIntervalThink()
	self:StartIntervalThink(-1)
	local caster = self:GetCaster()
	self.all_attribute_bonus = self.all_attribute_bonus * (1+0.01*self:GetAbility():GetSpecialValueFor("rune_1_bonus"))
	self.bonus_spell_damage = self.bonus_spell_damage * (1+0.01*self:GetAbility():GetSpecialValueFor("rune_1_bonus"))

	if IsServer() then
		
		self.trigger_rune1 = true
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ability_promotion/unrivaled_ambient.vpcf", PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, -1, false, false)
		caster:EmitSound("chaotic_ability_promotion_start")
		caster:EmitSound("chaotic_ability_promotion_cast")
	end
end

function modifier_chaotic_super_ability_promotion:OnDestroy()

	if not IsServer() then
		return
	end
	local time = (GameRules:GetGameTime()-self:GetCreationTime()) * self.cooldown_time_mul
	if self.trigger_rune1 then
		time = time * (1+0.01*self.ability:GetSpecialValueFor("rune_1_cooldown"))
	end
	if self.type == 2 then
		time = math.min(time,self.rune_2_cd_max)
	end
	self.ability:StartCooldown(time)

	if self.ability:GetToggleState() then
		self.ability:ToggleAbility()
	end

end

function modifier_chaotic_super_ability_promotion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_chaotic_super_ability_promotion:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.all_attribute_bonus
	end
	if self._tooltip == 2 then
		return self.bonus_spell_damage
	end

end

function modifier_chaotic_super_ability_promotion:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_chaotic_super_ability_promotion:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self.bonus_spell_damage
end

function modifier_chaotic_super_ability_promotion:Advanced_GetModifierBonusStats_Strength()	
	return self.all_attribute_bonus
end
function modifier_chaotic_super_ability_promotion:Advanced_GetModifierBonusStats_Agility()	
	return self.all_attribute_bonus
end
function modifier_chaotic_super_ability_promotion:Advanced_GetModifierBonusStats_Intellect()	
	return self.all_attribute_bonus
end
-----
modifier_chaotic_super_ability_promotion_rune2 = advanced_modifier({})

function modifier_chaotic_super_ability_promotion_rune2:IsHidden() return true end
function modifier_chaotic_super_ability_promotion_rune2:IsPurgable() return false end
function modifier_chaotic_super_ability_promotion_rune2:IsDebuff() return false end
function modifier_chaotic_super_ability_promotion_rune2:OnCreated()
	self.ability = self:GetAbility()
	self.rune_2_hpmp_cost = self.ability:GetSpecialValueFor("rune_2_hpmp_cost")*0.01
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_chaotic_super_ability_promotion_rune2:OnIntervalThink()
	if not self:GetAbility() then self:Destory() return end
	local parent = self:GetParent()
	
	parent:ModifyHealth(parent:GetHealth()-parent:GetMaxHealth()*self.rune_2_hpmp_cost*0.5, self:GetAbility(), false, 0)
	parent:Script_ReduceMana(parent:GetMaxMana()*self.rune_2_hpmp_cost*0.5, self:GetAbility())
end