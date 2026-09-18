creeps_spell_troll_roar = class({})


LinkLuaModifier("modifier_creeps_spell_troll_roar", "creeps_spell/creeps_spell_troll_roar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_troll_roar_trigger", "creeps_spell/creeps_spell_troll_roar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_troll_roar_trigger_effect", "creeps_spell/creeps_spell_troll_roar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_troll_roar_buff", "creeps_spell/creeps_spell_troll_roar", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_troll_roar:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/troll_roar/roar_wave.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/ursa/ursa_ti10/ursa_ti10_enrage_head.vpcf", context )
    PrecacheResource( "particle", "particles/status_fx/status_effect_life_stealer_rage.vpcf", context )
end
function creeps_spell_troll_roar:IsHiddenWhenStolen() 		return false end
function creeps_spell_troll_roar:IsRefreshable() 			return true end
function creeps_spell_troll_roar:IsStealable() 				return true end
function creeps_spell_troll_roar:IsNetherWardStealable()		return true end
function creeps_spell_troll_roar:GetIntrinsicModifierName() return "modifier_creeps_spell_troll_roar" end


modifier_creeps_spell_troll_roar = class({})

function modifier_creeps_spell_troll_roar:IsDebuff()			return false end
function modifier_creeps_spell_troll_roar:IsHidden() 			return true end
function modifier_creeps_spell_troll_roar:IsPurgable() 		    return false end
function modifier_creeps_spell_troll_roar:IsPurgeException() 	return false end
function modifier_creeps_spell_troll_roar:RemoveOnDeath()       return false end

function modifier_creeps_spell_troll_roar:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,} 
end

function modifier_creeps_spell_troll_roar:OnDeath(keys)
    if not IsServer() then
        return
    end
    local unit = keys.unit
    local parent =  self:GetParent()
    if unit:GetUnitName() == parent:GetUnitName() and unit:GetTeamNumber()==parent:GetTeamNumber() and unit~=parent then
        if CalculateDistance(unit,parent)<=1000 then
            local ModifierStatusGain = parent:GetModifierDurationGainIndex(1)
            parent:AddNewModifier(parent,self:GetAbility(),"modifier_creeps_spell_troll_roar_trigger",{	duration = 2.3})
            parent:AddNewModifier(parent,self:GetAbility(),"modifier_creeps_spell_troll_roar_buff",{	duration = 12.3*ModifierStatusGain})
        end

    end
end


modifier_creeps_spell_troll_roar_trigger = class({})

function modifier_creeps_spell_troll_roar_trigger:IsHidden()	return true end
function modifier_creeps_spell_troll_roar_trigger:IsDebuff()	return false end
function modifier_creeps_spell_troll_roar_trigger:IsPurgable()	return false end
function modifier_creeps_spell_troll_roar_trigger:IsPurgeException() return false end
function modifier_creeps_spell_troll_roar_trigger:RemoveOnDeath() return false end
function modifier_creeps_spell_troll_roar_trigger:IsAura()
	return true
end
function modifier_creeps_spell_troll_roar_trigger:GetModifierAura()	return "modifier_creeps_spell_troll_roar_trigger_effect" end
function modifier_creeps_spell_troll_roar_trigger:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_creeps_spell_troll_roar_trigger:GetAuraDuration()return self:GetAbility():GetSpecialValueFor("duration")  end
function modifier_creeps_spell_troll_roar_trigger:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creeps_spell_troll_roar_trigger:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_creeps_spell_troll_roar_trigger:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_creeps_spell_troll_roar_trigger:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return funcs
end

function modifier_creeps_spell_troll_roar_trigger:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end
function modifier_creeps_spell_troll_roar_trigger:GetOverrideAnimationRate()
	return 1
end

function modifier_creeps_spell_troll_roar_trigger:CheckState()
    return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_creeps_spell_troll_roar_trigger:OnCreated(keys)
    if IsServer() then
        self:StartIntervalThink(0.6)
    end
end


function modifier_creeps_spell_troll_roar_trigger:OnIntervalThink()
	local pfx = ParticleManager:CreateParticle("particles/rebuild/creeps_spell/troll_roar/roar_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(3000,1,1))
	ParticleManager:ReleaseParticleIndex(pfx)
end


modifier_creeps_spell_troll_roar_trigger_effect = advanced_modifier({})
function modifier_creeps_spell_troll_roar_trigger_effect:IsHidden()	return false end
function modifier_creeps_spell_troll_roar_trigger_effect:IsDebuff()	return true end
function modifier_creeps_spell_troll_roar_trigger_effect:IsPurgable()	return false end
function modifier_creeps_spell_troll_roar_trigger_effect:IsPurgeException() return false end
function modifier_creeps_spell_troll_roar_trigger_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creeps_spell_troll_roar_trigger_effect:OnCreated()

    self.armor_reduce = -self:GetAbility():GetSpecialValueFor("armor_reduce")
end

function modifier_creeps_spell_troll_roar_trigger_effect:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_creeps_spell_troll_roar_trigger_effect:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_creeps_spell_troll_roar_trigger_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_creeps_spell_troll_roar_trigger_effect:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor_reduce 
end



modifier_creeps_spell_troll_roar_buff = class({})
function modifier_creeps_spell_troll_roar_buff:IsHidden()	return false end
function modifier_creeps_spell_troll_roar_buff:IsDebuff()	return false end
function modifier_creeps_spell_troll_roar_buff:IsPurgable()	return false end
function modifier_creeps_spell_troll_roar_buff:IsPurgeException() return false end
function modifier_creeps_spell_troll_roar_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_troll_roar_buff:GetStatusEffectName() return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end

function modifier_creeps_spell_troll_roar_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比    
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, 
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

	return funcs
end
function modifier_creeps_spell_troll_roar_buff:OnCreated()
    self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
    self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    if IsServer() then
       
        self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_ti10/ursa_ti10_enrage_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
    end
end

function modifier_creeps_spell_troll_roar_buff:OnDestroy()
    if IsServer() then
        if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
    end
end
function modifier_creeps_spell_troll_roar_buff:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack end
function modifier_creeps_spell_troll_roar_buff:GetModifierMoveSpeedBonus_Percentage()	return  self.bonus_move end
function modifier_creeps_spell_troll_roar_buff:GetActivityTranslationModifiers( params )
	return "fast"
end
function modifier_creeps_spell_troll_roar_buff:GetModifierIgnoreMovespeedLimit( params )
	return 1
end