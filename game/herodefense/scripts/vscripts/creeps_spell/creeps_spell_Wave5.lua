creeps_spell_Wave5 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave5_check", "creeps_spell/creeps_spell_Wave5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave5_changing_to_2", "creeps_spell/creeps_spell_Wave5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave5_changing_to_3", "creeps_spell/creeps_spell_Wave5", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_normal_stun", "skills/skills_effect/modifier_normal_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave5_debuff1", "creeps_spell/creeps_spell_Wave5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave5_motion", "creeps_spell/creeps_spell_Wave5", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_Wave5:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave5:IsRefreshable() 			return true end
function creeps_spell_Wave5:IsStealable() 				return true end
function creeps_spell_Wave5:IsNetherWardStealable()		return true end
function creeps_spell_Wave5:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave5_check" end

require('internal/timers')

-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave5:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave5:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 1
    end
    return self.trigger
end
-------------------------------------------
--设置与获取当前是否正在变身
function creeps_spell_Wave5:SetTriggerChangging(int)
	if self.trigger_changging ==nil then
        self.trigger_changging = int
    end
    self.trigger_changging = int
end

function creeps_spell_Wave5:GetTriggerChangging()
	if self.trigger_changging ==nil then
        self.trigger_changging = 0
    end
    return self.trigger_changging
end

-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave5_check = advanced_modifier({})

function modifier_creeps_spell_Wave5_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave5_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave5_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave5_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave5_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave5_check:OnCreated(table)    
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

function modifier_creeps_spell_Wave5_check:OnIntervalThink()
	if self.ability:GetTrigger() == 1 then
        self.bonus_status_resistance = self.pattern_1_status_resistance
    elseif self.ability:GetTrigger() == 2 then
        self.bonus_status_resistance = self.pattern_2_status_resistance
    else
        self.bonus_status_resistance = self.pattern_3_status_resistance
    end
end




-------------------------------------------------------------------------------------------------
function modifier_creeps_spell_Wave5_check:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH,MODIFIER_EVENT_ON_DEATH,}
end

--形态转变的核心触发事件
--当生命值低于阈值时开启转变
function modifier_creeps_spell_Wave5_check:OnTakeDamage(keys)
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
        EmitGlobalSound("abaddon_abad_levelup_07")  --音效：我几乎不能控制这股力量
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave5_changing_to_2", {duration = 10})  --开始转变
    --当前状态是形态二 进入形态三
    --判断---是否是状态二 生命值低于阈值 当前没在进行形态转变
    elseif self.ability:GetTrigger() == 2 and self:GetParent():GetHealth() <= self.pattern_3 +10  and self.ability:GetTriggerChangging() == 0 then    
        --判断难度 小于等于2则返回
        if _G.GAME_DIFFICULTY<=2 then
            return
        end
        ability:SetTriggerChangging(1)  --设置正在转变
        EmitGlobalSound("abaddon_abad_borrowedtime_01")  --音效：走向我
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave5_changing_to_3", {duration = 10})  --开始转变
    end
    -----------------------------------------------
end

function modifier_creeps_spell_Wave5_check:GetMinHealth() 
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

function modifier_creeps_spell_Wave5_check:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit==self:GetParent() then
        local heroes = GetAllRealHeroes()
	    for  _, hero in pairs(heroes) do
	 --    hero:SetGold(hero:GetGold() + self.gold, true)
        local buffs = hero:FindAllModifiersByName("modifier_creeps_spell_Wave5_debuff1")
		if  #buffs > 0 then
            buffs[1]:SafeDestroy()
        end
	end
    end

    
end


function modifier_creeps_spell_Wave5_check:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave5_check:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave5_changing_to_2 = advanced_modifier({})

function modifier_creeps_spell_Wave5_changing_to_2:IsDebuff()			 return false end
function modifier_creeps_spell_Wave5_changing_to_2:IsHidden() 		     return true end
function modifier_creeps_spell_Wave5_changing_to_2:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave5_changing_to_2:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave5_changing_to_2:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave5_changing_to_2:DeclareFunctions() return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
} end
--额外受到50%伤害
function modifier_creeps_spell_Wave5_changing_to_2:Advanced_GetModifierIncomingDamage_Percentage() 
    return 50
end

function modifier_creeps_spell_Wave5_changing_to_2:OnTakeDamage(keys)
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
    if self:GetStackCount() > caster:GetMaxHealth()*0.1 then
        self:SafeDestroy()
    end
end

