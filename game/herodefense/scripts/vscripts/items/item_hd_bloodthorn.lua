item_hd_bloodthorn = class({})
-- LinkLuaModifier("modifier_item_hd_bloodthorn_arua", "items/item_hd_bloodthorn", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bloodthorn_arua_effect", "items/item_hd_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bloodthorn", "items/item_hd_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bloodthorn_active", "items/item_hd_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bloodthorn_active_standby", "items/item_hd_bloodthorn", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bloodthorn_active_debuff", "items/item_hd_bloodthorn", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_bloodthorn:GetIntrinsicModifierName()
	return "modifier_item_hd_bloodthorn"
end



function item_hd_bloodthorn:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	EmitSoundOn("DOTA_Item.Orchid.Activate", caster)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local duration = 3*StatusResistance
	if duration>8 then	duration =8	end
	if duration<3 then	duration =3	end
	target:AddNewModifier(caster, self, "modifier_item_hd_bloodthorn_active", {duration = duration})
end


-- modifier_item_hd_bloodthorn_arua = class({})

-- function modifier_item_hd_bloodthorn_arua:IsHidden() return true end
-- function modifier_item_hd_bloodthorn_arua:IsAura() return true end
-- function modifier_item_hd_bloodthorn_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_bloodthorn_arua:GetModifierAura() return "modifier_item_hd_bloodthorn_arua_effect" end
-- function modifier_item_hd_bloodthorn_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_bloodthorn_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_bloodthorn_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_bloodthorn_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_bloodthorn = class({})

function modifier_item_hd_bloodthorn:IsDebuff() return false end
function modifier_item_hd_bloodthorn:IsHidden() return true end
function modifier_item_hd_bloodthorn:IsPurgable() return false end
-- function modifier_item_hd_bloodthorn:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_bloodthorn:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_bloodthorn:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	-- self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	-- self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
	-- self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	-- self.bonus_active_life_steal = self.ability:GetSpecialValueFor("active_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了

	-- self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	-- self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	-- self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")

	-- self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	-- self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
    if IsServer() then
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_bloodthorn_active_standby", {duration = 20})
	end
end

function modifier_item_hd_bloodthorn:OnDestroy()
	if IsServer() then

		if self.modifier and not self.modifier:IsNull() then
			self.modifier:Destroy()
		end
		-- self.modifier:SafeDestroy()
	end
end


function modifier_item_hd_bloodthorn:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力

		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,            --魔法基础恢复


		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
		MODIFIER_EVENT_ON_ATTACK,                         --攻击事件

	}
end


-- function modifier_item_hd_bloodthorn:GetModifierBonusStats_Strength()	return self.bonus_str*self:GetStackCount() end
function modifier_item_hd_bloodthorn:GetModifierBonusStats_Intellect()	return self.bonus_int end


function modifier_item_hd_bloodthorn:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end

function modifier_item_hd_bloodthorn:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

-- function modifier_item_hd_bloodthorn:GetModifierEvasion_Constant() return self:GetStackCount()==2 and self.bonus_evasion or 0 end
function modifier_item_hd_bloodthorn:GetModifierPreAttack_BonusDamage() return self.bonus_damage end



function modifier_item_hd_bloodthorn:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not params.target:IsMagicImmune() then
			local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_bloodthorn_active_standby")
			-- print("modifier[1]:GetRemainingTime()=="..modifier[1]:GetRemainingTime())
			-- print(modifier[1])
			if modifier and modifier:GetRemainingTime()<=0 then
				modifier:SetDuration(20, true)
				self:GetParent():SetCursorCastTarget(params.target)
				self:GetAbility():OnSpellStart()
			end			
		end
	end
end
modifier_item_hd_bloodthorn_active = advanced_modifier({})

function modifier_item_hd_bloodthorn_active:IsDebuff() return true end
function modifier_item_hd_bloodthorn_active:IsHidden() return false end
function modifier_item_hd_bloodthorn_active:IsPurgable() return false end
function modifier_item_hd_bloodthorn_active:IsPurgeException() return false end
function modifier_item_hd_bloodthorn_active:GetTexture()return "item_bloodthorn" end
function modifier_item_hd_bloodthorn_active:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_item_hd_bloodthorn_active:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_hd_bloodthorn_active:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true,

}
	return state
end


function modifier_item_hd_bloodthorn_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return 40
end

function modifier_item_hd_bloodthorn_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end










modifier_item_hd_bloodthorn_active_standby = class({})

function modifier_item_hd_bloodthorn_active_standby:IsDebuff() return false end
function modifier_item_hd_bloodthorn_active_standby:IsHidden() return false end
function modifier_item_hd_bloodthorn_active_standby:DestroyOnExpire()	return false end
function modifier_item_hd_bloodthorn_active_standby:RemoveOnDeath()	return false end
function modifier_item_hd_bloodthorn_active_standby:GetTexture()return "item_bloodthorn" end