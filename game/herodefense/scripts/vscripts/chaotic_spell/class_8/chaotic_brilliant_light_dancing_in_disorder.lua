
chaotic_brilliant_light_dancing_in_disorder = class({})
function chaotic_brilliant_light_dancing_in_disorder:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_1.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_2_trail_c.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_4.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_5_trail_c.vpcf", context )

end
function chaotic_brilliant_light_dancing_in_disorder:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_brilliant_light_dancing_in_disorder:OnSpellStart()

	local caster = self:GetCaster()

	local caster_pos = caster:GetAbsOrigin()

	local interval = 0.05

	local radius = self:GetSpecialValueFor("radius")

	local duration = self:GetSpecialValueFor("duration")

	local length = self:GetSpecialValueFor("length")

	local width = self:GetSpecialValueFor("width")

	local damage = (caster:GetAverageTrueAttackDamage(nil) * self:GetSpecialValueFor("bonus_damage")) * self:GetEffectGain()

	local weapon_number = self:GetSpecialValueFor("number")

	local number = 0

	local count = 0

	self.PosList = {}

	self.Pos_Damage_List = {}

	self:ApplyWeapon(caster_pos)

	caster:GameTimer(2,function()
		if not IsValid(self) then
			return
		end

		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_2_trail_c.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, caster_pos)
		DestroyParticleByDelay(effect_cast,2)

		EmitSoundOnLocationWithCaster( caster_pos,"Hero_Drow.Glacier", caster)

		caster:GameTimer(interval,function()
			if not IsValid(self) then
				return		
			end

			local Random_pos = Vector(RandomInt(-radius, radius),RandomInt(-radius, radius),RandomInt(100, 300))

			local eff_pos = Vector(Random_pos.x,Random_pos.y,Random_pos.z)

			local Weapon_Pos = Vector(caster_pos.x + eff_pos.x , caster_pos.y + eff_pos.y , caster_pos.z + eff_pos.z)

			local projectileTable =
			{
				EffectName = nil,
				Ability = self,
				vSpawnOrigin = caster_pos,
				vVelocity = TG_Direction(Weapon_Pos,caster_pos) * math.max(math.abs(Random_pos.x),math.abs(Random_pos.y)),
				fDistance = TG_Distance(Weapon_Pos,caster_pos) - 200,
				fStartRadius = width,
				fEndRadius = width,
				Source = caster,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
				bProvidesVision = false,
				ExtraData = {damage = damage}   --额外的数据
			}

			ProjectileManager:CreateLinearProjectile( projectileTable )

			table.insert(self.PosList,Weapon_Pos)

			self:Weapon_Move(caster_pos,eff_pos)

			weapon_number = weapon_number - 1

			caster:GameTimer(0.6,function()

				if not IsValid(self) then
					return		
				end

				number = number + 1
	
				for index, pos in pairs(self.PosList) do

					if index == number then

						self:Weapon_Pos(pos,duration)

						caster:GameTimer(duration,function()

							if not IsValid(self) then
								return		
							end
			
							count = count + 1
				
							for index, pos in pairs(self.PosList) do
			
								if index == count then
			
									local Random_length = RandomInt(radius*2, radius*4)

									local dir = TG_Direction(caster_pos,pos)

									local damage_pos = dir * Random_length

									local projectileTable =
									{
										EffectName = nil,
										Ability = self,
										vSpawnOrigin = pos,
										vVelocity = dir * Random_length,
										fDistance = Random_length,
										fStartRadius = width,
										fEndRadius = width,
										Source = caster,
										iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
										iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
										iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
										bProvidesVision = false,
										ExtraData = {damage = damage}   --额外的数据
									}
						
									ProjectileManager:CreateLinearProjectile( projectileTable )									
			
									self:Damage_Move(pos,damage_pos,Random_length)
			
									break

								end
			
							end
				
						end)

						break
					end

				end
	
			end)

			if weapon_number > 0 then
				return interval
			end

		end)
	end)

end

function chaotic_brilliant_light_dancing_in_disorder:OnProjectileHit_ExtraData(target, location, kv)

	if target ~= nil then
		local ability = self
		local caster = ability:GetCaster()

		local damageTable = {
			victim = target,
			attacker = caster,
			damage =  kv.damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = ability,
			}

		ApplyDamage(damageTable)

		target:EmitSound("Hero_Mars.Attack")
				
	end
end

function chaotic_brilliant_light_dancing_in_disorder:ApplyWeapon(caster_pos)
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_2.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster_pos)
	DestroyParticleByDelay(effect_cast,2)

	EmitSoundOnLocationWithCaster( caster_pos,"Hero_DeathProphet.SpiritSiphon.Cast", self:GetCaster())

end

function chaotic_brilliant_light_dancing_in_disorder:Weapon_Move(caster_pos,eff_pos)

	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_4.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster_pos)
	ParticleManager:SetParticleControl( effect_cast, 1, eff_pos)
	DestroyParticleByDelay(effect_cast,0.7)

	EmitSoundOnLocationWithCaster( caster_pos,"Hero_TrollWarlord.WhirlingAxes.Ranged", self:GetCaster())
end

function chaotic_brilliant_light_dancing_in_disorder:Weapon_Pos(pos,duration)

	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_1.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(effect_cast , 0 , pos)
	DestroyParticleByDelay(effect_cast,duration)	

	EmitSoundOnLocationWithCaster( pos ,"Hero_Drow.Glacier.End", self:GetCaster())

end

function chaotic_brilliant_light_dancing_in_disorder:Damage_Move(pos,damage_pos,Random_length)

	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_brilliant_light_dancing_in_disorder/chaotic_brilliant_light_dancing_in_disorder_5.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(effect_cast , 0 , pos)
	ParticleManager:SetParticleControl(effect_cast, 1, damage_pos)
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(Random_length / 120 , 0 , 90))
	ParticleManager:SetParticleControl(effect_cast, 6, Vector(-1000,-1000,Random_length / 5))
	ParticleManager:SetParticleControl(effect_cast, 7, Vector(-1000,1000,Random_length))
	DestroyParticleByDelay(effect_cast,0.7)

	EmitSoundOnLocationWithCaster( pos ,"Hero_DrowRanger.FrostArrows", self:GetCaster())

end