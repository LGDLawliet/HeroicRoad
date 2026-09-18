--特效优化 √
Advanced_Eldwurm_soul_Aethrak = class({})

require("internal/timers")
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Aethrak", "skills/Advanced_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Aethrak_effect", "skills/Advanced_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Aethrak_unlock1", "skills/Advanced_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Aethrak_unlock2", "skills/Advanced_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Aethrak_unlock3", "skills/Advanced_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect", "skills/Advanced_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)

function Advanced_Eldwurm_soul_Aethrak:CheckKV(key)
	local table = {

		bonus_attack_speed =4,
		bonus_move_speed = 2,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Eldwurm_soul_Aethrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_aethrak/unlock3/effect.vpcf", context )
end
function Advanced_Eldwurm_soul_Aethrak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Aethrak:UnlockSecondCore(key)
	return true
end
function Advanced_Eldwurm_soul_Aethrak:UnlockThirdCore(key)

	return true
end
function Advanced_Eldwurm_soul_Aethrak:Spawn()
	self.unlock1_bonus = 0
end
function Advanced_Eldwurm_soul_Aethrak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Aethrak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Aethrak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end

function Advanced_Eldwurm_soul_Aethrak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Aethrak" end
function Advanced_Eldwurm_soul_Aethrak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Aethrak:IsRefreshable() 			return true  end
function Advanced_Eldwurm_soul_Aethrak:IsEldwurmSoulAbility() return true end



modifier_Advanced_Eldwurm_soul_Aethrak= class({})

function modifier_Advanced_Eldwurm_soul_Aethrak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Aethrak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Aethrak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Aethrak:IsPurgeException() 	return false end


function modifier_Advanced_Eldwurm_soul_Aethrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Aethrak_effect", {})

	
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
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(26,250,246))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(26,250,246))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Aethrak_unlock1", {})
		end
		if ability.unlock2 then
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Aethrak_unlock2", {})
			local pos = unit:GetOrigin()
			for i = 1, 5, 1 do
				Timers(RandomFloat(0, 0.5), function()
					local pfx = ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos)
					ParticleManager:SetParticleControl(pfx, 1, pos)
					ParticleManager:ReleaseParticleIndex( pfx )
					if not unit:IsNull() then
						unit:EmitSound("Hero_Leshrac.Lightning_Storm")
					end
				end)
		
				
					
		
			end
		end
		if ability.unlock3 then
			if not unit:IsRangedAttacker() then
				unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Aethrak_unlock3", {})
			end
			
		end
	end
end











modifier_Advanced_Eldwurm_soul_Aethrak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Aethrak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:DestroyOnExpire()	return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:GetTexture() return "soul_of_aethrak" end

function modifier_Advanced_Eldwurm_soul_Aethrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = ability:GetSpecialValueFor("bonus_move_speed")
	self.damage_index = 1
	self.damage_reduce_chance = 20
	self.lighting_chance = 10
	self.bonus_range = 0
	if self.advanced_level>=5 then
		self.lighting_chance = 15
		if self.advanced_level>=10 then
			self.damage_reduce_chance = 30
			if self.advanced_level>=15 then
				self.bonus_range = math.min(500,math.max(100,self:GetCaster():Script_GetAttackRange()*0.3))
				if self.advanced_level>=20 then
					self:StartIntervalThink(1)
				end
			end
			
		end
	end
end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(math.min(50,self:GetStackCount()+1))
	end
end

function modifier_Advanced_Eldwurm_soul_Aethrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_EVENT_ON_ATTACK_LANDED,


	}
end

function modifier_Advanced_Eldwurm_soul_Aethrak_effect:Advanced_GetModifierAttackRangeBonus() return  self.bonus_range end


function modifier_Advanced_Eldwurm_soul_Aethrak_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	if keys.damage <=  parent:GetHealth() and self.damage_reduce_chance>=RandomInt(1, 100) then

		return -100
	end
end


function modifier_Advanced_Eldwurm_soul_Aethrak_effect:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed*(1+self:GetStackCount()*0.01) end
function modifier_Advanced_Eldwurm_soul_Aethrak_effect:GetModifierMoveSpeedBonus_Constant()	return self.bonus_move_speed*(1+self:GetStackCount()*0.01) end

function modifier_Advanced_Eldwurm_soul_Aethrak_effect:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if self:GetRemainingTime()<0 then
		local pass = false
		if ability.unlock1 then
			pass = true
		else
			if self:GetCaster():GetRandomEffect(self.lighting_chance,INT_TYPE,1) >=RandomInt(1, 100) then
				pass = true
			end
		end
		if pass then
			--触发雷霆
			self:SetDuration(2, true)
			local caster = self:GetCaster()
			local damage = 0
			if ability.unlock1 then
				damage = self:GetParent():GetAverageTrueAttackDamage(nil)*self.damage_index * (1+0.3*ability:GetStack())
			else
				damage = self:GetParent():GetDamageMax()*self.damage_index
			end
			
			local target = keys.target
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
			local pos = target:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
			ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, 2000))
			ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
			ParticleManager:ReleaseParticleIndex(particle)
			target:EmitSound("Hero_Zuus.LightningBolt")

			target:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect", {stack = damage})
			


			
		end


	end


	
end


function modifier_Advanced_Eldwurm_soul_Aethrak_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end




modifier_Advanced_Eldwurm_soul_Aethrak_unlock1 = class({})

function modifier_Advanced_Eldwurm_soul_Aethrak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock1:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock1:OnCreated()
	local ability = self:GetAbility()
	-- local stack = ability:GetStack()
	-- if stack>=40 then
	-- 	self.no = true
	-- 	return
	-- end
	ability:AddStack()
end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end






modifier_Advanced_Eldwurm_soul_Aethrak_unlock2 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:IsPurgeException() return false end


function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,

	}
end

function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:GetModifierMoveSpeedBonus_Percentage() return   100 end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:GetModifierIgnoreMovespeedLimit()             return   1  end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:Advanced_GetModifierAttackSpeedPercentage()             return   20  end


function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only
    }

	return funcs

end


function modifier_Advanced_Eldwurm_soul_Aethrak_unlock2:Advanced_GetModifier_FlyingPathing()	
	return 1
end

modifier_Advanced_Eldwurm_soul_Aethrak_unlock3 = class({})

function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:GetEffectName()
	return "particles/rebuild/spell/eldwurm_soul_aethrak/unlock3/effect.vpcf"
end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_Advanced_Eldwurm_soul_Aethrak_unlock3:OnAttackLanded( params )
	if IsServer() then
		if params.attacker~=self:GetParent() then
			return
		end
		local parent = self:GetParent()
		local caster = self:GetCaster()
		if parent:IsInSpecialAttack() then
			return
		end
		local chance = 35
			
		if caster:GetRandomEffect(chance,INT_TYPE,0.5) >=RandomInt(1, 100) then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), params.target:GetAbsOrigin(), nil, 300, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER , false)
			for _, unit in ipairs(units) do
				-- print("aaa")
				if unit~=params.target then
					local modifier_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave =0,
						iDisableSplit = 0,
				
					}
					local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
					parent:PerformAttack(unit, false, true, true, false, true, false, true)
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end

					break
				end
			end
		end
	end
end





modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect = class({})

function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:IsDebuff() return true end
function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

	end
end
function modifier_Advanced_Eldwurm_soul_Aethrak_damage_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
		}
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end




