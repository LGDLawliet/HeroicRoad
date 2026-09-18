
item_chaotic_oracle_box = class({})

function item_chaotic_oracle_box:OnSpellStart()
	if IsServer() then
        local random = math.random(1,100)
        local newItem
        local pfx
        local caster = self:GetCaster()

        if random >= 1 and random < 35 then
            newItem = "item_hd_gold_bag"
            pfx = "particles/neutral_fx/neutral_item_drop_lvl0.vpcf"
        elseif random >= 35 and random < 70 then
            newItem = "item_hd_dust"
            pfx = "particles/neutral_fx/neutral_item_drop_lvl0.vpcf"
        elseif random >= 70 and random < 88 then
            newItem = "item_secret_of_experience"
            pfx = "particles/neutral_fx/neutral_item_drop_lvl4.vpcf"
        elseif random >= 88 and random < 94 then
            newItem = "item_hd_rubick_cube"
            pfx = "particles/neutral_fx/neutral_item_drop_lvl5.vpcf"
        elseif random >= 94 and random <= 100 then
            newItem = "item_hd_rubick_cube2"
            pfx = "particles/neutral_fx/neutral_item_drop_lvl5.vpcf"
        end

        self:GetCaster():AddItemByName(newItem)

        local pos = self:GetCaster():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle(pfx, PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end

        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_oracle_box_info"
        gameEvent["locstring_value"] = "#DOTA_Tooltip_ability_"..newItem
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )

        local item = caster:FindItemInInventory("item_chaotic_oracle_box")
		if item ~=nil then
            UTIL_RemoveImmediate(item) --removeitem的暂时替代
        end
	end
end

