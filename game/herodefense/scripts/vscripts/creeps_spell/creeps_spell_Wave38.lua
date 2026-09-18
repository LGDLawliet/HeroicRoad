creeps_spell_Wave38 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave38_check", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave38_changing_to_2", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave38_changing_to_3", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_creeps_spell_Wave38_fire_link_buff", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave38_fire_link_buff_triger", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_link_partten_2", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_link_partten_3", "creeps_spell/creeps_spell_Wave38", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Wave38:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave38:IsRefreshable() 			return true end
function creeps_spell_Wave38:IsStealable() 				return true end
function creeps_spell_Wave38:IsNetherWardStealable()		return true end
function creeps_spell_Wave38:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave38_check" end

require('internal/timers')

-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave38:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave38:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 1
    end
    return self.trigger
end
-------------------------------------------
--设置与获取当前是否正在变身
function creeps_spell_Wave38:SetTriggerChangging(int)
	if self.trigger_changging ==nil then
        self.trigger_changging = int
    end
    self.trigger_changging = int
end

function creeps_spell_Wave38:GetTriggerChangging()
	if self.trigger_changging ==nil then
        self.trigger_changging = 0
    end
    return self.trigger_changging
end

-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave38_check = advanced_modifier({})

function modifier_creeps_spell_Wave38_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave38_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave38_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave38_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave38_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave38_check:OnCreated(table)    
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
    Timers:CreateTimer(0.1, function()
        parent:SetSkin(1)
    end)
    Timers:CreateTimer(1, function()
        self.refresh_fnished = true
        self:OnCreated()
    end)
    
end

function modifier_creeps_spell_Wave38_check:OnIntervalThink()
	if self.ability:GetTrigger() == 1 then
        self.bonus_status_resistance = self.pattern_1_status_resistance
    elseif self.ability:GetTrigger() == 2 then
        self.bonus_status_resistance = self.pattern_2_status_resistance
    else
        self.bonus_status_resistance = self.pattern_3_status_resistance
    end
end




-------------------------------------------------------------------------------------------------
function modifier_creeps_spell_Wave38_check:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH,
    MODIFIER_EVENT_ON_DEATH}
end
function modifier_creeps_spell_Wave38_check:OnDeath(keys)
    if IsClient() then
        return
    end
    if keys.unit == self:GetParent() then
        Timers:CreateTimer(3, function()  --延迟3秒防止有人把boss秒杀导致状态无限存在
            local heroes = GetAllRealHeroes()
            for  _, hero in pairs(heroes) do
                local modifier = hero:FindModifierByName("modifier_creeps_spell_Wave38_form3_debuff")
                if modifier then
                    modifier:SafeDestroy()
                end
    
    
            end
        end)
      
    end


end
--形态转变的核心触发事件
--当生命值低于阈值时开启转变
function modifier_creeps_spell_Wave38_check:OnTakeDamage(keys)
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
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave38_changing_to_2", {duration = 0.1})  --开始转变
        
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
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave38_changing_to_3", {duration = 0.1})  --开始转变
    end
    -----------------------------------------------
end

function modifier_creeps_spell_Wave38_check:GetMinHealth() 
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


function modifier_creeps_spell_Wave38_check:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave38_check:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave38_changing_to_2 = advanced_modifier({})

function modifier_creeps_spell_Wave38_changing_to_2:IsDebuff()			 return false end
function modifier_creeps_spell_Wave38_changing_to_2:IsHidden() 		     return true end
function modifier_creeps_spell_Wave38_changing_to_2:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave38_changing_to_2:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave38_changing_to_2:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end
function modifier_creeps_spell_Wave38_changing_to_2:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end
--免疫所有伤害
function modifier_creeps_spell_Wave38_changing_to_2:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave38_changing_to_2:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
--释放质引
function modifier_creeps_spell_Wave38_changing_to_2:OnCreated()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local newAbility = caster:AddAbility("creeps_spell_dragon_blood")
    newAbility:SetLevel(1)
    if not caster.fire_link_unit:IsNull() and caster.fire_link_unit:IsAlive() then
        caster.fire_link_unit:AddNewModifier(caster, self:GetAbility(), "modifier_fire_link_partten_2", {})
        -- print("与莉娜分开")
    end


end

function modifier_creeps_spell_Wave38_changing_to_2:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(2)            --开启第二形态
    if not IsServer() then
        return
    end
    
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    ability:SetTriggerChangging(0)   --变身结束
    
    caster.pattern_2 = true
   

    EmitGlobalSound("custom_lina_give_u_nothing")  
    Timers:CreateTimer(3.5, function()
         EmitGlobalSound("custom_Slyrak_fire_dragon_child_of_fire")  
     end)
