item_hd_rule_breaker = class({})

LinkLuaModifier("modifier_item_hd_rule_breaker", "items/item_hd_rule_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rule_breaker_active", "items/item_hd_rule_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rule_breaker_cd", "items/item_hd_rule_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_enraged_buff", "special_gain/creep_special_gain_enraged", LUA_MODIFIER_MOTION_NONE)

function item_hd_rule_breaker:GetIntrinsicModifierName()
	return "modifier_item_hd_rule_breaker"
end


-------------------------------------------------------------------------------

modifier_item_hd_rule_breaker = advanced_modifier({})

function modifier_item_hd_rule_breaker:IsDebuff() return false end
function modifier_item_hd_rule_breaker:IsHidden() return true end
function modifier_item_hd_rule_breaker:IsPurgable() 		return false end
function modifier_item_hd_rule_breaker:IsPurgeException() 	return false end
function modifier_item_hd_rule_breaker:RemoveOnDeath()  return false end
function modifier_item_hd_rule_breaker:GetTexture()  return "item_a2" end


function modifier_item_hd_rule_breaker:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_spell_amp = ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_cooldown = ability:GetSpecialValueFor("bonus_cooldown")
end


function modifier_item_hd_rule_breaker:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},                       --受到伤害事件
    }
end
function modifier_item_hd_rule_breaker:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end
function modifier_item_hd_rule_breaker:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_amp end


function modifier_item_hd_rule_breaker:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		if not keys.inflictor then return end
		
		if not IsEnemy(unit,attacker) then
			return
		end
		
		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

        if unit:HasModifier("modifier_item_hd_rule_breaker_cd")then return 0 end

        unit:AddNewModifier(attacker, self:GetAbility(), "modifier_item_hd_rule_breaker_active", {})

		--fHDSendCustomOverheadEventMessage("msg_damage", unit, applydamage, nil, nil, Vector(27, 221, 247), 4)
    end 
end
------------------------------------------------
modifier_item_hd_rule_breaker_active = advanced_modifier({})

function modifier_item_hd_rule_breaker_active:IsDebuff() return true end
function modifier_item_hd_rule_breaker_active:IsHidden() return false end
function modifier_item_hd_rule_breaker_active:IsPurgable() 		return false end
function modifier_item_hd_rule_breaker_active:IsPurgeException() 	return false end
function modifier_item_hd_rule_breaker_active:RemoveOnDeath()  return false end
function modifier_item_hd_rule_breaker_active:GetTexture()  return "item_a2" end


function modifier_item_hd_rule_breaker_active:OnCreated(keys)
    local ability = self:GetAbility()
	self.active_duration = ability:GetSpecialValueFor("active_duration")
    self.duration = ability:GetSpecialValueFor("duration")
    self:StartIntervalThink(0.1)
end
function modifier_item_hd_rule_breaker_active:OnIntervalThink(keys)
    if IsServer() then
        if self:GetParent():HasModifier("modifier_creep_special_gain_enraged_buff") then
            self:GetParent():RemoveModifierByNameAndCaster("modifier_creep_special_gain_enraged_buff", self:GetParent())
            self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.active_duration})
            self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_item_hd_rule_breaker_cd", {duration = self.duration})
            self:GetParent():RemoveModifierByNameAndCaster("modifier_item_hd_rule_breaker_active", self:GetCaster())
        end
    end
end

------------------------------------------------
modifier_item_hd_rule_breaker_cd = advanced_modifier({})

function modifier_item_hd_rule_breaker_cd:IsDebuff() return true end
function modifier_item_hd_rule_breaker_cd:IsHidden() return false end
function modifier_item_hd_rule_breaker_cd:IsPurgable() 		return false end
function modifier_item_hd_rule_breaker_cd:IsPurgeException() 	return false end
function modifier_item_hd_rule_breaker_cd:RemoveOnDeath()  return false end
function modifier_item_hd_rule_breaker_cd:GetTexture()  return "item_a2" end