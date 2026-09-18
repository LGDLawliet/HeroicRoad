--特效优化 √
LinkLuaModifier("modifier_Advanced_Einherjar", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Einherjar_buff", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Einherjar_ghost", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Einherjar_buff2", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Einherjar_buff3", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Einherjar_passive_effect", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Einherjar_buff_unlock1", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Einherjar_ghost_unlock2", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Einherjar_ghost_unlock2_motion", "skills/Advanced_Einherjar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_animation_frozen", "modifier/generic/modifier_generic_animation_frozen", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能



--Abilities
if Advanced_Einherjar == nil then
	Advanced_Einherjar = class({})
end
function Advanced_Einherjar:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_erupt.vpcf", context )

	

end

function Advanced_Einherjar:CheckKV(key)
	local table = {

		duration =1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Einherjar:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Einherjar:UnlockSecondCore(key)
	return true
end
function Advanced_Einherjar:UnlockThirdCore(key)

	return true
end

function Advanced_Einherjar:GetCastRange()
	return self:GetSpecialValueFor("radius")
end
function Advanced_Einherjar:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	hCaster:AddNewModifier(hCaster, self, "modifier_Advanced_Einherjar_buff", { duration = duration })

	hCaster:EmitSound("Hero_Zuus.Righteous.Layer")
	hCaster:EmitSound("Hero_ArcWarden.SparkWraith.Appear")
	hCaster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")

	-- if self.unlock2 then
	-- 	self:Unlock2Effect()
	-- end
end



function Advanced_Einherjar:GetIntrinsicModifierName()
	return "modifier_Advanced_Einherjar"
end


function Advanced_Einherjar:Unlock2Effect()
	local caster = self:GetCaster()
	local hUnit  =CreateModifierThinker(caster, self, "modifier_Advanced_Einherjar_ghost_unlock2", 
	{duration = 1.1}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	-- local hUnit = CreateModifierThinker(caster, self, "modifier_Advanced_Einherjar_ghost_unlock2", nil, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	-- hUnit:SetForwardVector(caster:GetAbsOrigin())
	hUnit:SetOriginalModel(caster.origin_model_name)
	hUnit:SetModelScale(caster:GetModelScale())
	-- local vRBG = Vector(128, 128, 204)
	-- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)


	if caster:GetUnitName()=="npc_dota_hero_tiny" then
	
		-- if caster:HasModifier("modifier_heroTalent_npc_dota_hero_tiny_2") then
		-- 	hUnit:AddActivityModifier("tree")
		-- 	local hModel = caster:FirstMoveChild()
		-- 	while hModel ~= nil do
		-- 		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
		-- 			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hUnit:GetAbsOrigin() })
		-- 			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
		-- 			hWearable:FollowEntity(hUnit, true)
		-- 		end
		-- 		hModel = hModel:NextMovePeer()
		-- 	end
		-- end
		
	else
		local hModel = caster:FirstMoveChild()
		while hModel ~= nil do
			if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
				local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hUnit:GetAbsOrigin() })
				-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
				hWearable:FollowEntity(hUnit, true)
			end
			hModel = hModel:NextMovePeer()
		end
	end


	-- local hModel = caster:FirstMoveChild()
	-- while hModel ~= nil do
	-- 	if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
	-- 		local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hUnit:GetAbsOrigin() })
	-- 		-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
	-- 		hWearable:FollowEntity(hUnit, true)
	-- 	end
	-- 	hModel = hModel:NextMovePeer()
	-- end

end

---------------------------------------------------------------------
--Modifiers
modifier_Advanced_Einherjar = modifier_Advanced_Einherjar or class({})
function modifier_Advanced_Einherjar:IsHidden()
	return true
end
function modifier_Advanced_Einherjar:IsDebuff()
	return false
end
function modifier_Advanced_Einherjar:IsPurgable()
	return false
end
function modifier_Advanced_Einherjar:IsPurgeException()
	return false
