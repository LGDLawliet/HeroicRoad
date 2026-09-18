-- 重写完成
item_hd_artifact_56 = class({})
LinkLuaModifier("modifier_item_hd_artifact_56", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_56_lv40", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_56_buff", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_56_lv10", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_56_lv20", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_56_lv20_already", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_56_lv30", "player_artifact/item_hd_artifact_56.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_artifact_56:GetIntrinsicModifierName()
	return "modifier_item_hd_artifact_56"
end
function item_hd_artifact_56:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
end
function item_hd_artifact_56:SciAllCheck(target)
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
function item_hd_artifact_56:SciCheck(target)
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
function item_hd_artifact_56:GetArtifactSpecialList()
    local list = {}
    list["76561198101659620"] = true
    return list
end

function item_hd_artifact_56:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_artifact_56:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end
modifier_item_hd_artifact_56 = advanced_modifier({})

function modifier_item_hd_artifact_56:IsDebuff() return false end
function modifier_item_hd_artifact_56:IsHidden() return self.level < 30 end
function modifier_item_hd_artifact_56:IsPurgable() return false end
function modifier_item_hd_artifact_56:RemoveOnDeath() return false end
function modifier_item_hd_artifact_56:GetTexture() return "item_artifact_56" end

function modifier_item_hd_artifact_56:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.attack_index = self.ability:GetArtifactSpecialValueFor("attack_index")*0.01
    self.hp_index = self.ability:GetArtifactSpecialValueFor("hp_index")*0.01
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    

    self.attack_3 = self.ability:GetArtifactSpecialValueFor("attack_3")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_56")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_artifact_56:OnRefresh(keys)
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.attack_index = self.ability:GetArtifactSpecialValueFor("attack_index")*0.01
    self.hp_index = self.ability:GetArtifactSpecialValueFor("hp_index")*0.01
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")

    self.attack_3 = self.ability:GetArtifactSpecialValueFor("attack_3")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_56")
end

function modifier_item_hd_artifact_56:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_artifact_56:OnTooltip()
	return self:GetStackCount()*self.attack_3
end
function modifier_item_hd_artifact_56:OnIntervalThink()
    local whale = self:GetCaster():HasModifier("modifier_item_hd_artifact_58")
    if whale and GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_artifact_58") >= 30 then return end
    self:SummonSlime()
end

function modifier_item_hd_artifact_56:SummonSlime()
    if not IsServer() then return end
    
    local count = self.max
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	local caster = self:GetCaster()
    local armor = self.armor_index * caster:GetPhysicalArmorValue(false)
	local life_duration = self.duration

    local health = 0
    local attack = 0
    local shop = chaotic_era_shop:GetPlayerShopLevel(caster:GetPlayerOwnerID(),true)
    -- print("商店等级是"..shop)
    if shop <= 3 then
        attack = 70 + 5*shop
        health = 56 + 5*shop
        -- print("1-3级商店.."..attack)
    elseif shop > 3 and shop <= 7 then
        attack = 80 + 4*shop
        health = 70 + 4*shop
        -- print("4-7级商店.."..attack)
    elseif shop > 7 then
        attack = 100 + 3*shop
        health = 91 + 3*shop
        -- print("8-13级商店.."..attack)
    end

    local heal = health*0.01 * caster:GetMaxHealth()+1000
	local damage = attack*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+100
    -- lv40 小队作战
    if self.level >= 40 and self:GetAbility():SciAllCheck(caster) then
        heal = heal*1.3
        damage = damage*1.3
    end

	local unit_pos = self:GetCaster():GetAbsOrigin() - (self:GetCaster():GetForwardVector() * 400) 
	local unit = caster:SummonUnit("npc_hd_spirit_of_sci_snake",life_duration,unit_pos,caster:GetForwardVector(),self:GetAbility(),0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_56_buff", {level = self.level})
    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, unit)
    ParticleManager:SetParticleControl(pfx2, 1, Vector(400, 1, 400))
    ParticleManager:ReleaseParticleIndex(pfx2)
    
end

function modifier_item_hd_artifact_56:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity
    }
