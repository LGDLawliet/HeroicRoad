
Primary_Eldwurm_soul_Vahdrak = class({})


LinkLuaModifier("modifier_Primary_Eldwurm_soul_Vahdrak", "skills/Primary_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Eldwurm_soul_Vahdrak_effect", "skills/Primary_Eldwurm_soul_Vahdrak", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Primary_Eldwurm_soul_Vahdrak:GetIntrinsicModifierName() return "modifier_Primary_Eldwurm_soul_Vahdrak" end
function Primary_Eldwurm_soul_Vahdrak:IsHiddenWhenStolen() 		return false end
function Primary_Eldwurm_soul_Vahdrak:IsRefreshable() 			return true  end




modifier_Primary_Eldwurm_soul_Vahdrak= class({})

function modifier_Primary_Eldwurm_soul_Vahdrak:IsDebuff()			return false end
function modifier_Primary_Eldwurm_soul_Vahdrak:IsHidden() 			return true end
function modifier_Primary_Eldwurm_soul_Vahdrak:IsPurgable() 		return false end
function modifier_Primary_Eldwurm_soul_Vahdrak:IsPurgeException() 	return false end


function modifier_Primary_Eldwurm_soul_Vahdrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Primary_Eldwurm_soul_Vahdrak_effect", {stack=stack})

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













modifier_Primary_Eldwurm_soul_Vahdrak_effect = class({})

function modifier_Primary_Eldwurm_soul_Vahdrak_effect:IsDebuff() return false end
function modifier_Primary_Eldwurm_soul_Vahdrak_effect:IsHidden() return false end
function modifier_Primary_Eldwurm_soul_Vahdrak_effect:IsPurgable() return false end
function modifier_Primary_Eldwurm_soul_Vahdrak_effect:IsPurgeException() return false end
-- function modifier_Primary_Eldwurm_soul_Vahdrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Primary_Eldwurm_soul_Vahdrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end


function modifier_Primary_Eldwurm_soul_Vahdrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		
		

	}
end


function modifier_Primary_Eldwurm_soul_Vahdrak_effect:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount() end
