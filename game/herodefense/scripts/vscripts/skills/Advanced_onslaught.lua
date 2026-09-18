--特效优化 √
Advanced_onslaught = class({})

LinkLuaModifier( "modifier_Advanced_onslaught_charge", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_onslaught", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_onslaught_debuff", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_onslaught_friendly", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_onslaught_phantom", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_onslaught_phantom_charge", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_onslaught_phantom_charge_done", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_onslaught_phantom_effect", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_Advanced_onslaught_phantom_lv15_cooldown", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_onslaught_phantom_2", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_onslaught_phantom_2_charge_done", "skills/Advanced_onslaught", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Init Abilities
function Advanced_onslaught:Precache( context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/rebuild/spell/onslaught/effect_charge_active.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/onslaught_active/effect_charge_active.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/onslaught/color_effect_up.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/primal_beast/primal_beast_2022_prestige/primal_beast_2022_prestige_onslaught_crack.vpcf", context )

	-- particles/rebuild/spell/onslaught/color_effect_up.vpcf
	
	
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/onslaught_chargeup/effect.vpcf", context )
	PrecacheResource( "particle", "particles/indicator/primal_beast_onslaught_range_finder/effect.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_monkey_king_fur_army.vpcf", context )
end
function Advanced_onslaught:CheckKV(key)
	local table = {

	


		damage = 15,
		bonus_damage = 0.07,




	}
	if self:GetUnlock(3)==3 then
		table.attack_rate_multiplier = 0.02
	end
	local value = table[key] or -1
	return value

end
function Advanced_onslaught:GetCooldown(iLevel)
	if self:GetUnlock(2)==2 then
		return 4
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function Advanced_onslaught:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	-- local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if advanced_level>=20 then
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING +DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	-- if coreUnlockKV then
	-- 	if coreUnlockKV.coreUnlock ==1 then
	-- 		return DOTA_ABILITY_BEHAVIOR_POINT
	-- 	elseif coreUnlockKV.coreUnlock ==3 then
	-- 		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	-- 	end
		
	-- end

	return self.BaseClass.GetBehavior(self)
end
function Advanced_onslaught:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_onslaught:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_onslaught:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_onslaught:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	-- local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "chargeup_time" )

	-- add modifier
	self.move_speed = caster:GetIdealSpeed()

	local mod = caster:AddNewModifier(caster,self,"modifier_Advanced_onslaught_charge",{ duration = duration })
	self:RemovePhantom()
	local scale = 0.5
	if self.advanced_level>=15 then
		scale = 0.8
	end
	if self.unlock2 then
		if caster:GetHealthPercent()<=50 then
			self.death = true
		else
			self.death = false
		end
	end
	self.phantom = self:SpawnPhantom(caster:GetOrigin(),caster:GetForwardVector(),scale)
	if self.phantom then
		local mod = self.phantom:AddNewModifier(caster,self,"modifier_Advanced_onslaught_phantom_charge",{ duration = duration })
	end
end
function Advanced_onslaught:GetPreMoveSpeed()
	return self.move_speed or 0
end
function Advanced_onslaught:DeathWhenEnd()
	return self.death or false
end
function Advanced_onslaught:OnChargeFinish( interrupt )
	-- unit identifier
	local caster = self:GetCaster()


	-- load data
	local max_duration = self:GetSpecialValueFor( "chargeup_time" )
	local max_distance = self:GetSpecialValueFor( "max_distance" )
	local speed = self:GetSpecialValueFor( "charge_speed" )
	if self.unlock2 then
		speed = 5000
	end

	-- find charge modifier
	local charge_duration = max_duration
	local mod = caster:FindModifierByName( "modifier_Advanced_onslaught_charge" )
	if mod then
		charge_duration = mod:GetElapsedTime()

		mod.charge_finish = true
		mod:Destroy()
	end

	local distance = max_distance * charge_duration/max_duration
	local duration = distance/speed

	-- cancel if interrupted
	if interrupt or not caster:IsAlive() then 
		if self.phantom and not self.phantom:IsNull() then
			
			self.phantom:RemoveModifierByName( "modifier_Advanced_onslaught_phantom_charge" )
			self.phantom:RemoveModifierByName( "modifier_Advanced_onslaught_phantom" )
		end
		return 
	end

	if self.advanced_level>=15 then
		
		local damage_index = 1
		if self:GetAutoCastState() then
	
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				caster:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_BASIC +DOTA_UNIT_TARGET_HERO   ,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_NONE ,	-- int, flag filter
				FIND_CLOSEST ,	-- int, order filter
				false	-- bool, can grow cache
			)
			for _, unit in ipairs(units) do
				if not unit:IsInvulnerable() and unit~=caster then
					if not unit:HasModifier("modifier_Advanced_onslaught") and not unit:HasModifier("modifier_Advanced_onslaught_friendly") then
						unit:AddNewModifier(caster,self, "modifier_Advanced_onslaught_friendly",{} )
						damage_index = 2
						break
					end
		
			
				end
				
			end
		end
		if self.unlock2 then
			caster:AddNewModifier(caster,self, "modifier_Advanced_onslaught",{duration=duration,lv15_duration = duration,damage_index=damage_index} )
		else
			caster:AddNewModifier(caster,self, "modifier_Advanced_onslaught",{lv15_duration = duration,damage_index=damage_index} )
		end
		
	else
		caster:AddNewModifier(caster,self, "modifier_Advanced_onslaught",{ duration = duration} )
	end
	-- add modifier
	

	-- play effects
	EmitSoundOn( "Hero_PrimalBeast.Onslaught", caster )

	if self.phantom and not self.phantom:IsNull() then
		self.phantom:RemoveModifierByName( "modifier_Advanced_onslaught_phantom_charge" )
		self.phantom:AddNewModifier(caster,self, "modifier_Advanced_onslaught_phantom_charge_done",{} )
	end
	
	
