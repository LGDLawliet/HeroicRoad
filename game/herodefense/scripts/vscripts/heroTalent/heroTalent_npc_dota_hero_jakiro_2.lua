LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_jakiro_2", "heroTalent/heroTalent_npc_dota_hero_jakiro_2.lua", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_jakiro_2 = class({})

function heroTalent_npc_dota_hero_jakiro_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_jakiro_2"
end
function heroTalent_npc_dota_hero_jakiro_2:GetCurrentWave()
	return "modifier_heroTalent_npc_dota_hero_jakiro_2"
end
---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_jakiro_2 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_jakiro_2:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_jakiro_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_jakiro_2:GetTexture()
	if self:GetStackCount() == 1 then
		return "jakiro_liquid_fire"
	end	
	if self:GetStackCount() == 0 then
		return "jakiro_liquid_ice"
	end	
	return "jakiro/jakiro_ti10_immortal_ability_icon/jakiro_ti10_immortal_macropyre"
end

function modifier_heroTalent_npc_dota_hero_jakiro_2:OnCreated(params)
	self.ability = self:GetAbility()
	self.single_spell_amp = self.ability:GetSpecialValueFor("single_spell_amp")
	self.single_range = self.ability:GetSpecialValueFor("single_range")
	self.double_cd = self.ability:GetSpecialValueFor("double_cd")
	self.double_mp_regen = self.ability:GetSpecialValueFor("double_mp_regen")*0.01
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")

	self.currentRound = 0
	self:SetStackCount(0)
	self.level = 0
	if IsServer() then
		self:StartIntervalThink(3)
	end
end

function modifier_heroTalent_npc_dota_hero_jakiro_2:OnIntervalThink()
	self.currentRound = GetWave()
	self.level = self:GetParent():GetLevel()
	if self.currentRound % 2 == 1 then
		-- 奇数回合 
		self:SetStackCount(1)
	else
		-- 偶数回合
		self:SetStackCount(0)
	end

	if (_G.GAME_ROUND == 21 or _G.GAME_ROUND == 26) and  _G.GAME_END_WAVE_Trigger == true then
		self:SetStackCount(2)
	end
end

function modifier_heroTalent_npc_dota_hero_jakiro_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP, -- 处理输出伤害
	}
end
function modifier_heroTalent_npc_dota_hero_jakiro_2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION, -- 处理冷却缩减
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, -- 处理魔法恢复
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_heroTalent_npc_dota_hero_jakiro_2:Advanced_GetModifierSpellAmplifyBonus()
	if self:GetStackCount() == 1 or self:GetStackCount() == 2 then
		return self.single_spell_amp
	end
	return 
end
function modifier_heroTalent_npc_dota_hero_jakiro_2:Advanced_GetModifierCastRangeBonusStacking()
	if self:GetStackCount() == 1 or self:GetStackCount() == 2 then
		return self.single_range
	end
	return 
end
function modifier_heroTalent_npc_dota_hero_jakiro_2:Advanced_GetModifierCooldownReduction()
	if self:GetStackCount() == 0 or self:GetStackCount() == 2 then
		return self.double_cd
	end
	return 
end
function modifier_heroTalent_npc_dota_hero_jakiro_2:AdvancedGetModifierConstantManaRegen()
	if self:GetStackCount() == 0 or self:GetStackCount() == 2 then
		return self.double_mp_regen*self:GetParent():GetMaxMana()
	end
	return 
end
function modifier_heroTalent_npc_dota_hero_jakiro_2:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if not IsServer() then return end
	if IsIceDamage(keys) or IsFireDamage(keys) then
		return self.level*self.outgoing
	end
	return 
end

function modifier_heroTalent_npc_dota_hero_jakiro_2:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierSpellAmplifyBonus()
	end
	if self._tooltip == 2 then
		return self:Advanced_GetModifierCastRangeBonusStacking()
	end
	if self._tooltip == 3 then
		return self:Advanced_GetModifierCooldownReduction()
	end
	if self._tooltip == 4 then
		return self:AdvancedGetModifierConstantManaRegen()
	end
end