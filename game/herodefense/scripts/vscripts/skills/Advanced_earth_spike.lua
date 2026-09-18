--特效优化 √
LinkLuaModifier("modifier_Advanced_earth_spike", "skills/Advanced_earth_spike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_earth_spike_gain", "skills/Advanced_earth_spike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_earth_spike_unlock2_aura", "skills/Advanced_earth_spike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_earth_spike_unlock2_aura_effect", "skills/Advanced_earth_spike", LUA_MODIFIER_MOTION_NONE)
Advanced_earth_spike = class({})

function Advanced_earth_spike:CheckKV(key)
	local table = {

		basic_damage =30,
		bonus_damage = 0.15,

	}
	local value = table[key] or -1
	return value

end
function Advanced_earth_spike:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_kraken_shell_unlock1",{})
	return true
end
function Advanced_earth_spike:UnlockSecondCore(key)
	return true
end
function Advanced_earth_spike:UnlockThirdCore(key)
	return true
end

function Advanced_earth_spike:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		
	end

	return self.BaseClass.GetBehavior(self)
end



function Advanced_earth_spike:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/earth_spike/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lion/lion_ti9/lion_spell_impale_ti9.vpcf", context )


end
function Advanced_earth_spike:GetIntrinsicModifierName()
	return "modifier_Advanced_earth_spike_gain"
end

function Advanced_earth_spike:IsHiddenWhenStolen()
	return false
end 
function Advanced_earth_spike:GetCastRange(vLocation, hTarget)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	local radius =self:GetSpecialValueFor("travel_distance")
	--LV15解锁广域化
	if advanced_level>=15 then
		radius = 3000
	end

	return radius
end


function Advanced_earth_spike:OnSpellStart()
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
	local dis =  ability:GetSpecialValueFor("travel_distance")
	--LV15解锁广域化
	if self.advanced_level>=15 then
		dis = 3000
	end
	local travel_distance = dis + caster:GetCastRangeBonus()

	-- Roll for a cast response
	if RollPercentage(15) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	caster:EmitSound(sound_cast)        
			

	local modifier = caster:FindModifierByName("modifier_Advanced_earth_spike_gain")
	--潜影之灵增幅
	if modifier then
		local max_stack = 150
		--LV10解锁潜影之灵+
		if ability.advanced_level>=10 then
			max_stack = 250
		end
		modifier:SetStackCount(math.min(modifier:GetStackCount()+10,max_stack))
	end


	-- Decide direction
	local direction = (target - caster:GetAbsOrigin()):Normalized()
	
	local bonus_damage = 0
	if self:GetAutoCastState() then
		local mana = caster:GetMana()
		caster:SetMana(0)
		bonus_damage = mana
		particle_projectile = "particles/econ/items/lion/lion_ti9/lion_spell_impale_ti9.vpcf"
	end
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
								ExtraData = {bonus_damage = bonus_damage}
							}
							
	ProjectileManager:CreateLinearProjectile(spikes_projectile)
end

function Advanced_earth_spike:OnProjectileHit_ExtraData(target, location, extra_data)

	-- If there was no target, do nothing
	if not target then
		return nil
	end    

	self:ApplyEffect(target,extra_data.bonus_damage,1)
	-- Ability properties
	
end



function Advanced_earth_spike:ApplyEffect(target,bonus_damage,level)
	local caster = self:GetCaster()      
	local ability = self    
	local sound_impact = "Hero_Lion.ImpaleHitTarget"
	local particle_hit = "particles/rebuild/spell/earth_spike/lion_spell_impale_hit_spikes.vpcf"  
	local trigger_unlock2 = false
	if self.unlock2 then
		trigger_unlock2 = true
	end

	if self.unlock3 and level==1 then
		local ability = caster:FindAbilityByName("Advanced_finger_of_death")
		if ability then
			ability:SingleSpellEffect(target)
		end
	end

	-- Ability specials 
	local knock_up_height = 200
	local knock_up_time = ability:GetSpecialValueFor("knock_up_time")
	local damage = ability:GetSpecialValueFor("basic_damage")+(ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)+bonus_damage
	local stun_duration = ability:GetSpecialValueFor("stun_duration")

	if level==2 then
		local damage_index = 0.5
		--LV5解锁地狱之息+
		if ability.advanced_level>=5 then
			damage_index = 0.75
		end
		damage = damage *damage_index
	end


	--潜影之灵
	local modifier = caster:FindModifierByName("modifier_Advanced_earth_spike_gain")
	if modifier then
		damage = damage * (1+modifier:GetStackCount()*0.01)
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
		target:AddNewModifier(caster, ability, "modifier_Advanced_earth_spike", {duration = 6,bonus_damage=bonus_damage})
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
	if trigger_unlock2 and caster:GetRandomEffect(10,INT_TYPE,1)  > RandomInt(1, 100) then
		self:CreateUnlock2Aura(target:GetOrigin())
		trigger_unlock2 = false
	end

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
	
		local damage = ApplyDamage(damageTable) 
		--LV20解锁摄灵      
		if self.advanced_level>=20 then
			caster:GiveMana(math.min(damage*0.03,caster:GetIntellect(false)*0.3))
		end
		if target:GetHealth()<=0 then

			if trigger_unlock2 then
				self:CreateUnlock2Aura(target:GetOrigin())
			end
			--潜影之灵增幅
			if modifier then
				local max_stack = 150
				--LV10解锁潜影之灵+
				if ability.advanced_level>=10 then
					max_stack = 250
				end
				modifier:SetStackCount(math.min(modifier:GetStackCount()+3,max_stack))
			end
		end 
	end)
