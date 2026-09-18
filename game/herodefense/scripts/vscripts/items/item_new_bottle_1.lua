LinkLuaModifier("modifier_item_new_bottle_1", "items/item_new_bottle_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_1_active", "items/item_new_bottle_1", LUA_MODIFIER_MOTION_NONE)

item_new_bottle_1 = class({})

function item_new_bottle_1:OnSpellStart()
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
    caster:AddNewModifier(caster, self, "modifier_item_new_bottle_1", {})
    for itemSlot = 0, 9 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() then
			UTIL_RemoveImmediate(item)
			break
		end
	end
end
-----------------------------------------------
modifier_item_new_bottle_1 = advanced_modifier({})

function modifier_item_new_bottle_1:IsDebuff()return false end
function modifier_item_new_bottle_1:IsHidden()return false end
function modifier_item_new_bottle_1:IsPurgable()return false end
function modifier_item_new_bottle_1:RemoveOnDeath()return false end
function modifier_item_new_bottle_1:GetTexture()return "item_bottomless_chalice" end
