creeps_spell_Wave20 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave20_check", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave20_changing_to_2", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave20_changing_to_3", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave20_changing_to_3_slow", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave20_heal", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Wave20_debuff1", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave20_debuff2", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave20_debuff3", "creeps_spell/creeps_spell_Wave20", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Wave20:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave20:IsRefreshable() 			return true end
function creeps_spell_Wave20:IsStealable() 				return true end
function creeps_spell_Wave20:IsNetherWardStealable()		return true end
function creeps_spell_Wave20:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave20_check" end

require('internal/timers')


-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave20:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave20:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 1
    end
    return self.trigger
end
-------------------------------------------
--设置与获取当前是否正在变身
function creeps_spell_Wave20:SetTriggerChangging(int)
	if self.trigger_changging ==nil then
        self.trigger_changging = int
    end
    self.trigger_changging = int
end

function creeps_spell_Wave20:GetTriggerChangging()
	if self.trigger_changging ==nil then
        self.trigger_changging = 0
    end
    return self.trigger_changging
end

-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave20_check = advanced_modifier({})

function modifier_creeps_spell_Wave20_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave20_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave20_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave20_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave20_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave20_check:OnCreated(table)   
    local ability = self:GetAbility()
    self.ability = ability
    self.pattern_1_status_resistance = ability:GetSpecialValueFor("pattern_1_StatusResistance")--常态状态抗性
    self.pattern_2_status_resistance = ability:GetSpecialValueFor("pattern_2_StatusResistance")--形态2状态抗性
    self.pattern_3_status_resistance = ability:GetSpecialValueFor("pattern_3_StatusResistance")--形态3状态抗性
    self.bonus_status_resistance = 0 
    self:StartIntervalThink(1)
    if not IsServer() then
        return
    end  
    --初始设置，当前形态是常态
    local parent = self:GetParent()
    local ability = self:GetAbility()
    self.ability = ability

    -------------------------------------------------
    self.pattern_2 = parent:GetMaxHealth()* ability:GetSpecialValueFor("pattern_2_health")     --形态2界限  60%生命值
    self.pattern_3 = parent:GetMaxHealth()* ability:GetSpecialValueFor("pattern_3_health")     --形态3界限  20%生命值
    if self.refresh_fnished then
        return
    end
    --因为难度系统与人数难度系统加的属性在单位出生（~0.3秒）之后，需要延迟刷新一下
    Timers:CreateTimer(1, function()
        self.refresh_fnished = true
        self:OnCreated()
    end)
    
end

function modifier_creeps_spell_Wave20_check:OnIntervalThink()
	if self.ability:GetTrigger() == 1 then
        self.bonus_status_resistance = self.pattern_1_status_resistance
    elseif self.ability:GetTrigger() == 2 then
        self.bonus_status_resistance = self.pattern_2_status_resistance
    else
        self.bonus_status_resistance = self.pattern_3_status_resistance
    end
end



-------------------------------------------------------------------------------------------------
function modifier_creeps_spell_Wave20_check:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH,MODIFIER_EVENT_ON_DEATH,}
end

function modifier_creeps_spell_Wave20_check:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    -----------------------------------------------
    --当前状态是形态一，进入形态二
    if self.ability:GetTrigger() == 1 and self:GetParent():GetHealth() <= self.pattern_2 +10 and  self.ability:GetTriggerChangging() == 0  then
        ability:SetTriggerChangging(1)
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave20_changing_to_2", {})
        EmitGlobalSound("enchantress_ench_anger_04")
    end
    --当前状态是形态二，进入形态三
    if self.ability:GetTrigger() == 2 and self:GetParent():GetHealth() <= self.pattern_3 +10 and  self.ability:GetTriggerChangging() == 0  then
        --判断难度 小于等于2则返回
        if _G.GAME_DIFFICULTY<=2 then
            return
        end
        ability:SetTriggerChangging(1)
        EmitGlobalSound("enchantress_ench_anger_03")
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave20_changing_to_3", {duration = 10})
    end
    -----------------------------------------------
end

