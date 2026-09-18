creeps_spell_Wave51 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave51_check", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_changing_to_2", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_changing_to_3", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_creeps_spell_Wave51_form3_phantom", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_form3_debuff", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_thinker", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_debuff", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Wave51_tsf", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_tsf_thinker", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_tsf_trigger", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_tsf_trigger_safe", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_tsf_trigger_end", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave51_tsf_noheal", "creeps_spell/creeps_spell_Wave51", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Wave51:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_big/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/chronoshere/effect2/faceless_void_chronosphere.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect_purple.vpcf", context )

end

function creeps_spell_Wave51:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave51:IsRefreshable() 			return true end
function creeps_spell_Wave51:IsStealable() 				return true end
function creeps_spell_Wave51:IsNetherWardStealable()		return true end
function creeps_spell_Wave51:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave51_check" end

function creeps_spell_Wave51:Spawn()
    _G.GAME_Faceless_Void_Online = true
end


require('internal/timers')

-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave51:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave51:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 1
    end
    return self.trigger
end
-------------------------------------------
--设置与获取当前是否正在变身
function creeps_spell_Wave51:SetTriggerChangging(int)
	if self.trigger_changging ==nil then
        self.trigger_changging = int
    end
    self.trigger_changging = int
end

function creeps_spell_Wave51:GetTriggerChangging()
	if self.trigger_changging ==nil then
        self.trigger_changging = 0
    end
    return self.trigger_changging
end


