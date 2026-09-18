--特效优化 √
Advanced_Culling_Blade = class({})

LinkLuaModifier("modifier_Advanced_Culling_Blade_sprint", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Culling_Blade_debuff", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Culling_Blade_blood", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Culling_Blade_blood_effect", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Culling_Blade_kill_god", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Culling_Blade_unlock1", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Culling_Blade_unlock3", "skills/Advanced_Culling_Blade", LUA_MODIFIER_MOTION_NONE)


function Advanced_Culling_Blade:IsHiddenWhenStolen() 		return false end
function Advanced_Culling_Blade:IsRefreshable() 			return true end
function Advanced_Culling_Blade:IsStealable() 				return true end
function Advanced_Culling_Blade:IsNetherWardStealable() 	return true end

function Advanced_Culling_Blade:CheckKV(key)
	local table = {

		caster_health_percent = 1,
		speed_duration = 0.3,
		health_damage = 0.5,
		speed_aoe = 10,
		as_bonus = 2,
		speed_bonus = 1,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Culling_Blade:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/culling_blade/unlock1/ti9_jungle_axe_culling_blade_kill_lv.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/culling_blade/unlock1_3/ti9_jungle_axe_culling_blade_kill_lv.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/culling_blade/unlock2/effect.vpcf", context )

end

function Advanced_Culling_Blade:UnlockFirstCore(key)
	return true
end
function Advanced_Culling_Blade:UnlockSecondCore(key)
	return true
end

function Advanced_Culling_Blade:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Culling_Blade_unlock3",{})
	return true
end

function Advanced_Culling_Blade:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	
		elseif coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end
	return self.BaseClass.GetBehavior(self)
	
end
function Advanced_Culling_Blade:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	return true
end
function Advanced_Culling_Blade:GetAOERadius()
	return 400
end
function Advanced_Culling_Blade:Battle_Hunger_unlock1_Try(target)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local debuff_duration = self:GetSpecialValueFor("debuff_duration")
	local radius = self:GetSpecialValueFor("radius")
	local blood_duration = self:GetSpecialValueFor("blood_duration")
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local kill_index = self:GetSpecialValueFor("caster_health_percent")

	local modifier= caster:FindModifierByName("modifier_Advanced_Culling_Blade_kill_god")
	if modifier then
		kill_index  = kill_index  +modifier:GetStackCount()*5
	end

	local talent_1 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_axe_4")
	local talent_2 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_axe_4_buff")
	if talent_1 then
		kill_index = kill_index * (1+talent_1:GetAbility():GetSpecialValueFor("hp_line")*0.01)
	end
	if talent_2 then
		kill_index = kill_index * (1+talent_1:GetAbility():GetSpecialValueFor("active_line")*0.01)
		talent_2:SafeDestroy()
	end

	local kill_threshold = kill_index*0.01* caster:GetMaxHealth()
	
	local particle = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
	
	if self.unlock1 then
		local modifier = caster:FindModifierByName("modifier_Advanced_Culling_Blade_unlock1")
		if modifier then
			kill_threshold = kill_threshold + math.min(modifier:GetStackCount(),caster:GetHealth()*5)
		end
		particle = "particles/rebuild/spell/culling_blade/unlock1/ti9_jungle_axe_culling_blade_kill_lv.vpcf"

	elseif self.unlock3 then
		particle = "particles/rebuild/spell/culling_blade/unlock1_3/ti9_jungle_axe_culling_blade_kill_lv.vpcf"
	end
	if target:GetHealth() <= kill_threshold then
		TrueKill(caster, target, self)
		target:EmitSound("Hero_Axe.Culling_Blade_Success")
		local culling_kill_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(culling_kill_particle, 4,target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
		ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)
		local radius = self:GetSpecialValueFor("speed_aoe")
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
		local buff_duration = self:GetSpecialValueFor("speed_duration")
		for _, ally in pairs(allies) do
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_POINT_FOLLOW, ally)
			ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			
			ally:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_sprint", {duration = buff_duration})
		end
		CreateModifierThinker(caster, self, "modifier_Advanced_Culling_Blade_blood", {duration = 1}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
		local blood_units = FindUnitsInRadius(caster:GetTeamNumber(),  target:GetAbsOrigin(), nil, radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST , false)
		for _, blood_target in ipairs(blood_units) do
			blood_target:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_blood_effect", {duration = blood_duration})
		end

		--LV15解锁杀神
		if self.advanced_level>=15 then
			caster:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_kill_god", {duration = 15})
		end

		if self.unlock1 then
			caster:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_unlock1", {index = caster:GetStrength()*0.5})
		end
		
	end
end

function Advanced_Culling_Blade:OnAbilityPhaseInterrupted() self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4) end