end
function modifier_Advanced_Einherjar:IsStunDebuff()
	return false
end
function modifier_Advanced_Einherjar:AllowIllusionDuplicate()
	return false
end
function modifier_Advanced_Einherjar:OnCreated(params)
	if IsServer() then
		self.tScepterGhosts = {}
		self.count = 0
		self:StartIntervalThink(0.25)
	end
end
function modifier_Advanced_Einherjar:OnRefresh(params)
end
function modifier_Advanced_Einherjar:OnDestroy()
	if IsServer() then
		for n, hGhost in pairs(self.tScepterGhosts) do
			if IsValid(hGhost) then
				hGhost:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
			end
		end
	end
end
function modifier_Advanced_Einherjar:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if not IsValid(ability) then
			self:StartIntervalThink(-1)
			self:SafeDestroy()
			return
		end	

		local caster = ability:GetCaster()
		self.advanced_level = self:GetAbility().advanced_level
		if self.advanced_level>=20 then
			self.count = self.count + 1
			if self.count>=10 then
				self.count = 0
				local modifier = caster:FindModifierByName("modifier_Advanced_Einherjar_buff3")
				if not modifier then
					caster:AddNewModifier(caster,  self:GetAbility(), "modifier_Advanced_Einherjar_buff3", {})
				end
			end
		end

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
modifier_Advanced_Einherjar_buff =modifier_Advanced_Einherjar_buff  or class({})
function modifier_Advanced_Einherjar_buff:IsHidden()	return false end
function modifier_Advanced_Einherjar_buff:IsDebuff()	return false end
function modifier_Advanced_Einherjar_buff:IsPurgable()	return false end
function modifier_Advanced_Einherjar_buff:IsPurgeException()	return false end
function modifier_Advanced_Einherjar_buff:IsStunDebuff()	return false end
function modifier_Advanced_Einherjar_buff:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Einherjar_buff:DestroyOnExpire()	return false end
-- function modifier_Advanced_Einherjar_buff:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE
-- end
function modifier_Advanced_Einherjar_buff:OnCreated(params)

	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()

		self.radius = hAbility:GetSpecialValueFor("radius")
		self.spirits = 2
		local index = 1.4
		self.advanced_level = hAbility:GetSpecialValueFor("advanced_level")
		self.attack_range = 150
		if self.advanced_level>=5 then
			index = 1.65
			self.attack_range = 200
			if self.advanced_level>=15 then
				self.spirits = 3
			end
		end
		if hCaster:HasAbility("heroTalent_npc_dota_hero_meepo_2") then
			self.spirits = self.spirits + 1
			if self.advanced_level>=25 and hCaster:GetLevel()>=53 then
				self.spirits = self.spirits + 1
			end
		end
	
	
		
		self.spirit_speed = 600*index
		self.return_speed = self.spirit_speed*2
		self.current_speed = 600
		self.max_distance = 2500
		self.give_up_distance = 1800
	
		-- self.min_damage = 50
		-- self.max_damage = 80
		self.buff_duration = 20
		if self.advanced_level>=10 then
			self.buff_duration = 30
		end
	
		self.ghost_spawn_rate = 0.5

		local hParent = self:GetParent()
		self:StartIntervalThink(self.ghost_spawn_rate)

		self.damage_type = hAbility:GetAbilityDamageType()
		if hAbility.unlock3 then
			self.spirits = self.spirits+2
			self.max_distance = 5000
			self.radius = 4000
			self.give_up_distance  = 4500
		end

		self.attack_cooldown = 0.3  -- 设置攻击冷却时间为0.5秒
		self.last_attack_time = {}  -- 用于记录每个幽灵的上次攻击时间

		-- hParent:EmitSound("Hero_DeathProphet.Exorcism")

		self.tGhosts = {}


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
	
	
			if self:GetRemainingTime() <= -10 then
				self:SafeDestroy()
		
				return
			end

	
			local hAttackTarget = hParent:GetAttackTarget()
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(),  hParent:GetAbsOrigin(), nil, self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)

			for i = #self.tGhosts, 1, -1 do
	
				local hGhost = self.tGhosts[i]
				if IsValid(hGhost.hUnit) then
					if hGhost.hTarget == hParent then
						self.current_speed = self.return_speed
						local index =  math.max((hGhost.hUnit:GetAbsOrigin() -hParent:GetAbsOrigin()):Length2D()/1000,1)
						self.current_speed = self.current_speed * index
					else
						self.current_speed = self.spirit_speed
						local index =  math.max((hGhost.hUnit:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D()/1000,1)
						self.current_speed = self.current_speed * index
					end
	
					if self:GetRemainingTime() <= 0 then
						hGhost.bReturning = true
						
						hGhost.hTarget = hParent
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
								hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
							end
						else
							hGhost.vTargetPosition = nil
						end
					end
	
					if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
						hGhost.hTarget = hParent
						hGhost.bReturning = true
						-- hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
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
								local gain = hCaster:GetModifierDurationGainIndex(1)
								hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_Advanced_Einherjar_buff2", { duration = self.buff_duration*gain })
								if self:GetRemainingTime() <= 0 then
									hGhost.hUnit:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
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
	
								if hAbility.unlock2 then
									if hCaster:GetRandomEffect(15,INT_TYPE,1)  > RandomInt(1, 100) then
		
										hAbility:Unlock2Effect()
		
									end
								end
	
							end
						else
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
						end
					end
				end
			
			end

			return 0
		end
		)
	end
