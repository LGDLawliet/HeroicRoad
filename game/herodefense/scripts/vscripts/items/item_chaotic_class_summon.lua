LinkLuaModifier( "modifier_item_chaotic_class_summon", "items/item_chaotic_class_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_summon_active", "items/item_chaotic_class_summon", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_summon = class({})

function item_chaotic_class_summon:OnSpellStart()
	if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_summon")
    if item ~=nil then
		local modifier = caster:FindModifierByName("modifier_item_chaotic_class_range_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_melee_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_summon")
		or caster:FindModifierByName("modifier_item_chaotic_class_ass")

		if modifier then
			modifier:Destroy()
		end
        caster:AddNewModifier(caster, nil, "modifier_item_chaotic_class_summon", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

modifier_item_chaotic_class_summon = advanced_modifier({})

function modifier_item_chaotic_class_summon:IsDebuff()return false end
function modifier_item_chaotic_class_summon:IsHidden()return false end
function modifier_item_chaotic_class_summon:IsPurgable()return false end
function modifier_item_chaotic_class_summon:RemoveOnDeath()return false end
function modifier_item_chaotic_class_summon:DestroyOnExpire()	return false end
function modifier_item_chaotic_class_summon:GetTexture()	return "item_helm_of_the_dominator" end

function modifier_item_chaotic_class_summon:OnCreated(params)
	self.summon = 15
	self.bonus_summon = 0.8
	self.base_attack = 50
    self.bonus_base_attack = 8
    self.outgoing = 10

	self.mp_regen = 0.003
	self.speed = 3

	if not IsServer() then return end
	if self:GetParent():HasAbility("chaotic_summon_null") then return end
    if not self.checkingAbility then
		local parent = self:GetParent()
		local maxSlotNumber = skillshop:GetMaxSpellCount(parent)
		if not parent:IsAlive() then
            return
        end
        if skillshop:GetPlayerAbilityNumber(parent) >= maxSlotNumber then
			return
		end
		self.checkingAbility = true
		if parent:HasAbility("chaotic_summon_null") then
			return
		end
		chaotic_era:LearnChaoticEraSpell(parent,"chaotic_summon_null")
	end
end

function modifier_item_chaotic_class_summon:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end

function modifier_item_chaotic_class_summon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_summon:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 5 + 1
	if self._tooltip == 1 then
		return self.outgoing
	end
	if self._tooltip == 2 then
		return self:Advanced_GetModifier_Summon_Intensity()
	end
	if self._tooltip == 3 then
		return self:Advanced_GetModifierBaseAttack_BonusDamage()
	end
	if self._tooltip == 4 then
		return self.speed*self:GetParent():GetLevel()
	end
	if self._tooltip == 5 then
		return self.mp_regen*self:GetParent():GetMaxMana()
	end
end


function modifier_item_chaotic_class_summon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self.outgoing 
end
function modifier_item_chaotic_class_summon:Advanced_GetModifierBaseAttack_BonusDamage()
	return self.base_attack + self.bonus_base_attack*self:GetParent():GetLevel()
end
function modifier_item_chaotic_class_summon:Advanced_GetModifier_Summon_Intensity()
	return self.summon + self.bonus_summon*self:GetParent():GetLevel()
end
function modifier_item_chaotic_class_summon:OnSummonUnit(keys)
	if not IsServer() then
		return
	end
	local target = keys.target
	
	target:AddNewModifier(self:GetParent(),nil,"modifier_item_chaotic_class_summon_active",{speed = self.speed*self:GetParent():GetLevel(), mp = self.mp_regen})
end

---------------------

modifier_item_chaotic_class_summon_active = advanced_modifier({})

function modifier_item_chaotic_class_summon_active:IsDebuff()return false end
function modifier_item_chaotic_class_summon_active:IsHidden()return false end
function modifier_item_chaotic_class_summon_active:IsPurgable()return false end
function modifier_item_chaotic_class_summon_active:GetTexture()	return "item_helm_of_the_dominator" end
function modifier_item_chaotic_class_summon_active:OnCreated(keys)
	if not IsServer() then return end
	self.speed = keys.speed or 80
	self.mp = keys.mp or 0.1
	self:SetStackCount(self.speed)
end
function modifier_item_chaotic_class_summon_active:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_item_chaotic_class_summon_active:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
end
function modifier_item_chaotic_class_summon_active:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end
function modifier_item_chaotic_class_summon_active:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self:GetCaster() then return end
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	
	caster:GiveMana(caster:GetMaxMana()*self.mp)
end

