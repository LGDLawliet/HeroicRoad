
if CustomIndicator == nil then
    _G.CustomIndicator = class({})
end

CustomIndicator.particle = nil

ListenToGameEvent("ability_custom_indicator",Dynamic_Wrap(CustomIndicator, "OnCustomIndicatorEvent"), CustomIndicator)

function CustomIndicator:OnCustomIndicatorEvent(params)
    local owner = EntIndexToHScript(params.ownerIndex)
    local target = nil
    if params.targetIndex ~= nil then
        target = EntIndexToHScript(params.targetIndex)
    end

    local startLocation = nil
    if params.startX ~= nil then
        startLocation = Vector(params.startX,params.startY,params.startZ)
    end

    local forward = nil
    if params.forwardX ~= nil then
        forward = Vector(params.forwardX,params.forwardY,params.forwardZ)
    end

    local overlap = false
    if params.overlap ~= nil then
        overlap = params.overlap == 1 and true or false
    end
    -- if IsServer() then
    --     CustomGameEventManager:Send_ServerToPlayer(owner:GetPlayerOwner(), "ability_custom_indicator", params)
    -- end

    if owner ~= nil then
        local ability = owner:FindAbilityByName(params.abilityName)
        if ability~= nil then
           self:CheckEventType(params.type,owner,target,ability,Vector(params.x,params.y,params.z),startLocation,forward,overlap,params.AOERadius)
        end
    end
end

function CustomIndicator:CheckEventType(type,owner,target,ability,location,startLocation,forward,overlap,AOERadius)
    if type == "vector_select_start" then
        self:DoVectorAbilitySelectStart(owner,target,ability,location,AOERadius)
    elseif type == "select_start" then
        self:DoAbilitySelectStart(owner,ability,AOERadius)
    elseif type == "vector_selecting" then
        self:DoVectorAbilitySelecting(owner,ability,location,startLocation,target,forward,overlap)
    elseif type == "selecting" then
        self:DoAbilitySelecting(owner,ability,location)
    elseif type == "select_end" then
        self:DoAbilitySelectEnd(owner,ability)
    end
end

function CustomIndicator:DoAbilitySelectStart(owner,ability,AOERadius)
    if ability:IsEnableDefulatIndicator() then

        if self.particle ~= nil then
            ParticleManager:DestroyParticle(self.particle,true)
            ParticleManager:ReleaseParticleIndex(self.particle)
            self.particle = nil
        end

        -- check if the ability exists and if it is Vector targeting

        local behavior = ability:GetBehaviorInt()
        if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
            self.particle = ParticleManager:CreateParticle("particles/ui_mouseactions/custom_range_finder_generic_aoe.vpcf",PATTACH_ABSORIGIN_FOLLOW,owner)
        elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
            self.particle = ParticleManager:CreateParticle("particles/ui_mouseactions/custom_range_finder_targeted_aoe.vpcf",PATTACH_ABSORIGIN_FOLLOW,owner)
        end

        if self.particle ~= nil then
            ParticleManager:SetParticleControlEnt(self.particle,0, owner,PATTACH_ABSORIGIN_FOLLOW,"",Vector(0,0,0),true)
            ParticleManager:SetParticleControlEnt(self.particle,1, owner,PATTACH_ABSORIGIN_FOLLOW,"",Vector(0,0,0),true)
            ParticleManager:SetParticleControl(self.particle, 2, owner:GetAbsOrigin())
            if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) == 0 then
                ParticleManager:SetParticleControl(self.particle,3, Vector(AOERadius == nil and 0 or AOERadius,0,0))
            end
        end
    else
        ability:OnAbilitySelectStart(owner)
    end
end

function CustomIndicator:DoVectorAbilitySelectStart(owner,target,ability,location,AOERadius)
    if ability:IsEnableDefulatIndicator() then
        if self.particle ~= nil then
            ParticleManager:DestroyParticle(self.particle,true)
            ParticleManager:ReleaseParticleIndex(self.particle)
            self.particle = nil
        end

        if AOERadius == nil or AOERadius <= 0 then
            self.particle = ParticleManager:CreateParticle("particles/ui_mouseactions/custom_range_finder_cone.vpcf",PATTACH_ABSORIGIN,owner)
            ParticleManager:SetParticleControl(self.particle, 3, Vector(ability:GetVectorTargetStartRadius(),ability:GetVectorTargetEndRadius(),0))
            ParticleManager:SetParticleControl(self.particle, 4, Vector(255,0,0))
        else
            --创建AOE矢量特效
        end
        
        local behavior = ability:GetBehaviorInt()
        if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
            ParticleManager:SetParticleControl(self.particle, 0, location)
            ParticleManager:SetParticleControl(self.particle, 1, location)
        elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
            ParticleManager:SetParticleControlEnt(self.particle,0, target,PATTACH_ABSORIGIN_FOLLOW,"",Vector(0,0,0),true)
            ParticleManager:SetParticleControlEnt(self.particle,1, target,PATTACH_ABSORIGIN_FOLLOW,"",Vector(0,0,0),true)
        end

        -- if self.particle ~= nil then
        --     ParticleManager:SetParticleControlEnt(self.particle,0, owner,PATTACH_ABSORIGIN_FOLLOW,"",Vector(0,0,0),true)
        --     ParticleManager:SetParticleControlEnt(self.particle,1, owner,PATTACH_ABSORIGIN_FOLLOW,"",Vector(0,0,0),true)
        --     ParticleManager:SetParticleControl(self.particle, 2, owner:GetAbsOrigin())
        --     if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) == 0 then
        --         ParticleManager:SetParticleControl(self.particle,3, Vector(AOERadius == nil and 0 or AOERadius,0,0))
        --     end
        -- end
    else
        ability:OnVectorAbilitySelectStart(owner)
    end