end
function modifier_Advanced_Einherjar_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			-- hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
			end
		end
	end
end
function modifier_Advanced_Einherjar_buff:OnIntervalThink()
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
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_Advanced_Einherjar_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
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
--马甲单位buff
modifier_Advanced_Einherjar_ghost = modifier_Advanced_Einherjar_ghost or class({})
function modifier_Advanced_Einherjar_ghost:IsHidden()	return true end
function modifier_Advanced_Einherjar_ghost:IsDebuff()	return false end
function modifier_Advanced_Einherjar_ghost:IsPurgable()	return false end
function modifier_Advanced_Einherjar_ghost:IsPurgeException()	return false end
function modifier_Advanced_Einherjar_ghost:IsStunDebuff()	return false end
function modifier_Advanced_Einherjar_ghost:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Einherjar_ghost:OnCreated(params)
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
function modifier_Advanced_Einherjar_ghost:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_Einherjar_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_Advanced_Einherjar_ghost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_Advanced_Einherjar_ghost:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().overrideModelName or  self:GetCaster().origin_model_name
	end
	
end
function modifier_Advanced_Einherjar_ghost:GetOverrideAnimation(params)



	return ACT_DOTA_RUN
end
function modifier_Advanced_Einherjar_ghost:GetOverrideAnimationRate()	return 2 end
function modifier_Advanced_Einherjar_ghost:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then

		return "haste"
	end
	return "run_fast" 
end
function modifier_Advanced_Einherjar_ghost:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
function modifier_Advanced_Einherjar_ghost:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
---------------------------------------------------------------------





--敏捷加成buff
modifier_Advanced_Einherjar_buff2 = class({})

function modifier_Advanced_Einherjar_buff2:IsDebuff() return false end
function modifier_Advanced_Einherjar_buff2:IsHidden() return false end
function modifier_Advanced_Einherjar_buff2:IsPurgable() return false end
function modifier_Advanced_Einherjar_buff2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,      
	

	}
end
function modifier_Advanced_Einherjar_buff2:GetModifierBonusStats_Agility()	return 3*self:GetStackCount() end




function modifier_Advanced_Einherjar_buff2:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Einherjar_buff2:OnRefresh(params)
	if IsServer() then
		-- table.insert(self.tData, {dieTime = self:GetDieTime() })
		-- self:IncrementStackCount()

		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 50 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end

	end
