
Middle_Eldwurm_soul_Uldorak = class({})


LinkLuaModifier("modifier_Middle_Eldwurm_soul_Uldorak", "skills/Middle_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Uldorak_effect", "skills/Middle_Eldwurm_soul_Uldorak", LUA_MODIFIER_MOTION_NONE)
-- require('internal/timers')   --计时器功能

function Middle_Eldwurm_soul_Uldorak:GetIntrinsicModifierName() return "modifier_Middle_Eldwurm_soul_Uldorak" end
function Middle_Eldwurm_soul_Uldorak:IsHiddenWhenStolen() 		return false end
function Middle_Eldwurm_soul_Uldorak:IsRefreshable() 			return true  end




modifier_Middle_Eldwurm_soul_Uldorak= class({})

function modifier_Middle_Eldwurm_soul_Uldorak:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Uldorak:IsHidden() 			return true end
function modifier_Middle_Eldwurm_soul_Uldorak:IsPurgable() 		return false end
function modifier_Middle_Eldwurm_soul_Uldorak:IsPurgeException() 	return false end


function modifier_Middle_Eldwurm_soul_Uldorak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()

		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Eldwurm_soul_Uldorak_effect", {})


			local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/earthspirit_petrify_shockwave.vpcf", PATTACH_WORLDORIGIN , unit)
			local pos = unit:GetAbsOrigin()
			-- ParticleManager:SetParticleControl(particle_cast_fx, 1, self:GetCaster():GetAbsOrigin())
			-- ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			ParticleManager:SetParticleControl(particle_cast_fx, 3, Vector(200,0,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)


			unit:EmitSound("Hero_EarthSpirit.StoneRemnant.Destroy")
		-- end
	end
end













modifier_Middle_Eldwurm_soul_Uldorak_effect = advanced_modifier({})

function modifier_Middle_Eldwurm_soul_Uldorak_effect:IsDebuff() return false end
function modifier_Middle_Eldwurm_soul_Uldorak_effect:IsHidden() return false end
function modifier_Middle_Eldwurm_soul_Uldorak_effect:IsPurgable() return false end
function modifier_Middle_Eldwurm_soul_Uldorak_effect:IsPurgeException() return false end
-- function modifier_Middle_Eldwurm_soul_Uldorak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Middle_Eldwurm_soul_Uldorak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
	self.bonus_magic_res = ability:GetSpecialValueFor("bonus_magic_res")
	if IsServer() then
		self.take_damage = 0
	end
end


function modifier_Middle_Eldwurm_soul_Uldorak_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_EVENT_ON_TAKEDAMAGE

	}
end


function modifier_Middle_Eldwurm_soul_Uldorak_effect:Advanced_GetModifierPhysicalArmorBonus()	return self.bonus_armor+self:GetStackCount() end
function modifier_Middle_Eldwurm_soul_Uldorak_effect:GetModifierMagicalResistanceBonus()	return self.bonus_magic_res+self:GetStackCount()*0.5 end



function modifier_Middle_Eldwurm_soul_Uldorak_effect:OnTakeDamage(keys)
    if IsServer() then   
		local parent = self:GetParent()
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION  then return end

		--触发受到伤害
		if keys.unit==parent 	and not parent:IsIllusion()  then 
			self.take_damage = self.take_damage +keys.damage
			local parent_health = parent:GetMaxHealth()*0.1

			if self.take_damage>=parent_health then
				local stack = self.take_damage / parent_health
				stack = stack-stack%1
				self.take_damage =self.take_damage -parent_health * stack
				self:SetStackCount(math.min(self:GetStackCount()+stack,20))
			end

			

        end 




    end 
end


function modifier_Middle_Eldwurm_soul_Uldorak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end