end

function CustomIndicator:DoVectorAbilitySelecting(owner,ability,location,startLocation,startTarget,forward,overlap)
    if self.particle ~= nil then

        local minlength = ability:GetVectorMinLength()
        local maxlength = ability:GetVectorMaxLength()

        if maxlength < minlength then
            error("The VectorMinLength is greater than VectorMaxLength")
        end
        
        local behavior = ability:GetBehaviorInt()
        if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
            local endLocation = location
            local ownerLocation = owner:GetAbsOrigin()
            if overlap then
                endLocation = startLocation + (startLocation - ownerLocation):Normalized() * minlength
            else
                local length = (location - startLocation):Length2D()
                if length > maxlength then
                    endLocation = startLocation + (location - startLocation):Normalized() * maxlength
                end
                if length < minlength then
                    endLocation = startLocation + (location - startLocation):Normalized() * minlength
                end
            end
            ParticleManager:SetParticleControl(self.particle, 2, endLocation)
        elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
            local endLocation = location
            local targetLocation = startTarget:GetAbsOrigin()
            if overlap then
                if owner == startTarget then
                    endLocation = targetLocation + forward * minlength
                else
                    endLocation = targetLocation + (targetLocation - owner:GetAbsOrigin()):Normalized() * minlength
                end
            else
                local length = (location - targetLocation):Length2D()
                if length > maxlength then
                    endLocation = targetLocation + (location - targetLocation):Normalized() * maxlength
                end
                if length < minlength then
                    endLocation = targetLocation + (location - targetLocation):Normalized() * minlength
                end
            end
            ParticleManager:SetParticleControl(self.particle, 2, endLocation)
        end 
    end

    ability:OnVectorAbilitySelecting(owner,location)
end

function CustomIndicator:DoAbilitySelecting(owner,ability,location)
    if ability:IsEnableDefulatIndicator() then
        if self.particle ~= nil then
            ParticleManager:SetParticleControl(self.particle, 2, location)
        end
    else
        ability:OnAbilitySelecting(owner,location)
    end
end

function CustomIndicator:DoAbilitySelectEnd(owner,ability)
    if ability:IsEnableDefulatIndicator() then
        if self.particle ~= nil then
            ParticleManager:DestroyParticle(self.particle,true)
            ParticleManager:ReleaseParticleIndex(self.particle)
            self.particle = nil
        end
    else
        ability:OnAbilitySelectEnd(owner)
    end
end


-- function ParticleManager:CreateParticleForLocalPlayer(particle,pattach,owner)
--     local playerid = GetLocalPlayerID()
--     local player = PlayerResource:GetPlayer(playerid)
--     print(playerid)
--     local particle = ParticleManager:CreateParticleForPlayer(particle,pattach,owner,player)
--     return particle
-- end

--是否启用默认特效
function C_DOTABaseAbility:IsEnableDefulatIndicator()
	return true
end

function C_DOTABaseAbility:OnAbilitySelectStart(caster)
    -- print("开始选择目标")
end

function C_DOTABaseAbility:OnVectorAbilitySelectStart(caster)
    -- print("开始选择矢量方向")
end

function C_DOTABaseAbility:OnAbilitySelecting(caster,location)
    -- print("选择目标中..." .. tostring(location))
end

function C_DOTABaseAbility:OnVectorAbilitySelecting(caster,location)
    -- print("选择矢量方向中..." .. tostring(location))
end

function C_DOTABaseAbility:OnAbilitySelectEnd(caster)
    -- print("结束选择目标")
end

function C_DOTABaseAbility:GetVectorMinLength()
    local name = self:GetName()
    if name == "shadow_shaman_serpentine" then
        return self:GetSpecialValueFor("length")
    elseif name == "windrunner_gale_force" then
        return self:GetSpecialValueFor("radius")
    elseif name == "pangolier_swashbuckle" then
        return self:GetSpecialValueFor("range")
    end
	return 0
end 

function C_DOTABaseAbility:GetVectorMaxLength()
    local name = self:GetName()
    if name == "shadow_shaman_serpentine" then
        return self:GetSpecialValueFor("length")
    elseif name == "windrunner_gale_force" then
        return self:GetSpecialValueFor("radius")
    elseif name == "pangolier_swashbuckle" then
        return self:GetSpecialValueFor("range")
    end
	return 999999
end

function C_DOTABaseAbility:GetVectorTargetStartRadius()
	return 125
end 

function C_DOTABaseAbility:GetVectorTargetEndRadius()
	return self:GetVectorTargetStartRadius()
end

function C_DOTABaseAbility:IsDualVectorDirection()
	return false
end