function modifier_creeps_spell_Wave20_check:GetMinHealth() 
    if self.ability:GetTrigger() == 1 and self.ability:GetTriggerChangging()==0 then  --如果在状态一，不是在变身中  返回60%
        return self.pattern_2 
    elseif self.ability:GetTrigger() == 1 and self.ability:GetTriggerChangging()==1 then --如果在状态一，在变身中  返回20%
        return self.pattern_3
    elseif self.ability:GetTrigger() == 2 and self.ability:GetTriggerChangging()==0 then  --如果在状态二，没在变身中，返回0，暂不设置状态三
        return 0  --暂不设置第三形态
    else
        return 0
    end
end


function modifier_creeps_spell_Wave20_check:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
        local heroes = GetAllRealHeroes()
        for  _, hero in pairs(heroes) do
         --    hero:SetGold(hero:GetGold() + self.gold, true)
            local buffs = hero:FindAllModifiersByName("modifier_creeps_spell_Wave20_debuff1")
            if  #buffs > 0 then
                buffs[1]:SafeDestroy()
            end
            buffs = hero:FindAllModifiersByName("modifier_creeps_spell_Wave20_debuff2")
            if  #buffs > 0 then
                buffs[1]:SafeDestroy()
            end
            buffs = hero:FindAllModifiersByName("modifier_creeps_spell_Wave20_debuff3")
            if  #buffs > 0 then
                buffs[1]:SafeDestroy()
            end
        end

    end
  
end

function modifier_creeps_spell_Wave20_check:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave20_check:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave20_changing_to_2 = class({})

function modifier_creeps_spell_Wave20_changing_to_2:IsDebuff()			 return false end
function modifier_creeps_spell_Wave20_changing_to_2:IsHidden() 		     return false end
function modifier_creeps_spell_Wave20_changing_to_2:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave20_changing_to_2:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave20_changing_to_2:DeclareFunctions() return 
    {
    MODIFIER_EVENT_ON_TAKEDAMAGE,} end

function modifier_creeps_spell_Wave20_changing_to_2:OnTakeDamage(keys)
	if not IsServer() then 
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
    --判断累计伤害是否达到触发线
    --强制结束状态
    if self:GetStackCount() > caster:GetMaxHealth()*0.3 then
        self:SafeDestroy()
    end
end
--转变结束

function modifier_creeps_spell_Wave20_changing_to_2:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(2)            --开启第二形态
    if not IsServer() then
        return
    end
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    caster:StopSound("Hero_Leshrac.Pulse_Nova")
    ability:SetTriggerChangging(0)   --变身结束
    caster.pattern_2 = true
    local pfx = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_spirit_ti8_overload_active.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, pos)

    ParticleManager:SetParticleControl(pfx, 5, pos)
    ParticleManager:SetParticleControl(pfx, 2, pos)

    ParticleManager:ReleaseParticleIndex(pfx)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
     nil, 1000,
      DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
        FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave20_debuff1", {})
	end
    caster:EmitSound("enchantress_ench_level_06")
    caster:EmitSound("Hero_Enchantress.EnchantHero")
end


--治疗
function modifier_creeps_spell_Wave20_changing_to_2:OnCreated()		
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    self.healing = 0
    if IsServer() then
        caster:EmitSound("enchantress_ench_ability_nature_05")
        self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count14.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
        for num = 3, 11 do 
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false) 
    	self:StartIntervalThink(1)
    end	
end


--治疗
function modifier_creeps_spell_Wave20_changing_to_2:OnIntervalThink()	
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    local healing = caster:GetMaxHealth()*0.01
    local fhealing =  HealWithGain(healing,caster,caster,ability) --返回治疗的数值
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,caster, fhealing, nil) 
    --即使治疗效果为0也记录
    self.healing = self.healing + healing
    if self.healing >= caster:GetMaxHealth()*0.3 then
        self:SafeDestroy()
    end
end	



--------------------------------------------------------
--状态三变身中
modifier_creeps_spell_Wave20_changing_to_3 = advanced_modifier({})

function modifier_creeps_spell_Wave20_changing_to_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave20_changing_to_3:IsHidden() 		     return false end
function modifier_creeps_spell_Wave20_changing_to_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave20_changing_to_3:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave20_changing_to_3:IsAura() return true end
function modifier_creeps_spell_Wave20_changing_to_3:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Wave20_changing_to_3:GetModifierAura() return "modifier_creeps_spell_Wave20_changing_to_3_slow" end
function modifier_creeps_spell_Wave20_changing_to_3:GetAuraRadius() return 1000 end
function modifier_creeps_spell_Wave20_changing_to_3:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_creeps_spell_Wave20_changing_to_3:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creeps_spell_Wave20_changing_to_3:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- 石化与冻结
function modifier_creeps_spell_Wave20_changing_to_3:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave20_changing_to_3:DeclareFunctions() return 
    {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_MIN_HEALTH,}
