--特效优化 √
Advanced_shockwave = class({})
LinkLuaModifier( "modifier_Advanced_shockwave", "skills/Advanced_shockwave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_shockwave_debuff", "skills/Advanced_shockwave", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_shockwave_debuff2", "skills/Advanced_shockwave", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function Advanced_shockwave:CheckKV(key)
	local table = {
		damage = 10,
		bonus_damage=0.1,



	}
	-- if self:GetUnlock(2)==2 then
	-- 	table.damage_reflection_pct = 0.7
	-- end
	local value = table[key] or -1
	return value

end

function Advanced_shockwave:GetCastRange()
	-- local caster = self:GetCaster()
	if self:GetUnlock(1)==1 then
		return 1600
	end
	return 1200 

end
function Advanced_shockwave:OnAbilityPhaseStart()
	if not IsServer() then return end

	-- play effects
	self:PlayEffects1()

	return true
end

function Advanced_shockwave:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	-- stop effects
	self:StopEffects1( true )
end

function Advanced_shockwave:Spawn()
	self.active_proj = {}
	self.unlock2_target = self:GetCaster()
	self.unlock2_count = 0
end

function Advanced_shockwave:UnlockFirstCore(key)
	return true
end
function Advanced_shockwave:UnlockSecondCore(key)
	return true
end
function Advanced_shockwave:UnlockThirdCore(key)
	return true
end

function Advanced_shockwave:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_erupt.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/shockwave/unlock3/effect.vpcf", context )

	

end

function Advanced_shockwave:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
		end
		
	end

	return self.BaseClass.GetBehavior(self)
end


function Advanced_shockwave:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	if target == caster then
		return "#Spells_CustomCastError_NOT_SELF"
	end
	return ""
end

function Advanced_shockwave:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target == caster then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end


function Advanced_shockwave:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	if self.unlock2 then
		local target = self:GetCursorTarget()
		self.unlock2_target = target
		self.unlock2_count = self.unlock2_count + 1
		local point = target:GetAbsOrigin()
		if point ==caster:GetAbsOrigin() then
			point = point +caster:GetForwardVector()*50
		end

		-- stop effects
		self:StopEffects1( false )

		-- load data
		local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
		local distance = CalculateDistance(point,caster:GetAbsOrigin())
		local radius = 300
		local speed = distance/1.5
		
		local direction = point - caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = caster:GetAbsOrigin(),
			bDeleteOnHit = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			EffectName = name,
			fDistance = distance,
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = direction * speed,
		}
		local particle = ProjectileManager:CreateLinearProjectile(info)
		self.active_proj[particle] = {
			count_index = self.unlock2_count,
			target = self.unlock2_target,
			type = 1,
			sourcePos = caster:GetAbsOrigin(),
			startPos = caster:GetAbsOrigin(),
			damage_index = 1,
		}
		-- play effects
		local sound_cast = "Hero_Magnataur.ShockWave.Particle"
		EmitSoundOn( sound_cast, caster )
	else
		--普通效果
		local point = self:GetCursorPosition()
		if point ==caster:GetAbsOrigin() then
			point = point +caster:GetForwardVector()
		end
	
		-- stop effects
		self:StopEffects1( false )
	
		-- load data
		local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
		local distance = self:GetCastRange()
		local radius = 200
		if self.unlock3 then
			name = "particles/rebuild/spell/shockwave/unlock3/effect.vpcf"
			radius = 400
		end
		local speed = 1200
		
		local direction = point - caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		local bonus_count = 1
		local bonusDamage_index = 0.5
		if self.advanced_level>=5 then
			bonus_count = 2
			if self.advanced_level>=10 then
				bonusDamage_index = 0.75
			end
		end
		-- create projectile
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = caster:GetAbsOrigin(),
			
			bDeleteOnHit = true,
			
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			
			EffectName = name,
			fDistance = distance,
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = direction * speed,
		}
		local particle = ProjectileManager:CreateLinearProjectile(info)
		self.active_proj[particle] = {
			bonus_projectile = bonus_count,
			sourcePos = caster:GetAbsOrigin(),
			startPos = caster:GetAbsOrigin(),
			damage_index = 1,
		}
		local newpos1 = RotatePosition(caster:GetAbsOrigin(), QAngle(0, 30, 0), point)
		local newpos2 = RotatePosition(caster:GetAbsOrigin(), QAngle(0, -30, 0), point)
		direction = newpos1 - caster:GetAbsOrigin()
		direction.z = 0
		direction = direction:Normalized()
		info.vVelocity = direction*speed
		local particle = ProjectileManager:CreateLinearProjectile(info)
		self.active_proj[particle] = {
			bonus_projectile = bonus_count,
			sourcePos = caster:GetAbsOrigin(),
			startPos = caster:GetAbsOrigin(),
			damage_index = bonusDamage_index,
		}
		direction = newpos2 - caster:GetAbsOrigin()
		direction.z = 0
		direction = direction:Normalized()
		info.vVelocity = direction*speed
		local particle = ProjectileManager:CreateLinearProjectile(info)
		self.active_proj[particle] = {
			bonus_projectile = bonus_count,
			sourcePos = caster:GetAbsOrigin(),
			startPos = caster:GetAbsOrigin(),
			damage_index =bonusDamage_index,
		}
	
		-- play effects
		local sound_cast = "Hero_Magnataur.ShockWave.Particle"
		EmitSoundOn( sound_cast, caster )
	end



	
