chaotic_rune11_amn = class({})
LinkLuaModifier("modifier_chaotic_rune11_amn", "chaotic_spell/class_6/chaotic_rune11_amn", LUA_MODIFIER_MOTION_NONE)

function chaotic_rune11_amn:GetIntrinsicModifierName()
	return "modifier_chaotic_rune11_amn"
end
--------------------------------------------------------
modifier_chaotic_rune11_amn = advanced_modifier({})

function modifier_chaotic_rune11_amn:IsDebuff() return false end
function modifier_chaotic_rune11_amn:IsPurgable()	return false end
function modifier_chaotic_rune11_amn:RemoveOnDeath() return false end
function modifier_chaotic_rune11_amn:IsPurgeException() return false end
function modifier_chaotic_rune11_amn:IsHidden() return true end
function modifier_chaotic_rune11_amn:OnCreated(keys)
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.crit_index = self:GetAbility():GetSpecialValueFor("crit_index")*0.01
	self.outgoing = (self.crit_chance*self.crit_index)
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
	if self:GetAbility():GetRuneType() == 1 then
        self.outgoing = self.outgoing + self.rune_1_bonus
    end
    if self:GetAbility():GetRuneType() == 3 then
        self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance") * (1-self:GetAbility():GetSpecialValueFor("rune_3_crit_chance")*0.01)
        self.crit_index = self:GetAbility():GetSpecialValueFor("crit_index")*0.01 * (1+self:GetAbility():GetSpecialValueFor("rune_3_crit_index")*0.01)
    end
end

function modifier_chaotic_rune11_amn:OnRefresh(keys)
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.crit_index = self:GetAbility():GetSpecialValueFor("crit_index")*0.01
	self.outgoing = (self.crit_chance*self.crit_index)
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
	if self:GetAbility():GetRuneType() == 1 then
        self.outgoing = self.outgoing + self.rune_1_bonus
    end
    if self:GetAbility():GetRuneType() == 3 then
        self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance") * (1-self:GetAbility():GetSpecialValueFor("rune_3_crit_chance")*0.01)
        self.crit_index = self:GetAbility():GetSpecialValueFor("crit_index")*0.01 * (1+self:GetAbility():GetSpecialValueFor("rune_3_crit_index")*0.01)
    end
end

function modifier_chaotic_rune11_amn:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end

function modifier_chaotic_rune11_amn:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end

    if IsPoisonDamage(keys) or IsBurningDamage(keys) or IsFreezingDamage(keys) then
     	return self.outgoing
    end
    return 0
end

function modifier_chaotic_rune11_amn:OnTakeDamage(keys)
    if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		
		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end

        if unit:GetTeamNumber() == attacker:GetTeamNumber() then
            return
        end
		if Cannotcrit(keys) then return end

		if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

        local random = math.random
		local chance = self.crit_chance

		

		local more_multi = attacker:FindAbilityByName("Primary_arcane_supremacy") or attacker:FindAbilityByName("Middle_arcane_supremacy") or attacker:FindAbilityByName("Advanced_arcane_supremacy") or attacker:FindAbilityByName("chaotic_arcane_supremacy")
		if more_multi then
			chance = 0
		else
			chance = self.crit_chance
		end

		local sky_fire = attacker:FindAbilityByName("chaotic_sky_fire")
		if sky_fire and sky_fire:GetRuneType() == 1 then
			if keys.inflictor and keys.inflictor == sky_fire then
				chance = 100
				print("天碍震星暴击拉满"..chance)
			else
				chance = self.crit_chance
				print("不是天碍震星，概率回复"..chance)
			end
		end
		
		if chance >= random(1, 100) then
			
			if sky_fire and sky_fire:GetRuneType() == 1 then
				self.crit_damage = self.crit_index - sky_fire:GetSpecialValueFor("rune_1_crit_damage")*0.01
			else
				self.crit_damage = self.crit_index
			end

			local damage = keys.damage*self.crit_damage
			local damageTable = {
								victim = unit,
								attacker = attacker,
								damage = damage,
								damage_type = keys.damage_type,
								damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
								ability = keys.inflictor, --Optional.
                                hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
								}
			local applydamage = ApplyDamage(damageTable)
			--print("触发暴击")

            if self:GetAbility():GetRuneType() == 2 then
                local mp_regen = (attacker:GetMaxMana()-attacker:GetMana())*self:GetAbility():GetSpecialValueFor("rune_2_mp_regen")*0.01
                attacker:GiveMana(mp_regen)
            end
			if applydamage<=0 then
				return
			end

			fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
		end
    end 
end

