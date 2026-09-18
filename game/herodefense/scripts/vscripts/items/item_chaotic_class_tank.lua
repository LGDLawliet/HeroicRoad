LinkLuaModifier( "modifier_item_chaotic_class_tank", "items/item_chaotic_class_tank.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_tank_active", "items/item_chaotic_class_tank.lua", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_tank = class({})

function item_chaotic_class_tank:OnSpellStart()
	if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_tank")
    if item ~=nil then
        caster:AddNewModifier(caster, self, "modifier_item_chaotic_class_tank", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

modifier_item_chaotic_class_tank = advanced_modifier({})

function modifier_item_chaotic_class_tank:IsDebuff()return false end
function modifier_item_chaotic_class_tank:IsHidden()return false end
function modifier_item_chaotic_class_tank:IsPurgable()return false end
function modifier_item_chaotic_class_tank:RemoveOnDeath()return false end
function modifier_item_chaotic_class_tank:DestroyOnExpire()	return false end
function modifier_item_chaotic_class_tank:GetTexture()	return "item_fluffy_hat" end

function modifier_item_chaotic_class_tank:OnCreated(params)
	self.hp_max = 1
	self.duration = 1
	self.interval = 15
	self.bonus_hp = 70
	self.incoming = 25
	self.outgoing_down = 45
end

function modifier_item_chaotic_class_tank:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end

function modifier_item_chaotic_class_tank:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_tank:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if keys.attacker:IsChaoticEraElite() or keys.attacker:IsChaoticEraBoss() then
		return -self.incoming
	end
	return 0
end

function modifier_item_chaotic_class_tank:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return -self.outgoing_down
end

function modifier_item_chaotic_class_tank:AdvancedGetModifierHealthBonus()
	local hp = self:GetParent():GetLevel()*self.bonus_hp
	return hp + self:GetStackCount()
end

function modifier_item_chaotic_class_tank:OnTooltip()
	local hp = self:GetParent():GetLevel()*self.bonus_hp
	return hp + self:GetStackCount()
end


function modifier_item_chaotic_class_tank:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return
	end
	self:GetParent():AddNewModifier(self:GetParent(),nil,"modifier_item_chaotic_class_tank_active",{duration = self.duration})
end

function modifier_item_chaotic_class_tank:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if self:GetRemainingTime() > 0 then
		return
	end
	local modifier = keys.attacker:FindModifierByName("modifier_item_chaotic_class_tank_active")
	if not modifier then
		return
	end
	modifier:SafeDestroy()

	self:SetDuration(self.interval, true)
	self:SetStackCount(self:GetStackCount() + self:GetParent():GetLevel()*self.hp_max)
end

---------------------

modifier_item_chaotic_class_tank_active = advanced_modifier({})

function modifier_item_chaotic_class_tank_active:IsDebuff()return false end
function modifier_item_chaotic_class_tank_active:IsHidden()return false end
function modifier_item_chaotic_class_tank_active:IsPurgable()return false end
function modifier_item_chaotic_class_tank_active:RemoveOnDeath()return false end
function modifier_item_chaotic_class_tank_active:GetTexture()	return "item_fluffy_hat" end

function modifier_item_chaotic_class_tank_active:OnCreated(params)
	self.hp_regen = 0.03
end

function modifier_item_chaotic_class_tank_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end

function modifier_item_chaotic_class_tank_active:AdvancedGetModifierConstantHealthRegenPercentage()
	return self:GetParent():GetLevel()*self.hp_regen
end

