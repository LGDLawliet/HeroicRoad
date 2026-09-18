item_secret_of_experience = item_secret_of_experience or class({})


function item_secret_of_experience:OnSpellStart()
    -- Ability properties
    self:GetCaster():HeroLevelUp(true)

    self:SpendCharge(0)

    
end

item_secret_of_experience_2 = item_secret_of_experience_2 or class({})

function item_secret_of_experience_2:OnSpellStart()
    -- Ability properties
    self:GetCaster():HeroLevelUp(true)

    self:SpendCharge(0)
end


item_secret_of_experience_3 = item_secret_of_experience_3 or class({})

function item_secret_of_experience_3:OnSpellStart()
    -- Ability properties
    self:GetCaster():HeroLevelUp(true)

    self:SpendCharge(0)
end
