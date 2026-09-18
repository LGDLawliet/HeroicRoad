--特效优化 √
Advanced_stroke_of_fate = class({})
LinkLuaModifier( "modifier_Advanced_stroke_of_fate", "skills/Advanced_stroke_of_fate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stroke_of_fate_buff", "skills/Advanced_stroke_of_fate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stroke_of_fate_buff2", "skills/Advanced_stroke_of_fate", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_stroke_of_fate_debuff_unlock1", "skills/Advanced_stroke_of_fate", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_stroke_of_fate_buff_unlock3", "skills/Advanced_stroke_of_fate", LUA_MODIFIER_MOTION_NONE )
function Advanced_stroke_of_fate:UnlockFirstCore(key)
	return true
end
function Advanced_stroke_of_fate:UnlockSecondCore(key)
	return true
end
function Advanced_stroke_of_fate:UnlockThirdCore(key)
	self.unlock3_table = {}
	return true
end




-- function Advanced_stroke_of_fate:Precache( context )
-- 	-- PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning/lightning_rod/f_formation.vpcf", context )
-- 	-- PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning_aoe/arc_aoe.vpcf", context )
-- 	-- PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", context )
-- 	-- PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning_continued/arc_lightning.vpcf", context )
-- 	-- PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )

	
	
-- end




--------------------------------------------------------------------------------
-- Ability Phase Start
function Advanced_stroke_of_fate:CheckKV(key)
	local table = {
		damage=10,
		bonus_damage_per_target=0.01,
		bonus_damage=0.08,
	}
	local value = table[key] or -1
	return value

end
function Advanced_stroke_of_fate:Spawn()
	self.active_proj = {}
end
function Advanced_stroke_of_fate:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1(self:GetCaster())
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_grimstroke_2")
		if ability and ability:IsCooldownReady() then
			ability:UseResources(true,true,true,true)
			local point = self:GetCursorPosition()
			self.phantom = ability:CreatePhantom(point)
			self.phantom:StartGesture(self:GetCastAnimation())
			self:PlayEffects1(self.phantom)
		end
	end
	return true -- if success
end
function Advanced_stroke_of_fate:OnAbilityPhaseInterrupted()
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


function Advanced_stroke_of_fate:OnSpellStart()
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
	self.base_damage = self:GetSpecialValueFor("damage")+(self:GetSpecialValueFor("bonus_damage"))*self:GetCaster():GetIntellect(false)
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
	
	local split = 0 --分裂次数
	local bonus = 0 --连笔次数
	if self.advanced_level>=20 then
		bonus = 1
		if self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
			bonus = 2
		end
	elseif self.advanced_level>=15 and self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
		bonus = 1
	end
	if self.unlock2 then
		bonus = 5
		split = 1
	end
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
		split = split,
		center = point,

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
		local split = 0 --分裂次数
		local bonus = 0 --连笔次数
		if self.advanced_level>=20 then
			bonus = 1
			if self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
				bonus = 2
			end
		elseif self.advanced_level>=15 and self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
			bonus = 1
		end
		if self.unlock2 then
			bonus = 5
			split = 1
		end
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
			split = split,
			center = point,
	
		}
		self.phantom = nil
	end
end

function Advanced_stroke_of_fate:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		if not target then
			if self.active_proj[handle].bonus_projectile >0 then
				local split = self.active_proj[handle].split
				local center = self.active_proj[handle].center
				local start_radius = 120
				local end_radius = 160
				local speed = 2400
				local distance = 1200
				local new_pos = location+ Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
				if self.unlock2 and  CalculateDistance(center,location)>=1500 then
					new_pos = center
					distance =  CalculateDistance(center,location)
				end
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
					fDistance = distance,
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
					split = split - 1,
					center = center
				}


				if split>=1 then
					local new_pos = location+ Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
					local direction = new_pos-location
					direction.z = 0
					local projectile_direction = direction:Normalized()
					info.vVelocity = projectile_direction * speed
					local particle = ProjectileManager:CreateLinearProjectile(info)
					self.active_proj[particle] = {
						count = 0,
						bonus_count = 0,
						bonus_projectile = self.active_proj[handle].bonus_projectile-1,
						split = split - 1,
						center = center
					}
				end


			end
			self.active_proj[handle] = nil

			return true
		end


		local unlock3_damage = 1
		if self.unlock3 then
			local name = target:GetUnitName()
			self.unlock3_table[name] = self.unlock3_table[name] or 0
			self.unlock3_table[name] = math.min(800,self.unlock3_table[name]+1)
			unlock3_damage = 1+self.unlock3_table[name]*0.01
		end
		
		if self.active_proj[handle].bonus_count<5 then
			local modifier = target:FindModifierByName("modifier_stroke_of_fate_buff")
			if modifier then
				local reduce =0.1
				if self.advanced_level>=5 then
					reduce = 0.14
				end
				local stack = modifier:GetStackCount()
				local cooldown = self:GetCooldownTimeRemaining()
				self:EndCooldown()
				if cooldown-stack*reduce>0 then
					self:StartCooldown(cooldown-stack*reduce)
				end

				self.active_proj[handle].bonus_count = self.active_proj[handle].bonus_count +1
			end
		end
		

		-- get data
		local multiplier = self.active_proj[handle].count
		local base_damage = self.base_damage
		local plus_damage = (self:GetSpecialValueFor( "bonus_damage_per_target" ))*self:GetCaster():GetIntellect(false)
		local slow = self:GetSpecialValueFor( "slow_duration" )
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		-- damage
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage =( base_damage + math.min(multiplier, 20)*plus_damage)*unlock3_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

		-- debuff
		target:AddNewModifier(self:GetCaster(), self,"modifier_Advanced_stroke_of_fate",{	duration = slow*StatusResistance,} )
		target:AddNewModifier(self:GetCaster(), self,"modifier_stroke_of_fate_buff",{} )
		target:AddNewModifier(self:GetCaster(), self,"modifier_stroke_of_fate_buff2",{duration = RandomFloat(3, 4)} )
		if self.unlock1 then
			target:AddNewModifier(self:GetCaster(), self,"modifier_stroke_of_fate_debuff_unlock1",{duration = 2} )
			
		end
		-- add stack
		self.active_proj[handle].count = multiplier + 1

		-- play effects
		self:PlayEffects2( target )
	end
