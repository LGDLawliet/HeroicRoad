--特效优化 √
Advanced_Nature_Attendants = class({})
LinkLuaModifier("modifier_Advanced_Nature_Attendants_hp", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nature_Attendants_hp2", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nature_Attendants_Purge", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Nature_Attendants_hp_unlock1", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nature_Attendants_hp_unlock2", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nature_Attendants_unlock3", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nature_Attendants_unlock1", "skills/Advanced_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)
function Advanced_Nature_Attendants:IsHiddenWhenStolen()        return false end
function Advanced_Nature_Attendants:IsStealable()               return true end
function Advanced_Nature_Attendants:IsRefreshable() 			return true end
function Advanced_Nature_Attendants:CheckKV(key)
	local table = {

	


		basic_healing = 1,
		intelligence_index = 0.004,





	}
	local value = table[key] or -1
	return value

end

function Advanced_Nature_Attendants:UnlockFirstCore(key)
    local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Nature_Attendants_unlock1",{})
	return true
end
function Advanced_Nature_Attendants:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Nature_Attendants:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Nature_Attendants_unlock3",{})
	return true
end


function Advanced_Nature_Attendants:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/natures_attendants/unlock1/effect_count3.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/plus/high_five/high_five_impact_burst.vpcf", context )

end





function Advanced_Nature_Attendants:OnSpellStart()
    local caster=self:GetCaster()
    caster:EmitSound("Hero_Enchantress.NaturesAttendantsCast")

    local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.5)
    caster:AddNewModifier(caster, self, "modifier_Advanced_Nature_Attendants_hp", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
    caster:AddNewModifier(caster, self, "modifier_Advanced_Nature_Attendants_Purge", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})
end
function Advanced_Nature_Attendants:GetIntrinsicModifierName() 
    return "modifier_Advanced_Nature_Attendants_hp2" 
end


modifier_Advanced_Nature_Attendants_hp = class({})

function modifier_Advanced_Nature_Attendants_hp:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_hp:IsPurgeException()   	return true end
function modifier_Advanced_Nature_Attendants_hp:IsHidden()				return false end
function modifier_Advanced_Nature_Attendants_hp:GetAttributes()				return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Nature_Attendants_hp:OnCreated()		
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

    local heal_interval = ability:GetSpecialValueFor("heal_interval")
    self.heal_int = ability:GetSpecialValueFor("basic_healing") + (ability:GetSpecialValueFor("intelligence_index")) * caster:GetIntellect(false)
    self.radius = ability:GetSpecialValueFor("radius")
    --LV15解锁广域之类
    if self.advanced_level>=15 then
        self.radius = 800
    end
    self._count = ability:GetSpecialValueFor("number")
    --LV20解锁精灵之海
    if self.advanced_level>=20 then
        self._count = self._count +5
    end
    if IsServer() then
        self.radius = self.radius + self:GetParent():GetCastRangeBonus() 
        self.radius = math.max(self.radius,100)

        self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count8.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
        for num = 3, 9 do 
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false) 
    	self:StartIntervalThink(heal_interval)
    end	
end

function modifier_Advanced_Nature_Attendants_hp:OnRefresh()		
   self:OnCreated()	
end