function creeps_spell_Wave51:CreateChronosphere(caster, position, radius, duration, ally_behavior)
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	local ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, self, "modifier_creeps_spell_Wave51_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
	for _, unit in ipairs(enemies) do
        caster:IncreaseBaseDamageByModifier(math.max(caster:GetBaseDamageMax()*0.1,50))
	end
    Timers:CreateTimer(3, function()
        if 10==RandomInt(1, 100) then
        
            local sound = {
                "faceless_void_fv_arc_lgcy_rare_02",
                "faceless_void_fv_arc_respawn_11",
    
            
    
            }
        
        
            EmitGlobalSound(sound[RandomInt(1, #sound)])
        else
            if #enemies>0 then
                local sound = {
                    "faceless_void_fv_arc_level_09",
                    "faceless_void_fv_arc_level_15",
        
                }
            
            
                EmitGlobalSound(sound[RandomInt(1, #sound)])     
            else
                local sound = {
                    "faceless_void_fv_arc_level_11",
                    "faceless_void_fv_arc_level_12",
        
                }
            
            
                EmitGlobalSound(sound[RandomInt(1, #sound)])  
            end
        end
    end)

   
    thinker:EmitSound("dio_world")
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    return thinker
end




-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave51_check = advanced_modifier({})

function modifier_creeps_spell_Wave51_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave51_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave51_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave51_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave51_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave51_check:OnCreated(table)    
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
    self.hNpcSpawnedGameEvent = ListenToGameEvent( "dota_on_game_fail", Dynamic_Wrap( self, 'OnGameFail' ),self )
    
end
function modifier_creeps_spell_Wave51_check:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end
function modifier_creeps_spell_Wave51_check:OnIntervalThink()
	if self.ability:GetTrigger() == 1 then
        self.bonus_status_resistance = self.pattern_1_status_resistance
    elseif self.ability:GetTrigger() == 2 then
        self.bonus_status_resistance = self.pattern_2_status_resistance
    else
        self.bonus_status_resistance = self.pattern_3_status_resistance
    end
end

function modifier_creeps_spell_Wave51_check:OnGameFail(keys)
	if IsServer() then
		local Spell_sound = {
            "faceless_void_fv_arc_win_03",
            "faceless_void_fv_arc_win_04",
            "faceless_void_fv_arc_win_05",

        }
		EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
	end
end




-------------------------------------------------------------------------------------------------
function modifier_creeps_spell_Wave51_check:DeclareFunctions()
	return 
    {
     MODIFIER_EVENT_ON_TAKEDAMAGE,
     MODIFIER_PROPERTY_MIN_HEALTH,
    --  MODIFIER_EVENT_ON_DEATH
    }
end

--形态转变的核心触发事件
--当生命值低于阈值时开启转变
function modifier_creeps_spell_Wave51_check:OnTakeDamage(keys)
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
        self:ChangeToForm2()
        -- EmitGlobalSound("magnataur_magn_levelup_14")  --音效
        -- caster:EmitSound("magnataur_magn_levelup_14")
        -- self:GetParent():StartGesture(ACT_SIGNAL2 )
        -- 	Timers:CreateTimer(0.5, function()
        --         self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave51_changing_to_2", {duration = 3})  --开始转变
	    -- end)
        
    --当前状态是形态二 进入形态三
    --判断---是否是状态二 生命值低于阈值 当前没在进行形态转变
    elseif self.ability:GetTrigger() == 2 and self:GetParent():GetHealth() <= self.pattern_3 +10  and self.ability:GetTriggerChangging() == 0 then    
        --判断难度 小于等于2则返回
        if _G.GAME_DIFFICULTY<=2 then
            return
        end
        ability:SetTriggerChangging(1)  --设置正在转变
        caster:EmitSound("magnataur_magn_levelup_2")
        -- EmitGlobalSound("magnataur_magn_levelup_2")  --音效
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave51_changing_to_3", {duration = 25})  --开始转变
    end
    -----------------------------------------------
end

function modifier_creeps_spell_Wave51_check:GetMinHealth() 
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

function modifier_creeps_spell_Wave51_check:ChangeToForm2()
    -- local caster = self:GetParent()
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    -- local pos = caster:GetAbsOrigin()
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    caster.pattern_2 = true
	caster:EmitSound("Hero_FacelessVoid.TimeDilation.Cast")
	local effect_name = "particles/rebuild/creeps_spell/time_dialate_big/effect.vpcf"
	local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)

    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        for i=0, 15 do
            local Ability = hero:GetAbilityByIndex(i)
            if Ability ~= nil and Ability:GetAbilityName()~="Default_Move" then
                local newCooldown = math.max(Ability:GetCooldownTimeRemaining() +10,10)
                -- print("newCooldown="..newCooldown)
                Ability:StartCooldown(newCooldown)
                -- stack = stack + 1
                -- Ability:EndCooldown()
                -- if newCooldown>=0 then
                -- 	Ability:StartCooldown(newCooldown)
                -- end
            end
        end
    end

    local sound = {
        "faceless_void_fv_arc_level_03",
        "faceless_void_fv_arc_level_04",
        "faceless_void_fv_arc_level_05",
    }


    EmitGlobalSound(sound[RandomInt(1, #sound)])

    ability:SetTriggerChangging(0)   --变身结束
    ability:SetTrigger(2)            --开启第二形态

end


function modifier_creeps_spell_Wave51_check:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave51_check:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end





--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave51_changing_to_3 = advanced_modifier({})

function modifier_creeps_spell_Wave51_changing_to_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave51_changing_to_3:IsHidden() 		     return true end
function modifier_creeps_spell_Wave51_changing_to_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave51_changing_to_3:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave51_changing_to_3:CheckState()
	return {
		-- [MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave51_changing_to_3:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end

function modifier_creeps_spell_Wave51_changing_to_3:GetOverrideAnimation(params)
	return ACT_DOTA_TELEPORT
end
function modifier_creeps_spell_Wave51_changing_to_3:GetOverrideAnimationRate()	return 2 end
--免疫所有伤害
function modifier_creeps_spell_Wave51_changing_to_3:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave51_changing_to_3:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
function modifier_creeps_spell_Wave51_changing_to_3:OnCreated(keys)
    if IsServer() then
        local caster = self:GetCaster()
        caster:Stop()
        caster:EmitSound("Hero_FacelessVoid.TimeDilation.Cast")

        CreateModifierThinker(caster, self:GetAbility(), "modifier_creeps_spell_Wave51_tsf_thinker", {duration = 25}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)

        --self.safe_pos = GetClearSpaceForUnit(caster, caster:GetAbsOrigin() + RandomVector(RandomFloat(1500,2500)))
        --self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/creeps_spell/time_dialate_changing/effect.vpcf", PATTACH_WORLDORIGIN, nil )
        --ParticleManager:SetParticleShouldCheckFoW( self.nFXIndex,false )
        --ParticleManager:SetParticleControl( self.nFXIndex, 0, caster:GetAbsOrigin())
        --ParticleManager:SetParticleControl( self.nFXIndex, 1, self.safe_pos)
        --ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(400,0,0))
        --self:AddParticle( self.nFXIndex, false, false, 0, true, false )
        --caster:AddNewModifier(caster,self:GetAbility(),"modifier_creeps_spell_Wave51_tsf",{duration = 25})
        --caster:AddNewModifier(caster,self:GetAbility(),"modifier_creeps_spell_Wave51_tsf_trigger",{duration = 25 , pos = self.safe_pos})


        self.phantom ={}
        --self:CreatePhantom()
        --self:CreatePhantom()
        --self:CreatePhantom()
        --local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 100000,
        --DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD, FIND_CLOSEST, false)
        --for _,hero in pairs(heros)do
        --    hero:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_creeps_spell_Wave51_tsf_noheal",{duration = 25})
        --end
        self:StartIntervalThink(0.1)
        local Spell_sound = {
            "faceless_void_fv_arc_kill_23",
            "faceless_void_fv_arc_kill_24",
            "faceless_void_fv_arc_chronos_special_04"
        }
        EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
    end
end





function modifier_creeps_spell_Wave51_changing_to_3:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(3)            --开启第三形态
    if not IsServer() then
        return
    end
   
    local caster = ability:GetCaster()
    -- local pos = caster:GetAbsOrigin()
    -- caster:StopSound("Hero_Leshrac.Pulse_Nova")
    ability:SetTriggerChangging(0)   --变身结束

    caster.pattern_3 = true
    
    --虚空补救措施
	--ParticleManager:DestroyParticle(self.nFXIndex, false)
	--ParticleManager:ReleaseParticleIndex( self.nFXIndex )

    --参与游戏的玩家个数
    local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 100000,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD, FIND_CLOSEST, false)
    local stack = #heros

    for _,hero in pairs(heros)do

        local modifier = hero:FindModifierByName("modifier_creeps_spell_Wave51_tsf_trigger_safe")
        if modifier then
            stack = math.max(stack - 1,0)
        end
    end

    --local modifier = caster:FindModifierByName("modifier_creeps_spell_Wave51_form3_debuff")
    --local stack = 0
    --if modifier then
    --    stack = modifier:GetStackCount()
    --end
    self.bonus_radius = 900*stack
    self.bonus_time = 5*stack
    if stack == #heros then
        self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_invulnerable",{duration = 30})
        self.bonus_radius = 99100
        self.bonus_time = 24
    end
    ability:CreateChronosphere(caster, caster:GetAbsOrigin(), 900+self.bonus_radius, 5+self.bonus_time, 1)

    if stack ~= 0 then
        self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_creeps_spell_Wave51_tsf_trigger_end",{stack = stack})
    end
    

   --增加攻击力
--    caster:SetBaseDamageMax(caster:GetBaseDamageMax()*1.4)
--    caster:SetBaseDamageMin(caster:GetBaseDamageMin()*1.4)
    caster:IncreaseBaseDamageByModifier(caster:GetBaseDamageMax()*0.4)
    local creeps_spell_Time_Crack = caster:FindAbilityByName("creeps_spell_Time_Crack")
    if creeps_spell_Time_Crack then
        creeps_spell_Time_Crack:TriggerModifier()
    end
    
--    EmitGlobalSound("magnataur_magn_kill_09")  --音效：火山都不在脚下
--    caster:EmitSound("magnataur_magn_kill_09")


--    local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
--    EmitSoundOn( sound_cast, caster )
    if self.nFXIndex ~= nil then
        ParticleManager:DestroyParticle( self.nFXIndex, false )
        ParticleManager:ReleaseParticleIndex( self.nFXIndex )
    end

   for i = 1, #self.phantom, 1 do
    local modifier = self.phantom[i]
    if not modifier:IsNull() then
        modifier:SafeDestroy()
    end
    end
end


function modifier_creeps_spell_Wave51_changing_to_3:CreatePhantom()
    local  caster  =self:GetCaster()
    local unit = caster:SummonUnit("npc_hd_Claszian_Apostasy_phantom",nil,caster:GetAbsOrigin(),nil,self:GetAbility(),0,5000,2000,700,30,1,1)
    FindClearSpaceForUnit( unit, caster:GetAbsOrigin(), true )
    unit:StartGesture(ACT_DOTA_TELEPORT_END)

	local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
	ability:SetLevel(_G.GAME_DIFFICULTY)
	if GetChallengeDifficulty()~=0 then
		local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
		ability:SetLevel(GetChallengeDifficulty())
	end
	_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
	_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
	if GetChallengeDifficulty()>=1 then
		CreateSpecialGainForUnit(unit,0,500,1)  --为产生的单位添加词条
	end
	local modifier = unit:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_Wave51_form3_phantom", {})--提供增益
    -- self.phantom
    table.insert(self.phantom,modifier)
end


function modifier_creeps_spell_Wave51_changing_to_3:OnIntervalThink( kv )


    for i = 1, #self.phantom, 1 do
        local modifier = self.phantom[i]
        if not modifier or modifier:IsNull() then
            table.remove(self.phantom,i)
            i = i -1
        end
    end

    if #self.phantom<3 then
        --self:CreatePhantom()
    end
	
end


function modifier_creeps_spell_Wave51_changing_to_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



modifier_creeps_spell_Wave51_form3_phantom = class({})

function modifier_creeps_spell_Wave51_form3_phantom:IsDebuff()			return false end
function modifier_creeps_spell_Wave51_form3_phantom:IsHidden() 			return true end
function modifier_creeps_spell_Wave51_form3_phantom:IsPurgable() 		return false end
function modifier_creeps_spell_Wave51_form3_phantom:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave51_form3_phantom:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        if parent then
            if parent:IsAlive() then
                TrueKill(parent, parent, self:GetAbility())
                -- parent:AddNewModifier(parent, self:GetAbility() or nil, "modifier_kill", {duration = 0.1}) --召唤持续时间
            else
                local caster = self:GetCaster()
                if caster and caster:IsAlive() then
                    caster:AddNewModifier(caster, self:GetAbility() or nil, "modifier_creeps_spell_Wave51_form3_debuff", {duration = 25}) 
                end
            end
           
        end
        
    end
end


modifier_creeps_spell_Wave51_form3_debuff = advanced_modifier({})

function modifier_creeps_spell_Wave51_form3_debuff:IsDebuff()			return true end
function modifier_creeps_spell_Wave51_form3_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Wave51_form3_debuff:IsPurgable() 		return false end
function modifier_creeps_spell_Wave51_form3_debuff:IsPurgeException() 	return false end
-- function modifier_creeps_spell_Wave51_form3_debuff:IsMotionController() return true end
function modifier_creeps_spell_Wave51_form3_debuff:RemoveOnDeath() return false end

function modifier_creeps_spell_Wave51_form3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end
function modifier_creeps_spell_Wave51_form3_debuff:GetModifierMagicalResistanceBonus()	return -2*self:GetStackCount() end
function modifier_creeps_spell_Wave51_form3_debuff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(1)
	end
end
function modifier_creeps_spell_Wave51_form3_debuff:OnRefresh(keys)
    if IsServer() then
        self:IncrementStackCount()
	end
end



function modifier_creeps_spell_Wave51_form3_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_creeps_spell_Wave51_form3_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -5*self:GetStackCount()
end









--时间结界
----------------------------------------------------------------------------------
modifier_creeps_spell_Wave51_thinker = class({})

function modifier_creeps_spell_Wave51_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/rebuild/spell/chronoshere/effect2/faceless_void_chronosphere.vpcf"



		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)

        pfx_name = "particles/dev/the_world.vpcf"
        local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
        self:AddParticle(pfx, false, false, 16, false, false)
        self:StartIntervalThink(1)
	end
end

function modifier_creeps_spell_Wave51_thinker:IsAura() return true end
function modifier_creeps_spell_Wave51_thinker:GetAuraDuration() return 0.1 end
function modifier_creeps_spell_Wave51_thinker:GetModifierAura() return "modifier_creeps_spell_Wave51_debuff" end
function modifier_creeps_spell_Wave51_thinker:GetAuraRadius() return self.radius end
function modifier_creeps_spell_Wave51_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_creeps_spell_Wave51_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_creeps_spell_Wave51_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_creeps_spell_Wave51_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end

function modifier_creeps_spell_Wave51_thinker:OnDestroy(  )
    UTIL_Remove(self:GetParent())
end

function modifier_creeps_spell_Wave51_thinker:OnIntervalThink()
    if not self:GetCaster():IsAlive() then
        self:SafeDestroy()
    end
end

modifier_creeps_spell_Wave51_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Enemy = 3
Chronosphere_Enemy_Void = 4
function modifier_creeps_spell_Wave51_debuff:OnCreated()
	self.buff_type = 0
	local parent = self:GetParent()
	if parent == self:GetCaster() or parent:GetUnitName()=="npc_hd_Claszian_Apostasy_phantom" or parent:GetUnitName()=="npc_hd_Claszian_Apostasy" then
		self.buff_type = Chronosphere_Caster
	elseif parent:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		self.buff_type = Chronosphere_Ally
	elseif parent:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.buff_type = Chronosphere_Enemy
	else
		self.buff_type = Chronosphere_Enemy
	end
	if IsServer() and self:IsMotionController() then
		parent:InterruptMotionControllers(false)
		self.abs = parent:GetAbsOrigin()
		-- self:StartIntervalThink(FrameTime())
	end
end

function modifier_creeps_spell_Wave51_debuff:OnIntervalThink()
	local parent = self:GetParent()
	parent:InterruptMotionControllers(false)
	parent:SetOrigin(self.abs)
end

function modifier_creeps_spell_Wave51_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_creeps_spell_Wave51_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Wave51_debuff:IsPurgable() 			return false end
function modifier_creeps_spell_Wave51_debuff:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave51_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_creeps_spell_Wave51_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster) end
function modifier_creeps_spell_Wave51_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_creeps_spell_Wave51_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Void) end
function modifier_creeps_spell_Wave51_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_creeps_spell_Wave51_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_creeps_spell_Wave51_debuff:StatusEffectPriority() return 16 end
function modifier_creeps_spell_Wave51_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creeps_spell_Wave51_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_creeps_spell_Wave51_debuff:CheckState()
	if self:IsMotionController() then
		return {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_INVISIBLE] = false,
			[MODIFIER_STATE_FROZEN] = true,
			-- [MODIFIER_STATE_INVISIBLE] = false,
		}
	elseif self.buff_type == Chronosphere_Caster then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_creeps_spell_Wave51_debuff:DeclareFunctions()
    local parent = self:GetParent()
	if self:GetParent()==self:GetCaster() or parent:GetUnitName()=="npc_hd_Claszian_Apostasy_phantom" or parent:GetUnitName()=="npc_hd_Claszian_Apostasy" then
		return 
		{
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, 
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	end

end

function modifier_creeps_spell_Wave51_debuff:GetModifierMoveSpeed_AbsoluteMin()
	return 2500
end

function modifier_creeps_spell_Wave51_debuff:GetModifierMoveSpeed_AbsoluteMax()
	return 2500
end

function modifier_creeps_spell_Wave51_debuff:GetModifierAttackSpeedBonus_Constant()
	if self.buff_type == Chronosphere_Caster then
		return (self:GetStackCount() *15)
	else
		return nil
	end
end

function modifier_creeps_spell_Wave51_debuff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetCaster() or self:GetAbility() ~= self:GetParent():FindAbilityByName("creeps_spell_Wave51") then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:HasModifier("modifier_creeps_spell_Wave51_debuff") or not keys.target:IsAlive() then
		return
	end
	self:IncrementStackCount()
end


--补救措施：虚空bug
modifier_creeps_spell_Wave51_tsf = advanced_modifier({})

function modifier_creeps_spell_Wave51_tsf:IsDebuff() return false end
function modifier_creeps_spell_Wave51_tsf:IsHidden() return true end
function modifier_creeps_spell_Wave51_tsf:IsPurgable() return false end
function modifier_creeps_spell_Wave51_tsf:IsPurgeException() return false end
function modifier_creeps_spell_Wave51_tsf:RemoveOnDeath() return false end

function modifier_creeps_spell_Wave51_tsf:OnCreated(keys)
    if not IsServer() then
        return 
    end
    self:StartIntervalThink(1)
end

function modifier_creeps_spell_Wave51_tsf:OnIntervalThink()
    local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 100000,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

    self.damageTable = {
        attacker	= self:GetCaster(),

		damage_type	= DAMAGE_TYPE_PURE,
		ability		= self:GetAbility(),
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
    }
    for _,hero in pairs(heros)do
        local modifier = hero:FindModifierByName("modifier_creeps_spell_Wave51_tsf_trigger_safe")
        if modifier then
            return
        end
        self.damageTable.victim = hero
        self.damageTable.damage = math.max(hero:GetHealth()*0.10,50)
        ApplyDamage(self.damageTable)
    end
    
end

modifier_creeps_spell_Wave51_tsf_trigger = advanced_modifier({})

function modifier_creeps_spell_Wave51_tsf_trigger:IsDebuff() return false end
function modifier_creeps_spell_Wave51_tsf_trigger:IsHidden() return true end
function modifier_creeps_spell_Wave51_tsf_trigger:IsPurgable() return false end
function modifier_creeps_spell_Wave51_tsf_trigger:IsPurgeException() return false end
function modifier_creeps_spell_Wave51_tsf_trigger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creeps_spell_Wave51_tsf_trigger:OnCreated(params)
    
    if IsServer() then
        self.pos = StringToVector(params.pos)
		self:StartIntervalThink(0.1)
    end
end

function modifier_creeps_spell_Wave51_tsf_trigger:OnIntervalThink()

    local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, 400,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    for _,hero in pairs(heros)do
        if CalculateDistance(hero,self.pos)<=400 then
            hero:AddNewModifier(hero,self:GetAbility(),"modifier_creeps_spell_Wave51_tsf_trigger_safe",{duration = 0.12})
            hero:Purge(true, false, false, true, true) --强驱散
        end
    end
end
-----------------------------------
modifier_creeps_spell_Wave51_tsf_thinker = class({})

function modifier_creeps_spell_Wave51_tsf_thinker:IsAura() return true end
function modifier_creeps_spell_Wave51_tsf_thinker:OnCreated(keys)
	if IsServer() then
        local caster = self:GetCaster()

        self.safe_pos = GetClearSpaceForUnit(caster, caster:GetAbsOrigin() + RandomVector(RandomFloat(1500,2500)))
        self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/creeps_spell/time_dialate_changing/effect.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleShouldCheckFoW( self.nFXIndex,false )
        ParticleManager:SetParticleControl( self.nFXIndex, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl( self.nFXIndex, 1, self.safe_pos)
        ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(400,0,0))
        self:AddParticle( self.nFXIndex, false, false, 0, true, false )
        caster:AddNewModifier(caster,self:GetAbility(),"modifier_creeps_spell_Wave51_tsf",{duration = 25})
        caster:AddNewModifier(caster,self:GetAbility(),"modifier_creeps_spell_Wave51_tsf_trigger",{duration = 25 , pos = self.safe_pos})

        local heros = GetAllRealHeroes()
        for _,hero in pairs(heros)do
            hero:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_creeps_spell_Wave51_tsf_noheal",{duration = 25})
        end
	end
end
-----------------------------------
modifier_creeps_spell_Wave51_tsf_noheal = advanced_modifier({})

function modifier_creeps_spell_Wave51_tsf_noheal:IsDebuff() return true end
function modifier_creeps_spell_Wave51_tsf_noheal:IsHidden() return false end
function modifier_creeps_spell_Wave51_tsf_noheal:IsPurgable() return false end
function modifier_creeps_spell_Wave51_tsf_noheal:IsPurgeException() return false end
function modifier_creeps_spell_Wave51_tsf_noheal:RemoveOnDeath() return false end
function modifier_creeps_spell_Wave51_tsf_noheal:DeclareFunctions()    return {MODIFIER_PROPERTY_DISABLE_HEALING}end
function modifier_creeps_spell_Wave51_tsf_noheal:GetDisableHealing()	return 1 end
---------------------------------
modifier_creeps_spell_Wave51_tsf_trigger_safe = advanced_modifier({})

function modifier_creeps_spell_Wave51_tsf_trigger_safe:IsDebuff() return false end
function modifier_creeps_spell_Wave51_tsf_trigger_safe:IsHidden() return false end
function modifier_creeps_spell_Wave51_tsf_trigger_safe:IsPurgable() return false end
function modifier_creeps_spell_Wave51_tsf_trigger_safe:IsPurgeException() return false end

---------------------------------
modifier_creeps_spell_Wave51_tsf_trigger_end = advanced_modifier({})

function modifier_creeps_spell_Wave51_tsf_trigger_end:IsDebuff() return false end
function modifier_creeps_spell_Wave51_tsf_trigger_end:IsHidden() return false end
function modifier_creeps_spell_Wave51_tsf_trigger_end:IsPurgable() return false end
function modifier_creeps_spell_Wave51_tsf_trigger_end:IsPurgeException() return false end

function modifier_creeps_spell_Wave51_tsf_trigger_end:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)  
    end
end
function modifier_creeps_spell_Wave51_tsf_trigger_end:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
    }
end
function modifier_creeps_spell_Wave51_tsf_trigger_end:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return 30*self:GetStackCount()
end
function modifier_creeps_spell_Wave51_tsf_trigger_end:Advanced_GetModifierAttackSpeedPercentage()
    return 30*self:GetStackCount()
end
function modifier_creeps_spell_Wave51_tsf_trigger_end:Advanced_GetModifierAttackArmor_Ignore()
    return 20*self:GetStackCount()
end