end

function modifier_Advanced_Einherjar_buff2:OnIntervalThink()
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








modifier_Advanced_Einherjar_buff3 =modifier_Advanced_Einherjar_buff3  or class({})
function modifier_Advanced_Einherjar_buff3:IsHidden()	return true end
function modifier_Advanced_Einherjar_buff3:IsDebuff()	return false end
function modifier_Advanced_Einherjar_buff3:IsPurgable()	return false end
function modifier_Advanced_Einherjar_buff3:IsPurgeException()	return false end
function modifier_Advanced_Einherjar_buff3:IsStunDebuff()	return false end
function modifier_Advanced_Einherjar_buff3:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Einherjar_buff3:DestroyOnExpire()	return false end
-- function modifier_Advanced_Einherjar_buff3:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE
-- end
function modifier_Advanced_Einherjar_buff3:OnCreated(params)
	local hCaster = self:GetCaster()

	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.spirits = 1

	self.advanced_level = self:GetAbility().advanced_level

	self.spirit_speed = 600*1.65
	self.return_speed = self.spirit_speed*2
	self.current_speed = 600
	self.max_distance = 2500
	self.give_up_distance = 1800
	self.attack_range = 200
	-- self.min_damage = 50
	-- self.max_damage = 80
	self.buff_duration = 20


	self.ghost_spawn_rate = 0.5
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self:StartIntervalThink(self.ghost_spawn_rate)

		self.damage_type = hAbility:GetAbilityDamageType()


		-- hParent:EmitSound("Hero_DeathProphet.Exorcism")
		self.attack_cooldown = 0.3  -- 设置攻击冷却时间为0.5秒
		self.last_attack_time = {}  -- 用于记录每个幽灵的上次攻击时间

		self.tGhosts = {}



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
		
				-- if self:GetRemainingTime() <= 0 then
				-- 	hGhost.bReturning = true
					
				-- 	hGhost.hTarget = hParent
				-- end
		
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
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
						end
					else
						hGhost.vTargetPosition = nil
					end
				end
				if not IsValid(hGhost.hUnit) then
					goto continue
				end
			
				if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
					hGhost.hTarget = hParent
					hGhost.bReturning = true
					-- hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
					hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
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
							local gain = hCaster:GetModifierDurationGainIndex(1)
							hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_Advanced_Einherjar_buff2", { duration =30*gain })
							-- if self:GetRemainingTime() <= 0 then
							-- 	hGhost.hUnit:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
							-- 	table.remove(self.tGhosts, i)
							-- 	if #self.tGhosts == 0 then
							-- 		self:SafeDestroy()
						
							-- 		return
							-- 	end
							-- end
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

							if hAbility.unlock2 then
								if hCaster:GetRandomEffect(15,INT_TYPE,1)  > RandomInt(1, 100) then
									hAbility:Unlock2Effect()
			
								end
							end


							hGhost.hTarget = hParent
							hGhost.bReturning = true

						end
					else
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
					end
				end

				::continue::
			end

			return 0
		end
		)
	end
end
function modifier_Advanced_Einherjar_buff3:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			-- hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
			end
		end
	end
end
function modifier_Advanced_Einherjar_buff3:OnIntervalThink()
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
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_Advanced_Einherjar_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
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










modifier_Advanced_Einherjar_passive_effect = class({})

