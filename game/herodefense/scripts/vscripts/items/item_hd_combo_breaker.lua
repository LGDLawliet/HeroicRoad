item_hd_combo_breaker = class({})

LinkLuaModifier("modifier_item_hd_combo_breaker", "items/item_hd_combo_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_combo_breaker_active", "items/item_hd_combo_breaker", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_combo_breaker:GetIntrinsicModifierName()
	return "modifier_item_hd_combo_breaker"
end






modifier_item_hd_combo_breaker = advanced_modifier({})

function modifier_item_hd_combo_breaker:IsDebuff() return false end
function modifier_item_hd_combo_breaker:IsHidden() return true end
function modifier_item_hd_combo_breaker:IsPurgable() return false end


function modifier_item_hd_combo_breaker:OnCreated(keys)
    self.ability = self:GetAbility()

 
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

end



function modifier_item_hd_combo_breaker:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end


function modifier_item_hd_combo_breaker:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_combo_breaker:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_combo_breaker:GetModifierManaBonus()	return self.bonus_mana end

function modifier_item_hd_combo_breaker:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit


		if unit~=self:GetParent() then	return end

		if keys.damage<=0 then return	end
		-- if not unit:IsAlive() then
		-- 	return
		-- end

		if self:GetAbility():IsCooldownReady() then
			local health = unit:GetHealth()
			local maxHealth = unit:GetMaxHealth()
			if health-keys.damage<=maxHealth*0.7 then
				unit:SetHealth(math.max(health, maxHealth*0.1))
				self:GetAbility():UseResources(true, true, true,true)
				self:GetAbility():StartCooldown(15)
				unit:Purge(false, true, false, false,true) --强驱散
				unit:EmitSound("DOTA_Item.ComboBreaker")
				unit:AddNewModifier(unit, self:GetAbility(), "modifier_item_hd_combo_breaker_active", {duration = 2.5})
				self.particle = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_POINT_FOLLOW, unit)
				local pos = unit:GetAbsOrigin()
				pos.z = pos.z +88
				ParticleManager:SetParticleControl(self.particle, 0, pos)
				ParticleManager:SetParticleControl(self.particle, 1, pos)
				ParticleManager:ReleaseParticleIndex(self.particle)
			end
			

		
		end
		

 
    end 
end

function modifier_item_hd_combo_breaker:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_combo_breaker:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

modifier_item_hd_combo_breaker_active = advanced_modifier({})

function modifier_item_hd_combo_breaker_active:IsDebuff() return false end
function modifier_item_hd_combo_breaker_active:IsHidden() return false end
function modifier_item_hd_combo_breaker_active:IsPurgable() return false end
function modifier_item_hd_combo_breaker_active:GetTexture()return "item_combo_breaker" end
function modifier_item_hd_combo_breaker_active:Advanced_GetModifierIncomingDamage_Percentage()return -100 end

function modifier_item_hd_combo_breaker_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
}
	return funcs
end

function modifier_item_hd_combo_breaker_active:Advanced_GetModifier_StatusResistance(keys)
	return 75
end

