-- 流水加速

LinkLuaModifier("modifier_chaotic_flowing_water_acceleration", "chaotic_spell/class_3/chaotic_flowing_water_acceleration", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_flowing_water_acceleration_buff", "chaotic_spell/class_3/chaotic_flowing_water_acceleration", LUA_MODIFIER_MOTION_NONE)

chaotic_flowing_water_acceleration = class({})
function chaotic_flowing_water_acceleration:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_flowing_water_acceleration/chaotic_flowing_water_acceleration.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_flowing_water_acceleration2/chaotic_flowing_water_acceleration2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_flowing_water_acceleration3/chaotic_flowing_water_acceleration3.vpcf", context )
end

function chaotic_flowing_water_acceleration:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_flowing_water_acceleration:OnSpellStart()

	local caster = self:GetCaster()

	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * gain

	caster:AddNewModifier(caster, self, "modifier_chaotic_flowing_water_acceleration", {duration = duration})
	
end


modifier_chaotic_flowing_water_acceleration = advanced_modifier({})

function modifier_chaotic_flowing_water_acceleration:IsHidden() return false end
function modifier_chaotic_flowing_water_acceleration:IsPurgable() return true end
function modifier_chaotic_flowing_water_acceleration:IsDebuff() return false end

function modifier_chaotic_flowing_water_acceleration:OnCreated()
	
	self.parent = self:GetParent()

	self.duration = self:GetAbility():GetSpecialValueFor("duration2")

	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")

	self.currentpos = 0

	if IsServer() then

		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_flowing_water_acceleration2/chaotic_flowing_water_acceleration3illlmove.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 1, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		DestroyParticleByDelay(nFXIndex,1)

		self.parent:EmitSound("Hero_EmberSpirit.SearingChains.Cast")

	end

	self:StartIntervalThink( 0.1 )

end

function modifier_chaotic_flowing_water_acceleration:OnRefresh()

	self.parent = self:GetParent()

	self.duration = self:GetAbility():GetSpecialValueFor("duration2")

	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")

	self.currentpos = 0

	if IsServer() then

		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_flowing_water_acceleration2/chaotic_flowing_water_acceleration3illlmove.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 1, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		DestroyParticleByDelay(nFXIndex,1)

		local nFXIndex_phantom = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_flowing_water_acceleration2/chaotic_flowing_water_acceleration2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt(nFXIndex_phantom, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		DestroyParticleByDelay(nFXIndex_phantom,1)

		self.parent:EmitSound("Hero_EmberSpirit.SearingChains.Cast")

	end

	self:StartIntervalThink( 0.1 )

end

function modifier_chaotic_flowing_water_acceleration:OnIntervalThink(keys)

	if not IsServer() then
		return
	end

	if not self.parent:IsAlive() then
		return
	end

	if not self.parent:HasModifier("modifier_chaotic_flowing_water_acceleration_buff") then
		return
	end

	local pos = self.parent:GetOrigin()

	if self.currentpos ~= pos then

		self:SetStackCount(self.attack_speed)
		ProjectileManager:ProjectileDodge(self:GetCaster())
		self.parent:EmitSound("Hero_EmberSpirit.FireRemnant.Create")

	end

end

function modifier_chaotic_flowing_water_acceleration:OnAttackStart(keys)
	if IsServer() then

		if not IsServer() then
			return 
		end

		if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
			return
		end

		self:SetStackCount(0)

		keys.attacker:AddNewModifier(keys.target, self:GetAbility(), "modifier_chaotic_flowing_water_acceleration_buff", {duration = self.duration})

		self.currentpos = self.parent:GetOrigin()

		self:SetStackCount(0)

	end
end

function modifier_chaotic_flowing_water_acceleration:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_chaotic_flowing_water_acceleration:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end

function modifier_chaotic_flowing_water_acceleration:Advanced_GetModifierAttackSpeedPercentage()	
	return self:GetStackCount()
end

modifier_chaotic_flowing_water_acceleration_buff = advanced_modifier({})

function modifier_chaotic_flowing_water_acceleration_buff:IsHidden() return true end
function modifier_chaotic_flowing_water_acceleration_buff:IsPurgable() return true end
function modifier_chaotic_flowing_water_acceleration_buff:IsDebuff() return false end
function modifier_chaotic_flowing_water_acceleration_buff:GetEffectName()
	return "particles/rebuild/spell/chaotic_flowing_water_acceleration2/chaotic_flowing_water_acceleration2.vpcf"
end

function modifier_chaotic_flowing_water_acceleration_buff:OnCreated()

	self.parent = self:GetParent()

	local increase = self:GetAbility():GetSpecialValueFor("increase") * 0.01

	if not self.parent:IsRangedAttacker() then

		self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed") * (1 + increase)
	else
		self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")
	end

	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_flowing_water_acceleration3/chaotic_flowing_water_acceleration3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(nFXIndex,  false, false, -1,  false, false)
	end

end

function modifier_chaotic_flowing_water_acceleration_buff:DeclareFunctions()   
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	} 
end

function modifier_chaotic_flowing_water_acceleration_buff:GetModifierMoveSpeedBonus_Percentage() 
    return self.move_speed
end


function modifier_chaotic_flowing_water_acceleration_buff:GetModifierIgnoreMovespeedLimit()             return   1  end
