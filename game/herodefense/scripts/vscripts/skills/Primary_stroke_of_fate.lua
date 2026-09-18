Primary_stroke_of_fate = class({})
LinkLuaModifier( "modifier_Primary_stroke_of_fate", "skills/Primary_stroke_of_fate", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function Primary_stroke_of_fate:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1(self:GetCaster())
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_grimstroke_2")
		if ability then
			if ability:IsCooldownReady() then
				ability:UseResources(true,true,true,true)
				local point = self:GetCursorPosition()
				self.phantom = ability:CreatePhantom(point)
				self.phantom:StartGesture(self:GetCastAnimation())
				self:PlayEffects1(self.phantom)
			end
		
		end
	end

	return true -- if success
end
function Primary_stroke_of_fate:OnAbilityPhaseInterrupted()
	self:StopEffects1()
	if self.phantom then
		local modifier = self.phantom:FindModifierByName("modifier_heroTalent_npc_dota_hero_grimstroke_2")
		if modifier then
			modifier:SafeDestroy()
		end
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_grimstroke_2")
		if ability then
			ability:EndCooldown()
		end
		self.phantom = nil
	end
end



function Primary_stroke_of_fate:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local spawnDelta = 150

	-- set up projectile
	local projectile_name = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf"
	local distance = self:GetCastRange( point, nil )
	local start_radius = 120
	local end_radius = 160
	local speed = 2400

	local spawnPos = caster:GetOrigin() + caster:GetRightVector()*(-spawnDelta)
	local direction = point-spawnPos
	direction.z = 0
	direction = direction:Normalized()
	self.base_damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)
	-- create linear projectile
	local info = {
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = spawnPos,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius =end_radius,
		vVelocity = direction * speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = false,

		EffectSound = "Hero_Grimstroke.DarkArtistry.Projectile",
		ProjectileSound = "Hero_Grimstroke.DarkArtistry.Projectile",
		SoundName = "Hero_Grimstroke.DarkArtistry.Projectile",
		Sound = "Hero_Grimstroke.DarkArtistry.Projectile",
		SoundEvent = "Hero_Grimstroke.DarkArtistry.Projectile",
	}
	local particle = ProjectileManager:CreateLinearProjectile(info)
	local bonus = 0
	local ability_talent = caster:FindAbilityByName("heroTalent_npc_dota_hero_grimstroke") 
	if ability_talent then
		local chance1 = ability_talent:GetSpecialValueFor("once_chance")
		local chance2 = ability_talent:GetSpecialValueFor("secend_chance")
		local chance3 = ability_talent:GetSpecialValueFor("third_chance")
		bonus = bonus + 1
		if self:GetCaster():GetRandomEffect(chance1,INT_TYPE,1) >=RandomInt(1, 100) then
			bonus = bonus + 1
			if self:GetCaster():GetRandomEffect(chance2,INT_TYPE,1) >=RandomInt(1, 100) then
				bonus = bonus + 1
				if self:GetCaster():GetRandomEffect(chance3,INT_TYPE,1) >=RandomInt(1, 100) then
					bonus = bonus + 1
				end
			end
		end
	end
	self.active_proj[particle] = {
		count = 0,
		bonus_count = 0,
		bonus_projectile = bonus,
		
	}
	-- effects
	local sound_cast1 = "Hero_Grimstroke.DarkArtistry.Cast"
	local sound_cast2 = "Hero_Grimstroke.DarkArtistry.Cast.Layer"
	-- local sound_cast_proj = "Hero_Grimstroke.DarkArtistry.Projectile"
	EmitSoundOn( sound_cast1, caster )
	EmitSoundOn( sound_cast2, caster )
	if self.phantom and not self.phantom:IsNull() then
		info.Source = self.phantom
		local spawnPos = self.phantom:GetOrigin() + self.phantom:GetRightVector()*(-spawnDelta)
		local direction = point-spawnPos
		direction.z = 0
		direction = direction:Normalized()
		info.vVelocity = direction * speed
		local particle2 = ProjectileManager:CreateLinearProjectile(info)
		local bonus = 0
		if ability_talent then
			bonus = bonus + 1
			if self:GetCaster():GetRandomEffect(chance1,INT_TYPE,1) >=RandomInt(1, 100) then
				bonus = bonus + 1
				if self:GetCaster():GetRandomEffect(chance2,INT_TYPE,1) >=RandomInt(1, 100) then
					bonus = bonus + 1
					if self:GetCaster():GetRandomEffect(chance3,INT_TYPE,1) >=RandomInt(1, 100) then
						bonus = bonus + 1
					end
				end
			end
		end
		self.active_proj[particle2] = {
			count = 0,
			bonus_count = 0,
			bonus_projectile = bonus,
			
		}
		-- local modifier = self.phantom:FindModifierByName("modifier_heroTalent_npc_dota_hero_grimstroke_2")
		-- if modifier then
		-- 	modifier:SafeDestroy()
		-- end
		self.phantom = nil
	end
