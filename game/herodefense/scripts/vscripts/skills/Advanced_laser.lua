--特效优化 √
Advanced_laser = class({})
LinkLuaModifier( "modifier_Advanced_laser", "skills/Advanced_laser", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_laser_buff", "skills/Advanced_laser", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_laser_buff_2", "skills/Advanced_laser", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_laser_dummy", "skills/Advanced_laser", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_laser_debuff2", "skills/Advanced_laser", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function Advanced_laser:CheckKV(key)
	local table = {

	


		damage = 15,
		bonus_damage = 0.15,



	}
	local value = table[key] or -1
	return value

end


function Advanced_laser:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/laser_normal/big_laser/tinker_laser.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/laser_red/big_laser.vpcf", context )
	

end
function Advanced_laser:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_tinker" then
		return ACT_DOTA_CAST_ABILITY_1
	end
	return ACT_DOTA_ATTACK
end

function Advanced_laser:GetChannelTime()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==3 then
		return 4
	end
	return 0
end
function Advanced_laser:GetCastPoint()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==3 then
		return 1
	end
	return 0.5
end
function Advanced_laser:GetCooldown(level)

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==3 then
		return 1
	end
	return 18
end


function Advanced_laser:UnlockFirstCore(key)
	return true
end
function Advanced_laser:UnlockSecondCore(key)
	return true
end
function Advanced_laser:UnlockThirdCore(key)
	return true
end





function Advanced_laser:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==3 then
		return DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_AOE +DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AOE
end





function Advanced_laser:GetAOERadius()
	return 350
end

function Advanced_laser:GetCastRange(vLocation, hTarget)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level>=15 then
		return 1400
	end
	return 700
end

function Advanced_laser:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_Advanced_laser_buff") then
		return "tinker/tinker_ti10_immortal_ability_icons/tinker_laser_ti10"
	end
	return "tinker_laser"
end

function Advanced_laser:Spawn()
	self.stack = 1
end
function Advanced_laser:GetIntrinsicModifierName()
	return "modifier_Advanced_laser_buff_2"
end


function Advanced_laser:OnAbilityPhaseStart()
	self.radius = 200
	self.distance_past_target = 200
	self.damage_interval = 0.5
	self.damage_per_second = 0
	local sound_cast = "Hero_Tinker.LaserAnim"
	EmitSoundOn( sound_cast, self:GetCaster() )
	if IsServer() then
		if not self.unlock3 then
			return true
		end
		EmitSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )

		local vTargetPos = self:GetCursorPosition()

		local attach = "attach_attack1"
		if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
		local vAttachmentSourcePos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( attach ) )

		self.vDir = vTargetPos - vAttachmentSourcePos
		self.vDir.z = 0
		self.vDir = self.vDir:Normalized()

		self.vBeamEnd = vTargetPos + self.vDir * self.distance_past_target

		local hDummy = CreateUnitByName( "npc_dota_invisible_vision_source", self.vBeamEnd, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hDummy then
		   local fDuration = self:GetChannelTime()+2
		   hDummy:AddNewModifier( self:GetCaster(), self, "modifier_laser_dummy", { duration = fDuration } )
		   self.hBeamEnd = hDummy
		end

	end

	return true
end


--------------------------------------------------------------------------------
-- Ability Start
function Advanced_laser:OnSpellStart()

	local caster = self:GetCaster()
	local modifier =caster:FindModifierByName("modifier_Advanced_laser_buff")
	local talent4 = self:FindTalent4()
	if talent4 and talent4:IsCooldownReady() then
		talent4:StartCooldown(self:GetCooldownTimeRemaining())
		self:EndCooldown()
	end

	if self.unlock3 then
		-- local vTargetPos = self:GetCursorPosition()
		if not self.hBeamEnd or self.hBeamEnd:IsNull() then
			return
		end
		local attach = "attach_attack1"
		if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
		-- local vAttachmentSourcePos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( attach ) )
		-- self.nBeamRange = ( self.vBeamEnd - vAttachmentSourcePos ):Length2D()
		-- local nExtraBitAtEnd = self.radius * 0.3
		-- self.nBeamRange = self.nBeamRange - self.radius + nExtraBitAtEnd


		StopSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )
		EmitSoundOn( "Boss_Tinker.Laser", self:GetCaster() )

		local particleName = "particles/rebuild/spell/laser_normal/big_laser/tinker_laser.vpcf"
		if modifier then
			particleName= "particles/rebuild/spell/laser_red/big_laser.vpcf"
		end
		
		self.nBeamFX = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
		-- ParticleManager:SetParticleControlEnt( self.nBeamFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 1, self.hBeamEnd, PATTACH_ABSORIGIN_FOLLOW, nil, self.vBeamEnd, true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, attach, self:GetCaster():GetAbsOrigin(), true )

		EmitSoundOnLocationWithCaster( self:GetCaster():GetCursorPosition(), "Boss_Tinker.Laser.Loop", self:GetCaster() )

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 )

		self.fNextBurnTime = GameRules:GetGameTime() + self.damage_interval
		local damage = self:GetSpecialValueFor("damage")+( self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
		if modifier then
			damage = damage *2
		end
		self.damage_per_second = damage

	else
		local target = self:GetCursorTarget()
		if target:TriggerSpellAbsorb( self ) then
			return
		end


		local duration = self:GetSpecialValueFor("duration")
		local damage = self:GetSpecialValueFor("damage")+( self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
		if modifier then
			damage = damage *2
		end
	
		local damage = {
			-- victim = hTarget,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		--激光矩阵解锁 不再折射
		if self.unlock2 then
			local heroes = GetAllRealHeroes()
			local particle_cast = "particles/units/heroes/hero_tinker_rebuild/tinker_laser.vpcf"
			local modifier =caster:FindModifierByName("modifier_Advanced_laser_buff")
			if modifier then
				particle_cast = "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf"
			end
			local sound_cast = "Hero_Tinker.Laser"
			local sound_target = "Hero_Tinker.LaserImpact"
			
			local i = 0
			for  _, hero in pairs(heroes) do
				i = i + 1
				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW,hero )
				local attach = "attach_attack1"
				if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
				ParticleManager:SetParticleControlEnt(effect_cast,9,hero,PATTACH_POINT_FOLLOW,attach,Vector(0,0,0), true )
				ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0), true )
				ParticleManager:ReleaseParticleIndex( effect_cast )
				EmitSoundOn( sound_cast, self:GetCaster() )
				EmitSoundOn( sound_target, target )
			end
			damage.damage = damage.damage * i 
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 350, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(units) do
				-- apply damage
				damage.victim = enemy
				ApplyDamage( damage )
			end
	
			local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, self, "modifier_Advanced_laser", { duration = duration *StatusResistance} 	)
	
		else
			
			local targets = {}
			table.insert( targets, target )
			
			local count = 1
	
			
			if self.advanced_level>=5 then
				count = 2
				if self.unlock1 then
					count = count + 5
				end
	
			end
			if talent4 then
				count = count + talent4:GetSpecialValueFor("bonus_bounce")
			end
	
			for i = 1, count, 1 do
				self:Refract( targets )
			end
			
			-- self:Refract( targets )
			-- if self.advanced_level>=5 then
			-- 	self:Refract( targets )
			-- end
			self:PlayEffects( targets )
	
	
	
	
			for _, unit in ipairs(targets) do
				local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 350, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,enemy in pairs(units) do
					-- apply damage
					damage.victim = enemy
					ApplyDamage( damage )
				end
				if IsValid(unit) and unit:IsAlive() then
					local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					unit:AddNewModifier(caster, self, "modifier_Advanced_laser", { duration = duration *StatusResistance} 	)
				end
	

			end
			
	
	
		end
	
	end



	if modifier then
		modifier:SafeDestroy()
	end

	local need_count = 3
	if self.advanced_level>=10 then
		need_count = 2
		if self.advanced_level>=15 and RandomInt(1, 2)==1 then
			local cooldown = self:GetCooldownTimeRemaining()
			self:EndCooldown()
			self:StartCooldown(cooldown*0.5)
		end
	end


	if self.stack>=need_count then
		self.stack = 0
		caster:AddNewModifier(caster, self, "modifier_Advanced_laser_buff", {} 	)
	else
		self.stack = self.stack + 1
	end
	
