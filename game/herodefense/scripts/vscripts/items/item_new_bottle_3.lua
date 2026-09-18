LinkLuaModifier("modifier_item_new_bottle_3", "items/item_new_bottle_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_3_active", "items/item_new_bottle_3", LUA_MODIFIER_MOTION_NONE)

item_new_bottle_3 = class({})

function item_new_bottle_3:OnSpellStart()
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local modifier = 
    caster:FindModifierByName("modifier_item_new_bottle_1") or caster:FindModifierByName("modifier_item_new_bottle_2") or caster:FindModifierByName("modifier_item_new_bottle_3") or caster:FindModifierByName("modifier_item_new_bottle_4")
    or caster:FindModifierByName("modifier_item_new_bottle_5")

    if modifier then
        modifier:SafeDestroy()
    end
    caster:AddNewModifier(caster, self, "modifier_item_new_bottle_3", {})
    for itemSlot = 0, 9 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() then
			UTIL_RemoveImmediate(item)
			break
		end
	end
end
-----------------------------------------------
modifier_item_new_bottle_3 = advanced_modifier({})

function modifier_item_new_bottle_3:IsDebuff()return false end
function modifier_item_new_bottle_3:IsHidden()return false end
function modifier_item_new_bottle_3:IsPurgable()return false end
function modifier_item_new_bottle_3:RemoveOnDeath()return false end
function modifier_item_new_bottle_3:GetTexture()return "item_bottle_doubledamage" end
-----------------------------------------------
modifier_item_new_bottle_3_active = advanced_modifier({})

function modifier_item_new_bottle_3_active:IsDebuff()return false end
function modifier_item_new_bottle_3_active:IsHidden()return true end
function modifier_item_new_bottle_3_active:IsPurgable()return false end
function modifier_item_new_bottle_3_active:RemoveOnDeath()return false end

function modifier_item_new_bottle_3_active:OnCreated()
    if IsServer() then
    end
    self.damage_up = 20
end

function modifier_item_new_bottle_3_active:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_item_new_bottle_3_active:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.damage_up
end