item_chaotic_skill_book_1 = item_chaotic_skill_book_1 or class({})
function item_chaotic_skill_book_1:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 1)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_2 = item_chaotic_skill_book_2 or class({})
function item_chaotic_skill_book_2:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 2)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_3 = item_chaotic_skill_book_3 or class({})
function item_chaotic_skill_book_3:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 3)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_4 = item_chaotic_skill_book_4 or class({})
function item_chaotic_skill_book_4:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 4)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_5 = item_chaotic_skill_book_5 or class({})
function item_chaotic_skill_book_5:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 5)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_6 = item_chaotic_skill_book_6 or class({})
function item_chaotic_skill_book_6:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 6)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_7 = item_chaotic_skill_book_7 or class({})
function item_chaotic_skill_book_7:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 7)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_8 = item_chaotic_skill_book_8 or class({})
function item_chaotic_skill_book_8:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 8)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_9 = item_chaotic_skill_book_9 or class({})
function item_chaotic_skill_book_9:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 9)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_random_rune = item_chaotic_skill_book_random_rune or class({})
function item_chaotic_skill_book_random_rune:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, 0)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end

item_chaotic_skill_book_random_general = item_chaotic_skill_book_random_general or class({})
function item_chaotic_skill_book_random_general:OnSpellStart()
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    if playerid and caster:IsHero() then
        chaotic_era:GenerateSpellList_Genaral(playerid, -1)
        self:SpendCharge(0)
    else
        self:StartCooldown(2)
    end
end