end
function Advanced_laser:OnChannelThink( flInterval )
	if IsServer() then
		if not self.unlock3 then
			return
		end
		if self.fNextBurnTime ~= nil and GameRules:GetGameTime() >= self.fNextBurnTime then
			if not self.hBeamEnd or self.hBeamEnd:IsNull() then
				return
			end
			local caster = self:GetCaster()
			local attach = "attach_attack1"
			if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
			local vAttachmentSourcePos = self:GetCaster():GetAttachmentOrigin( caster:ScriptLookupAttachment( attach ) )


			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), vAttachmentSourcePos, self.hBeamEnd:GetAbsOrigin(),nil, self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE)

			local duration = self:GetSpecialValueFor("duration")
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			for _, hitEnemy in pairs( tTargets ) do
				local fDamage = self.damage_per_second * self.damage_interval

				local damage =
				{
					victim = hitEnemy,
					attacker = caster,
					damage = fDamage,
					damage_type = self:GetAbilityDamageType(),
					ability = self,
				}
				ApplyDamage( damage )

				local StatusResistance = hitEnemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				if duration *StatusResistance then
					hitEnemy:AddNewModifier(caster, self, "modifier_Advanced_laser_debuff2", { duration = duration *StatusResistance} 	)
				end
				

				local nDamageFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_laser_enemy.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nDamageFX, 1, hitEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hitEnemy:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nDamageFX )
			end

			self.fNextBurnTime = GameRules:GetGameTime() + self.damage_interval
		end
	end
end

-------------------------------------------------------------------------------

function Advanced_laser:OnChannelFinish( bInterrupted )
	if IsServer() then
		if not self.unlock3 then
			return
		end
		ParticleManager:DestroyParticle( self.nBeamFX, true )

		self:GetCaster():StopSound("Boss_Tinker.Laser.Loop")
		self:GetCaster():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )

	end
