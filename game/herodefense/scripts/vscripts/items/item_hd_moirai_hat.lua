item_hd_moirai_hat = class({})

LinkLuaModifier("modifier_item_hd_moirai_hat", "items/item_hd_moirai_hat", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_moirai_hat:GetIntrinsicModifierName()
	return "modifier_item_hd_moirai_hat"
end




modifier_item_hd_moirai_hat = advanced_modifier({})

function modifier_item_hd_moirai_hat:IsDebuff() return false end
function modifier_item_hd_moirai_hat:IsHidden() return true end
function modifier_item_hd_moirai_hat:IsPurgable() 		return false end
function modifier_item_hd_moirai_hat:IsPurgeException() 	return false end
function modifier_item_hd_moirai_hat:RemoveOnDeath()  return false end


function modifier_item_hd_moirai_hat:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_spell_damage_amplification = ability:GetSpecialValueFor("bonus_spell_amp")
	self.atb_spell_amp = ability:GetSpecialValueFor("atb_spell_amp")
	self.spell_amp_max = ability:GetSpecialValueFor("spell_amp_max")
	if IsServer() then
		self:StartIntervalThink(1)
	end
    -- if IsServer() then
	-- 	self.damage = 0
	-- end
end

function modifier_item_hd_moirai_hat:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_moirai_hat:OnIntervalThink()   
	local parent = self:GetParent()
	local stack = math.floor(parent:HDGetPrimaryStatValue()/self.atb_spell_amp)
	self:SetStackCount(math.min(stack, self.spell_amp_max))
end

function modifier_item_hd_moirai_hat:Advanced_GetModifierSpellAmplifyBonus()   
	return self.bonus_spell_damage_amplification + self:GetStackCount()
end

-- function modifier_item_hd_moirai_hat:DeclareFunctions()
-- 	return {

-- 		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
-- 		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
-- 	}
-- end

-- function modifier_item_hd_moirai_hat:GetModifierBonusStats_Intellect()	return self.bonus_int end

-- function modifier_item_hd_moirai_hat:OnTakeDamage(keys)
-- 	if IsServer() then   
-- 		local attacker = keys.attacker
-- 		local unit = keys.unit

-- 		if not keys.inflictor then return end
-- 		if attacker~=self:GetParent() then	return end

-- 		if keys.damage<=50 then return	end
		
-- 		if not IsEnemy(unit,attacker) then
-- 			return
-- 		end
		
-- 		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
		
-- 		if Cannotcrit(keys) then return end
	
-- 		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

-- 		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

-- 		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


-- 		local chance = 35
-- 		if keys.damage>=self.damage then
-- 			chance = 100
-- 		end
-- 		self.damage = keys.damage+1
-- 		if self:GetAbility():IsCooldownReady() and self:GetCaster():GetRandomEffect(chance,INT_TYPE,1)>=RandomInt(1, 100) then

-- 			self:GetAbility():StartCooldown(1)
-- 			local damage = keys.damage *0.8
-- 			local damageTable = {
-- 								victim = unit,
-- 								attacker = attacker,
-- 								damage = damage,
-- 								damage_type = keys.damage_type,
-- 								damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
-- 								ability = keys.inflictor, --Optional.
-- 								hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
-- 								}
-- 			local applydamage = ApplyDamage(damageTable)
-- 			if applydamage<=0 then
-- 				return
-- 			end
-- 			fHDSendCustomOverheadEventMessage("msg_damage", unit, applydamage, nil, nil, Vector(27, 221, 247), 4)
-- 		end
		

 
--     end 
-- end

