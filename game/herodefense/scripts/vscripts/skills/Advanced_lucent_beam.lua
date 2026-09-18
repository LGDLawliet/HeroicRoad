--特效优化 √
Advanced_lucent_beam = class({})
LinkLuaModifier("modifier_Advanced_lucent_beam_thinker", "skills/Advanced_lucent_beam", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_Advanced_lucent_beam_lv15", "skills/Advanced_lucent_beam", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_lucent_beam_unlock1", "skills/Advanced_lucent_beam", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_lucent_beam_unlock1_trigger", "skills/Advanced_lucent_beam", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_lucent_beam_unlock3", "skills/Advanced_lucent_beam", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function Advanced_lucent_beam:CheckKV(key)
	local table = {

	


		base_damage = 10,
		bonus_damage = 0.1,



	}
	local value = table[key] or -1
	return value

end
function Advanced_lucent_beam:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_lucent_beam_unlock1",{})
	return true
end
function Advanced_lucent_beam:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_lucent_beam_unlock1",{})
	return true
end
function Advanced_lucent_beam:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock3",{})
	return true
end

function Advanced_lucent_beam:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/luna_impact/eclipse_impact_notarget_moonfall.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/indicator/circular/luna_aura/base.vpcf", context )

	PrecacheResource( "particle", "particles/rebuild/spell/lucent_beam/unlock3/effect_parent.vpcf", context )
	PrecacheResource( "particle", "particles/base_attacks/ranged_tower_good.vpcf", context )


end
function Advanced_lucent_beam:GetAOERadius()
	return 200
end
function Advanced_lucent_beam:GetBehavior()
	if self:GetUnlock(1)==1 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_lucent_beam:OnAbilityPhaseStart()
	-- play effects
	self:PlayEffects1()
	return true -- if success
end
function Advanced_lucent_beam:GetCooldown(iLevel)
	local cooldown = self.BaseClass.GetCooldown(self,iLevel)
	if IsServer() then
		if self:GetAutoCastState() then
			return cooldown * 3
		end
	end
	return cooldown
end
function Advanced_lucent_beam:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if IsServer() then
		if self:GetAutoCastState() then
			return cost * 3
		end
	end
	return cost
end

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_lucent_beam:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	self:CreateSingleLucent(target)
	if self:GetAutoCastState() then
		local pos = target:GetOrigin()
		Timers:CreateTimer(0.5, function()
			if self and not self:IsNull() then
				local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					pos,	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					0,	-- int, flag filter
					FIND_ANY_ORDER,	-- int, order filter
					false	-- bool, can grow cache
				)
				for index, unit in ipairs(enemies) do
					self:CreateSingleLucent(unit)
					break
				end
			end
		end
		)
		Timers:CreateTimer(1, function()
			if self and not self:IsNull() then
				local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					pos,	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					0,	-- int, flag filter
					FIND_ANY_ORDER,	-- int, order filter
					false	-- bool, can grow cache
				)
				for index, unit in ipairs(enemies) do
					self:CreateSingleLucent(unit)
					break
				end
			end
		end
		)
		if self.advanced_level>=10 then
			Timers:CreateTimer(1.5, function()
				if self and not self:IsNull() then
					local enemies = FindUnitsInRadius(
						caster:GetTeamNumber(),	-- int, your team number
						pos,	-- point, center point
						nil,	-- handle, cacheUnit. (not known)
						600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
						0,	-- int, flag filter
						FIND_ANY_ORDER,	-- int, order filter
						false	-- bool, can grow cache
					)
					for index, unit in ipairs(enemies) do
						self:CreateSingleLucent(unit)
						break
					end
				end
			end
			)
		end
	

	end
	if caster:IsInNightTime() and self.advanced_level>=20 then
		if 20>=RandomInt(1, 100) then
			self:EndCooldown()
		end
	end
end

