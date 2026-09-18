item_hd_silver_edge = class({})
-- LinkLuaModifier("modifier_item_hd_silver_edge_arua", "items/item_hd_silver_edge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_silver_edge_arua_effect", "items/item_hd_silver_edge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_silver_edge", "items/item_hd_silver_edge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_silver_edge_active", "items/item_hd_silver_edge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_silver_edge_active_debuff", "items/item_hd_silver_edge", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_silver_edge:GetIntrinsicModifierName()
	return "modifier_item_hd_silver_edge"
end



function item_hd_silver_edge:OnSpellStart()

	local caster    =   self:GetCaster()

	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)
	local duration =caster:IsInNightTime() and 4 or 2
	self:StartCooldown(25)
	Timers:CreateTimer(0.3, function()

		local particle_invis_start_fx = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

		caster:AddNewModifier(caster, self, "modifier_item_hd_silver_edge_active", {duration = duration})
	end)
end


-- modifier_item_hd_silver_edge_arua = class({})

-- function modifier_item_hd_silver_edge_arua:IsHidden() return true end
-- function modifier_item_hd_silver_edge_arua:IsAura() return true end
-- function modifier_item_hd_silver_edge_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_silver_edge_arua:GetModifierAura() return "modifier_item_hd_silver_edge_arua_effect" end
-- function modifier_item_hd_silver_edge_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_silver_edge_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_silver_edge_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_silver_edge_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_silver_edge = advanced_modifier({})

function modifier_item_hd_silver_edge:IsDebuff() return false end
function modifier_item_hd_silver_edge:IsHidden() return true end
function modifier_item_hd_silver_edge:IsPurgable() return false end
-- function modifier_item_hd_silver_edge:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_silver_edge:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_silver_edge:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_silver_edge_active", {})
		self:StartIntervalThink(0.5)

	end
end
function modifier_item_hd_silver_edge:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsInNightTime() then
			self:SetStackCount(1)
		else
			self:SetStackCount(2)
		end
		-- self:SetHasCustomTransmitterData(true)
	end
end


function modifier_item_hd_silver_edge:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力

	}
end


function modifier_item_hd_silver_edge:GetModifierBonusStats_Strength()	return self.bonus_str*self:GetStackCount() end
function modifier_item_hd_silver_edge:GetModifierBonusStats_Intellect()	return self.bonus_int*self:GetStackCount() end
function modifier_item_hd_silver_edge:GetModifierBonusStats_Agility()	return self.bonus_agi*self:GetStackCount() end

function modifier_item_hd_silver_edge:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end

function modifier_item_hd_silver_edge:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

-- function modifier_item_hd_silver_edge:GetModifierEvasion_Constant() return self:GetStackCount()==2 and self.bonus_evasion or 0 end
function modifier_item_hd_silver_edge:GetModifierPreAttack_BonusDamage() return self.bonus_damage end

function modifier_item_hd_silver_edge:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end


modifier_item_hd_silver_edge_active = class({})

function modifier_item_hd_silver_edge_active:IsDebuff() return false end
function modifier_item_hd_silver_edge_active:IsHidden() return false end
function modifier_item_hd_silver_edge_active:IsPurgable() return false end
function modifier_item_hd_silver_edge_active:GetTexture()return "item_silver_edge" end

function modifier_item_hd_silver_edge_active:OnCreated(table)
	if IsServer() then
		-- self.pos = self:GetParent():GetAbsOrigin()
		-- self:StartIntervalThink(1)
		self.bonus_attack_damage = self:GetCaster():GetBaseDamageMax()*6+600
	end
end


function modifier_item_hd_silver_edge_active:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:GetAbsOrigin()==self.pos then
			if self:GetStackCount()<30 then
				self:IncrementStackCount()	
			end
		else
			self:SetStackCount(0)
			self.pos= parent:GetAbsOrigin()
		end
	end
end



function modifier_item_hd_silver_edge_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
	}
end


function modifier_item_hd_silver_edge_active:GetModifierInvisibilityLevel()return 1 end

function modifier_item_hd_silver_edge_active:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end



function modifier_item_hd_silver_edge_active:GetModifierPreAttack_BonusDamagePostCrit(params) return self.bonus_attack_damage end


function modifier_item_hd_silver_edge_active:GetModifierMoveSpeedBonus_Percentage()		return 20	end

function modifier_item_hd_silver_edge_active:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local ModifierStatusNegativeGain = params.attacker:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = params.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_hd_silver_edge_active_debuff", {duration = 4*StatusResistance})
			self:SafeDestroy()
		end
	end
end

function modifier_item_hd_silver_edge_active:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		if keys.unit == parent then
			self:SafeDestroy()
		end
	end
end



modifier_item_hd_silver_edge_active_debuff = advanced_modifier({})

function modifier_item_hd_silver_edge_active_debuff:IsDebuff() return true end
function modifier_item_hd_silver_edge_active_debuff:IsHidden() return false end
function modifier_item_hd_silver_edge_active_debuff:IsPurgable() return false end
function modifier_item_hd_silver_edge_active_debuff:GetTexture()return "item_silver_edge" end
function modifier_item_hd_silver_edge_active_debuff:GetEffectName()	return "particles/items3_fx/silver_edge.vpcf" end
function modifier_item_hd_silver_edge_active_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_silver_edge_active_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
	return state
end

function modifier_item_hd_silver_edge_active_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
	}
end

function modifier_item_hd_silver_edge_active_debuff:GetModifierMagicalResistanceBonus() return -20 end


function modifier_item_hd_silver_edge_active_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_silver_edge_active_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -8
end