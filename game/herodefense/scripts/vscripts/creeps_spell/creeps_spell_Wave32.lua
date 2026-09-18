creeps_spell_Wave32 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave32_check", "creeps_spell/creeps_spell_Wave32", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave32_changing_to_2", "creeps_spell/creeps_spell_Wave32", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave32_changing_to_3", "creeps_spell/creeps_spell_Wave32", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_creeps_spell_Wave32_p2", "creeps_spell/creeps_spell_Wave32", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave32_p3", "creeps_spell/creeps_spell_Wave32", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave32_p3_buff", "creeps_spell/creeps_spell_Wave32", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_Wave32:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave32:IsRefreshable() 			return true end
function creeps_spell_Wave32:IsStealable() 				return true end
function creeps_spell_Wave32:IsNetherWardStealable()		return true end
function creeps_spell_Wave32:GetIntrinsicModifierName() 
    if  self:GetCaster():GetUnitName() =="npc_hd_Brain_worm" then
        return "modifier_creeps_spell_Wave32_check" 
    end
end

require('internal/timers')

-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave32:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave32:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 1
    end
    return self.trigger
end
-------------------------------------------
--设置与获取当前是否正在变身
function creeps_spell_Wave32:SetTriggerChangging(int)
	if self.trigger_changging ==nil then
        self.trigger_changging = int
    end
    self.trigger_changging = int
end

function creeps_spell_Wave32:GetTriggerChangging()
	if self.trigger_changging ==nil then
        self.trigger_changging = 0
    end
    return self.trigger_changging
end

-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave32_check = advanced_modifier({})

function modifier_creeps_spell_Wave32_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave32_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave32_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave32_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave32_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave32_check:OnCreated(table)    
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

function modifier_creeps_spell_Wave32_check:OnIntervalThink()
	if self.ability:GetTrigger() == 1 then
        self.bonus_status_resistance = self.pattern_1_status_resistance
    elseif self.ability:GetTrigger() == 2 then
        self.bonus_status_resistance = self.pattern_2_status_resistance
    else
        self.bonus_status_resistance = self.pattern_3_status_resistance
    end
end




-------------------------------------------------------------------------------------------------
function modifier_creeps_spell_Wave32_check:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH,}
end

--形态转变的核心触发事件
--当生命值低于阈值时开启转变
function modifier_creeps_spell_Wave32_check:OnTakeDamage(keys)
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
    --判断---是否是状态一 生命值低于阈值 当前没在进行形态转变
    if self.ability:GetTrigger() == 1 and self:GetParent():GetHealth() <= self.pattern_2 +10  and self.ability:GetTriggerChangging() == 0  then
        ability:SetTriggerChangging(1)  --设置正在转变
        -- EmitGlobalSound("magnataur_magn_levelup_14")  --音效
        -- caster:EmitSound("magnataur_magn_levelup_14")
        self:GetParent():StartGesture(ACT_SIGNAL2 )
        	Timers:CreateTimer(0.5, function()
                self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave32_changing_to_2", {duration = 0.1})  --开始转变
	    end)
        
    --当前状态是形态二 进入形态三
    --判断---是否是状态二 生命值低于阈值 当前没在进行形态转变
    elseif self.ability:GetTrigger() == 2 and self:GetParent():GetHealth() <= self.pattern_3 +10  and self.ability:GetTriggerChangging() == 0 then    
        --判断难度 小于等于2则返回
        if _G.GAME_DIFFICULTY<=2 then
            return
        end
        ability:SetTriggerChangging(1)  --设置正在转变
        -- caster:EmitSound("magnataur_magn_levelup_2")
        -- EmitGlobalSound("magnataur_magn_levelup_2")  --音效
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave32_changing_to_3", {duration = 0.1})  --开始转变
    end
    -----------------------------------------------
end

function modifier_creeps_spell_Wave32_check:GetMinHealth() 
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


function modifier_creeps_spell_Wave32_check:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave32_check:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave32_changing_to_2 = advanced_modifier({})

function modifier_creeps_spell_Wave32_changing_to_2:IsDebuff()			 return false end
function modifier_creeps_spell_Wave32_changing_to_2:IsHidden() 		     return true end
function modifier_creeps_spell_Wave32_changing_to_2:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave32_changing_to_2:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave32_changing_to_2:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end
function modifier_creeps_spell_Wave32_changing_to_2:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end
--免疫所有伤害
function modifier_creeps_spell_Wave32_changing_to_2:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end

function modifier_creeps_spell_Wave32_changing_to_2:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
function modifier_creeps_spell_Wave32_changing_to_2:OnCreated()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()

end

