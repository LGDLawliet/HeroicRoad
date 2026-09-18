LinkLuaModifier("modifier_chaotic_weakness_perception", "chaotic_spell/class_3/chaotic_weakness_perception", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_weakness_perception_debuff", "chaotic_spell/class_3/chaotic_weakness_perception", LUA_MODIFIER_MOTION_NONE)

chaotic_weakness_perception = chaotic_weakness_perception or class({})

function chaotic_weakness_perception:GetIntrinsicModifierName()return "modifier_chaotic_weakness_perception" end

function chaotic_weakness_perception:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_weakness_perception/eff_debuff_all.vpcf", context )
end

modifier_chaotic_weakness_perception = advanced_modifier({})

function modifier_chaotic_weakness_perception:IsPurgable() 		return false end
function modifier_chaotic_weakness_perception:IsPurgeException() 	return false end
function modifier_chaotic_weakness_perception:IsHidden() return true end

function modifier_chaotic_weakness_perception:OnCreated()
	if not IsServer() then
		return
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.duration = self.ability:GetSpecialValueFor("duration")
	
	self:StartIntervalThink(0.5)
end

function modifier_chaotic_weakness_perception:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self.ability:IsCooldownReady() then
		return
	end
	if self.parent:PassivesDisabled() then
		return
	end
	self.ability:UseResources(true, true, true, true)
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), 
		self.parent:GetAbsOrigin(), 
		nil, 
		self.radius , 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER,
		false
	)
	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(1)
	local pass = false
	for _, unit in ipairs(enemies) do
		local chance = self.chance * (2-unit:GetHealthPercent()*0.01)
		if RandomFloat(1, 100) <= chance then
			local StatusResistance = unit:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
			unit:AddNewModifier(self.parent, self.ability, "modifier_chaotic_weakness_perception_debuff", {duration = self.duration * StatusResistance})
			pass = true
		end
	end
	if pass then
		self:GetParent():EmitSound("Hero_Hoodwink.Boomerang.Cast")
		if self:GetAbility():GetRuneType() == 1 then
			local chance = self:GetAbility():GetSpecialValueFor("rune_1_chance")
			if chance >= math.random(1,100) then
				self:GetAbility():EndCooldown()
			end
		end
	end

end

modifier_chaotic_weakness_perception_debuff = modifier_chaotic_weakness_perception_debuff or advanced_modifier({})

function modifier_chaotic_weakness_perception_debuff:IsHidden() return false end
function modifier_chaotic_weakness_perception_debuff:IsDebuff()return true end
function modifier_chaotic_weakness_perception_debuff:IsPurgable()return false end
function modifier_chaotic_weakness_perception_debuff:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_weakness_perception/eff_debuff_all.vpcf" end

function modifier_chaotic_weakness_perception_debuff:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- if IsServer() then
	-- 	self:GetParent():EmitSound("Hero_Hoodwink.Boomerang.Cast")
	-- end
end

function modifier_chaotic_weakness_perception_debuff:OnRefresh(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- if IsServer() then
	-- 	self:GetParent():EmitSound("Hero_Hoodwink.Boomerang.Cast")
	-- end
end

function modifier_chaotic_weakness_perception_debuff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_chaotic_weakness_perception_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker == self.caster then
		return self.bonus_damage
	end
	return 0
end

function modifier_chaotic_weakness_perception_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_weakness_perception_debuff:OnTooltip() 
    return self.bonus_damage
end