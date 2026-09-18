
--特效优化 √
Advanced_spirits = class({})
LinkLuaModifier("modifier_Advanced_spirits", "skills/Advanced_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_spirits_handler", "skills/Advanced_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_spirits_creep_hit", "skills/Advanced_spirits", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_spirits_unlock1", "skills/Advanced_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_spirits_unlock3", "skills/Advanced_spirits", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function Advanced_spirits:CheckKV(key)
	local table = {
		basic_damage=3,
		bonus_damage=0.02,	

	}
	local value = table[key] or -1
	return value

end



function Advanced_spirits:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_spirits_unlock1",{})
	return true
end
function Advanced_spirits:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_spirits:UnlockThirdCore(key)

	local caster = self:GetCaster()
	-- print("添加")
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_spirits_unlock3",{})
	return true

end



function Advanced_spirits:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
	
		end
		
	end

	return self.BaseClass.GetBehavior(self)
end







function Advanced_spirits:OnSpellStart()

	local caster 					= self:GetCaster()
	local spirit_min_radius 		= 100        --最近距离
	local spirit_max_radius 		= 1200        --最远距离
	local spirit_movement_rate		= 250
	local creep_damage				= self:GetSpecialValueFor("basic_damage") + (self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	local explosion_damage			= 2*caster:GetIntellect(false)

	local spirit_duration 			= self:GetSpecialValueFor("duration")
	local spirit_summon_interval	= 1
	local max_spirits 				= 5
	--LV5解锁引爆+
	if self.advanced_level>=5 then
		explosion_damage = explosion_damage*2
	end
	--LV20解锁增幅
	if self.advanced_level>=20 then
		max_spirits = max_spirits+3
	end
	if self.unlock2 then
		max_spirits = 30
		spirit_summon_interval = 0.3
	end
	local collision_radius			= 80
	local explosion_radius			= 300
	local spirit_turn_rate 			= 180






	if caster:HasModifier("modifier_Advanced_spirits") then
		caster:RemoveModifierByName("modifier_Advanced_spirits")
	end


	EmitSoundOn("Hero_Wisp.Spirits.Cast", caster)	




	caster:AddNewModifier(
		caster, 
		self, 
		"modifier_Advanced_spirits", 
		{
			duration = spirit_duration,
			spirits_starttime 		= GameRules:GetGameTime(),
			spirit_summon_interval	= spirit_summon_interval,
			max_spirits 			= max_spirits,
			collision_radius 		= collision_radius,
			explosion_radius 		= explosion_radius,
			spirit_min_radius		= spirit_min_radius,
			spirit_max_radius		= spirit_max_radius,
			spirit_movement_rate	= spirit_movement_rate,
			spirit_turn_rate 		= spirit_turn_rate,

			creep_damage 			= creep_damage,
			explosion_damage 		= explosion_damage,
	

		}) 

	

end


function Advanced_spirits:Explode(caster, spirit, explosion_radius, explosion_damage, ability)
	if IsServer() then
		EmitSoundOn("Hero_Wisp.Spirits.Target", spirit)
		ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, spirit)

		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeam(),
			spirit:GetAbsOrigin(), 
			nil, 
			explosion_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)

		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= explosion_damage

		-- Deal damage to each enemy hero
		for _,enemy in pairs(nearby_enemy_units) do
			if enemy ~= nil then
				damage_table.victim = enemy

				ApplyDamage(damage_table)
			end
		end

		-- Let's just have another one here for Rubick to "properly" destroy Spirit particles
		if spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
			ParticleManager:ReleaseParticleIndex(spirit.spirit_pfx_silence)
		end
		
		-- modifier.spirits_spiritsSpawned[spirit.spirit_index] = nil
	end
end



function Advanced_spirits:OnProjectileHit(target, pos)
	local caster = self:GetCaster()
	if not target then
		return
	end
	if target:IsAttackImmune() then
		return
	end
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
	caster:PerformAttack(target, false, true, true, true, false, false, true)--对一单位执行攻击。
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end

















----------------------
--		SPIRITS	modifier	--
------------------------------
modifier_Advanced_spirits = class({})
function modifier_Advanced_spirits:IsPurgable() return false end
function modifier_Advanced_spirits:IsPurgeException() return false end
function modifier_Advanced_spirits:GetAttributes() 
	if self:GetAbility():GetUnlock(1)==1 then
		return MODIFIER_ATTRIBUTE_MULTIPLE
	end