end

function modifier_creeps_spell_Wave38_changing_to_2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave38_changing_to_3 = advanced_modifier({})

function modifier_creeps_spell_Wave38_changing_to_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave38_changing_to_3:IsHidden() 		     return true end
function modifier_creeps_spell_Wave38_changing_to_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave38_changing_to_3:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave38_changing_to_3:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave38_changing_to_3:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end
--免疫所有伤害
function modifier_creeps_spell_Wave38_changing_to_3:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave38_changing_to_3:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
function modifier_creeps_spell_Wave38_changing_to_3:OnCreated(keys)
    if IsServer() then
        local caster = self:GetCaster()
 
        if not caster.fire_link_unit:IsNull() and caster.fire_link_unit:IsAlive() then
            caster.fire_link_unit:AddNewModifier(caster, self:GetAbility(), "modifier_fire_link_partten_3", {})
            caster.fire_link_unit:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Wave38_fire_link_buff", {target = caster:entindex()})
            caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Wave38_fire_link_buff", {target = caster.fire_link_unit:entindex()})
            print("第三阶段")
        end
    


    end

end

function modifier_creeps_spell_Wave38_changing_to_3:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(3)            --开启第二形态
    if not IsServer() then
        return
    end
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    -- caster:StopSound("Hero_Leshrac.Pulse_Nova")
    ability:SetTriggerChangging(0)   --变身结束
    caster.pattern_3 = true
    

   --增加攻击力
   caster:SetBaseDamageMax(caster:GetBaseDamageMax()*1.4)
   caster:SetBaseDamageMin(caster:GetBaseDamageMin()*1.4)

   EmitGlobalSound("lina_lina_lose_03")  
   Timers:CreateTimer(3.5, function()
        EmitGlobalSound("custom_Slyrak_fire_dragon_star")  
    end)



end


function modifier_creeps_spell_Wave38_changing_to_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end







modifier_fire_link_partten_2 = advanced_modifier({})

function modifier_fire_link_partten_2:IsDebuff()			 return false end
function modifier_fire_link_partten_2:IsHidden() 		     return true end
function modifier_fire_link_partten_2:IsPurgable() 		 return false end
function modifier_fire_link_partten_2:IsPurgeException() 	 return false end
function modifier_fire_link_partten_2:RemoveOnDeath()       return false end
function modifier_fire_link_partten_2:OnCreated(table)    
    if not IsServer() then
        return
    end  
 
    local newAbility = self:GetParent():AddAbility("creeps_spell_fiery_soul")
    self.target = self:GetParent().fire_link_unit
    self.pattern_3 = self:GetParent():GetMaxHealth()* self:GetAbility():GetSpecialValueFor("pattern_3_health")     --形态3界限  20%生命值

    
    newAbility:SetLevel(1)
    
end

function modifier_fire_link_partten_2:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

--形态转变的核心触发事件
--当生命值低于阈值时开启转变
function modifier_fire_link_partten_2:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end

    local ability = self:GetAbility()
    if not ability then
        return
    end
    local caster = ability:GetCaster()
  
    --当前状态是形态二 进入形态三
    --判断---是否是状态二 生命值低于阈值 当前没在进行形态转变
    if ability:GetTrigger() == 2 and self:GetParent():GetHealth() <= self.pattern_3 +10  and ability:GetTriggerChangging() == 0 then    
        --判断难度 小于等于2则返回
        if _G.GAME_DIFFICULTY<=2 then
            return
        end
        if self.target and not self.target:IsNull() and self.target:IsAlive() then
            ability:SetTriggerChangging(1)  --设置正在转变
            -- caster:EmitSound("magnataur_magn_levelup_2")
            -- EmitGlobalSound("magnataur_magn_levelup_2")  --音效
            self.target:AddNewModifier(self.target, ability, "modifier_creeps_spell_Wave38_changing_to_3", {duration = 0.1})  --开始转变
        end
        
        
    end
    -----------------------------------------------
end



function modifier_fire_link_partten_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end


function modifier_fire_link_partten_2:Advanced_GetModifier_StatusResistance(keys)
	return 50
end








modifier_fire_link_partten_3 = advanced_modifier({})

function modifier_fire_link_partten_3:IsDebuff()			 return false end
function modifier_fire_link_partten_3:IsHidden() 		     return true end
function modifier_fire_link_partten_3:IsPurgable() 		 return false end
function modifier_fire_link_partten_3:IsPurgeException() 	 return false end
function modifier_fire_link_partten_3:RemoveOnDeath()       return false end
function modifier_fire_link_partten_3:OnCreated(table)    
    if not IsServer() then
        return
    end  
    self:GetParent():SetBaseDamageMax(self:GetParent():GetBaseDamageMax()*1.4)
    self:GetParent():SetBaseDamageMin(self:GetParent():GetBaseDamageMin()*1.4)
