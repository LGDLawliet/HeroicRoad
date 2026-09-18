--特效优化 √
Advanced_Eldwurm_soul_Lirrak = class({})


LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_effect", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_effect2", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_debuff", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_lv20", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_unlock1", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_unlock2", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all", "skills/Advanced_Eldwurm_soul_Lirrak", LUA_MODIFIER_MOTION_NONE)
-- require('internal/timers')   --计时器功能
function Advanced_Eldwurm_soul_Lirrak:CheckKV(key)
	local table = {

		bonus_health_regen =2,
		bonus_attack_range = 1.8,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Eldwurm_soul_Lirrak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Lirrak:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Eldwurm_soul_Lirrak_unlock2",{})
	-- self:AddModifierToAllHero(caster,self,"modifier_Advanced_Eldwurm_soul_Lirrak_unlock2",{})
	return true
end
function Advanced_Eldwurm_soul_Lirrak:UnlockThirdCore(key)

	return true
end
function Advanced_Eldwurm_soul_Lirrak:Spawn()
	self.unlock1_bonus = 0
end
function Advanced_Eldwurm_soul_Lirrak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Lirrak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Lirrak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end

function Advanced_Eldwurm_soul_Lirrak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Lirrak" end
function Advanced_Eldwurm_soul_Lirrak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Lirrak:IsRefreshable() 			return true  end

function Advanced_Eldwurm_soul_Lirrak:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/monkey_king/arcana/water/mk_arcana_spring_cast_ring_outer_pnt.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/ice_blast/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/tuskarr/tusk_ti9_immortal/tusk_ti9_walruspunch_tgt_fishes.vpcf", context )

	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", context )

	
end

function Advanced_Eldwurm_soul_Lirrak:FrozenEffect(parent)
	local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/items/ice_blast/effect.vpcf", PATTACH_WORLDORIGIN , parent)
	local pos = parent:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(300,0,0))
	DestroyParticleByDelay(particle_cast_fx,8)
	-- ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	parent:EmitSound("Hero_Crystal.CrystalNova")
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
	caster:GetTeamNumber(),	-- int, your team number
	pos,	-- point, center point
	nil,	-- handle, cacheUnit. (not known)
	300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
	FIND_CLOSEST,	-- int, order filter
	false	-- bool, can grow cache
	)


	local count = 0
	for i,unit in pairs(enemies) do
		if not unit:HasModifier("modifier_Advanced_Eldwurm_soul_Lirrak_debuff") then
			unit:AddNewModifier(caster, self, "modifier_Advanced_Eldwurm_soul_Lirrak_debuff", {duration = 2})
			count = count+ 1
			if count>=10 then
				return
			end
		end
	end
end



modifier_Advanced_Eldwurm_soul_Lirrak= class({})

function modifier_Advanced_Eldwurm_soul_Lirrak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Lirrak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Lirrak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Lirrak:IsPurgeException() 	return false end

function modifier_Advanced_Eldwurm_soul_Lirrak:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
	end
end
function modifier_Advanced_Eldwurm_soul_Lirrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		-- local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Lirrak_effect", {})
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_arcana_spring_cast_ring_outer_pnt.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		unit:EmitSound("Hero_NagaSiren.Riptide.Cast")
		if ability.advanced_level>=15 then
			if GameRules:GetGameTime()>=self.timer then
				self.timer =  GameRules:GetGameTime() +0.03
				local units = FindUnitsInRadius(
				unit:GetTeamNumber(),	-- int, your team number
				pos,	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
				FIND_CLOSEST,	-- int, order filter
				false	-- bool, can grow cache
				)
				local heal_list = {}
				for index, target in ipairs(units) do
					if unit~=target and target:GetMainControllingPlayer()==unit:GetMainControllingPlayer() then
						table.insert(heal_list,target)
					end
				end
				if #heal_list>0 then
					local heal_index = #heal_list * 2*0.01
					for _, target in ipairs(units) do
						if target:GetMaxHealth()>=200 then
							local healing = HealWithGain(target:GetMaxHealth()*heal_index,caster,target,ability)
							SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
							local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/tuskarr/tusk_ti9_immortal/tusk_ti9_walruspunch_tgt_fishes.vpcf", PATTACH_WORLDORIGIN , target)
							ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin()+Vector(0,0,24))
							ParticleManager:ReleaseParticleIndex(particle_cast_fx)
						end	
					end
				end
			end
			
		end

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
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(126,212,255))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(126,212,255))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Lirrak_unlock1", {})
		end

		-- modifier_Advanced_Eldwurm_soul_Lirrak_unlock1
	end
