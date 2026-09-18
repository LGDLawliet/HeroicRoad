item_hd_obliterating_orb = class({})

LinkLuaModifier("modifier_item_hd_obliterating_orb", "items/item_hd_obliterating_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_obliterating_orb_debuff", "items/item_hd_obliterating_orb", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_obliterating_orb:GetIntrinsicModifierName()
	return "modifier_item_hd_obliterating_orb"
end


modifier_item_hd_obliterating_orb = advanced_modifier({})

function modifier_item_hd_obliterating_orb:IsDebuff() return false end
function modifier_item_hd_obliterating_orb:IsHidden() return true end
function modifier_item_hd_obliterating_orb:IsPurgable() return false end
function modifier_item_hd_obliterating_orb:IsPurgeException() return false end
function modifier_item_hd_obliterating_orb:RemoveOnDeath() return false end
function modifier_item_hd_obliterating_orb:DestroyOnExpire() return false end
function modifier_item_hd_obliterating_orb:OnCreated(keys)

	self.bonus_spell_amp =  self:GetAbility():GetSpecialValueFor("bonus_spell_amp")

	if IsServer() then
	

	end
end

function modifier_item_hd_obliterating_orb:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE

	}
end

function modifier_item_hd_obliterating_orb:Advanced_GetModifierSpellAmplifyBonus()return self.bonus_spell_amp end

function modifier_item_hd_obliterating_orb:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_obliterating_orb:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end

		if keys.damage<=50 then return	end
		if keys.damage_type~=DAMAGE_TYPE_MAGICAL  then
			return
		end
		

		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
	
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		if unit:HasModifier("modifier_item_hd_obliterating_orb_debuff") then
			return
		end
		unit:AddNewModifier(attacker, self:GetAbility(), "modifier_item_hd_obliterating_orb_debuff", {duration = 5})
 
    end 
end


modifier_item_hd_obliterating_orb_debuff = class({})

function modifier_item_hd_obliterating_orb_debuff:IsDebuff() return true end
function modifier_item_hd_obliterating_orb_debuff:IsHidden() return false end
function modifier_item_hd_obliterating_orb_debuff:IsPurgable() return false end
function modifier_item_hd_obliterating_orb_debuff:IsPurgeException() return false end
function modifier_item_hd_obliterating_orb_debuff:OnCreated(keys)
	if IsServer() then
		local stack = RandomInt(10, 40) * (self:GetCaster():GetModifierRandomEffectGain()*0.01+1)

		self:SetStackCount(math.max(stack,0))
	end
end

function modifier_item_hd_obliterating_orb_debuff:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
end

function modifier_item_hd_obliterating_orb_debuff:GetModifierMagicalResistanceBonus()return -self:GetStackCount() end
