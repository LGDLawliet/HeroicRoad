-- 重写完成
item_hd_indentrue_head_effects = class({})
LinkLuaModifier("modifier_item_hd_indentrue_head_effects", "player_artifact/item_hd_indentrue_head_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_indentrue_head_effects_lv2030", "player_artifact/item_hd_indentrue_head_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_indentrue_head_effects_lv2030_debuff", "player_artifact/item_hd_indentrue_head_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_indentrue_head_effects_buff", "player_artifact/item_hd_indentrue_head_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_indentrue_head_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_indentrue_head_effects"
end
function item_hd_indentrue_head_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
end
-------------
modifier_item_hd_indentrue_head_effects = advanced_modifier({})

function modifier_item_hd_indentrue_head_effects:IsDebuff() return false end
function modifier_item_hd_indentrue_head_effects:IsHidden() return true end
function modifier_item_hd_indentrue_head_effects:IsPurgable() return false end
function modifier_item_hd_indentrue_head_effects:RemoveOnDeath() return false end
function modifier_item_hd_indentrue_head_effects:DestroyOnExpire() return false end
function modifier_item_hd_indentrue_head_effects:GetTexture() return "item_artifact_12" end

function modifier_item_hd_indentrue_head_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_base_damage = self.ability:GetArtifactSpecialValueFor("bonus_base_damage")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.max = self.ability:GetArtifactSpecialValueFor("max")

    self.attack = self.ability:GetArtifactSpecialValueFor("attack")*0.01
    self.health = self.ability:GetArtifactSpecialValueFor("health")*0.01
    self.armor = self.ability:GetArtifactSpecialValueFor("armor")*0.01

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_indentrue_head_effects")

    if self.level >= 40 then
        self.max = self.ability:GetArtifactSpecialValueFor("max_4")
    end
    if self.level >= 100 then
        self.max = self.ability:GetArtifactSpecialValueFor("max_10")
        self.attack = self.attack * (1+self.ability:GetArtifactSpecialValueFor("index_10")*0.01)
        self.health = self.health * (1+self.ability:GetArtifactSpecialValueFor("index_10")*0.01)
    end
end

function modifier_item_hd_indentrue_head_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_base_damage = self.ability:GetArtifactSpecialValueFor("bonus_base_damage")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.max = self.ability:GetArtifactSpecialValueFor("max")

    self.attack = self.ability:GetArtifactSpecialValueFor("attack")*0.01
    self.health = self.ability:GetArtifactSpecialValueFor("health")*0.01
    self.armor = self.ability:GetArtifactSpecialValueFor("armor")*0.01

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_indentrue_head_effects")

    if self.level >= 40 then
        self.max = self.ability:GetArtifactSpecialValueFor("max_4")
    end
    if self.level >= 100 then
        self.max = self.ability:GetArtifactSpecialValueFor("max_10")
        self.attack = self.attack * (1+self.ability:GetArtifactSpecialValueFor("index_10")*0.01)
        self.health = self.health * (1+self.ability:GetArtifactSpecialValueFor("index_10")*0.01)
    end
end

function modifier_item_hd_indentrue_head_effects:SummonDragon()
    if not IsServer() then return end

    local caster =self:GetCaster()

    local count = self.max
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	local life_duration = self.duration
	local heal = self.health* caster:GetMaxHealth()
	local damage =  self.attack* math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)
    local armor = self.armor* caster:GetPhysicalArmorValue(false)
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	self.unit = caster:SummonUnit("npc_hd_artifact_little_dragon",life_duration,unit_pos,caster:GetForwardVector(),self:GetAbility(),0,heal,nil,damage,armor,1,1)
    caster:GameTimer(0.03,function ()
        self.unit:SetSkin(1)
    end)
    
	table.insert(self.summon_table,self.unit)

    if self.level >= 10 then
	    self.unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_indentrue_head_effects_buff", {level = self.level})
    end
    if self.level >= 40 then
        local ability = self.unit:AddAbility("chaotic_elder_dragon_form")
		if ability then
			ability:SetLevel(1)
		end 
    end
end

function modifier_item_hd_indentrue_head_effects:OnSummonUnit(keys)
    if not IsServer() then return end
    if not keys.target then return end
    local target = keys.target
    if not target:IsIndentureSummon() then return end

    if self.level >= 20 then
       target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_hd_indentrue_head_effects_lv2030",{level = self.level}) 
    end
    if target:GetUnitName() == "npc_hd_artifact_little_dragon" then return end
    self:SummonDragon()
end

function modifier_item_hd_indentrue_head_effects:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_item_hd_indentrue_head_effects:Advanced_GetModifierBaseAttack_BonusDamage()
    return self.bonus_base_damage
end

----------------
modifier_item_hd_indentrue_head_effects_buff = advanced_modifier({})

