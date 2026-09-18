item_hd_javelin = class({})

LinkLuaModifier("modifier_item_hd_javelin", "items/item_hd_javelin", LUA_MODIFIER_MOTION_NONE)

function item_hd_javelin:GetIntrinsicModifierName()
	return "modifier_item_hd_javelin"
end


modifier_item_hd_javelin = advanced_modifier({})

function modifier_item_hd_javelin:IsDebuff() return false end
function modifier_item_hd_javelin:IsHidden() return true end
function modifier_item_hd_javelin:IsPurgable() return false end

function modifier_item_hd_javelin:CheckState()
	local state = {}
	state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	return state
end


function modifier_item_hd_javelin:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.pierce_proc 			= false   --用于金箍棒
	self.pierce_records			= {}      --用于金箍棒
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.extra_damage = self.ability:GetSpecialValueFor("extra_damage")

end


function modifier_item_hd_javelin:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度

		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,  --额外伤害
		MODIFIER_EVENT_ON_ATTACK_RECORD,                    --攻击被记录
		

	}
end

function modifier_item_hd_javelin:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_javelin:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.extra_damage, nil)
				
				return self.extra_damage
			end
		end
	end
end

function modifier_item_hd_javelin:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
		self.pierce_proc = true
	end
end

