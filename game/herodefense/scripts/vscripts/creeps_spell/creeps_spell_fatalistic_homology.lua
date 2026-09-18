creeps_spell_fatalistic_homology = class({})



LinkLuaModifier( "modifier_creeps_spell_fatalistic_homology", "creeps_spell/creeps_spell_fatalistic_homology", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_fatalistic_homology_buff", "creeps_spell/creeps_spell_fatalistic_homology", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fatalistic_homology_ghost", "creeps_spell/creeps_spell_fatalistic_homology", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')

function creeps_spell_fatalistic_homology:GetIntrinsicModifierName() return "modifier_creeps_spell_fatalistic_homology" end
--------------------------------------------------------------------------------





modifier_creeps_spell_fatalistic_homology = class({})
function modifier_creeps_spell_fatalistic_homology:IsHidden() return true end
function modifier_creeps_spell_fatalistic_homology:IsDebuff() return false end
function modifier_creeps_spell_fatalistic_homology:IsPurgable() 		return false end
function modifier_creeps_spell_fatalistic_homology:IsPurgeException() 	return false end
function modifier_creeps_spell_fatalistic_homology:RemoveOnDeath()  return false end
function modifier_creeps_spell_fatalistic_homology:IsStunDebuff() return false end
function modifier_creeps_spell_fatalistic_homology:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_fatalistic_homology:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,} 
end

function modifier_creeps_spell_fatalistic_homology:OnDeath(keys)
    if not IsServer() then
        return
    end
	local unit = keys.unit
    if unit ~= self:GetParent() and _G.GAME_DIFFICULTY>=4  then
		if unit:GetUnitName()=="npc_hd_lina" then
			-- print("lina die")
			self:GetParent():SetHealth(self:GetParent():GetHealth()+self:GetParent():GetMaxHealth()*0.2)
			-- EmitGlobalSound("custom_Slyrak_fire_dragon_linss_dead") 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_fatalistic_homology_buff", {duration = 99999})

			
		end
		if unit:GetUnitName()=="npc_hd_fire_dragon"  then
			-- print("dragon die")
			self:GetParent():SetHealth(self:GetParent():GetHealth()+self:GetParent():GetMaxHealth()*0.2)
			-- EmitGlobalSound("custom_lina_i_am_the_fire") 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_fatalistic_homology_buff", {duration = 99999})
		end
        

		
	
    end
end





modifier_creeps_spell_fatalistic_homology_buff = advanced_modifier({})
function modifier_creeps_spell_fatalistic_homology_buff:IsHidden() return true end
function modifier_creeps_spell_fatalistic_homology_buff:IsDebuff() return false end
function modifier_creeps_spell_fatalistic_homology_buff:IsPurgable() 		return false end
function modifier_creeps_spell_fatalistic_homology_buff:IsPurgeException() 	return false end
function modifier_creeps_spell_fatalistic_homology_buff:RemoveOnDeath()  return false end
function modifier_creeps_spell_fatalistic_homology_buff:IsStunDebuff() return false end
function modifier_creeps_spell_fatalistic_homology_buff:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_fatalistic_homology_buff:OnCreated(params)
	local hCaster = self:GetCaster()


	if IsServer() then
		if hCaster:GetUnitName()=="npc_hd_fire_dragon"  then
			EmitGlobalSound("custom_Slyrak_fire_dragon_linss_dead") 
			
		elseif hCaster:GetUnitName()=="npc_hd_lina" then
			EmitGlobalSound("custom_lina_i_am_the_fire") 
			for i=0, 10 do
				local Ability = self:GetParent():GetAbilityByIndex(i)
				if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()  and Ability:GetAbilityType() ~= 1  and not Ability:IsCooldownReady() then
					Ability:EndCooldown()
				end
			end
			return
		end
	
		self.radius = 1500
		self.spirits = 10
		self.spirit_speed = 600
		self.return_speed = 800
		self.current_speed = 600
		self.max_distance = 2500
		self.give_up_distance = 2000
		self.damage = hCaster:GetDamageMax()*0.25
		-- self.min_damage = 50
		-- self.max_damage = 80
	
		self.ghost_spawn_rate = 0.5
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self:StartIntervalThink(self.ghost_spawn_rate)




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
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
						end
					else
						hGhost.vTargetPosition = nil
					end
				end
			
				if not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
					hGhost.hTarget = hParent
					hGhost.bReturning = true
					-- hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
					hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
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

				if hGhost.hUnit:IsPositionInRange(vTargetPosition, 100) then
					if hGhost.hTarget ~= nil then
						if hGhost.bReturning then
							hGhost.hTarget = nil
							hGhost.bReturning = false
							if self:GetRemainingTime() <= 0 then
								hGhost.hUnit:RemoveModifierByName("modifier_fatalistic_homology_ghost")
								table.remove(self.tGhosts, i)
								if #self.tGhosts == 0 then
									self:SafeDestroy()
						
									return
								end
							end
						else
							local tDamageTable = {
								ability = hAbility,
								attacker = hCaster,
								victim = hGhost.hTarget,
								damage = self.damage,
								damage_type = DAMAGE_TYPE_MAGICAL
							}
							ApplyDamage(tDamageTable)



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
function modifier_creeps_spell_fatalistic_homology_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			-- hParent:StopSound(self.sSoundName)
		end
		if not self.tGhosts  then
			return
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_fatalistic_homology_ghost")
			end
		end
	end
