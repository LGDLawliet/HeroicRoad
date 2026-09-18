item_hd_black_king_bar = class({})
-- LinkLuaModifier("modifier_item_hd_black_king_bar_arua", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_black_king_bar_arua_effect", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_black_king_bar", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_black_king_bar_active", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_black_king_bar_active_standby", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_black_king_bar_active_debuff", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_black_king_bar_thinker", "items/item_hd_black_king_bar", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_black_king_bar:GetIntrinsicModifierName()
	return "modifier_item_hd_black_king_bar"
end

function item_hd_black_king_bar:IsRefreshable() return false end

function item_hd_black_king_bar:OnSpellStart()

	local caster    =   self:GetCaster()
	-- local target = self:GetCursorTarget()

	-- EmitSoundOn("DOTA_Item.Orchid.Activate", caster)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_item_hd_black_king_bar_active", {duration = 5*ModifierStatusGain})
	caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
	caster:Purge(false,true,false,false,true)


    -- local hRemnant = CreateUnitByName("npc_dota_thinker", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
    -- hRemnant:ResistSpawneNeutral(false)
    -- hRemnant:AddNewModifier(target, self, "modifier_item_hd_black_king_bar_thinker", { duration = 0.5 })
	-- hRemnant:AddNewModifier(caster, self, "modifier_phased", { duration = 4 })

end


-- modifier_item_hd_black_king_bar_arua = class({})

-- function modifier_item_hd_black_king_bar_arua:IsHidden() return true end
-- function modifier_item_hd_black_king_bar_arua:IsAura() return true end
-- function modifier_item_hd_black_king_bar_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_black_king_bar_arua:GetModifierAura() return "modifier_item_hd_black_king_bar_arua_effect" end
-- function modifier_item_hd_black_king_bar_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_black_king_bar_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_black_king_bar_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_black_king_bar_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_black_king_bar = class({})

function modifier_item_hd_black_king_bar:IsDebuff() return false end
function modifier_item_hd_black_king_bar:IsHidden() return true end
function modifier_item_hd_black_king_bar:IsPurgable() return false end
-- function modifier_item_hd_black_king_bar:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_black_king_bar:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_black_king_bar:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_black_king_bar_active_standby", {duration = 20})

	end
end


function modifier_item_hd_black_king_bar:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力


	}
end


function modifier_item_hd_black_king_bar:GetModifierBonusStats_Strength()	return self.bonus_str end

function modifier_item_hd_black_king_bar:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


modifier_item_hd_black_king_bar_active = class({})

function modifier_item_hd_black_king_bar_active:IsDebuff() return false end
function modifier_item_hd_black_king_bar_active:IsHidden() return false end
function modifier_item_hd_black_king_bar_active:IsPurgable() return false end
function modifier_item_hd_black_king_bar_active:IsPurgeException() return false end
function modifier_item_hd_black_king_bar_active:GetTexture()return "item_black_king_bar" end
function modifier_item_hd_black_king_bar_active:GetEffectName()	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_item_hd_black_king_bar_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_black_king_bar_active:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true,
}
	return state
end



function modifier_item_hd_black_king_bar_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
	}
end


function modifier_item_hd_black_king_bar_active:GetModifierMagicalResistanceBonus(keys)
	return 200
end

