Primary_Anchor_Smash = class({})

LinkLuaModifier( "modifier_Primary_Anchor_Smash_buff", "skills/Primary_Anchor_Smash", LUA_MODIFIER_MOTION_NONE )

function Primary_Anchor_Smash:OnSpellStart()
	local caster = self:GetCaster()

	-- get references
	local reduction_radius = self:GetSpecialValueFor("radius")
	local bonus_damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage_index")*caster:GetStrength()

	-- get list of affected enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		reduction_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	-- add buff modifier
	-- SUPPRESS_CLEAVE doesn't work yet
	local mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_Anchor_Smash_buff", -- modifier name
		{
			bonus = bonus_damage,
		} -- kv
	)
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	-- Do for each affected enemies
	for i,enemy in pairs(enemies) do
		-- Add reduction modifier

		-- attack
		caster:PerformAttack( enemy, true, true, true, true, false, false, true )
		if i>=8 then
			break
		end
	end

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	-- destroy modifier
	mod:SafeDestroy()

	self:PlayEffects()
end

function Primary_Anchor_Smash:PlayEffects()
	-- get resources
	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_rebuildhero.vpcf"
	local sound_cast = "Hero_Tidehunter.AnchorSmash"
	local radius = self:GetSpecialValueFor("radius")
	local index = radius/500

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(index,0,0))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius,0,0))
	ParticleManager:SetParticleControl( effect_cast, 62, Vector(radius-500,0,0))
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end






modifier_Primary_Anchor_Smash_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Anchor_Smash_buff:IsHidden()	return true end
function modifier_Primary_Anchor_Smash_buff:IsDebuff()	return false end
function modifier_Primary_Anchor_Smash_buff:IsPurgable()	return false end
function modifier_Primary_Anchor_Smash_buff:OnCreated( kv )
	if not IsServer() then return end
	self.bonus = kv.bonus
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Anchor_Smash_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_Primary_Anchor_Smash_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus
end

