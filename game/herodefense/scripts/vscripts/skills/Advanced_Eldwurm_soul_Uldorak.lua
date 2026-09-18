--特效优化 √
Advanced_Eldwurm_soul_Uldorak = class({})


LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Uldorak", "skills/Advanced_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Uldorak_effect", "skills/Advanced_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Uldorak_buff", "skills/Advanced_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Uldorak_unlock1", "skills/Advanced_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Uldorak_unlock2", "skills/Advanced_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Uldorak_unlock3", "skills/Advanced_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
-- require('internal/timers')   --计时器功能

function Advanced_Eldwurm_soul_Uldorak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Uldorak" end
function Advanced_Eldwurm_soul_Uldorak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Uldorak:IsRefreshable() 			return true  end
function Advanced_Eldwurm_soul_Uldorak:IsEldwurmSoulAbility() return true end
function Advanced_Eldwurm_soul_Uldorak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Uldorak:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Eldwurm_soul_Uldorak_unlock2",{})
	return true
end
function Advanced_Eldwurm_soul_Uldorak:UnlockThirdCore(key)

	return true
end
function Advanced_Eldwurm_soul_Uldorak:CheckKV(key)
	local table = {

		bonus_armor =0.7,
		bonus_magic_res = 0.5,



	}
	local value = table[key] or -1
	return value

end




function Advanced_Eldwurm_soul_Uldorak:Spawn()
	self.unlock1_bonus = 0
end
function Advanced_Eldwurm_soul_Uldorak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Uldorak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Uldorak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end


function Advanced_Eldwurm_soul_Uldorak:GetBehavior()
	if self:GetUnlock(3)==3 then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return self.BaseClass.GetBehavior(self)
	end
end


modifier_Advanced_Eldwurm_soul_Uldorak= class({})

function modifier_Advanced_Eldwurm_soul_Uldorak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Uldorak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Uldorak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Uldorak:IsPurgeException() 	return false end


function modifier_Advanced_Eldwurm_soul_Uldorak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()

		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Uldorak_effect", {})

		local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/earthspirit_petrify_shockwave.vpcf", PATTACH_WORLDORIGIN , unit)
		local pos = unit:GetAbsOrigin()
		-- ParticleManager:SetParticleControl(particle_cast_fx, 1, self:GetCaster():GetAbsOrigin())
		-- ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 3, Vector(200,0,0))
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		unit:EmitSound("Hero_EarthSpirit.StoneRemnant.Destroy")

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
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(106,58,0))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 60, Vector(106,58,0))
			ParticleManager:SetParticleControl(particle_cast_fx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Uldorak_unlock1", {})
		end

		if ability:GetAutoCastState() then
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Uldorak_unlock3", {})
		end
	end
end













modifier_Advanced_Eldwurm_soul_Uldorak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Uldorak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_effect:IsPurgeException() return false end
-- function modifier_Advanced_Eldwurm_soul_Uldorak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Uldorak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_res = ability:GetSpecialValueFor("bonus_magic_res")
	self.regen = 0
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		self.regen = 1 
		if self:GetAbility():GetUnlock(1)==1 then
			self.regen = self.regen * (1+self:GetAbility():GetStack()*0.14)
		end
	end
	if IsServer() then
		self.take_damage = 0
		self.max_stack = 20
		self.time_chance = 10
		if ability.advanced_level>=5 then
			self.max_stack = 30
			if ability.advanced_level>=10 then
				self.time_chance = 15

			end
		end
	end
end


function modifier_Advanced_Eldwurm_soul_Uldorak_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_EVENT_ON_TAKEDAMAGE

	}
end


function modifier_Advanced_Eldwurm_soul_Uldorak_effect:AdvancedGetModifierConstantHealthRegenPercentage()
	return not self:GetParent():IsMoving() and self.regen or 0
end



function modifier_Advanced_Eldwurm_soul_Uldorak_effect:Advanced_GetModifierPhysicalArmorBonus()	return self.bonus_armor+self:GetStackCount() end
function modifier_Advanced_Eldwurm_soul_Uldorak_effect:GetModifierMagicalResistanceBonus()	return self.bonus_magic_res+self:GetStackCount()*0.5 end



