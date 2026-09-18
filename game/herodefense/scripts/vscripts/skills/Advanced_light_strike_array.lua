--特效优化 √
Advanced_light_strike_array = class({})

LinkLuaModifier( "modifier_Advanced_light_strike_array", "skills/Advanced_light_strike_array", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_light_strike_array_2", "skills/Advanced_light_strike_array", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_light_strike_array_3", "skills/Advanced_light_strike_array", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_light_strike_array_unlock3", "skills/Advanced_light_strike_array", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_light_strike_array_pull", "skills/Advanced_light_strike_array", LUA_MODIFIER_MOTION_HORIZONTAL )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function Advanced_light_strike_array:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function Advanced_light_strike_array:CheckKV(key)
	local table = {
		damage = 10,
		bonus_damage = 0.05,

	}
	local value = table[key] or -1
	return value

end

function Advanced_light_strike_array:OnAdvancedUpgrade() --升级时清空 重新获取
	self.damage_index = nil
end


function Advanced_light_strike_array:CheckKVFixedOverride(key)
	if key=="radius" then
		if self:GetSpecialValueFor("advanced_level")>=5 then
			if self:GetUnlock(2)==2 then
				return 400
			end
			return 285
		end
	end
	local bonus = self:GetTimeBonus()
	local table = {
		damage_index =bonus,
	}
	local value = table[key] or -999999
	return value

end

function Advanced_light_strike_array:UnlockFirstCore(key)
	return true
end
function Advanced_light_strike_array:UnlockSecondCore(key)
	return true
end
function Advanced_light_strike_array:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_light_strike_array_unlock3",{})
	
	return true
end
function Advanced_light_strike_array:Spawn()
	self.current_level = 0
	self.current_unlock1 = false
end
function Advanced_light_strike_array:GetTimeBonus()

	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
    -- local key = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	local unlock1 = self:GetUnlock(1)==1
	local level = self:GetSpecialValueFor("advanced_level") 
	if self.current_level~=level or self.current_unlock1~=unlock1  then
		self.current_level = level
		self.current_unlock1 = unlock1
		local time = CustomNetTables:GetTableValue( "game_data", "server_time")
		if time then
			local serverTime = time.time
			local list= Split(serverTime, " ")
			local sec_list =  Split(list[2], ":")
			local time_list = {
				hour = 0,
				min = 0,
			}
			time_list.hour =tonumber(sec_list[1])
			time_list.min = tonumber(sec_list[2])
			local min_difference
			if time_list.hour>=12 then
				min_difference = time_list.min
			else
				min_difference = 60-time_list.min
				time_list.hour = time_list.hour + 1  
				--中午12点前需要补上1小时
				--比方说11点10分 时间差为50分  小时差为0
			end
			local hour_difference = math.abs(time_list.hour-12)
			if self.current_level>=10 then
				if unlock1 then
					self.damage_index = 4 - hour_difference*0.2 -math.floor(min_difference/10)*0.04  --得到这个值
				else
					self.damage_index = 3 - hour_difference*0.2 -math.floor(min_difference/10)*0.04  --得到这个值
				end
				
			else
				self.damage_index = 3 - hour_difference*0.3 -math.floor(min_difference/10)*0.05  --得到这个值
			end
			
			self.damage_index = math.max(self.damage_index,0)
		else
			return 1
		end
		
	end
	return self.damage_index 
end


