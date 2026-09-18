item_hd_mind_breaker = class({})

LinkLuaModifier("modifier_item_hd_mind_breaker", "items/item_hd_mind_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mind_breaker_active", "items/item_hd_mind_breaker", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_mind_breaker:GetIntrinsicModifierName()
	return "modifier_item_hd_mind_breaker"
end




modifier_item_hd_mind_breaker = advanced_modifier({})

function modifier_item_hd_mind_breaker:IsDebuff() return false end
function modifier_item_hd_mind_breaker:IsHidden() return true end
function modifier_item_hd_mind_breaker:IsPurgable() return false end


function modifier_item_hd_mind_breaker:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.mana_break = self.ability:GetSpecialValueFor("mana_break")

	self.bonus_attack_spdamage = self.ability:GetSpecialValueFor("bonus_attack_spdamage")
	self.spdamage_max = self.ability:GetSpecialValueFor("spdamage_max")
	self.losemana_spdamage = self.ability:GetSpecialValueFor("losemana_spdamage")*0.01
	self.damage = 0

end


function modifier_item_hd_mind_breaker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,	--附加伤害
	}
end
function modifier_item_hd_mind_breaker:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},                    --攻击降临
	}
end

function modifier_item_hd_mind_breaker:GetModifierAttackSpeedBonus_Constant() 	
	return self.bonus_attack_speed 
end
function modifier_item_hd_mind_breaker:GetModifierPreAttack_BonusDamagePostCrit() 
	
	return self.bonus_attack_spdamage + self.damage
end

function modifier_item_hd_mind_breaker:OnAttackLanded(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker
		if target:GetMaxMana() == 0 then
			return 
		end

		-- Only apply on caster attacking enemies
		if self:GetParent() == attacker and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			target:EmitSound("Hero_Antimage.ManaBreak")	
			local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(manaburn_pfx)

			local target_mana_burn = target:GetMana()
			if (target_mana_burn > self.mana_break) then
				target_mana_burn = self.mana_break
			end
			target:Script_ReduceMana(target_mana_burn,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, target_mana_burn, nil)
			self.damage = math.min((target:GetMaxMana() - target:GetMana())*self.losemana_spdamage,self.spdamage_max)

		end

	end
end
