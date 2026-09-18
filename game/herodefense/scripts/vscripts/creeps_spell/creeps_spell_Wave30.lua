creeps_spell_Wave30 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave30_check", "creeps_spell/creeps_spell_Wave30", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave30_pattern_1", "creeps_spell/creeps_spell_Wave30", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave30_pattern_2", "creeps_spell/creeps_spell_Wave30", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave30_pattern_3", "creeps_spell/creeps_spell_Wave30", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave30_INVULNERABLE", "creeps_spell/creeps_spell_Wave30", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Wave30_count", "creeps_spell/creeps_spell_Wave30", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Wave30:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave30:IsRefreshable() 			return true end
function creeps_spell_Wave30:IsStealable() 				return true end
function creeps_spell_Wave30:IsNetherWardStealable()		return true end
function creeps_spell_Wave30:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave30_check" end



-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave30:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave30:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 0
    end
    return self.trigger
end
CREATE_ELEMENT = {
    "npc_monster_wave_30_2",
    "npc_monster_wave_30_3",
    "npc_monster_wave_30_4",
    "npc_monster_wave_30_5",
}
       
-------------------------------------------
--产生元素分裂体
function creeps_spell_Wave30:ElementSplitting()
    if not IsServer() then
        return
    end

    self:SetTrigger(0)
    local pattern = 1
    local caster = self:GetCaster()

    --方便能量核心的处理
    caster.element = {}
    local HEALTH = caster:GetHealth()
    local pattern_2 = caster:GetMaxHealth()* self:GetSpecialValueFor("pattern_2_health")
    local pattern_3 = caster:GetMaxHealth()* self:GetSpecialValueFor("pattern_3_health")
    if HEALTH<=pattern_2 and HEALTH > pattern_3 then
        pattern = 2
    elseif HEALTH<=pattern_3 then
        pattern = 3
    end
    -----------
    local unit_count = 4
    if pattern==3 then
        unit_count = 7
    end
    for i = 1, unit_count, 1 do
        local unit =CreateUnitByName(CREATE_ELEMENT[RandomInt(1, 4)], caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
        self:SetTrigger(self:GetTrigger()+1)
        unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1}):SetStackCount(GetPlayerCount()) --提供增益
        table.insert(caster.element,unit)
          --词条处理
	    if GetChallengeDifficulty()>=1 then
		    CreateSpecialGainForUnit(unit,1000,1000,7)  --为产生的单位添加词条
	    end

        if _G.GAME_DIFFICULTY~=0  then
            local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
            ability:SetLevel(_G.GAME_DIFFICULTY)
            if GetChallengeDifficulty()~=0 then
                local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
                ability:SetLevel(GetChallengeDifficulty())
            end
        end
        if pattern == 1 then
            unit:AddNewModifier(caster, self, "modifier_creeps_spell_Wave30_pattern_1",{})
        elseif pattern == 2 then
            unit.pattern_2 = true
            unit:AddNewModifier(caster, self, "modifier_creeps_spell_Wave30_pattern_2",{})
        else

            unit:AddNewModifier(caster, self, "modifier_creeps_spell_Wave30_pattern_3",{})
            if _G.GAME_DIFFICULTY==4 then
                unit:SetBaseDamageMax(unit:GetBaseDamageMax()*1.4)
                unit:SetBaseDamageMin(unit:GetBaseDamageMin()*1.4)

            end
            unit.pattern_2 = true
    
        end

    end


end

-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave30_check = class({})

