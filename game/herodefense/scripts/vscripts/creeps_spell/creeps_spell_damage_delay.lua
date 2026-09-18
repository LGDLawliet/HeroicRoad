creeps_spell_damage_delay = class({})
LinkLuaModifier("modifier_creeps_spell_damage_delay_damage_count", "creeps_spell/creeps_spell_damage_delay", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_damage_delay:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/damage_delay/blood_effect.vpcf", context )
end

function creeps_spell_damage_delay:IsHiddenWhenStolen() 		return false end
function creeps_spell_damage_delay:IsRefreshable() 			return true end
function creeps_spell_damage_delay:IsStealable() 				return true end
function creeps_spell_damage_delay:IsNetherWardStealable()		return true end
function creeps_spell_damage_delay:GetIntrinsicModifierName() return "modifier_creeps_spell_damage_delay_damage_count" end

modifier_creeps_spell_damage_delay_damage_count = advanced_modifier({})
function modifier_creeps_spell_damage_delay_damage_count:IsHidden() return false end
function modifier_creeps_spell_damage_delay_damage_count:IsDebuff() return false end
function modifier_creeps_spell_damage_delay_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_damage_delay_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_damage_delay_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_damage_delay_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_damage_delay_damage_count:AllowIllusionDuplicate() return false end





function modifier_creeps_spell_damage_delay_damage_count:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end


function modifier_creeps_spell_damage_delay_damage_count:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if not IsServer() then
		return 0
	end
    if keys.block_disabled then
        return 0 
    end

	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return 0
    end
    if keys.damage<=0 then
        return 0
    end
	self:SetStackCount(self:GetStackCount()+keys.damage)
	self.last_hit_unit = keys.attacker
	return keys.damage


end







function modifier_creeps_spell_damage_delay_damage_count:OnCreated(keys)
    if IsServer() then
		self.last_hit_unit = self:GetParent()
        self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/creeps_spell/damage_delay/blood_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(math.min(self:GetStackCount(),1500),0,0))
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(1)
    end
end

function modifier_creeps_spell_damage_delay_damage_count:OnIntervalThink()
	local stack =  self:GetStackCount()
	if stack<=50 then
		self:SetStackCount(0)
		return
	end
	if not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	
		return
	end
	if self.nFXIndex then
		ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(math.min(stack,1500),0,0))

	end
	local damage = stack*0.1
	self:SetStackCount(stack-damage)

	local damage_table = {
		victim			= self:GetParent(),
		damage			= damage,
		damage_type		= DAMAGE_TYPE_PURE,
		damage_flags	= DOTA_DAMAGE_FLAG_HPLOSS +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL +DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS+DOTA_DAMAGE_FLAG_REFLECTION   ,
		attacker		= self.last_hit_unit,
		ability			= self:GetAbility()
	}
	ApplyDamage(damage_table)

end

