creeps_spell_Wave31 = class({})

LinkLuaModifier("modifier_creeps_spell_Wave31_check", "creeps_spell/creeps_spell_Wave31", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave31_changing_to_2", "creeps_spell/creeps_spell_Wave31", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave31_changing_to_3", "creeps_spell/creeps_spell_Wave31", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave31_stun", "creeps_spell/creeps_spell_Wave31", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wave31_form3_debuff", "creeps_spell/creeps_spell_Wave31", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Wave31:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wave31:IsRefreshable() 			return true end
function creeps_spell_Wave31:IsStealable() 				return true end
function creeps_spell_Wave31:IsNetherWardStealable()		return true end
function creeps_spell_Wave31:GetIntrinsicModifierName() return "modifier_creeps_spell_Wave31_check" end

require('internal/timers')

-------------------------------------------
--设置与获取当前形态
function creeps_spell_Wave31:SetTrigger(int)
	if self.trigger ==nil then
        self.trigger = int
    end
    self.trigger = int
end

function creeps_spell_Wave31:GetTrigger()
	if self.trigger ==nil then
        self.trigger = 1
    end
    return self.trigger
end
-------------------------------------------
--设置与获取当前是否正在变身
function creeps_spell_Wave31:SetTriggerChangging(int)
	if self.trigger_changging ==nil then
        self.trigger_changging = int
    end
    self.trigger_changging = int
end

function creeps_spell_Wave31:GetTriggerChangging()
	if self.trigger_changging ==nil then
        self.trigger_changging = 0
    end
    return self.trigger_changging
end

-------------------------------------------
--检测生命值与形态转变进程，锁血
modifier_creeps_spell_Wave31_check = advanced_modifier({})

function modifier_creeps_spell_Wave31_check:IsDebuff()			 return false end
function modifier_creeps_spell_Wave31_check:IsHidden() 		     return true end
function modifier_creeps_spell_Wave31_check:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave31_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_Wave31_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_Wave31_check:OnCreated(table)   
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

function modifier_creeps_spell_Wave31_check:OnIntervalThink()
	if self.ability:GetTrigger() == 1 then
        self.bonus_status_resistance = self.pattern_1_status_resistance
    elseif self.ability:GetTrigger() == 2 then
        self.bonus_status_resistance = self.pattern_2_status_resistance
    else
        self.bonus_status_resistance = self.pattern_3_status_resistance
    end
end




-------------------------------------------------------------------------------------------------
function modifier_creeps_spell_Wave31_check:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH,
    MODIFIER_EVENT_ON_DEATH}
end
function modifier_creeps_spell_Wave31_check:OnDeath(keys)
    if IsClient() then
        return
    end
    if keys.unit == self:GetParent() then
        Timers:CreateTimer(3, function()  --延迟3秒防止有人把boss秒杀导致状态无限存在
            local heroes = GetAllRealHeroes()
            for  _, hero in pairs(heroes) do
                local modifier = hero:FindModifierByName("modifier_creeps_spell_Wave31_form3_debuff")
                if modifier then
                    modifier:SafeDestroy()
                end
    
    
            end
        end)
      
    end


end
--形态转变的核心触发事件
--当生命值低于阈值时开启转变
function modifier_creeps_spell_Wave31_check:OnTakeDamage(keys)
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
        caster:EmitSound("magnataur_magn_levelup_14")
        self:GetParent():StartGesture(ACT_SIGNAL2 )
        	Timers:CreateTimer(0.5, function()
                self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave31_changing_to_2", {duration = 3})  --开始转变
	    end)
        
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
        self:GetParent():AddNewModifier(caster, ability, "modifier_creeps_spell_Wave31_changing_to_3", {duration = 15})  --开始转变
    end
    -----------------------------------------------
end

function modifier_creeps_spell_Wave31_check:GetMinHealth() 
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

function modifier_creeps_spell_Wave31_check:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_creeps_spell_Wave31_check:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end

--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave31_changing_to_2 = advanced_modifier({})

