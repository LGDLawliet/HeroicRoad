--特效优化 √
Advanced_Eldwurm_soul_Indrak = class({})


LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Indrak", "skills/Advanced_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Indrak_effect", "skills/Advanced_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Indrak_unlock1", "skills/Advanced_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Indrak_unlock2", "skills/Advanced_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Advanced_Eldwurm_soul_Indrak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Indrak" end
function Advanced_Eldwurm_soul_Indrak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Indrak:IsRefreshable() 			return true  end

function Advanced_Eldwurm_soul_Indrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/ti7/maelstorm_ti7.vpcf", context )

	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", context )


	
end

function Advanced_Eldwurm_soul_Indrak:CheckKV(key)
	local table = {

		bonus_attack_speed =0.6,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Eldwurm_soul_Indrak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Indrak:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Eldwurm_soul_Indrak_unlock2",{})
	return true
end
function Advanced_Eldwurm_soul_Indrak:UnlockThirdCore(key)

	return true
end


function Advanced_Eldwurm_soul_Indrak:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	-- local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	-- if coreUnlockKV then
	-- 	if coreUnlockKV.coreUnlock ==1 then
	-- 		return DOTA_ABILITY_BEHAVIOR_POINT
	-- 	elseif coreUnlockKV.coreUnlock ==3 then
	-- 		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	-- 	end
		
	-- end

	if advanced_level>=15 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return self.BaseClass.GetBehavior(self)
end

function Advanced_Eldwurm_soul_Indrak:GetCooldown(iLevel)
	if self:GetSpecialValueFor("advanced_level")>=15 then
		return 1
	end

	return 0
end	


function Advanced_Eldwurm_soul_Indrak:CastFilterResultTarget( target )
	-- check nohammer
	if IsServer() then
		if target:IsRealHero() then
			return UF_FAIL_CUSTOM
		end
		if target:GetPlayerOwnerID()~=self:GetCaster():GetPlayerOwnerID() then
			return UF_FAIL_CUSTOM
		end
	

		return UF_SUCCESS
	end
	
end
function Advanced_Eldwurm_soul_Indrak:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return "#DOTA_HUB_CANT_CAST_TO_TARGET"
	end

end

function Advanced_Eldwurm_soul_Indrak:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	if self:GetAutoCastState() then
		local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- local pos = target:GetAbsOrigin()
		local pos1 = target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc"))
		ParticleManager:SetParticleControl( particle, 0,pos1)
		FindClearSpaceForUnit( target, caster:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( particle, 1, target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")))
		ParticleManager:ReleaseParticleIndex(particle)
	else
		local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- local pos = target:GetAbsOrigin()
		local pos1 = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc"))
		ParticleManager:SetParticleControl( particle, 0,pos1)
		FindClearSpaceForUnit( caster, target:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( particle, 1, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")))
		ParticleManager:ReleaseParticleIndex(particle)
	end



end




function Advanced_Eldwurm_soul_Indrak:Spawn()
	self.unlock1_bonus = 0
end
function Advanced_Eldwurm_soul_Indrak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Indrak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Indrak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end














modifier_Advanced_Eldwurm_soul_Indrak= advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Indrak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Indrak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Indrak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Indrak:IsPurgeException() 	return false end
function modifier_Advanced_Eldwurm_soul_Indrak:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.bonus_speed = 0
		self.current_unit = "aaa"
	end
end

function modifier_Advanced_Eldwurm_soul_Indrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 2,Vector(200,0,0))  
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)

		unit:EmitSound("Hero_Zuus.StaticField")
		local ability = self:GetAbility()

		if GameRules:GetGameTime()>=self.timer then
			if unit:GetUnitName()==self.current_unit then
				self.timer = GameRules:GetGameTime() +0.03
				local max = 50
				if ability.advanced_level>=5 then
					max = 80
				end
				self.bonus_speed = math.min(self.bonus_speed + 5,max)
			else
				self.current_unit = unit:GetUnitName()
				self.timer = GameRules:GetGameTime() +0.03
				self.bonus_speed = math.max(self.bonus_speed-20,0)
			end
		end

		local caster = self:GetCaster()
		unit:AddNewModifier(caster,ability, "modifier_Advanced_Eldwurm_soul_Indrak_effect", {stack = self.bonus_speed})
		if ability.unlock1 then

			local caster_pos = caster:GetOrigin()
			local unit_pos = unit:GetOrigin()
			local dir = CalculateDirection(caster_pos,unit_pos)
			-- dir.z = 0
			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , unit)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, unit_pos)
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,unit_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(111,230,237))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(111,230,237))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Indrak_unlock1", {})
		end
	end
end












