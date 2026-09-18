chaotic_heimdallr_aura = class({})
LinkLuaModifier("modifier_chaotic_heimdallr_aura", "chaotic_spell/class_4/chaotic_heimdallr_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_heimdallr_aura_buff", "chaotic_spell/class_4/chaotic_heimdallr_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_heimdallr_aura_debuff", "chaotic_spell/class_4/chaotic_heimdallr_aura", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_heimdallr_aura_active", "chaotic_spell/class_4/chaotic_heimdallr_aura", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------------------------------------
function chaotic_heimdallr_aura:GetIntrinsicModifierName()
	return "modifier_chaotic_heimdallr_aura"
end

function chaotic_heimdallr_aura:GetCastRange()
	return 1000
end
----------------------------------------------------------------------------------------------
function chaotic_heimdallr_aura:OnSpellStart()

	local caster = self:GetCaster()
    local radius = 1000
    local duration = self:GetSpecialValueFor("duration")
		
	caster:AddNewModifier(caster, self, "modifier_chaotic_heimdallr_aura_debuff", {duration = duration})

	caster:EmitSound("Hero_TrollWarlord.Taunt.TrollGroove")
	self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_heimdallr_aura/effect_cast/chaotic_heimdallr_aura.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 2, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 3, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)



end

----------------------------------------------------------------------------------------------
modifier_chaotic_heimdallr_aura = advanced_modifier({})

function modifier_chaotic_heimdallr_aura:IsDebuff() return false end
function modifier_chaotic_heimdallr_aura:IsHidden() return true end
function modifier_chaotic_heimdallr_aura:IsPurgable() return false end
function modifier_chaotic_heimdallr_aura:IsPurgeException() 	return false end
function modifier_chaotic_heimdallr_aura:RemoveOnDeath()  return false end
function modifier_chaotic_heimdallr_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chaotic_heimdallr_aura:IsAura() return not self:GetParent():PassivesDisabled() end
function modifier_chaotic_heimdallr_aura:GetModifierAura()	return "modifier_chaotic_heimdallr_aura_buff" end
function modifier_chaotic_heimdallr_aura:GetAuraRadius()	return self.radius end
function modifier_chaotic_heimdallr_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_chaotic_heimdallr_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_chaotic_heimdallr_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_chaotic_heimdallr_aura:OnCreated(keys)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_chaotic_heimdallr_aura:OnRefresh(keys)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
------------------------------------------------------------------------------------------------------------------------------------
modifier_chaotic_heimdallr_aura_buff = advanced_modifier({})

function modifier_chaotic_heimdallr_aura_buff:IsHidden()	return false end
function modifier_chaotic_heimdallr_aura_buff:IsDebuff()    return false end
function modifier_chaotic_heimdallr_aura_buff:IsPurgable()	return false end
function modifier_chaotic_heimdallr_aura_buff:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_heimdallr_aura_buff:OnCreated(keys)
    self.cast_range = self:GetAbility():GetSpecialValueFor("cast_range")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    self.bonus_attack_range_ranger = self:GetAbility():GetSpecialValueFor("bonus_attack_range_ranger")

    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
    if IsServer() then
        self.rune_type = self:GetAbility():GetRuneType()
        if self.rune_type==1 then
            print("11111")
            self.rune_1_shield = self:GetAbility():GetSpecialValueFor("rune_1_shield")
            self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rune_1_interval"))
        end
    end

end
function modifier_chaotic_heimdallr_aura_buff:OnRefresh(keys)
    self.cast_range = self:GetAbility():GetSpecialValueFor("cast_range")
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    self.bonus_attack_range_ranger = self:GetAbility():GetSpecialValueFor("bonus_attack_range_ranger")

    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")

end
function modifier_chaotic_heimdallr_aura_buff:OnIntervalThink()
    print("22222")
    if self.rune_type==1 then

        self:SetStackCount(self.rune_1_shield)
    end
    
end




function modifier_chaotic_heimdallr_aura_buff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE

    }
    if self:GetAbility():GetRuneType()==1 then
        funcs["MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK"] = {nil, self:GetParent()}
    end
    return funcs
    
end





function modifier_chaotic_heimdallr_aura_buff:Advanced_GetModifierCastRangeBonusStacking()
    return  self.cast_range
end

function modifier_chaotic_heimdallr_aura_buff:Advanced_GetModifierAttackRangeBonus()
   if self:GetParent():IsRangedAttacker() then
        return self.bonus_attack_range_ranger
   else
        return self.bonus_attack_range
   end
end


function modifier_chaotic_heimdallr_aura_buff:Advanced_GetModifierAttackSpeedPercentage()
    if self:GetAuraOwner():HasModifier("modifier_chaotic_heimdallr_aura_debuff") then
        return self.bonus_attack_speed
    end
  
end

function modifier_chaotic_heimdallr_aura_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if self:GetAuraOwner():HasModifier("modifier_chaotic_heimdallr_aura_debuff") then
        return self.bonus_attack_damage
    end
    
end
function modifier_chaotic_heimdallr_aura_buff:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

    local stack = self:GetStackCount()
    if stack <= 0 then
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack
end

------------------------------------------------------------------------------------------------------------------------------------

modifier_chaotic_heimdallr_aura_debuff = advanced_modifier({})

function modifier_chaotic_heimdallr_aura_debuff:IsDebuff() return false end
function modifier_chaotic_heimdallr_aura_debuff:IsHidden() return false end
function modifier_chaotic_heimdallr_aura_debuff:IsPurgable() return false end
function modifier_chaotic_heimdallr_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_chaotic_heimdallr_aura_debuff:GetModifierMoveSpeedBonus_Constant()
    return -99999
end