end

function Advanced_onslaught:SpawnPhantom(pos,dir,scale_offect)
	local hCaster = self:GetCaster()
	local illusion =	CreateUnitByName( "npc_hd_primal_beast_phantom", pos, true, nil, nil, hCaster:GetTeamNumber() )
	illusion:SetOrigin(pos)
	
	illusion:AddNewModifier(hCaster, self, "modifier_Advanced_onslaught_phantom", {scale_offect=scale_offect})

	illusion:AddNewModifier(hCaster, self, "modifier_Advanced_onslaught_phantom_effect", {})

	

	-- illusion:StartGesture(ACT_DOTA_CAST_ABILITY_5)
	illusion:SetForwardVector(dir)
	illusion.isThinker = true
	return illusion
end
function Advanced_onslaught:SpawnPhantom_unlock3(pos,dir,scale_offect)
	local hCaster = self:GetCaster()
	local illusion =	CreateUnitByName( "npc_hd_primal_beast_phantom", pos, true, nil, nil, hCaster:GetTeamNumber() )
	illusion:SetOrigin(pos)
	
	illusion:AddNewModifier(hCaster, self, "modifier_Advanced_onslaught_phantom_2", {duration = 6,scale_offect=scale_offect})
	illusion:AddNewModifier(hCaster, self, "modifier_Advanced_onslaught_phantom_2_charge_done", {duration = 6})

	illusion:SetForwardVector(dir)
	illusion.isThinker = true
	return illusion
end
function Advanced_onslaught:RemovePhantom()
	if self.phantom and not self.phantom:IsNull() then
		
		self.phantom:RemoveModifierByName( "modifier_Advanced_onslaught_phantom_charge_done" )
		self.phantom:RemoveModifierByName( "modifier_Advanced_onslaught_phantom_charge" )
		self.phantom:RemoveModifierByName( "modifier_Advanced_onslaught_phantom" )
	end
end

modifier_Advanced_onslaught_charge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_onslaught_charge:IsHidden()	return false end
function modifier_Advanced_onslaught_charge:IsDebuff()	return false end
function modifier_Advanced_onslaught_charge:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_onslaught_charge:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self.ability:GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self.ability:GetSpecialValueFor( "turn_rate" )

	if not IsServer() then return end
	if self.parent:HasAbility("heroTalent_npc_dota_hero_primal_beast_2") then
		self.turn_speed = self.turn_speed *3
		
	end
	if self.ability:GetSpecialValueFor("advanced_level")>=15 then
		kv.lv15 = true
	end

	self.origin = self.parent:GetOrigin()
	self.charge_finish = false

	-- turning data
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- Start interval
	self:StartIntervalThink( FrameTime() )

	-- order filter using library
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )

	-- play effect
	self:PlayEffects1()
	self:PlayEffects2()
end


function modifier_Advanced_onslaught_charge:OnRemoved()
	if not IsServer() then return end

	-- stop effects
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"
	EmitSoundOn( sound_cast, self.parent )

	if not self.charge_finish then
		self.ability:OnChargeFinish( false )
	end

	-- remove filter
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_Advanced_onslaught_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end



function modifier_Advanced_onslaught_charge:GetOverrideAnimation()
	if self:GetParent():GetUnitName()=="npc_dota_hero_primal_beast" then
		return ACT_DOTA_IDLE
	end
	return ACT_DOTA_GENERIC_CHANNEL_1