end

function modifier_item_hd_artifact_56:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end

function modifier_item_hd_artifact_56:OnSummonUnit(keys)
    if not IsServer() then return end
    if not keys.target then return end
    if self:GetAbility():SciCheck(keys.target) then
        --lv 30 协同
        keys.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_hd_artifact_56_lv30",{stack = self:GetStackCount()}) 
    end
end
-- function modifier_item_hd_artifact_56:OnSummonUnitFinished(keys)
--     if not IsServer() then return end
--     if not keys.target then return end
--     if not self:GetAbility():SciCheck(keys.target) then
--         -- keys.target:ModifyHealth(0, self:GetAbility(), true, 0)
--     end
-- end
---- 不采用光环
modifier_item_hd_artifact_56_buff = advanced_modifier({})

function modifier_item_hd_artifact_56_buff:IsDebuff() return false end
function modifier_item_hd_artifact_56_buff:IsHidden() return true end
function modifier_item_hd_artifact_56_buff:IsPurgable() return false end
function modifier_item_hd_artifact_56_buff:RemoveOnDeath() return false end

function modifier_item_hd_artifact_56_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    self.radius = self:GetAbility():GetArtifactSpecialValueFor("radius")
    self.poison_atk_pct = self:GetAbility():GetArtifactSpecialValueFor("poison_atk_pct")*0.01
    self.duration_2 = self:GetAbility():GetArtifactSpecialValueFor("duration_2")

    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)
        self.poison = self:GetParent():GetAverageTrueAttackDamage(nil) *self.poison_atk_pct
        self:StartIntervalThink(1.5)
    end
end
function modifier_item_hd_artifact_56_buff:OnIntervalThink()
    if not self:GetAbility() then return end
    if not self:GetParent():IsAlive() then return end
    self:BonusPoison(self.radius)
end
function modifier_item_hd_artifact_56_buff:BonusPoison(radius)
    if not self:GetAbility() then return end
    if not IsServer() then return end
    local parent = self:GetParent()
    self.poison = parent:GetAverageTrueAttackDamage(nil) *self.poison_atk_pct
    if self:GetStackCount() >= 70 then
        local spell = 0
        local spell_amp = self.parent:GetSpellAmplification(false)*100
		if spell_amp>0 then
			spell = math.min(spell_amp*self.spell_give_7, self.spell_max_7)
            self.poison = self.poison*(1+spell*0.01)
        end
    end

    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, parent)
    ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, 1, radius))
    ParticleManager:ReleaseParticleIndex(pfx2)

    local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for _, enemy in pairs(units) do
        enemy:Poison(parent, self:GetAbility(),self.poison)
        if self:GetStackCount() >= 10 then
            enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_artifact_56_lv10",{stack = 1}) 
        end
        if self:GetStackCount() >= 20 then
            if not enemy:HasModifier("modifier_item_hd_artifact_56_lv20_already")  then
                enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_artifact_56_lv20_already",{}) 
                enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_artifact_56_lv20",{duration = self.duration_2}) 
            end
        end
    end
end

function modifier_item_hd_artifact_56_buff:CheckState()
    return{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end
---- lv10
modifier_item_hd_artifact_56_lv10 = advanced_modifier({})

function modifier_item_hd_artifact_56_lv10:IsDebuff() return true end
function modifier_item_hd_artifact_56_lv10:IsHidden() return false end
function modifier_item_hd_artifact_56_lv10:IsPurgable() return false end
function modifier_item_hd_artifact_56_lv10:GetTexture() return "item_artifact_56" end

function modifier_item_hd_artifact_56_lv10:OnCreated(keys)
    if not self:GetAbility() then return end
    self.poison_reduction_1 = self:GetAbility():GetArtifactSpecialValueFor("poison_reduction_1")
	if IsServer() then
		self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
	end
end
function modifier_item_hd_artifact_56_lv10:OnRefresh(keys)
    if not self:GetAbility() then return end
    self.poison_reduction_1 = self:GetAbility():GetArtifactSpecialValueFor("poison_reduction_1")
	if IsServer() then
		self.stack = self.stack + keys.stack
        self:SetStackCount(self.stack)
	end
end

function modifier_item_hd_artifact_56_lv10:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE
    }
