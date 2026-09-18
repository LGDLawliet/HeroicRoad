Advanced_Chilling_Touch = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Chilling_Touch_attack", "skills/Advanced_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chilling_Touch_debuff", "skills/Advanced_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chilling_Touch_slow", "skills/Advanced_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chilling_Touch_kill", "skills/Advanced_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chilling_Touch_buff", "skills/Advanced_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Chilling_Touch_unlock2", "skills/Advanced_Chilling_Touch", LUA_MODIFIER_MOTION_NONE)
function Advanced_Chilling_Touch:IsHiddenWhenStolen()         return false end
function Advanced_Chilling_Touch:IsStealable()                return true end
function Advanced_Chilling_Touch:IsNetherWardStealable()      return true end
function Advanced_Chilling_Touch:GetIntrinsicModifierName()   return "modifier_Advanced_Chilling_Touch_attack" end
function Advanced_Chilling_Touch:CheckKV(key)
	local table = {
		basic_damage =5,
        intelligence_index = 0.05,
        move_slow = 1,
        duration = 0.05,
        bonus_attack_range = 5,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Chilling_Touch:UnlockFirstCore(key)
	return true
end
function Advanced_Chilling_Touch:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Chilling_Touch:UnlockThirdCore(key)

	return true
end


function Advanced_Chilling_Touch:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_TOGGLE
		end
		
	end

	return self.BaseClass.GetBehavior(self)
end

function Advanced_Chilling_Touch:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_Chilling_Touch:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Advanced_Chilling_Touch:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then

		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Chilling_Touch_unlock2", {})
	else


		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Chilling_Touch_unlock2", self:GetCaster())
	end
	
end
function Advanced_Chilling_Touch:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_i_cowlofice.vpcf", context )
end
---------------------------------------------------------------------------

modifier_Advanced_Chilling_Touch_attack = advanced_modifier({})

function modifier_Advanced_Chilling_Touch_attack:IsPassive()          return true end
function modifier_Advanced_Chilling_Touch_attack:IsBuff()				return true end
function modifier_Advanced_Chilling_Touch_attack:IsPurgable()     	return false end
function modifier_Advanced_Chilling_Touch_attack:IsPurgeException() 	return false end
function modifier_Advanced_Chilling_Touch_attack:IsHidden()			return false end
function modifier_Advanced_Chilling_Touch_attack:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf" 
    end	
end 

function modifier_Advanced_Chilling_Touch_attack:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_Advanced_Chilling_Touch_attack:Advanced_GetModifierAttackRangeBonus()		
    if self:GetParent():IsRangedAttacker() then
        return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    else 
        return 0
    end
end



function modifier_Advanced_Chilling_Touch_attack:OnAttackLanded(keys)
    self.advanced_level = self:GetAbility().advanced_level
    if not IsServer() then
        return
	end  
	
	if not self:GetParent():IsAlive() or self:GetParent():IsIllusion() then
		return
    end
    --新LV15技能将无视减益免疫。
    if  self.advanced_level<=15 then
        if keys.target:IsMagicImmune() then
            return
        end
    end


    if not self:GetParent():IsApplyModifier()  then
        return
    end
    if keys.attacker == self:GetParent() then 
        local damage = self:GetAbility():GetSpecialValueFor("basic_damage")+ self:GetParent():GetIntellect(false) * (self:GetAbility():GetSpecialValueFor("intelligence_index"))
		--LV15解锁攻击附魔//已盖板
        --if self.advanced_level>=15 then
        --    damage = damage +keys.attacker:GetDamageMax()*0.2
        --end
        if self:GetAbility().unlock3 then
            local units = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            if #units>1 then
                damage = damage * (1+(#units-1)*0.3)
                local heal_particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_i_cowlofice.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
                local target_vector = keys.target:GetAbsOrigin() + Vector(0,0,64)
                ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
                -- ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
                ParticleManager:ReleaseParticleIndex(heal_particle)
                
            end
    
        end
        local damagetable= {
            victim = keys.target,
            attacker = keys.attacker,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
            }
		keys.target:ApplyMergeDamage(damagetable)
        EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Target", keys.target)
        local ModifierStatusNegativeGain = keys.attacker:GetModifierStatusNegativeGainIndex(1)
        local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
        local gain = keys.attacker:GetModifierDurationGainIndex(1)--正面增强
        local duration = self:GetAbility():GetSpecialValueFor("duration")
        --新LV15解锁【绝对零度+】【绝对零度】并使极寒之触本身造成的减速效果不再受到状态抗性影响。
        if self.advanced_level >=15 then
            keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_slow", {duration=duration*ModifierStatusNegativeGain})
        else
            keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_slow", {duration=duration*StatusResistance})
        end
        self:SetStackCount(self:GetStackCount()+1)
        --新中阶效果：【绝对零度】每3次攻击使下一次攻击获得强化：被命中的单位将无法恢复生命值并进入被动破坏状态，持续1.5秒，不会被负面状态持续时间加成与状态抗性影响。.
        --新高阶lv10：【低温化+】触发【低温化】所需攻击次数-1。
        local times = 3
        if self.advanced_level>=10 then
            times = 2
        end
        if self:GetStackCount() > times then
            self:SetStackCount(0)
            --//高阶【温度吸收】//已改版
            --local gain = keys.attacker:GetModifierDurationGainIndex(1)
            --local index = keys.target:GetHealthRegen()
            --if index>=1 then
            --    keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_buff", {duration=2*gain,index=index}) 
            --end
            --//LV5解锁【绝对零度+】//已改版
            --local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)
            --if StatusResistance>1 and self.advanced_level >=5 then
            --    keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_debuff", {duration=1.5*StatusResistance}) 
            --else
            --    keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_debuff", {duration=1.5}) 
            --end

            --新高阶效果：【易碎之寒】触发【绝对零度】强化攻击时，为敌人施加1层永久异常[易碎]:若敌人的生命值低于其最大生命值的5%将被斩杀。
            --新LV5解锁【温度吸收】触发【绝对零度】强化攻击时，提高自身10%攻击速度，持续2秒（最多可叠加3次）。

            keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_kill", {duration = 5}) 
            if self.advanced_level >=5 then
                keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_buff", {duration = 2*gain})
            end
            
            keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Advanced_Chilling_Touch_debuff", {duration=1}) 
        
		end

	end 
end


function modifier_Advanced_Chilling_Touch_attack:OnCreated(table)
    if IsServer() then
        
        self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

        self.advanced_level = 1
		self.prevLoc = self.parent:GetAbsOrigin()
        self.move_dis = 0
        self:StartIntervalThink(0.03)
    end
end

function modifier_Advanced_Chilling_Touch_attack:OnIntervalThink()
    if IsClient() then
        return
    end
    if self.parent:PassivesDisabled() then
        return
    end
    --LV20解锁移动炮台
    if self.advanced_level>=20 then
        local dis = CalculateDistance(self.prevLoc, self.parent)
        self.move_dis = self.move_dis + dis
        local ability = self:GetAbility()
        if ability.unlock1 then
            if self.move_dis >=70 then
                self.move_dis  = 0
                local radius =self.parent:Script_GetAttackRange(  )
                local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
                if enemies~=nil then
                    self:GetParent():PerformAttack(enemies[1], false, true, true, true, true, false, true)--对一单位执行攻击。
                end
            end
        else
            if self.move_dis >=200 then
                self.move_dis  = 0
                local radius =self.parent:Script_GetAttackRange(  )
                local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
                if enemies~=nil then
                    local modifier_keys = {
                        duration = 0.1,
                        iSpecialAttack = 1,
                        iDisableApplyModifier = 0,
                        iDisableCleave =0,
                        iDisableSplit = 0,
                
                    }
                    local attackEffectRecord = self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
                    self:GetParent():PerformAttack(enemies[1], false, true, true, true, true, false, true)--对一单位执行攻击。
                    if IsValid(attackEffectRecord) then
                        attackEffectRecord:Destroy()
                    end
                end
            end
        end
     
        self.prevLoc = self:GetParent():GetAbsOrigin()
        
    end

end
function modifier_Advanced_Chilling_Touch_attack:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end
------------------------绝对零度破坏被动禁疗---------------------------------

modifier_Advanced_Chilling_Touch_debuff = class({})
function modifier_Advanced_Chilling_Touch_debuff:IsDebuff()				return true  end
function modifier_Advanced_Chilling_Touch_debuff:IsPurgable() 			return true end
function modifier_Advanced_Chilling_Touch_debuff:IsPurgeException()     return true end
function modifier_Advanced_Chilling_Touch_debuff:IsHidden()				return false end
function modifier_Advanced_Chilling_Touch_debuff:DeclareFunctions()    return {MODIFIER_PROPERTY_DISABLE_HEALING,MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE}end
function modifier_Advanced_Chilling_Touch_debuff:GetDisableHealing()	return 1 end


----------------------------基础减速------------------------------

modifier_Advanced_Chilling_Touch_slow = class({})
function modifier_Advanced_Chilling_Touch_slow:IsDebuff()				return true  end
function modifier_Advanced_Chilling_Touch_slow:IsPurgable() 			return true end
function modifier_Advanced_Chilling_Touch_slow:IsPurgeException() 	    return true end
function modifier_Advanced_Chilling_Touch_slow:IsHidden()				return false end
function modifier_Advanced_Chilling_Touch_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Chilling_Touch_slow:GetModifierMoveSpeedBonus_Constant() return self.slow  end

function modifier_Advanced_Chilling_Touch_slow:OnCreated()
    self.slow = - self:GetAbility():GetSpecialValueFor("move_slow")
end

function modifier_Advanced_Chilling_Touch_slow:OnRefresh()
    self.slow = - self:GetAbility():GetSpecialValueFor("move_slow")
end

------------------------------新【易碎之寒】易碎斩杀---------------------------
modifier_Advanced_Chilling_Touch_kill = advanced_modifier({})
function modifier_Advanced_Chilling_Touch_kill:IsDebuff()				return true  end
function modifier_Advanced_Chilling_Touch_kill:IsPurgable() 			return true end
function modifier_Advanced_Chilling_Touch_kill:IsPurgeException() 	    return true end
function modifier_Advanced_Chilling_Touch_kill:IsHidden()				return false end
function modifier_Advanced_Chilling_Touch_kill:OnCreated(keys)
    self.truekill_line = self:GetAbility():GetSpecialValueFor("truekill_line")*0.01
    self:StartIntervalThink(0.1)
end
--新高阶效果：【易碎之寒】触发【绝对零度】强化攻击时，为敌人施加1层永久异常[易碎]:若敌人的生命值低于其最大生命值的5%将被斩杀。
function modifier_Advanced_Chilling_Touch_kill:OnIntervalThink(keys)
 --   self.advanced_level = self:GetAbility().advanced_level
 --   local skill = self:GetAbility()
 --   print(skill)
    if  self:GetParent():GetHealth() <= self:GetParent():GetMaxHealth()*self.truekill_line then
        TrueKill(self:GetCaster(), self:GetParent(), self:GetAbility())
    end
end
-----------------------------新[温度吸收]攻速--------------------------
modifier_Advanced_Chilling_Touch_buff = advanced_modifier({})
function modifier_Advanced_Chilling_Touch_buff:IsDebuff()				return false  end
function modifier_Advanced_Chilling_Touch_buff:IsPurgable() 			return true end
function modifier_Advanced_Chilling_Touch_buff:IsPurgeException() 	    return true end
function modifier_Advanced_Chilling_Touch_buff:IsHidden()				return false end
function modifier_Advanced_Chilling_Touch_buff:OnCreated(keys)
    self.max_count = self:GetAbility():GetSpecialValueFor("max_count")
    self:SetStackCount(1)
end
function modifier_Advanced_Chilling_Touch_buff:OnRefresh(keys)
    self:SetStackCount(math.min(self:GetStackCount()+1,self.max_count))
end
function modifier_Advanced_Chilling_Touch_buff:DeclareFunctions()
    return  {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function modifier_Advanced_Chilling_Touch_buff:GetModifierAttackSpeedBonus_Constant()
    return  self:GetAbility():GetSpecialValueFor("bonus_attack_speed")*self:GetStackCount()
end
------------------------------温度吸收回蓝---------------------------

--modifier_Advanced_Chilling_Touch_buff = class({})
--function modifier_Advanced_Chilling_Touch_buff:IsDebuff()				return false  end
--function modifier_Advanced_Chilling_Touch_buff:IsPurgable() 			return true end
--function modifier_Advanced_Chilling_Touch_buff:IsPurgeException()     return true end
--function modifier_Advanced_Chilling_Touch_buff:IsHidden()				return false end
--function modifier_Advanced_Chilling_Touch_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--function modifier_Advanced_Chilling_Touch_buff:OnCreated(keys)
--   if IsServer() then
--        --解锁温度吸收+
--        if self:GetAbility().advanced_level>=10 then
--            self:SetStackCount(keys.index*2)
--        else
--            self:SetStackCount(keys.index)
--        end
--        
--    end
--end


--function modifier_Advanced_Chilling_Touch_buff:DeclareFunctions()
--	return {
---
--		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
--	}
--end
--function modifier_Advanced_Chilling_Touch_buff:GetModifierConstantManaRegen()	return self:GetStackCount()*0.5 end

-----------------------------原石2--------------------------------


modifier_Advanced_Chilling_Touch_unlock2= modifier_Advanced_Chilling_Touch_unlock2 or advanced_modifier({})
function modifier_Advanced_Chilling_Touch_unlock2:IsDebuff() return false end
function modifier_Advanced_Chilling_Touch_unlock2:IsHidden()		return true end
function modifier_Advanced_Chilling_Touch_unlock2:IsPurgable()		return false end
function modifier_Advanced_Chilling_Touch_unlock2:IsPurgeException() return false end
function modifier_Advanced_Chilling_Touch_unlock2:RemoveOnDeath()	return false end
function modifier_Advanced_Chilling_Touch_unlock2:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end


-- function modifier_Advanced_Chilling_Touch_unlock2:GetModifierTotalDamageOutgoing_Percentage(keys)
--     if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
--         return 400
--     end
   
-- end
-- advanced_modifier
function modifier_Advanced_Chilling_Touch_unlock2:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
	return funcs

end
function modifier_Advanced_Chilling_Touch_unlock2:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if IsClient() then
        return 0
    end
    if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
        return 400
    end
end


function modifier_Advanced_Chilling_Touch_unlock2:GetModifierAttackSpeedBonus_Constant(keys)
    return -99999
end



