
creeps_spell_Rolling_Boulder =  class({})
LinkLuaModifier("modifier_creeps_spell_Rolling_Boulder", "creeps_spell/creeps_spell_Rolling_Boulder", LUA_MODIFIER_MOTION_NONE)		-- Movement handler

LinkLuaModifier("modifier_creeps_spell_Rolling_Boulder_death", "creeps_spell/creeps_spell_Rolling_Boulder", LUA_MODIFIER_MOTION_NONE)	

function creeps_spell_Rolling_Boulder:IsNetherWardStealable() return false end

function creeps_spell_Rolling_Boulder:GetAssociatedSecondaryAbilities()
	return "imba_earth_spirit_stone_remnant" end

function creeps_spell_Rolling_Boulder:GetCastRange()
	if IsClient() then		-- Indicating no-remnant maximum range
		return self:GetSpecialValueFor("roll_distance")
	else					-- So you can click wherever and roll in that direction, even if its out of range
		return 30000
	end
end
function creeps_spell_Rolling_Boulder:Spawn()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Rolling_Boulder_death", {})
	end
end

function creeps_spell_Rolling_Boulder:OnSpellStart()
	if IsServer() then
		EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Cast", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Rolling_Boulder", {})
	end
end

-----	Movement handler
modifier_creeps_spell_Rolling_Boulder =  advanced_modifier({})
function modifier_creeps_spell_Rolling_Boulder:IsHidden() return true end
function modifier_creeps_spell_Rolling_Boulder:IsMotionController() return true end
function modifier_creeps_spell_Rolling_Boulder:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_creeps_spell_Rolling_Boulder:GetEffectName()
	return "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf" end

function modifier_creeps_spell_Rolling_Boulder:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creeps_spell_Rolling_Boulder:CheckState()		
	return	
	{	
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
end

function modifier_creeps_spell_Rolling_Boulder:OnCreated()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("creeps_spell_earth_return")
		if ability then
			self.earth_return = ability
			self.damage_to_heal_hero = self.earth_return:GetSpecialValueFor("damage_to_heal_hero")*0.01
			self.damage_to_heal_basic = self.earth_return:GetSpecialValueFor("damage_to_heal_basic")*0.01
		end

		self.ability = self:GetAbility()
		self.caster = self:GetCaster()
		self.casterTeam = self.caster:GetTeamNumber()
		
		-- ability params
		self.delay = 0.25
		self.hitRadius = self.ability:GetSpecialValueFor("hit_radius")
		self.Radius = self.ability:GetSpecialValueFor("radius")
		self.damage = self.ability:GetSpecialValueFor("damage") * self.caster:GetBaseDamageMax()

		self.normalDistance = self.ability:GetSpecialValueFor("distance")
		self.normalVelocity = 100
		self.max_speed = self.ability:GetSpecialValueFor("speed")
		-- extra handlers
		self.hitRemnant = false
		self.traveled = 0
		self.direction = (self.caster:GetCursorPosition() - self.caster:GetAbsOrigin()):Normalized()
		
		self.hitEnemies = {}
		self.hitEnemies2 = {}
		
		self.caster:EmitSound("Hero_EarthSpirit.RollingBoulder.Loop")
		self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
		local ability = self:GetAbility()
		Timers:CreateTimer(self.delay, function()
			if not ability or ability:IsNull() then
				return
			end
			self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
			self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL)
		end)
		-- Disable ability
		self.ability:SetActivated(false)
		-- start thinking
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_creeps_spell_Rolling_Boulder:OnIntervalThink()
	if IsServer() then
		self.caster:SetForwardVector(self.direction)
		
		if self.delay > 0 then
			self.delay = self.delay - FrameTime()
		else
			self:HorizontalMotion(FrameTime())
			if not self.hitRemnant then
				local unit = FindUnitsInRadius(self.casterTeam, self.caster:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				 DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				 if #unit<1 then
					 return
				 end
				local RemnantFinder = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,
				 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
				for _, r in ipairs(RemnantFinder) do
					if r~=self.caster and  r:HasModifier("modifier_creeps_spell_Rolling_Boulder")  then
						local remnantModifier = r:FindModifierByName("modifier_creeps_spell_Rolling_Boulder")
						if remnantModifier then remnantModifier:SafeDestroy() end
						EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Stone", self.caster)
						self.hitRemnant = true
						self.trigger = 1
						self:SafeDestroy()
						break
					end
				end
			end
			
			local units = FindUnitsInRadius(self.casterTeam, self.caster:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local healing  = 0 
			for _, unit in ipairs(units) do
				if not self.hitEnemies[unit:GetEntityIndex()] then
					self.hitEnemies[unit:GetEntityIndex()] = true
					local damage = ApplyDamage({victim = unit, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
					if self.earth_return then
						if unit:IsRealHero() then
							healing = healing +  self.damage_to_heal_hero*damage
							self.earth_return:InsertTarget(unit)
						else
							healing = healing +  self.damage_to_heal_basic*damage
						end
					end

				end
			end
			if healing>0 then
				if not self.caster:PassivesDisabled() then
					local fhealing =  HealWithGain(healing,self.caster,self.caster,self:GetAbility())
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.caster, fhealing, nil) 
					self.earth_return:InsertHealing(fhealing)
				end
				
			end

			self:HorizontalMotion(FrameTime())
		end
	end
end

function modifier_creeps_spell_Rolling_Boulder:HorizontalMotion(dt)
	if IsServer() then
		if self.hitRemnant then
			self.trigger = 1
			self:SafeDestroy()
		else
			if self.traveled < self.normalDistance then

				self.normalVelocity = math.min(self.normalVelocity+30,self.max_speed)
				-- self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + self.direction * self.normalVelocity * dt)
				self.caster:SetOrigin(self.caster:GetAbsOrigin() + self.direction * self.normalVelocity * dt)
				self.traveled = self.traveled + self.normalVelocity * dt
				
				self.caster:SetAbsOrigin(Vector(self.caster:GetAbsOrigin().x, self.caster:GetAbsOrigin().y, GetGroundHeight(self.caster:GetAbsOrigin(), self.caster)))
			else
				FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), false)
				EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Destroy", self.caster)
				self:SafeDestroy()
			end
		end

	end
