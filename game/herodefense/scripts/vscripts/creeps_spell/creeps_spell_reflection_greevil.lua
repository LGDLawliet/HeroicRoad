creeps_spell_reflection_greevil = class({})
require("internal/timers")
LinkLuaModifier("modifier_creeps_spell_reflection_greevil", "creeps_spell/creeps_spell_reflection_greevil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_reflection_greevil_illusion", "creeps_spell/creeps_spell_reflection_greevil", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creeps_spell_reflection_greevil_illusion_vision", "creeps_spell/creeps_spell_reflection_greevil", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_reflection_greevil:IsHiddenWhenStolen() 		return false end
function creeps_spell_reflection_greevil:IsRefreshable() 			return true end
function creeps_spell_reflection_greevil:IsStealable() 				return true end
function creeps_spell_reflection_greevil:IsNetherWardStealable()		return true end
function creeps_spell_reflection_greevil:GetIntrinsicModifierName() return "modifier_creeps_spell_reflection_greevil" end

function creeps_spell_reflection_greevil:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_illusion_destroy.vpcf", context )
end

modifier_creeps_spell_reflection_greevil = class({})

function modifier_creeps_spell_reflection_greevil:IsDebuff()			return false end
function modifier_creeps_spell_reflection_greevil:IsHidden() 			return false end
function modifier_creeps_spell_reflection_greevil:IsPurgable() 		    return false end
function modifier_creeps_spell_reflection_greevil:IsPurgeException() 	return false end
function modifier_creeps_spell_reflection_greevil:RemoveOnDeath()       return false end

function modifier_creeps_spell_reflection_greevil:OnCreated(keys)
    if IsServer() then
      
        Timers:CreateTimer(0.5, function()
			if not self or self:IsNull() then
				return
			end
            local caster = self:GetCaster()
            if not caster or caster:IsNull() or not caster:IsAlive() then
                return
            end
            if caster:HasModifier("modifier_creeps_spell_reflection_greevil_illusion") then
                return
            end
            local unit = caster:SummonUnit(caster:GetUnitName(),-1,
            caster:GetAbsOrigin(),
            caster:GetForwardVector(),self:GetAbility(),0,caster:GetMaxHealth()*0.1,nil,caster:GetDamageMax(),0,1,1)

            unit:AddNewModifier(
                self:GetCaster(), -- player source
                self:GetAbility(), -- ability source
                "modifier_creeps_spell_reflection_greevil_illusion", -- modifier name
                { duration = -1 } -- kv
            )
        end)

       

    end
end




modifier_creeps_spell_reflection_greevil_illusion = advanced_modifier({})

function modifier_creeps_spell_reflection_greevil_illusion:IsDebuff()			return false end
function modifier_creeps_spell_reflection_greevil_illusion:IsHidden() 			return true end
function modifier_creeps_spell_reflection_greevil_illusion:IsPurgable() 		return false end
function modifier_creeps_spell_reflection_greevil_illusion:IsPurgeException() 	return false end
-- function modifier_creeps_spell_reflection_greevil_illusion:GetEffectName() return "particles/status_fx/status_effect_terrorblade_reflection.vpcf" end
function modifier_creeps_spell_reflection_greevil_illusion:GetStatusEffectName()return "particles/status_fx/status_effect_terrorblade_reflection.vpcf" end
function modifier_creeps_spell_reflection_greevil_illusion:StatusEffectPriority() return 10000 end

function modifier_creeps_spell_reflection_greevil_illusion:CheckState() return 
	{
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
    [MODIFIER_STATE_INVISIBLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
} 
end

function modifier_creeps_spell_reflection_greevil_illusion:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,

} end
function modifier_creeps_spell_reflection_greevil_illusion:GetModifierMoveSpeedBonus_Percentage() return 200 end
function modifier_creeps_spell_reflection_greevil_illusion:GetModifierIgnoreMovespeedLimit() return 1 end
-- function modifier_creeps_spell_reflection_greevil_illusion:GetModifierTotalDamageOutgoing_Percentage() return 100 end

function modifier_creeps_spell_reflection_greevil_illusion:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(3)

	end
end

function modifier_creeps_spell_reflection_greevil_illusion:GetModifierInvisibilityLevel()return 1 end
function modifier_creeps_spell_reflection_greevil_illusion:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
    local caster = self:GetAbility():GetCaster()  --技能的拥有者
	if not ability or ability:IsNull() or not caster:IsAlive() then
		-- local parent = self:GetParent()
		self:SafeDestroy()
		-- parent:ForceKill(false)
		
		return
	end

	local caster_pos = caster:GetAbsOrigin()      --幻象跟随者位置
	local self_pos = self:GetParent():GetAbsOrigin()--幻象位置
	local distance = (caster_pos - self_pos):Length2D()
	--距离太远就走进跟随者
	if distance >1200 then 
		self:GetParent():SetForceAttackTarget(nil) 
		self:GetParent():MoveToPosition(caster_pos)
		return
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(),caster_pos, nil, 1000,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end
function modifier_creeps_spell_reflection_greevil_illusion:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return 0
	end
    local target = keys.target
    local attacker = keys.attacker
    if attacker:CanEntityBeSeenByMyTeam(target) then

        return 0
    end
    return -100


end

function modifier_creeps_spell_reflection_greevil_illusion:OnDestroy()
    if IsServer() then
        local ability = self:GetAbility()
        self:GetCaster():RemoveAbilityByHandle(ability)
        local particle = ParticleManager:CreateParticle( "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_illusion_destroy.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        UTIL_Remove(self:GetParent())
    end
end

function modifier_creeps_spell_reflection_greevil_illusion:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_creeps_spell_reflection_greevil_illusion:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return 100
end






-- modifier_creeps_spell_reflection_greevil_illusion_vision = class({})

-- function modifier_creeps_spell_reflection_greevil_illusion_vision:IsDebuff()			return false end
-- function modifier_creeps_spell_reflection_greevil_illusion_vision:IsHidden() 			return true end
-- function modifier_creeps_spell_reflection_greevil_illusion_vision:IsPurgable() 		return false end
-- function modifier_creeps_spell_reflection_greevil_illusion_vision:IsPurgeException() 	return false end
-- function modifier_creeps_spell_reflection_greevil_illusion_vision:CheckState() return 
-- 	{
--     [MODIFIER_STATE_PROVIDES_VISION ] = true,

-- 	}
-- end