modifier_Advanced_Eldwurm_soul_Indrak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Indrak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:IsPurgeException() return false end
-- function modifier_Advanced_Eldwurm_soul_Indrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus = ability:GetSpecialValueFor("bonus_attack_speed")
	self.unlock1_bonus = 1
	local chance = ability:GetSpecialValueFor("release_chance")
	if ability:GetUnlock(1)==1 then
		self.unlock1 = true
		self:StartIntervalThink(0.5)
	end
	if ability:GetUnlock(2)==2 then
		self.bonus = self.bonus * 2.5
	end
	if IsServer() then

		self:SetHasCustomTransmitterData( true )
		self.bonus_speed = keys.stack
		self.chance = chance
		if ability.advanced_level>=20 then
			self.chance = chance - 1
		end

		if IsServer() and ability.unlock3 then
			self:StartIntervalThink(1)
		end
		
		-- self:SetStackCount(keys.stack)
	end
end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if self.unlock1 then
		self.unlock1_bonus = math.min(ability:GetStack()*0.05+1,2.2)
	end
	
	
	if IsServer() then
		if ability.unlock3 then
			if self:GetStackCount()<50 then
				self:IncrementStackCount()
			end
		end
	end
end

function modifier_Advanced_Eldwurm_soul_Indrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
		

	}
end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:AddCustomTransmitterData( )
	return
	{
		bonus_speed = self.bonus_speed
	}
end

function modifier_Advanced_Eldwurm_soul_Indrak_effect:HandleCustomTransmitterData( data )
	self.bonus_speed = data.bonus_speed
end

function modifier_Advanced_Eldwurm_soul_Indrak_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.bonus*self.unlock1_bonus end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:GetModifierAttackSpeedBonus_Constant()	return (self.bonus_speed*self.unlock1_bonus) or 0 end
function modifier_Advanced_Eldwurm_soul_Indrak_effect:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	self:IncrementStackCount()
	if ability.unlock3 and 1==RandomInt(1, 2) then
		self:IncrementStackCount()
	end
	if self.chance>=RandomInt(1, 100) then
		local stack = self:GetStackCount()
		local ability = self:GetAbility()
		if ability.advanced_level>=20 then
			local units = FindUnitsInRadius(
				keys.attacker:GetTeamNumber(),	-- int, your team number
				keys.attacker:GetAbsOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
				FIND_CLOSEST,	-- int, order filter
				false	-- bool, can grow cache
			)
			for _, unit in ipairs(units) do
				if unit~=keys.attacker and unit:GetPlayerOwnerID()==keys.attacker:GetPlayerOwnerID() then
					local modifier = unit:FindModifierByName("modifier_Advanced_Eldwurm_soul_Indrak_effect")
					if modifier then
						local bonus_stck = modifier:GetStackCount()
						if bonus_stck>=3 then
							modifier:SetStackCount(math.floor(bonus_stck*0.5))
							stack = stack + math.floor(bonus_stck*0.5)
							local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
							ParticleManager:SetParticleControlEnt( particle, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true )
							ParticleManager:ReleaseParticleIndex(particle)
						end
					end
				end
			end
		end

		local gain_time = math.floor(stack/10)
		local agi_index= 0.2

		if ability.advanced_level>=10 then
			agi_index = 0.25
		end
		if gain_time>=1 then
			for i = 1, gain_time, 1 do
				agi_index = agi_index * 2
			end
		end
		agi_index = math.min(agi_index,3.2)
		self:SetStackCount(0)
		local caster = self:GetCaster()
		
		local target = keys.target
		local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt( particle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle)
		target:EmitSound("Hero_Zuus.ArcLightning.Cast")
		local damageTable = {
			victim = target,
			attacker = caster,
			damage =  caster:GetAgility()*agi_index*stack,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = ability,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
		ApplyDamage(damageTable)
		if keys.target:GetHealth()<= caster:GetAgility()*agi_index*stack then
			TrueKill(caster, keys.target, self:GetAbility())
		end
	end
	

	
end


function modifier_Advanced_Eldwurm_soul_Indrak_effect:OnTooltip()
	return self:Advanced_GetModifierAttackSpeedPercentage()
end



function modifier_Advanced_Eldwurm_soul_Indrak_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end







modifier_Advanced_Eldwurm_soul_Indrak_unlock1 = class({})

function modifier_Advanced_Eldwurm_soul_Indrak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock1:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock1:OnCreated()
	local ability = self:GetAbility()
	-- local stack = ability:GetStack()
	-- if stack>=40 then
	-- 	self.no = true
	-- 	return
	-- end
	ability:AddStack()
end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end





modifier_Advanced_Eldwurm_soul_Indrak_unlock2 = class({})

function modifier_Advanced_Eldwurm_soul_Indrak_unlock2:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock2:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock2:IsPurgable() 		    return false end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock2:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Indrak_unlock2:RemoveOnDeath() return false end