end
function modifier_Advanced_spirits:OnCreated(params)
	if IsServer() then
		self.start_time 				= params.spirits_starttime
		self.spirit_summon_interval 	= params.spirit_summon_interval
		self.max_spirits				= params.max_spirits
		self.collision_radius			= params.collision_radius
		self.explosion_radius			= params.explosion_radius
		self.spirit_radius 				= params.collision_radius
		self.spirit_min_radius			= params.spirit_min_radius
		self.spirit_max_radius			= params.spirit_max_radius
		self.spirit_movement_rate 		= params.spirit_movement_rate
		self.spirit_turn_rate			= params.spirit_turn_rate

		self.creep_damage 				= params.creep_damage
		self.explosion_damage			= params.explosion_damage
		self.spirits_num_spirits		= 0

		self.spirits_movementFactor = 1
		self.spirits_spiritsSpawned		= {}
		-- timers for tracking update of FX
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_3") then
			if self:GetAbility().unlock2 then
				self.max_spirits = self.max_spirits +5
			else
				self.max_spirits = self.max_spirits *2
			end
			self.spirit_turn_rate = self.spirit_turn_rate * 2
		end

		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	

		self:StartIntervalThink(0.03)
	end
end

function modifier_Advanced_spirits:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
	
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval



		local caster_position 			= self:GetParent():GetAbsOrigin()
		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)
		if self.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", caster_position, false, caster, caster, caster:GetTeam())


			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			newSpirit.spirit_pfx = pfx

			
			--增加数量记录
			local spiritIndex = self.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			self.spirits_num_spirits = spiritIndex
			self.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_Advanced_spirits_handler", 
				{ 
					duraiton 			= -1,


					tinkerval 			= 360 / self.spirit_turn_rate / self.max_spirits,
					collision_radius 	= self.collision_radius,
					explosion_radius 	= self.explosion_radius,
					creep_damage 		= self.creep_damage,
					explosion_damage 	= self.explosion_damage,
					
				}
			)
		end
		
		--------------------------------------------------------------------------------
		-- Update the radius
		--------------------------------------------------------------------------------
		local currentRadius	= self.spirit_radius


		if not self:GetAbility():GetAutoCastState() then
			local deltaRadius 	= self.spirits_movementFactor * self.spirit_movement_rate * 0.03
			currentRadius 		= currentRadius + deltaRadius
		end
		-- currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
		if currentRadius<= self.spirit_min_radius then
			self.spirits_movementFactor = 1
		end
		if currentRadius>= self.spirit_max_radius then
			self.spirits_movementFactor = -1
		end
		self.spirit_radius 	= currentRadius


		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( self.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1

				-- Rotate
				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, currentRadius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)

				-- Update particle... switch particle depending on currently active effect. 
				-- the dealy is needed since it takes 0.3s for spirits to fade in.
				
				
				if spirit.spirit_pfx then
					spirit.currentRadius = Vector(currentRadius, 0, 0)
					ParticleManager:SetParticleControl(spirit.spirit_pfx, 1, Vector(currentRadius, 0, 0))
				end
			else
				self.spirits_spiritsSpawned[k] = nil
			end
		end
	



		if self.spirits_num_spirits == self.max_spirits and numSpiritsAlive == 0 then
			-- All spirits have been exploded.
			caster:RemoveModifierByName("modifier_Advanced_spirits")
			return
		end
	end
end




function modifier_Advanced_spirits:OnRemoved()
	if IsServer() then
	
		local ability 	= self:GetAbility()
		local caster 	= self:GetCaster()
		for k,spirit in pairs( self.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				spirit:RemoveModifierByName("modifier_Advanced_spirits_handler")
			end
		end

		self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
	end
end




--命中特效
modifier_Advanced_spirits_creep_hit = class({})
function modifier_Advanced_spirits_creep_hit:IsHidden() return true end
function modifier_Advanced_spirits_creep_hit:OnCreated() 
	if IsServer() then
		local target = self:GetParent()
		EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", target)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
end

function modifier_Advanced_spirits_creep_hit:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
	end
end



----------------------------------------------------------------------
--		SPIRITS	modifier (keep them from getting targeted)			--
----------------------------------------------------------------------
modifier_Advanced_spirits_handler = class({})
function modifier_Advanced_spirits_handler:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
	}

	return state
