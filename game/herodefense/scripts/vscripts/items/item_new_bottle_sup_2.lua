LinkLuaModifier("modifier_item_new_bottle_sup_2", "items/item_new_bottle_sup_2", LUA_MODIFIER_MOTION_NONE)


item_new_bottle_sup_2 = class({})

function item_new_bottle_sup_2:GetIntrinsicModifierName()
    return "modifier_item_new_bottle_sup_2"
end

function item_new_bottle_sup_2:OnSpellStart()
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_new_bottle_sup_2")
    if item ~=nil then
        caster:AddNewModifier(caster, self, "modifier_item_new_bottle_sup_2", {})
    end
end
-----------------------------------------------
modifier_item_new_bottle_sup_2 = advanced_modifier({})

function modifier_item_new_bottle_sup_2:IsDebuff()return false end
function modifier_item_new_bottle_sup_2:IsHidden()return false end
function modifier_item_new_bottle_sup_2:IsPurgable()return false end
function modifier_item_new_bottle_sup_2:RemoveOnDeath()return false end
function modifier_item_new_bottle_sup_2:DestroyOnExpire()	return false end
function modifier_item_new_bottle_sup_2:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end
function modifier_item_new_bottle_sup_2:OnIntervalThink()
    if not Game_State:IsInBattle() then
        return 
    end
    local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_new_bottle")
    local parent = self:GetParent()
    local charge = item:GetCurrentCharges()
        if charge < item:GetBottleMaxCharge() then
            if self:GetRemainingTime() <= 0 then
                item:SetCurrentCharges(charge + 1)
                self:SetDuration(40, true)
                parent:EmitSound("Hero_Phoenix.FireSpirits.Launch")
            end
        end
end
