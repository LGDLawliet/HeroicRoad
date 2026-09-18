item_hd_diffusal_blade = class({})
-- LinkLuaModifier("modifier_item_hd_diffusal_blade_arua", "items/item_hd_diffusal_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_diffusal_blade_arua_effect", "items/item_hd_diffusal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_diffusal_blade", "items/item_hd_diffusal_blade", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_diffusal_blade:GetIntrinsicModifierName()
	return "modifier_item_hd_diffusal_blade"
end





modifier_item_hd_diffusal_blade = class({})

function modifier_item_hd_diffusal_blade:IsDebuff() return false end
function modifier_item_hd_diffusal_blade:IsHidden() return true end
function modifier_item_hd_diffusal_blade:IsPurgable() return false end



function modifier_item_hd_diffusal_blade:OnCreated(keys)
    self.ability = self:GetAbility()


	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_damage = 0



end


function modifier_item_hd_diffusal_blade:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, --额外物理伤害
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end



function modifier_item_hd_diffusal_blade:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_diffusal_blade:GetModifierBonusStats_Agility()	return self.bonus_agi end


function modifier_item_hd_diffusal_blade:GetModifierPreAttack_BonusDamagePostCrit(params) 
	local damage = self.bonus_damage
	self.bonus_damage = 0
	return damage
end



function modifier_item_hd_diffusal_blade:OnAttackLanded(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return 
		end
		-- Only apply on caster attacking enemies
		if self:GetParent() == attacker and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			if keys.damage<50 then
				return
			end
			if self:GetCaster():GetRandomEffect(10,INT_TYPE,0.5) >=RandomInt(1, 100) then
				local mana_break =keys.damage *0.5
				local target_max_mana = target:GetMaxMana()*0.5
				if (target:GetMana() >target_max_mana) then
					target:Script_ReduceMana(mana_break,self:GetAbility())
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, mana_break, nil)
					else
						self.bonus_damage = mana_break
				end				
			end



		end
	end
end

