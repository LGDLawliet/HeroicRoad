





function EpicenterTriggerAfterShock(caster)
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        local modifier = hero:FindModifierByName("modifier_Advanced_aftershock_unlock1_effect")
        if modifier then
            if caster==hero then
                modifier:Trigger(3,caster)
            else
                modifier:Trigger(4,caster)
            end
        end
        
    end
end