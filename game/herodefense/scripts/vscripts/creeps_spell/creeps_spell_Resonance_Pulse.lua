LinkLuaModifier("modifier_creeps_spell_Resonance_Pulse_ring", "creeps_spell/creeps_spell_Resonance_Pulse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Resonance_Pulse_physical_buff", "creeps_spell/creeps_spell_Resonance_Pulse", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Resonance_Pulse_death", "creeps_spell/creeps_spell_Resonance_Pulse", LUA_MODIFIER_MOTION_NONE)

creeps_spell_Resonance_Pulse							= creeps_spell_Resonance_Pulse or class({})
modifier_creeps_spell_Resonance_Pulse_ring			= modifier_creeps_spell_Resonance_Pulse_ring or class({})
modifier_creeps_spell_Resonance_Pulse_physical_buff	= modifier_creeps_spell_Resonance_Pulse_physical_buff or class({})


function creeps_spell_Resonance_Pulse:Spawn()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Resonance_Pulse_death", {})
	end
end


function creeps_spell_Resonance_Pulse:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_VoidSpirit.Pulse.Cast")
	self:GetCaster():EmitSound("Hero_VoidSpirit.Pulse")
	
	local pulse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(pulse_particle, 1, Vector(self:GetSpecialValueFor("speed"), 1, 0))
	ParticleManager:ReleaseParticleIndex(pulse_particle)
	
	self:GetCaster():RemoveModifierByName("modifier_creeps_spell_Resonance_Pulse_physical_buff")

	
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Resonance_Pulse_ring", {
		duration 			= self:GetSpecialValueFor("radius") / self:GetSpecialValueFor("speed"),

	})

end

function creeps_spell_Resonance_Pulse:OnProjectileHit(target, location)
	if target then
		if target == self:GetCaster() then
			if target:HasModifier("modifier_creeps_spell_Resonance_Pulse_physical_buff") then
				target:FindModifierByName("modifier_creeps_spell_Resonance_Pulse_physical_buff"):SetStackCount(target:FindModifierByName("modifier_creeps_spell_Resonance_Pulse_physical_buff"):GetStackCount() + self:GetSpecialValueFor("bonus_shield")*self:GetCaster():GetBaseDamageMax())
			else
				target:AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Resonance_Pulse_physical_buff", {duration = self:GetSpecialValueFor("duration")})
			end
		end
	end
end

---------------------------------------------------
-- MODIFIER_creeps_spell_Resonance_Pulse_RING --
---------------------------------------------------

function modifier_creeps_spell_Resonance_Pulse_ring:IsHidden()	return true end
function modifier_creeps_spell_Resonance_Pulse_ring:IsPurgable()	return false end
function modifier_creeps_spell_Resonance_Pulse_ring:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creeps_spell_Resonance_Pulse_ring:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf"
end