end

function modifier_Advanced_spirits_handler:OnCreated(params)
	if IsServer() then
		self.caster 			= self:GetCaster()
		self.ability 			= self:GetAbility()


		self.tinkerval 			= params.tinkerval
		self.collision_radius 	= params.collision_radius
		self.explosion_radius 	= params.explosion_radius
		self.creep_damage 		= params.creep_damage
		self.explosion_damage 	= params.explosion_damage
		self.parent = self:GetParent()
		self.parent.hit_table = {}
		self.damage_time = 0.6
		self.advanced_level = self.ability.advanced_level
		--LV10解锁效率化
		if self.advanced_level>=10 then
			self.damage_time = 0.4
		end

		self.damage_count = 0
		-- dmg timer and hittable
		self.damage_interval 	= 0.10
		self.damage_timer 		= 0

		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_Advanced_spirits_handler:OnIntervalThink()
	if IsServer() then 
		local spirit = self:GetParent()
		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			self.caster:GetTeam(),
			spirit:GetAbsOrigin(), 
			nil, 
			self.collision_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)


		if nearby_enemy_units ~= nil and #nearby_enemy_units > 0 then
			self:OnHit(self.caster, spirit, nearby_enemy_units, self.creep_damage, self.ability)
		end


		self.damage_timer = self.damage_timer +self.damage_interval
		if self.advanced_level>=15 and self.damage_timer>=1 then
			self.damage_timer = 0
			if self:GetCaster():GetRandomEffect(30,INT_TYPE,1) >=RandomInt(1, 100) then
				local nearby_enemy_units = FindUnitsInRadius(
					self.caster:GetTeam(),
					spirit:GetAbsOrigin(), 
					nil, 
					600, 
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_ANY_ORDER, 
					false
				)
				if #nearby_enemy_units>=1 then
					for _, unit in ipairs(nearby_enemy_units) do
						if not unit:IsAttackImmune() then
							local info = 
							{
								Target = unit,
								-- Source = spirit,
								vSourceLoc = spirit:GetOrigin()+Vector(0,0,128),
								Ability = self.ability,	
								EffectName = "particles/units/heroes/hero_wisp/wisp_base_attack.vpcf",
								iMoveSpeed = 800,
								-- vSourceLoc= spirit:GetAbsOrigin(),
								bDrawsOnMinimap = false,
								bDodgeable = true,
								bIsAttack = false,
								bVisibleToEnemies = true,
								bReplaceExisting = false,
								flExpireTime = GameRules:GetGameTime() + 10,
								bProvidesVision = false,	
							}
							ProjectileManager:CreateTrackingProjectile(info)
							break
						end
					end
				end
			end
			
		end
	end
end

function modifier_Advanced_spirits_handler:OnHit(caster, spirit, enemies_hit, creep_damage, ability) 

	-- Initialize damage table
	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 

	-- Deal damage to each enemy hero
	for _,enemy in pairs(enemies_hit) do
		-- cant dmg ded stuff + cant dmg if ded
		if enemy:IsAlive() and not spirit:IsNull() then 
			local hit = false

			damage_table.victim = enemy

			if spirit.hit_table[enemy] == nil then
				spirit.hit_table[enemy] = true
				enemy:AddNewModifier(caster, ability, "modifier_Advanced_spirits_creep_hit", {duration = 0.03})
				damage_table.damage	= creep_damage
				hit = true
				Timers:CreateTimer(self.damage_time, function()
					if not spirit:IsNull() then
						spirit.hit_table[enemy] = nil
					end
				end)
			end

			if hit then
				ApplyDamage(damage_table)
				if self.ability.unlock2 then
					self.damage_count = self.damage_count + 1
				end
			end

		end
	end
	if self.ability.unlock2 and self.damage_count>=3 then
		self:SafeDestroy()
	end

end

function modifier_Advanced_spirits_handler:OnRemoved()
	if IsServer() then
		local spirit	= self:GetParent()
		local ability	= self:GetAbility()
		ability:Explode(self.caster, spirit, self.explosion_radius, self.explosion_damage, ability)
		if spirit.spirit_pfx~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx, true)
		end
		spirit:ForceKill( true )
	end
end









modifier_Advanced_spirits_unlock1 = class({})