end
function modifier_creeps_spell_fatalistic_homology_buff:OnIntervalThink()
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
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_fatalistic_homology_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
				vTargetPosition = nil,
				hTarget = nil,
				bReturning = false
			}
			hGhost.hUnit:SetForwardVector(vForward)
			hGhost.hUnit:SetOriginalModel("models/items/warlock/golem/ti_8_warlock_darkness_apostate_golem/ti_8_warlock_darkness_apostate_golem.vmdl")
			hGhost.hUnit:SetModelScale(1)
			-- local vRBG = Vector(128, 128, 204)
			-- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
	
			local hModel = hCaster:FirstMoveChild()
			while hModel ~= nil do
				if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
					local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hGhost.hUnit:GetAbsOrigin() })
					-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
					hWearable:FollowEntity(hGhost.hUnit, true)
				end
				hModel = hModel:NextMovePeer()
			end

			table.insert(self.tGhosts, hGhost)
		end
	end
end



function modifier_creeps_spell_fatalistic_homology_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_fatalistic_homology_buff:Advanced_GetModifier_StatusResistance(keys)
	return 200
end




---------------------------------------------------------------------
modifier_fatalistic_homology_ghost = modifier_fatalistic_homology_ghost or class({})
function modifier_fatalistic_homology_ghost:IsHidden()	return true end
function modifier_fatalistic_homology_ghost:IsDebuff()	return false end
function modifier_fatalistic_homology_ghost:IsPurgable()	return false end
function modifier_fatalistic_homology_ghost:IsPurgeException()	return false end
function modifier_fatalistic_homology_ghost:IsStunDebuff()	return false end
function modifier_fatalistic_homology_ghost:AllowIllusionDuplicate()	return false end
function modifier_fatalistic_homology_ghost:OnCreated(params)
	if IsServer() then
		self:GetParent():SetModelScale(0.05)
		Timers:CreateTimer(0.05, function()
			if IsValid(self) then
				self:GetParent():SetSkin(1)
			end
			
		end)
		
	end
end
function modifier_fatalistic_homology_ghost:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_fatalistic_homology_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,  --强制类不用管
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_fatalistic_homology_ghost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function modifier_fatalistic_homology_ghost:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	return self:GetCaster():GetModelName()
end
function modifier_fatalistic_homology_ghost:GetOverrideAnimation(params)



	return ACT_DOTA_RUN
end
function modifier_fatalistic_homology_ghost:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then
		return "haste"
	end
	return "run_fast" 
end
-- function modifier_fatalistic_homology_ghost:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
function modifier_fatalistic_homology_ghost:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_fatalistic_homology_ghost:GetEffectName() return "particles/world_tower/tower_upgrade/ti7_dire_tower_ambient_core.vpcf" end
---------------------------------------------------------------------
