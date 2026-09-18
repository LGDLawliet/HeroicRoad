-- 重写完成
item_hd_artifact_58 = class({})
LinkLuaModifier("modifier_item_hd_artifact_58", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_buff", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_chaotic_lucent_beam", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_chaotic_static_storm", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_chaotic_death_cloud", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_lv40_fire", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_strom_thinker", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_strom_damage", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_buff_lv60", "player_artifact/item_hd_artifact_58.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_58_lv70", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
require("internal/weather_controler")
function item_hd_artifact_58:GetIntrinsicModifierName()
	return "modifier_item_hd_artifact_58"
end
function item_hd_artifact_58:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock1/effect_ground_beam.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/disruptor/disruptor_2022_immortal/disruptor_2022_immortal_static_storm.vpcf", context )
end
function item_hd_artifact_58:SciAllCheck(target)
	if target then
        if target:HasModifier("modifier_item_hd_summon_ring_effects") 
            and target:HasModifier("modifier_item_hd_artifact_56") 
            and target:HasModifier("modifier_item_hd_artifact_57")
            and target:HasModifier("modifier_item_hd_artifact_58") then
            return true
        end
        return
    end
    return
end
function item_hd_artifact_58:SciCheck(target)
	if target then
        if target:GetUnitName() == "npc_hd_artifact_sci_dragon" 
            or target:GetUnitName() == "npc_hd_spirit_of_sci_snake" 
            or target:GetUnitName() == "npc_hd_artifact_sci_cat"
            or target:GetUnitName() == "npc_hd_artifact_sci_blue_whale" then
            return true
        end
        return
    end
    return
end
function item_hd_artifact_58:SciAllLevelCheck(target)
	if target then
        if GetArtifactLevel(target:GetPlayerOwnerID(),"item_hd_summon_ring_effects") >= 40 
            and GetArtifactLevel(target:GetPlayerOwnerID(),"item_hd_artifact_56") >= 40 
            and GetArtifactLevel(target:GetPlayerOwnerID(),"item_hd_artifact_57") >= 40 
            and GetArtifactLevel(target:GetPlayerOwnerID(),"item_hd_artifact_58") >= 40  then
            return true
        end
        return
    end
    return
end
function item_hd_artifact_58:GetArtifactSpecialList()
    local list = {}
    list["76561198101659620"] = true
    return list
end
function item_hd_artifact_58:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_artifact_58:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end

modifier_item_hd_artifact_58 = advanced_modifier({})

function modifier_item_hd_artifact_58:IsDebuff() return false end
function modifier_item_hd_artifact_58:IsHidden() return true end
function modifier_item_hd_artifact_58:IsPurgable() return false end
function modifier_item_hd_artifact_58:RemoveOnDeath() return false end
function modifier_item_hd_artifact_58:GetTexture() return "item_artifact_59" end

function modifier_item_hd_artifact_58:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.block = self.ability:GetArtifactSpecialValueFor("block")
    self.bonus_2 = self.ability:GetArtifactSpecialValueFor("bonus_2")
    self.bonus_3 = self.ability:GetArtifactSpecialValueFor("bonus_3")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_58")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_artifact_58:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.block = self.ability:GetArtifactSpecialValueFor("block")
    self.bonus_2 = self.ability:GetArtifactSpecialValueFor("bonus_2")
    self.bonus_3 = self.ability:GetArtifactSpecialValueFor("bonus_3")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_58")
end
function modifier_item_hd_artifact_58:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_artifact_58:OnTooltip()
	return self:GetStackCount()
end
function modifier_item_hd_artifact_58:OnIntervalThink()
    self:SummonSlime()
end

function modifier_item_hd_artifact_58:SummonSlime()
    if not IsServer() then return end
    
    local count = 1
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	local caster = self:GetCaster()
    local armor = 2* caster:GetPhysicalArmorValue(false)
	local life_duration = self.interval +10

    local health = 0
    local attack = 0
    local shop = chaotic_era_shop:GetPlayerShopLevel(caster:GetPlayerOwnerID(),true)
    -- print("商店等级是"..shop)
    if shop <= 3 then
        attack = 30 + 3*shop + GetWave()*1
        health = 56 + 5*shop + GetWave()*1
        -- print("1-3级商店.."..attack)
    elseif shop > 3 and shop <= 7 then
        attack = 40 + 4*shop + GetWave()*3
        health = 70 + 4*shop + GetWave()*3
        -- print("4-7级商店.."..attack)
    elseif shop > 7 then
        attack = 50 + 5*shop + GetWave()*6
        health = 91 + 6*shop + GetWave()*6
        -- print("8-13级商店.."..attack)
    end

    local heal = health*0.01*1.1 * caster:GetMaxHealth()+1000
	local damage = attack*0.01* math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+30

    local casterID = tostring(PlayerResource:GetSteamID(caster:GetPlayerOwnerID()))
	if casterID == "76561198101659620"  then
        heal = heal*1.5 +500
        damage = damage*1.5 +150
    end

    if caster:HasModifier("modifier_item_hd_summon_ring_effects") then
        heal = heal*1.1
        damage = damage*1.1
    end
    if caster:HasModifier("modifier_item_hd_artifact_57") then
        heal = heal*1.2
        damage = damage*1.2
    end
    if caster:HasModifier("modifier_item_hd_artifact_56") then
        heal = heal*1.3
        damage = damage*1.3
    end

	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 400) 
	local unit = caster:SummonUnit("npc_hd_artifact_sci_blue_whale",life_duration,unit_pos,caster:GetForwardVector(),self:GetAbility(),0,heal,nil,damage,armor,1,0)

	table.insert(self.summon_table,unit)
	unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_58_buff", {level = self.level})
    if self.level >= 40 and self:GetAbility():SciAllCheck(caster) and self:GetAbility():SciAllLevelCheck(caster) then
        local ability1 = unit:AddAbility("chaotic_element_fire")
        if ability1 then
            ability1:SetLevel(1)
        end
        local ability2 = unit:AddAbility("chaotic_element_lightning")
        if ability2 then
            ability2:SetLevel(1)
        end
        local ability3 = unit:AddAbility("chaotic_element_ice")
        if ability3 then
            ability3:SetLevel(1)
        end
        local ability4 = unit:AddAbility("chaotic_flame_strike")
        if ability4 then
            ability4:SetLevel(1)
            unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_58_lv40_fire", {})
        end
    end

    if self.level >= 60 and caster:GetLevel() >= 30 then
        unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_58_buff_lv60", {})
    end
    if self.level >= 70 then
        local spell = 0
        local spell_amp = self.parent:GetSpellAmplification(false)*100
		if spell_amp>0 then
			spell = math.min(spell_amp*self.spell_give_7, self.spell_max_7)
		end
        unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_58_lv70", {spell = spell})
    end
