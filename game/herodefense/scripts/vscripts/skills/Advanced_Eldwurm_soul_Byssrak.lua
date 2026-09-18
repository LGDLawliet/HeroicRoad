--特效优化 √
Advanced_Eldwurm_soul_Byssrak = class({})


LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Byssrak", "skills/Advanced_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Byssrak_effect", "skills/Advanced_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Byssrak_unlock1", "skills/Advanced_Eldwurm_soul_Byssrak", LUA_MODIFIER_MOTION_NONE)

function Advanced_Eldwurm_soul_Byssrak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Byssrak" end
function Advanced_Eldwurm_soul_Byssrak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Byssrak:IsRefreshable() 			return true  end
function Advanced_Eldwurm_soul_Byssrak:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_walk_preimage.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", context )



	
	
end
function Advanced_Eldwurm_soul_Byssrak:CheckKV(key)
	local table = {

		bonus_damage =1,
		attack_speed_reduce = 0.2,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Eldwurm_soul_Byssrak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Byssrak:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Eldwurm_soul_Uldorak_unlock2",{})
	return true
end
function Advanced_Eldwurm_soul_Byssrak:UnlockThirdCore(key)

	return true
end




function Advanced_Eldwurm_soul_Byssrak:Spawn()
	self.unlock1_bonus = 0
end
function Advanced_Eldwurm_soul_Byssrak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Byssrak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Byssrak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end


modifier_Advanced_Eldwurm_soul_Byssrak= class({})

function modifier_Advanced_Eldwurm_soul_Byssrak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Byssrak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Byssrak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Byssrak:IsPurgeException() 	return false end


function modifier_Advanced_Eldwurm_soul_Byssrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
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
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(182,0,255))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(182,0,255))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Byssrak_unlock1", {})
		end
		

		unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Byssrak_effect", {})
		local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetOrigin() + Vector(0,0,128)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		for i = 1, 5, 1 do
			local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_WORLDORIGIN , unit)
			local new_pos = pos + Vector(RandomInt(-100, 100),RandomInt(-100, 100),RandomInt(-50, 200))
			ParticleManager:SetParticleControl(particle_cast_fx, 0, new_pos)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end
		

		unit:EmitSound("Hero_Enigma.Malefice")

	end
end



modifier_Advanced_Eldwurm_soul_Byssrak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Byssrak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:DestroyOnExpire() return false end
-- function modifier_Advanced_Eldwurm_soul_Byssrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.attack_speed_reduce = -ability:GetSpecialValueFor("attack_speed_reduce")
	if ability:GetUnlock(3)==3 then
		self.attack_speed_reduce  = self.attack_speed_reduce * -0.75
	end
	if IsServer() then
		self.bonus_totaldamage = 0
		self.trigger_chance = 7
		self.cooldown = 3
		self.record ={}
		if ability.advanced_level>=5 then
			self:StartIntervalThink(0.2)
			if ability.unlock1 then
				local interval = 0.3/(1+ability:GetStack()*0.08)
				math.max(interval,0.03)
				self:StartIntervalThink(interval)
			end
			self.lv5 = true
			self.need_stack = 20
			if ability.advanced_level>=10 then
				self.trigger_chance = 11
				self.cooldown = 2
				if ability.advanced_level>=15 then
					self.lv15 = true
					if ability.advanced_level>=20 then
						self.need_stack = 7
					end
				end
			end
			
		else
			self:StartIntervalThink(0.5)
		end
		
	end
end

function modifier_Advanced_Eldwurm_soul_Byssrak_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,      
		MODIFIER_PROPERTY_TOOLTIP
	}
	if self:GetParent():IsRangedAttacker() then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end
	return funcs
end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:OnIntervalThink()

	self:SetStackCount(math.min(self:GetStackCount()+1,50))
	
	
end

function modifier_Advanced_Eldwurm_soul_Byssrak_effect:OnTooltip()

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()	
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	end
end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:GetModifierDamageOutgoing_Percentage()	return self.bonus_damage end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.attack_speed_reduce end



