item_hd_panic_button = class({})
-- LinkLuaModifier("modifier_item_hd_panic_button_arua", "items/item_hd_panic_button", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_panic_button_arua_effect", "items/item_hd_panic_button", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_panic_button", "items/item_hd_panic_button", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_panic_button:GetIntrinsicModifierName()
	return "modifier_item_hd_panic_button"
end





modifier_item_hd_panic_button = advanced_modifier({})

function modifier_item_hd_panic_button:IsDebuff() return false end
function modifier_item_hd_panic_button:IsHidden() return true end
function modifier_item_hd_panic_button:IsPurgable() return false end


function modifier_item_hd_panic_button:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	if IsServer() then
		self:StartIntervalThink(0.2)
	end



end
function modifier_item_hd_panic_button:OnIntervalThink()
	if IsServer() then

	   if self:GetAbility():IsCooldownReady()  then

		local caster = self:GetCaster()
		if not caster:IsAlive() then
			return
		end
		if caster:GetHealthPercent()<=30 then
			caster:Purge(false, true, false, false,true) --强驱散
			self:GetAbility():UseResources(true, true, true,true)
			self:GetAbility():StartCooldown(10)
			caster:EmitSound("DOTA_Item.MagicLamp.Cast")
			self.particle = ParticleManager:CreateParticle("particles/items5_fx/magic_lamp.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle)

			local heal = caster:GetMaxHealth()*0.3
			local healing =  HealWithGain(heal,caster,caster,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)


			
		end
	
	   end
		-- self:SetHasCustomTransmitterData(true)
	end
end


function modifier_item_hd_panic_button:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值

	}
end


function modifier_item_hd_panic_button:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_panic_button:AdvancedGetModifierConstantHealthRegenAmpPercentage() 	return self.bonus_regeneration_amplification end
function modifier_item_hd_panic_button:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_panic_button:AdvancedGetModifierConstantManaRegenAmpPercentage() 	return self.bonus_mana_regeneration end


function modifier_item_hd_panic_button:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
	}
	return funcs
end