end

function modifier_item_hd_artifact_58:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
    }
end

function modifier_item_hd_artifact_58:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end

function modifier_item_hd_artifact_58:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
    if not self:GetParent():HasModifier("modifier_item_chaotic_class_summon") then
        return 0
    end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
	return self.bonus_block*self:GetParent():GetLevel()
end

-- function modifier_item_hd_artifact_58:OnSummonUnitFinished(keys)
--     if not IsServer() then return end
--     if not keys.target then return end
--     if not self:GetAbility():SciCheck(keys.target) then
--         keys.target:ModifyHealth(0, self:GetAbility(), true, 0)
--     end
-- end
-----
modifier_item_hd_artifact_58_buff = advanced_modifier({})

function modifier_item_hd_artifact_58_buff:IsDebuff() return false end
function modifier_item_hd_artifact_58_buff:IsHidden() return true end
function modifier_item_hd_artifact_58_buff:IsPurgable() return false end
function modifier_item_hd_artifact_58_buff:RemoveOnDeath() return false end
function modifier_item_hd_artifact_58_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)
        self:StartIntervalThink(10)
        

        self.weather_table = {
            
        }
        weather_controler:SwitchWeather("Default")
        self:OnIntervalThink()
    end
end

function modifier_item_hd_artifact_58_buff:OnDestroy()
    self.weather_table = {}
    weather_controler:SwitchWeather("Default")
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
	end
end
function modifier_item_hd_artifact_58_buff:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
    }
    return funcs
end

