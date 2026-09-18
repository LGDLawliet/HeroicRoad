LinkLuaModifier( "modifier_item_chaotic_class_melee_phy", "items/item_chaotic_class_melee_phy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_melee_phy_active", "items/item_chaotic_class_melee_phy", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_melee_phy = class({})

function item_chaotic_class_melee_phy:OnSpellStart()
	if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_melee_phy")
    if item ~=nil then
        local modifier = caster:FindModifierByName("modifier_item_chaotic_class_range_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_melee_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_summon")
		or caster:FindModifierByName("modifier_item_chaotic_class_ass")

		if modifier then
			modifier:Destroy()
		end
        caster:AddNewModifier(caster, nil, "modifier_item_chaotic_class_melee_phy", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

modifier_item_chaotic_class_melee_phy = advanced_modifier({})

function modifier_item_chaotic_class_melee_phy:IsDebuff()return false end
function modifier_item_chaotic_class_melee_phy:IsHidden()return false end
function modifier_item_chaotic_class_melee_phy:IsPurgable()return false end
function modifier_item_chaotic_class_melee_phy:RemoveOnDeath()return false end
function modifier_item_chaotic_class_melee_phy:DestroyOnExpire()	return false end
function modifier_item_chaotic_class_melee_phy:GetTexture()	return "item_martyrs_plate" end

function modifier_item_chaotic_class_melee_phy:OnCreated(params)
	self.parent = self:GetParent()
    self.incoming = 0.5
    self.regen = 0.1
end

function modifier_item_chaotic_class_melee_phy:ADDeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        -- advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_item_chaotic_class_melee_phy:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_melee_phy:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.parent:GetLevel()*self.incoming
	end
	if self._tooltip == 2 then
		return self.parent:GetLevel()*self.regen
	end
end

function modifier_item_chaotic_class_melee_phy:AdvancedGetModifierConstantHealthRegenPercentage()
    return self.parent:GetLevel()*self.regen
end

function modifier_item_chaotic_class_melee_phy:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.parent:GetLevel()*self.incoming
end

-- function modifier_item_chaotic_class_melee_phy:OnAttackLanded(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if keys.attacker ~= self:GetParent() then
-- 		return
-- 	end
-- 	if keys.target:HasModifier("modifier_item_chaotic_class_melee_phy_active") then
-- 		return
-- 	end
--     if not keys.target:IsAlive() then
--         return
--     end

--     local damageTable = {
--         victim = keys.target,
--         attacker = keys.attacker,
--         damage = self.first_hit * keys.target:GetMaxHealth(),
--         damage_type = DAMAGE_TYPE_PHYSICAL,
--         damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT+DOTA_DAMAGE_FLAG_REFLECTION +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
--         ability = nil,
--         hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
--         }
--     ApplyDamage(damageTable)
--     local heal = self.first_heal*keys.attacker:GetMaxHealth()
--     local fhealing =  HealWithGain(heal,keys.attacker,keys.attacker,nil)
-- 	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,keys.attacker, fhealing, nil) 

-- 	keys.target:AddNewModifier(keys.attacker,nil,"modifier_item_chaotic_class_melee_phy_active",{})
-- end

---------------------

modifier_item_chaotic_class_melee_phy_active = advanced_modifier({})

function modifier_item_chaotic_class_melee_phy_active:IsDebuff()return true end
function modifier_item_chaotic_class_melee_phy_active:IsHidden()return true end
function modifier_item_chaotic_class_melee_phy_active:IsPurgable()return false end
function modifier_item_chaotic_class_melee_phy_active:RemoveOnDeath()return false end

