LinkLuaModifier("modifier_chaotic_ability_promotion", "chaotic_spell/class_4/chaotic_ability_promotion", LUA_MODIFIER_MOTION_NONE)

chaotic_ability_promotion = class({})
function chaotic_ability_promotion:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ability_promotion/eff_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ability_promotion/unrivaled_ambient.vpcf", context )
end

function chaotic_ability_promotion:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function chaotic_ability_promotion:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function chaotic_ability_promotion:OnToggle()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetToggleState() then
		
		if self:GetRuneType()==1 then
			duration = duration + self:GetSpecialValueFor("rune_1_duration")
		end
		caster:AddNewModifier(caster, self, "modifier_chaotic_ability_promotion", {duration = duration})
		
		caster:EmitSound("chaotic_ability_promotion_start")
		caster:EmitSound("chaotic_ability_promotion_cast")

		local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_ability_promotion/eff_crit.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControlEnt(effect_cast1, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(effect_cast1)

		
		
	else

		caster:RemoveModifierByName("modifier_chaotic_ability_promotion")
		caster:EmitSound("Hero_Axe.Battle_Hunger")
	end
	
end

modifier_chaotic_ability_promotion = advanced_modifier({})

function modifier_chaotic_ability_promotion:IsHidden() return false end
function modifier_chaotic_ability_promotion:IsPurgable() return false end
function modifier_chaotic_ability_promotion:IsDebuff() return false end

function modifier_chaotic_ability_promotion:OnCreated()

	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.all_attribute_bonus = self.ability:GetSpecialValueFor("all_attribute_bonus")
	
	if self.ability:GetRuneType()==1 then
		self:StartIntervalThink(self.ability:GetSpecialValueFor("duration"))
	end
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ability_promotion/unrivaled_ambient.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, -1, false, false)
	end

end
function modifier_chaotic_ability_promotion:OnIntervalThink()
	self:StartIntervalThink(-1)
	local caster = self:GetCaster()
	self.all_attribute_bonus = self.all_attribute_bonus * (1+0.01*self:GetAbility():GetSpecialValueFor("rune_1_bonus"))
	
	if IsServer() then
		
		self.trigger_rune1 = true
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ability_promotion/unrivaled_ambient.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, -1, false, false)
		caster:EmitSound("chaotic_ability_promotion_start")
		caster:EmitSound("chaotic_ability_promotion_cast")
	end
end
function modifier_chaotic_ability_promotion:OnDestroy()

	if not IsServer() then
		return
	end

	if not IsValid(self.ability) then
		return
	end
	local time = (GameRules:GetGameTime()-self:GetCreationTime()) * self.ability:GetSpecialValueFor("cooldown_time_mul")
	if self.trigger_rune1 then
		time = time * (1+0.01*self.ability:GetSpecialValueFor("rune_1_cooldown"))
	end
	self.ability:StartCooldown(time)
	-- self.ability:StartCooldown()

	if self.ability:GetToggleState() then
		self.ability:ToggleAbility()
	end

end

function modifier_chaotic_ability_promotion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	} 
end

function modifier_chaotic_ability_promotion:OnTooltip() 

    return self.all_attribute_bonus

end

function modifier_chaotic_ability_promotion:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_chaotic_ability_promotion:Advanced_GetModifierBonusStats_Strength()	
	return self.all_attribute_bonus
end
function modifier_chaotic_ability_promotion:Advanced_GetModifierBonusStats_Agility()	
	return self.all_attribute_bonus
end
function modifier_chaotic_ability_promotion:Advanced_GetModifierBonusStats_Intellect()	
	return self.all_attribute_bonus
end