function modifier_item_hd_artifact_58_buff:CheckState()
    return{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end
    
function modifier_item_hd_artifact_58_buff:OnDeath(keys)
    if not IsServer() then return end
    if not self:GetCaster() then return end
    if keys.attacker ~= self:GetParent() then return end
    local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_artifact_57")
    local modifier2 = self:GetCaster():FindModifierByName("modifier_item_hd_artifact_56")
    local modifier3 = self:GetCaster():FindModifierByName("modifier_item_hd_summon_ring_effects")
    if modifier then
        modifier:SetStackCount(math.min(modifier:GetStackCount() + 1, 5000))
    end
    if modifier2 then
        modifier2:SetStackCount(math.min(modifier2:GetStackCount() + 1, 5000))
    end
    if modifier3 then
        modifier3:SetStackCount(math.min(modifier3:GetStackCount() + 1, 5000))
    end
end

function modifier_item_hd_artifact_58_buff:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetAbility() then self:Destory() return end
    local caster = self:GetCaster()
    local unit = self:GetParent()
    if not unit:IsAlive() then return end
    
    local dragon = caster:FindModifierByName("modifier_item_hd_summon_ring_effects")
    local snake = caster:FindModifierByName("modifier_item_hd_artifact_56")
    local cat = caster:FindModifierByName("modifier_item_hd_artifact_57")
    self.dragon_lvl = GetArtifactLevel(unit:GetPlayerOwnerID(),dragon)
    self.snake_lvl = GetArtifactLevel(unit:GetPlayerOwnerID(),snake)
    self.cat_lvl = GetArtifactLevel(unit:GetPlayerOwnerID(),cat)
    
    -- 重置天气表
    self.weather_table = {}
    
    print(dragon)
    -- 根据激活条件构建天气表
    if self:GetStackCount() >= 10 and dragon then
        table.insert(self.weather_table, "Moonbeam")
    end
    if self:GetStackCount() >= 20 and cat then
        table.insert(self.weather_table, "Rain")
    end
    if self:GetStackCount() >= 30 and snake then
        table.insert(self.weather_table, "Pestilence")
    end
    
    -- 如果没有任何天气激活，使用默认天气
    if #self.weather_table == 0 then
        self.weather_table = {"Default"}
    end

    -- 更新计数器
    if not self.i then
        self.i = 1
    else
        self.i = self.i + 1
    end

    if self.i > #self.weather_table then
        self.i = 1
    end
    
    self:ChangeWeather(self.weather_table[self.i])
end

function modifier_item_hd_artifact_58_buff:ChangeWeather(weather_name)
    if not weather_name then 
        weather_controler:SwitchWeather("Default")
    end
    local abilityname 
    weather_controler:SwitchWeather(weather_name)
    if weather_name == "Moonbeam" then
        abilityname = "chaotic_lucent_beam"
    elseif weather_name == "Rain" then
        abilityname = "chaotic_static_storm"
    elseif weather_name == "Pestilence" then
        abilityname = "chaotic_death_cloud"
    end
    local abilitytable = {
        [1] = "chaotic_lucent_beam",
        [2] = "chaotic_static_storm",
        [3] = "chaotic_death_cloud",
    }
    for i=1,3,1 do
        local ability_learned = self:GetParent():FindAbilityByName(abilitytable[i])
        if ability_learned then
            self:GetParent():RemoveAbility(abilitytable[i])
        end
    end

    local ability = self:GetParent():AddAbility(abilityname)
    if ability then
        ability:SetLevel(1)
        local modifier = "modifier_item_hd_artifact_58_"..abilityname
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifier, {duration = 9.9})
    end
end
-----
modifier_item_hd_artifact_58_lv40_fire = advanced_modifier({})

function modifier_item_hd_artifact_58_lv40_fire:IsDebuff() return false end
function modifier_item_hd_artifact_58_lv40_fire:IsHidden() return true end
function modifier_item_hd_artifact_58_lv40_fire:IsPurgable() return false end

function modifier_item_hd_artifact_58_lv40_fire:OnCreated(keys)
    if not self:GetAbility() then return end

	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_flame_strike")
		self.interval = 15
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(self.interval)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.65)
		end
	end
end
function modifier_item_hd_artifact_58_lv40_fire:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	if not self.creep_ability then return end
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then

		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, target in pairs(units) do
			if target:IsAlive() then
				self.creep_ability:EndCooldown()
				self.timer = time + self.interval
				parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
				break
			end
		end
	end
