if IsServer() then
        -- 是否为圣物
        function CDOTA_Item:IsArtifact()
            local name = self:GetAbilityName()
            if  KeyValues.palyer_artifactKV[name] then
                return true
            end
    
            return false
        end
    
        -- 圣物是否可用（满足需求等级）
        function CDOTA_Item:IsArtifactEquip()
            local name = self:GetAbilityName()
            if  KeyValues.palyer_artifactKV[name] then
                local level_require = KeyValues.palyer_artifactKV[name].RequireLevel
                local abilityValue = KeyValues.palyer_artifactKV[name].AbilityValues
                local artifactLevel = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),name)
                local level = self:GetParent():GetLevel()

                local list = self:GetArtifactSpecialList()
                local steamID =  tostring(PlayerResource:GetSteamID(self:GetParent():GetPlayerOwnerID()))
                if list[steamID] then
                    local reduction = math.floor(self:GetArtifactSpecialListLevelRequireReduction__Pct()*0.01 * level_require) + self:GetArtifactSpecialListLevelRequireReduction__Con()
                    level_require = level_require - reduction
                end

                print("level_require1=",level_require)
                if level>=level_require then
                    return true
                end

                for _key, _value in pairs(abilityValue) do
                    -- print("1111111111")
                    if type(_value) == "table" then
                        if _value["_equip_level_require_reduction"] then
                            if _value["_additional_unlock_level"] and artifactLevel>=_value["_additional_unlock_level"] then
                                level_require = level_require - self:GetSpecialValueFor(_key)
                            end
                        end
        
        
      

                    end
                end




                
                if level>=level_require then
                    return true
                end


         
            end
    
            return false
        end

        -- 获取可减免等级的steamID list
        function CDOTA_Item:GetArtifactSpecialList()
            return {}
        end
        -- 默认的等级减免常数部分
        function CDOTA_Item:GetArtifactSpecialListLevelRequireReduction__Con()
            return 3
        end
        -- 默认的等级减免百分比部分
        function CDOTA_Item:GetArtifactSpecialListLevelRequireReduction__Pct()
            return 10
        end
        -- tostring(PlayerResource:GetSteamID(nPlayerID))


        function CDOTA_Item:GetArtifactSpecialValueFor(szName)
            local name = self:GetAbilityName()
            if  KeyValues.palyer_artifactKV[name] then
                local abilityValue = KeyValues.palyer_artifactKV[name].AbilityValues
                local artifactLevel = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),name)
                local value =  self:GetSpecialValueFor(szName)
                if abilityValue[szName] then
                    local _value = abilityValue[szName] 
                    if type(_value) == "table" then
                        if _value["_level_bonus"] then
                            return value + _value["_level_bonus"] * artifactLevel
                        end
                    end
                end

                return value
                
            end
    
            return 0
        end
end
if IsClient() then

    function C_DOTA_Item:GetArtifactSpecialValueFor(szName)
        local name = self:GetAbilityName()
        if  KeyValues.palyer_artifactKV[name] then
            local abilityValue = KeyValues.palyer_artifactKV[name].AbilityValues
            local caster 
            if not caster then
                -- CustomNetTables:SetTableValue("artifactParentRecord", tostring(hItem:entindex()),  hUnit:entindex())
                local tableData = CustomNetTables:GetTableValue("artifactParentRecord", tostring(self:entindex()))
                if tableData  then
                    --print("caster= ",tableData["index"])
                    caster = EntIndexToHScript(tableData["index"])
                end
            end
            if not caster then
                return 0
            end
            local owner = caster:GetPlayerOwnerID()
            local artifactLevel = GetArtifactLevel(owner,name)
            local value =  self:GetSpecialValueFor(szName)
            if abilityValue[szName] then
                local _value = abilityValue[szName] 
                if type(_value) == "table" then
                    if _value["_level_bonus"] then
                        return value + _value["_level_bonus"] * artifactLevel
                    end
                end
            end

            return value
            
        end

        return 0
    end
end



function GetArtifactLevel(nPlayerID,name)
	-- KeyValues.playerArtifact_expSetting
    -- 扩充上限时，搜GetCurrentArtifactLevel，在common.js内也要改

	local netData = CustomNetTables:GetTableValue( "chaoticEraData", "playerArtifact")
	if netData and netData[""..nPlayerID] and netData[""..nPlayerID][name] then
    local expSetting = KeyValues.playerArtifact_expSetting
        local current = netData[""..nPlayerID][name].valueOne
        local lv = 0;
        -- print("lv=",lv)
        for i = 1, 100, 1 do
            local require = expSetting[""..i]
            if current>=require.value then
                lv = i
            end
        end
        -- print("lv=",lv)
        return lv

	end
    return 0
end
