item_act2_giant = class({})

function item_act2_giant:Spawn()
	if IsServer() then
		self:SetCurrentCharges(1)
	end
end

function item_act2_giant:OnSpellStart()
    local caster = self:GetCaster()

    for i=0, 10 do
        local item = caster:GetItemInSlot(i)
        if item then
            if string.match(item:GetAbilityName(), "item_act2_") and item:GetAbilityName() ~= "item_act2_giant" and item:GetCurrentCharges() >= 1 then
                print("找到了"..item:GetAbilityName())
                caster:EmitSound("DOTA_Item.HavocHammer.Cast")
                item:SetCurrentCharges(item:GetCurrentCharges() + 1)
                self:SetCurrentCharges(0)

                local giant = caster:FindItemInInventory("item_act2_giant")
                if giant ~= nil then
                    UTIL_RemoveImmediate(giant)
                end
                break
            end
        end
    end
end


