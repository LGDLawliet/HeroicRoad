item_hd_iron_talon = class({})

LinkLuaModifier("modifier_item_hd_iron_talon", "items/item_hd_iron_talon", LUA_MODIFIER_MOTION_NONE)

function item_hd_iron_talon:GetIntrinsicModifierName()
	return "modifier_item_hd_iron_talon"
end

modifier_item_hd_iron_talon = class({})

function modifier_item_hd_iron_talon:IsDebuff() return false end
function modifier_item_hd_iron_talon:IsHidden() return true end
function modifier_item_hd_iron_talon:IsPurgable() return false end


function modifier_item_hd_iron_talon:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	-- self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	-- self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	-- self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
	-- self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	-- self.bonus_active_life_steal = self.ability:GetSpecialValueFor("active_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了

	-- self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	-- self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	-- self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	-- self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")

	-- self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	-- self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	-- self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	-- self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	-- self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
	-- self.bonus_heal_receive_amplification = self.ability:GetSpecialValueFor("bonus_heal_receive_amplification")
	self.exattack_chance = self.ability:GetSpecialValueFor("chance") + 1
	self:StartIntervalThink(1)
end

function modifier_item_hd_iron_talon:OnIntervalThink(keys)
	if self:GetCaster():FindAbilityByName("Primary_necromastery") or self:GetCaster():FindAbilityByName("Middle_necromastery") or self:GetCaster():FindAbilityByName("Advanced_necromastery") then
		self.exattack_chance = self.ability:GetSpecialValueFor("chance_override") + 1
	else
		self.exattack_chance = self.ability:GetSpecialValueFor("chance") + 1
	end
end

function modifier_item_hd_iron_talon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_EVENT_ON_ATTACK,                           --攻击事件
	}
end


function modifier_item_hd_iron_talon:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_item_hd_iron_talon:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetCaster():GetRandomEffect(self.exattack_chance,INT_TYPE,1)  >= RandomInt(1, 100) then
			self:GetAbility():UseResources(true, true, true,true)
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			
			self:GetParent():PerformAttack(keys.target, false, true, true, true, false, false, true)--对一单位执行攻击。
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		end
	end
end