function modifier_creeps_spell_Wave5_changing_to_2:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(2)            --开启第二形态
    if not IsServer() then
        return
    end
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    caster:StopSound("Hero_Leshrac.Pulse_Nova")
    ability:SetTriggerChangging(0)   --变身结束
    caster.pattern_2 = true
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 60, Vector(5,207,243))
    ParticleManager:SetParticleControl(pfx, 1, Vector(1200,1200,1200))
    ParticleManager:SetParticleControl(pfx, 3, pos)
    ParticleManager:SetParticleControl(pfx, 61, Vector(1200,1200,1200))
    ParticleManager:ReleaseParticleIndex(pfx)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
     nil, 700,
      DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
        FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        local damage = enemy:GetMaxHealth()*0.5
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			}
        ApplyDamage(damageTable)  
        enemy:AddNewModifier(caster, ability, "modifier_normal_stun", {duration = 5})
        
        
	end
    caster:EmitSound("Hero_Phoenix.SuperNova.Explode")
    EmitGlobalSound("abaddon_abad_levelup_08")  --音效：新的力量在激荡。
end

function modifier_creeps_spell_Wave5_changing_to_2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave5_changing_to_3 = advanced_modifier({})

function modifier_creeps_spell_Wave5_changing_to_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave5_changing_to_3:IsHidden() 		     return true end
function modifier_creeps_spell_Wave5_changing_to_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave5_changing_to_3:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave5_changing_to_3:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave5_changing_to_3:DeclareFunctions() return 
    {
        MODIFIER_PROPERTY_MIN_HEALTH,
    } 
end
--免疫所有伤害
function modifier_creeps_spell_Wave5_changing_to_3:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave5_changing_to_3:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end

function modifier_creeps_spell_Wave5_changing_to_3:OnCreated(table)
    self:StartIntervalThink(0.2)
end
function modifier_creeps_spell_Wave5_changing_to_3:OnIntervalThink(table)
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local heroes = GetAllRealHeroes()
    for _, enemy in pairs(heroes) do

        enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave5_motion", {duration = 0.7})
        
        
        
	end
end
function modifier_creeps_spell_Wave5_changing_to_3:OnDestroy()
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
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 60, Vector(5,207,243))
    ParticleManager:SetParticleControl(pfx, 1, Vector(1200,1200,1200))
    ParticleManager:SetParticleControl(pfx, 3, pos)
    ParticleManager:SetParticleControl(pfx, 61, Vector(1200,1200,1200))
    ParticleManager:ReleaseParticleIndex(pfx)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
     nil, 500,
      DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
        FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do

        enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave5_debuff1", {})
        enemy:AddNewModifier(caster, ability, "modifier_normal_stun", {duration = 10})
        
 
	end
    local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
    nil, 1000,
     DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
       FIND_ANY_ORDER, false)
   local heal = 0
   for _, enemy in pairs(enemies2) do
       if enemy:IsRealHero() then
           heal = heal + 0.5
       end       
   end
   --治疗
   heal = math.min(0.1,heal)
   local healing = heal *caster:GetMaxHealth()
   caster:Heal( healing, self:GetParent())
   SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,caster, healing, nil) 

   --增加攻击力
   caster:SetBaseDamageMax(caster:GetBaseDamageMax()*1.4)
   caster:SetBaseDamageMin(caster:GetBaseDamageMin()*1.4)

   EmitGlobalSound("abaddon_abad_borrowedtime_06")  --音效：尽管试试
    caster:EmitSound("Hero_Phoenix.SuperNova.Explode")
end

function modifier_creeps_spell_Wave5_changing_to_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


modifier_creeps_spell_Wave5_motion = class({})

function modifier_creeps_spell_Wave5_motion:IsDebuff()			return false end
function modifier_creeps_spell_Wave5_motion:IsHidden() 			return true end
function modifier_creeps_spell_Wave5_motion:IsPurgable() 		return false end
function modifier_creeps_spell_Wave5_motion:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave5_motion:IsMotionController() return true end
function modifier_creeps_spell_Wave5_motion:OnCreated(keys)
    if IsServer() then
        self:GetParent():EmitSound("Ability.static.loop")
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = self:GetParent():GetIdealSpeed()*0.9
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_creeps_spell_Wave5_motion:OnRefresh(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = self:GetParent():GetIdealSpeed()*0.9
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_creeps_spell_Wave5_motion:OnIntervalThink(keys)   
    if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + (-self.direction) * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    end
end



function modifier_creeps_spell_Wave5_motion:OnDestroy(keys) 
    if  IsServer() then
        self:GetParent():StopSound("Ability.static.loop")
	    self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
    end
end




-----debuff

modifier_creeps_spell_Wave5_debuff1 = advanced_modifier({})

function modifier_creeps_spell_Wave5_debuff1:IsDebuff()			return true end
function modifier_creeps_spell_Wave5_debuff1:IsHidden() 			return false end
function modifier_creeps_spell_Wave5_debuff1:IsPurgable() 		return false end
function modifier_creeps_spell_Wave5_debuff1:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave5_debuff1:Advanced_GetModifierIncomingDamage_Percentage() 
    return 50
end
function modifier_creeps_spell_Wave5_debuff1:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