end
-----
modifier_item_hd_artifact_58_chaotic_lucent_beam = advanced_modifier({})

function modifier_item_hd_artifact_58_chaotic_lucent_beam:IsDebuff() return false end
function modifier_item_hd_artifact_58_chaotic_lucent_beam:IsHidden() return true end
function modifier_item_hd_artifact_58_chaotic_lucent_beam:IsPurgable() return false end

function modifier_item_hd_artifact_58_chaotic_lucent_beam:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
        self.deepactive = nil
        if GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_summon_ring_effects") >= 40 then
            self.deepactive = true
        end
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_lucent_beam")
		self.interval = 6
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(self.interval)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.4)
		end
	end
end

function modifier_item_hd_artifact_58_chaotic_lucent_beam:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	if not self.creep_ability then return end
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		self.creep_ability:EndCooldown()
		self.timer = time + self.interval
		parent:CastAbilityNoTarget(self.creep_ability, parent:GetPlayerOwnerID())
	end
end

-----
modifier_item_hd_artifact_58_chaotic_death_cloud = advanced_modifier({})

function modifier_item_hd_artifact_58_chaotic_death_cloud:IsDebuff() return false end
function modifier_item_hd_artifact_58_chaotic_death_cloud:IsHidden() return true end
function modifier_item_hd_artifact_58_chaotic_death_cloud:IsPurgable() return false end

function modifier_item_hd_artifact_58_chaotic_death_cloud:OnCreated(keys)
    if not self:GetAbility() then return end
    
	self.bonus = self:GetAbility():GetArtifactSpecialValueFor("bonus_3")
	if IsServer() then
        self.deepactive = nil
        if GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_artifact_56") >= 40 then
            self.deepactive = 1
        end
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_death_cloud")
		self.interval = 20
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(self.interval)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.65)
		end
	end
end

function modifier_item_hd_artifact_58_chaotic_death_cloud:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	if not self.creep_ability then return end
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		

			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnPosition(parent:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
		
	end
end
function modifier_item_hd_artifact_58_chaotic_death_cloud:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_item_hd_artifact_58_chaotic_death_cloud:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.deepactive*self.bonus
end
-----
modifier_item_hd_artifact_58_chaotic_static_storm = advanced_modifier({})

function modifier_item_hd_artifact_58_chaotic_static_storm:IsDebuff() return false end
function modifier_item_hd_artifact_58_chaotic_static_storm:IsHidden() return true end
function modifier_item_hd_artifact_58_chaotic_static_storm:IsPurgable() return false end

function modifier_item_hd_artifact_58_chaotic_static_storm:OnCreated(keys)
    if not self:GetAbility() then return end
	self.bonus = self:GetAbility():GetArtifactSpecialValueFor("bonus_2")
	if IsServer() then
        self.deepactive = nil
        if GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_summon_ring_effects") >= 40 then
            self.deepactive = 1
        end
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_static_storm")
		self.interval = 20
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(self.interval)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.4)
		end
	end
end

