item_hd_blaiddar_effects = class({})

LinkLuaModifier("modifier_item_hd_blaiddar_effects", "player_artifact/item_hd_blaiddar_effects", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blaiddar_effects_debuff", "player_artifact/item_hd_blaiddar_effects", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blaiddar_effects_lv30", "player_artifact/item_hd_blaiddar_effects", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blaiddar_effects_lv20", "player_artifact/item_hd_blaiddar_effects", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blaiddar_effects_lv10", "player_artifact/item_hd_blaiddar_effects", LUA_MODIFIER_MOTION_NONE)

function item_hd_blaiddar_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/blaiddar/taunt.vpcf", context )
end

function item_hd_blaiddar_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_blaiddar_effects"
end
function item_hd_blaiddar_effects:GetClass(target)
    if not target then return end
    -- 强韧者
    if target:HasModifier("modifier_item_chaotic_class_melee_phy") then
        return 1
    end
    return 0
end

modifier_item_hd_blaiddar_effects = advanced_modifier({})
function modifier_item_hd_blaiddar_effects:IsDebuff() return false end
function modifier_item_hd_blaiddar_effects:IsHidden() return true end
function modifier_item_hd_blaiddar_effects:IsPurgable() return false end
function modifier_item_hd_blaiddar_effects:RemoveOnDeath() return false end

function modifier_item_hd_blaiddar_effects:OnCreated()

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_blaiddar_effects")
    self.class = self:GetAbility():GetClass(self:GetParent())

    self.bonus_armor = self:GetAbility():GetArtifactSpecialValueFor("bonus_armor")
    self.armor_to_damage = self:GetAbility():GetArtifactSpecialValueFor("armor_to_damage")
    self.outgoing_down = self:GetAbility():GetArtifactSpecialValueFor("outgoing_down")
    
    -- 预加载所有等级需要的参数
    self.radius_1 = self:GetAbility():GetArtifactSpecialValueFor("radius_1")
    self.interval_1 = self:GetAbility():GetArtifactSpecialValueFor("interval_1")
    self.losthp_heal_1 = self:GetAbility():GetArtifactSpecialValueFor("losthp_heal_1")*0.01
    self.heal_pct_2 = self:GetAbility():GetArtifactSpecialValueFor("heal_pct_2")*0.01
    self.attack_speed_2 = self:GetAbility():GetArtifactSpecialValueFor("attack_speed_2")
    self.duration_2 = self:GetAbility():GetArtifactSpecialValueFor("duration_2")
    self.bonus_hp_3 = self:GetAbility():GetArtifactSpecialValueFor("bonus_hp_3")
    self.armor_to_hp_3 = self:GetAbility():GetArtifactSpecialValueFor("armor_to_hp_3")
    self.incoming_3 = self:GetAbility():GetArtifactSpecialValueFor("incoming_3")
    self.incoming_4 = self:GetAbility():GetArtifactSpecialValueFor("incoming_4")
    self.armor_to_damage_7 = self:GetAbility():GetArtifactSpecialValueFor("armor_to_damage_7")
    self.duration_7 = self:GetAbility():GetArtifactSpecialValueFor("duration_7")
    -- 启动附加效果1的计时器（仅不屈者）
    self:StartIntervalThink(self.interval_1)

    if self.level >= 70 then
       self.armor_to_damage = self.armor_to_damage_7
       self.duration_2 = self.duration_7
    end
end