end

function Advanced_earth_spike:CreateUnlock2Aura(location)
	EmitSoundOnLocationWithCaster(location, "Hero_DeathProphet.Silence", caster)
	CreateModifierThinker(self:GetCaster(), self, "modifier_Advanced_earth_spike_unlock2_aura", {duration = 5},location, self:GetCaster():GetTeamNumber(), false)
end

modifier_Advanced_earth_spike = class({})

function modifier_Advanced_earth_spike:IsDebuff() return true end
function modifier_Advanced_earth_spike:IsHidden() return false end
function modifier_Advanced_earth_spike:IsPurgable() return false end
function modifier_Advanced_earth_spike:OnCreated(keys)
	if IsServer() then
		self.bonus_damage = keys.bonus_damage
	end
end

function modifier_Advanced_earth_spike:OnDestroy()
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
		local ability =self:GetAbility()
		--LV5解锁地狱之息+
		if ability.advanced_level>=5 then
			radius = 600
		end
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		for _, unit in pairs(units) do
			if unit:GetHealth()>0 then
				ability:ApplyEffect(unit,self.bonus_damage,2)
				break
			end


		end
		
	end

 

end



modifier_Advanced_earth_spike_gain = advanced_modifier({})

function modifier_Advanced_earth_spike_gain:IsDebuff() return false end
function modifier_Advanced_earth_spike_gain:IsHidden() return false end
function modifier_Advanced_earth_spike_gain:IsPurgable() 		return false end
function modifier_Advanced_earth_spike_gain:IsPurgeException() 	return false end
function modifier_Advanced_earth_spike_gain:RemoveOnDeath()  return false end


function modifier_Advanced_earth_spike_gain:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end




function modifier_Advanced_earth_spike_gain:OnWaveEnd()
    if IsServer() then
		self:SetStackCount(0)
	end
end







modifier_Advanced_earth_spike_unlock2_aura = class({})

function modifier_Advanced_earth_spike_unlock2_aura:IsAura() return true end
function modifier_Advanced_earth_spike_unlock2_aura:GetAuraDuration() return 1 end
function modifier_Advanced_earth_spike_unlock2_aura:GetModifierAura() return "modifier_Advanced_earth_spike_unlock2_aura_effect" end
function modifier_Advanced_earth_spike_unlock2_aura:GetAuraRadius() return 350 end
function modifier_Advanced_earth_spike_unlock2_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_earth_spike_unlock2_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_earth_spike_unlock2_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
-- function modifier_Advanced_earth_spike_unlock2_aura:GetAuraEntityReject(unit) return self:GetCaster() ~= unit end

function modifier_Advanced_earth_spike_unlock2_aura:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/earth_spike/unlock2/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(350, 1, 1))
		-- self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_Advanced_earth_spike_unlock2_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx,false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		UTIL_Remove(self:GetParent())
	end
end

modifier_Advanced_earth_spike_unlock2_aura_effect = class({})

function modifier_Advanced_earth_spike_unlock2_aura_effect:IsDebuff()			return false end
function modifier_Advanced_earth_spike_unlock2_aura_effect:IsHidden() 		return true end
function modifier_Advanced_earth_spike_unlock2_aura_effect:IsPurgable() 		return false end
function modifier_Advanced_earth_spike_unlock2_aura_effect:IsPurgeException() return false end
function modifier_Advanced_earth_spike_unlock2_aura_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_earth_spike_unlock2_aura_effect:DeclareFunctions()
return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end
function modifier_Advanced_earth_spike_unlock2_aura_effect:GetModifierMagicalResistanceBonus()	return -20 end