function Advanced_Culling_Blade:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local level = self.advanced_level
	local buff_duration = self:GetSpecialValueFor("speed_duration")
	local debuff_duration = self:GetSpecialValueFor("duration")
	local blood_duration = self:GetSpecialValueFor("blood_duration")
	local kill_index = self:GetSpecialValueFor("caster_health_percent")

	local modifier= caster:FindModifierByName("modifier_Advanced_Culling_Blade_kill_god")
	if modifier then
		kill_index  = kill_index  +modifier:GetStackCount()*5
	end

	local talent_1 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_axe_4")
	local talent_2 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_axe_4_buff")
	if talent_1 then
		kill_index = kill_index * (1+talent_1:GetAbility():GetSpecialValueFor("hp_line")*0.01)
	end
	if talent_2 then
		kill_index = kill_index * (1+talent_1:GetAbility():GetSpecialValueFor("active_line")*0.01)
		talent_2:SafeDestroy()
	end

	local kill_threshold = kill_index*0.01* caster:GetMaxHealth()
	local particle = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
	
	if self.unlock1 then
		local modifier = caster:FindModifierByName("modifier_Advanced_Culling_Blade_unlock1")
		if modifier then
			kill_threshold = kill_threshold + math.min(modifier:GetStackCount(),caster:GetHealth()*5)
		end
		particle = "particles/rebuild/spell/culling_blade/unlock1/ti9_jungle_axe_culling_blade_kill_lv.vpcf"

	elseif self.unlock3 then
		particle = "particles/rebuild/spell/culling_blade/unlock1_3/ti9_jungle_axe_culling_blade_kill_lv.vpcf"
	end

	if self.unlock2 then
		local particle_unlock2 = ParticleManager:CreateParticle("particles/rebuild/spell/culling_blade/unlock2/effect.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle_unlock2, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_unlock2)

		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 400, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST , false)
		local success = false
		local first_target = target
		for i, unit in ipairs(units) do
		
			if unit:GetHealth() <= kill_threshold then
				TrueKill(caster, unit, self)
				unit:EmitSound("Hero_Axe.Culling_Blade_Success")
				local culling_kill_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
				ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
				ParticleManager:ReleaseParticleIndex(culling_kill_particle)
				local radius = self:GetSpecialValueFor("speed_aoe")
				local blood_radius = self:GetSpecialValueFor("radius")
				local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, ally in pairs(allies) do
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_POINT_FOLLOW, ally)
					ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(pfx)
					
					ally:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_sprint", {duration = buff_duration})
				end
				CreateModifierThinker(caster, self, "modifier_Advanced_Culling_Blade_blood", {duration = 1}, unit:GetAbsOrigin(), caster:GetTeamNumber(), false)
				local blood_units = FindUnitsInRadius(caster:GetTeamNumber(),  unit:GetAbsOrigin(), nil, blood_radius, 
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST , false)
				for _, blood_target in ipairs(blood_units) do
					blood_target:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_blood_effect", {duration = blood_duration})
				end
				caster:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_kill_god", {duration = 15})
				self:EndCooldown()
				if not success then
					success = true
					first_target = unit
				end
			else 
				local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:ReleaseParticleIndex(pfx)
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Axe.Culling_Blade_Fail", caster)
				local damageTable = {
									victim = unit,
									attacker = self:GetCaster(),
									damage = (self:GetSpecialValueFor("health_damage"))* caster:GetMaxHealth()*0.01,
									damage_type = self:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self, --Optional.
									}
				ApplyDamage(damageTable)
				unit:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_debuff", {duration = debuff_duration})
			end
			if i>=5 then
				break
			end
		end

		if success then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), first_target:GetAbsOrigin(), nil, 400, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST , false)
			local count = 0
			for i, unit in ipairs(units) do
		
				if unit:IsAlive() then
					if unit:GetHealth() <= kill_threshold then
						TrueKill(caster, unit, self)
						unit:EmitSound("Hero_Axe.Culling_Blade_Success")
						local culling_kill_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
						ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
						ParticleManager:ReleaseParticleIndex(culling_kill_particle)
						local radius = self:GetSpecialValueFor("speed_aoe")
						local blood_radius = self:GetSpecialValueFor("radius")
						local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
						for _, ally in pairs(allies) do
							local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_POINT_FOLLOW, ally)
							ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
							ParticleManager:ReleaseParticleIndex(pfx)
							
							ally:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_sprint", {duration = buff_duration})
						end
						CreateModifierThinker(caster, self, "modifier_Advanced_Culling_Blade_blood", {duration = 1}, unit:GetAbsOrigin(), caster:GetTeamNumber(), false)
						local blood_units = FindUnitsInRadius(caster:GetTeamNumber(),  unit:GetAbsOrigin(), nil, blood_radius, 
						DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST , false)
						for _, blood_target in ipairs(blood_units) do
							blood_target:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_blood_effect", {duration = blood_duration})
						end
						caster:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_kill_god", {duration = 15})
					else 
						local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
						ParticleManager:ReleaseParticleIndex(pfx)
						EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Axe.Culling_Blade_Fail", caster)
						local damageTable = {
											victim = unit,
											attacker = self:GetCaster(),
											damage = (self:GetSpecialValueFor("health_damage"))* caster:GetMaxHealth()*0.01,
											damage_type = self:GetAbilityDamageType(),
											damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
											ability = self, --Optional.
											}
						ApplyDamage(damageTable)
						unit:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_debuff", {duration = debuff_duration})
					end
					count = count +1
					if count>=5 then
						break
					end
				end
			end
		end




		
	else
		if target:GetHealth() <= kill_threshold then
			TrueKill(caster, target, self)
			target:EmitSound("Hero_Axe.Culling_Blade_Success")
			local culling_kill_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
			ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(culling_kill_particle)
			local radius = self:GetSpecialValueFor("speed_aoe")
			local blood_radius = self:GetSpecialValueFor("radius")
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, ally in pairs(allies) do
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_POINT_FOLLOW, ally)
				ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)
				
				ally:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_sprint", {duration = buff_duration})
			end
			CreateModifierThinker(caster, self, "modifier_Advanced_Culling_Blade_blood", {duration = 1}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
			local blood_units = FindUnitsInRadius(caster:GetTeamNumber(),  target:GetAbsOrigin(), nil, blood_radius, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_CLOSEST , false)
			for _, blood_target in ipairs(blood_units) do
				blood_target:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_blood_effect", {duration = blood_duration})
			end
	
			--LV15解锁杀神
			if level>=15 then
				caster:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_kill_god", {duration = 15})
			end
	
			if self.unlock1 then
				caster:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_unlock1", {index = caster:GetStrength()*0.5})
			end
			
			self:EndCooldown()
		else 
			local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(pfx, 4, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Axe.Culling_Blade_Fail", caster)
			local damageTable = {
								victim = target,
								attacker = self:GetCaster(),
								damage = (self:GetSpecialValueFor("health_damage"))* caster:GetMaxHealth()*0.01,
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
			ApplyDamage(damageTable)
			target:AddNewModifier(caster, self, "modifier_Advanced_Culling_Blade_debuff", {duration = debuff_duration})
		end
	end


end

modifier_Advanced_Culling_Blade_sprint = class({})

function modifier_Advanced_Culling_Blade_sprint:IsDebuff()				return false end
function modifier_Advanced_Culling_Blade_sprint:IsPurgable() 			return true end
function modifier_Advanced_Culling_Blade_sprint:IsPurgeException() 		return true end
function modifier_Advanced_Culling_Blade_sprint:IsHidden()				return false end

function modifier_Advanced_Culling_Blade_sprint:GetEffectName()	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf" end

function modifier_Advanced_Culling_Blade_sprint:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function modifier_Advanced_Culling_Blade_sprint:OnCreated(table)

	self.bonus_as = self:GetAbility():GetSpecialValueFor("as_bonus") 
	self.bonus_move = self:GetAbility():GetSpecialValueFor("speed_bonus") 
	-- if IsServer() then
	-- 	local level = self:GetAbility().advanced_level
	-- end
end
function modifier_Advanced_Culling_Blade_sprint:GetModifierAttackSpeedBonus_Constant()	
	if not self:GetAbility() then
		self:Destroy()
		return 
	end
	return self.bonus_as 
end
function modifier_Advanced_Culling_Blade_sprint:GetModifierMoveSpeedBonus_Percentage()	
	if not self:GetAbility() then
		self:Destroy()
		return 
	end
	return self.bonus_move
end


--额外受到伤害
modifier_Advanced_Culling_Blade_debuff = advanced_modifier({})

function modifier_Advanced_Culling_Blade_debuff:IsDebuff()			return true end
function modifier_Advanced_Culling_Blade_debuff:IsHidden() 			return false end
function modifier_Advanced_Culling_Blade_debuff:IsPurgable() 		return false end
function modifier_Advanced_Culling_Blade_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Culling_Blade_debuff:OnCreated(table)
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
		self.incoming = 40
	end
end
function modifier_Advanced_Culling_Blade_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys) 
	if not self:GetAbility() then self:Destroy() return end
	if IsServer() then	
		if keys.damage_type == DAMAGE_TYPE_PHYSICAL then
			return self.incoming
		end
	end
end
function modifier_Advanced_Culling_Blade_debuff:OnDestroy(table)
	if IsServer() then
		--LV20解锁弱点暴露++
		if self:GetAbility().advanced_level>=20 and self:GetParent():GetHealth()<=0 then
			local ability = self:GetAbility()
			ability:EndCooldown()
		end
	end
end

function modifier_Advanced_Culling_Blade_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




---血池

modifier_Advanced_Culling_Blade_blood = class({})

function modifier_Advanced_Culling_Blade_blood:OnCreated()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/newr_axe_blood_lake.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius * 1.15, 1, 1))
		self:AddParticle(pfx, false, false, 15, false, false)
		-- self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Culling_Blade_blood:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