end
--免疫所有伤害
function modifier_creeps_spell_Wave20_changing_to_3:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave20_changing_to_3:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end

--转变结束
function modifier_creeps_spell_Wave20_changing_to_3:OnCreated()
    if not IsServer() then
        return
    end
    local cast_particle = ParticleManager:CreateParticle("particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(cast_particle, 0, self:GetParent():GetAbsOrigin())
    -- ParticleManager:SetParticleControl(cast_particle, 62, Vector(1000,1000,1000))
	ParticleManager:ReleaseParticleIndex(cast_particle)
    self:GetCaster():EmitSound("Hero_Treant.Overgrowth.Cast")
    
end

function modifier_creeps_spell_Wave20_changing_to_3:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(3)            --开启第二形态
    if not IsServer() then
        return
    end
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    caster:StopSound("Hero_Leshrac.Pulse_Nova")
    ability:SetTriggerChangging(0)   --变身结束
    caster.pattern_3 = true
    local heal = 0


    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos,
     nil, 1500,
      DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
        FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave20_debuff2", {})
        local dis= GetDistanceBetweenTwoUnit(caster,enemy)
        if dis<=1000 and enemy:IsRealHero() then
             heal = heal + 1
        end
	end
    for i = 1, heal, 1 do
        Timers:CreateTimer(RandomFloat(0, 1), function()
            caster:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave20_heal", {})
        end)
    end
    caster:EmitSound("enchantress_ench_level_06")
    caster:EmitSound("Hero_Enchantress.EnchantHero")

    --提升攻击力
    caster:SetBaseDamageMax(caster:GetBaseDamageMax()*1.4)
    caster:SetBaseDamageMin(caster:GetBaseDamageMin()*1.4)
    local pfx = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_spirit_ti8_overload_active.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, pos)

    ParticleManager:SetParticleControl(pfx, 5, pos)
    ParticleManager:SetParticleControl(pfx, 2, pos)

    ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_creeps_spell_Wave20_changing_to_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





--------------------------------------------------------
--状态三治疗
modifier_creeps_spell_Wave20_heal = class({})

function modifier_creeps_spell_Wave20_heal:IsDebuff()			 return false end
function modifier_creeps_spell_Wave20_heal:IsHidden() 		     return true end
function modifier_creeps_spell_Wave20_heal:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave20_heal:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave20_heal:GetAttributes()				return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_Wave20_heal:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count3.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
    for num = 3, 5 do 
        ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
    end
    ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
    ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
    self:AddParticle(self.particle2, false, false, 100, false, false) 

end

function modifier_creeps_spell_Wave20_heal:OnDestroy()
    if not IsServer() then
        return
    end
    ParticleManager:DestroyParticle(self.particle2, false)
    ParticleManager:ReleaseParticleIndex(self.particle2 )
end
--治疗
function modifier_creeps_spell_Wave20_heal:OnIntervalThink()	
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    local healing = caster:GetMaxHealth()*0.003
    local fhealing =  HealWithGain(healing,caster,caster,ability) --返回治疗的数值
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,caster, fhealing, nil) 
end	






-----debuff

modifier_creeps_spell_Wave20_debuff1 = class({})