function modifier_item_hd_artifact_58_chaotic_static_storm:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	if not self.creep_ability then return end
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		

			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnPosition(parent:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
		
	end
end
function modifier_item_hd_artifact_58_chaotic_static_storm:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_item_hd_artifact_58_chaotic_static_storm:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.deepactive*self.bonus
end

modifier_item_hd_artifact_58_buff_lv60 = advanced_modifier({})

function modifier_item_hd_artifact_58_buff_lv60:IsDebuff() return false end
function modifier_item_hd_artifact_58_buff_lv60:IsHidden() return true end
function modifier_item_hd_artifact_58_buff_lv60:IsPurgable() 		return false end
function modifier_item_hd_artifact_58_buff_lv60:IsPurgeException() 	return false end
function modifier_item_hd_artifact_58_buff_lv60:OnCreated(keys)
    self.ability = self:GetAbility()
    self.interval_6 = self.ability:GetArtifactSpecialValueFor("interval_6")
    self.radius_6 = self.ability:GetArtifactSpecialValueFor("radius_6")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_58")
	if IsServer() then
        self:StartIntervalThink(self.interval_6)
	end
end

function modifier_item_hd_artifact_58_buff_lv60:OnIntervalThink()
    if not self:GetAbility() then return end
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end

	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius_6, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, target in pairs(units) do
		if target:IsAlive() then
			self:StormofThaira(target:GetAbsOrigin())
			break
		end
	end
end

function modifier_item_hd_artifact_58_buff_lv60:StormofThaira(pos)
    if not pos then return end
    
    local caster = self:GetParent()
	local thinker = CreateUnitByName("npc_dota_thinker", pos, false, caster, caster, caster:GetTeam())
	if thinker then
		thinker:AddNewModifier(caster, self.ability, "modifier_item_hd_artifact_58_strom_thinker", {duration = 3})
	end
end
-----------
modifier_item_hd_artifact_58_strom_thinker = advanced_modifier({})

function modifier_item_hd_artifact_58_strom_thinker:IsAura()return true end
function modifier_item_hd_artifact_58_strom_thinker:OnCreated(keys)

	self:GetParent().chaotic_static_storm_thinker = self

	if IsServer() then
		self.duration = 3
		self.radius = 500
		local parent = self:GetParent()
		parent:EmitSound("Hero_Zuus.Cloud.Cast")

		self.particle = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_2022_immortal/disruptor_2022_immortal_static_storm.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
		ParticleManager:SetParticleControl(self.particle,2,Vector(self.duration,0,0))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_item_hd_artifact_58_strom_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_item_hd_artifact_58_strom_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(),	
		parent:GetOrigin(),
		nil,	
		self.radius,	
		 DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		 DOTA_UNIT_TARGET_FLAG_NONE,	
		FIND_ANY_ORDER,	
		false	
	)
	for _,unit in pairs(units) do
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_artifact_58_strom_damage", {duration = 1})
	end
end

function modifier_item_hd_artifact_58_strom_thinker:CheckState()
	return{
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}
end

modifier_item_hd_artifact_58_strom_damage = advanced_modifier({})

function modifier_item_hd_artifact_58_strom_damage:IsHidden() 			return true end
function modifier_item_hd_artifact_58_strom_damage:IsPurgable() 			return false end
function modifier_item_hd_artifact_58_strom_damage:IsPurgeException() 	return false end
function modifier_item_hd_artifact_58_strom_damage:IsDebuff() return true end
function modifier_item_hd_artifact_58_strom_damage:OnCreated(keys)
	local ability = self:GetAbility()
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		local caster = self:GetCaster()
		self.base_damage = 300
		self.bonus_damage = 3
		self.damageTable = {
			victim = self:GetParent(),
			attacker = caster,
			-- damage = damage,
			--damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
			-- hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
        self.random_table = {
            [1] = {DAMAGE_TYPE_PHYSICAL, HD_DAMAGE_FLAG_FIRE_DAMAGE},
            [2] = {DAMAGE_TYPE_MAGICAL, HD_DAMAGE_FLAG_ICE_DAMAGE},
            [3] = {DAMAGE_TYPE_PURE, HD_DAMAGE_FLAG_LIGHTING_DAMAGE},
        }
		self:StartIntervalThink(1)
        self:OnIntervalThink()
	end
end
function modifier_item_hd_artifact_58_strom_damage:OnIntervalThink()
    if not self:GetAbility() then return end
    if not self:GetCaster():IsAlive() then return end
    
	local caster = self:GetCaster()
	local damage = self.base_damage + self.bonus_damage*caster:HDGetPrimaryStatValue()
    if self.random_table then
        self.damageTable.damage_type = self.random_table[RandomInt(1,3)][1]
        self.damageTable.hd_flags = self.random_table[RandomInt(1,3)][2]
    end
	self.damageTable.damage = damage
	ApplyDamage(self.damageTable)
end

modifier_item_hd_artifact_58_lv70 = advanced_modifier({})

function modifier_item_hd_artifact_58_lv70:IsDebuff() return false end
function modifier_item_hd_artifact_58_lv70:IsHidden() return true end
function modifier_item_hd_artifact_58_lv70:IsPurgable() return false end

function modifier_item_hd_artifact_58_lv70:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
        self:SetStackCount(keys.spell)
    end
end

function modifier_item_hd_artifact_58_lv70:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_artifact_58_lv70:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()
end