end
function modifier_Advanced_onslaught_charge:GetActivityTranslationModifiers()
	return "onslaught_windup"
end
function modifier_Advanced_onslaught_charge:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self.ability:OnChargeFinish( false )
	end	
end

function modifier_Advanced_onslaught_charge:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_Advanced_onslaught_charge:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_onslaught_charge:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Filter
-- NOTE: Filter is required because right-clicking faces the unit to target position, RESPECTING the terrain, so the target point may be different
function modifier_Advanced_onslaught_charge:OrderFilter( data )
	-- only filter right-clicks
	if data.order_type~=DOTA_UNIT_ORDER_MOVE_TO_POSITION and
		data.order_type~=DOTA_UNIT_ORDER_MOVE_TO_TARGET and
		data.order_type~=DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		return true
	end

	-- filter orders given to parent
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==self.parent then
			found = true
		end
	end
	if not found then return true end

	-- set order to move to direction
	data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION

	-- if there is target, set position to its origin
	if data.entindex_target~=0 then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end

	return true
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_onslaught_charge:OnIntervalThink()
	-- cancel logic
	if self.parent:IsRooted() or self.parent:IsStunned() or self.parent:IsSilenced() or
		self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsCurrentlyVerticalMotionControlled()
	then
		self.ability:OnChargeFinish( true )
	end

	-- turning logic
	self:TurnLogic( FrameTime() )

	-- set particles
	self:SetEffects()
end

function modifier_Advanced_onslaught_charge:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_onslaught_charge:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/indicator/primal_beast_onslaught_range_finder/effect.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast,60, Vector(270,0,0) )
	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self.effect_cast = effect_cast
	self:SetEffects()
end

function modifier_Advanced_onslaught_charge:SetEffects()
	local target_pos = self.origin + self.parent:GetForwardVector() * self.speed * self:GetElapsedTime()
	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_Advanced_onslaught_charge:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/onslaught_chargeup/effect.vpcf"
	if self.lv15 then
		particle_cast = "particles/rebuild/spell/onslaught/color_effect_up.vpcf"
	end
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl( effect_cast, 60, Vector(255,0,0) )
		ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )
	end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)


	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end







modifier_Advanced_onslaught = advanced_modifier({})


function modifier_Advanced_onslaught:IsHidden()	return true end
function modifier_Advanced_onslaught:IsDebuff()	return false end
function modifier_Advanced_onslaught:IsPurgable()	return false end
function modifier_Advanced_onslaught:IsMotionController() return true end
function modifier_Advanced_onslaught:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_Advanced_onslaught:OnCreated( kv )
	

	if not IsServer() then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self.ability:GetSpecialValueFor( "charge_speed" )

	self.turn_speed = self.ability:GetSpecialValueFor( "turn_rate" )

	self.radius = self.ability:GetSpecialValueFor( "knockback_radius" )
	if self.ability:GetSpecialValueFor("advanced_level")>=10 then
		self.radius = self.radius*1.5
	end
	self.distance = self.ability:GetSpecialValueFor( "knockback_distance" )
	self.duration = self.ability:GetSpecialValueFor( "knockback_duration" )
	self.stun = self.ability:GetSpecialValueFor( "stun_duration" )
	local damage = self.ability:GetSpecialValueFor( "damage" )+self.ability:GetSpecialValueFor( "bonus_damage" )*self.parent:GetDamageMax()+ self.ability:GetPreMoveSpeed()
	self.mana_index = 1
	if self.ability.unlock1 then
		self.speed = self.speed + math.min( self.ability:GetPreMoveSpeed(),3000)
		self.turn_speed = self.turn_speed *4
		self.mana_index = 0.3
	end

	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3 -- kv above is a lie
	if self.ability:GetSpecialValueFor("advanced_level")>=15 then
		kv.lv15 = true
		self.lv15 = true
		self.lv15_timer = GameRules:GetGameTime()+kv.lv15_duration
	end
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()
	self.abilityTargetTeam = self.ability:GetAbilityTargetTeam()
	self.abilityTargetType = self.ability:GetAbilityTargetType()
	self.abilityTargetFlags = self.ability:GetAbilityTargetFlags()

	-- turning data
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- knockback data
	self.knockback_units = {}
	self.knockback_units[self.parent] = true
	self.knockback_units_time = {}
	self.knockback_units_time[self.parent] = GameRules:GetGameTime() +999999
	if self.parent:HasAbility("heroTalent_npc_dota_hero_primal_beast_2") then
		self.turn_speed = self.turn_speed *3
		damage = damage + self.parent:GetAverageTrueAttackDamage(nil)*2
	end
	if self.ability.unlock2 then
		self.speed = 5000
		damage = self.ability:GetSpecialValueFor( "damage" )+self.ability:GetSpecialValueFor( "bonus_damage" )*self.parent:GetAverageTrueAttackDamage(nil)+ self.ability:GetPreMoveSpeed()

		if self.parent:HasAbility("heroTalent_npc_dota_hero_primal_beast_2") then
			damage = damage + self.parent:GetAverageTrueAttackDamage(nil)*2
		end
		if kv.damage_index then
			damage = damage * (kv.damage_index+5)
		else
			damage = damage * 6
		end
		self.distance = 700
	else
		if kv.damage_index then
			damage = kv.damage_index*damage
		end
	end

	
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
	}
	self:PlayEffect_attach()
	self.start_pos = self.parent:GetOrigin()
	self:StartIntervalThink(FrameTime()) 

	self.unlock3_timer = GameRules:GetGameTime()+1
	

