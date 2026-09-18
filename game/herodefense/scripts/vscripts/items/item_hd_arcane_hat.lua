item_hd_arcane_hat = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_arcane_hat", "items/item_hd_arcane_hat", LUA_MODIFIER_MOTION_NONE)

function item_hd_arcane_hat:GetIntrinsicModifierName()
	return "modifier_item_hd_arcane_hat"
end


modifier_item_hd_arcane_hat = advanced_modifier({})

function modifier_item_hd_arcane_hat:IsDebuff() return false end
function modifier_item_hd_arcane_hat:IsHidden() return true end
function modifier_item_hd_arcane_hat:IsPurgable() 		return false end
function modifier_item_hd_arcane_hat:IsPurgeException() 	return false end
function modifier_item_hd_arcane_hat:RemoveOnDeath()  return false end
function modifier_item_hd_arcane_hat:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.cri = self.ability:GetSpecialValueFor("cri")*0.01

end


function modifier_item_hd_arcane_hat:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
function modifier_item_hd_arcane_hat:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end
function modifier_item_hd_arcane_hat:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},                       --受到伤害事件
    }
end

function modifier_item_hd_arcane_hat:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end

		if keys.damage<=100 then return	end
		if not IsEnemy(unit,attacker) then
			return
		end
		if Cannotcrit(keys) then return end

		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		if self:GetAbility():IsCooldownReady() and self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1)>=RandomInt(1, 100) then

			local damage = keys.damage *self.cri

			local damageTable = {
								victim = unit,
								attacker = attacker,
								damage = damage,
								damage_type = DAMAGE_TYPE_PURE,
								damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
								ability = keys.inflictor, --Optional.
								}
			local applydamage = ApplyDamage(damageTable)
			self:GetAbility():UseResources(true, true, true, true)
			if applydamage<=0 then
				return
			end
			fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
		end
		

 
    end 
end

