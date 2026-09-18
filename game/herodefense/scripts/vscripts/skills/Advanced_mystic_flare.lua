--特效优化 √
Advanced_mystic_flare =  Advanced_mystic_flare or class({})
LinkLuaModifier( "modifier_Advanced_mystic_flare_thinker", "skills/Advanced_mystic_flare", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Advanced_mystic_flare_unlock2_thinker", "skills/Advanced_mystic_flare", LUA_MODIFIER_MOTION_NONE )

function Advanced_mystic_flare:CheckKV(key)
	local table = {
		damage = 40,
		bonus_damage = 0.3,
	}
	local value = table[key] or -1
	return value
end
function Advanced_mystic_flare:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Nature_Attendants_unlock1",{})
	return true
end
function Advanced_mystic_flare:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_mystic_flare:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Nature_Attendants_unlock3",{})
	return true
end


function Advanced_mystic_flare:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/mystic_flare/main_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/talent/skywrath_mage_2/effect_ambient_hit.vpcf", context )



	
end

function Advanced_mystic_flare:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function Advanced_mystic_flare:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	-- local radius = self:GetSpecialValueFor( "radius" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_mystic_flare_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	-- play effects
	local sound_cast = "Hero_SkywrathMage.MysticFlare.Cast"
	EmitSoundOn( sound_cast, caster )

	-- -- scepter effect
	-- if caster:HasScepter() then
	-- 	local scepter_radius = self:GetSpecialValueFor( "scepter_radius" )
		
	-- 	-- find nearby enemies
	-- 	local enemies = FindUnitsInRadius(
	-- 		caster:GetTeamNumber(),	-- int, your team number
	-- 		point,	-- point, center point
	-- 		nil,	-- handle, cacheUnit. (not known)
	-- 		scepter_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	-- 		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
	-- 		0,	-- int, order filter
	-- 		false	-- bool, can grow cache
	-- 	)

	-- 	local target = nil
	-- 	local creep = nil
	-- 	-- prioritize hero
	-- 	for _,enemy in pairs(enemies) do
	-- 		-- only enemies outside cast aoe
	-- 		if (enemy:GetOrigin()-point):Length2D()>radius then
	-- 			if enemy:IsHero() then
	-- 				target = enemy
	-- 				break
	-- 			elseif not creep then
	-- 				-- store first found creep
	-- 				creep = enemy
	-- 			end
	-- 		end
	-- 	end
	-- 	-- no secondary hero found, find creep
	-- 	if not target then
	-- 		target = creep
	-- 	end

	-- 	if target then
	-- 		-- create thinker
	-- 		CreateModifierThinker(
	-- 			caster, -- player source
	-- 			self, -- ability source
	-- 			"modifier_Advanced_mystic_flare_thinker", -- modifier name
	-- 			{ duration = duration }, -- kv
	-- 			target:GetOrigin(),
	-- 			caster:GetTeamNumber(),
	-- 			false
	-- 		)
	-- 	end
	-- end
end








modifier_Advanced_mystic_flare_thinker = modifier_Advanced_mystic_flare_thinker or  class({})

function modifier_Advanced_mystic_flare_thinker:OnCreated( keys )
	local ability = self:GetAbility()
	local interval = ability:GetSpecialValueFor( "damage_interval" )
	self.damage = ability:GetSpecialValueFor( "damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	self.radius = ability:GetSpecialValueFor( "radius" )

	if IsServer() then
		if ability.advanced_level>=5 then
			self.lv5 = true
			if ability.advanced_level>=10 then
				self.lv10 = true
				if ability.advanced_level>=15 then
					self.lv15 = true
					if ability.advanced_level>=20 then
						self.lv20  =true
						self.lv20_radius = self.radius
						self.radius = self.radius + 300
					end
				end
			end
		end

		self.damage = self.damage*interval/keys.duration
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
			-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}

		-- Start interval


		self.duration = keys.duration
		self.interval = interval
		-- play effects
		

		self.origin_damage= self.damage
		self.origin_radius = self.radius
		self.radius_index = 1
		self.damage_index = 1

		self.lv15_count = 0

		self:PlayEffects( self.radius, keys.duration, interval )

		self.normal_timer = GameRules:GetGameTime()
		self.lv20_timer = GameRules:GetGameTime()


		self.unlock2_timer = GameRules:GetGameTime()
		if ability.unlock2 then
			self.unlock2_start_time= GameRules:GetGameTime()
			self.unlock2 = true
			self.unlock2_particle = {}
			self:PlayEffectsUnlock2()
		end




		self:StartIntervalThink( 0.03 )
		self:OnIntervalThink()
	end
end


function modifier_Advanced_mystic_flare_thinker:OnDestroy()
	if IsServer() then
		if self.unlock2 then
			self:RemoveUnlock2Particle()
		end
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_mystic_flare_thinker:OnIntervalThink()

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local time = GameRules:GetGameTime()
	if time>=self.normal_timer then
		self.normal_timer = self.normal_timer + self.interval
		local gain_chance = ability:GetSpecialValueFor("gain_chance")
		local gain_radius_up = ability:GetSpecialValueFor("gain_radius_up")*0.01
		local gain_damage_up = ability:GetSpecialValueFor("gain_damage_up")*0.01
		if self.lv10 then
			gain_chance = ability:GetSpecialValueFor("gain_chance") + 11
			gain_radius_up = ability:GetSpecialValueFor("gain_radius_up")*0.01 + 0.03
			gain_damage_up = ability:GetSpecialValueFor("gain_damage_up")*0.01 + 0.02
		end

		
		if caster:GetRandomEffect(gain_chance,INT_TYPE,1)  > RandomInt(1, 100) then
			self.radius_index = self.radius_index + gain_radius_up
			self.damage_index = self.damage_index + gain_damage_up

			self.radius = self.origin_radius * self.radius_index
			self.damage = self.origin_damage * self.damage_index
			self:ModifyEffect1(self.radius,self.duration,self.interval)
			if self.lv15 then
				self:LV15Effect()
			end
		end


		local pos = self:GetParent():GetOrigin()
		local range = self.radius*0.7
		self:PlayEffectsHit( pos + Vector(RandomInt(-range, range),RandomInt(-range, range),0) )


		-- find heroes
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),
			pos,
			nil,	
			self.radius,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,	
			DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC,	
			0,	
			0,	
			false	
		)


		
		local count = #units
		if count<1 then return end
		count = math.min(count,3)
		local chance = self:GetAbility():GetSpecialValueFor("alone_chance") + 1
		if self.lv5 then
			chance = self:GetAbility():GetSpecialValueFor("alone_chance") + 11
		end
		if caster:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
			self.damageTable.damage = self.damage
			if self.lv15 then
				self:LV15Effect()
			end
		else
			self.damageTable.damage = self.damage/count
		end
		
		for i,unit in pairs(units) do
			self.damageTable.victim = unit
			ApplyDamage( self.damageTable )
			if i>=count then
				break			
			end
		end
	end

	if self.lv20 and time>=self.lv20_timer then
		self.lv20_timer = self.lv20_timer + 0.1
		local count = 1
		local index = self.radius/self.lv20_radius
		if index>=6 then
			count = 2
			if index>=12 then
				count = 3
			end
		end
		for i = 1, count, 1 do
			local pos = self:GetParent():GetOrigin()
			local range = self.radius*0.7
			local new_pos = pos + Vector(RandomInt(-range, range),RandomInt(-range, range),0)
			self:PlayEffectsHit( new_pos )
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(),
				new_pos,
				nil,	
				self.lv20_radius,	
				DOTA_UNIT_TARGET_TEAM_ENEMY,	
				DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC,	
				0,	
				0,	
				false	
			)
			self.damageTable.damage = self.damage
			for i,unit in pairs(units) do
				self.damageTable.victim = unit
				ApplyDamage( self.damageTable )
				break
			end
		end
		
	end
	
	if self.unlock2 then
		self:RotateUnlock2Particle()
		if time>=self.unlock2_timer then
			self.unlock2_timer = self.unlock2_timer +0.4
			local pos = self:GetParent():GetOrigin()
			local units = FindUnitsInRadius(
			caster:GetTeamNumber(),
			pos,
			nil,	
			170,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,	
			DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC,	
			0,	
			0,	
			false	
			)


			
			self.damageTable.damage = self.damage*3
			
			for i,unit in pairs(units) do
				self.damageTable.victim = unit
				ApplyDamage( self.damageTable )
			end
		end
	end
