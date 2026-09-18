item_hd_echo_sabre = class({})
-- LinkLuaModifier("modifier_item_hd_echo_sabre_arua", "items/item_hd_echo_sabre", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_echo_sabre_arua_effect", "items/item_hd_echo_sabre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_echo_sabre", "items/item_hd_echo_sabre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_echo_sabre_active", "items/item_hd_echo_sabre", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_echo_sabre:GetIntrinsicModifierName()
	return "modifier_item_hd_echo_sabre"
end






modifier_item_hd_echo_sabre = class({})

function modifier_item_hd_echo_sabre:IsDebuff() return false end
function modifier_item_hd_echo_sabre:IsHidden() return true end
function modifier_item_hd_echo_sabre:IsPurgable() return false end


function modifier_item_hd_echo_sabre:OnCreated(keys)
    self.ability = self:GetAbility()

 
 
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")

	self.bonus_damage = self.ability:GetSpecialValueFor("bounus_damage")
	
end



function modifier_item_hd_echo_sabre:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量

		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		

	}
end


function modifier_item_hd_echo_sabre:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_echo_sabre:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_echo_sabre:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_echo_sabre:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			if self:GetParent():IsRangedAttacker() then
				return
			end
			self:GetAbility():UseResources(true, true, true,true)
			self:GetAbility():StartCooldown(3)
			keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_echo_sabre_active", {duration = 3})

		end
	end
end



modifier_item_hd_echo_sabre_active = class({})

function modifier_item_hd_echo_sabre_active:IsDebuff() return false end
function modifier_item_hd_echo_sabre_active:IsHidden() return true end
function modifier_item_hd_echo_sabre_active:IsPurgable() return false end
function modifier_item_hd_echo_sabre_active:GetTexture()return "item_echo_sabre" end
function modifier_item_hd_echo_sabre_active:GetEffectName() return "particles/new_effect/status/new_status_effect_soul_04.vpcf" end
function modifier_item_hd_echo_sabre_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_echo_sabre_active:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
			MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	

	}
end
function modifier_item_hd_echo_sabre_active:CheckState()
	local state = {[MODIFIER_STATE_CANNOT_MISS] = true}

	return state
end

function modifier_item_hd_echo_sabre_active:GetModifierAttackSpeedBonus_Constant()return 4000 end

function modifier_item_hd_echo_sabre_active:OnCreated(table)
	if IsServer() then
		self:SetStackCount(5)
		
	end
end

function modifier_item_hd_echo_sabre_active:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() then
			self:DecrementStackCount()
			if self:GetStackCount()==0 then
				self:SafeDestroy()
			end

		end
	end
end