function modifier_Advanced_spirits_unlock1:IsHidden()	return true end
function modifier_Advanced_spirits_unlock1:IsDebuff()	return false end
function modifier_Advanced_spirits_unlock1:IsPurgable()	return false end
function modifier_Advanced_spirits_unlock1:IsPurgeException() return false end
function modifier_Advanced_spirits_unlock1:RemoveOnDeath() return false end

function modifier_Advanced_spirits_unlock1:DeclareFunctions() 
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
 end


function modifier_Advanced_spirits_unlock1:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=3 then
		if keys.target then
           	local caster					= self:GetCaster()
			local ability 					= self:GetAbility()
		
			local spirit_min_radius 		= 100        --最近距离
			local spirit_max_radius 		= RandomInt(200, 500)        --最远距离
			local spirit_movement_rate		= RandomInt(200, 500)
			local creep_damage				= ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
			local explosion_damage			= 4*caster:GetIntellect(false)

			local spirit_duration 			= 15
			local spirit_summon_interval	= 1
			local max_spirits 				= 1

			local collision_radius			= 80
			local explosion_radius			= 300
			local spirit_turn_rate 			= RandomInt(50, 270)

			EmitSoundOn("Hero_Wisp.Spirits.Cast", caster)	




			keys.target:AddNewModifier(
				caster, 
				ability, 
				"modifier_Advanced_spirits", 
				{
					duration = spirit_duration,
					spirits_starttime 		= GameRules:GetGameTime(),
					spirit_summon_interval	= spirit_summon_interval,
					max_spirits 			= max_spirits,
					collision_radius 		= collision_radius,
					explosion_radius 		= explosion_radius,
					spirit_min_radius		= spirit_min_radius,
					spirit_max_radius		= spirit_max_radius,
					spirit_movement_rate	= spirit_movement_rate,
					spirit_turn_rate 		= spirit_turn_rate,
		
					creep_damage 			= creep_damage,
					explosion_damage 		= explosion_damage,
			

				}) 

        end
    end
  
    
end



modifier_Advanced_spirits_unlock3 = class({})

function modifier_Advanced_spirits_unlock3:IsHidden()	return true end
function modifier_Advanced_spirits_unlock3:IsDebuff()	return false end
function modifier_Advanced_spirits_unlock3:IsPurgable()	return false end
function modifier_Advanced_spirits_unlock3:IsPurgeException() return false end
function modifier_Advanced_spirits_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_spirits_unlock3:OnCreated()
	if IsServer() then
		-- print("oooo")
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "dota_on_summon", Dynamic_Wrap( self, 'OnSummonTrigger' ),self )
	end
end
function modifier_Advanced_spirits_unlock3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_Advanced_spirits_unlock3:OnSummonTrigger(keys)

	if IsServer() then
		local unit =  EntIndexToHScript(keys.unit)
		local target =  EntIndexToHScript(keys.target)
		-- print("000000000")
		if not IsEnemy(unit,self:GetParent()) then
				-- print("1111111")
			-- local target = keys.target
		  	local caster					= self:GetCaster()
			local ability 					= self:GetAbility()
		
			local spirit_min_radius 		= 100        --最近距离
			local spirit_max_radius 		= RandomInt(200, 500)        --最远距离
			local spirit_movement_rate		= RandomInt(200, 500)
			local creep_damage				= ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
			local explosion_damage			= 4*caster:GetIntellect(false)

			local spirit_duration 			= -1
			local spirit_summon_interval	= 1
			local max_spirits 				= 1

			local collision_radius			= 80
			local explosion_radius			= 300
			local spirit_turn_rate 			= RandomInt(50, 270)

			EmitSoundOn("Hero_Wisp.Spirits.Cast", target)	




			target:AddNewModifier(
				caster, 
				ability, 
				"modifier_Advanced_spirits", 
				{
					duration = spirit_duration,
					spirits_starttime 		= GameRules:GetGameTime(),
					spirit_summon_interval	= spirit_summon_interval,
					max_spirits 			= max_spirits,
					collision_radius 		= collision_radius,
					explosion_radius 		= explosion_radius,
					spirit_min_radius		= spirit_min_radius,
					spirit_max_radius		= spirit_max_radius,
					spirit_movement_rate	= spirit_movement_rate,
					spirit_turn_rate 		= spirit_turn_rate,
		
					creep_damage 			= creep_damage,
					explosion_damage 		= explosion_damage,
			

				}) 

		end
	end
end

-- dota_on_summon