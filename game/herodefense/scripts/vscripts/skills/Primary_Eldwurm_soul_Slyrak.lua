
Primary_Eldwurm_soul_Slyrak = class({})


LinkLuaModifier("modifier_Primary_Eldwurm_soul_Slyrak", "skills/Primary_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Eldwurm_soul_Slyrak_effect", "skills/Primary_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
-- require('internal/timers')   --计时器功能

function Primary_Eldwurm_soul_Slyrak:GetIntrinsicModifierName() return "modifier_Primary_Eldwurm_soul_Slyrak" end
function Primary_Eldwurm_soul_Slyrak:IsHiddenWhenStolen() 		return false end
function Primary_Eldwurm_soul_Slyrak:IsRefreshable() 			return true  end

function Primary_Eldwurm_soul_Slyrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/elder_dragon_form/unlock2/effect/fire/monkey_king_spring_fire_base.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", context )
end


modifier_Primary_Eldwurm_soul_Slyrak= class({})

function modifier_Primary_Eldwurm_soul_Slyrak:IsDebuff()			return false end
function modifier_Primary_Eldwurm_soul_Slyrak:IsHidden() 			return true end
function modifier_Primary_Eldwurm_soul_Slyrak:IsPurgable() 		return false end
function modifier_Primary_Eldwurm_soul_Slyrak:IsPurgeException() 	return false end


function modifier_Primary_Eldwurm_soul_Slyrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		-- local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Primary_Eldwurm_soul_Slyrak_effect", {})


			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/elder_dragon_form/unlock2/effect/fire/monkey_king_spring_fire_base.vpcf", PATTACH_WORLDORIGIN , unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			-- ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(50,0,0))
			-- ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
			Timers:CreateTimer(0.5, function()
				ParticleManager:DestroyParticle(particle_cast_fx, false)
				ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			end)

			unit:EmitSound("Hero_DragonKnight.ElderDragonForm")
		-- end
	end
end












modifier_Primary_Eldwurm_soul_Slyrak_effect = advanced_modifier({})

function modifier_Primary_Eldwurm_soul_Slyrak_effect:IsDebuff() return false end
function modifier_Primary_Eldwurm_soul_Slyrak_effect:IsHidden() return false end
function modifier_Primary_Eldwurm_soul_Slyrak_effect:IsPurgable() return false end
function modifier_Primary_Eldwurm_soul_Slyrak_effect:IsPurgeException() return false end
-- function modifier_Primary_Eldwurm_soul_Slyrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Primary_Eldwurm_soul_Slyrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_health_threshold = ability:GetSpecialValueFor("bonus_health_threshold")
	self.bonus_attack_damage = ability:GetSpecialValueFor("bonus_attack_damage")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.armor_reduce = ability:GetSpecialValueFor("armor_reduce")
	if IsServer() then
		
		self:StartIntervalThink(0.1)
	end
end

function modifier_Primary_Eldwurm_soul_Slyrak_effect:OnIntervalThink()
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end

	else
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex,false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	end
end



function modifier_Primary_Eldwurm_soul_Slyrak_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_TOOLTIP,
	}
end




function modifier_Primary_Eldwurm_soul_Slyrak_effect:GetModifierPreAttack_BonusDamage()	
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		return self.bonus_attack_damage
	end
	return 0
end

function modifier_Primary_Eldwurm_soul_Slyrak_effect:Advanced_GetModifierPhysicalArmorBonus()	
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		return -self.armor_reduce
	end
	return 0
end

function modifier_Primary_Eldwurm_soul_Slyrak_effect:OnTooltip()
	if self:GetParent():GetHealthPercent()>self.bonus_health_threshold then
		return 0
	end
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()	
	elseif self._tooltip == 2 then
		return self.armor_reduce
	end
end
function modifier_Primary_Eldwurm_soul_Slyrak_effect:Advanced_GetModifierAttackSpeedPercentage()	
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		return self.bonus_attack_speed
	end
	return 0
end



function modifier_Primary_Eldwurm_soul_Slyrak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end