modifier_Advanced_Culling_Blade_blood_effect = advanced_modifier({})

function modifier_Advanced_Culling_Blade_blood_effect:IsDebuff()			return false end
function modifier_Advanced_Culling_Blade_blood_effect:IsHidden() 		return false end
function modifier_Advanced_Culling_Blade_blood_effect:IsPurgable() 		return false end
function modifier_Advanced_Culling_Blade_blood_effect:IsPurgeException() return false end
function modifier_Advanced_Culling_Blade_blood_effect:ADDeclareFunctions()
	return {advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
end
function modifier_Advanced_Culling_Blade_blood_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOOLTIP}
end
function modifier_Advanced_Culling_Blade_blood_effect:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierBonusStats_Agility()
    end
end
function modifier_Advanced_Culling_Blade_blood_effect:OnCreated(keys)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local ability = self:GetAbility()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.str = ability:GetSpecialValueFor("str")
	self.agi = ability:GetSpecialValueFor("agi")

	--LV10解锁血池+
	if self.advanced_level>=15 then
		self.str = 10
		self.agi = 6
	end
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Culling_Blade_blood_effect:Advanced_GetModifierBonusStats_Strength()	
	if not self:GetAbility() then self:Destroy() return end
	return self.str*self:GetStackCount()
end
function modifier_Advanced_Culling_Blade_blood_effect:Advanced_GetModifierBonusStats_Agility()
	if not self:GetAbility() then self:Destroy() return end
	return self.agi*self:GetStackCount()
