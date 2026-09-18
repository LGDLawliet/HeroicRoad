LinkLuaModifier("modifier_Advanced_heat_seeking_missile_unlock3", "skills/Advanced_heat_seeking_missile", LUA_MODIFIER_MOTION_NONE)

Advanced_heat_seeking_missile = Advanced_heat_seeking_missile or class({})


function Advanced_heat_seeking_missile:CheckKV(key)
	local table = {

	
		basic_damage =10,
		bonus_damage = 0.1,


	}
	local value = table[key] or -1
	return value

end

function Advanced_heat_seeking_missile:UnlockFirstCore(key)
	return true
end
function Advanced_heat_seeking_missile:UnlockSecondCore(key)
	return true
end
function Advanced_heat_seeking_missile:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_heat_seeking_missile_unlock3",{})
	return true
end






function Advanced_heat_seeking_missile:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/heat_seeking_missile/single_missile/effect_missile.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/heat_seeking_missile/hit_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf", context )

end



function Advanced_heat_seeking_missile:GetCastRange()
	return self:GetSpecialValueFor("radius")		 
end

function Advanced_heat_seeking_missile:Spawn()
	self.missileList ={}
	self.missileListSplit ={}
end

function Advanced_heat_seeking_missile:CastFilterResult()
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

function Advanced_heat_seeking_missile:GetCustomCastError()
	if IsClient() then
		return
	end

	return "#DOTA_CUSTOM_CAST_DENY_NO_TARGET"
end

function Advanced_heat_seeking_missile:OnSpellStart()
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
		iMoveSpeed = 500,
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
	local delay = 1.4
	local split = 1
	if self.advanced_level>=15 then
		delay = 1.1
		split = 2
		if self.advanced_level>=20 then
			delay = 0.5
			if self.unlock1 then
				split = 3
			end
			if self.unlock2 then
				split = 5
				delay = 0.4
			end
		end
	end
	for _, unit in ipairs(units) do
		info.Target = unit
		if not self.unlock1 then
			info.iMoveSpeed = speed + RandomInt(-200, 200)
		end
		
		local ProjectileID = ProjectileManager:CreateTrackingProjectile(info)
		-- 只需要伤害
		self.missileList[ProjectileID] = {
			damage = damage,
		}
		-- 记录分裂时间与次数
		self.missileListSplit[ProjectileID] = {
			target = unit,
			damage = damage,
			split = split,
			timer = GameRules:GetGameTime()+delay,
		}
		current_count = current_count + 1
		if current_count>=count then
			break
		end
	end
	

	caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
end


function Advanced_heat_seeking_missile:Unlock3Trigger()
	local caster = self:GetCaster()
	local particle_cast = "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(effect_cast,0,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetOrigin(),true )
	self:OnSpellStart()
end





function Advanced_heat_seeking_missile:OnProjectileHitHandle(target, location, ProjectileID)
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



		-- 温压效果
		target:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
		local particle_cast = "particles/rebuild/spell/heat_seeking_missile/hit_effect.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(effect_cast,0,target:GetOrigin() )
		ParticleManager:SetParticleControl(effect_cast,1,Vector(300,300,300) )
		DestroyParticleByDelay(effect_cast,3)
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		local damage_index = 0.5
		if self.advanced_level>=10 then
			damage_index = 0.7
		end
		local boom_damageTable = {
			-- victim = enemy,
			attacker = caster,
			damage = self.missileList[ProjectileID].damage*damage_index,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}
		local count = 3
		local knockBack_kv = 
		{
			center_x = target:GetAbsOrigin().x,
			center_y = target:GetAbsOrigin().y,
			center_z = target:GetAbsOrigin().z,
			duration = 0.15,
			should_stun = true, 
			knockback_duration = 0.15,
			knockback_distance = 200,
			knockback_height = 15,
		}
		if caster:HasAbility("heroTalent_npc_dota_hero_tinker_3") then
			knockBack_kv.knockback_distance = -knockBack_kv.knockback_distance
		end

		for i, unit in pairs(units) do
			if unit~=target then

				unit:AddNewModifier( caster, self, "modifier_knockback", knockBack_kv )
				boom_damageTable.victim = unit
				ApplyDamage(boom_damageTable)
				count = count - 1
				if count<=0 then
					break
				end
			end
		
			
			
		end

		local damageTable = {
			victim = target,
			attacker = caster,
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


function Advanced_heat_seeking_missile:OnProjectileThinkHandle(ProjectileID)
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
				iMoveSpeed = speed,
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
			local delay = 1.5
			if self.advanced_level>=5 then
				bonus_count = 2
				if self.advanced_level>=20 then
					delay = 1
					if self.unlock1 then
						bonus_count = 3
					end
				end
			end
			if self.unlock2 then
				bonus_count = 1
				delay = 0.4
			end
			local split_time = GameRules:GetGameTime()+delay
			local have_unit = false
			for _, unit in ipairs(units) do
				if unit~=target then
					info.Target = unit
					if not self.unlock1 then
						info.iMoveSpeed = speed + RandomInt(-200, 200)
					end
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
							timer = split_time,
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
						timer =split_time,
					}
				end
	
			else
				-- 没办法分裂
				self.missileListSplit[ProjectileID] = nil
				return
			end
			


			self.missileListSplit[ProjectileID] = nil
			self.missileList[ProjectileID] = nil
			-- ProjectileManager:DestroyTrackingProjectile(ProjectileID)
			
		end
	end
end


















modifier_Advanced_heat_seeking_missile_unlock3 = modifier_Advanced_heat_seeking_missile_unlock3 or class({})

function modifier_Advanced_heat_seeking_missile_unlock3:IsDebuff()			return false end
function modifier_Advanced_heat_seeking_missile_unlock3:IsHidden() 			return true end
function modifier_Advanced_heat_seeking_missile_unlock3:IsPurgable() 		return false end
function modifier_Advanced_heat_seeking_missile_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_heat_seeking_missile_unlock3:AllowIllusionDuplicate() return false end
function modifier_Advanced_heat_seeking_missile_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_heat_seeking_missile_unlock3:DeclareFunctions() 
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
 end


function modifier_Advanced_heat_seeking_missile_unlock3:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
   
	if keys.target and keys.target==self:GetParent() then
		local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) -4
		local chance = 20
		if cooldown>=1 then
			chance = math.min(chance + cooldown*10,100)
		end
		if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1)  >= RandomInt(1, 100) then
			self:GetAbility():Unlock3Trigger()
		end

	end

  
    
end

