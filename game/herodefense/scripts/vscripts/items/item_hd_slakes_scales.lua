item_hd_slakes_scales = class({})
-- LinkLuaModifier("modifier_item_hd_slakes_scales_arua", "items/item_hd_slakes_scales", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_slakes_scales_arua_effect", "items/item_hd_slakes_scales", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slakes_scales", "items/item_hd_slakes_scales", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slakes_scales_active", "items/item_hd_slakes_scales", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_slakes_scales_active_standby", "items/item_hd_slakes_scales", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_slakes_scales_active_debuff", "items/item_hd_slakes_scales", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_slakes_scales:GetIntrinsicModifierName()
	return "modifier_item_hd_slakes_scales"
end



-- function item_hd_slakes_scales:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_slakes_scales_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_slakes_scales_arua = class({})

-- function modifier_item_hd_slakes_scales_arua:IsHidden() return true end
-- function modifier_item_hd_slakes_scales_arua:IsAura() return true end
-- function modifier_item_hd_slakes_scales_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_slakes_scales_arua:GetModifierAura() return "modifier_item_hd_slakes_scales_arua_effect" end
-- function modifier_item_hd_slakes_scales_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_slakes_scales_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_slakes_scales_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_slakes_scales_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_slakes_scales = class({})

function modifier_item_hd_slakes_scales:IsDebuff() return false end
function modifier_item_hd_slakes_scales:IsHidden() return true end
function modifier_item_hd_slakes_scales:IsPurgable() return false end
-- function modifier_item_hd_slakes_scales:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_slakes_scales:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_slakes_scales:OnCreated(keys)
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
	-- self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	-- self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	-- self.bonus_heal_receive_amplification = self.ability:GetSpecialValueFor("bonus_heal_receive_amplification")
    if IsServer() then

	end
end

function modifier_item_hd_slakes_scales:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件


	}
end



function modifier_item_hd_slakes_scales:OnTakeDamage(keys)
    if IsServer() then  
		-- print(keys.unit == self:GetParent()) 
		-- print(self:GetParent():GetHealthPercent())
		-- print(self:GetAbility():IsCooldownReady())
		if keys.unit == self:GetParent() and self:GetParent():GetHealthPercent()<10 and self:GetAbility():IsCooldownReady() then
			-- print("damage")
			self:GetAbility():StartCooldown(25)
			self.modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_slakes_scales_active", {duration = 1})
		end

    end 
end





modifier_item_hd_slakes_scales_active = advanced_modifier({})

function modifier_item_hd_slakes_scales_active:IsDebuff() return false end
function modifier_item_hd_slakes_scales_active:IsHidden() return false end
function modifier_item_hd_slakes_scales_active:IsPurgable() return true end
function modifier_item_hd_slakes_scales_active:GetTexture()return "item_slakes_scales" end
function modifier_item_hd_slakes_scales_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_slakes_scales_active:OnCreated()
	if IsServer() then
		--0, 1 absorigin
		--3 attach_eyeR
		--4 attach_eyeL
		--特效
		local pfx_name = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
		local pfx = ParticleManager:CreateParticleForTeam(pfx_name, PATTACH_CUSTOMORIGIN, nil, self:GetParent():GetTeamNumber())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeR", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeL", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)

	end
end

function modifier_item_hd_slakes_scales_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end



function modifier_item_hd_slakes_scales_active:CheckState()		return {[MODIFIER_STATE_INVISIBLE] = true} end
function modifier_item_hd_slakes_scales_active:AdvancedGetModifierConstantHealthRegenPercentage()return 5 end