end

function modifier_Advanced_onslaught:OnDestroy()
	if not IsServer() then return end
	-- self.parent:RemoveHorizontalMotionController(self)
	local ability = self:GetAbility()
	ability:RemovePhantom()
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )
	if ability.unlock2 then
		if ability:DeathWhenEnd() then
			TrueKill(self.parent, self.parent, ability)
		else
			self.parent:ModifyHealth(self.parent:GetMaxHealth()*0.1,nil,false,0)
		end
	end
end


function modifier_Advanced_onslaught:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_Advanced_onslaught:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		ExecuteOrderFromTable({
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION,
			Position = params.new_pos,
		})
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_Advanced_onslaught:GetModifierDisableTurning()
	return 1
end

function modifier_Advanced_onslaught:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_Advanced_onslaught:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_Advanced_onslaught:GetActivityTranslationModifiers()
	return "onslaught_movement"
end



function modifier_Advanced_onslaught:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	if self.parent:IsRooted() or self.parent:IsStunned() then
		self:Destroy()
		return
	end

	self:HitLogic()

	-- local forward = self.parent:GetForwardVector()
	self:TurnLogic( FrameTime() )

	local nextpos = self.parent:GetOrigin() + self.parent:GetForwardVector() * self.speed*FrameTime()
	nextpos = GetGroundPosition(nextpos, nil)
	-- self.no_Interrupted = true
	-- FindClearSpaceForUnit( self.parent, nextpos, true )
	-- self.update_count = self.update_count + 1
	if CalculateDistance(self.start_pos,self.parent:GetOrigin())>=2000 then
		FindClearSpaceForUnit( self.parent, nextpos, true )
		self.start_pos = self.parent:GetOrigin()
		
	else
		self.parent:SetOrigin(nextpos)  --Sets the location of this entity
	end
	
	if self.ability.unlock3 and GameRules:GetGameTime()>=self.unlock3_timer then
		self.unlock3_timer = GameRules:GetGameTime()+1.5
		self.ability:SpawnPhantom_unlock3(self.parent:GetOrigin(),self.parent:GetForwardVector(),0)
	end
	-- self.no_Interrupted = false
end