function Advanced_lucent_beam:CreateSingleLucent(target)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("base_damage")+caster:GetAgility()*self:GetSpecialValueFor("bonus_damage")
	if self.advanced_level>=15 then
		if self.unlock2 then
			damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.5
		else
			damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.2
		end
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	local damage = ApplyDamage(damageTable)
	self:DamageRecord(damage)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = duration*StatusResistance } -- kv
	)

	-- effects
	self:PlayEffects2( target )


	local point = target:GetOrigin()
	local radius = 200
	local wave_count = 1
	local interval = 1
	local delay = 1
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/indicator/circular/luna_aura/base.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius, 0, 0 ) )
	
	local duration = wave_count*interval
	Timers:CreateTimer(delay, function()
		if effect_cast then
			ParticleManager:DestroyParticle(effect_cast, true)
			ParticleManager:ReleaseParticleIndex( effect_cast )
		end
	end
	)
	if self.unlock3 then
		local info = 
		{
			Target = target,
			Source = caster,
			Ability = self,	
			EffectName = "particles/base_attacks/ranged_tower_good.vpcf",
			iMoveSpeed = 1000,
			-- vSourceLoc = caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 30, --存在时间
			bProvidesVision = false, --提供视野
			ExtraData = {}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/lucent_beam/unlock3/effect_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin()+Vector(0,0,64) )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1000,1,1) )
		ParticleManager:SetParticleControlEnt(nFXIndex, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
	end
	
	


	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_lucent_beam_thinker", -- modifier name
		{duration =duration +5,delay = delay}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

function Advanced_lucent_beam:CreateSingleLucent_luna(target)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("base_damage")+caster:GetAgility()*self:GetSpecialValueFor("bonus_damage")
	if self.advanced_level>=15 then
		if self.unlock2 then
			damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.5
		else
			damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.2
		end
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	local damage = ApplyDamage(damageTable)
	self:DamageRecord(damage)
	-- effects
	self:PlayEffects2( target )


	local point = target:GetOrigin()
	local radius = 200
	local wave_count = 1
	local interval = 1
	local delay = 1
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/indicator/circular/luna_aura/base.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius, 0, 0 ) )
	
	local duration = wave_count*interval
	Timers:CreateTimer(delay, function()
		if effect_cast then
			ParticleManager:DestroyParticle(effect_cast, true)
			ParticleManager:ReleaseParticleIndex( effect_cast )
		end
	end
	)
	if self.unlock3 then
		local info = 
		{
			Target = target,
			Source = caster,
			Ability = self,	
			EffectName = "particles/base_attacks/ranged_tower_good.vpcf",
			iMoveSpeed = 1000,
			-- vSourceLoc = caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 30, --存在时间
			bProvidesVision = false, --提供视野
			ExtraData = {}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/lucent_beam/unlock3/effect_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin()+Vector(0,0,64) )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1000,1,1) )
		ParticleManager:SetParticleControlEnt(nFXIndex, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
	end
end

function Advanced_lucent_beam:Spawn()
	self.damage_count = 0
end
function Advanced_lucent_beam:DamageRecord(amount)
	if self.advanced_level<15 then
		return
	end
	if amount>0 then
		self.damage_count = self.damage_count + amount
		local caster = self:GetCaster()
		local need_amount = caster:GetAverageTrueAttackDamage(nil)*1.2
		if self.damage_count>=need_amount then
			self.damage_count = self.damage_count - need_amount
			local gain = caster:GetModifierDurationGainIndex(1)
			local duration = 15
			if self.unlock2 then
				duration = 20
			end
			caster:AddNewModifier(
				caster,
				self,
				"modifier_Advanced_lucent_beam_lv15",
				{	duration =duration*gain}
			)
		end
	end
end

function Advanced_lucent_beam:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	
	-- target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	--AddFOWViewer(self:GetCaster():GetTeamNumber(), location, 450, self:GetSpecialValueFor("slow_duration"), false)
	local caster = self:GetCaster()
--	local bonus_damage = self:GetSpecialValueFor("bonus_damage") * self:GetCaster():GetAverageTrueAttackDamage(nil) *0.01
	local newmodifier = caster:AddNewModifier(caster, self, "modifier_Advanced_lucent_beam_unlock3", {duration = 0.1})
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	if newmodifier then
		newmodifier:SafeDestroy()
	end
	if 40>=RandomInt(1, 100) then
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)


		for _,enemy in pairs(enemies) do
			self:CreateSingleLucent(enemy)
			break
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function Advanced_lucent_beam:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(0.4,0,0) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- ParticleManager:SetParticleControlEnt(
	-- 	effect_cast,
	-- 	2,
	-- 	self:GetCaster(),
	-- 	PATTACH_POINT_FOLLOW,
	-- 	"attach_attack1",
	-- 	Vector(0,0,0), -- unknown
	-- 	true -- unknown, true
	-- )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Advanced_lucent_beam:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		6,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end

function Advanced_lucent_beam:PlayEffects3(pos)
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 1, pos )
	ParticleManager:SetParticleControl( effect_cast, 5, pos )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		6,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	-- EmitSoundOn( sound_target, self:GetCaster() )
end







modifier_Advanced_lucent_beam_thinker = class({})


function modifier_Advanced_lucent_beam_thinker:IsHidden()	return true end
function modifier_Advanced_lucent_beam_thinker:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_lucent_beam_thinker:OnCreated( keys )



	if not IsServer() then return end
	local caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage =  self.ability:GetSpecialValueFor("base_damage")+caster:GetAgility()*self.ability:GetSpecialValueFor("bonus_damage")
	if self.ability.advanced_level>=15 then
		if self.ability.unlock2 then
			damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.5
		else
			damage = damage + caster:GetAverageTrueAttackDamage(nil)*0.2
		end
	end

	local index =0.6
	if self.ability.advanced_level>=5 then
		index = 0.8
	end
	self.radius = 200
	self.count = 1
	self.interval = 1

	local delay = keys.delay or 1
	self.delay_on = false
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage*index,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}

	self:StartIntervalThink( delay )
	
