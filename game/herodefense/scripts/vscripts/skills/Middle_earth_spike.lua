LinkLuaModifier("modifier_Middle_earth_spike", "skills/Middle_earth_spike", LUA_MODIFIER_MOTION_NONE)
Middle_earth_spike = class({})

function Middle_earth_spike:IsHiddenWhenStolen()
	return false
end 
function Middle_earth_spike:GetCastRange(vLocation, hTarget)
	local radius =self:GetSpecialValueFor("travel_distance")
	return radius
end


function Middle_earth_spike:OnSpellStart()
	-- 预防目标位置等于自身位置导致的bug
	local pos = self:GetCursorPosition()  
	if pos == self:GetCaster():GetAbsOrigin() then
		pos = pos + self:GetCaster():GetForwardVector()
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = pos                 
	local cast_response = "lion_lion_ability_spike_01"
	local sound_cast = "Hero_Lion.Impale"
	local particle_projectile = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf"    
	
	-- Ability specials
	local spike_speed = ability:GetSpecialValueFor("spike_speed")    
	local spikes_radius = ability:GetSpecialValueFor("spikes_radius")
	local travel_distance = ability:GetSpecialValueFor("travel_distance") + caster:GetCastRangeBonus()
	travel_distance = math.max(travel_distance,100)
	-- Roll for a cast response
	if RollPercentage(15) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	caster:EmitSound(sound_cast)        
			



	-- Decide direction
	local direction = (target - caster:GetAbsOrigin()):Normalized()
	
	-- Launch line projectile
	local spikes_projectile = { Ability = ability,
								EffectName = particle_projectile,
								vSpawnOrigin = caster:GetAbsOrigin(),
								fDistance = travel_distance,
								fStartRadius = spikes_radius,
								fEndRadius = spikes_radius,
								Source = caster,
								bHasFrontalCone = false,
								bReplaceExisting = false,
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                          
								iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,                           
								bDeleteOnHit = false,
								vVelocity = direction * spike_speed * Vector(1, 1, 0),
								bProvidesVision = false,
								-- ExtraData = {hit_targets_index = hit_targets_index, incoming_targets_index = incoming_targets_index, bounces_left = max_bounces_per_cast}
							}
							
	ProjectileManager:CreateLinearProjectile(spikes_projectile)
end

function Middle_earth_spike:OnProjectileHit_ExtraData(target, location, extra_data)

	-- If there was no target, do nothing
	if not target then
		return nil
	end    

	self:ApplyEffect(target,1)
	-- Ability properties
	
end



function Middle_earth_spike:ApplyEffect(target,level)
	local caster = self:GetCaster()      
	local ability = self    
	local sound_impact = "Hero_Lion.ImpaleHitTarget"
	local particle_hit = "particles/rebuild/spell/earth_spike/lion_spell_impale_hit_spikes.vpcf" 



	-- Ability specials 
	local knock_up_height = 200
	local knock_up_time = ability:GetSpecialValueFor("knock_up_time")
	local damage = ability:GetSpecialValueFor("basic_damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
	local stun_duration = ability:GetSpecialValueFor("stun_duration")

	if level==2 then
		local damage_index = 0.5
		damage = damage *damage_index
	end


	local target_position = target:GetAbsOrigin()
	-- target_position.z = 0 
	
	-- Add high spikes particles
	local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle_hit_fx, 0, target_position)
	ParticleManager:SetParticleControl(particle_hit_fx, 1, target_position)
	ParticleManager:SetParticleControl(particle_hit_fx, 2, target_position)
	ParticleManager:ReleaseParticleIndex(particle_hit_fx)
	
	-- Play hit sound
	caster:EmitSound(sound_impact)  



	-- If target has Linken's Sphere off cooldown, do nothing
	if target:TriggerSpellAbsorb(self) then
		return nil
	end
	
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local duration  = math.max(stun_duration*StatusResistance,knock_up_time)

	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})
	
	--地狱之息
	if level==1 then
		target:AddNewModifier(caster, ability, "modifier_Middle_earth_spike", {duration = 6})
	end
	

	-- Knockback unit to the air    
	local knockbackProperties =
	{
		center_x = target.x,
		center_y = target.y,
		center_z = target.z,
		duration = knock_up_time,
		knockback_duration = knock_up_time,
		knockback_distance = 0,
		knockback_height = knock_up_height
	}

	target:AddNewModifier( target, nil, "modifier_knockback", knockbackProperties )



	Timers:CreateTimer(knock_up_time, function()
	
		if not ability or ability:IsNull() then
			return
		end
		local damageTable = {victim = target,
							 attacker = caster, 
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL,
							 ability = ability
							}
	
		ApplyDamage(damageTable)        
	end)
end



modifier_Middle_earth_spike = class({})

function modifier_Middle_earth_spike:IsDebuff() return true end
function modifier_Middle_earth_spike:IsHidden() return false end
function modifier_Middle_earth_spike:IsPurgable() return false end


function modifier_Middle_earth_spike:OnDestroy()
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end
	--判断死亡
    if self:GetParent():GetHealth()<=0 then
		local radius = 400
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		for _, unit in pairs(units) do
			if unit:GetHealth()>0 then
				self:GetAbility():ApplyEffect(unit,2)
				break
			end


		end
		
	end

 

end