function modifier_Advanced_Nature_Attendants_hp:OnIntervalThink()	
    -- local facing_direction = self:GetParent():GetAnglesAsVector().y


    local parent = self:GetParent()
    local ability = self:GetAbility()
    local heros = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,  self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if #heros>0 then 
        local i = 1
        local num = 1
        local end_i = 0
        local healing_table = {}
        while true do
            if i > #heros then
                i = 1
            end
            if heros[i]:GetHealth() ~= heros[i]:GetMaxHealth() then
                local healing = HealWithGain(self.heal_int,parent,heros[i],ability)
                -- 进行治疗
  

                if healing>0 then
                    if healing_table[heros[i]] then
                        healing_table[heros[i]].healing_counut = healing_table[heros[i]].healing_counut+healing
                        healing_table[heros[i]].heal_count = healing_table[heros[i]].heal_count +1
                    else
                        healing_table[heros[i]] = {}
                        healing_table[heros[i]].healing_counut = healing
                        healing_table[heros[i]].hero = heros[i]
                        healing_table[heros[i]].heal_count = 1
                    end

                end
                num = num + 1
                i = i + 1
            else
                i = i + 1
                end_i = end_i +1
            end
            if end_i > self._count or num > self._count then
                break
            end
        end


        if ability.unlock2 then
            
            local caster = self:GetCaster()
            for _, hero in ipairs(heros) do
                if healing_table[hero] then
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,hero, healing_table[hero].healing_counut, nil) 
                    if hero:IsRealHero() then
                        hero:AddNewModifier(caster, ability, "modifier_Advanced_Nature_Attendants_hp_unlock2", {stack =healing_table[hero].heal_count })
                    end
                end
            end
        else
            for _, hero in ipairs(heros) do
                if healing_table[hero] then
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,hero, healing_table[hero].healing_counut, nil) 
                end
            end
        end

       
    end
end	


function modifier_Advanced_Nature_Attendants_hp:OnSummonUnit(keys)
	if IsServer() then
        local ability = self:GetAbility()
        if ability.unlock1 then
            local unit = keys.target
            unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Nature_Attendants_hp_unlock1", {})
   
        end
	end
end




modifier_Advanced_Nature_Attendants_hp2 = class({})

function modifier_Advanced_Nature_Attendants_hp2:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_hp2:IsPurgeException() 	return false end
function modifier_Advanced_Nature_Attendants_hp2:IsHidden()				return true end


function modifier_Advanced_Nature_Attendants_hp2:OnCreated()		


    if IsServer() then
        local ability = self:GetAbility()
	    local caster = self:GetCaster()

	    self.advanced_level = 1

        self.heal_int = ability:GetSpecialValueFor("basic_healing") + (ability:GetSpecialValueFor("intelligence_index")) * caster:GetIntellect(false)

        self.radius = ability:GetSpecialValueFor("radius")
        self._count = ability:GetSpecialValueFor("bonus_elves")
        self.radius = self.radius + self:GetParent():GetCastRangeBonus() 
        self.radius = math.max(self.radius,100)
        self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count3.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
        for num = 3, 5 do 
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false) 
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("heal_interval"))
    end	
end

function modifier_Advanced_Nature_Attendants_hp2:OnRefresh()		
    -- self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("heal_interval"))
    
    if IsServer() then
        local ability = self:GetAbility()
	    local caster = self:GetCaster()
	    self.advanced_level = ability:GetSpecialValueFor("advanced_level")

        self.heal_int = ability:GetSpecialValueFor("basic_healing") + (ability:GetSpecialValueFor("intelligence_index")) * caster:GetIntellect(false)

        --LV10解锁森林之子+
        if self.advanced_level>=10 then
            self.heal_int = self.heal_int *1.5
        end
        self.radius = ability:GetSpecialValueFor("radius")
        self._count = ability:GetSpecialValueFor("bonus_elves")
        self.radius = self.radius + self:GetParent():GetCastRangeBonus() 
        self.radius = math.max(self.radius,100)
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("heal_interval"))
    end	
end