function modifier_creeps_spell_Wave30_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave30_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave30_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave30_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave30_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave30_check:OnCreated(table)    
    if not IsServer() then
        return
    end  
    --初始设置，当前形态是常态
    local parent = self:GetParent()
    local ability = self:GetAbility()
    self.ability = ability
    self.ability:SetTrigger(0)
    parent:AddNewModifier( parent, self.ability, "modifier_creeps_spell_Wave30_INVULNERABLE",{})

    self.pattern_1_status_resistance = ability:GetSpecialValueFor("pattern_1_StatusResistance")--常态状态抗性
    -------------------------------------------------
    self.pattern_2 = parent:GetMaxHealth()* ability:GetSpecialValueFor("pattern_2_health")     --形态2界限  60%生命值
    self.pattern_2_status_resistance = ability:GetSpecialValueFor("pattern_2_StatusResistance")--形态2状态抗性


    self.pattern_3 = parent:GetMaxHealth()* ability:GetSpecialValueFor("pattern_3_health")     --形态3界限  20%生命值
    self.pattern_3_status_resistance = ability:GetSpecialValueFor("pattern_3_StatusResistance")--形态3状态抗性
    self:StartIntervalThink(1)
    
end
--产生元素
function modifier_creeps_spell_Wave30_check:OnIntervalThink()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if parent:IsAlive() and self:GetAbility():GetTrigger() ==0 then
        self:GetAbility():ElementSplitting()
    end
end

function modifier_creeps_spell_Wave30_check:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,  -- 无碰撞
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,  --飞行
	}
end
function modifier_creeps_spell_Wave30_check:DeclareFunctions()    return {MODIFIER_PROPERTY_DISABLE_HEALING,MODIFIER_EVENT_ON_DEATH ,}end
function modifier_creeps_spell_Wave30_check:GetDisableHealing()	return 1 end

function modifier_creeps_spell_Wave30_check:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit == self:GetParent() then
        local tEnemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            self:GetCaster():GetOrigin(),
            nil,
            5000,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            0,
            false
            )
            if tEnemies==nil then
                return
            end
            for _, hEnemy in pairs(tEnemies) do
                if hEnemy:IsAlive() then
                    -- hEnemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = 0.1})
                    TrueKill(self:GetCaster(), hEnemy, self:GetAbility())
                end
            end
    end
end




modifier_creeps_spell_Wave30_pattern_1 = advanced_modifier({})

function modifier_creeps_spell_Wave30_pattern_1:IsDebuff()			 return false end
function modifier_creeps_spell_Wave30_pattern_1:IsHidden() 		     return true end
function modifier_creeps_spell_Wave30_pattern_1:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave30_pattern_1:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave30_pattern_1:RemoveOnDeath()       return true end
function modifier_creeps_spell_Wave30_pattern_1:OnCreated(table)    
    local ability = self:GetAbility()
    self.ability = ability
    self.status_resistance = ability:GetSpecialValueFor("pattern_1_StatusResistance")--状态抗性
end



function modifier_creeps_spell_Wave30_pattern_1:OnDestroy(keys)
    if not IsServer() then
        return
    end

    local ability = self:GetAbility()

    self:GetCaster():RemoveModifierByName("modifier_creeps_spell_Wave30_INVULNERABLE")	
    local damageTable = {
        victim = self:GetCaster(),
        attacker = self:GetCaster(),
        damage = self:GetCaster():GetMaxHealth()*0.05,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = ability, --Optional.
        }
    ApplyDamage(damageTable)
    self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_creeps_spell_Wave30_INVULNERABLE",{})

    ability:SetTrigger(ability:GetTrigger()-1)
   
end



function modifier_creeps_spell_Wave30_pattern_1:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave30_pattern_1:Advanced_GetModifier_StatusResistance(keys)
	return self.status_resistance
end




modifier_creeps_spell_Wave30_pattern_2 = advanced_modifier({})

function modifier_creeps_spell_Wave30_pattern_2:IsDebuff()			 return false end
function modifier_creeps_spell_Wave30_pattern_2:IsHidden() 		     return true end
function modifier_creeps_spell_Wave30_pattern_2:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave30_pattern_2:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave30_pattern_2:RemoveOnDeath()       return true end
function modifier_creeps_spell_Wave30_pattern_2:OnCreated(table)    

    local ability = self:GetAbility()
    self.ability = ability
    self.status_resistance = ability:GetSpecialValueFor("pattern_1_StatusResistance")--状态抗性