function modifier_item_hd_blaiddar_effects:OnRefresh()

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_blaiddar_effects")
    self.class = self:GetAbility():GetClass(self:GetParent())

    self.bonus_armor = self:GetAbility():GetArtifactSpecialValueFor("bonus_armor")
    self.armor_to_damage = self:GetAbility():GetArtifactSpecialValueFor("armor_to_damage")
    self.outgoing_down = self:GetAbility():GetArtifactSpecialValueFor("outgoing_down")
    
    -- 预加载所有等级需要的参数
    self.radius_1 = self:GetAbility():GetArtifactSpecialValueFor("radius_1")
    self.interval_1 = self:GetAbility():GetArtifactSpecialValueFor("interval_1")
    self.losthp_heal_1 = self:GetAbility():GetArtifactSpecialValueFor("losthp_heal_1")*0.01
    self.heal_pct_2 = self:GetAbility():GetArtifactSpecialValueFor("heal_pct_2")*0.01
    self.attack_speed_2 = self:GetAbility():GetArtifactSpecialValueFor("attack_speed_2")
    self.duration_2 = self:GetAbility():GetArtifactSpecialValueFor("duration_2")
    self.bonus_hp_3 = self:GetAbility():GetArtifactSpecialValueFor("bonus_hp_3")
    self.armor_to_hp_3 = self:GetAbility():GetArtifactSpecialValueFor("armor_to_hp_3")
    self.incoming_3 = self:GetAbility():GetArtifactSpecialValueFor("incoming_3")
    self.incoming_4 = self:GetAbility():GetArtifactSpecialValueFor("incoming_4")
    self.armor_to_damage_7 = self:GetAbility():GetArtifactSpecialValueFor("armor_to_damage_7")
    self.duration_7 = self:GetAbility():GetArtifactSpecialValueFor("duration_7")
    if self.level >= 70 then
        self.armor_to_damage = self.armor_to_damage_7
        self.duration_2 = self.duration_7
     end
end

function modifier_item_hd_blaiddar_effects:OnIntervalThink()
    if not IsServer() then return end
    local parent = self:GetParent()
    if not parent:HasModifier("modifier_item_chaotic_class_tank") then return end
    -- 附加效果1：守护
    local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius_1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,false) 
    -- 嘲讽敌人
    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_blaiddar_effects_lv10", {duration = self.interval_1*0.7})
    end
    -- 生命回复
    local lost_hp = parent:GetMaxHealth() - parent:GetHealth()
    parent:Heal(lost_hp*self.losthp_heal_1 , self:GetAbility())
end

function modifier_item_hd_blaiddar_effects:ADDeclareFunctions()
    local funcs ={
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end

function modifier_item_hd_blaiddar_effects:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_blaiddar_effects:Advanced_GetModifierBaseAttack_BonusDamage()
    return math.min(self:GetParent():GetPhysicalArmorValue(false) * self.armor_to_damage,1600)
end
function modifier_item_hd_blaiddar_effects:Advanced_GetModifierIncomingDamage_Percentage(keys)
    local incoming = 0
    if self.level >= 30 then
        incoming = incoming + self.incoming_3
    end
    if keys.attacker then
        if self.level >= 40 and keys.attacker:HasModifier("modifier_item_hd_blaiddar_effects_debuff") then
            incoming = incoming + self.incoming_4
        end
    end
    return -incoming    
end

function modifier_item_hd_blaiddar_effects:AdvancedGetModifierHealthBonus()
    if self.level >= 30 then
        return math.min(self.armor_to_hp_3*self:GetParent():GetPhysicalArmorValue(false),10000)
    end
    return 
end

function modifier_item_hd_blaiddar_effects:OnTakeDamage(params)
    if not IsServer() then return end
    local parent = self:GetParent()
    local unit = params.unit
    local attacker = params.attacker
    if unit and unit == self:GetParent() and attacker then
        -- 注意优先级，否则会先施加印记
        if self.level >= 40 and IsEnemy(attacker, params.unit) and not attacker:HasModifier("modifier_item_hd_blaiddar_effects_debuff") then
            if not params.unit:IsAlive() then
                params.unit:SetHealth(parent:GetMaxHealth()*0.5)
            end
        end

        -- 基础效果：施加狼之印
        if attacker:IsAlive() and IsEnemy(attacker, params.unit)  and not attacker:HasModifier("modifier_item_hd_blaiddar_effects_debuff") and params.damage > 0 then
            attacker:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_blaiddar_effects_debuff", {})
        end

        -- 附加效果2：暗月意志（等级20+）
        if self.level >= 20 and IsEnemy(attacker, params.unit) and params.damage > 0 then
            parent:Heal(params.damage*self.heal_pct_2, self:GetAbility())
            parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_blaiddar_effects_lv20", {duration = self.duration_2})
        end
    end
end

-- 附加效果3：抗旨之决心（仅不屈者）
function modifier_item_hd_blaiddar_effects:OnDeath(params)
    if not IsServer() then return end
    if self.level >= 30 and params.unit == self:GetParent() then
        if self.class == 1 then  -- 不屈者
            local outgoing_3 = self:GetAbility():GetArtifactSpecialValueFor("outgoing_3")
            local duration_3 = self:GetAbility():GetArtifactSpecialValueFor("duration_3")
            
            local players = GetAllRealHeroes()
            for _,hero in pairs(players) do
                if hero:IsAlive() and hero ~= self:GetParent() then
                    hero:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_blaiddar_effects_lv30", {
                        duration = duration_3,
                        outgoing = outgoing_3
                    })
                end
            end
        end
    end