function modifier_Advanced_Nature_Attendants_hp2:OnIntervalThink()			
    if self:GetParent():PassivesDisabled() or  not self:GetParent():IsAlive() or  not IsServer() then
        return
    end		
    
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    --该技能需要从网表拿等级数据 自定义变量拿不到该值
    local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
    self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

    self.heal_int = ability:GetSpecialValueFor("basic_healing") + (ability:GetSpecialValueFor("intelligence_index")) * caster:GetIntellect(false)

    --LV10解锁森林之子+
    if self.advanced_level>=10 then
        self.heal_int = self.heal_int *1.5
    end

    local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if #heros>0 then 
        local i = 1
        local num = 1
        local end_i = 0
        local healing_table = {}
        while true do
            if i > #heros then
                i = 1
            end
            if heros[i]:GetHealth() ~= heros[i]:GetMaxHealth() then
                local healing = HealWithGain(self.heal_int,self:GetParent(),heros[i],self:GetAbility())
                if healing>0 then
                    if healing_table[heros[i]] then
                        healing_table[heros[i]].healing_counut = healing_table[heros[i]].healing_counut+healing
                        healing_table[heros[i]].heal_count = healing_table[heros[i]].heal_count +1
                    else
                        healing_table[heros[i]] = {}
                        healing_table[heros[i]].healing_counut = healing
                        healing_table[heros[i]].hero = heros[i]
                        healing_table[heros[i]].heal_count = 1
                    end

                end
                num = num + 1
                i = i + 1
            else
                i = i + 1
                end_i = end_i +1
            end
            if end_i > self._count or num > self._count then
                break
            end
        end
        if ability.unlock2 then
            
            local caster = self:GetCaster()
            for _, hero in ipairs(heros) do
                if healing_table[hero] then
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,hero, healing_table[hero].healing_counut, nil) 
                    if hero:IsRealHero() then
                        hero:AddNewModifier(caster, ability, "modifier_Advanced_Nature_Attendants_hp_unlock2", {stack =healing_table[hero].heal_count })
                    end
                    
                end
            end
        else
            for _, hero in ipairs(heros) do
                if healing_table[hero] then
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,hero, healing_table[hero].healing_counut, nil) 
                end
            end
        end

    end
end	







modifier_Advanced_Nature_Attendants_Purge = class({})

function modifier_Advanced_Nature_Attendants_Purge:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_Purge:IsPurgeException()   	return true end
function modifier_Advanced_Nature_Attendants_Purge:IsHidden()				return true end
function modifier_Advanced_Nature_Attendants_Purge:GetAttributes()				return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Nature_Attendants_Purge:OnCreated()		
    if IsServer() then
        local ability = self:GetAbility()
        local heal_interval = ability:GetSpecialValueFor("purge_interval")
        self.radius = ability:GetSpecialValueFor("radius")
        self.advanced_level = ability.advanced_level
        self:StartIntervalThink(heal_interval)
    end	
end

function modifier_Advanced_Nature_Attendants_Purge:OnRefresh()		
   self:OnCreated()	
end

function modifier_Advanced_Nature_Attendants_Purge:OnIntervalThink()			
    local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    --LV5解锁自然而然+
    if self.advanced_level>=5 then
        if #heros>0 then 
            for i=1, #heros do
    
                heros[i]:Purge(false, true, false, false, true)--强驱散
            end
        end 
    else
        if #heros>0 then 
            for i=1, #heros do
    
                heros[i]:Purge(false, true, false, false, false)
            end
        end
    end

end	







modifier_Advanced_Nature_Attendants_hp_unlock1 = class({})

function modifier_Advanced_Nature_Attendants_hp_unlock1:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_hp_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Nature_Attendants_hp_unlock1:IsHidden()				return true end


function modifier_Advanced_Nature_Attendants_hp_unlock1:OnCreated()		
    if IsServer() then
        local ability = self:GetAbility()
        self.radius = ability:GetSpecialValueFor("radius")
        self._count =2
        self.radius = self.radius + self:GetParent():GetCastRangeBonus() 
        self.radius = math.max(self.radius,100)
        self.particle2 = ParticleManager:CreateParticle( "particles/rebuild/spell/natures_attendants/unlock1/effect_count3.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
        for num = 3, 4 do 
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false) 
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("heal_interval"))
    end	
end