function modifier_creeps_spell_Wave31_changing_to_2:IsDebuff()			 return false end
function modifier_creeps_spell_Wave31_changing_to_2:IsHidden() 		     return true end
function modifier_creeps_spell_Wave31_changing_to_2:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave31_changing_to_2:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave31_changing_to_2:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end
function modifier_creeps_spell_Wave31_changing_to_2:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end
--免疫所有伤害
function modifier_creeps_spell_Wave31_changing_to_2:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave31_changing_to_2:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
--释放质引
function modifier_creeps_spell_Wave31_changing_to_2:OnCreated()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	-- Get data
	local radius = 1000


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 3, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )


    self.effect_cast = effect_cast
	-- Create Sound
	EmitSoundOn( sound_cast, caster )





    local range = 250
    
    local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf"
    local sound_cast = "Hero_Magnataur.ReversePolarity.Stun"

    local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
    local heroes = GetAllRealHeroes()
    for _,enemy in pairs(enemies) do
		-- move to front
		local origin = enemy:GetOrigin()
		local pos = caster:GetOrigin() + caster:GetForwardVector() * range
		FindClearSpaceForUnit( enemy, pos, true )
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
        ParticleManager:SetParticleControl( effect_cast, 1, origin )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( sound_cast, target )
        enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_creeps_spell_Wave31_stun", -- modifier name
			{ duration = 2 } -- kv
		)
	end
    for _,enemy in pairs(heroes) do
		-- move to front
		local origin = enemy:GetOrigin()
		local pos = caster:GetOrigin() + caster:GetForwardVector() * range
		FindClearSpaceForUnit( enemy, pos, true )
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
        ParticleManager:SetParticleControl( effect_cast, 1, origin )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( sound_cast, target )
        enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_creeps_spell_Wave31_stun", -- modifier name
			{ duration = 2 } -- kv
		)
	end


end

function modifier_creeps_spell_Wave31_changing_to_2:OnDestroy()
    local ability = self:GetAbility()
    ability:SetTrigger(2)            --开启第二形态
    if not IsServer() then
        return
    end
    local caster = ability:GetCaster()
    local pos = caster:GetAbsOrigin()
    ability:SetTriggerChangging(0)   --变身结束
    caster.pattern_2 = true
   
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
     nil, 500,
      DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
        FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
    
        enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave31_stun", {duration = 10})
        
        
	end




	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )


	local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	EmitSoundOn( sound_cast, caster )





    -- EmitGlobalSound("magnataur_magn_empower_04")  --音效：粉碎敌人
    caster:EmitSound("magnataur_magn_empower_04")
end


function modifier_creeps_spell_Wave31_changing_to_2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




--------------------------------------------------------
--状态二变身中
modifier_creeps_spell_Wave31_changing_to_3 = advanced_modifier({})

function modifier_creeps_spell_Wave31_changing_to_3:IsDebuff()			 return false end
function modifier_creeps_spell_Wave31_changing_to_3:IsHidden() 		     return true end
function modifier_creeps_spell_Wave31_changing_to_3:IsPurgable() 		 return false end
function modifier_creeps_spell_Wave31_changing_to_3:IsPurgeException() 	 return false end
--石化与冻结
function modifier_creeps_spell_Wave31_changing_to_3:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave31_changing_to_3:DeclareFunctions() 
    local decFuncs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return decFuncs
end
--免疫所有伤害
function modifier_creeps_spell_Wave31_changing_to_3:Advanced_GetModifierIncomingDamage_Percentage() 
    return -100
end
function modifier_creeps_spell_Wave31_changing_to_3:GetMinHealth()
    if not self.minHealth then
        self.minHealth = self:GetParent():GetHealth()
    end
    return self.minHealth or 1
end
function modifier_creeps_spell_Wave31_changing_to_3:OnCreated(keys)
    if IsServer() then
        local caster = self:GetCaster()
 
        local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_boss.vpcf"
        local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

        -- Get data
        local radius = 1000


        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
        ParticleManager:SetParticleControl( effect_cast, 2, Vector( 3, 0, 0 ) )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            3,
            caster,
            PATTACH_ABSORIGIN_FOLLOW,
            "attach_hitloc",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )

--
        self.effect_cast = effect_cast
        -- Create Sound
        EmitSoundOn( sound_cast, caster )

        self:StartIntervalThink(1)


    end

end

function modifier_creeps_spell_Wave31_changing_to_3:OnDestroy()
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
   caster:EmitSound("magnataur_magn_kill_09")


   local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
   EmitSoundOn( sound_cast, caster )
   ParticleManager:DestroyParticle( self.effect_cast, false )
   ParticleManager:ReleaseParticleIndex( self.effect_cast )

end





