
LinkLuaModifier( "modifier_Primary_Blade_Fury", "skills/Primary_Blade_Fury", LUA_MODIFIER_MOTION_NONE )

Primary_Blade_Fury = class({})

--------------------------------------------------------------------------------
function Primary_Blade_Fury:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function Primary_Blade_Fury:OnSpellStart()
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(0.2)
	local bDuration = self:GetSpecialValueFor("duration")*gain

	caster:AddNewModifier(
		caster,
		self, 
		"modifier_Primary_Blade_Fury",
		{ duration = bDuration }
	)
end
-------------------------------------------------------------------------------
modifier_Primary_Blade_Fury = advanced_modifier({})


function modifier_Primary_Blade_Fury:IsHidden()	return false end
function modifier_Primary_Blade_Fury:IsDebuff()	return false end
function modifier_Primary_Blade_Fury:IsPurgable()	return false end

function modifier_Primary_Blade_Fury:OnCreated( kv )
	if IsServer() then
		self.tick = self:GetAbility():GetSpecialValueFor( "interval" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.max = self:GetAbility():GetSpecialValueFor( "max" )

		self:StartIntervalThink( self.tick )
		self:PlayEffects()
	end
end

function modifier_Primary_Blade_Fury:OnRefresh( kv )
	if IsServer() then
		self.tick = self:GetAbility():GetSpecialValueFor( "interval" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.max = self:GetAbility():GetSpecialValueFor( "max" )
	end
end

function modifier_Primary_Blade_Fury:OnDestroy( kv )
	local sound_cast = "Hero_Juggernaut.BladeFuryStart"
	StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_Primary_Blade_Fury:OnIntervalThink()
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self:Fury(self.radius,self.max)
end

-- 单次风暴执行
function modifier_Primary_Blade_Fury:Fury(radius,max)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	local radius = radius
	if self.effect then
		ParticleManager:SetParticleControl( self.effect, 5, Vector( radius, 0, 0 ) )
	end
	local max = max
	local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
	}
	local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false
	)
	
	local i = 0
	for _ , enemy in pairs(enemies) do
		parent:PerformAttack(enemy, true, true, true, true, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
		self:PlayEffects2( enemy )
		i = i + 1 
		if i >= max then
			break
		end
	end

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end

function modifier_Primary_Blade_Fury:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	return state
end

function modifier_Primary_Blade_Fury:PlayEffects()
	local particle_cast = "particles/econ/items/juggernaut/jugg_sword_shred/juggernaut_blade_fury_shred.vpcf"
	local sound_cast = "Hero_Juggernaut.BladeFuryStart"

	self.effect = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect, 5, Vector( self.radius, 0, 0 ) )

	self:AddParticle(
		self.effect,
		false,
		false,
		-1,
		false,
		false
	)
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_Primary_Blade_Fury:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end