function modifier_Advanced_Eldwurm_soul_Uldorak_effect:OnTakeDamage(keys)
    if IsServer() then   
		local parent = self:GetParent()
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION  then return end

		--触发受到伤害
		if keys.unit==parent 	and not parent:IsIllusion()  then 
			local ability =  self:GetAbility()
			if not ability then
				return
			end
			local health = parent:GetHealth()
			if health<=0 then
				return
			end
			self.take_damage = self.take_damage +keys.damage
			local parent_health = parent:GetMaxHealth()*0.1

			if self.take_damage>=parent_health then
				local stack = self.take_damage / parent_health
				stack = stack-stack%1
				self.take_damage =self.take_damage -parent_health * stack
				self:SetStackCount(math.min(self:GetStackCount()+stack,self.max_stack))
			end

			
			if keys.damage>=50 and not parent:HasModifier("modifier_Advanced_Eldwurm_soul_Uldorak_buff") and self.time_chance>=RandomInt(1, 100) then
				
				local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_slow_jewel.vpcf", PATTACH_WORLDORIGIN, parent)
				local pos = parent:GetAbsOrigin()
				ParticleManager:SetParticleControl(particle, 0, pos)
				ParticleManager:SetParticleControl(particle, 1, Vector(300, 0, 0))
				ParticleManager:ReleaseParticleIndex(particle)
				parent:AddNewModifier(self:GetCaster(),ability, "modifier_Advanced_Eldwurm_soul_Uldorak_buff", {duration = 5,health=health*0.7})
			end

        end 




    end 
end

function modifier_Advanced_Eldwurm_soul_Uldorak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

modifier_Advanced_Eldwurm_soul_Uldorak_buff = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Uldorak_buff:IsDebuff()				return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_buff:IsHidden() 			return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_buff:IsPurgable() 			return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_buff:IsPurgeException() 	return false end
-- function modifier_Advanced_Eldwurm_soul_Uldorak_buff:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf" end
-- function modifier_Advanced_Eldwurm_soul_Uldorak_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Eldwurm_soul_Uldorak_buff:OnCreated(keys)
	self.bonus_armor = 0
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		self.bonus_armor = self:GetParent():GetPhysicalArmorValue(false)*0.5
	end
	if IsServer() then
		self:SetStackCount(keys.health)
		EmitSoundOn("Hero_FacelessVoid.TimeDilation.Target", self:GetParent())
	end
end

function modifier_Advanced_Eldwurm_soul_Uldorak_buff:DeclareFunctions()
	return { 
		MODIFIER_PROPERTY_MIN_HEALTH,
}
end



function modifier_Advanced_Eldwurm_soul_Uldorak_buff:Advanced_GetModifierPhysicalArmorBonus()	return self.bonus_armor end



function modifier_Advanced_Eldwurm_soul_Uldorak_buff:GetMinHealth() return self:GetStackCount() end


function modifier_Advanced_Eldwurm_soul_Uldorak_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


modifier_Advanced_Eldwurm_soul_Uldorak_unlock1 = class({})

function modifier_Advanced_Eldwurm_soul_Uldorak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock1:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock1:OnCreated()
	local ability = self:GetAbility()
	-- local stack = ability:GetStack()
	-- if stack>=40 then
	-- 	self.no = true
	-- 	return
	-- end
	ability:AddStack()
end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end



modifier_Advanced_Eldwurm_soul_Uldorak_unlock2 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:IsPurgable() 		    return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:RemoveOnDeath() return false end




-- advanced_modifier
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock2:Advanced_GetModifier_SummonTime_Intensity(keys)
	return 40
end















modifier_Advanced_Eldwurm_soul_Uldorak_unlock3 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:IsPurgeException() return false end

function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:CheckState()
	if IsClient() then
		return
	end
	local state = {	[MODIFIER_STATE_ROOTED] = true,}
	return state
end


function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:Advanced_GetModifierPhysicalArmorBonus()	return 120 end
function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:GetModifierMagicalResistanceBonus()	return 60 end


function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance,
    }
end

function modifier_Advanced_Eldwurm_soul_Uldorak_unlock3:Advanced_GetModifier_StatusResistance(keys)
	return 60
end