end

function modifier_creeps_spell_Rolling_Boulder:OnDestroy()
	if IsServer() then
		self.caster:StopSound("Hero_EarthSpirit.RollingBoulder.Loop")
		self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
		self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL)
		self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END)
		
		-- Reenable ability
		self.ability:SetActivated(true)

		if self.trigger == 1 then
			local damage = self.ability:GetSpecialValueFor("bonus_damage")*self:GetParent():GetBaseDamageMax()
		    local earthshock_particle_fx =	ParticleManager:CreateParticle("particles/econ/items/ursa/ursa_ti10/ursa_ti10_earthshock.vpcf", PATTACH_ABSORIGIN, self.caster)
		    ParticleManager:SetParticleControl(earthshock_particle_fx, 0, self.caster:GetAbsOrigin())
	    	ParticleManager:SetParticleControl(earthshock_particle_fx, 1, Vector(200,200,200))
		    ParticleManager:ReleaseParticleIndex(earthshock_particle_fx)
			local units = FindUnitsInRadius(self.casterTeam, self.caster:GetAbsOrigin(), nil, self.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			 DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local healing = 0
		   for _, unit in ipairs(units) do
			   if not self.hitEnemies2[unit:GetEntityIndex()]  then
				   self.hitEnemies2[unit:GetEntityIndex()] = true
				   if self.earth_return then
					if unit:IsRealHero() then
						healing = healing +  self.damage_to_heal_hero* unit:GetHealth()
						self.earth_return:InsertTarget(unit)
					else
						healing = healing +  self.damage_to_heal_basic* unit:GetHealth()
					end
				end
				   ApplyDamage({victim = unit, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
		
			   end
		   end

		   if healing>0 then
				local fhealing =  HealWithGain(healing,self.caster,self.caster,self:GetAbility())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.caster, fhealing, nil) 
				self.earth_return:InsertHealing(fhealing)
			end
		end
		
		Timers:CreateTimer(0.6, function()
			self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END)
		end)
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_phased", {duration=0.1}) --提供相位，防止卡位
	end
end



function modifier_creeps_spell_Rolling_Boulder:ADDeclareFunctions()
	if self:GetParent():HasModifier("creeps_spell_earth_return") then
		return 
		{
			advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		}
	end
   return {}
end
function modifier_creeps_spell_Rolling_Boulder:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -100
end


require('internal/timers')   --计时器功能
modifier_creeps_spell_Rolling_Boulder_death = class({})

function modifier_creeps_spell_Rolling_Boulder_death:IsDebuff()			return false end
function modifier_creeps_spell_Rolling_Boulder_death:IsHidden() 			return true end
function modifier_creeps_spell_Rolling_Boulder_death:IsPurgable() 		return false end
function modifier_creeps_spell_Rolling_Boulder_death:IsPurgeException() 	return false  end
function modifier_creeps_spell_Rolling_Boulder_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_earth_death.vpcf", context )
end

function modifier_creeps_spell_Rolling_Boulder_death:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_earth_death.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		local scale = parent:GetModelScale()
		local timer = 0
		Timers:CreateTimer(FrameTime(), function()
			timer = timer + FrameTime()
			if timer>=0.4 then
				parent:AddNoDraw()
				return nil
			end
			scale = scale*0.95
			parent:SetModelScale(scale)

			return FrameTime()
			
		end)
		
	end
end

