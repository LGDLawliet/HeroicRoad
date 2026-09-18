LinkLuaModifier("modifier_item_new_bottle_5", "items/item_new_bottle_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_5_active", "items/item_new_bottle_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_5_break", "items/item_new_bottle_5", LUA_MODIFIER_MOTION_NONE)

item_new_bottle_5 = class({})

function item_new_bottle_5:OnSpellStart()
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
    caster:AddNewModifier(caster, self, "modifier_item_new_bottle_5", {})
    for itemSlot = 0, 9 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() then
			UTIL_RemoveImmediate(item)
			break
		end
	end
end
-----------------------------------------------
modifier_item_new_bottle_5 = advanced_modifier({})

function modifier_item_new_bottle_5:IsDebuff()return false end
function modifier_item_new_bottle_5:IsHidden()return false end
function modifier_item_new_bottle_5:IsPurgable()return false end
function modifier_item_new_bottle_5:RemoveOnDeath()return false end
function modifier_item_new_bottle_5:GetTexture()return "item_bottle_water" end
-----------------------------------------------
modifier_item_new_bottle_5_active = advanced_modifier({})

function modifier_item_new_bottle_5_active:IsDebuff()return false end
function modifier_item_new_bottle_5_active:IsHidden()return true end
function modifier_item_new_bottle_5_active:IsPurgable()return false end
function modifier_item_new_bottle_5_active:RemoveOnDeath()return false end
function modifier_item_new_bottle_5_active:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end
function modifier_item_new_bottle_5_active:OnTakeDamage(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if keys.unit:GetTeamNumber() == keys.attacker:GetTeamNumber() then
        return
    end
    keys.unit:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_new_bottle_5_break", {duration = 1})
end
-----------------------------------------------
modifier_item_new_bottle_5_break = advanced_modifier({})

function modifier_item_new_bottle_5_break:IsDebuff()return true end
function modifier_item_new_bottle_5_break:IsHidden()return false end
function modifier_item_new_bottle_5_break:IsPurgable()return false end
function modifier_item_new_bottle_5_break:RemoveOnDeath()return false end
function modifier_item_new_bottle_5_break:GetTexture()return "item_bottle_water" end
function modifier_item_new_bottle_5_break:CheckState()
    return{
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end