end


function modifier_Advanced_mystic_flare_thinker:PlayEffects( radius, duration, interval )

	local particle_cast = "particles/rebuild/spell/mystic_flare/main_effect/effect.vpcf"
	local sound_cast = "Hero_SkywrathMage.MysticFlare"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, duration, interval ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_Advanced_mystic_flare_thinker:ModifyEffect1(radius,duration,interval)
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, duration, interval ) )
end


function modifier_Advanced_mystic_flare_thinker:PlayEffectsHit( pos )

	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf"
	local sound_cast = "Hero_ElderTitan.AncestralSpirit.Damage"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_Advanced_mystic_flare_thinker:LV15Effect()
	--unlock1 效果
	local ability = self:GetAbility()
	if ability.unlock1 then
		if self.lv15_count>=60 then
			return
		end
		self.lv15_count = self.lv15_count + 1
		self:SetDuration(self:GetRemainingTime()+0.33, false)
		self.duration = self.duration +0.33
		self:ModifyEffect1(self.radius,self.duration,self.interval)
		return
	end

	if self.lv15_count>=20 then
		return
	end

	local caster = self:GetCaster()
	local chance = 41

	if caster:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
		self.lv15_count = self.lv15_count + 1
		self:SetDuration(self:GetRemainingTime()+0.33, false)
		self.duration = self.duration +0.33
		self:ModifyEffect1(self.radius,self.duration,self.interval)
		if ability.unlock3 then
			if not ability:IsCooldownReady() then
				local cooldown = ability:GetCooldownTimeRemaining()
				ability:EndCooldown()
				ability:StartCooldown(cooldown*0.82)
				return
			end
		end
	end
