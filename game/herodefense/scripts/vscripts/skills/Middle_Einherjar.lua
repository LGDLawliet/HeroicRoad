LinkLuaModifier("modifier_Middle_Einherjar", "skills/Middle_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Einherjar_buff", "skills/Middle_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Einherjar_ghost", "skills/Middle_Einherjar", LUA_MODIFIER_MOTION_NONE)


require('internal/timers')   --计时器功能
--Abilities
if Middle_Einherjar == nil then
	Middle_Einherjar = class({})
end

function Middle_Einherjar:GetCastRange()
	return self:GetSpecialValueFor("radius")
end
function Middle_Einherjar:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	hCaster:AddNewModifier(hCaster, self, "modifier_Middle_Einherjar_buff", { duration = duration })

	hCaster:EmitSound("Hero_Zuus.Righteous.Layer")
	hCaster:EmitSound("Hero_ArcWarden.SparkWraith.Appear")
	hCaster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")
end


function Middle_Einherjar:GetIntrinsicModifierName()
	return "modifier_Middle_Einherjar"
end

---------------------------------------------------------------------
--Modifiers
modifier_Middle_Einherjar = modifier_Middle_Einherjar or class({})
function modifier_Middle_Einherjar:IsHidden()
	return true
end
function modifier_Middle_Einherjar:IsDebuff()
	return false
end
function modifier_Middle_Einherjar:IsPurgable()
	return false
end
function modifier_Middle_Einherjar:IsPurgeException()
	return false
end
function modifier_Middle_Einherjar:IsStunDebuff()
	return false
end
function modifier_Middle_Einherjar:AllowIllusionDuplicate()
	return false
end
function modifier_Middle_Einherjar:OnCreated(params)
	if IsServer() then
		self.tScepterGhosts = {}
		self:StartIntervalThink(0.25)
	end
end
function modifier_Middle_Einherjar:OnRefresh(params)
end
function modifier_Middle_Einherjar:OnDestroy()
	if IsServer() then
		for n, hGhost in pairs(self.tScepterGhosts) do
			if IsValid(hGhost) then
				hGhost:RemoveModifierByName("modifier_Middle_Einherjar_ghost")
			end
		end
	end
end
function modifier_Middle_Einherjar:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if not IsValid(ability) then
			self:StartIntervalThink(-1)
			self:SafeDestroy()
			return
		end

		local caster = ability:GetCaster()

		if not ability:GetAutoCastState() then
			return
		end

		if caster:IsTempestDouble() or caster:IsIllusion() then
			self:StartIntervalThink(-1)
			return
		end

		if not caster:IsAbilityReady(ability) then
			return
		end

		local range = caster:Script_GetAttackRange()
		local teamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
		local typeFilter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local flagFilter = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
		local order = FIND_CLOSEST
		local targets = Spawner:FindMissingInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), range, teamFilter, typeFilter, flagFilter, order)
		if targets[1] ~= nil then
			ExecuteOrderFromTable(
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ability:entindex()
				}
			)
		end
	end
end

---------------------------------------------------------------------
modifier_Middle_Einherjar_buff =modifier_Middle_Einherjar_buff  or class({})
function modifier_Middle_Einherjar_buff:IsHidden()	return false end
function modifier_Middle_Einherjar_buff:IsDebuff()	return false end
function modifier_Middle_Einherjar_buff:IsPurgable()	return false end
function modifier_Middle_Einherjar_buff:IsPurgeException()	return false end
function modifier_Middle_Einherjar_buff:IsStunDebuff()	return false end
function modifier_Middle_Einherjar_buff:AllowIllusionDuplicate()	return false end
function modifier_Middle_Einherjar_buff:DestroyOnExpire()	return false end
-- function modifier_Middle_Einherjar_buff:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE
-- end
function modifier_Middle_Einherjar_buff:OnCreated(params)
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self.radius = hAbility:GetSpecialValueFor("radius")
		self.spirits = 2
		self.spirit_speed = 600*1.4
		self.return_speed = self.spirit_speed*2
		self.current_speed = 600
		self.max_distance = 2500
		self.give_up_distance = 1800
		self.attack_range = 150
		self.ghost_spawn_rate = 0.5
		if hCaster:HasAbility("heroTalent_npc_dota_hero_meepo_2") then
			self.spirits = 3
		end

		self.attack_cooldown = 0.3  -- 设置攻击冷却时间为0.5秒
		self.last_attack_time = {}  -- 用于记录每个幽灵的上次攻击时间






		self:StartIntervalThink(self.ghost_spawn_rate)

		self.damage_type = hAbility:GetAbilityDamageType()


		-- hParent:EmitSound("Hero_DeathProphet.Exorcism")

		self.tGhosts = {}

		self.unique_str = DoUniqueString("modifier_Middle_Einherjar_buff")

		Timers:CreateTimer(0, function()

			if not IsValid(self) then
			
				return
			end
			if  GameRules:IsGamePaused() then
				return 0.1
			end
			if not IsValid(hAbility) or not IsValid(hCaster) then
			
				return
			end
	
			if self:GetRemainingTime() <= -10 then
				self:SafeDestroy()
		
				return
			end
	
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
		
				if self:GetRemainingTime() <= 0 then
					hGhost.bReturning = true
					
					hGhost.hTarget = hParent
				end

				if IsValid(hGhost.hUnit) then
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
								hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(200, self.radius)
							end
						else
							hGhost.vTargetPosition = nil
						end
					end
				
					if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
						hGhost.hTarget = hParent
						hGhost.bReturning = true
						-- hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(200, self.radius)
					end
	
					local fAngularSpeed = self:GetRemainingTime() <= 0 and (1 / (1 / 30) * FrameTime()) or ((1 / 9) / (1 / 30) * FrameTime())
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
	
					if hGhost.hUnit:IsPositionInRange(vTargetPosition, self.attack_range) then
						if hGhost.hTarget ~= nil then
							if hGhost.bReturning then
								hGhost.hTarget = nil
								hGhost.bReturning = false
								if self:GetRemainingTime() <= 0 then
									hGhost.hUnit:RemoveModifierByName("modifier_Middle_Einherjar_ghost")
									table.remove(self.tGhosts, i)
									if #self.tGhosts == 0 then
										self:SafeDestroy()
							
										return
									end
								end
							else
								local current_time = GameRules:GetGameTime()
								if not self.last_attack_time[i] or (current_time - self.last_attack_time[i]) >= self.attack_cooldown then
									local modifier_keys = {
										duration = 0.1,
										iSpecialAttack = 1,
										iDisableApplyModifier = 0,
										iDisableCleave =0,
										iDisableSplit = 0,
									}
								
									local attackEffectRecord = hCaster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
									hCaster:PerformAttack(hGhost.hTarget, false, true, true, true, false, false, true)
									if IsValid(attackEffectRecord) then
										attackEffectRecord:Destroy()
									end

									self.last_attack_time[i] = current_time
									hGhost.hTarget = hParent
									hGhost.bReturning = true
								end
							end
						else
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(200, self.radius)
						end
					end
				
	
				end
				
			end
				
			return 0
		end
		)
	end