function modifier_creeps_spell_Wave32_changing_to_2:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(2)            --开启第二形态
    if not IsServer() then
        return
    end
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    ability:SetTriggerChangging(0)   --变身结束
    caster.pattern_2 = true
   
    caster:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave32_p2", {})


	-- local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	-- EmitSoundOn( sound_cast, caster )





    -- EmitGlobalSound("magnataur_magn_empower_04")  --音效：粉碎敌人
    caster:EmitSound("spectre_spec_redux_levelup_15")
end

function modifier_creeps_spell_Wave32_changing_to_2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave32_changing_to_3 = advanced_modifier({})

function modifier_creeps_spell_Wave32_changing_to_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave32_changing_to_3:IsHidden() 		     return true end
function modifier_creeps_spell_Wave32_changing_to_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave32_changing_to_3:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave32_changing_to_3:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave32_changing_to_3:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end
--免疫所有伤害
function modifier_creeps_spell_Wave32_changing_to_3:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave32_changing_to_3:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
function modifier_creeps_spell_Wave32_changing_to_3:OnCreated(keys)
    if IsServer() then
        local caster = self:GetCaster()
        caster:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave32_p3", {})

    end

end

function modifier_creeps_spell_Wave32_changing_to_3:OnDestroy()
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
    

   --增加攻击力
   caster:SetBaseDamageMax(caster:GetBaseDamageMax()*1.4)
   caster:SetBaseDamageMin(caster:GetBaseDamageMin()*1.4)

--    EmitGlobalSound("magnataur_magn_kill_09")  --音效：火山都不在脚下
   caster:EmitSound("spectre_spec_redux_levelup_20")


--    local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
--    EmitSoundOn( sound_cast, caster )

--    ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function modifier_creeps_spell_Wave32_changing_to_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end























modifier_creeps_spell_Wave32_p2 = class({})

function modifier_creeps_spell_Wave32_p2:IsDebuff() return false end
function modifier_creeps_spell_Wave32_p2:IsHidden() return true end
function modifier_creeps_spell_Wave32_p2:IsPurgable() return false end



function modifier_creeps_spell_Wave32_p2:OnCreated()
	if IsServer() then
		self:StartIntervalThink(10)
	end
end

function modifier_creeps_spell_Wave32_p2:OnIntervalThink()
	-- local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
    -- local effect_cast = ParticleManager:CreateParticle( "particles/new_effect/unit/brain_worm/grand_illusion.vpcf", PATTACH_POINT , nil )
    local effect_cast  = ParticleManager:CreateParticle( "particles/new_effect/unit/brain_worm/grand_illusion.vpcf", PATTACH_WORLDORIGIN, caster )
    -- local effect_cast = ParticleManager:CreateParticleForTeam("particles/new_effect/unit/brain_worm/grand_illusion.vpcf",PATTACH_POINT, caster, DOTA_TEAM_GOODGUYS )
    ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(200,0,0) )
    caster:EmitSound("Hero_Venomancer.PoisonNova")

    local time = 5
    Timers:CreateTimer(5, function()
        if time>140 or  not caster:IsAlive() then
            ParticleManager:DestroyParticle(effect_cast, true)
            ParticleManager:ReleaseParticleIndex( effect_cast )
            return
        else
            time = time+1
            return 1
        end
    end)



end




modifier_creeps_spell_Wave32_p3 = class({})

function modifier_creeps_spell_Wave32_p3:IsDebuff() return false end
function modifier_creeps_spell_Wave32_p3:IsHidden() return true end
function modifier_creeps_spell_Wave32_p3:IsPurgable() return false end



function modifier_creeps_spell_Wave32_p3:OnCreated()
	if IsServer() then
        local caster = self:GetCaster()
        caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Wave32_p3_buff", {duration = 10})
		self:StartIntervalThink(20)
	end
end

function modifier_creeps_spell_Wave32_p3:OnIntervalThink()
	local caster = self:GetCaster()
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Wave32_p3_buff", {duration = 3})
end



modifier_creeps_spell_Wave32_p3_buff = class({})
function modifier_creeps_spell_Wave32_p3_buff:IsHidden()	return false end
function modifier_creeps_spell_Wave32_p3_buff:IsDebuff()	return false end
function modifier_creeps_spell_Wave32_p3_buff:IsPurgable()	return false end


function modifier_creeps_spell_Wave32_p3_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

function modifier_creeps_spell_Wave32_p3_buff:GetModifierInvisibilityLevel()	return 2 end


function modifier_creeps_spell_Wave32_p3_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
	return state
end

function modifier_creeps_spell_Wave32_p3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度

	}
end

function modifier_creeps_spell_Wave32_p3_buff:GetModifierAttackSpeedBonus_Constant()	return 150 end