end

function Advanced_laser:Refract( targets )
	-- load data

	local serchOrder = FIND_FARTHEST
	if self.unlock1 then
		serchOrder = FIND_CLOSEST
	end

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		targets[#targets]:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		serchOrder,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- check for valid closest not-yet-affected next target 
	local next_target = nil
	for _,enemy in pairs(enemies) do
		local candidate = true
		for _,target in pairs(targets) do
			if enemy==target then
				candidate = false
				break
			end
		end
		if candidate then
			next_target = enemy
			break
		end
	end

	-- recursive
	if next_target then
		table.insert( targets, next_target )
	end
end





--------------------------------------------------------------------------------
function Advanced_laser:PlayEffects( targets )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_tinker_rebuild/tinker_laser.vpcf"
	local modifier =self:GetCaster():FindModifierByName("modifier_Advanced_laser_buff")
	if modifier then
		particle_cast = "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf"
	end
	local sound_cast = "Hero_Tinker.Laser"
	local sound_target = "Hero_Tinker.LaserImpact"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		9,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		targets[1],
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, targets[1] )

	if #targets>1 then
		for i=2,#targets do
			-- Create Particle
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt(
				effect_cast,
				9,
				targets[i-1],
				PATTACH_POINT_FOLLOW,
				"attach_hitloc",
				Vector(0,0,0), -- unknown
				true -- unknown, true
			)
			ParticleManager:SetParticleControlEnt(
				effect_cast,
				1,
				targets[i],
				PATTACH_POINT_FOLLOW,
				"attach_hitloc",
				Vector(0,0,0), -- unknown
				true -- unknown, true
			)
			ParticleManager:ReleaseParticleIndex( effect_cast )

			-- create sound
			EmitSoundOn( sound_target, targets[i] )
		end
	end
end



function Advanced_laser:FindTalent4()
	if not self.talent4 then
		self.talent4 = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_tinker_4")
	end
	return self.talent4
end



modifier_Advanced_laser = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_laser:IsHidden()	return false end
function modifier_Advanced_laser:IsDebuff()	return true end
function modifier_Advanced_laser:IsStunDebuff()	return false end
function modifier_Advanced_laser:IsPurgable()	return true end

function modifier_Advanced_laser:OnCreated( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_Advanced_laser:OnRefresh( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_laser:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_laser:GetModifierMiss_Percentage()
	return self.miss_rate
end








modifier_Advanced_laser_debuff2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_laser_debuff2:IsHidden()	return false end
function modifier_Advanced_laser_debuff2:IsDebuff()	return true end
function modifier_Advanced_laser_debuff2:IsStunDebuff()	return false end
function modifier_Advanced_laser_debuff2:IsPurgable()	return true end

function modifier_Advanced_laser_debuff2:OnCreated( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )*0.5
end

function modifier_Advanced_laser_debuff2:OnRefresh( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )*0.5
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_laser_debuff2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_laser_debuff2:GetModifierMiss_Percentage()
	return self.miss_rate
end








modifier_Advanced_laser_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_laser_buff:IsHidden()	return false end
function modifier_Advanced_laser_buff:IsDebuff()	return false end
function modifier_Advanced_laser_buff:IsStunDebuff()	return false end
function modifier_Advanced_laser_buff:RemoveOnDeath()	return false end






modifier_Advanced_laser_buff_2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_laser_buff_2:IsHidden()	return self.advanced_level<20 and true or false end
function modifier_Advanced_laser_buff_2:IsDebuff()	return false end
function modifier_Advanced_laser_buff_2:IsStunDebuff()	return false end
function modifier_Advanced_laser_buff_2:RemoveOnDeath()	return false end
function modifier_Advanced_laser_buff_2:DestroyOnExpire()	return false end
function modifier_Advanced_laser_buff_2:IsPurgable() 		return false end
function modifier_Advanced_laser_buff_2:IsPurgeException() 	return false end

function modifier_Advanced_laser_buff_2:OnCreated(table)
	self.advanced_level = 1
	self:StartIntervalThink(1)

end

function modifier_Advanced_laser_buff_2:OnIntervalThink(table)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock3 then
			self:StartIntervalThink(-1)
			return
		end
		local parent = self:GetParent()
		if self.advanced_level>=20 and  self:GetRemainingTime()<0 and parent:IsAlive() then
			
	
			local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
	  		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		   for i, unit in pairs(units) do
				parent:SetCursorCastTarget(unit)
           		ability:OnSpellStart()
				self:SetDuration(15, true)
				break
		   end



		end

	end
end











modifier_laser_dummy = class({})

--------------------------------------------------------------------------------

function modifier_laser_dummy:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_laser_dummy:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_laser_dummy:CheckState()
	local state =
	{
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_INVISIBLE ] = true,
		--[ MODIFIER_PROPERTY_PROVIDES_FOW_POSITION ] = true,
	}

	return state
end