-- Do I just assume this ring has a thickness of 1 or something
-- I guess make it 50 to be reasonable
function modifier_creeps_spell_Resonance_Pulse_ring:OnCreated(keys)
	self.speed	 					= self:GetAbility():GetSpecialValueFor("speed")
	self.return_projectile_speed	= self:GetAbility():GetSpecialValueFor("return_projectile_speed")
	self.equal_exchange_duration	= self:GetAbility():GetSpecialValueFor("duration")
	
	if not IsServer() then return end
	
	self.damage		= self:GetAbility():GetSpecialValueFor("damage")*self:GetCaster():GetBaseDamageMax()
	self.radius 	= self:GetAbility():GetSpecialValueFor("radius")
	self.thickness = 120
	
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.hit_enemies	= {}
	self.ring_size		= 0
	self.center 		= self:GetParent():GetAbsOrigin()
	

	
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end
--圆环的计时器
function modifier_creeps_spell_Resonance_Pulse_ring:OnIntervalThink()
	self.ring_size = self:GetElapsedTime() * self.speed
	if self.ring_size > self.radius then
		self.ring_size = self.radius
	end
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.center, nil, self.ring_size, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		local distance = CalculateDistance(enemy, self.center)		
		if not self.hit_enemies[enemy:entindex()] and distance < self.ring_size + self.thickness and distance > self.ring_size - self.thickness then
		
			enemy:EmitSound("Hero_VoidSpirit.Pulse.Target")
			
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
            self.damage = self.damage +self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetBaseDamageMax()


			
			self.hit_enemies[enemy:entindex()] = true
			
		
		end
	end
    for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.center, nil, self.ring_size, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		local distance = CalculateDistance(unit, self.center)		
		if not self.hit_enemies[unit:entindex()] and distance < self.ring_size + self.thickness and distance > self.ring_size - self.thickness and unit~= self:GetCaster() then
		
			unit:EmitSound("Hero_VoidSpirit.Pulse.Target")
			
			self.impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(self.impact_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.impact_particle)
			
			if unit:IsAlive() then
				ProjectileManager:CreateTrackingProjectile({
					EffectName			= "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf",
					Ability				= self:GetAbility(),
					Source				= unit:GetAbsOrigin(),
					vSourceLoc			= unit:GetAbsOrigin(),
					Target				= self:GetParent(),
					iMoveSpeed			= self.return_projectile_speed,
					-- flExpireTime		= nil,
					bDodgeable			= false,
					bIsAttack			= false,
					bReplaceExisting	= false,
					iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					bDrawsOnMinimap		= nil,
					bVisibleToEnemies	= true,
					bProvidesVision		= false,
					iVisionRadius		= nil,
					iVisionTeamNumber	= nil,
					ExtraData			= {}
				})
				
				-- IMBAfication: Expansion Dome

			end
			
			self.hit_enemies[unit:entindex()] = true
		end
	end
end

------------------------------------------------------------
-- MODIFIER_creeps_spell_Resonance_Pulse_PHYSICAL_BUFF --
------------------------------------------------------------
function modifier_creeps_spell_Resonance_Pulse_physical_buff:IsHidden()return false end
function modifier_creeps_spell_Resonance_Pulse_physical_buff:IsDebuff() return false end
function modifier_creeps_spell_Resonance_Pulse_physical_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_creeps_spell_Resonance_Pulse_physical_buff:OnCreated()

	if not IsServer() then return end
	self.base_absorb_amount	= self:GetAbility():GetSpecialValueFor("base_absorb_amount")+self:GetAbility():GetSpecialValueFor("bonus_shield")*self:GetCaster():GetBaseDamageMax()
	
	-- Arbitrary side-by-side testing
	self.radius				= 130
	
	self.shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.shield_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.shield_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.shield_particle, false, false, -1, false, false)
	
	self:SetStackCount(self.base_absorb_amount)
end

function modifier_creeps_spell_Resonance_Pulse_physical_buff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_VoidSpirit.Pulse.Destroy")
end

function modifier_creeps_spell_Resonance_Pulse_physical_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT}
end

function modifier_creeps_spell_Resonance_Pulse_physical_buff:GetModifierIncomingPhysicalDamageConstant(keys)
	if IsClient() then
		return
	end
	if self:GetParent():IsBlockDisabled() then
        return
    end
	self.deflect_particle	= ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.deflect_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.deflect_particle, 1, Vector(self.radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(self.deflect_particle)

	if keys.damage >= self:GetStackCount() then
		self:SafeDestroy()
		return self:GetStackCount() * (-1)
	else
		self:SetStackCount(self:GetStackCount() - keys.damage)
		return keys.damage * (-1)
	end
end

require('internal/timers')   --计时器功能
modifier_creeps_spell_Resonance_Pulse_death = class({})

function modifier_creeps_spell_Resonance_Pulse_death:IsDebuff()			return false end
function modifier_creeps_spell_Resonance_Pulse_death:IsHidden() 			return true end
function modifier_creeps_spell_Resonance_Pulse_death:IsPurgable() 		return false end
function modifier_creeps_spell_Resonance_Pulse_death:IsPurgeException() 	return false  end
function modifier_creeps_spell_Resonance_Pulse_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_void_death.vpcf", context )
end

function modifier_creeps_spell_Resonance_Pulse_death:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_void_death.vpcf", PATTACH_WORLDORIGIN, nil )
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