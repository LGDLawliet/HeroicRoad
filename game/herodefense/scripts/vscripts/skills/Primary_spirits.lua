Primary_spirits = class({})
LinkLuaModifier("modifier_Primary_spirits", "skills/Primary_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_spirits_handler", "skills/Primary_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_spirits_creep_hit", "skills/Primary_spirits", LUA_MODIFIER_MOTION_NONE)


require('internal/timers')   --计时器功能
function Primary_spirits:OnSpellStart()
	if IsServer() then
		self.caster 					= self:GetCaster()
		self.ability 					= self.caster:FindAbilityByName("Primary_spirits")
		self.start_time 				= GameRules:GetGameTime()
		self.spirits_num_spirits		= 0
		local spirit_min_radius 		= 100        --最近距离
		local spirit_max_radius 		= 1200        --最远距离
		local spirit_movement_rate		= 250
		local creep_damage				= self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("bonus_damage")*self.caster:GetIntellect(false)
		local explosion_damage			= 0

		local spirit_duration 			= self:GetSpecialValueFor("duration")
		local spirit_summon_interval	= 1
		local max_spirits 				= 5
		local collision_radius			= 80
		local explosion_radius			= 0
		local spirit_turn_rate 			= 100

	
	



		if self.caster:HasModifier("modifier_Primary_spirits") then
			self.caster:RemoveModifierByName("modifier_Primary_spirits")
		end
		self.spirits_movementFactor				= 1	
		self.ability.spirits_spiritsSpawned		= {}

		EmitSoundOn("Hero_Wisp.Spirits.Cast", self.caster)	




		self.caster:AddNewModifier(
			self.caster, 
			self.ability, 
			"modifier_Primary_spirits", 
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


function Primary_spirits:Explode(caster, spirit, explosion_radius, explosion_damage, ability)
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
		
		ability.spirits_spiritsSpawned[spirit.spirit_index] = nil
	end
end





















----------------------
--		SPIRITS	modifier	--
------------------------------
modifier_Primary_spirits = class({})
function modifier_Primary_spirits:IsPurgable() return false end
function modifier_Primary_spirits:IsPurgeException() return false end

function modifier_Primary_spirits:OnCreated(params)
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
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_3") then
			self.max_spirits = self.max_spirits + 5
			self.spirit_turn_rate = self.spirit_turn_rate * 2
		end


		-- timers for tracking update of FX


		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	

		self:StartIntervalThink(0.03)
	end
end

function modifier_Primary_spirits:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
		local caster_position 			= caster:GetAbsOrigin()
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval




		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)
		if ability.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", caster_position, false, caster, caster, caster:GetTeam())


			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			newSpirit.spirit_pfx = pfx

			
			--增加数量记录
			local spiritIndex = ability.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			ability.spirits_num_spirits = spiritIndex
			ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_Primary_spirits_handler", 
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
			local deltaRadius 	= ability.spirits_movementFactor * self.spirit_movement_rate * 0.03
			currentRadius 		= currentRadius + deltaRadius
		end
		
		-- currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
		if currentRadius<= self.spirit_min_radius then
			ability.spirits_movementFactor = 1
		end
		if currentRadius>= self.spirit_max_radius then
			ability.spirits_movementFactor = -1
		end
		self.spirit_radius 	= currentRadius


		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
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
			end
		end



		if ability.spirits_num_spirits == self.max_spirits and numSpiritsAlive == 0 then
			-- All spirits have been exploded.
			caster:RemoveModifierByName("modifier_Primary_spirits")
			return
		end
	end
end




function modifier_Primary_spirits:OnRemoved()
	if IsServer() then
	
		local ability 	= self:GetAbility()
		local caster 	= self:GetCaster()
		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				spirit:RemoveModifierByName("modifier_Primary_spirits_handler")
			end
		end

		self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
	end
end




--命中特效
modifier_Primary_spirits_creep_hit = class({})
function modifier_Primary_spirits_creep_hit:IsHidden() return true end
function modifier_Primary_spirits_creep_hit:OnCreated() 
	if IsServer() then
		local target = self:GetParent()
		EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", target)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
end

function modifier_Primary_spirits_creep_hit:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
	end
end



----------------------------------------------------------------------
--		SPIRITS	modifier (keep them from getting targeted)			--
----------------------------------------------------------------------
modifier_Primary_spirits_handler = class({})
function modifier_Primary_spirits_handler:CheckState()
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

function modifier_Primary_spirits_handler:OnCreated(params)
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


		-- dmg timer and hittable
		self.damage_interval 	= 0.10
		self.damage_timer 		= 0

		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_Primary_spirits_handler:OnIntervalThink()
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
	end
end

function modifier_Primary_spirits_handler:OnHit(caster, spirit, enemies_hit, creep_damage, ability) 

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
				enemy:AddNewModifier(caster, ability, "modifier_Primary_spirits_creep_hit", {duration = 0.03})
				damage_table.damage	= creep_damage
				hit = true
				Timers:CreateTimer(0.8, function()
					if not spirit:IsNull() then
						spirit.hit_table[enemy] = nil
					end
				end)
			end

			if hit then
				ApplyDamage(damage_table)
			end

		end
	end

end

function modifier_Primary_spirits_handler:OnRemoved()
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