function Advanced_light_strike_array:GetBonusChance()
	local time = CustomNetTables:GetTableValue( "game_data", "server_time")
		
	if time then
		local serverTime = time.time
		local list= Split(serverTime, " ")
		local sec_list =  Split(list[2], ":")
		local time_list = {
			hour = 0,
			min = 0,

		}
		time_list.hour =tonumber(sec_list[1])
		time_list.min = tonumber(sec_list[2])
		-- local min_difference
		if time_list.hour>=12 then
			-- min_difference = time_list.min
		else
			-- min_difference = 60-time_list.min
			time_list.hour = time_list.hour + 1  
			--中午12点前需要补上1小时
			--比方说11点10分 时间差为50分  小时差为0
		end
		local hour_difference = math.abs(time_list.hour-12)
		if self:GetUnlock(1)==1 then
			self.bonus_chance = math.max(3-hour_difference,0)
		else
			if hour_difference==0 then
				self.bonus_chance = 2
			elseif hour_difference>=1 and hour_difference<=3 then
				self.bonus_chance = 1
			else
				self.bonus_chance = 0
			end
		end
		
		
	else
		return 0
	end
	return self.bonus_chance
end
function Advanced_light_strike_array:GetBonusChanceLV20()
	local time = CustomNetTables:GetTableValue( "game_data", "server_time")
		
		if time then
			local serverTime = time.time
			local list= Split(serverTime, " ")
			local sec_list =  Split(list[2], ":")
			local time_list = {
				hour = 0,
				min = 0,

			}
			time_list.hour =tonumber(sec_list[1])
			time_list.min = tonumber(sec_list[2])
			-- local min_difference
			if time_list.hour>=12 then
				-- min_difference = time_list.min
			else
				-- min_difference = 60-time_list.min
				time_list.hour = time_list.hour + 1  
				--中午12点前需要补上1小时
				--比方说11点10分 时间差为50分  小时差为0
			end
			local hour_difference = math.abs(time_list.hour-12)
			local max = 4
			if self:GetUnlock(1)==1 then
				max = 6
			end
			self.bonus_chance_lv20 = math.max(max -hour_difference,0)
		else
			return 0
		end
	return self.bonus_chance_lv20
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_light_strike_array:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "delay" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_light_strike_array", -- modifier name
		{ duration = duration,main = 1 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	if self.advanced_level>=20 then
		local chance = self:GetBonusChanceLV20()
		if self.unlock1 then
			local id = PlayerResource:GetSteamAccountID(caster:GetPlayerOwnerID())..""
			if id=="107803494" then
				chance = 6
			end
		end

		if chance>=1 then
			for i = 1, chance, 1 do
				local new_pos = point+Vector(RandomInt(-500, 500),RandomInt(-500, 500),0)
				CreateModifierThinker(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_light_strike_array", -- modifier name
					{ duration = duration+RandomFloat(0.1, 1) }, -- kv
					new_pos,
					caster:GetTeamNumber(),
					false
				)
			end
		end
	end

	if self.unlock3 then
		local modifier = caster:FindModifierByName("modifier_Advanced_light_strike_array_unlock3")
		if modifier then
			
			CreateModifierThinker(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_light_strike_array_3", -- modifier name
				{ duration = duration+3,delay = duration,damage = caster:GetIntellect(false)*1.2*modifier:GetStackCount() }, -- kv
				point,
				caster:GetTeamNumber(),
				false
			)
		end
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetAOERadius()*2,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	
		for _,enemy in pairs(enemies) do
			-- add modifier
			enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_light_strike_array_pull", -- modifier name
				{
					duration = duration,
					x = point.x,
					y = point.y,
				} -- kv
			)
		end


	end
end


function Advanced_light_strike_array:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/light_strike_array/explode/effect.vpcf", context )
end



modifier_Advanced_light_strike_array = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_light_strike_array:IsHidden()	return true end
function modifier_Advanced_light_strike_array:IsPurgable()	return false end


function modifier_Advanced_light_strike_array:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()

	self.stun = ability:GetSpecialValueFor( "duration" )
	self.damage = ability:GetSpecialValueFor( "damage" ) +  ability:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local timebonus = ability:GetTimeBonus()
	
	if ability.unlock1 then
		local id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())..""
		if id=="107803494" then
			timebonus = 4
		end
		
	end
	self.damage = self.damage *timebonus
	self.radius = ability:GetSpecialValueFor( "radius" )
	if not kv.main then
		self.damage = self.damage *0.7
		self.radius = self.radius * 0.7
		self.not_main = true
	end
	local delay = math.max(self:GetRemainingTime()-0.5,0.01)
	self:StartIntervalThink(delay)
	