function modifier_Advanced_Einherjar_passive_effect:IsDebuff()			return false end
function modifier_Advanced_Einherjar_passive_effect:IsHidden() 			return true end
function modifier_Advanced_Einherjar_passive_effect:IsPurgable() 		return false end
function modifier_Advanced_Einherjar_passive_effect:IsPurgeException() 	return false end
function modifier_Advanced_Einherjar_passive_effect:RemoveOnDeath() return false end
function modifier_Advanced_Einherjar_passive_effect:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Einherjar_passive_effect:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Einherjar_passive_effect:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if self:GetCaster():GetRandomEffect(5,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		-- if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
		-- 	return
		-- end

		local modifiers = caster:FindAllModifiersByName("modifier_Advanced_Einherjar_buff_unlock1")
		if #modifiers>=10 then
			return
		end
		caster:AddNewModifier(caster, ability, "modifier_Advanced_Einherjar_buff_unlock1", { duration =5 })
				
		
	end

	
end






modifier_Advanced_Einherjar_buff_unlock1 =modifier_Advanced_Einherjar_buff_unlock1  or class({})
function modifier_Advanced_Einherjar_buff_unlock1:IsHidden()	return true end
function modifier_Advanced_Einherjar_buff_unlock1:IsDebuff()	return false end
function modifier_Advanced_Einherjar_buff_unlock1:IsPurgable()	return false end
function modifier_Advanced_Einherjar_buff_unlock1:IsPurgeException()	return false end
function modifier_Advanced_Einherjar_buff_unlock1:IsStunDebuff()	return false end
function modifier_Advanced_Einherjar_buff_unlock1:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Einherjar_buff_unlock1:DestroyOnExpire()	return false end
function modifier_Advanced_Einherjar_buff_unlock1:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_Advanced_Einherjar_buff_unlock1:OnCreated(params)
	-- local hCaster = self:GetCaster()

	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.spirits = 1


	self.attack_range = 200

	self.spirit_speed = 600*1.65
	self.return_speed = self.spirit_speed*2
	self.current_speed = 600
	self.max_distance = 2500
	self.give_up_distance = 1800
	self.buff_duration = 30


	self.ghost_spawn_rate = 0.5
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self:StartIntervalThink(self.ghost_spawn_rate)

		self.damage_type = hAbility:GetAbilityDamageType()


		-- hParent:EmitSound("Hero_DeathProphet.Exorcism")

		self.tGhosts = {}


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
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
						end
					else
						hGhost.vTargetPosition = nil
					end
				end
			
				if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
					hGhost.hTarget = hParent
					hGhost.bReturning = true
					-- hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
					hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
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
							local gain = hCaster:GetModifierDurationGainIndex(1)
							hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_Advanced_Einherjar_buff2", { duration = self.buff_duration*gain })
							if self:GetRemainingTime() <= 0 then
								hGhost.hUnit:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
								table.remove(self.tGhosts, i)
								if #self.tGhosts == 0 then
									self:SafeDestroy()
						
									return
								end
							end
						else
							local modifier_keys = {
								duration = 0.1,
								iSpecialAttack = 1,
								iDisableApplyModifier = 0,
								iDisableCleave =0,
								iDisableSplit = 0,
						
							}
							local attackEffectRecord = hCaster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
							hCaster:PerformAttack(hGhost.hTarget, false, true, true, true, false, false, true)--对一单位执行攻击。
							if IsValid(attackEffectRecord) then
								attackEffectRecord:Destroy()
							end

							hGhost.hTarget = hParent
							hGhost.bReturning = true

						end
					else
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(50, self.radius)
					end
				end
			end

			return 0
		end
		)
	end
end
function modifier_Advanced_Einherjar_buff_unlock1:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			-- hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_Advanced_Einherjar_ghost")
			end
		end
	end
end
function modifier_Advanced_Einherjar_buff_unlock1:OnIntervalThink()
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
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_Advanced_Einherjar_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
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

