end
--------------------------------------------------------------------------------
-- Projectile
Primary_stroke_of_fate.active_proj = {}
function Primary_stroke_of_fate:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		if not target then
			if self.active_proj[handle].bonus_projectile >0 then
				local start_radius = 120
				local end_radius = 160
				local speed = 2400
				local new_pos = location+ Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
				local direction = new_pos-location
				direction.z = 0
				local projectile_direction = direction:Normalized()
				local projectile_name = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf"
				local info = {
					
					Source = self:GetCaster(),
					Ability = self,
					vSpawnOrigin = location,
					
					bDeleteOnHit = false,
					
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					
					EffectName = projectile_name,
					fDistance = 1200,
					fStartRadius = start_radius,
					fEndRadius =end_radius,
					vVelocity = projectile_direction * speed,
				
					bHasFrontalCone = false,
					bReplaceExisting = false,
					
					bProvidesVision = false,
			
					EffectSound = "Hero_Grimstroke.DarkArtistry.Projectile",
					ProjectileSound = "Hero_Grimstroke.DarkArtistry.Projectile",
					SoundName = "Hero_Grimstroke.DarkArtistry.Projectile",
					Sound = "Hero_Grimstroke.DarkArtistry.Projectile",
					SoundEvent = "Hero_Grimstroke.DarkArtistry.Projectile",
				}
				local particle = ProjectileManager:CreateLinearProjectile(info)
				self.active_proj[particle] = {
					count = 0,
					bonus_count = 0,
					bonus_projectile = self.active_proj[handle].bonus_projectile-1,
				}
			end
			self.active_proj[handle] = nil
			return true
		end

		-- register new projectile
		if not self.active_proj[handle] then
			self.active_proj[handle] = {
				count = 0,
				bonus_count = 0
			}
		end

		-- get data
		local multiplier = self.active_proj[handle].count
		local base_damage = self.base_damage
		local plus_damage = self:GetSpecialValueFor( "bonus_damage_per_target" )*self:GetCaster():GetIntellect(false)
		local slow = self:GetSpecialValueFor( "slow_duration" )
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		-- damage
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = base_damage + math.min(multiplier, 20)*plus_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

		-- debuff
		target:AddNewModifier(self:GetCaster(), self,"modifier_Primary_stroke_of_fate",{	duration = slow*StatusResistance,} )

		-- add stack
		self.active_proj[handle].count = multiplier + 1

		-- play effects
		self:PlayEffects2( target )
	end
end

--------------------------------------------------------------------------------
function Primary_stroke_of_fate:PlayEffects1(target)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf"
	local sound_precast = "Hero_Grimstroke.DarkArtistry.PreCastPoint"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		Vector( 0,0,0 ), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_precast, target )
end
function Primary_stroke_of_fate:StopEffects1()
	-- stop effects
	local sound_precast = "Hero_Grimstroke.DarkArtistry.PreCastPoint"
	StopSoundOn( sound_precast, self:GetCaster() )
end

function Primary_stroke_of_fate:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg.vpcf"
	local sound_target = "Hero_Grimstroke.DarkArtistry.Damage"
	-- local sound_creep = "Hero_Grimstroke.DarkArtistry.Damage.Creep"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	-- if target:IsCreep() then
	-- 	EmitSoundOn( sound_creep, target )
	-- else
		EmitSoundOn( sound_target, target )
	-- end
end



modifier_Primary_stroke_of_fate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_stroke_of_fate:IsHidden()	return false end
function modifier_Primary_stroke_of_fate:IsDebuff()	return true end
function modifier_Primary_stroke_of_fate:IsStunDebuff()	return false end
function modifier_Primary_stroke_of_fate:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_stroke_of_fate:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" ) -- special value
end

function modifier_Primary_stroke_of_fate:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" ) -- special value	
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_stroke_of_fate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_Primary_stroke_of_fate:GetModifierMoveSpeedBonus_Constant()	return -self.slow end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_stroke_of_fate:GetEffectName()
	return "particles/units/heroes/hero_grimstroke/grimstroke_dark_artistry_debuff.vpcf"
end

function modifier_Primary_stroke_of_fate:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end