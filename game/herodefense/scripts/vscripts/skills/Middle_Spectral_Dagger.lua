LinkLuaModifier("modifier_Middle_Spectral_Dagger", "skills/Middle_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Spectral_Dagger_debuff", "skills/Middle_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Spectral_Dagger_ghost", "skills/Middle_Spectral_Dagger", LUA_MODIFIER_MOTION_NONE)


require('internal/timers')   --计时器功能
--Abilities
if Middle_Spectral_Dagger == nil then
	Middle_Spectral_Dagger = class({})
end

function Middle_Spectral_Dagger:GetCastRange()
	return self:GetSpecialValueFor("radius")
end
function Middle_Spectral_Dagger:OnSpellStart()
	-- local hCaster = self:GetCaster()
	-- local duration = self:GetSpecialValueFor("duration")

	-- hCaster:AddNewModifier(hCaster, self, "modifier_Middle_Spectral_Dagger_buff", { duration = duration })

	-- hCaster:EmitSound("Hero_Zuus.Righteous.Layer")
	-- hCaster:EmitSound("Hero_ArcWarden.SparkWraith.Appear")
	-- hCaster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")
end




function Middle_Spectral_Dagger:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/spectre/spectre_arcana/spectre_arcana_desolate.vpcf", context )

end

function Middle_Spectral_Dagger:GetIntrinsicModifierName()
	return "modifier_Middle_Spectral_Dagger"
end

---------------------------------------------------------------------
--Modifiers
modifier_Middle_Spectral_Dagger = modifier_Middle_Spectral_Dagger or class({})
function modifier_Middle_Spectral_Dagger:IsHidden()	return true end
function modifier_Middle_Spectral_Dagger:IsDebuff()	return false end
function modifier_Middle_Spectral_Dagger:IsPurgable()	return false end
function modifier_Middle_Spectral_Dagger:IsPurgeException()	return false end
function modifier_Middle_Spectral_Dagger:IsStunDebuff()	return false end
function modifier_Middle_Spectral_Dagger:AllowIllusionDuplicate()	return false end
function modifier_Middle_Spectral_Dagger:OnCreated(params)
	if IsServer() then
		local hAbility = self:GetAbility()
		self.radius = hAbility:GetSpecialValueFor("move_radius")
		self.spirits = hAbility:GetSpecialValueFor("dagger_count")
		self.spirit_speed = hAbility:GetSpecialValueFor("move_speed")
		self.return_speed = self.spirit_speed*2
		self.current_speed = self.spirit_speed
		self.max_distance = self.radius*2
		self.give_up_distance = self.radius*1.5
	
		-- print("self.radius=",self.radius)
		-- print("self.spirits=",self.spirits)
		-- print("self.spirit_speed=",self.spirit_speed)
	
		self.ghost_spawn_rate = 0.5
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self:StartIntervalThink(self.ghost_spawn_rate)
		self.damage_type = hAbility:GetAbilityDamageType()
		self.tGhosts = {}
		-- self.unique_str = DoUniqueString("modifier_Middle_Spectral_Dagger_buff")
		Timers:CreateTimer(0, function()
			if not IsValid(self) then
				return
			end
			if not IsValid(hAbility) or not IsValid(hCaster) then
				return
			end
			if  GameRules:IsGamePaused() then
				return 0.1
			end
			-- if self:GetRemainingTime() <= -10 then
			-- 	self:SafeDestroy()
			-- 	return
			-- end
	
			local hAttackTarget = hParent:GetAttackTarget()
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(),  hParent:GetAbsOrigin(), nil, self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)

			for i = #self.tGhosts, 1, -1 do
	
				local hGhost = self.tGhosts[i]
				if hGhost.hTarget == hParent then
					self.current_speed = self.return_speed
				else
					self.current_speed = self.spirit_speed
				end
				if hGhost.bReturning == false then
					local hTarget = hGhost.hTarget
					if IsValid(hTarget) then
						if not hTarget:IsAlive() or not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.give_up_distance) then
							hTarget = nil
						end
					end
					if not IsValid(hTarget) then
						hTarget = hAttackTarget
						if not IsValid(hTarget) then
							hTarget = GetRandomElement(tTargets)
						end
					end
					hGhost.hTarget = hTarget
					if not IsValid(hGhost.hTarget) then
						if hGhost.vTargetPosition == nil then
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
						end
					else
						hGhost.vTargetPosition = nil
					end
				end
			
				if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
					hGhost.hTarget = hParent
					hGhost.bReturning = true
					hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
				end

			
				-- local fAngularSpeed = self:GetRemainingTime() <= 0 and (1 / (1 / 30) * FrameTime()) or ((1 / 9) / (1 / 30) * FrameTime())
				local fAngularSpeed = ((1 / 9) / (1 / 30) * FrameTime())
				if hGhost.bReturning then
					fAngularSpeed = ((1/4) / (1 / 30) * FrameTime()) 
				end
				local vTargetPosition = IsValid(hGhost.hTarget) and hGhost.hTarget:GetAbsOrigin() or hGhost.vTargetPosition
				local vDirection = vTargetPosition - hGhost.hUnit:GetAbsOrigin()
				vDirection.z = 0
				vDirection = vDirection:Normalized()

				local vForward = hGhost.hUnit:GetForwardVector()

				local fAngle = math.acos(Clamp(vDirection.x * vForward.x + vDirection.y * vForward.y, -1, 1))

				fAngularSpeed = math.min(fAngularSpeed, fAngle)

				local vCross = vForward:Cross(vDirection)

				if vCross.z < 0 then
					fAngularSpeed = -fAngularSpeed
				end
				vForward = Rotation2D(vForward, fAngularSpeed)

				hGhost.hUnit:SetForwardVector(vForward)

				local vPosition = GetGroundPosition(hGhost.hUnit:GetAbsOrigin() + hGhost.hUnit:GetForwardVector() * (self.current_speed * FrameTime()), hParent)
				hGhost.hUnit:SetAbsOrigin(vPosition)

				if hGhost.hUnit:IsPositionInRange(vTargetPosition, 100) then
					if hGhost.hTarget ~= nil then
						if hGhost.bReturning then
							hGhost.hTarget = nil
							hGhost.bReturning = false

						else
		
							hGhost.hTarget = hParent
							hGhost.bReturning = true
						end
					else
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
					end
				end
			end

			return 0
		end
		)
	end
