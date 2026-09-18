--用于显示单位状态抗性
--附带功能 设置英雄重生时的魔法
--附带功能 设置单位dps
--------------------------------------------------------------------------------
modifier_unit_status_Resistance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unit_status_Resistance:IsHidden()return true end
function modifier_unit_status_Resistance:IsDebuff()return false end
function modifier_unit_status_Resistance:IsStunDebuff()return false end
function modifier_unit_status_Resistance:IsPurgable()return false end
function modifier_unit_status_Resistance:IsPurgeException() 	return false end
function modifier_unit_status_Resistance:RemoveOnDeath() return false end
function modifier_unit_status_Resistance:OnCreated(table)
    if IsServer() then
        self.parent = self:GetParent()
        -- self:StartIntervalThink(1.5)

    end
    
end


function modifier_unit_status_Resistance:DeclareFunctions()
    local funcs = {
        -- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        -- MODIFIER_EVENT_ON_DEATH,
        -- MODIFIER_EVENT_ON_RESPAWN,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --用于计算伤害
    }

    return funcs
   
end


-- function modifier_Advanced_Bad_Juju_passive2:GetModifierPercentageCooldown() return (self:GetStackCount()*1.1) end



-- function modifier_unit_status_Resistance:GetModifierStatusResistanceStacking()
-- 	return -self:GetStackCount()+100
-- end




-- attacker.GetPlayerOwnerID


-- function modifier_unit_status_Resistance:OnDeath(keys)
-- 	if IsServer() then
-- 		local unit = keys.unit
--         if not unit:IsRealHero() then
--             return
--         end
--         local mana = unit:GetMana()
--         if mana then
--             unit.dead_mana = mana
--         end
-- 	end
-- end
-- function modifier_unit_status_Resistance:OnRespawn(keys)
-- 	if IsServer() then
-- 		local unit = keys.unit
--         if not unit:IsRealHero() then
--             return
--         end
--         if unit.dead_mana and Game_State:IsInBattle() then
--             unit:SetMana(math.max(unit.dead_mana,unit:GetMaxMana()*0.2))
--         end

-- 	end
-- end




function modifier_unit_status_Resistance:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        local victim = self:GetParent()
        local attacker = keys.attacker
        if not attacker then
            return
        end
        local damage = keys.original_damage
        if attacker:IsCreature() and victim:IsRealHero() and victim.GetPlayerOwnerID then
            local victimPlayerId = victim:GetPlayerOwnerID()
            if victimPlayerId and victimPlayerId >= 0 and damage>=0 then
                player_data_modify_value(victimPlayerId, "damageTaken", damage)
            end
        end
    end
	return 0
end





-- function modifier_unit_status_Resistance:OnTakeDamage(keys)
--     if IsServer() then   
--         local attacker = keys.attacker
--         local unit = keys.unit
--         local parent = self:GetParent()
--         -- if not keys.inflictor then return end
--         if keys.damage<=1 then return	end
--         if not attacker or not unit then
--             return
--         end
--         if attacker==parent then	
--             --现在你是攻击者 在目标那里产生跳字特效
--             local player = PlayerResource:GetPlayer(parent:GetPlayerOwnerID())
--             local color = DAMAGE_COLOR_NORMAL
--             if keys.damage_type==DAMAGE_TYPE_PHYSICAL  then
--                 color = DAMAGE_COLOR_PHYSICAL
--             elseif keys.damage_type==DAMAGE_TYPE_MAGICAL  then
--                 color = DAMAGE_COLOR_MAGICAL
--             elseif keys.damage_type==DAMAGE_TYPE_PURE  then
--                 color = DAMAGE_COLOR_PURE
--             end
--             fHDSendCustomOverheadEventMessageForPlayer(player,"hd_damage", unit, math.floor(keys.damage), 1, nil, color, 0)
--         elseif unit==parent then
--             fHDSendCustomOverheadEventMessageForPlayer(parent,"hd_damage", unit, math.floor(keys.damage), 1, nil, DAMAGE_TAKE_COLOR_NORMAL, 0)
--         end

       
        

--         -- if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then		return 0	end
    
--         -- if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

--         -- if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

--         -- if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end



--         -- fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
      
        

    
--     end 
-- end