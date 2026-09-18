LinkLuaModifier("modifier_item_new_bottle_sup", "items/item_new_bottle_sup", LUA_MODIFIER_MOTION_NONE)


item_new_bottle_sup = class({})


function item_new_bottle_sup:OnSpellStart()
    if not IsServer() then
        return
    end

	local caster = self:GetCaster()

    local item = caster:FindItemInInventory("item_new_bottle_sup")
    if item ~=nil then
        caster:AddNewModifier(caster, self, "modifier_item_new_bottle_sup", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end
-----------------------------------------------
modifier_item_new_bottle_sup = advanced_modifier({})

function modifier_item_new_bottle_sup:IsDebuff()return false end
function modifier_item_new_bottle_sup:IsHidden()return false end
function modifier_item_new_bottle_sup:IsPurgable()return false end
function modifier_item_new_bottle_sup:RemoveOnDeath()return false end
function modifier_item_new_bottle_sup:DestroyOnExpire()	return false end
function modifier_item_new_bottle_sup:GetTexture()	return "item_doubloon_maxmana" end
function modifier_item_new_bottle_sup:OnCreated()
    
    if IsServer() then
        self:StartIntervalThink(1)
    end
end
function modifier_item_new_bottle_sup:OnIntervalThink()
    if not Game_State:IsInBattle() then
        return 
    end
    local parent = self:GetParent()
    local item = parent:FindItemInInventory("item_new_bottle")
    if item then
        local charge = item:GetCurrentCharges()
        if charge < item:GetBottleMaxCharge() then
            if self:GetRemainingTime() <= 0 then
                item:SetCurrentCharges(charge + 1)
                self:SetDuration(40, true)
                parent:EmitSound("Hero_Phoenix.FireSpirits.Launch")
            end
        end
    end
end
