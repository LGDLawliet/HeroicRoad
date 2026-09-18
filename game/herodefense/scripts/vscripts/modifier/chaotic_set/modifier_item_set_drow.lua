modifier_item_set_drow = advanced_modifier({})

function modifier_item_set_drow:IsDebuff()return false end
function modifier_item_set_drow:IsHidden()return true end
function modifier_item_set_drow:IsPurgable()return false end
function modifier_item_set_drow:RemoveOnDeath()return false end

function modifier_item_set_drow:Precache( context )
	PrecacheResource( "particle", "particles/neutral_fx/neutral_item_drop_lvl5.vpcf", context )
end

function modifier_item_set_drow:ADDeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH ={nil, self:GetParent()}
	}
end

function modifier_item_set_drow:OnDeath(keys)
    if self:GetParent() ~= keys.unit then
        return
    end
    local random = math.random

    if self:GetParent():GetUnitName() == "npc_monster_wave_5_1_chaotic" then
        local chance = 7
        if chance >= random(1,100) then
            self:SetDrow_Storm()
        end
    end
    if self:GetParent():GetUnitName() == "npc_monster_wave_immortal_stumps" then
        local chance = 7
        if chance >= random(1,100) then
            self:SetDrow_Tree()
        end
    end
    if self:GetParent():GetUnitName() == "npc_monster_wave_undead_skeleton_archer" then
        local chance = 4
        if chance >= random(1,100) then
            self:SetDrow_Rbone()
        end
    end
    if self:GetParent():GetUnitName() == "npc_monster_wave_undead_skeleton_walker" then
        local chance = 4
        if chance >= random(1,100) then
            self:SetDrow_Mbone()
        end
    end
    --if self:GetParent():GetUnitName() == "npc_monster_wave_thirsty_servant" then
    if self:GetParent():GetUnitName() == "npc_monster_wave_thirsty_assassin" then
        local chance = 3
        if chance >= random(1,100) then
            self:SetDrow_Asasin()
        end
    end
    if self:GetParent():GetUnitName() == "npc_monster_wave_chaotic_executive" then
        local chance = 15
        if chance >= random(1,100) then
            self:SetDrow_ChaosElement()
        end
    end
    
end

function modifier_item_set_drow:SetDrow_Storm()
    if not IsServer() then
        return
    end
    local storm_1 = CreateItem( "item_set_storm_amulet", nil, nil )
    local storm_2 = CreateItem( "item_set_storm_boot", nil, nil )
    local storm_3 = CreateItem( "item_set_storm_book", nil, nil )
    local storm_4 = CreateItem( "item_set_storm_armor", nil, nil )
    local newItem = nil
    local random = math.random(1,4)
    if random == 1 then
        newItem = storm_1
    end
    if random == 2 then
        newItem = storm_2
    end
    if random == 3 then
        newItem = storm_3
    end
    if random == 4 then
        newItem = storm_4
    end
    if newItem then
        local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
        self.base_target = self:GetParent():GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(self:GetParent(), self.vector)
    
        newItem:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = newItem:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_set_drow_info"
        gameEvent["locstring_value"] = "#npc_monster_wave_5_1"
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..newItem:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end

function modifier_item_set_drow:SetDrow_Tree()
    if not IsServer() then
        return
    end
    local storm_1 = CreateItem( "item_set_tree_amulet", nil, nil )
    local storm_2 = CreateItem( "item_set_tree_boot", nil, nil )
    local storm_3 = CreateItem( "item_set_tree_lance", nil, nil )
    local storm_4 = CreateItem( "item_set_tree_armor", nil, nil )
    local newItem = nil
    local random = math.random(1,4)
    if random == 1 then
        newItem = storm_1
    end
    if random == 2 then
        newItem = storm_2
    end
    if random == 3 then
        newItem = storm_3
    end
    if random == 4 then
        newItem = storm_4
    end
    if newItem then
        local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
        self.base_target = self:GetParent():GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(self:GetParent(), self.vector)
    
        newItem:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = newItem:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_set_drow_info"
        gameEvent["locstring_value"] = "#npc_monster_wave_immortal_stumps"
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..newItem:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end

function modifier_item_set_drow:SetDrow_Rbone()
    if not IsServer() then
        return
    end
    local storm_1 = CreateItem( "item_set_rbone_bow", nil, nil )
    local storm_2 = CreateItem( "item_set_rbone_quiver", nil, nil )

    local newItem = nil
    local random = math.random(1,2)
    if random == 1 then
        newItem = storm_1
    end
    if random == 2 then
        newItem = storm_2
    end

    if newItem then
        local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
        self.base_target = self:GetParent():GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(self:GetParent(), self.vector)
    
        newItem:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = newItem:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_set_drow_info"
        gameEvent["locstring_value"] = "#npc_monster_wave_undead_skeleton_archer"
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..newItem:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end

function modifier_item_set_drow:SetDrow_Mbone()
    if not IsServer() then
        return
    end
    local storm_1 = CreateItem( "item_set_mbone_sword", nil, nil )
    local storm_2 = CreateItem( "item_set_mbone_shield", nil, nil )

    local newItem = nil
    local random = math.random(1,2)
    if random == 1 then
        newItem = storm_1
    end
    if random == 2 then
        newItem = storm_2
    end

    if newItem then
        local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
        self.base_target = self:GetParent():GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(self:GetParent(), self.vector)
    
        newItem:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = newItem:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_set_drow_info"
        gameEvent["locstring_value"] = "#npc_monster_wave_undead_skeleton_walker"
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..newItem:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end

function modifier_item_set_drow:SetDrow_Asasin()
    if not IsServer() then
        return
    end
    local item_table = {
        "item_set_asasin_blade",
        "item_set_asasin_blade_2",
    }
    local random = math.random
    --print("进行随机判定")
    local newItem = CreateItem(item_table[random(1,2)],nil,nil)
    --print("newitem已经生成")

    if newItem then
        local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
        self.base_target = self:GetParent():GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(self:GetParent(), self.vector)
    
        newItem:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = newItem:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_set_drow_info"
        gameEvent["locstring_value"] = "#npc_monster_wave_thirsty_assassin"
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..newItem:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end

function modifier_item_set_drow:SetDrow_ChaosElement()
    if not IsServer() then
        return
    end

    local newItem = CreateItem("item_set_chaos_food",nil,nil)


    if newItem then
        local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
        self.base_target = self:GetParent():GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(self:GetParent(), self.vector)
    
        newItem:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = newItem:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_set_normal_drow_info"
        gameEvent["locstring_value"] = "#npc_monster_wave_chaotic_executive"
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_ability_"..newItem:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
    end
end