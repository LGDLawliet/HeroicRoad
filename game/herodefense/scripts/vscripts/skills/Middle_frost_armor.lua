

LinkLuaModifier( "modifier_Middle_frost_armor_buff", "skills/Middle_frost_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_frost_armor_debuff", "skills/Middle_frost_armor", LUA_MODIFIER_MOTION_NONE )

Middle_frost_armor = class({})

--------------------------------------------------------------------------------
-- Ability Start
function Middle_frost_armor:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	local gain = caster:GetModifierDurationGainIndex(1)
	-- local bonus_regen = math.max(target:GetMaxHealth()*0.02,50)
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_frost_armor_buff", -- modifier name
		{ duration = duration*gain } -- kv
	)

	-- effects
	local sound_cast = "Hero_Lich.FrostArmor"
	EmitSoundOn( sound_cast, self:GetCaster() )
end




modifier_Middle_frost_armor_buff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_frost_armor_buff:IsHidden()	return false end
function modifier_Middle_frost_armor_buff:IsDebuff()	return false end
function modifier_Middle_frost_armor_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_INVULNERABLE 
end

function modifier_Middle_frost_armor_buff:IsPurgable()	return true end



--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_frost_armor_buff:OnCreated( kv )
	-- references
	self.damage_reduce = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )
	self.regen = math.max(self:GetParent():GetMaxHealth()*0.02,50)
	if IsServer() then
		self:StartIntervalThink(1)
		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0,parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(radius,radius,radius), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
	

end

function modifier_Middle_frost_armor_buff:OnRefresh( kv )
	-- references
	self.damage_reduce = -self:GetAbility():GetSpecialValueFor( "damage_reduce" )


	
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_frost_armor_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		
	}

	return funcs
end


function modifier_Middle_frost_armor_buff:GetModifierIncomingPhysicalDamage_Percentage(keys)
	if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
		return self.damage_reduce
	end
	return 0
end


function modifier_Middle_frost_armor_buff:AdvancedGetModifierConstantHealthRegen(keys)
	
	return self.regen
end


function modifier_Middle_frost_armor_buff:OnIntervalThink()
	local pos = self:GetParent():GetAbsOrigin()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	local radius = ability:GetSpecialValueFor("radius")
	caster:EmitSound("Hero_Lich.IceAge.Tick")
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex( effect_cast )
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	 DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	 local damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
	for _, enemy in pairs(enemies) do
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, ability, "modifier_Middle_frost_armor_debuff", {duration = ability:GetSpecialValueFor( "slow_duration" )*StatusResistance})
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
							}
		ApplyDamage(damageTable)

	end
end

function modifier_Middle_frost_armor_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,


    }
end




modifier_Middle_frost_armor_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_frost_armor_debuff:IsHidden()	return false end
function modifier_Middle_frost_armor_debuff:IsDebuff()	return true end
function modifier_Middle_frost_armor_debuff:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_frost_armor_debuff:OnCreated( kv )
	self.move_slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
end




--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_frost_armor_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Middle_frost_armor_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.move_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_frost_armor_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end