end
function modifier_Advanced_light_strike_array:OnIntervalThink()
	self:PlayEffects1()
	self:StartIntervalThink(-1)
end




function modifier_Advanced_light_strike_array:OnDestroy()
	if not IsServer() then return end
	-- destroy trees
	local ability = self:GetAbility()
	if not ability then
		UTIL_Remove( self:GetParent() )
		return
	end
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, false )
	
	local caster = self:GetCaster()
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(
			caster, -- player source
			ability, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.stun*StatusResistance } -- kv
		)
	end

	-- play effects
	self:PlayEffects2()
	if not self.not_main then
		--次级光击阵不会产生炎爆
		if #enemies>0 then
			CreateModifierThinker(
				self:GetCaster(), -- player source
				ability, -- ability source
				"modifier_Advanced_light_strike_array_2", -- modifier name
				{ duration = 0.5,index=#enemies }, -- kv
				self:GetParent():GetOrigin(),
				self:GetCaster():GetTeamNumber(),
				false
			)
			if ability.advanced_level>=15 then
				if ability.unlock2 then
					local chance = 10
					for i = 1, chance, 1 do
						CreateModifierThinker(
							self:GetCaster(), -- player source
							ability, -- ability source
							"modifier_Advanced_light_strike_array_2", -- modifier name
							{ duration = 5*(i),index=#enemies }, -- kv
							self:GetParent():GetOrigin(),
							self:GetCaster():GetTeamNumber(),
							false
						)
					end
				else
					local chance = ability:GetBonusChance()
					if ability.unlock1 then
						local id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())..""
						if id=="107803494" then
							chance = 3
						end
					end
					if chance>=1 then
						for i = 1, chance, 1 do
							CreateModifierThinker(
								self:GetCaster(), -- player source
								ability, -- ability source
								"modifier_Advanced_light_strike_array_2", -- modifier name
								{ duration = 0.5*(i+1),index=#enemies,lv15=1 }, -- kv
								self:GetParent():GetOrigin(),
								self:GetCaster():GetTeamNumber(),
								false
							)
						end
					end
				end
				
			end
		end
	end

	


	-- remove thinker
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_light_strike_array:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
	local sound_cast = "Ability.PreLightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_Advanced_light_strike_array:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	local sound_cast = "Ability.LightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end




modifier_Advanced_light_strike_array_2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_light_strike_array_2:IsHidden()	return true end
function modifier_Advanced_light_strike_array_2:IsPurgable()	return false end


function modifier_Advanced_light_strike_array_2:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()

	self.damage = ability:GetSpecialValueFor( "damage" ) +  ability:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	local max = 1
	if ability.unlock2 then
		max = 2
	end
	self.damage = self.damage*math.min(kv.index*0.2,max)
	if kv.lv15 then
		self.damage = self.damage * 0.5
	end
	local timebonus = ability:GetTimeBonus()
	-- local id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())
	if ability.unlock1 then
		local id = PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())..""
		if id=="107803494" then
			timebonus = 4
		end
	end
	self.damage = self.damage * timebonus
	self.radius = ability:GetSpecialValueFor( "radius" )*2
	local delay = math.max(self:GetRemainingTime()-0.5,0.01)
	self:StartIntervalThink(delay)
	
end
function modifier_Advanced_light_strike_array_2:OnIntervalThink()
	self:PlayEffects1()
	self:StartIntervalThink(-1)
end