function modifier_Advanced_onslaught:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_Advanced_onslaught:HitLogic()
	-- destroy trees
	-- GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.tree_radius, false )

	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	if self.lv15 then
		if GameRules:GetGameTime()>=self.lv15_timer then
			self.lv15_timer = self.lv15_timer +0.2
			self.parent:SpendMana( (self.parent:GetMaxMana()*0.01+10)*self.mana_index, self.ability )
			if self.parent:GetManaPercent()<=20 then
				self:SafeDestroy()
				return
			end
		end
		for _,unit in pairs(units) do
			-- only knockback once
			if not self.knockback_units_time[unit] or ( self.knockback_units_time[unit] and GameRules:GetGameTime()>=self.knockback_units_time[unit]) then
				-- unit:AddNewModifier(self.parent,self.ability,"modifier_Advanced_onslaught_phantom_lv15_cooldown",{ duration = 5 })
				self.knockback_units_time[unit] = GameRules:GetGameTime() + 3
				local is_enemy = unit:GetTeamNumber()~=self.parent:GetTeamNumber()
	
				if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
					-- knockback data
					local direction = unit:GetOrigin()-self.parent:GetOrigin()
					direction.z = 0
					direction = direction:Normalized()
	
					-- create arc
					unit:AddNewModifier(
						self.parent, -- player source
						self.ability, -- ability source
						"modifier_generic_arc_lua_not_remove_on_death", -- modifier name
						{
							dir_x = direction.x,
							dir_y = direction.y,
							duration = self.duration,
							distance = self.distance,
							height = self.height,
							activity = ACT_DOTA_FLAIL,
						} -- kv
					)
				end
				-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
				
				-- damage and stun
				if is_enemy then
					local enemy = unit
	
					-- damage
					self.damageTable.victim = enemy
					ApplyDamage(self.damageTable)
					local StatusResistance = enemy:GetHDStatusResistanceIndex(1)
					-- stun
					local stun = self.stun*StatusResistance
					if self.ability.unlock2 then
						stun = math.max(stun,1)
					end
					enemy:AddNewModifier(self.parent, self.ability, "modifier_stunned",{ duration = stun } )
					enemy:AddNewModifier(self.parent, self.ability, "modifier_Advanced_onslaught_debuff",{ duration = 7 } )
	
	
					
				end
	
	
				-- play effects
				self:PlayEffects( unit, self.radius )
			end
		end
	else
		for _,unit in pairs(units) do
			-- only knockback once
			if not self.knockback_units[unit] then
				self.knockback_units[unit] = true
	
				local is_enemy = unit:GetTeamNumber()~=self.parent:GetTeamNumber()
	
				if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
					-- knockback data
					local direction = unit:GetOrigin()-self.parent:GetOrigin()
					direction.z = 0
					direction = direction:Normalized()
	
					-- create arc
					unit:AddNewModifier(
						self.parent, -- player source
						self.ability, -- ability source
						"modifier_generic_arc_lua_not_remove_on_death", -- modifier name
						{
							dir_x = direction.x,
							dir_y = direction.y,
							duration = self.duration,
							distance = self.distance,
							height = self.height,
							activity = ACT_DOTA_FLAIL,
						} -- kv
					)
				end
				-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
				
				-- damage and stun
				if is_enemy then
					local enemy = unit
	
					-- damage
					self.damageTable.victim = enemy
					ApplyDamage(self.damageTable)
					local StatusResistance = enemy:GetHDStatusResistanceIndex(1)
					-- stun
					enemy:AddNewModifier(self.parent, self.ability, "modifier_stunned",{ duration = self.stun*StatusResistance } )
					enemy:AddNewModifier(self.parent, self.ability, "modifier_Advanced_onslaught_debuff",{ duration = 7 } )
	
	
					
				end
	
	
				-- play effects
				self:PlayEffects( unit, self.radius )
			end
		end
	end


end


function modifier_Advanced_onslaught:PlayEffect_attach()
	local effect = "particles/rebuild/spell/onslaught/effect_charge_active.vpcf"
	if self.lv15 then
		effect = "particles/rebuild/spell/onslaught_active/effect_charge_active.vpcf"
	end
	self.nFXIndex = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(255,0,0) )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	end
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )

end

function modifier_Advanced_onslaught:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_onslaught:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf"
	if self.lv15 then
		particle_cast = "particles/econ/items/primal_beast/primal_beast_2022_prestige/primal_beast_2022_prestige_onslaught_crack.vpcf"
	end
	local sound_cast = "Hero_PrimalBeast.Onslaught.Hit"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


function modifier_Advanced_onslaught:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
	
end

function modifier_Advanced_onslaught:GetModifierMoveSpeed_Limit()
	return 0.1
end


function modifier_Advanced_onslaught:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_Advanced_onslaught:Advanced_GetModifier_FlyingPathing()	
	return 1
end



modifier_Advanced_onslaught_debuff = advanced_modifier({})

function modifier_Advanced_onslaught_debuff:IsDebuff() return true end
function modifier_Advanced_onslaught_debuff:IsHidden() return false end
function modifier_Advanced_onslaught_debuff:IsPurgable() return false end
function modifier_Advanced_onslaught_debuff:IsPurgeException() return false end
function modifier_Advanced_onslaught_debuff:OnCreated()
	self.armor = -7
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
		self.armor = -11
	end
end

function modifier_Advanced_onslaught_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_onslaught_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_onslaught_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_onslaught_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end







modifier_Advanced_onslaught_phantom = modifier_Advanced_onslaught_phantom or class({})
function modifier_Advanced_onslaught_phantom:IsHidden()	return true end
function modifier_Advanced_onslaught_phantom:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom:IsPurgable()	return false end
function modifier_Advanced_onslaught_phantom:IsPurgeException()	return false end
function modifier_Advanced_onslaught_phantom:IsStunDebuff()	return false end
function modifier_Advanced_onslaught_phantom:AllowIllusionDuplicate()	return false end
function modifier_Advanced_onslaught_phantom:OnCreated(keys)
	if IsServer() then
		-- self.state = 0
		local parent = self:GetParent()
		parent:SetModelScale(self:GetCaster():GetModelScale()+keys.scale_offect)
		-- local model = parent:FirstMoveChild()
		-- while model ~= nil do
		-- 	if model:GetClassname() == "dota_item_wearable" then
		-- 		-- print(model:GetModelName())
		-- 		if model:GetModelName()=="models/heroes/mars/mars_spear.vmdl" then
		-- 			self.lastModel = model
		-- 			self:StartIntervalThink(0.25)
		-- 			break
		-- 		end
				
		-- 	end
		-- 	model = model:NextMovePeer()
		
		-- end
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_onslaught_phantom:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
	end
