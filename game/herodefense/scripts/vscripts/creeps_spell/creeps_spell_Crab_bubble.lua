creeps_spell_Crab_bubble = class({})
require("internal/timers")
LinkLuaModifier("modifier_creeps_spell_Crab_bubble", "creeps_spell/creeps_spell_Crab_bubble", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Crab_bubble_effect", "creeps_spell/creeps_spell_Crab_bubble", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Crab_bubble:IsHiddenWhenStolen() 		return false end
function creeps_spell_Crab_bubble:IsRefreshable() 			return true end
function creeps_spell_Crab_bubble:IsStealable() 				return true end
function creeps_spell_Crab_bubble:IsNetherWardStealable()		return true end
function creeps_spell_Crab_bubble:GetIntrinsicModifierName() return "modifier_creeps_spell_Crab_bubble" end

function creeps_spell_Crab_bubble:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/void_spirit_exitportal_bubbles.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/crab_bubble/crab_bubble.vpcf", context )

	
end

modifier_creeps_spell_Crab_bubble = class({})

function modifier_creeps_spell_Crab_bubble:IsDebuff()			return false end
function modifier_creeps_spell_Crab_bubble:IsHidden() 			return true end
function modifier_creeps_spell_Crab_bubble:IsPurgable() 		    return false end
function modifier_creeps_spell_Crab_bubble:IsPurgeException() 	return false end
function modifier_creeps_spell_Crab_bubble:RemoveOnDeath()       return false end
function modifier_creeps_spell_Crab_bubble:GetEffectName() return "particles/units/heroes/hero_void_spirit/void_spirit_exitportal_bubbles.vpcf" end
function modifier_creeps_spell_Crab_bubble:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creeps_spell_Crab_bubble:OnCreated(keys)
    if IsServer() then
      
       self:StartIntervalThink(1)

       

    end
end

function modifier_creeps_spell_Crab_bubble:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in ipairs(units) do
		unit:AddNewModifier(unit, ability, "modifier_creeps_spell_Crab_bubble_effect", {duration=1.5})

	end
end


modifier_creeps_spell_Crab_bubble_effect = class({})

function modifier_creeps_spell_Crab_bubble_effect:IsDebuff()			return true end
function modifier_creeps_spell_Crab_bubble_effect:IsHidden() 			return false end
function modifier_creeps_spell_Crab_bubble_effect:IsPurgable() 		return false end
function modifier_creeps_spell_Crab_bubble_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_Crab_bubble_effect:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

} end
function modifier_creeps_spell_Crab_bubble_effect:GetModifierMoveSpeedBonus_Percentage() return self.slow+self.bonus_slow*self:GetStackCount() end

function modifier_creeps_spell_Crab_bubble_effect:OnCreated(keys)
	self.slow = -self:GetAbility():GetSpecialValueFor("slow")
	self.bonus_slow = -self:GetAbility():GetSpecialValueFor("slow_bonus")
	if IsServer() then
		self:SetStackCount(1)

		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/creeps_spell/crab_bubble/crab_bubble.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetStackCount()*5,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

	end
end
function modifier_creeps_spell_Crab_bubble_effect:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
		local duration = math.min(math.max(self:GetStackCount()/10,1.5),5)
		self:SetDuration(duration, true)
		ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(self:GetStackCount()*5,0,0) )

	end
end



function modifier_creeps_spell_Crab_bubble_effect:OnDestroy()
    if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex,false)
        ParticleManager:ReleaseParticleIndex( self.nFXIndex)
        -- UTIL_Remove(self:GetParent())
    end
end