end

function Advanced_shockwave:CreateShockWave(source,target)
	local caster = self:GetCaster()
	local point = target
	local start_pos = source
	if point ==start_pos then
		point = point +caster:GetForwardVector()
	end
	local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	local distance = self:GetCastRange()
	local radius = 200
	if self.unlock3 then
		name = "particles/rebuild/spell/shockwave/unlock3/effect.vpcf"
		radius = 400
	end
	local speed = 1200
	
	local direction = point - start_pos
	direction.z = 0
	direction = direction:Normalized()
	local bonus_count = 1
	local bonusDamage_index = 0.5
	if self.advanced_level>=5 then
		bonus_count = 2
		if self.advanced_level>=10 then
			bonusDamage_index = 0.75
		end
	end
	-- create projectile
	local info = {
		Source = caster,
		-- vSpawnOrigin = source,
		Ability = self,
		vSpawnOrigin = start_pos,
		
		bDeleteOnHit = true,
		
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		
		EffectName = name,
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		vVelocity = direction * speed,
	}
	local particle = ProjectileManager:CreateLinearProjectile(info)
	self.active_proj[particle] = {
		bonus_projectile = bonus_count,
		sourcePos = start_pos,
		startPos = start_pos,
		damage_index = 1,
	}
	local newpos1 = RotatePosition(start_pos, QAngle(0, 30, 0), point)
	local newpos2 = RotatePosition(start_pos, QAngle(0, -30, 0), point)
	direction = newpos1 - start_pos
	direction.z = 0
	direction = direction:Normalized()
	info.vVelocity = direction*speed
	local particle = ProjectileManager:CreateLinearProjectile(info)
	self.active_proj[particle] = {
		bonus_projectile = bonus_count,
		sourcePos = start_pos,
		startPos = start_pos,
		damage_index = bonusDamage_index,
	}
	direction = newpos2 - start_pos
	direction.z = 0
	direction = direction:Normalized()
	info.vVelocity = direction*speed
	local particle = ProjectileManager:CreateLinearProjectile(info)
	self.active_proj[particle] = {
		bonus_projectile = bonus_count,
		sourcePos = start_pos,
		startPos = start_pos,
		damage_index =bonusDamage_index,
	}

	-- play effects
	local sound_cast = "Hero_Magnataur.ShockWave.Particle"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile

function Advanced_shockwave:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		local caster = self:GetCaster()

		if not target then

			if self.active_proj[handle].target  then
				if self.active_proj[handle].count_index ~=self.unlock2_count then
					--将被新的震荡波代替
					return
				end
				--目标死亡或不存在
				local target_unit = self.active_proj[handle].target
				if not target_unit or target_unit:IsNull() or not target_unit:IsAlive() then
					return
				end
				local caster = self:GetCaster()
				--施法者死亡
				if not caster or not caster:IsAlive() then
					return
				end
				--通过 处理往返逻辑
				local target_ponit
				local distance
				local direction 
				if self.active_proj[handle].type==1 then
					--接下来是返回
					target_ponit = caster:GetAbsOrigin()
					if target_ponit ==location then
						target_ponit = target_ponit +target_unit:GetForwardVector()*50
					end
					distance = CalculateDistance(target_ponit,location)
					direction = target_ponit - location
					direction.z = 0
					direction = direction:Normalized()
			
					local sound_cast = "Hero_Magnataur.ShockWave.Particle"
					EmitSoundOn( sound_cast, target_unit )
				else
					target_ponit = target_unit:GetAbsOrigin()
					if target_ponit ==location then
						target_ponit = target_ponit +caster:GetForwardVector()*50
					end
					distance = CalculateDistance(target_ponit,location)
					direction = target_ponit - location
					direction.z = 0
					direction = direction:Normalized()
					local sound_cast = "Hero_Magnataur.ShockWave.Particle"
					EmitSoundOn( sound_cast, caster )
				end
				local speed = distance/1.5
				local info = {
					Source = caster,
					Ability = self,
					vSpawnOrigin =location,
					
					bDeleteOnHit = false,
					
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					
					EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
					fDistance = distance,
					fStartRadius = 300,
					fEndRadius = 300,
					vVelocity = direction * speed,


					bHasFrontalCone = false,
					bReplaceExisting = false,
				}
				local particle = ProjectileManager:CreateLinearProjectile(info)
				
				self.active_proj[particle] = {
					count_index  = self.active_proj[handle].count_index,
					target =  self.active_proj[handle].target,
					type = -self.active_proj[handle].type,
					sourcePos = location,
					startPos = caster:GetAbsOrigin(),
					damage_index =1,
				}

			else
				--一般效果
				if self.active_proj[handle].bonus_projectile >0 then
					local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
					local point = self.active_proj[handle].sourcePos
					if point==location then
						point = point + caster:GetForwardVector()
					end
					local distance = self:GetCastRange(point, nil )
					local radius = 200
					local speed = 1200
					if self.unlock3 then
						name = "particles/rebuild/spell/shockwave/unlock3/effect.vpcf"
						radius = 400
					end
					local direction = point - location
					direction.z = 0
					direction = direction:Normalized()
				
					-- create projectile
					local info = {
						Source = caster,
						Ability = self,
						vSpawnOrigin =location,
						
						bDeleteOnHit = false,
						
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						
						EffectName = name,
						fDistance = distance,
						fStartRadius = radius,
						fEndRadius = radius,
						vVelocity = direction * speed,
	
	
						bHasFrontalCone = false,
						bReplaceExisting = false,
					}
		
					local particle = ProjectileManager:CreateLinearProjectile(info)
					self.active_proj[particle] = {
						sourcePos = location,
						damage_index = self.active_proj[handle].damage_index*0.5,
						startPos = self.active_proj[handle].startPos,
						bonus_projectile = self.active_proj[handle].bonus_projectile-1,
					}
					if self.advanced_level>=20 and self:GetCaster():GetRandomEffect(15,INT_TYPE,1) >=RandomInt(1, 100) then
						local newpos1 = RotatePosition(location, QAngle(0, 30, 0), point)
						local newpos2 = RotatePosition(location, QAngle(0, -30, 0), point)
						direction = newpos1 - location
						direction.z = 0
						direction = direction:Normalized()
						info.vVelocity = direction*speed
						local particle = ProjectileManager:CreateLinearProjectile(info)
						self.active_proj[particle] = {
							bonus_projectile = self.active_proj[handle].bonus_projectile-1,
							sourcePos = location,
							startPos = caster:GetAbsOrigin(),
							damage_index = self.active_proj[handle].damage_index*0.5,
						}
						direction = newpos2 - location
						direction.z = 0
						direction = direction:Normalized()
						info.vVelocity = direction*speed
						local particle = ProjectileManager:CreateLinearProjectile(info)
						self.active_proj[particle] = {
							bonus_projectile = self.active_proj[handle].bonus_projectile-1,
							sourcePos = location,
							startPos = caster:GetAbsOrigin(),
							damage_index =self.active_proj[handle].damage_index*0.5,
						}
					end
				end
			end

		

			--奥义一效果
			if self.unlock1 then
				local point = self.active_proj[handle].sourcePos
				if point==location then
					point = point + caster:GetForwardVector()
				end
				local radius = 200
				local direction = point - location
				direction.z = 0
				direction = direction:Normalized()
				local distance = self:GetCastRange(point, nil )
				local end_point = point-distance*direction
				Timers:CreateTimer(0.4, function()
					if self and not self:IsNull() then
						

						local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_erupt.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(pfx, 0, point)
						ParticleManager:SetParticleControl(pfx, 1,end_point)
						-- ParticleManager:ReleaseParticleIndex( pfx )
						DestroyParticleByDelay(pfx,5)
						caster:EmitSound("Hero_Magnataur.ShockWave.Particle.Anvil")
						local tTargets = FindUnitsInLine(caster:GetTeamNumber(), point, end_point, nil, radius,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_NONE)
						print(#tTargets)
						local damageTable = {
							attacker = caster,
							damage = caster:GetAverageTrueAttackDamage(nil)*0.5,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
						}
				
						for _, enemy in pairs(tTargets) do
							-- print("go")
							enemy:AddNewModifier(caster,self, "modifier_Advanced_shockwave_debuff2",{ duration = 5 } )
							damageTable.victim = enemy
							ApplyDamage(damageTable)
						end
					

					end
				end)
			end
			self.active_proj[handle] = nil

			return true
		end


		

		-- get data
		
		local damage_type = self:GetAbilityDamageType()
		local damage = (self:GetSpecialValueFor( "damage" )+self:GetSpecialValueFor( "bonus_damage" )*caster:GetStrength())*self.active_proj[handle].damage_index
		if self.unlock3 then
			damage = damage + caster:GetDamageMax()*1.5
			damage_type = DAMAGE_TYPE_PHYSICAL
		end
		
		local duration = self:GetSpecialValueFor( "slow_duration" )

	
		local pull_duration = 0.4
		local pull_distance = 200
	
		-- pull
		local mod = target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				target_x = self.active_proj[handle].startPos.x,
				target_y = self.active_proj[handle].startPos.y,
				duration = pull_duration,
				distance = pull_distance,
				activity = ACT_DOTA_FLAIL,
			} -- kv
		)
	

		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	
		-- slow
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_shockwave", -- modifier name
			{ duration = duration*StatusResistance } -- kv
		)
		if self.advanced_level>=15 then
			local modifier = target:FindModifierByName("modifier_Advanced_shockwave_debuff")
			if modifier then
				damage = damage *(modifier:GetStackCount()*0.1+1)
			end
			target:AddNewModifier(caster, self, "modifier_Advanced_shockwave_debuff", {duration =5})
		end
		-- play effects
		self:PlayEffects2( target, mod )
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = damage_type,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
	end
