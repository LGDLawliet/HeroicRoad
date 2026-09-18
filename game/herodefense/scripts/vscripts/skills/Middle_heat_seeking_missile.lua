
Middle_heat_seeking_missile = Middle_heat_seeking_missile or class({})


function Middle_heat_seeking_missile:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/heat_seeking_missile/single_missile/effect_missile.vpcf", context )

end
function Middle_heat_seeking_missile:GetCastRange()
	return self:GetSpecialValueFor("radius")		 
end

function Middle_heat_seeking_missile:Spawn()
	self.missileList ={}
	self.missileListSplit ={}
end

function Middle_heat_seeking_missile:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	if #units==0 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function Middle_heat_seeking_missile:GetCustomCastError()
	if IsClient() then
		return
	end

	return "#DOTA_CUSTOM_CAST_DENY_NO_TARGET"
end

function Middle_heat_seeking_missile:OnSpellStart(scepter)
	local caster = self:GetCaster()


	local radius = self:GetSpecialValueFor("radius")
	local count = self:GetSpecialValueFor("count")
	local speed = self:GetSpecialValueFor("speed")
	local damage = self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("bonus_damage") * caster:GetIntellect(false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)


	local info = 
	{
		-- Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
		-- iMoveSpeed = speed + RandomInt(-200, 200),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {
			damage = damage,
		} 
	}
	local current_count = 0
	for _, unit in ipairs(units) do
		info.Target = unit
		info.iMoveSpeed = speed + RandomInt(-200, 200)
		local ProjectileID = ProjectileManager:CreateTrackingProjectile(info)
		-- 只需要伤害
		self.missileList[ProjectileID] = {
			damage = damage,
		}
		-- 记录分裂时间与次数
		self.missileListSplit[ProjectileID] = {
			target = unit,
			damage = damage,
			split = 1,
			timer = GameRules:GetGameTime()+1.4,
		}
		current_count = current_count + 1
		if current_count>=count then
			break
		end
	end
	

	caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
end

function Middle_heat_seeking_missile:OnProjectileHitHandle(target, location, ProjectileID)
	if not target then
		return
	end

	
	if not self.missileList[ProjectileID] then
		return
	end
	
	if not target:IsMagicImmune() then

		target:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
		local particle_cast = "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetOrigin(),true )
		DestroyParticleByDelay(effect_cast,3)
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = self.missileList[ProjectileID].damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}
		self.missileList[ProjectileID] = nil
		if self.missileListSplit[ProjectileID] then
			self.missileListSplit[ProjectileID] = nil
		end
		ApplyDamage(damageTable)
	end
end


function Middle_heat_seeking_missile:OnProjectileThinkHandle(ProjectileID)
	if self.missileListSplit[ProjectileID] then

		local time = GameRules:GetGameTime()
		if time>=self.missileListSplit[ProjectileID].timer then
			-- 时间到了 分裂吧
			local target = self.missileListSplit[ProjectileID].target --获取目标
			-- 目标无法成为目标时那就直接结束
			if not target or target:IsNull() or not target:IsAlive() then
				self.missileListSplit[ProjectileID] = nil
				return
			end
			local caster = self:GetCaster()
			-- 距离取500 不能太大
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			local speed = self:GetSpecialValueFor("speed")
			local currentHandlePos = ProjectileManager:GetTrackingProjectileLocation(ProjectileID)
			local info = 
			{
				-- Target = target,
				-- Source = caster,
				Ability = self,	
				EffectName = "particles/rebuild/spell/heat_seeking_missile/single_missile/effect_missile.vpcf",
				-- iMoveSpeed = speed + RandomInt(-200, 200),
				vSourceLoc = currentHandlePos,
				bDrawsOnMinimap = false,  --？？
				bDodgeable = true,   --可躲闪
				bIsAttack = false,   --攻击效果
				bVisibleToEnemies = true,  --对敌人可视
				bReplaceExisting = false, --替换现有的
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				bProvidesVision = false, --提供视野
	
			}
			local damage = self.missileListSplit[ProjectileID].damage
			local split = self.missileListSplit[ProjectileID].split - 1
			local bonus_count = 1
			local have_unit = false
			for _, unit in ipairs(units) do
				if unit~=target then
					info.Target = unit
					info.iMoveSpeed = speed + RandomInt(-200, 200)
					local new_ProjectileID = ProjectileManager:CreateTrackingProjectile(info)
					-- 只需要伤害
					self.missileList[new_ProjectileID] = {
						damage = damage,
					}
					-- 记录分裂时间与次数
					if split>0 then
						-- 剩下分裂机会
						self.missileListSplit[new_ProjectileID] = {
							target = unit,
							damage = damage,
							split = split,
							timer = GameRules:GetGameTime()+2,
						}
					end
		
					have_unit = true
					bonus_count = bonus_count - 1
					if bonus_count<=0 then
						break
					end
				end
			end
			if have_unit then
				local particle_cast = "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf"
				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl(effect_cast,0,currentHandlePos )
				DestroyParticleByDelay(effect_cast,3)
				EmitSoundOnLocationWithCaster(currentHandlePos,"Hero_Tinker.Heat-Seeking_Missile.Impact",caster)

				info.Target = target
				info.iMoveSpeed = speed + RandomInt(-200, 200)
				local new_ProjectileID = ProjectileManager:CreateTrackingProjectile(info)
				-- 只需要伤害
				self.missileList[new_ProjectileID] = {
					damage = damage,
				}
				-- 记录分裂时间与次数
				if split>0 then
					-- 剩下分裂机会
					self.missileListSplit[new_ProjectileID] = {
						target = target,
						damage = damage,
						split = split,
						timer = GameRules:GetGameTime()+1.4,
					}
				end
	
			else
				-- 没办法分裂
				self.missileListSplit[ProjectileID] = nil
				return
			end
			


			self.missileListSplit[ProjectileID] = nil
			self.missileList[ProjectileID] = nil
			-- if ProjectileManager:IsValidProjectile(ProjectileID)  then
			-- 	ProjectileManager:DestroyTrackingProjectile(ProjectileID)
			-- end
			-- ProjectileManager:DestroyTrackingProjectile(ProjectileID)
			
		end
	end
end