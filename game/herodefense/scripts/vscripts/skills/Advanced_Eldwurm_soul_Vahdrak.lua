--特效优化 √
Advanced_Eldwurm_soul_Vahdrak = class({})


LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Vahdrak", "skills/Advanced_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Vahdrak_effect", "skills/Advanced_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_unlock1", "skills/Advanced_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_unlock3", "skills/Advanced_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff", "skills/Advanced_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function Advanced_Eldwurm_soul_Vahdrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_vahdrak/status_effect.vpcf", context )
end
function Advanced_Eldwurm_soul_Vahdrak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Vahdrak" end
function Advanced_Eldwurm_soul_Vahdrak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Vahdrak:IsRefreshable() 			return true  end
function Advanced_Eldwurm_soul_Vahdrak:IsEldwurmSoulAbility() return true end
function Advanced_Eldwurm_soul_Vahdrak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Vahdrak:UnlockSecondCore(key)
	return true
end
function Advanced_Eldwurm_soul_Vahdrak:UnlockThirdCore(key)

	return true
end
function Advanced_Eldwurm_soul_Vahdrak:CheckKV(key)
	local table = {

		bonus_damage_max =1.5,
		bonus_damage_min = 0.5,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Eldwurm_soul_Vahdrak:Spawn()
	self.unlock1_bonus = 0
end
function Advanced_Eldwurm_soul_Vahdrak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Vahdrak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Vahdrak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end

modifier_Advanced_Eldwurm_soul_Vahdrak= class({})

function modifier_Advanced_Eldwurm_soul_Vahdrak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Vahdrak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Vahdrak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Vahdrak:IsPurgeException() 	return false end


function modifier_Advanced_Eldwurm_soul_Vahdrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		if ability.unlock1 then
			stack = stack * (1+ability:GetStack()*0.07)
		end
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Vahdrak_effect", {stack=stack})


		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle_cast_fx, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
		ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
		-- ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(particle_cast_fx, false)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end)

		unit:EmitSound("Hero_ChaosKnight.RealityRift")
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
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(42,0,0))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(42,0,0))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_unlock1", {})
		end
		if ability.unlock3 then
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_unlock3", {})
		end
		
		-- end
	end
end












modifier_Advanced_Eldwurm_soul_Vahdrak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:DestroyOnExpire()	return false end
-- function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.crit = {}
	self.bonus_attackSpeed_index = 0
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		self.bonus_attackSpeed_index =1
	end

	if IsServer() then
		self:SetStackCount(keys.stack)
		self.chance = 7
		if ability.advanced_level>=10 then
			self.chance = 13
		end
	end
end


-- function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:OnDestroy() self.crit = nil end


function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度

	}
end


function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount() end
function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:GetModifierAttackSpeedBonus_Constant()	return  self:GetStackCount()*self.bonus_attackSpeed_index end




function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:OnAttackFail(keys) self.crit[keys.record] = nil end


function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:OnAttackLanded(keys)
   if not IsServer() then
	   return
   end
   local ability = self:GetAbility()
   if not ability or ability:IsNull() then
	   self:SafeDestroy()
	   return
   end
   if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
	   return
   end
   local caster = self:GetParent()
   if not self.crit then
		return
	end
   if self.chance>=RandomInt(1, 100) then
		local pfx_name = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt_explosion.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
		self:GetParent():EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")
		ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		local damageTable = {
			victim = keys.target,
			attacker = caster,
			damage = caster:GetHealth()*0.1,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)
   end
   if self.crit[keys.record] then
	   local pfx_name = "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf"
	   local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
	   self:GetParent():EmitSound("Hero_ChaosKnight.ChaosStrike")
	   ParticleManager:SetParticleControlEnt(pfx, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
	   ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin())
	   ParticleManager:SetParticleControl(pfx, 2, keys.target:GetAbsOrigin())
	--    ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
	   ParticleManager:ReleaseParticleIndex(pfx)
	  
		if self:GetAbility().advanced_level>=5 then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
	 
			local gain = caster:GetModifierLifeStealGain(1)
			local flLifesteal = keys.damage * 0.3*gain
			caster:Heal( flLifesteal, self:GetAbility() )
		end
	

   end
   self.crit[keys.record] = nil
end

function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:OnDeath(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
    if keys.unit == self:GetParent() and self:GetAbility().advanced_level>=15 then
        local pos = keys.unit:GetAbsOrigin()
        local caster = self:GetCaster()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
		ParticleManager:SetParticleControlEnt(effect_cast, 2,  keys.unit, PATTACH_POINT_FOLLOW, "attach_head",  keys.unit:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl( effect_cast, 0, pos )
		-- ParticleManager:SetParticleControl( effect_cast, 1, Vector(700,0,0) )
		caster:EmitSound("Hero_ChaosKnight.Phantasm")
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(effect_cast, false)
			ParticleManager:ReleaseParticleIndex(effect_cast)
		end)
		-- ParticleManager:ReleaseParticleIndex( effect_cast )
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = keys.unit:GetAverageTrueAttackDamage(nil)*2
		local damageTable = {
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
			}
		for i,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
       



    end
end


function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end

function modifier_Advanced_Eldwurm_soul_Vahdrak_effect:Advanced_GetModifierCriticalStrike(keys)



	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther()
	 and not self:GetParent():PassivesDisabled() then
		 if not self or self:IsNull() then
			 return 0
		 end
		 local ability = self:GetAbility()
		 if not ability then
			 return
		 end
 
		 if ability.unlock2 then
			 if 25>=RandomInt(1, 100) then
				 self.crit[keys.record] = true
				 local damage_mul =  RandomInt(180, 320)
				 return damage_mul 
			 end
		 end
 
		if self:GetRemainingTime()<=0 then
			self.crit[keys.record] = true
			self:SetDuration(3, true)
			local caster = self:GetParent()
			local damage_mul =  RandomInt(120, 220)
			return damage_mul 

		 else
			return 0
		end
	end
 end




modifier_Advanced_Eldwurm_soul_Slyrak_unlock1 = class({})

function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:OnCreated()
	local ability = self:GetAbility()
	-- local stack = ability:GetStack()
	-- if stack>=40 then
	-- 	self.no = true
	-- 	return
	-- end
	ability:AddStack()
end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end





modifier_Advanced_Eldwurm_soul_Slyrak_unlock3 = class({})

function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:GetHealth()<=0 and not parent.specialUnit then
			local caster = self:GetCaster()
			local unit = caster:SummonUnit("npc_hd_chaos_unit",10,
			parent:GetOrigin(),
			self:GetCaster():GetForwardVector(),self:GetAbility(),0,caster:GetMaxHealth()*0.25,nil,caster:GetDamageMax()*2,0,1,0)
			if unit then
				unit.specialUnit = true
				unit:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff", {})
			end
		end
	end

end




modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff = class({})

function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:IsPurgeException() 	return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:StatusEffectPriority() return 16 end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:GetStatusEffectName()
	return "particles/rebuild/spell/eldwurm_soul_vahdrak/status_effect.vpcf"
end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock3_buff:CheckState() return 
	{
	
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,

	
	} 
end