end

-- 死亡增益modifier
modifier_item_hd_blaiddar_effects_lv30 = advanced_modifier({})
function modifier_item_hd_blaiddar_effects_lv30:IsPurgable() return false end
function modifier_item_hd_blaiddar_effects_lv30:GetTexture() return "item_artifact_8" end
function modifier_item_hd_blaiddar_effects_lv30:ADDeclareFunctions()
    return {advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL}
end
function modifier_item_hd_blaiddar_effects_lv30:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self:GetStackCount()
end
function modifier_item_hd_blaiddar_effects_lv30:OnCreated(params)
    if IsServer() then
        self.outgoing = params.outgoing or 40
        self:SetStackCount(self.outgoing)
    end
end
function modifier_item_hd_blaiddar_effects_lv30:OnRefresh(params)
    if IsServer() then
        self.outgoing = params.outgoing or 40
        self:SetStackCount(self.outgoing)
    end
end

-- 狼之印减益
modifier_item_hd_blaiddar_effects_debuff = advanced_modifier({})
function modifier_item_hd_blaiddar_effects_debuff:IsPurgable() return false end
function modifier_item_hd_blaiddar_effects_debuff:IsDebuff() return true end
function modifier_item_hd_blaiddar_effects_debuff:GetTexture() return "item_artifact_8" end

function modifier_item_hd_blaiddar_effects_debuff:ADDeclareFunctions()
    return {advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL}
end

function modifier_item_hd_blaiddar_effects_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return -self:GetAbility():GetArtifactSpecialValueFor("outgoing_down")
end

-- 附加效果2：暗月意志
modifier_item_hd_blaiddar_effects_lv20 = advanced_modifier({})
function modifier_item_hd_blaiddar_effects_lv20:IsPurgable() return false end
function modifier_item_hd_blaiddar_effects_lv20:IsHidden() return true end


function modifier_item_hd_blaiddar_effects_lv20:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_blaiddar_effects_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    self.attack_speed = self:GetAbility():GetArtifactSpecialValueFor("attack_speed_2")
end

function modifier_item_hd_blaiddar_effects_lv20:Advanced_GetModifierAttackSpeedPercentage()
    if not self:GetAbility() then return end
    return self.attack_speed
end
function modifier_item_hd_blaiddar_effects_lv20:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if not self:GetAbility() then return end
    return self.attack_speed
end

modifier_item_hd_blaiddar_effects_lv10 = advanced_modifier({})

function modifier_item_hd_blaiddar_effects_lv10:IsDebuff()			return true end
function modifier_item_hd_blaiddar_effects_lv10:IsHidden() 		return false end
function modifier_item_hd_blaiddar_effects_lv10:IsPurgable() 		return false end
function modifier_item_hd_blaiddar_effects_lv10:IsPurgeException() return false end
function modifier_item_hd_blaiddar_effects_lv10:GetTexture() return "item_artifact_8" end

function modifier_item_hd_blaiddar_effects_lv10:OnCreated()
	if not IsServer() then
		return
	end

	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	if not self.caster:IsAttackImmune() and not self.caster:IsInvulnerable() and not self.parent:ImmuneForceAttack() then
		self.parent:SetForceAttackTarget( self.caster ) 
		self.parent:MoveToTargetToAttack( self.caster )
	end
	self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/artifact/blaiddar/taunt.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.parent, PATTACH_OVERHEAD_FOLLOW, nil , self.parent:GetOrigin(), true )
	DestroyParticleByDelay(self.effect_cast,1)
end

function modifier_item_hd_blaiddar_effects_lv10:OnDestroy()
	if not IsServer() then
		return
	end
	self.parent:SetForceAttackTarget( nil )
	self.parent:Stop()
end