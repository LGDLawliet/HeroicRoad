item_hd_curse_staff = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_curse_staff", "items/item_hd_curse_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_curse_staff_active", "items/item_hd_curse_staff", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
function item_hd_curse_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_curse_staff"
end
----------------------

modifier_item_hd_curse_staff = advanced_modifier({})

function modifier_item_hd_curse_staff:IsDebuff() return false end
function modifier_item_hd_curse_staff:IsHidden() return true end
function modifier_item_hd_curse_staff:IsPurgable() return false end

function modifier_item_hd_curse_staff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
    self.bonus_cast_range = self.ability:GetSpecialValueFor("bonus_cast_range")
    self.duration = self.ability:GetSpecialValueFor("duration")
end

-- advanced_modifier
function modifier_item_hd_curse_staff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end

function modifier_item_hd_curse_staff:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
        if not keys.target:IsRealHero() then
            return
        end
        if keys.target:GetTeamNumber() ~= keys.unit:GetTeamNumber() then
            return
        end
        if not self:GetAbility():IsCooldownReady() then
            return
        end


		local caster = self:GetCaster()
		local target = keys.target
		if target.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
				return
			end
		end

        keys.target:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_curse_staff_active", {duration = self.duration})
        self:GetAbility():UseResources(true, true, true, true)
	end
end
function modifier_item_hd_curse_staff:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end
function modifier_item_hd_curse_staff:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self.bonus_cast_range 
end

modifier_item_hd_curse_staff_active = advanced_modifier({})

function modifier_item_hd_curse_staff_active:IsDebuff() return false end
function modifier_item_hd_curse_staff_active:IsHidden() return true end
function modifier_item_hd_curse_staff_active:IsPurgable() return false end
function modifier_item_hd_curse_staff_active:GetEffectName() return "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_steam.vpcf" end
function modifier_item_hd_curse_staff_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_curse_staff_active:OnCreated(keys)
    
    self.ability = self:GetAbility()
    self.active_atb = self.ability:GetSpecialValueFor("active_atb")
    self.active_damage = self.ability:GetSpecialValueFor("active_damage")
	self:StartIntervalThink(1)
	if IsServer() then
	self.damagetable = {
		attacker = self:GetCaster() ,
		victim = self:GetParent(),
		--damage = self.active,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY  + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL, --Optional.
		ability = self, --Optional.
	}
	end
    
end
function modifier_item_hd_curse_staff_active:OnRefresh(keys)
    
    self.ability = self:GetAbility()
    self.active_atb = self.ability:GetSpecialValueFor("active_atb")
    self.active_damage = self.ability:GetSpecialValueFor("active_damage")
	if IsServer() then
	self.damagetable = {
		attacker = self:GetCaster() ,
		victim = self:GetParent(),
		--damage = self.active,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL, --Optional.
		ability = self, --Optional.
	}
	end

end
function modifier_item_hd_curse_staff_active:OnIntervalThink(keys)
	if IsServer() then
	local damage =  self.ability:GetSpecialValueFor("active")*0.01*self:GetParent():GetMaxHealth()
	self.damagetable.damage = damage
	ApplyDamage(self.damagetable)
	end
end
function modifier_item_hd_curse_staff_active:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function modifier_item_hd_curse_staff_active:Advanced_GetModifierBonusStats_Strength()
    return self.active_atb
end
function modifier_item_hd_curse_staff_active:Advanced_GetModifierBonusStats_Agility()
    return self.active_atb
end
function modifier_item_hd_curse_staff_active:Advanced_GetModifierBonusStats_Intellect()
    return self.active_atb
end
function modifier_item_hd_curse_staff_active:Advanced_GetModifierPreAttack_BonusDamage()
    return  self.active_damage
end