modifier_Advanced_Einherjar_ghost_unlock2 = modifier_Advanced_Einherjar_ghost_unlock2 or class({})
function modifier_Advanced_Einherjar_ghost_unlock2:IsHidden()	return true end
function modifier_Advanced_Einherjar_ghost_unlock2:IsDebuff()	return false end
function modifier_Advanced_Einherjar_ghost_unlock2:IsPurgable()	return false end
function modifier_Advanced_Einherjar_ghost_unlock2:IsPurgeException()	return false end
function modifier_Advanced_Einherjar_ghost_unlock2:IsStunDebuff()	return false end
function modifier_Advanced_Einherjar_ghost_unlock2:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Einherjar_ghost_unlock2:OnCreated(params)
	if IsServer() then

		
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local angle = caster:GetAngles()
		parent:SetModelScale(0.9)
		parent:SetAngles(angle.x, angle.y, angle.z)
		-- local pos = parent:GetAbsOrigin()
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Einherjar_ghost_unlock2_motion", {duration = 0.8})
		self:StartIntervalThink(0.8)
	end
end
function modifier_Advanced_Einherjar_ghost_unlock2:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_animation_frozen", {})
end
function modifier_Advanced_Einherjar_ghost_unlock2:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_Advanced_Einherjar_ghost_unlock2:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_Advanced_Einherjar_ghost_unlock2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_Advanced_Einherjar_ghost_unlock2:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().overrideModelName or   self:GetCaster().origin_model_name
	end
	
end
function modifier_Advanced_Einherjar_ghost_unlock2:GetOverrideAnimation(params)
	return ACT_DOTA_ATTACK
end
function modifier_Advanced_Einherjar_ghost_unlock2:GetOverrideAnimationRate()	
	return 0.4
	
end
function modifier_Advanced_Einherjar_ghost_unlock2:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_terrorblade" then
		return "abysm"
	end
	if self:GetCaster():GetUnitName()=="npc_dota_hero_monkey_king" then
		return "attack_long_range"
	end
end

function modifier_Advanced_Einherjar_ghost_unlock2:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
function modifier_Advanced_Einherjar_ghost_unlock2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
---------------------------------------------------------------------



modifier_Advanced_Einherjar_ghost_unlock2_motion = class({})

function modifier_Advanced_Einherjar_ghost_unlock2_motion:IsDebuff()				return true end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:IsHidden() 			return true end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:IsPurgable() 			return false end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:IsPurgeException() 	return true end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:IsStunDebuff() 		return true end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:OnRefresh(keys) self:OnCreated(keys) end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:IsMotionController() return true end
function modifier_Advanced_Einherjar_ghost_unlock2_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_Einherjar_ghost_unlock2_motion:OnCreated(keys)
	if IsServer() then
		if self:CheckMotionControllers() then
			local pos = self:GetParent():GetAbsOrigin()- self:GetParent():GetForwardVector()*1000 + Vector(RandomInt(-800, 800),RandomInt(-800, 800),0)
			self.dir =( self:GetParent():GetAbsOrigin()-pos):Normalized()
			self.dir.z = 0
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end

function modifier_Advanced_Einherjar_ghost_unlock2_motion:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 300
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z + motion_progress*height
	next_pos = next_pos - self.dir*10
	self:GetParent():SetOrigin(next_pos)
end

function modifier_Advanced_Einherjar_ghost_unlock2_motion:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent or parent:IsNull() then
			return
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not caster or not ability then
			return
		end
		local pos_start = GetGroundPosition(parent:GetAbsOrigin(), nil)
		local pos_target = caster:GetAbsOrigin() + caster:GetForwardVector()*1000
		FindClearSpaceForUnit(parent,pos_target, true)
	
	
		self.pos = nil
		self.distance = nil 


		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_erupt.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 0, pos_start)
		ParticleManager:SetParticleControl(pfx, 1,pos_target)
		-- ParticleManager:ReleaseParticleIndex( pfx )
		DestroyParticleByDelay(pfx,5)
		parent:EmitSound("Hero_Magnataur.ShockWave.Particle.Anvil")

		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_target, nil, 150,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE)
		local damageTable = {
			attacker = caster,
			damage = caster:GetAverageTrueAttackDamage(nil)*2,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
}
		for _, enemy in pairs(tTargets) do
		
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end

	end
end