function modifier_Advanced_Nature_Attendants_hp_unlock1:OnIntervalThink()			
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local heal_int = ability:GetSpecialValueFor("basic_healing") + (ability:GetSpecialValueFor("intelligence_index")) * caster:GetIntellect(false)
    heal_int =heal_int *1.5


    local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if #heros>0 then 
        local i = 1
        local num = 1
        local end_i = 0
        local healing_table = {}
        while true do
            if i > #heros then
                i = 1
            end
            if heros[i]:GetHealth() ~= heros[i]:GetMaxHealth() then
                local healing = HealWithGain(heal_int,self:GetParent(),heros[i],self:GetAbility())
                if healing>0 then
                    if healing_table[heros[i]] then
                        healing_table[heros[i]].healing_counut = healing_table[heros[i]].healing_counut+healing
                    else
                        healing_table[heros[i]] = {}
                        healing_table[heros[i]].healing_counut = healing
                        healing_table[heros[i]].hero = heros[i]
                    end

                end
                num = num + 1
                i = i + 1
            else
                i = i + 1
                end_i = end_i +1
            end
            if end_i > self._count or num > self._count then
                break
            end
        end

        for _, hero in ipairs(heros) do
            if healing_table[hero] then
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,hero, healing_table[hero].healing_counut, nil) 
            end
        end
    end
end	







modifier_Advanced_Nature_Attendants_hp_unlock2 = class({})

function modifier_Advanced_Nature_Attendants_hp_unlock2:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_hp_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Nature_Attendants_hp_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Nature_Attendants_hp_unlock2:IsHidden()				return false end
function modifier_Advanced_Nature_Attendants_hp_unlock2:IsDebuff() return false end
function modifier_Advanced_Nature_Attendants_hp_unlock2:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_Advanced_Nature_Attendants_hp_unlock2:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(math.min(15000,keys.stack+self:GetStackCount()))
    end
end

function modifier_Advanced_Nature_Attendants_hp_unlock2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
end


function modifier_Advanced_Nature_Attendants_hp_unlock2:GetModifierHealthBonus()	return self:GetStackCount() end




modifier_Advanced_Nature_Attendants_unlock3 = class({})

function modifier_Advanced_Nature_Attendants_unlock3:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Nature_Attendants_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Nature_Attendants_unlock3:IsHidden()				return false end
function modifier_Advanced_Nature_Attendants_unlock3:IsDebuff() return false end
function modifier_Advanced_Nature_Attendants_unlock3:OnCreated(keys)
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end
function modifier_Advanced_Nature_Attendants_unlock3:OnIntervalThink()
    local stack = self:GetStackCount()
    if stack >0 then
        local parent = self:GetParent()
        local enemies = FindUnitsInRadius(
			parent:GetTeamNumber(),	-- int, your team number
			parent:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
		)

		local damageTable = {
			attacker = parent,
			damage =stack,
			damage_type =DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
		}
	
        for i,enemy in pairs(enemies) do
            local head_particle = ParticleManager:CreateParticle("particles/econ/events/plus/high_five/high_five_impact_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
            ParticleManager:SetParticleControlEnt(head_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_attack1", enemy:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(head_particle, 3, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(head_particle)
            enemy:EmitSound("Hero_Mirana.Starstorm.Impact")
            damageTable.victim = enemy
            ApplyDamage(damageTable)
            self:SetStackCount(0)
            break
        end
    end
end
function modifier_Advanced_Nature_Attendants_unlock3:OnCustomModifierFunction_Heal(keys)
    if not Game_State:IsInBattle() then
        return
    end
    if keys.heal>0 then
        self:SetStackCount(self:GetStackCount()+keys.heal)
    end
end







modifier_Advanced_Nature_Attendants_unlock1 = advanced_modifier({})

function modifier_Advanced_Nature_Attendants_unlock1:IsPurgable() 			return false end
function modifier_Advanced_Nature_Attendants_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Nature_Attendants_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Nature_Attendants_unlock1:IsHidden()				return true end
function modifier_Advanced_Nature_Attendants_unlock1:IsDebuff() return false end

function modifier_Advanced_Nature_Attendants_unlock1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_Advanced_Nature_Attendants_unlock1:Advanced_GetModifier_Summon_Intensity(keys)
	return 20
end