end



function modifier_Advanced_lucent_beam_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_lucent_beam_thinker:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then
		self:SafeDestroy()
		return
	end
	if self.ability:IsNull() then
		return
	end


	if not self.delay_on then
		self.delay_on = true
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		return
	end




	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		local damage = ApplyDamage( self.damageTable )
		self.ability:DamageRecord(damage)
	end

	self:PlayEffects()
	self.wave = self.wave + 1
	if self.wave>=self.count then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_lucent_beam_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/luna_impact/eclipse_impact_notarget_moonfall.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 5, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end





modifier_Advanced_lucent_beam_lv15 = class({})

function modifier_Advanced_lucent_beam_lv15:IsHidden()	return false end
function modifier_Advanced_lucent_beam_lv15:IsDebuff()	return false end
function modifier_Advanced_lucent_beam_lv15:IsPurgable()	return false end
function modifier_Advanced_lucent_beam_lv15:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_Advanced_lucent_beam_lv15:GetModifierPreAttack_BonusDamage()	return math.min(self:GetStackCount()*self.bonus,2000) end






function modifier_Advanced_lucent_beam_lv15:OnCreated(params)
	self.ability = self:GetAbility()
	self.bonus = 15
	if self.ability:GetUnlock(2)==2 then
		self.bonus = 25
	end
	if IsServer() then

		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_lucent_beam_lv15:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		-- if self:GetStackCount()>= (20+_G.GAME_ROUND*5.5) then
		-- 	--移除第一个 添加一个
		-- 	table.remove(self.tData, 1)
		-- 	table.insert(self.tData, {dieTime = dieTime })

		-- else
			--当叠加乘数没达到最高时
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		-- end
	end
end

function modifier_Advanced_lucent_beam_lv15:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end







modifier_Advanced_lucent_beam_unlock1		= class({})

function modifier_Advanced_lucent_beam_unlock1:IsHidden()	return true end
function modifier_Advanced_lucent_beam_unlock1:IsPurgable() 		return false end
function modifier_Advanced_lucent_beam_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_lucent_beam_unlock1:RemoveOnDeath()  return false end
function modifier_Advanced_lucent_beam_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(7)
	end
end	
function modifier_Advanced_lucent_beam_unlock1:OnIntervalThink()
	local caster = self:GetCaster()
	if caster:IsAlive() then
		caster:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_Advanced_lucent_beam_unlock1_trigger", -- modifier name
			{ duration = -1 } -- kv
		)
	
	end
end






modifier_Advanced_lucent_beam_unlock1_trigger		= class({})

function modifier_Advanced_lucent_beam_unlock1_trigger:IsHidden()	return false end
function modifier_Advanced_lucent_beam_unlock1_trigger:IsPurgable() 		return false end
function modifier_Advanced_lucent_beam_unlock1_trigger:IsPurgeException() 	return false end
function modifier_Advanced_lucent_beam_unlock1_trigger:RemoveOnDeath()  return false end
function modifier_Advanced_lucent_beam_unlock1_trigger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_lucent_beam_unlock1_trigger:OnCreated(keys)
	if IsServer() then
		self.count = 4
		if self:GetParent():IsInNightTime() then
			self.count = 6
		end
		self:StartIntervalThink(0.3)
	end
end	
function modifier_Advanced_lucent_beam_unlock1_trigger:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local pass = false
	for _,enemy in pairs(enemies) do
		ability:CreateSingleLucent(enemy)
		pass = true
		break
	end
	if not pass then
		local pos = caster:GetOrigin() + Vector(RandomInt(-500, 500),RandomInt(-500, 500),0)
		ability:PlayEffects3(pos)
	end
	self.count = self.count - 1
	if self.count<=0 then
		self:SafeDestroy()
	end
end


modifier_Advanced_lucent_beam_unlock3 = class({})

function modifier_Advanced_lucent_beam_unlock3:IsDebuff()			return false end
function modifier_Advanced_lucent_beam_unlock3:IsHidden() 			return true end
function modifier_Advanced_lucent_beam_unlock3:IsPurgable() 			return false end
function modifier_Advanced_lucent_beam_unlock3:IsPurgeException() 	return false end  
function modifier_Advanced_lucent_beam_unlock3:DeclareFunctions() return {
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
 } end
function modifier_Advanced_lucent_beam_unlock3:GetModifierDamageOutgoing_Percentage() 
	if IsClient() then
		return 0
	end
	return 400 
end