end
function modifier_item_hd_artifact_56_lv10:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_artifact_56_lv10:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return self:GetStackCount()*self.poison_reduction_1
end
function modifier_item_hd_artifact_56_lv10:OnTooltip()
	return self:GetStackCount()*self.poison_reduction_1
end

--- lv20
modifier_item_hd_artifact_56_lv20_already = advanced_modifier({})

function modifier_item_hd_artifact_56_lv20_already:IsDebuff() return false end
function modifier_item_hd_artifact_56_lv20_already:IsHidden() return true end
function modifier_item_hd_artifact_56_lv20_already:IsPurgable() return false end

modifier_item_hd_artifact_56_lv20 = advanced_modifier({})

function modifier_item_hd_artifact_56_lv20:IsDebuff() return true end
function modifier_item_hd_artifact_56_lv20:IsHidden() return false end
function modifier_item_hd_artifact_56_lv20:IsPurgable() return false end
function modifier_item_hd_artifact_56_lv20:GetTexture() return "item_artifact_56" end

function modifier_item_hd_artifact_56_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    self.poison_interval_reduction_2 = self:GetAbility():GetArtifactSpecialValueFor("poison_interval_reduction_2")
    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_artifact_56")
end

function modifier_item_hd_artifact_56_lv20:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_POISON_TICKTIME_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
    }
    return funcs
end

function modifier_item_hd_artifact_56_lv20:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hd_artifact_56_lv20:Advanced_GetModifierPoisonTicktimePercentage()
	return -self.poison_interval_reduction_2
end

function modifier_item_hd_artifact_56_lv20:OnTooltip()
	return self.poison_interval_reduction_2
end

function modifier_item_hd_artifact_56_lv20:OnDeath(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    if not self:GetAbility() then return end
    if self.level < 30 then return end
    
    local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_artifact_56")
    --print("找到了")
    if modifier then
       modifier:SetStackCount(modifier:GetStackCount() + 1) 
    end
end
--- lv30
modifier_item_hd_artifact_56_lv30 = advanced_modifier({})

function modifier_item_hd_artifact_56_lv30:IsDebuff() return false end
function modifier_item_hd_artifact_56_lv30:IsHidden() return false end
function modifier_item_hd_artifact_56_lv30:IsPurgable() return false end
function modifier_item_hd_artifact_56_lv30:GetTexture() return "item_artifact_56" end

function modifier_item_hd_artifact_56_lv30:OnCreated(keys)
    if not self:GetAbility() then return end
    self.attack_3 = self:GetAbility():GetArtifactSpecialValueFor("attack_3")
	if IsServer() then
		self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
	end
end

function modifier_item_hd_artifact_56_lv30:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_artifact_56_lv30:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_artifact_56_lv30:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()*self.attack_3
end
function modifier_item_hd_artifact_56_lv30:OnTooltip()
	return self:GetStackCount()*self.attack_3
end

--- lv40
modifier_item_hd_artifact_56_lv40 = advanced_modifier({})

function modifier_item_hd_artifact_56_lv40:IsDebuff() return false end
function modifier_item_hd_artifact_56_lv40:IsHidden() return true end
function modifier_item_hd_artifact_56_lv40:IsPurgable() 		return false end
function modifier_item_hd_artifact_56_lv40:IsPurgeException() 	return false end
function modifier_item_hd_artifact_56_lv40:RemoveOnDeath()  return false end
function modifier_item_hd_artifact_56_lv40:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then return end
	if IsServer() then
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_ray_of_sickness")
		self.interval = self.ability:GetArtifactSpecialValueFor("interval_4")
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(3)
			self.creep_ability:SetFrozenCooldown(true)
			-- self.lighting:StartCooldown(600)
			self:StartIntervalThink(0.5)
		end
	end
end

function modifier_item_hd_artifact_56_lv40:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval
			parent:CastAbilityOnTarget(target, self.creep_ability, parent:GetPlayerOwnerID())
		end
	end
end