end

function modifier_Advanced_onslaught_phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_Advanced_onslaught_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end

-- function modifier_Advanced_onslaught_phantom:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
-- 	}
-- end


-- function modifier_Advanced_onslaught_phantom:GetModifierInvisibilityLevel()return 1 end




modifier_Advanced_onslaught_phantom_charge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_onslaught_phantom_charge:IsHidden()	return false end
function modifier_Advanced_onslaught_phantom_charge:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom_charge:IsPurgable()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_onslaught_phantom_charge:OnCreated( kv )
	if not IsServer() then return end
	self.parent = self:GetParent()
	self:StartIntervalThink( FrameTime() )
	self:PlayEffects()
end

function modifier_Advanced_onslaught_phantom_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

function modifier_Advanced_onslaught_phantom_charge:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end
function modifier_Advanced_onslaught_phantom_charge:GetActivityTranslationModifiers()
	return "onslaught_windup"
end
function modifier_Advanced_onslaught_phantom_charge:GetModifierMoveSpeed_Limit()
	return 0.1
end
function modifier_Advanced_onslaught_phantom_charge:OnIntervalThink()
	local caster= self:GetCaster()
	self.parent:SetForwardVector(caster:GetForwardVector())
end
function modifier_Advanced_onslaught_phantom_charge:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/onslaught_chargeup/effect.vpcf"
	if self:GetAbility().advanced_level>=15 then
		particle_cast = "particles/rebuild/spell/onslaught/color_effect_up.vpcf"
	end
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl( effect_cast, 60, Vector(255,0,0) )
		ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )
	end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end











modifier_Advanced_onslaught_phantom_charge_done = class({})


function modifier_Advanced_onslaught_phantom_charge_done:IsHidden()	return true end
function modifier_Advanced_onslaught_phantom_charge_done:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom_charge_done:IsPurgable()	return false end
function modifier_Advanced_onslaught_phantom_charge_done:IsMotionController() return true end
function modifier_Advanced_onslaught_phantom_charge_done:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_Advanced_onslaught_phantom_charge_done:OnCreated( kv )
	if IsServer() then
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self:StartIntervalThink(FrameTime()) 
		self:PlayEffect_attach()
	end

	
end



function modifier_Advanced_onslaught_phantom_charge_done:DeclareFunctions()
	local funcs = {
		-- MODIFIER_EVENT_ON_ORDER,
		-- MODIFIER_PROPERTY_DISABLE_TURNING,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end



function modifier_Advanced_onslaught_phantom_charge_done:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_Advanced_onslaught_phantom_charge_done:GetActivityTranslationModifiers()
	return "onslaught_movement"
end



function modifier_Advanced_onslaught_phantom_charge_done:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	
	self.parent:SetOrigin(self.caster:GetOrigin())
	self.parent:SetForwardVector(self.caster:GetForwardVector())

	
	-- self.no_Interrupted = false
end


function modifier_Advanced_onslaught_phantom_charge_done:PlayEffect_attach()
	local effect = "particles/rebuild/spell/onslaught/effect_charge_active.vpcf"
	if self:GetAbility().advanced_level>=15 then
		effect = "particles/rebuild/spell/onslaught_active/effect_charge_active.vpcf"
	end
	self.nFXIndex = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(255,0,0) )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	end
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )

end


-- function modifier_Advanced_onslaught_phantom_charge_done:GetEffectName()
-- 	return "particles/rebuild/spell/onslaught/effect_charge_active.vpcf"
-- end

-- function modifier_Advanced_onslaught_phantom_charge_done:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end




modifier_Advanced_onslaught_phantom_effect = modifier_Advanced_onslaught_phantom_effect or class({})
function modifier_Advanced_onslaught_phantom_effect:IsHidden()	return true end
function modifier_Advanced_onslaught_phantom_effect:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom_effect:IsPurgable()	return false end
function modifier_Advanced_onslaught_phantom_effect:IsPurgeException()	return false end
function modifier_Advanced_onslaught_phantom_effect:IsStunDebuff()	return false end
function modifier_Advanced_onslaught_phantom_effect:AllowIllusionDuplicate()	return false end
function modifier_Advanced_onslaught_phantom_effect:GetStatusEffectName() return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf" end
function modifier_Advanced_onslaught_phantom_effect:RemoveOnDeath() return false end
function modifier_Advanced_onslaught_phantom_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end


