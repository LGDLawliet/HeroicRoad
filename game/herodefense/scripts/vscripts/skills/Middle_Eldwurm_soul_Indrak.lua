
Middle_Eldwurm_soul_Indrak = class({})


LinkLuaModifier("modifier_Middle_Eldwurm_soul_Indrak", "skills/Middle_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Eldwurm_soul_Indrak_effect", "skills/Middle_Eldwurm_soul_Indrak", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Middle_Eldwurm_soul_Indrak:GetIntrinsicModifierName() return "modifier_Middle_Eldwurm_soul_Indrak" end
function Middle_Eldwurm_soul_Indrak:IsHiddenWhenStolen() 		return false end
function Middle_Eldwurm_soul_Indrak:IsRefreshable() 			return true  end

function Middle_Eldwurm_soul_Indrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", context )
end


modifier_Middle_Eldwurm_soul_Indrak= class({})

function modifier_Middle_Eldwurm_soul_Indrak:IsDebuff()			return false end
function modifier_Middle_Eldwurm_soul_Indrak:IsHidden() 			return true end
function modifier_Middle_Eldwurm_soul_Indrak:IsPurgable() 		return false end
function modifier_Middle_Eldwurm_soul_Indrak:IsPurgeException() 	return false end
function modifier_Middle_Eldwurm_soul_Indrak:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.bonus_speed = 0
		self.current_unit = "aaa"
	end
end

function modifier_Middle_Eldwurm_soul_Indrak:OnSummonUnit(keys)
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

		if GameRules:GetGameTime()>=self.timer then
			if unit:GetUnitName()==self.current_unit then
				self.timer = GameRules:GetGameTime() +0.03
				self.bonus_speed = math.min(self.bonus_speed + 5,50)
			else
				self.current_unit = unit:GetUnitName()
				self.timer = GameRules:GetGameTime() +0.03
				self.bonus_speed = math.max(self.bonus_speed-20,0)
			end
		end

		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Eldwurm_soul_Indrak_effect", {stack = self.bonus_speed})
	end
end















modifier_Middle_Eldwurm_soul_Indrak_effect = advanced_modifier({})

function modifier_Middle_Eldwurm_soul_Indrak_effect:IsDebuff() return false end
function modifier_Middle_Eldwurm_soul_Indrak_effect:IsHidden() return false end
function modifier_Middle_Eldwurm_soul_Indrak_effect:IsPurgable() return false end
function modifier_Middle_Eldwurm_soul_Indrak_effect:IsPurgeException() return false end
-- function modifier_Middle_Eldwurm_soul_Indrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Middle_Eldwurm_soul_Indrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus = ability:GetSpecialValueFor("bonus_attack_speed")

	if IsServer() then

		self:SetHasCustomTransmitterData( true )
		self.bonus_speed = keys.stack
		-- self:SetStackCount(keys.stack)
	end
end


function modifier_Middle_Eldwurm_soul_Indrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		

	}
end
function modifier_Middle_Eldwurm_soul_Indrak_effect:AddCustomTransmitterData( )
	return
	{
		bonus_speed = self.bonus_speed
	}
end

function modifier_Middle_Eldwurm_soul_Indrak_effect:HandleCustomTransmitterData( data )
	self.bonus_speed = data.bonus_speed
end


function modifier_Middle_Eldwurm_soul_Indrak_effect:GetModifierAttackSpeedBonus_Constant()	return self.bonus_speed or 0 end



function modifier_Middle_Eldwurm_soul_Indrak_effect:OnTooltip()
	return self:Advanced_GetModifierAttackSpeedPercentage()
end



function modifier_Middle_Eldwurm_soul_Indrak_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.bonus end

function modifier_Middle_Eldwurm_soul_Indrak_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end