function modifier_creeps_spell_Wave20_debuff1:IsDebuff()			return true end
function modifier_creeps_spell_Wave20_debuff1:IsHidden() 			return false end
function modifier_creeps_spell_Wave20_debuff1:IsPurgable() 		return false end
function modifier_creeps_spell_Wave20_debuff1:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave20_debuff1:GetEffectName() return "particles/econ/items/enchantress/enchantress_lodestar/enchantress_lodestar_butterfly_blue.vpcf" end
function modifier_creeps_spell_Wave20_debuff1:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creeps_spell_Wave20_debuff1:DeclareFunctions() return
	 { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_creeps_spell_Wave20_debuff1:GetModifierMagicalResistanceBonus() return self.reduce end
function modifier_creeps_spell_Wave20_debuff1:OnCreated()
    self.reduce = - self:GetAbility():GetSpecialValueFor("magic_resistance_reduce1")
    if IsServer() then
        self:StartIntervalThink(2)
    end
end
function modifier_creeps_spell_Wave20_debuff1:OnIntervalThink()
    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:SafeDestroy()
    end
end
-----debuff

modifier_creeps_spell_Wave20_debuff2 = advanced_modifier({})

function modifier_creeps_spell_Wave20_debuff2:IsDebuff()			return true end
function modifier_creeps_spell_Wave20_debuff2:IsHidden() 			return false end
function modifier_creeps_spell_Wave20_debuff2:IsPurgable() 		return false end
function modifier_creeps_spell_Wave20_debuff2:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave20_debuff2:GetEffectName() return "particles/econ/items/enchantress/enchantress_lodestar/enchantress_lodestar_butterfly_blue.vpcf" end
function modifier_creeps_spell_Wave20_debuff2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creeps_spell_Wave20_debuff2:DeclareFunctions() return
	 { 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    } 
end
function modifier_creeps_spell_Wave20_debuff2:GetModifierMoveSpeedBonus_Percentage() return self.speed_slow end
function modifier_creeps_spell_Wave20_debuff2:Advanced_GetModifierAttackSpeedPercentage() return self.speed_slow end

function modifier_creeps_spell_Wave20_debuff2:OnCreated()
    self.speed_slow = self:GetAbility():GetSpecialValueFor("speed_slow")
    self.cast_slow = self:GetAbility():GetSpecialValueFor("cast_speed_reduce")
    if IsServer() then

        self:StartIntervalThink(2)
    end
end

function modifier_creeps_spell_Wave20_debuff2:OnRefresh()
    self.speed_slow = self:GetAbility():GetSpecialValueFor("speed_slow")
    self.cast_slow = self:GetAbility():GetSpecialValueFor("cast_speed_reduce")

end


function modifier_creeps_spell_Wave20_debuff2:OnIntervalThink()
    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:SafeDestroy()
    end
end


-- advanced_modifier
function modifier_creeps_spell_Wave20_debuff2:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_CastPoint

    }

	return funcs

end

function modifier_creeps_spell_Wave20_debuff2:Advanced_GetModifier_CastPoint() return self.cast_slow end





modifier_creeps_spell_Wave20_changing_to_3_slow = class({})

function modifier_creeps_spell_Wave20_changing_to_3_slow:IsDebuff()			return true end
function modifier_creeps_spell_Wave20_changing_to_3_slow:IsHidden() 			return false end
function modifier_creeps_spell_Wave20_changing_to_3_slow:IsPurgable() 		return false end
function modifier_creeps_spell_Wave20_changing_to_3_slow:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave20_changing_to_3_slow:CheckState()
	return {
		--[MODIFIER_STATE_SILENCED] = true,

	}
end

function modifier_creeps_spell_Wave20_changing_to_3_slow:DeclareFunctions() return
	 { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_creeps_spell_Wave20_changing_to_3_slow:GetModifierMoveSpeedBonus_Percentage() return (-90) end
function modifier_creeps_spell_Wave20_changing_to_3_slow:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end
function modifier_creeps_spell_Wave20_changing_to_3_slow:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creeps_spell_Wave20_debuff3", {})
end



modifier_creeps_spell_Wave20_debuff3 = class({})

function modifier_creeps_spell_Wave20_debuff3:IsDebuff()			return true end
function modifier_creeps_spell_Wave20_debuff3:IsHidden() 			return false end
function modifier_creeps_spell_Wave20_debuff3:IsPurgable() 		return false end
function modifier_creeps_spell_Wave20_debuff3:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave20_debuff3:DeclareFunctions() return
	 { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_creeps_spell_Wave20_debuff3:GetModifierMagicalResistanceBonus() return (-2)*self:GetStackCount() end

function modifier_creeps_spell_Wave20_debuff3:OnCreated()
    if not IsServer() then
        return
    end
    self:SetStackCount(1)
    self:StartIntervalThink(2)
end
function modifier_creeps_spell_Wave20_debuff3:OnRefresh()
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
end



function modifier_creeps_spell_Wave20_debuff3:OnIntervalThink()
    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:SafeDestroy()
    end
end