function modifier_Advanced_Eldwurm_soul_Byssrak_effect:OnAttackLanded(keys)
	if IsServer() then
		local parnet = self:GetParent()
		if keys.attacker == parnet then
			if self:GetRemainingTime()>0 then
				return
			end
			local ability = self:GetAbility()
			if not ability then
				return
			end
			if CalculateDistance(parnet,keys.target)<=300 then
				local chance = self.trigger_chance
				local damage_index = 0.3
				if ability.unlock2 then
					chance = 100
					damage_index = 0.7
				end
				if chance>=RandomInt(1, 100) then
					if keys.target:IsAlive() then
						local radius = math.min(parnet:Script_GetAttackRange()-50,1200)
						local pos = parnet:GetOrigin()
						local new_pos = pos + parnet:GetForwardVector()*radius
						local pre_pos = keys.target:GetOrigin()
						FindClearSpaceForUnit( keys.target, new_pos, true )

						local damage =  parnet:GetAverageTrueAttackDamage(nil)*damage_index
						
						
						local damageTable = {
							victim = keys.target,
							attacker = self:GetCaster(),
							damage = damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
						ApplyDamage(damageTable)	
						local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_walk_preimage.vpcf", PATTACH_WORLDORIGIN , keys.target)

						ParticleManager:SetParticleControl(particle_cast_fx, 0, pre_pos)
						local now_pos =  keys.target:GetOrigin()
						-- local dir = CalculateDistance(pre_pos,now_pos) * CalculateDirection(pre_pos,new_pos)
						ParticleManager:SetParticleControl(particle_cast_fx, 1, now_pos)
						ParticleManager:ReleaseParticleIndex(particle_cast_fx)
						keys.target:EmitSound("Hero_FacelessVoid.TimeWalk.Aeons")

						self:SetDuration(self.cooldown, true)
					end
			

				end
			end
			
			
		end
	end
end



function modifier_Advanced_Eldwurm_soul_Byssrak_effect:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		-- if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end

		if self.record[keys.record] then
			self.record[keys.record] = nil
			if keys.damage<=100 then return	end
			local ability = self:GetAbility()
			if not ability then
				return
			end
			local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), unit:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local damageTable = {
								victim = unit,
								attacker = self:GetCaster(),
								damage = keys.damage,
								damage_type = keys.damage_type,
								damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
								ability = ability, --Optional.
			}
			if ability.advanced_level>=20 then
				local limit = attacker:GetAverageTrueAttackDamage(nil)*0.5
				for i, unit in ipairs(enemies) do
					damageTable.victim = unit
					ApplyDamage(damageTable)
					if unit:IsAlive() and unit:GetHealth()<=limit then
				

						local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_CUSTOMORIGIN , nil)
						local new_pos = unit:GetOrigin() + Vector(0,0,80)
						ParticleManager:SetParticleControl(particle_cast_fx, 0, new_pos)
						ParticleManager:ReleaseParticleIndex(particle_cast_fx)
						TrueKill(self:GetCaster(),unit, ability)
					end
					if i>=5 then
						break
					end
				end
			else
				for i, unit in ipairs(enemies) do
					damageTable.victim = unit
					ApplyDamage(damageTable)
					if i>=5 then
						break
					end
				end
			end
			
			local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			attacker:EmitSound("Hero_MonkeyKing.Spring.Impact")

		end
		


		-- if self:GetAbility():IsCooldownReady() and 20>=RandomInt(1, 100) then
		-- 	local cooldown_time = keys.damage/(5*attacker:GetIntellect(false))
		-- 	if cooldown_time>5 then cooldown_time=5 end
		-- 	if cooldown_time<0.1 then cooldown_time=0.1 end
		-- 	self:GetAbility():StartCooldown(keys.damage/(10*attacker:GetIntellect(false)))
		-- 	local damage = keys.damage *0.5

		-- 	local damageTable = {
		-- 						victim = unit,
		-- 						attacker = attacker,
		-- 						damage = damage,
		-- 						damage_type = keys.damage_type,
		-- 						damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
		-- 						ability = keys.inflictor, --Optional.
		-- 						}
		-- 	local applydamage = ApplyDamage(damageTable)
		-- 	if applydamage<=0 then
		-- 		return
		-- 	end
		-- 	fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
		-- end
		

 
    end 
end


-- advanced_modifier
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
	return funcs

end
function modifier_Advanced_Eldwurm_soul_Byssrak_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then	return 0 end
	local damage = self:GetStackCount()*10
	if IsServer() then
		if self.lv5 then
			if self:GetStackCount()>=self.need_stack then
				self.record[keys.record] = true
			end
		end
		if self.lv15 then
			local stack = self:GetStackCount()
			local min_stack = RandomInt(1, 2)
			stack = math.max(stack *0.6,min_stack)
			self:SetStackCount(stack)
		else
			self:SetStackCount(0)
		end
		
		return damage
	end	
	return damage
end




modifier_Advanced_Eldwurm_soul_Byssrak_unlock1 = class({})

function modifier_Advanced_Eldwurm_soul_Byssrak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_unlock1:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Byssrak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Byssrak_unlock1:OnCreated()
	local ability = self:GetAbility()
	-- local stack = ability:GetStack()
	-- if stack>=40 then
	-- 	self.no = true
	-- 	return
	-- end
	ability:AddStack()
end
function modifier_Advanced_Eldwurm_soul_Byssrak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end