end

function modifier_Advanced_Culling_Blade_blood_effect:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Culling_Blade_blood_effect:OnIntervalThink()
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






modifier_Advanced_Culling_Blade_kill_god = class({})

function modifier_Advanced_Culling_Blade_kill_god:IsDebuff() return false end
function modifier_Advanced_Culling_Blade_kill_god:IsHidden() return false end
function modifier_Advanced_Culling_Blade_kill_god:IsPurgable() return false end



function modifier_Advanced_Culling_Blade_kill_god:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Culling_Blade_kill_god:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Culling_Blade_kill_god:OnIntervalThink()
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








modifier_Advanced_Culling_Blade_unlock1 = class({})

function modifier_Advanced_Culling_Blade_unlock1:IsDebuff() return false end
function modifier_Advanced_Culling_Blade_unlock1:IsHidden() return false end
function modifier_Advanced_Culling_Blade_unlock1:IsPurgable() return false end
function modifier_Advanced_Culling_Blade_unlock1:IsPurgeException() return false end
function modifier_Advanced_Culling_Blade_unlock1:RemoveOnDeath() return false end

function modifier_Advanced_Culling_Blade_unlock1:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end

function modifier_Advanced_Culling_Blade_unlock1:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.index)
	end
end






modifier_Advanced_Culling_Blade_unlock3 = class({})

function modifier_Advanced_Culling_Blade_unlock3:IsDebuff()				return false end
function modifier_Advanced_Culling_Blade_unlock3:IsPurgable() 			return false end
function modifier_Advanced_Culling_Blade_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Culling_Blade_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Culling_Blade_unlock3:IsHidden()				return true end
-- function modifier_Advanced_Culling_Blade_unlock3:OnCreated()
-- 	if IsServer() then
-- 		print("asdasfasfsa")
-- 	end
-- end
function modifier_Advanced_Culling_Blade_unlock3:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

function modifier_Advanced_Culling_Blade_unlock3:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		return
	end

	if keys.target == self:GetParent() then
		if keys.attacker:IsMagicImmune() or keys.attacker:IsInvulnerable() or not keys.attacker:IsAlive() then
			return
		end
		if self:GetCaster():GetRandomEffect(10,INT_TYPE,1) >=RandomInt(1, 100) then
			self:GetCaster():SetCursorCastTarget(keys.attacker)
			ability:OnSpellStart()
	
		end
	
	

		
	end
end