end
function modifier_Middle_Spectral_Dagger:OnRefresh(keys)
	if IsServer() then
		local hAbility = self:GetAbility()
		self.radius = hAbility:GetSpecialValueFor("move_radius")
		self.spirits = hAbility:GetSpecialValueFor("dagger_count")
		self.spirit_speed = hAbility:GetSpecialValueFor("move_speed")
		self.return_speed = self.spirit_speed*2
		self.current_speed = self.spirit_speed
		self.max_distance = self.radius*2
		self.give_up_distance = self.radius*1.5
	end
end



function modifier_Middle_Spectral_Dagger:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			-- hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_Middle_Spectral_Dagger_ghost")
			end
		end
	end
end
function modifier_Middle_Spectral_Dagger:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()

		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:SafeDestroy()
			return
		end

		local maxCount = self:GetMaxDaggerCount()
		if #(self.tGhosts) < maxCount then
			local vPosition = hCaster:GetAbsOrigin()
			local vForward = RandomVector(1)
			local hGhost = {
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_Middle_Spectral_Dagger_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
				vTargetPosition = nil,
				hTarget = nil,
				bReturning = false
			}
			-- hGhost.hUnit:SetForwardVector(vForward)
			-- hGhost.hUnit:SetOriginalModel(hCaster.origin_model_name)
			-- hGhost.hUnit:SetModelScale(hCaster:GetModelScale())
			-- if hCaster:GetUnitName()=="npc_dota_hero_tiny" then
			-- else
			-- 	local hModel = hCaster:FirstMoveChild()
			-- 	while hModel ~= nil do
			-- 		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			-- 			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hGhost.hUnit:GetAbsOrigin() })
			-- 			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			-- 			hWearable:FollowEntity(hGhost.hUnit, true)
			-- 		end
			-- 		hModel = hModel:NextMovePeer()
			-- 	end
			-- end

			table.insert(self.tGhosts, hGhost)
		elseif #(self.tGhosts) > maxCount then
			for n, hGhost in pairs(self.tGhosts) do
				if IsValid(hGhost.hUnit) then
					hGhost.hUnit:RemoveModifierByName("modifier_Middle_Spectral_Dagger_ghost")
				end
				table.remove(self.tGhosts,n)
				break
			end
		end
	end
