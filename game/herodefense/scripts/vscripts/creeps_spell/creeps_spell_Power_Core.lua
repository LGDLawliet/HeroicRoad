------
---能来源
creeps_spell_Power_Core = class({})

LinkLuaModifier("modifier_creeps_spell_Power_Core_passive", "creeps_spell/creeps_spell_Power_Core", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Power_Core_effect", "creeps_spell/creeps_spell_Power_Core", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Power_Core_buff", "creeps_spell/creeps_spell_Power_Core", LUA_MODIFIER_MOTION_NONE)



function creeps_spell_Power_Core:GetIntrinsicModifierName() return "modifier_creeps_spell_Power_Core_passive" end

modifier_creeps_spell_Power_Core_passive = class({})

function modifier_creeps_spell_Power_Core_passive:IsHidden() return true end
function modifier_creeps_spell_Power_Core_passive:IsAura() return true end
function modifier_creeps_spell_Power_Core_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Power_Core_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Power_Core_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Power_Core_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Power_Core_passive:GetModifierAura() return "modifier_creeps_spell_Power_Core_effect" end
function modifier_creeps_spell_Power_Core_passive:GetAuraRadius() return _G.GAME_DIFFICULTY~=4 and 0 or 2700 end
function modifier_creeps_spell_Power_Core_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Power_Core_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Power_Core_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creeps_spell_Power_Core_passive:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_creeps_spell_Power_Core_passive:OnCreated(table)
    if IsServer() then
        if _G.GAME_DIFFICULTY~=4 then
            return
        end
        self:StartIntervalThink(0.5)
    end
end
function modifier_creeps_spell_Power_Core_passive:OnIntervalThink(table)
    if IsServer() then
        local caster = self:GetCaster()
        if not caster.element then
            return
        end
        for _, unit in ipairs(caster.element) do
            if IsValidEntity(unit) then

                local dis= GetDistanceBetweenTwoUnit(caster,unit)
                if dis>=2700 then
                    unit:AddNewModifier(unit, self:GetAbility(), "modifier_creeps_spell_Power_Core_buff", {duration =3})
                end
            end
        end
        
    end
end



modifier_creeps_spell_Power_Core_effect = advanced_modifier({})

function modifier_creeps_spell_Power_Core_effect:IsDebuff()			    return false end
function modifier_creeps_spell_Power_Core_effect:IsHidden() 			return false end
function modifier_creeps_spell_Power_Core_effect:IsPurgable() 		    return false end
function modifier_creeps_spell_Power_Core_effect:IsPurgeException() 	return false end

function modifier_creeps_spell_Power_Core_effect:DeclareFunctions() return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end

function modifier_creeps_spell_Power_Core_effect:GetModifierPercentageCooldown()
    return self:GetStackCount()/1000*10
end
function modifier_creeps_spell_Power_Core_effect:Advanced_GetModifierAttackSpeedPercentage() 
    return self:GetStackCount()/1000*20
end


function modifier_creeps_spell_Power_Core_effect:OnCreated()
    if not IsServer() then
        return
    end
    if _G.GAME_DIFFICULTY~=4 then
        return
    end
    self:StartIntervalThink(1)
end
function modifier_creeps_spell_Power_Core_effect:OnIntervalThink()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local dis= GetDistanceBetweenTwoUnit(caster,parent)
    local gain = -0.002*dis + 5.4
    if gain<0 then
        gain = 0
    end
    if gain>4 then
        gain = 4
    end
    gain = gain*1000
    gain = gain-gain%1
    self:SetStackCount(gain)

end

-- advanced_modifier

function modifier_creeps_spell_Power_Core_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
	return funcs
end

function modifier_creeps_spell_Power_Core_effect:AdvancedGetModifierConstantManaRegenAmpPercentage() 
    return  self:GetStackCount()/1000*25 
end








modifier_creeps_spell_Power_Core_buff = class({})

-----------------------------------------------------------------------------------------
function modifier_creeps_spell_Power_Core_buff:IsDebuff() return false end
function modifier_creeps_spell_Power_Core_buff:IsHidden() return false end
function modifier_creeps_spell_Power_Core_buff:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:StatusEffectPriority()
	return 60
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:OnCreated( kv )
	self.enrage_movespeed_bonus = 200
	self.enrage_attack_speed_bonus = 100
	self.enrage_model_scale_bonus = 0

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		EmitSoundOn( "Hero_LifeStealer.Rage", self:GetParent() )


	end
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:GetModifierMoveSpeedBonus_Constant( params )
	return self.enrage_movespeed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.enrage_attack_speed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:GetModifierModelScale( params )
	return self.enrage_model_scale_bonus
end

-----------------------------------------------------------------------------------------

function modifier_creeps_spell_Power_Core_buff:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end

-----------------------------------------------------------------------------------------