end












modifier_Advanced_Eldwurm_soul_Lirrak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Lirrak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect:IsPurgeException() return false end
-- function modifier_Advanced_Eldwurm_soul_Lirrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_health_regen = ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_attack_range = ability:GetSpecialValueFor("bonus_attack_range")

	if IsServer() then
		if ability.unlock3 then
			self.damage_count = 0
		end
		
	end
end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Eldwurm_soul_Lirrak_effect2", {})
		local parent = self:GetParent()
		if not parent:IsAlive() then

			
			ability:FrozenEffect(parent)

			local caster = self:GetCaster()
			local pos = parent:GetOrigin()


			if ability.advanced_level>=20 and parent:GetMaxHealth()>=200 then
				local units = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					pos,	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					700,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
					DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
					FIND_CLOSEST,	-- int, order filter
					false	-- bool, can grow cache
				)
				local gain = caster:GetModifierDurationGainIndex(1)
				for i,target in pairs(units) do
					if target:GetMaxHealth()>=200 then
						local healing = HealWithGain(target:GetMaxHealth()*0.15,caster,target,ability)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
					end
					target:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Lirrak_lv20", {duration = 20*gain})
				end
				local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", PATTACH_WORLDORIGIN , parent)
				ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
				ParticleManager:ReleaseParticleIndex(particle_cast_fx)

				
			end
		end
	end
end


function modifier_Advanced_Eldwurm_soul_Lirrak_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP, 
	}
	if self:GetAbility():GetUnlock(3)==3 and self:GetParent():GetHealth()>=200 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end
	return funcs
end


function modifier_Advanced_Eldwurm_soul_Lirrak_effect:AdvancedGetModifierConstantHealthRegen()	

	return self.bonus_health_regen
end

function modifier_Advanced_Eldwurm_soul_Lirrak_effect:Advanced_GetModifierAttackRangeBonusPercentage()	
	return self.bonus_attack_range
end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end
		if flDamage<=0 then
			return
		end
		self.damage_count = self.damage_count + flDamage
		if self.damage_count>=(Target:GetMaxHealth()*0.3+1000) then
			self.damage_count = 0
			self:GetAbility():FrozenEffect(Target)
		end


	end

	return 0.0

end


function modifier_Advanced_Eldwurm_soul_Lirrak_effect:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantHealthRegen()
	elseif self._tooltip == 2 then
		return  self:Advanced_GetModifierAttackRangeBonusPercentage()
	end

end

function modifier_Advanced_Eldwurm_soul_Lirrak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE

    }
end





modifier_Advanced_Eldwurm_soul_Lirrak_effect2 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:IsHidden() 			return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:IsPurgable() 		    return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:RemoveOnDeath() return false end


function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:OnCreated(keys)
	if IsServer() then
		local bonus = 4
		if self:GetAbility().advanced_level>=5 then
			bonus = 6
		end
		self:SetStackCount(bonus)


	end
end

function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:OnRefresh(keys)
	if IsServer() then
		local bonus = 4
		if self:GetAbility().advanced_level>=5 then
			bonus = 6
		end
		self:SetStackCount(math.min(bonus+self:GetStackCount(),50))


	end
end



function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:DeclareFunctions()
	return {



		MODIFIER_PROPERTY_TOOLTIP,      

	
		

	}
end


function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:OnTooltip()	

	return self:GetStackCount()
end



function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:OnSummonUnit(keys)
	if IsServer() then
		self:SetDuration(0.03, false)
	end
end

-- advanced_modifier
function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_Advanced_Eldwurm_soul_Lirrak_effect2:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self:GetStackCount()
end




modifier_Advanced_Eldwurm_soul_Lirrak_debuff = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:IsDebuff() return true end
function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:IsPurgable() return true end
function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:OnCreated()
	self.bonus_damage = 20
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
		self.bonus_damage = 35
		if self:GetAbility():GetUnlock(3)==3 then
			self.bonus_damage = 150
		end
	end
end




function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end
function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:Advanced_GetModifierIncomingDamage_Percentage()	return self.bonus_damage end


