LinkLuaModifier("modifier_item_new_bottle_4", "items/item_new_bottle_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_4_active", "items/item_new_bottle_4", LUA_MODIFIER_MOTION_NONE)

item_new_bottle_4 = class({})

function item_new_bottle_4:OnSpellStart()
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
    caster:AddNewModifier(caster, self, "modifier_item_new_bottle_4", {})
    for itemSlot = 0, 9 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() then
			UTIL_RemoveImmediate(item)
			break
		end
	end
end
-----------------------------------------------
modifier_item_new_bottle_4 = advanced_modifier({})

function modifier_item_new_bottle_4:IsDebuff()return false end
function modifier_item_new_bottle_4:IsHidden()return false end
function modifier_item_new_bottle_4:IsPurgable()return false end
function modifier_item_new_bottle_4:RemoveOnDeath()return false end
function modifier_item_new_bottle_4:GetTexture()return "item_bottle4" end
-----------------------------------------------
modifier_item_new_bottle_4_active = advanced_modifier({})

function modifier_item_new_bottle_4_active:IsDebuff()return false end
function modifier_item_new_bottle_4_active:IsHidden()return true end
function modifier_item_new_bottle_4_active:IsPurgable()return false end
function modifier_item_new_bottle_4_active:RemoveOnDeath()return false end
function modifier_item_new_bottle_4_active:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
        self:GetParent():Purge(false, true, false, false, false)--弱驱散

    end
end

function modifier_item_new_bottle_4_active:OnIntervalThink()
    self:GetParent():Purge(false, true, false, false, false)--弱驱散
end