end


function modifier_Middle_Spectral_Dagger:GetMaxDaggerCount()
	return self.spirits
end







---------------------------------------------------------------------
modifier_Middle_Spectral_Dagger_ghost = modifier_Middle_Spectral_Dagger_ghost or advanced_modifier({})
function modifier_Middle_Spectral_Dagger_ghost:IsHidden()	return true end
function modifier_Middle_Spectral_Dagger_ghost:IsDebuff()	return false end
function modifier_Middle_Spectral_Dagger_ghost:IsPurgable()	return false end
function modifier_Middle_Spectral_Dagger_ghost:IsPurgeException()	return false end
function modifier_Middle_Spectral_Dagger_ghost:IsStunDebuff()	return false end
function modifier_Middle_Spectral_Dagger_ghost:AllowIllusionDuplicate()	return false end
function modifier_Middle_Spectral_Dagger_ghost:OnCreated(params)
	if IsServer() then

		self:GetParent():SetModelScale(0.9)



		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/spectral_dagger/effect/tracking.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		
		self:StartIntervalThink(0.1)

		-- self.base_damage = self:GetAbility():GetSpecialValueFor("damage")
		-- self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.radius  = 100

		self.damage_list = {}

	end
end
function modifier_Middle_Spectral_Dagger_ghost:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_Middle_Spectral_Dagger_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_Middle_Spectral_Dagger_ghost:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if not caster:IsAlive() or caster:PassivesDisabled() then
		return
	end
	local tTargets = FindUnitsInRadius(caster:GetTeamNumber(),  parent:GetAbsOrigin(), nil, self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	if #tTargets>0 then
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue()
		local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		
		local damage_table =
		{
			ability = ability,
			attacker = caster,
			-- victim = hTarget,
			damage = damage,
			damage_type = ability:GetAbilityDamageType()
		}
		local time = GameRules:GetGameTime()

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

		
		for _, unit in ipairs(tTargets) do
			if not self.damage_list[unit] then
				self.damage_list[unit] = time
			end
			if self.damage_list[unit]<time then
				self.damage_list[unit] = time +1
				damage_table.victim = unit


				local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_arcana/spectre_arcana_desolate.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt( effect_cast, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
				DestroyParticleByDelay(effect_cast,1.5)
				unit:ApplyMergeDamage(damage_table)
				parent:EmitSound("Hero_Spectre.DaggerImpact")
				if unit:IsAlive() then
					local StatusResistance =unit:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					unit:AddNewModifier(caster, ability, "modifier_Middle_Spectral_Dagger_debuff", { duration = debuff_duration  * StatusResistance})
				end
			end
		end
		

	end


end



function modifier_Middle_Spectral_Dagger_ghost:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_End = {},
	}
end
function modifier_Middle_Spectral_Dagger_ghost:OnWaveEnd()
    if IsClient() then
        return
    end

    self.damage_list = {}
	-- print("清除非不要数据")
end











if modifier_Middle_Spectral_Dagger_debuff == nil then
	modifier_Middle_Spectral_Dagger_debuff = class({})
end
function modifier_Middle_Spectral_Dagger_debuff:IsHidden()return false end
function modifier_Middle_Spectral_Dagger_debuff:IsDebuff()return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() end
function modifier_Middle_Spectral_Dagger_debuff:IsPurgable()return false end
function modifier_Middle_Spectral_Dagger_debuff:IsPurgeException()return false end
function modifier_Middle_Spectral_Dagger_debuff:IsStunDebuff()return false end
function modifier_Middle_Spectral_Dagger_debuff:AllowIllusionDuplicate()return false end

function modifier_Middle_Spectral_Dagger_debuff:OnCreated(table)
	self.value = self:GetAbility():GetSpecialValueFor("bonus_movespeed") 
end
function modifier_Middle_Spectral_Dagger_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

	}
end
function modifier_Middle_Spectral_Dagger_debuff:GetModifierMoveSpeedBonus_Constant(params)
	
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return -self.value
	end
	return self.value
end