function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:OnTooltip()
	return self:Advanced_GetModifierIncomingDamage_Percentage()
end




function modifier_Advanced_Eldwurm_soul_Lirrak_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	
	return state
end






modifier_Advanced_Eldwurm_soul_Lirrak_lv20 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:IsHidden()	return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:IsDebuff()	return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:IsPurgable()	return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

-- function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:GetModifierTotalDamageOutgoing_Percentage()	return math.min(self:GetStackCount(),60) end

function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:OnTooltip()
	return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
end




function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:SetStackCount(4)
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		
		table.insert(self.tData, {dieTime = dieTime })
		-- self:IncrementStackCount()
		self:SetStackCount(4+self:GetStackCount())
	
	end
end

function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:SetStackCount(self:GetStackCount()-4)
	
		
			end
		end
	end
end

-- advanced_modifier
function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
	return funcs

end
function modifier_Advanced_Eldwurm_soul_Lirrak_lv20:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return math.min(self:GetStackCount(),60) 
end




modifier_Advanced_Eldwurm_soul_Lirrak_unlock1 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:OnCreated()
	local ability = self:GetAbility()
	ability:AddStack()

	self.bonus = ability:GetStack()
	self:StartIntervalThink(2)
end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	self.bonus = self:GetAbility():GetStack()

end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:OnTooltip()	

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierHealReceiveAMP_Percentage()
	end


end


-- advanced_modifier
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return 4*self.bonus
end

function modifier_Advanced_Eldwurm_soul_Lirrak_unlock1:Advanced_GetModifierIncomingDamage_Percentage()	return -math.min(self.bonus*1.5,30) end










modifier_Advanced_Eldwurm_soul_Lirrak_unlock2 = class({})

function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:IsPurgable() 		    return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:RemoveOnDeath() return false end


function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
	end
end





function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		if not ability then
			self:SafeDestroy()
			return
		end
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all", {})

	end
end







modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all= class({})

function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:IsPurgeException() 	return false end

function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end
-- function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:OnIntervalThink()
-- 	local ability = self:GetAbility()

-- 	local parent = self:GetParent()
-- 	if parent:GetHealthPercent()<=self.health then
-- 		local heal = parent:GetMaxHealth()*0.4
-- 		if ability.unlock2 then
-- 			heal = parent:GetMaxHealth()*0.6
-- 		end
		
-- 		local healing = HealWithGain(heal,self:GetCaster(),parent,ability)
-- 		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
-- 		self:DecrementStackCount()
-- 		EmitSoundOn("Hero_Morphling.AdaptiveStrikeStr.Target", parent)	
-- 		local attachment = parent:ScriptLookupAttachment( "attach_hitloc" )
-- 		local info = 
-- 					{
-- 					Target = parent,
-- 					Source = parent,
-- 					Ability = ability,
-- 					EffectName = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf",
-- 					iMoveSpeed = 1000,
-- 					vSourceLoc = parent:GetAttachmentOrigin(attachment),
-- 					bDodgeable = false,
-- 					bProvidesVision = false,
-- 					flExpireTime = GameRules:GetGameTime() + 4,
-- 		}

-- 		ProjectileManager:CreateTrackingProjectile( info )
-- 		self:SafeDestroy()
-- 	end
-- end
function modifier_Advanced_Eldwurm_soul_Lirrak_unlock2_effect_all:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		-- local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end
	
		if Target:GetHealth()<=0 then
			local modifier = Target:FindModifierByName("modifier_kill")
			if not modifier then
				return
			end
			if modifier:GetRemainingTime()<=1 then
				return
			end
			Target:SetHealth(Target:GetMaxHealth())
			EmitSoundOn("Hero_Morphling.AdaptiveStrikeStr.Target", Target)	
			local attachment = Target:ScriptLookupAttachment( "attach_hitloc" )
			local info = 
						{
						Target = Target,
						Source = Target,
						Ability = nil,
						EffectName = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf",
						iMoveSpeed = 1000,
						vSourceLoc = Target:GetAttachmentOrigin(attachment),
						bDodgeable = false,
						bProvidesVision = false,
						flExpireTime = GameRules:GetGameTime() + 4,
			}
	
			ProjectileManager:CreateTrackingProjectile( info )
			self:SafeDestroy()
		end



	end

	return 0.0

end