function modifier_Advanced_onslaught_phantom_effect:GetModifierInvisibilityLevel()return 1 end



modifier_Advanced_onslaught_phantom_lv15_cooldown = modifier_Advanced_onslaught_phantom_lv15_cooldown or class({})
function modifier_Advanced_onslaught_phantom_lv15_cooldown:IsHidden()	return true end
function modifier_Advanced_onslaught_phantom_lv15_cooldown:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom_lv15_cooldown:IsPurgable()	return false end
function modifier_Advanced_onslaught_phantom_lv15_cooldown:IsPurgeException()	return false end


modifier_Advanced_onslaught_friendly = advanced_modifier({})


function modifier_Advanced_onslaught_friendly:IsHidden()	return true end
function modifier_Advanced_onslaught_friendly:IsDebuff()	return false end
function modifier_Advanced_onslaught_friendly:IsPurgable()	return false end
function modifier_Advanced_onslaught_friendly:IsMotionController() return true end
function modifier_Advanced_onslaught_friendly:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_Advanced_onslaught_friendly:OnCreated( kv )
	if IsServer() then
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self:StartIntervalThink(FrameTime()) 
		self:PlayEffect_attach()
		
	end

	
end
function modifier_Advanced_onslaught_friendly:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,

	}
end



function modifier_Advanced_onslaught_friendly:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end



function modifier_Advanced_onslaught_friendly:GetModifierDisableTurning() 
    return 1
end
function modifier_Advanced_onslaught_friendly:GetModifierIgnoreCastAngle()
    return 1
end


function modifier_Advanced_onslaught_friendly:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_Advanced_onslaught_friendly:GetActivityTranslationModifiers()
	return "onslaught_movement"
end
function modifier_Advanced_onslaught_friendly:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	if not self.caster:HasModifier("modifier_Advanced_onslaught") then
		self:SafeDestroy()
		return
	end
	if self.caster:HasModifier("modifier_Advanced_infest") or self.caster:HasModifier("modifier_Middle_infest") or self.caster:HasModifier("modifier_Primary_infest") then
		self:SafeDestroy()
		return
	end
	local forward = self.caster:GetForwardVector()
	self.parent:SetOrigin(self.caster:GetOrigin() - forward*300)
	self.parent:SetForwardVector(forward)

	
	-- self.no_Interrupted = false
end


function modifier_Advanced_onslaught_friendly:PlayEffect_attach()
	local effect = "particles/rebuild/spell/onslaught_active/effect_charge_active.vpcf"
	self.nFXIndex = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(255,0,0) )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	end
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )

end



function modifier_Advanced_onslaught_friendly:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying,
		-- advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_Advanced_onslaught_friendly:Advanced_GetModifier_Flying()	
	return 1
end











modifier_Advanced_onslaught_phantom_2 = modifier_Advanced_onslaught_phantom_2 or class({})
function modifier_Advanced_onslaught_phantom_2:IsHidden()	return true end
function modifier_Advanced_onslaught_phantom_2:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom_2:IsPurgable()	return false end
function modifier_Advanced_onslaught_phantom_2:IsPurgeException()	return false end
function modifier_Advanced_onslaught_phantom_2:IsStunDebuff()	return false end
function modifier_Advanced_onslaught_phantom_2:AllowIllusionDuplicate()	return false end
function modifier_Advanced_onslaught_phantom_2:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:SetModelScale(1+keys.scale_offect)
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_onslaught_phantom_2:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
	end
end

function modifier_Advanced_onslaught_phantom_2:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_Advanced_onslaught_phantom_2:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end












modifier_Advanced_onslaught_phantom_2_charge_done = class({})