function modifier_item_hd_indentrue_head_effects_buff:IsDebuff() return false end
function modifier_item_hd_indentrue_head_effects_buff:IsHidden() return true end
function modifier_item_hd_indentrue_head_effects_buff:IsPurgable() return false end
function modifier_item_hd_indentrue_head_effects_buff:RemoveOnDeath() return false end
function modifier_item_hd_indentrue_head_effects_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    
    self.crit = {}
    self.chance_1 = self:GetAbility():GetArtifactSpecialValueFor("chance_1")
    self.crit_1 = self:GetAbility():GetArtifactSpecialValueFor("crit_1")
    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)

        if self:GetStackCount() >= 40 then
            self:GetCaster():GameTimer(0.1,function()

            self.creep_ability = self:GetParent():FindAbilityByName("chaotic_elder_dragon_form")
            self.interval = 30
            self.timer =  GameRules:GetGameTime()
            if self.creep_ability then
                self.creep_ability:StartCooldown(30)
                self.creep_ability:SetFrozenCooldown(true)
                self:StartIntervalThink(0.2)
            end

            end)
        end
    end
end
function modifier_item_hd_indentrue_head_effects_buff:OnDestroy() self.crit = nil end

function modifier_item_hd_indentrue_head_effects_buff:OnIntervalThink()
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
			parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
		end
	end
end

function modifier_item_hd_indentrue_head_effects_buff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
    return funcs
end

function modifier_item_hd_indentrue_head_effects_buff:DeclareFunctions() return 
	{
	  	MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	} 
end

function modifier_item_hd_indentrue_head_effects_buff:GetModifierModelScale()
    if self:GetStackCount() >= 100 then
        return 70
    end
    return 0
end

function modifier_item_hd_indentrue_head_effects_buff:GetModifierAttackRangeBonus()
    if self:GetStackCount() >= 100 then
        return 250
    end
    return 0
end



function modifier_item_hd_indentrue_head_effects_buff:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() then
		local pct = self.chance_1
		local random = math.random
		if pct > random(0,100) then
			self.crit[keys.record] = true
			local damage_mul = self.crit_1
			return damage_mul 
		else		
			return 0
		end
	end
end
function modifier_item_hd_indentrue_head_effects_buff:OnAttackFail(keys) self.crit[keys.record] = nil end
function modifier_item_hd_indentrue_head_effects_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end
	self.crit[keys.record] = nil
end

----------------
modifier_item_hd_indentrue_head_effects_lv2030 = advanced_modifier({})

function modifier_item_hd_indentrue_head_effects_lv2030:IsDebuff() return false end
function modifier_item_hd_indentrue_head_effects_lv2030:IsHidden() return true end
function modifier_item_hd_indentrue_head_effects_lv2030:IsPurgable() return false end
function modifier_item_hd_indentrue_head_effects_lv2030:RemoveOnDeath() return false end
function modifier_item_hd_indentrue_head_effects_lv2030:OnCreated(keys)
    if not self:GetAbility() then return end
    
    self.outgoing_2 = self:GetAbility():GetArtifactSpecialValueFor("outgoing_2")
    self.incoming_2 = self:GetAbility():GetArtifactSpecialValueFor("incoming_2")
    
    self.bonus_attack_3 = self:GetAbility():GetArtifactSpecialValueFor("bonus_attack_3")
    self.armor_7 = self:GetAbility():GetArtifactSpecialValueFor("armor_7")
    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)
    end
end
function modifier_item_hd_indentrue_head_effects_lv2030:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    if self:GetStackCount() >= 30 then
        funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
        }
    end
    if self:GetStackCount() >= 70 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE)
    end
    return funcs
end
function modifier_item_hd_indentrue_head_effects_lv2030:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self.outgoing_2
end
function modifier_item_hd_indentrue_head_effects_lv2030:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then return end
    return -self.incoming_2
end
function modifier_item_hd_indentrue_head_effects_lv2030:Advanced_GetModifierDamageOutgoing_Percentage()
    if not self:GetAbility() then return end
    return self.bonus_attack_3
end
function modifier_item_hd_indentrue_head_effects_lv2030:Advanced_GetModifierPhysicalArmorBonusPercentage()
    if not self:GetAbility() then return end
    return self.armor_7
end
function modifier_item_hd_indentrue_head_effects_lv2030:OnDeath(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local unit = keys.unit
    if not attacker or not IsEnemy(self:GetParent(),attacker) then return end
    if not self:GetAbility() then return end
    if unit ~= self:GetParent() then return end
    
    local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_indentrue_head_effects")
    if modifier then
       modifier:SetDuration(self.duration_3, true) 
    end
end
----------------
modifier_item_hd_indentrue_head_effects_lv2030_debuff = advanced_modifier({})

function modifier_item_hd_indentrue_head_effects_lv2030_debuff:IsDebuff() return true end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:IsHidden() return false end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:IsPurgable() return false end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:GetTexture() return "item_artifact_12" end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:OnCreated()
    if not self:GetAbility() then return end
    self.armor_3 = self:GetAbility():GetArtifactSpecialValueFor("armor_3")
end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:CheckState()
    return{
        [MODIFIER_STATE_STUNNED] = true,
    }
end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_indentrue_head_effects_lv2030_debuff:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then return end
    return -self.armor_3
end