end


function modifier_Advanced_mystic_flare_thinker:PlayEffectsUnlock2( )

	local particle_cast = "particles/rebuild/talent/skywrath_mage_2/effect_ambient_hit.vpcf"
	local parent = self:GetParent()
	local center_pos = parent:GetOrigin()
	local particle_count = 12
	local currentRotationAngle = 0
	local rotationAngleOffset	= 360 / particle_count
	local radius = self.lv20_radius*0.7
	for i = 1, particle_count, 1 do
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )

		local rotationAngle = currentRotationAngle - rotationAngleOffset * (i - 1)
		local relPos 		= Vector(0, radius, 0)
		relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
		local absPos 		= GetGroundPosition( relPos + center_pos, parent)
		ParticleManager:SetParticleControl( effect_cast, 0, absPos )

		table.insert(self.unlock2_particle,effect_cast)
	end
	








	-- self.unlock2_particle
end


function modifier_Advanced_mystic_flare_thinker:RotateUnlock2Particle()
	local elapsedTime 				= GameRules:GetGameTime() - self.unlock2_start_time
	local currentRotationAngle	= elapsedTime * 120
	local parent = self:GetParent()
	local center_pos = parent:GetOrigin()
	local particle_count = #self.unlock2_particle
	local rotationAngleOffset	= 360 / particle_count
	local radius = self.lv20_radius*0.7

	for i = 1, particle_count, 1 do
		
		local rotationAngle = currentRotationAngle - rotationAngleOffset * (i - 1)
		local relPos 		= Vector(0, radius, 0)
		relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
		local absPos 		= GetGroundPosition( relPos + center_pos, parent)
		ParticleManager:SetParticleControl( self.unlock2_particle[i], 0, absPos )
	end
	
	
end

function modifier_Advanced_mystic_flare_thinker:RemoveUnlock2Particle()
	local particle_count = #self.unlock2_particle
	for i = 1, particle_count, 1 do
		ParticleManager:DestroyParticle(self.unlock2_particle[i],false)
		ParticleManager:ReleaseParticleIndex(self.unlock2_particle[i])
	end
	

end