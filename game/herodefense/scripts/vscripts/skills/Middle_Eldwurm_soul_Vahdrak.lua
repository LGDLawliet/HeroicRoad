
Middle_Eldwurm_soul_Vahdrak = class({})


LinkLuaModifier("modifier_Middle_Eldwurm_soul_Vahdrak", "skills/Middle_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Vahdrak_effect", "skills/Middle_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Middle_Eldwurm_soul_Vahdrak:GetIntrinsicModifierName() return "modifier_Middle_Eldwurm_soul_Vahdrak" end
function Middle_Eldwurm_soul_Vahdrak:IsHiddenWhenStolen() 		return false end
function Middle_Eldwurm_soul_Vahdrak:IsRefreshable() 			return true  end




modifier_Middle_Eldwurm_soul_Vahdrak= class({})

function modifier_Middle_Eldwurm_soul_Vahdrak:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Vahdrak:IsHidden() 			return true end
function modifier_Middle_Eldwurm_soul_Vahdrak:IsPurgable() 		return false end
function modifier_Middle_Eldwurm_soul_Vahdrak:IsPurgeException() 	return false end


function modifier_Middle_Eldwurm_soul_Vahdrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Eldwurm_soul_Vahdrak_effect", {stack=stack})

	
			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", PATTACH_WORLDORIGIN , unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 1, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
			-- ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
			Timers:CreateTimer(0.5, function()
				ParticleManager:DestroyParticle(particle_cast_fx, false)
				ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			end)

			unit:EmitSound("Hero_ChaosKnight.RealityRift")
		-- end
	end
end









modifier_Middle_Eldwurm_soul_Vahdrak_effect = advanced_modifier({})

function modifier_Middle_Eldwurm_soul_Vahdrak_effect:IsDebuff() return false end
function modifier_Middle_Eldwurm_soul_Vahdrak_effect:IsHidden() return false end
function modifier_Middle_Eldwurm_soul_Vahdrak_effect:IsPurgable() return false end
function modifier_Middle_Eldwurm_soul_Vahdrak_effect:IsPurgeException() return false end
function modifier_Middle_Eldwurm_soul_Vahdrak_effect:DestroyOnExpire()	return false end
-- function modifier_Middle_Eldwurm_soul_Vahdrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Middle_Eldwurm_soul_Vahdrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.crit = {}
	if IsServer() then
		self:SetStackCount(keys.stack)

	end
end


function modifier_Middle_Eldwurm_soul_Vahdrak_effect:OnDestroy() self.crit = nil end


function modifier_Middle_Eldwurm_soul_Vahdrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_EVENT_ON_ATTACK_FAIL
		

	}
end


function modifier_Middle_Eldwurm_soul_Vahdrak_effect:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount() end



function modifier_Middle_Eldwurm_soul_Vahdrak_effect:Advanced_GetModifierCriticalStrike(keys)



   if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther()
	and not self:GetParent():PassivesDisabled() then

	   if self:GetRemainingTime()<=0 then
		if not self or self:IsNull() then
			return 0
		end

		   self.crit[keys.record] = true
		   self:SetDuration(3, true)
		   local damage_mul =  RandomInt(120, 220)
		   return damage_mul 
		else
		   return 0
	   end
   end
end

function modifier_Middle_Eldwurm_soul_Vahdrak_effect:OnAttackFail(keys) self.crit[keys.record] = nil end


function modifier_Middle_Eldwurm_soul_Vahdrak_effect:OnAttackLanded(keys)
   if not IsServer() then
	   return
   end

   if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
	   return
   end
   local caster = self:GetParent()
   if not self.crit then
	   return
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
	  



   end
   self.crit[keys.record] = nil
end

-- advanced_modifier
function modifier_Middle_Eldwurm_soul_Vahdrak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end