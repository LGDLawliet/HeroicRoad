item_hd_hero_cape = class({})

LinkLuaModifier("modifier_item_hd_hero_cape", "items/item_hd_hero_cape", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_hero_cape:GetIntrinsicModifierName()
	return "modifier_item_hd_hero_cape"
end


modifier_item_hd_hero_cape = class({})

function modifier_item_hd_hero_cape:IsDebuff() return false end
function modifier_item_hd_hero_cape:IsHidden() return true end
function modifier_item_hd_hero_cape:IsPurgable() return false end
function modifier_item_hd_hero_cape:IsPurgeException() return false end
function modifier_item_hd_hero_cape:RemoveOnDeath() return false end
function modifier_item_hd_hero_cape:DestroyOnExpire() return false end
function modifier_item_hd_hero_cape:OnCreated(keys)
	self.bonus_attribute =  self:GetAbility():GetSpecialValueFor("bonus_all_attribute")
	
	if IsServer() then

	end
end

function modifier_item_hd_hero_cape:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end
function modifier_item_hd_hero_cape:GetModifierBonusStats_Strength()return self.bonus_attribute end
function modifier_item_hd_hero_cape:GetModifierBonusStats_Agility()return self.bonus_attribute end
function modifier_item_hd_hero_cape:GetModifierBonusStats_Intellect()return self.bonus_attribute end

function modifier_item_hd_hero_cape:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end
		if keys.damage<=50 then return	end
		if not IsEnemy(attacker,unit) then
			return
		end
		if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		local damage = keys.damage*0.18
		unit:ModifyHealth(unit:GetHealth()  -damage, keys.inflictor , false, DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS+DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT)
    end 
end