end
--------------------------------------------------------------------------------
-- Effects
function Advanced_shockwave:PlayEffects2( target, mod )
	if not mod then
		return
	end
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf"
	local sound_cast = "Hero_Magnataur.ShockWave.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	mod:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function Advanced_shockwave:PlayEffects1()
	local caster = self:GetCaster()

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf"
	local sound_cast = "Hero_Magnataur.ShockWave.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, caster )
end

function Advanced_shockwave:StopEffects1( interrupted )
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local sound_cast = "Hero_Magnataur.ShockWave.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
end




modifier_Advanced_shockwave = class({})


function modifier_Advanced_shockwave:IsHidden()	return false end
function modifier_Advanced_shockwave:IsDebuff()	return true end
function modifier_Advanced_shockwave:IsStunDebuff()	return false end
function modifier_Advanced_shockwave:IsPurgable()	return true end
function modifier_Advanced_shockwave:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow" )
	if not IsServer() then return end
end


function modifier_Advanced_shockwave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_shockwave:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end


function modifier_Advanced_shockwave:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf"
end

function modifier_Advanced_shockwave:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




modifier_Advanced_shockwave_debuff = class({})

function modifier_Advanced_shockwave_debuff:IsDebuff() return true end
function modifier_Advanced_shockwave_debuff:IsHidden() return false end
function modifier_Advanced_shockwave_debuff:IsPurgable() return false end
function modifier_Advanced_shockwave_debuff:IsPurgeException() return false end



function modifier_Advanced_shockwave_debuff:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_shockwave_debuff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_shockwave_debuff:OnIntervalThink()
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





modifier_Advanced_shockwave_debuff2 = advanced_modifier({})

function modifier_Advanced_shockwave_debuff2:IsDebuff() return true end
function modifier_Advanced_shockwave_debuff2:IsHidden() return false end
function modifier_Advanced_shockwave_debuff2:IsPurgable() return false end
function modifier_Advanced_shockwave_debuff2:IsPurgeException() return false end



function modifier_Advanced_shockwave_debuff2:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_shockwave_debuff2:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_shockwave_debuff2:OnIntervalThink()
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


function modifier_Advanced_shockwave_debuff2:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_shockwave_debuff2:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_shockwave_debuff2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_shockwave_debuff2:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()*2
end