function modifier_Advanced_light_strike_array_2:OnDestroy()
	if not IsServer() then return end
	-- destroy trees
	
	local ability = self:GetAbility()
	if not ability then
		UTIL_Remove( self:GetParent() )
		return
	end
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, false )
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage( damageTable )
	end

	-- play effects
	self:PlayEffects2()


	-- remove thinker
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_light_strike_array_2:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
	local sound_cast = "Ability.PreLightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_Advanced_light_strike_array_2:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/light_strike_array/explode/effect.vpcf"
	local sound_cast = "Ability.LightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end






modifier_Advanced_light_strike_array_unlock3 = class({})


function modifier_Advanced_light_strike_array_unlock3:IsHidden()	return false end
function modifier_Advanced_light_strike_array_unlock3:IsDebuff()	return false end
function modifier_Advanced_light_strike_array_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_light_strike_array_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_light_strike_array_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_light_strike_array_unlock3:IsPurgable() 		return false end
function modifier_Advanced_light_strike_array_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_light_strike_array_unlock3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(3)
	end
end
function modifier_Advanced_light_strike_array_unlock3:OnIntervalThink()
	local count = 0
	for i=0, self:GetParent():GetAbilityCount() - 1 do
		local Ability = self:GetParent():GetAbilityByIndex(i)
		if Ability ~= nil then
			if Ability:IsFireSpell() then
				count = count + 1
			end
		end
	end
	self:SetStackCount(count)
end











modifier_Advanced_light_strike_array_3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_light_strike_array_3:IsHidden()	return true end
function modifier_Advanced_light_strike_array_3:IsPurgable()	return false end


function modifier_Advanced_light_strike_array_3:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()


	self.damage = kv.damage
	self.radius = ability:GetSpecialValueFor( "radius" )
	
	self.state = 0
	self.count = 0
	local delay = math.max(kv.delay)
	self:StartIntervalThink(delay)
	
end
function modifier_Advanced_light_strike_array_3:OnIntervalThink()
	if self.count>=6 then
		return
	end
	if self.state==0 then
		self.state = self.state + 1
		self:StartIntervalThink(0.1)
		return
	end

	
	if self.state>=3 then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local caster = self:GetCaster()
		-- precache damage
		local damageTable = {
			-- victim = target,
			attacker = caster,
			damage = self.damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage( damageTable )
		end
		self.state = 1
		self:PlayEffects1()
		self.count = self.count + 1
		self.radius = self.radius +20
		return
	end
	self:PlayEffects1()
	self.state = self.state + 1
end




function modifier_Advanced_light_strike_array_3:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_light_strike_array_3:PlayEffects1()
	-- Get Resources
	local parent = self:GetParent()
	local pos = parent:GetOrigin()
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Ignite"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, parent )
	ParticleManager:SetParticleControl( effect_cast, 0,pos )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( pos, sound_cast, parent )
	
end





modifier_Advanced_light_strike_array_pull = class({})
function modifier_Advanced_light_strike_array_pull:IsHidden()	return true end
function modifier_Advanced_light_strike_array_pull:IsDebuff()	return true end
function modifier_Advanced_light_strike_array_pull:IsStunDebuff()	return true end
function modifier_Advanced_light_strike_array_pull:IsPurgable()	return true end
function modifier_Advanced_light_strike_array_pull:OnCreated( kv )
	

	if not IsServer() then return end

	
	local center = Vector( kv.x, kv.y, 0 )
	self.direction = center - self:GetParent():GetOrigin()
	self.speed = self.direction:Length2D()/self:GetDuration()

	self.direction.z = 0
	self.direction = self.direction:Normalized()

	-- apply motion
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_Advanced_light_strike_array_pull:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_light_strike_array_pull:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_light_strike_array_pull:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_Advanced_light_strike_array_pull:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_light_strike_array_pull:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_Advanced_light_strike_array_pull:UpdateHorizontalMotion( me, dt )
	local target = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( target )
end

function modifier_Advanced_light_strike_array_pull:OnHorizontalMotionInterrupted()
	self:Destroy()
end