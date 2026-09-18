LinkLuaModifier("modifier_item_new_bottle_2", "items/item_new_bottle_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_2_active", "items/item_new_bottle_2", LUA_MODIFIER_MOTION_NONE)

item_new_bottle_2 = class({})

function item_new_bottle_2:OnSpellStart()
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
    caster:AddNewModifier(caster, self, "modifier_item_new_bottle_2", {})
    for itemSlot = 0, 9 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() then
			UTIL_RemoveImmediate(item)
			break
		end
	end
end
-----------------------------------------------
modifier_item_new_bottle_2 = advanced_modifier({})

function modifier_item_new_bottle_2:IsDebuff()return false end
function modifier_item_new_bottle_2:IsHidden()return false end
function modifier_item_new_bottle_2:IsPurgable()return false end
function modifier_item_new_bottle_2:RemoveOnDeath()return false end
function modifier_item_new_bottle_2:GetTexture()return "item_bottle_regeneration" end
