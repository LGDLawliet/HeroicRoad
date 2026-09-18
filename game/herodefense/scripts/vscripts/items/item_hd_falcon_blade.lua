item_hd_falcon_blade = class({})
-- LinkLuaModifier("modifier_item_hd_falcon_blade_arua", "items/item_hd_falcon_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_falcon_blade_arua_effect", "items/item_hd_falcon_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_falcon_blade", "items/item_hd_falcon_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_falcon_blade_active", "items/item_hd_falcon_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_falcon_blade_active_standby", "items/item_hd_falcon_blade", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_falcon_blade_active_debuff", "items/item_hd_falcon_blade", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_falcon_blade:GetIntrinsicModifierName()
	return "modifier_item_hd_falcon_blade"
end



-- function item_hd_falcon_blade:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("DOTA_Item.Sheepstick.Activate")
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_falcon_blade_active", {duration = 3.5*StatusResistance})
-- end


-- modifier_item_hd_falcon_blade_arua = class({})

-- function modifier_item_hd_falcon_blade_arua:IsHidden() return true end
-- function modifier_item_hd_falcon_blade_arua:IsAura() return true end
-- function modifier_item_hd_falcon_blade_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_falcon_blade_arua:GetModifierAura() return "modifier_item_hd_falcon_blade_arua_effect" end
-- function modifier_item_hd_falcon_blade_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_falcon_blade_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_falcon_blade_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_falcon_blade_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_falcon_blade = class({})

function modifier_item_hd_falcon_blade:IsDebuff() return false end
function modifier_item_hd_falcon_blade:IsHidden() return true end
function modifier_item_hd_falcon_blade:IsPurgable() return false end
-- function modifier_item_hd_falcon_blade:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_falcon_blade:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_falcon_blade:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    if IsServer() then

	end
end



function modifier_item_hd_falcon_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --发起攻击
		

	}
end


function modifier_item_hd_falcon_blade:GetModifierHealthBonus()	return self.bonus_health end

function modifier_item_hd_falcon_blade:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_falcon_blade:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If there isn't a valid target, do nothing
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return nil
		end
		if keys.damage <=0 then		return		end
		if self:GetParent() == attacker and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local target_mana_burn = math.min(target:GetMana(),3)
			target:Script_ReduceMana(target_mana_burn,self:GetAbility())
			local health = (target_mana_burn*3)
			self:GetParent():Heal(health, self:GetParent())


		end
	end
end