end



function modifier_creeps_spell_Wave30_pattern_2:OnDestroy(keys)
    if not IsServer() then
        return
    end

    local ability = self:GetAbility()

    self:GetCaster():RemoveModifierByName("modifier_creeps_spell_Wave30_INVULNERABLE")	
    local damageTable = {
        victim = self:GetCaster(),
        attacker = self:GetCaster(),
        damage = self:GetCaster():GetMaxHealth()*0.05,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = ability, --Optional.
        }
    ApplyDamage(damageTable)
    self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_creeps_spell_Wave30_INVULNERABLE",{})

    ability:SetTrigger(ability:GetTrigger()-1)
   
end

function modifier_creeps_spell_Wave30_pattern_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave30_pattern_2:Advanced_GetModifier_StatusResistance(keys)
	return self.status_resistance
end





--第三阶段


modifier_creeps_spell_Wave30_pattern_3 = advanced_modifier({})

function modifier_creeps_spell_Wave30_pattern_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave30_pattern_3:IsHidden() 		     return true end
function modifier_creeps_spell_Wave30_pattern_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave30_pattern_3:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave30_pattern_3:RemoveOnDeath()       return true end
function modifier_creeps_spell_Wave30_pattern_3:OnCreated(table) 
    local ability = self:GetAbility()
    self.ability = ability
    self.status_resistance = ability:GetSpecialValueFor("pattern_3_StatusResistance")--状态抗性
    self:StartIntervalThink(1)
end



function modifier_creeps_spell_Wave30_pattern_3:Advanced_GetModifierIncomingDamage_Percentage()
    if IsClient() then
        return 0
    end
    if _G.GAME_DIFFICULTY>=3 then
        return -40
    end
    return 0
end
function modifier_creeps_spell_Wave30_pattern_3:OnDestroy(keys)
    if not IsServer() then
        return
    end

    local ability = self:GetAbility()

    self:GetCaster():RemoveModifierByName("modifier_creeps_spell_Wave30_INVULNERABLE")	
    local damageTable = {
        victim = self:GetCaster(),
        attacker = self:GetCaster(),
        damage = self:GetCaster():GetMaxHealth()*0.05,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = ability, --Optional.
        }
    ApplyDamage(damageTable)
    self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_creeps_spell_Wave30_INVULNERABLE",{})

    ability:SetTrigger(ability:GetTrigger()-1)
   
end

function modifier_creeps_spell_Wave30_pattern_3:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_StatusResistance
}
	return funcs
end



function modifier_creeps_spell_Wave30_pattern_1:Advanced_GetModifier_StatusResistance(keys)
	return self.status_resistance
end




modifier_creeps_spell_Wave30_INVULNERABLE = class({})

function modifier_creeps_spell_Wave30_INVULNERABLE:IsDebuff()			 return false end
function modifier_creeps_spell_Wave30_INVULNERABLE:IsHidden() 		     return true end
function modifier_creeps_spell_Wave30_INVULNERABLE:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave30_INVULNERABLE:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave30_INVULNERABLE:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave30_INVULNERABLE:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,       --无敌
	}
end




modifier_creeps_spell_Wave30_count = class({})

function modifier_creeps_spell_Wave30_count:IsDebuff()			 return false end
function modifier_creeps_spell_Wave30_count:IsHidden() 		     return true end
function modifier_creeps_spell_Wave30_count:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave30_count:IsPurgeException() 	 return false end


function modifier_creeps_spell_Wave30_count:OnDestroy(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
        local ability = self:GetAbility()

        self:GetCaster():RemoveModifierByName("modifier_creeps_spell_Wave30_INVULNERABLE")	
        local damageTable = {
			victim = self:GetCaster(),
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetMaxHealth()*0.05,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
        ApplyDamage(damageTable)
        self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_creeps_spell_Wave30_INVULNERABLE",{})

        ability:SetTrigger(ability:GetTrigger()-1)

    end
   
end
