LinkLuaModifier("modifier_chaotic_shatter_rune_3", "chaotic_spell/class_2/chaotic_shatter", LUA_MODIFIER_MOTION_NONE)


chaotic_shatter = class({})






function chaotic_shatter:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_shatter/effect_cast/effect_rebuild.vpcf", context )

end
function chaotic_shatter:GetAOERadius()
	local range = self:GetSpecialValueFor("radius")
	if self:GetRuneType()==2 then
		range = self:GetSpecialValueFor("radius")*(1+self:GetSpecialValueFor("rune_2_radius")*0.01)
	end
	return range
end

function chaotic_shatter:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_shatter:GetBehavior()
	if self:GetRuneType()==2 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function chaotic_shatter:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetRuneType()==2 then
		self.pos = caster:GetAbsOrigin()
	else
		self.pos = self:GetCursorPosition()
	end

	local pos = self.pos
	self:PlayEffect(pos)

	if self:GetRuneType()==1 then
		local chance = self:GetSpecialValueFor("rune_1_chance")
		if caster:RollRandom(chance,1)  then
			self:PlayEffect(caster:GetAbsOrigin())
		end
	end
end

function chaotic_shatter:PlayEffect(pos)
	local caster = self:GetCaster()
	EmitSoundOnLocationWithCaster(pos, "chaotic_shatter_target", caster)
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_shatter/effect_cast/effect_rebuild.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(head_particle, 0, pos+Vector(0,0,64))
	ParticleManager:ReleaseParticleIndex(head_particle)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if self:GetRuneType()==3 then
		for _, unit in ipairs(enemies) do
			unit:AddNewModifier(caster, self, "modifier_chaotic_shatter_rune_3", {duration = self:GetSpecialValueFor("rune_3_duration")})
			unit:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.2})
			return
		end
	end

	local damageTable = {
		attacker	= self:GetCaster(),
		-- victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage_index"))*self:GetEffectGain(),
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
	}
	local kk_time = 0.2
	local kk_dis = self:GetSpecialValueFor("knockback_distance")
	if self:GetRuneType()==2 then
		kk_time = kk_time * (1+self:GetSpecialValueFor("rune_2_radius")*0.01)
		kk_dis  = kk_dis * (1+self:GetSpecialValueFor("rune_2_radius")*0.01)
	end
	local knockback =
	{
		knockback_duration = kk_time,
		duration = 0.2,
		knockback_distance = kk_dis,
		knockback_height = 50,
		center_x = pos.x,
		center_y = pos.y,
		center_z = pos.z,
	}

	for _, unit in ipairs(enemies) do
		unit:RemoveModifierByName("modifier_knockback")
		unit:AddNewModifier(caster, self, "modifier_knockback", knockback)	
		damageTable.victim = unit
		ApplyDamage(damageTable)

	end

end

------------------------------------------------------------------------------
modifier_chaotic_shatter_rune_3 = advanced_modifier({})

function modifier_chaotic_shatter_rune_3:IsDebuff()			return true end
function modifier_chaotic_shatter_rune_3:IsHidden() 		return true end
function modifier_chaotic_shatter_rune_3:IsPurgable() 		return false end
function modifier_chaotic_shatter_rune_3:IsPurgeException() return false end
function modifier_chaotic_shatter_rune_3:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_chaotic_shatter_rune_3:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_chaotic_shatter_rune_3:Advanced_GetModifierPhysicalArmorBonus()
	return -self:GetAbility():GetSpecialValueFor("rune_3_armor")
end
function modifier_chaotic_shatter_rune_3:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("rune_3_magicres")
end