function modifier_Advanced_onslaught_phantom_2_charge_done:IsHidden()	return true end
function modifier_Advanced_onslaught_phantom_2_charge_done:IsDebuff()	return false end
function modifier_Advanced_onslaught_phantom_2_charge_done:IsPurgable()	return false end
function modifier_Advanced_onslaught_phantom_2_charge_done:IsMotionController() return true end
function modifier_Advanced_onslaught_phantom_2_charge_done:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_Advanced_onslaught_phantom_2_charge_done:OnCreated( kv )
	

	if not IsServer() then return end
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.speed = self.ability:GetSpecialValueFor( "charge_speed" )*1.3

	self.turn_speed = self.ability:GetSpecialValueFor( "turn_rate" )

	self.radius = 220
	self.distance = self.ability:GetSpecialValueFor( "knockback_distance" )
	self.duration = self.ability:GetSpecialValueFor( "knockback_duration" )
	self.stun = self.ability:GetSpecialValueFor( "stun_duration" )
	local damage = self.ability:GetSpecialValueFor( "damage" )+self.ability:GetSpecialValueFor( "bonus_damage" )*self.caster:GetDamageMax()+ self.ability:GetPreMoveSpeed()
	
	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3 -- kv above is a lie
	-- ability properties
	self.abilityDamageType = self.ability:GetAbilityDamageType()
	self.abilityTargetTeam = self.ability:GetAbilityTargetTeam()
	self.abilityTargetType = self.ability:GetAbilityTargetType()
	self.abilityTargetFlags = self.ability:GetAbilityTargetFlags()

	-- turning data
	self.target_angle = self.caster:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- knockback data
	self.knockback_units = {}

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker =self.caster,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
	}
	self:PlayEffect_attach()
	self.start_pos = self.parent:GetOrigin()
	self:StartIntervalThink(FrameTime()) 


end

function modifier_Advanced_onslaught_phantom_2_charge_done:OnDestroy()
	if not IsServer() then return end
	-- self.parent:RemoveHorizontalMotionController(self)
	-- local ability = self:GetAbility()
	-- ability:RemovePhantom()
	-- FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )
	-- if ability.unlock2 then
	-- 	if ability:DeathWhenEnd() then
	-- 		TrueKill(self.parent, self.parent, ability)
	-- 	else
	-- 		self.parent:ModifyHealth(self.parent:GetMaxHealth()*0.1,nil,false,0)
	-- 	end
	-- end
end


function modifier_Advanced_onslaught_phantom_2_charge_done:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end


function modifier_Advanced_onslaught_phantom_2_charge_done:GetModifierDisableTurning()
	return 1
end

function modifier_Advanced_onslaught_phantom_2_charge_done:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_Advanced_onslaught_phantom_2_charge_done:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_Advanced_onslaught_phantom_2_charge_done:GetActivityTranslationModifiers()
	return "onslaught_movement"
end



function modifier_Advanced_onslaught_phantom_2_charge_done:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	if self.ability:IsNull() then
		self:Destroy()
		return
	end
	self:SetDirection( self.caster:GetOrigin() )
	self:HitLogic()

	-- local forward = self.parent:GetForwardVector()
	self:TurnLogic( FrameTime() )

	local nextpos = self.parent:GetOrigin() + self.parent:GetForwardVector() * self.speed*FrameTime()
	nextpos = GetGroundPosition(nextpos, nil)
	self.parent:SetOrigin(nextpos)  --Sets the location of this entity
	
end

function modifier_Advanced_onslaught_phantom_2_charge_done:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_Advanced_onslaught_phantom_2_charge_done:HitLogic()
	-- destroy trees
	-- GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.tree_radius, false )

	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,unit in pairs(units) do
		-- only knockback once
		if not self.knockback_units[unit] then
			self.knockback_units[unit] = true

			local is_enemy = unit:GetTeamNumber()~=self.parent:GetTeamNumber()

			if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
				-- knockback data
				local direction = unit:GetOrigin()-self.parent:GetOrigin()
				direction.z = 0
				direction = direction:Normalized()

				-- create arc
				unit:AddNewModifier(
					self.parent, -- player source
					self.ability, -- ability source
					"modifier_generic_arc_lua_not_remove_on_death", -- modifier name
					{
						dir_x = direction.x,
						dir_y = direction.y,
						duration = self.duration,
						distance = self.distance,
						height = self.height,
						activity = ACT_DOTA_FLAIL,
					} -- kv
				)
			end
			-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			
			-- damage and stun
			if is_enemy then
				local enemy = unit

				-- damage
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)
				-- stun
				enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned",{ duration = self.stun*StatusResistance } )
				enemy:AddNewModifier(self.caster, self.ability, "modifier_Advanced_onslaught_debuff",{ duration = 7 } )


				
			end

			self:PlayEffects( unit, self.radius )
		end
	end


end


function modifier_Advanced_onslaught_phantom_2_charge_done:PlayEffect_attach()
	local effect = "particles/rebuild/spell/onslaught_active/effect_charge_active.vpcf"
	self.nFXIndex = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(255,0,0) )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	end
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )

end



function modifier_Advanced_onslaught_phantom_2_charge_done:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/econ/items/primal_beast/primal_beast_2022_prestige/primal_beast_2022_prestige_onslaught_crack.vpcf"
	local sound_cast = "Hero_PrimalBeast.Onslaught.Hit"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


function modifier_Advanced_onslaught_phantom_2_charge_done:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
	
end
