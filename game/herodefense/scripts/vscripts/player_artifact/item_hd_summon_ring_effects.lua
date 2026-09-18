-- 重写完成
item_hd_summon_ring_effects = class({})
LinkLuaModifier("modifier_item_hd_summon_ring_effects", "player_artifact/item_hd_summon_ring_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_ring_effects_lv40", "player_artifact/item_hd_summon_ring_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_ring_effects_buff", "player_artifact/item_hd_summon_ring_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_ring_effects_lv20", "player_artifact/item_hd_summon_ring_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_ring_effects_moon", "player_artifact/item_hd_summon_ring_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_ring_effects_lv70", "player_artifact/item_hd_summon_ring_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_summon_ring_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_summon_ring_effects"
end
function item_hd_summon_ring_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
end
function item_hd_summon_ring_effects:SciAllCheck(target)
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
function item_hd_summon_ring_effects:SciCheck(target)
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
function item_hd_summon_ring_effects:GetArtifactSpecialList()
    local list = {}
    list["76561198101659620"] = true
    return list
end

function item_hd_summon_ring_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_summon_ring_effects:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end
modifier_item_hd_summon_ring_effects = advanced_modifier({})

function modifier_item_hd_summon_ring_effects:IsDebuff() return false end
function modifier_item_hd_summon_ring_effects:IsHidden() return self.level < 20 end
function modifier_item_hd_summon_ring_effects:IsPurgable() return false end
function modifier_item_hd_summon_ring_effects:RemoveOnDeath() return false end
function modifier_item_hd_summon_ring_effects:GetTexture() return "item_artifact_55" end

function modifier_item_hd_summon_ring_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.attack_index = self.ability:GetArtifactSpecialValueFor("attack_index")*0.01
    self.hp_index = self.ability:GetArtifactSpecialValueFor("hp_index")*0.01
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01
    self.outgoing_2 = self.ability:GetArtifactSpecialValueFor("outgoing_2")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_summon_ring_effects")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_summon_ring_effects:OnRefresh(keys)
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.attack_index = self.ability:GetArtifactSpecialValueFor("attack_index")*0.01
    self.hp_index = self.ability:GetArtifactSpecialValueFor("hp_index")*0.01
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01
    self.outgoing_2 = self.ability:GetArtifactSpecialValueFor("outgoing_2")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_summon_ring_effects")
end
function modifier_item_hd_summon_ring_effects:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_summon_ring_effects:OnTooltip()
	return self:GetStackCount()*self.outgoing_2
end
function modifier_item_hd_summon_ring_effects:OnIntervalThink()
    local whale = self:GetCaster():HasModifier("modifier_item_hd_artifact_58")
    if whale and GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_artifact_58") >= 10 then return end
    self:SummonSlime()
end

function modifier_item_hd_summon_ring_effects:SummonSlime()
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
        attack = 50 + 5*shop
        health = 40 + 5*shop
        -- print("1-3级商店.."..attack)
    elseif shop > 3 and shop <= 7 then
        attack = 60 + 4*shop
        health = 50 + 4*shop
        -- print("4-7级商店.."..attack)
    elseif shop > 7 then
        attack = 70 + 3*shop
        health = 60 + 3*shop
        -- print("8-13级商店.."..attack)
    end

    local heal = health*0.01 * caster:GetMaxHealth()
	local damage = attack*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)
	

	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 30) 
	local unit = caster:SummonUnit("npc_hd_artifact_sci_dragon",life_duration,
	unit_pos,
	caster:GetForwardVector(),self:GetAbility(),0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)

	unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_summon_ring_effects_buff", {level = self.level})
    local ability = unit:AddAbility("chaotic_lucent_beam")
	if ability then
		ability:SetLevel(1)
        unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_summon_ring_effects_moon", {level = self.level})
	end

    

    if self.level >= 40 and self:GetAbility():SciAllCheck(caster) then
        local ability2 = unit:AddAbility("chaotic_live_in_peace_magic")
		if ability2 then
			ability2:SetLevel(1)
		end
        unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_summon_ring_effects_lv40", {})
    end
    if self.level >= 70 then
        local spell = 0
        local spell_amp = self.parent:GetSpellAmplification(false)*100
		if spell_amp>0 then
			spell = math.min(spell_amp*self.spell_give_7, self.spell_max_7)
		end
        unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_summon_ring_effects_lv70", {spell = spell})
    end

    local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(0.4,0,0) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		unit,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_item_hd_summon_ring_effects:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity
    }
end

function modifier_item_hd_summon_ring_effects:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end

function modifier_item_hd_summon_ring_effects:OnSummonUnit(keys)
    if not IsServer() then return end
    if not keys.target then return end
    if self:GetAbility():SciCheck(keys.target) then
       keys.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_hd_summon_ring_effects_lv20",{stack = self:GetStackCount()}) 
    end
end
-- function modifier_item_hd_summon_ring_effects:OnSummonUnitFinished(keys)
--     if not IsServer() then return end
--     if not keys.target then return end
--     if not self:GetAbility():SciCheck(keys.target) then
--         keys.target:ModifyHealth(0, self:GetAbility(), true, 0)
--     end
-- end

modifier_item_hd_summon_ring_effects_buff = advanced_modifier({})