end
function modifier_Middle_Einherjar_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			-- hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_Middle_Einherjar_ghost")
			end
		end
	end
end
function modifier_Middle_Einherjar_buff:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()

		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:SafeDestroy()
			return
		end

		if #(self.tGhosts) < self.spirits then
			local vPosition = hCaster:GetAbsOrigin()
			local vForward = RandomVector(1)
			local hGhost = {
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_Middle_Einherjar_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
				vTargetPosition = nil,
				hTarget = nil,
				bReturning = false
			}
			hGhost.hUnit:SetForwardVector(vForward)
			hGhost.hUnit:SetOriginalModel(hCaster.origin_model_name)
			hGhost.hUnit:SetModelScale(hCaster:GetModelScale())
			-- local vRBG = Vector(128, 128, 204)
			-- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			if hCaster:GetUnitName()=="npc_dota_hero_tiny" then
				
				-- if hCaster:HasModifier("modifier_heroTalent_npc_dota_hero_tiny_2") then
				-- 	hGhost.hUnit:AddActivityModifier("tree")
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
				
			else
				if hCaster.overrideModelName then

				else
					local hModel = hCaster:FirstMoveChild()
					while hModel ~= nil do
						if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
							local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hGhost.hUnit:GetAbsOrigin() })
							-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
							hWearable:FollowEntity(hGhost.hUnit, true)
						end
						hModel = hModel:NextMovePeer()
					end
				end

			end
			-- local hModel = hCaster:FirstMoveChild()
			-- while hModel ~= nil do
			-- 	if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			-- 		local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hGhost.hUnit:GetAbsOrigin() })
			-- 		-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			-- 		hWearable:FollowEntity(hGhost.hUnit, true)
			-- 	end
			-- 	hModel = hModel:NextMovePeer()
			-- end

			table.insert(self.tGhosts, hGhost)
		end
	end
end
---------------------------------------------------------------------
modifier_Middle_Einherjar_ghost = modifier_Middle_Einherjar_ghost or class({})
function modifier_Middle_Einherjar_ghost:IsHidden()	return true end
function modifier_Middle_Einherjar_ghost:IsDebuff()	return false end
function modifier_Middle_Einherjar_ghost:IsPurgable()	return false end
function modifier_Middle_Einherjar_ghost:IsPurgeException()	return false end
function modifier_Middle_Einherjar_ghost:IsStunDebuff()	return false end
function modifier_Middle_Einherjar_ghost:AllowIllusionDuplicate()	return false end
function modifier_Middle_Einherjar_ghost:OnCreated(params)
	if IsServer() then

		self:GetParent():SetModelScale(0.9)
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/einherjar/einherjar_guardian.vpcf", PATTACH_CENTER_FOLLOW , self:GetParent())
		-- local pos = self:GetParent():GetAbsOrigin()
		-- pos.z = pos.z +64
		-- ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", pos, true)
		self:AddParticle(pfx, false, false, 15, false, false)
		-- self:GetParent():AddActivityModifier('run_fast')
	end
end
function modifier_Middle_Einherjar_ghost:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Middle_Einherjar_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_Middle_Einherjar_ghost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_Middle_Einherjar_ghost:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().overrideModelName or  self:GetCaster().origin_model_name
	end
end
function modifier_Middle_Einherjar_ghost:GetOverrideAnimation(params)



	return ACT_DOTA_RUN
end
function modifier_Middle_Einherjar_ghost:GetOverrideAnimationRate()	return 2 end
function modifier_Middle_Einherjar_ghost:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then

		return "haste"
	end
	return "run_fast" 
end
function modifier_Middle_Einherjar_ghost:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
function modifier_Middle_Einherjar_ghost:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
---------------------------------------------------------------------