function modifier_creeps_spell_Wave31_changing_to_3:OnIntervalThink( kv )

	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
			for i = 1, 3, 1 do
                local pos =hero:GetAbsOrigin()
                pos.x = pos.x +RandomInt(-500, 500)
                pos.y = pos.y +RandomInt(-500, 500)
                local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_boss.vpcf"
                local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

                -- Create Particle
                local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
                ParticleManager:SetParticleControl( effect_cast, 1, Vector( 500, 500, 500 ) )
                ParticleManager:SetParticleControl( effect_cast, 2, Vector( 3, 0, 0 ) )
                ParticleManager:SetParticleControl( effect_cast, 3, pos )
                -- ParticleManager:SetParticleControlEnt(effect_cast,3,hero,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",
                --     Vector(0,0,0), -- unknown
                --     true -- unknown, true
                -- )
                ParticleManager:SetParticleControlForward( effect_cast, 3, hero:GetForwardVector() )


			
				EmitSoundOnLocationWithCaster( pos, sound_cast, caster )
				Timers:CreateTimer(2.5, function()

					ParticleManager:ReleaseParticleIndex( effect_cast )
					EmitSoundOnLocationWithCaster( pos, "Hero_Magnataur.ReversePolarity.Cast", caster )

					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos,
					nil, 550,
					 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					  DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
					   FIND_ANY_ORDER, false)
					for _, enemy in pairs(enemies) do
                        enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Wave31_form3_debuff", {})
					end

				end)
			end
			
        end
    end
	
end


function modifier_creeps_spell_Wave31_changing_to_3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




modifier_creeps_spell_Wave31_stun = advanced_modifier({})

function modifier_creeps_spell_Wave31_stun:IsDebuff()			return true end
function modifier_creeps_spell_Wave31_stun:IsHidden() 			return false end
function modifier_creeps_spell_Wave31_stun:IsPurgable() 		return false end
function modifier_creeps_spell_Wave31_stun:IsPurgeException() 	return false end
function modifier_creeps_spell_Wave31_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_creeps_spell_Wave31_stun:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end
function modifier_creeps_spell_Wave31_stun:DeclareFunctions() 
    return
	{ 
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    } 
end
function modifier_creeps_spell_Wave31_stun:Advanced_GetModifierIncomingDamage_Percentage() 
    return 50
end

function modifier_creeps_spell_Wave31_stun:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



modifier_creeps_spell_Wave31_form3_debuff = advanced_modifier({})

function modifier_creeps_spell_Wave31_form3_debuff:IsDebuff()			return true end
function modifier_creeps_spell_Wave31_form3_debuff:IsHidden() 			return false end
function modifier_creeps_spell_Wave31_form3_debuff:IsPurgable() 		return false end
function modifier_creeps_spell_Wave31_form3_debuff:IsPurgeException() 	return false end
-- function modifier_creeps_spell_Wave31_form3_debuff:IsMotionController() return true end
function modifier_creeps_spell_Wave31_form3_debuff:RemoveOnDeath() return false end
function modifier_creeps_spell_Wave31_form3_debuff:Advanced_GetModifierIncomingDamage_Percentage() 
        return 5*self:GetStackCount()
end


function modifier_creeps_spell_Wave31_form3_debuff:OnCreated(keys)
    if IsServer() then


        self:SetStackCount(1)
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_creeps_spell_Wave31_form3_debuff:OnRefresh(keys)
    if IsServer() then


        self:IncrementStackCount()

	end
end



function modifier_creeps_spell_Wave31_form3_debuff:OnIntervalThink(keys)   
    if  IsServer() then
        if not self:GetAbility() then
            self:SafeDestroy()
            return
        end
        local stack = self:GetStackCount()
        local parent = self:GetParent()
        if parent:IsMagicImmune() or parent:IsInvulnerable() then
            return
        end
        local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(),
        nil, 900,
         DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_NONE ,
           FIND_CLOSEST, false)

        if #enemies>=2 then
            local pos_caster = parent:GetAbsOrigin()  --获取自己
            local pos_target = enemies[2]:GetAbsOrigin() --获取敌人
            if CalculateDistance(pos_caster,pos_target)<=100  then
                return
            end
            local dt = FrameTime()
          
            local direction = (pos_target - pos_caster):Normalized()
            direction.z = 0  --初始化Z值
            local new_pos = parent:GetAbsOrigin() + direction * (math.min(600, stack*50) / (1.0 / dt))  
            new_pos = GetGroundPosition(new_pos, nil)   
            parent:SetOrigin(new_pos)  
            ResolveNPCPositions(new_pos, 70)
        end
       
    end
end

function modifier_creeps_spell_Wave31_form3_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