end


--------------------------------------------------------------------------------
function Advanced_stroke_of_fate:PlayEffects1(target)
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
	EmitSoundOn( sound_precast, self:GetCaster() )

	-- Create Sound
	EmitSoundOn( sound_precast, self:GetCaster() )
end
function Advanced_stroke_of_fate:StopEffects1()
	-- stop effects
	local sound_precast = "Hero_Grimstroke.DarkArtistry.PreCastPoint"
	StopSoundOn( sound_precast, self:GetCaster() )
end

function Advanced_stroke_of_fate:PlayEffects2( target )
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



modifier_Advanced_stroke_of_fate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_stroke_of_fate:IsHidden()	return false end
function modifier_Advanced_stroke_of_fate:IsDebuff()	return true end
function modifier_Advanced_stroke_of_fate:IsStunDebuff()	return false end
function modifier_Advanced_stroke_of_fate:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_stroke_of_fate:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" ) -- special value
end

function modifier_Advanced_stroke_of_fate:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" ) -- special value	
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_stroke_of_fate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_Advanced_stroke_of_fate:GetModifierMoveSpeedBonus_Constant()	return -self.slow end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_stroke_of_fate:GetEffectName()
	return "particles/units/heroes/hero_grimstroke/grimstroke_dark_artistry_debuff.vpcf"
end

function modifier_Advanced_stroke_of_fate:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end





modifier_stroke_of_fate_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_stroke_of_fate_buff:IsHidden()	return false end
function modifier_stroke_of_fate_buff:IsDebuff()	return true end
function modifier_stroke_of_fate_buff:IsStunDebuff()	return false end
function modifier_stroke_of_fate_buff:IsPurgable()	return false end
function modifier_stroke_of_fate_buff:GetTexture() return "grimstroke_dark_artistry" end
--------------------------------------------------------------------------------
-- Initializations
function modifier_stroke_of_fate_buff:OnCreated( kv )
	-- references
	self:IncrementStackCount()
end

function modifier_stroke_of_fate_buff:OnRefresh( kv )
	-- references
	if self:GetStackCount()<10 then
		self:IncrementStackCount()
	end
end






modifier_stroke_of_fate_buff2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_stroke_of_fate_buff2:IsHidden()	return false end
function modifier_stroke_of_fate_buff2:IsDebuff()	return true end
function modifier_stroke_of_fate_buff2:IsStunDebuff()	return false end
function modifier_stroke_of_fate_buff2:IsPurgable()	return false end
function modifier_stroke_of_fate_buff2:GetTexture() return "grimstroke_dark_artistry" end
--------------------------------------------------------------------------------
-- Initializations
function modifier_stroke_of_fate_buff2:OnCreated( kv )
	-- references
	if IsServer() then
		self.pos = self:GetParent():GetAbsOrigin()
	end
end

function modifier_stroke_of_fate_buff2:OnDestroy( kv )
	if IsServer() then

		local ability = self:GetAbility()
		if ability then
			local parent = self:GetParent()
			local caster = self:GetCaster()
			local pos = parent:GetAbsOrigin()
			local max = 5
			if ability.advanced_level>=10 then
				max = 8
			end
			local damage = math.min(CalculateDistance(pos,self.pos)/200,max)*caster:GetIntellect(false)
			local damageTable = {
				victim = parent,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability, --Optional.
			}
			ApplyDamage(damageTable)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj_endcap_top.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl( pfx, 3, pos )
			ParticleManager:ReleaseParticleIndex(pfx)
			local sound_target = "Hero_Grimstroke.DarkArtistry.Damage"
			EmitSoundOn( sound_target, parent )
			FindClearSpaceForUnit(parent, self.pos, false)
		end

		
	end
end

function modifier_stroke_of_fate_buff2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end









modifier_stroke_of_fate_debuff_unlock1 = advanced_modifier({})

function modifier_stroke_of_fate_debuff_unlock1:IsDebuff()			return true end
function modifier_stroke_of_fate_debuff_unlock1:IsHidden() 			return false end
function modifier_stroke_of_fate_debuff_unlock1:IsPurgable() 		return false end
function modifier_stroke_of_fate_debuff_unlock1:IsPurgeException() 	return false end
-- function modifier_stroke_of_fate_debuff_unlock1:IsMotionController() return true end
function modifier_stroke_of_fate_debuff_unlock1:RemoveOnDeath() return false end
function modifier_stroke_of_fate_debuff_unlock1:Advanced_GetModifierIncomingDamage_Percentage() 
    return 75
end



function modifier_stroke_of_fate_debuff_unlock1:OnRefresh(keys)
    if IsServer() then


        self:SetDuration(self:GetRemainingTime()+2, true)

	end
end


function modifier_stroke_of_fate_debuff_unlock1:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