end



function modifier_fire_link_partten_3:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_fire_link_partten_3:Advanced_GetModifier_StatusResistance(keys)
	return 30
end

















modifier_creeps_spell_Wave38_fire_link_buff = class({})
function modifier_creeps_spell_Wave38_fire_link_buff:IsHidden() return false end
function modifier_creeps_spell_Wave38_fire_link_buff:IsDebuff() return false end
function modifier_creeps_spell_Wave38_fire_link_buff:IsPurgable() 		return false end
function modifier_creeps_spell_Wave38_fire_link_buff:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave38_fire_link_buff:RemoveOnDeath()  return false end
function modifier_creeps_spell_Wave38_fire_link_buff:IsStunDebuff() return false end
function modifier_creeps_spell_Wave38_fire_link_buff:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Wave38_fire_link_buff:DeclareFunctions() return
    {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_creeps_spell_Wave38_fire_link_buff:OnCreated(keys)
    if IsServer() then
        self.target	= EntIndexToHScript(keys.target)
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Wave38_fire_link_buff_triger", {duration= 5})
    end

end
function modifier_creeps_spell_Wave38_fire_link_buff:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
    --self.off 是判定是否进入了第二状态，如果进入了则以下效果均取消，不再触发电场
    if  self.off~=nil then
        return
    end

	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    if self.target:IsNull() or not self.target:IsAlive() then
        -- if true then
        --     self.target = self:GetParent()
        -- else
        --     self:SafeDestroy()
        --     return
        -- end
        self:SafeDestroy()
        return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > caster:GetMaxHealth()*0.05 then
        local modifier = self.target:FindModifierByName("modifier_creeps_spell_Wave38_fire_link_buff_triger")
        local duration = 3
        if modifier then
            duration = math.min((duration + modifier:GetRemainingTime()),30)
        end
        self.target:AddNewModifier(self.target, nil, "modifier_creeps_spell_Wave38_fire_link_buff_triger", {duration= duration})
        if self.target~=self:GetParent() then
            local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/fire_link_partten3/fire_link.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
            ParticleManager:SetParticleControl( pfx, 15, Vector(237, 10, 10 ) )
            ParticleManager:SetParticleControl( pfx, 16, Vector(1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex(pfx)
        end
        self:SetStackCount(0)
    end
end




modifier_creeps_spell_Wave38_fire_link_buff_triger = advanced_modifier({})

function modifier_creeps_spell_Wave38_fire_link_buff_triger:IsDebuff() return false end
function modifier_creeps_spell_Wave38_fire_link_buff_triger:IsHidden() return false end
function modifier_creeps_spell_Wave38_fire_link_buff_triger:IsPurgable() return false end
function modifier_creeps_spell_Wave38_fire_link_buff_triger:GetEffectName() return "particles/new_effect/status/new_status_effect_advanced_dragon_blood.vpcf" end
function modifier_creeps_spell_Wave38_fire_link_buff_triger:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creeps_spell_Wave38_fire_link_buff_triger:GetTexture() return "dragon_knight/dk_persona/dragon_knight_elder_dragon_form_persona1" end

function modifier_creeps_spell_Wave38_fire_link_buff_triger:OnCreated(keys)
    if IsServer() then
        local parent = self:GetParent()
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball_projectile_b.vpcf", PATTACH_POINT_FOLLOW, parent)
        ParticleManager:SetParticleControl(particle, 3, parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        parent:EmitSound("Hero_DragonKnight.ElderDragonForm")
        self:StartIntervalThink(1)
    end

end


function modifier_creeps_spell_Wave38_fire_link_buff_triger:OnIntervalThink()

	local caster = self:GetCaster()
	local damage = caster:GetDamageMax()
    local damage_table = {
		attacker = self:GetParent(),
		ability = nil,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	}
    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,600,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball_projectile_b.vpcf", PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
   for _,enemy in pairs(enemies) do
        damage_table.victim = enemy
        ApplyDamage(damage_table)
   end
			
			

	
end



function modifier_creeps_spell_Wave38_fire_link_buff_triger:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_MIN_HEALTH,

    }
end


function modifier_creeps_spell_Wave38_fire_link_buff_triger:Advanced_GetModifierIncomingDamage_Percentage() return -100 end
function modifier_creeps_spell_Wave38_fire_link_buff_triger:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end



function modifier_creeps_spell_Wave38_fire_link_buff_triger:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