function modifier_item_hd_summon_ring_effects_buff:IsDebuff() return false end
function modifier_item_hd_summon_ring_effects_buff:IsHidden() return true end
function modifier_item_hd_summon_ring_effects_buff:IsPurgable() return false end
function modifier_item_hd_summon_ring_effects_buff:RemoveOnDeath() return false end
function modifier_item_hd_summon_ring_effects_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)
        if self:GetStackCount() >= 30 then
           self:StartIntervalThink(3)
        end
    end
    self.max = 0
    self.sci = 1
    if self:GetStackCount() >= 10 then
        self.max = self:GetAbility():GetArtifactSpecialValueFor("max_1")
        if self:GetStackCount() >= 30 then
            self.max = self:GetAbility():GetArtifactSpecialValueFor("max_3")
        end
    end
    self.range = self:GetAbility():GetArtifactSpecialValueFor("range_3")
    self.bonus_attack_3 = self:GetAbility():GetArtifactSpecialValueFor("bonus_attack_3")
    self:SetHasCustomTransmitterData( true )-- 同步cy
end
function modifier_item_hd_summon_ring_effects_buff:AddCustomTransmitterData( )
	return
	{
		sci = self.sci,
	}
end

function modifier_item_hd_summon_ring_effects_buff:HandleCustomTransmitterData( data )
	self.sci = data.sci
end
function modifier_item_hd_summon_ring_effects_buff:ADDeclareFunctions()
    local funcs = {}

    if self:GetStackCount() >= 10 and self:GetStackCount() < 30 then
        funcs = {
            MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
        }
    elseif self:GetStackCount() >= 30 then
        funcs = {
            MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
            advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        }
    end
    return funcs
end
function modifier_item_hd_summon_ring_effects_buff:OnIntervalThink()
    local caster = self:GetParent()
    self.sci = 0
    if not self:GetAbility() then return end
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    for _ , unit in pairs(units) do
        if self:GetAbility():SciCheck(unit) then
            self.sci = self.sci + 1
        end
    end
end
function modifier_item_hd_summon_ring_effects_buff:CheckState()
    return{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end
function modifier_item_hd_summon_ring_effects_buff:Advanced_GetModifierAttackRangeBonus()
    return self.range
end
function modifier_item_hd_summon_ring_effects_buff:Advanced_GetModifierDamageOutgoing_Percentage()
    return self.sci*self.bonus_attack_3
end
function modifier_item_hd_summon_ring_effects_buff:OnDeath(keys)
    if not IsServer() then return end
    if not self:GetCaster() then return end
    if self:GetStackCount() < 20 then return end
    if keys.attacker ~= self:GetParent() then return end
    local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_summon_ring_effects")
    if modifier then
        modifier:SetStackCount(math.min(modifier:GetStackCount() + 1, 5000))
    end
end

-----
modifier_item_hd_summon_ring_effects_lv20 = advanced_modifier({})

function modifier_item_hd_summon_ring_effects_lv20:IsDebuff() return false end
function modifier_item_hd_summon_ring_effects_lv20:IsHidden() return false end
function modifier_item_hd_summon_ring_effects_lv20:IsPurgable() return false end
function modifier_item_hd_summon_ring_effects_lv20:GetTexture() return "item_artifact_55" end

function modifier_item_hd_summon_ring_effects_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    self.outgoing_2 = self:GetAbility():GetArtifactSpecialValueFor("outgoing_2")
	if IsServer() then
		self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
	end
end

function modifier_item_hd_summon_ring_effects_lv20:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_summon_ring_effects_lv20:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_summon_ring_effects_lv20:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self:GetStackCount()*self.outgoing_2
end
function modifier_item_hd_summon_ring_effects_lv20:OnTooltip()
	return self:GetStackCount()*self.outgoing_2
end
modifier_item_hd_summon_ring_effects_lv40 = advanced_modifier({})

function modifier_item_hd_summon_ring_effects_lv40:IsDebuff() return false end
function modifier_item_hd_summon_ring_effects_lv40:IsHidden() return true end
function modifier_item_hd_summon_ring_effects_lv40:IsPurgable() return false end

function modifier_item_hd_summon_ring_effects_lv40:OnCreated(keys)
    if not self:GetAbility() then return end
    self.interval_4 = self:GetAbility():GetArtifactSpecialValueFor("interval_4")
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_live_in_peace_magic")
		self.interval = self.interval_4
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(self.interval_4)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.4)
		end
	end
end

function modifier_item_hd_summon_ring_effects_lv40:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		

			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityNoTarget(self.creep_ability, parent:GetPlayerOwnerID())
		
	end
end
modifier_item_hd_summon_ring_effects_moon = advanced_modifier({})

function modifier_item_hd_summon_ring_effects_moon:IsDebuff() return false end
function modifier_item_hd_summon_ring_effects_moon:IsHidden() return true end
function modifier_item_hd_summon_ring_effects_moon:IsPurgable() return false end

function modifier_item_hd_summon_ring_effects_moon:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
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

function modifier_item_hd_summon_ring_effects_moon:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		

		self.creep_ability:EndCooldown()
		self.timer = time + self.interval

		parent:CastAbilityNoTarget(self.creep_ability, parent:GetPlayerOwnerID())
		
	end
end

modifier_item_hd_summon_ring_effects_lv70 = advanced_modifier({})

function modifier_item_hd_summon_ring_effects_lv70:IsDebuff() return false end
function modifier_item_hd_summon_ring_effects_lv70:IsHidden() return true end
function modifier_item_hd_summon_ring_effects_lv70:IsPurgable() return false end

function modifier_item_hd_summon_ring_effects_lv70:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
        self:SetStackCount(keys.spell)
    end
end

function modifier_item_hd_summon_ring_effects_lv70:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_summon_ring_effects_lv70:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()
end