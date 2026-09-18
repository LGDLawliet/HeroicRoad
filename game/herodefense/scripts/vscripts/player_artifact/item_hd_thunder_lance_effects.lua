-- 重写完成
item_hd_thunder_lance_effects = class({})
LinkLuaModifier("modifier_item_hd_thunder_lance_effects", "player_artifact/item_hd_thunder_lance_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_thunder_lance_effects_already", "player_artifact/item_hd_thunder_lance_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_thunder_lance_effects_lv40", "player_artifact/item_hd_thunder_lance_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_thunder_lance_effects_lv30_already", "player_artifact/item_hd_thunder_lance_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_thunder_lance_effects_lv20", "player_artifact/item_hd_thunder_lance_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_thunder_lance_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_thunder_lance_effects"
end
function item_hd_thunder_lance_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/thunder_lance/effect.vpcf", context )
end
modifier_item_hd_thunder_lance_effects = advanced_modifier({})

function modifier_item_hd_thunder_lance_effects:IsDebuff() return false end
function modifier_item_hd_thunder_lance_effects:IsHidden() return self.level < 30 end
function modifier_item_hd_thunder_lance_effects:IsPurgable() return false end
function modifier_item_hd_thunder_lance_effects:RemoveOnDeath() return false end
function modifier_item_hd_thunder_lance_effects:GetTexture() return "item_artifact_10" end

function modifier_item_hd_thunder_lance_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_base_damage = self.ability:GetArtifactSpecialValueFor("bonus_base_damage")
    self.first_index = self.ability:GetArtifactSpecialValueFor("first_index")*0.01
    self.index = self.ability:GetArtifactSpecialValueFor("index")*0.01
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.max = self.ability:GetArtifactSpecialValueFor("max")

    self.index_1 = self.ability:GetArtifactSpecialValueFor("index_1")*0.01
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")
    self.attack_grow_3 = self.ability:GetArtifactSpecialValueFor("attack_grow_3")
    self.crit_bonus_3 = self.ability:GetArtifactSpecialValueFor("crit_bonus_3")
    self.index_4 = self.ability:GetArtifactSpecialValueFor("index_4")*0.01
    self.bcrit_index_4 = self.ability:GetArtifactSpecialValueFor("bcrit_index_4")
    self.interval_7 = self.ability:GetArtifactSpecialValueFor("interval_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_thunder_lance_effects")
    if self.level >= 40 then
        self.index = self.index_4
    end
    if self.level >= 70 then
        self.interval_3 = self.interval_7 
    end
end

function modifier_item_hd_thunder_lance_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_base_damage = self.ability:GetArtifactSpecialValueFor("bonus_base_damage")
    self.first_index = self.ability:GetArtifactSpecialValueFor("first_index")*0.01
    self.index = self.ability:GetArtifactSpecialValueFor("index")*0.01
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.max = self.ability:GetArtifactSpecialValueFor("max")

    self.index_1 = self.ability:GetArtifactSpecialValueFor("index_1")*0.01
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")
    self.attack_grow_3 = self.ability:GetArtifactSpecialValueFor("attack_grow_3")
    self.crit_bonus_3 = self.ability:GetArtifactSpecialValueFor("crit_bonus_3")
    self.index_4 = self.ability:GetArtifactSpecialValueFor("index_4")*0.01
    self.bcrit_index_4 = self.ability:GetArtifactSpecialValueFor("bcrit_index_4")
    self.interval_7 = self.ability:GetArtifactSpecialValueFor("interval_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_thunder_lance_effects")
    if self.level >= 40 then
        self.index = self.index_4
    end
    if self.level >= 70 then
        self.interval_3 = self.interval_7 
    end
end

function modifier_item_hd_thunder_lance_effects:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
end

function modifier_item_hd_thunder_lance_effects:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
        MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_item_hd_thunder_lance_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if keys.attacker:IsInSpecialAttack() then return end
    local target = keys.target

    if not target then return end
    if not target:IsAlive() then return end
    if (not target:IsChaoticEraElite()) and (not target:IsChaoticEraBoss()) then return end
    
    local already = target:HasModifier("modifier_item_hd_thunder_lance_effects_already")
    if already then return end
    
    self:Thunder(target, keys.damage*self.first_index)  
    target:AddNewModifier(self:GetCaster(), self:GetAbility(),"modifier_item_hd_thunder_lance_effects_already",{})
end 

function modifier_item_hd_thunder_lance_effects:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    if self:GetParent():IsRangedAttacker() then return end
    local incoming = 0
    if self:GetParent():IsAttacking() then 
        incoming = incoming + self.incoming_1
    end
    return -incoming
end

function modifier_item_hd_thunder_lance_effects:Advanced_GetModifierBaseAttack_BonusDamage()
    return self.bonus_base_damage
end 

function modifier_item_hd_thunder_lance_effects:AdvancedOnCriticalStrikeTrigger(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then return end
    if attacker:IsInSpecialAttack() then return end
    if self.level < 30 then return end
    if attacker:HasModifier("modifier_item_hd_thunder_lance_effects_lv30_already") then return end
    local duration = self.interval_3
    if not attacker:IsRangedAttacker() then 
        duration = duration * 0.5
    end
    attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_thunder_lance_effects_lv30_already", {duration = duration})

    self:SetStackCount(self:GetStackCount() + 1 )
end

function modifier_item_hd_thunder_lance_effects:Advanced_GetModifierPreAttack_BonusDamage() 
    return  self.attack_grow_3*self:GetStackCount()
end
function modifier_item_hd_thunder_lance_effects:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return self.crit_bonus_3*self:GetStackCount()
end
function modifier_item_hd_thunder_lance_effects:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierPreAttack_BonusDamage() 
	end
	if self._tooltip == 2 then
		return self:Advanced_GetModifier_PhysicalCriticalAmp()
	end
end
function modifier_item_hd_thunder_lance_effects:GetModifierPreAttack_BonusDamagePostCrit(params) 
    if self.level >= 10 then
        return self.index_1 * self:GetParent():GetAverageTrueAttackDamage(nil)
    end
    return 
end

function modifier_item_hd_thunder_lance_effects:OnTakeDamage(keys)
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() then return end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
    if keys.attacker:IsInSpecialAttack() then return end
    if keys.attacker:IsRangedAttacker() then return end
    if not keys.attacker:IsApplyModifier() then return end
    if not keys.unit or keys.unit:IsAlive() then return end
    
    if self.level >= 20 then
        local modifier = keys.attacker:FindModifierByName("modifier_item_hd_thunder_lance_effects_lv20")
        if modifier then
            modifier:ForceRefresh()
            modifier:SetDuration(self.duration_2, true)
        else
            keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_thunder_lance_effects_lv20", {duration = self.duration_2})
        end
    end

    local damage = keys.damage*self.index
    local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.unit:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    for i, enemy in pairs(enemies) do
        if enemy:IsAlive() then
            self:Thunder(enemy,damage) 
            i = i + 1 
            if i > self.max then 
                break
            end
        end
    end
end

function modifier_item_hd_thunder_lance_effects:Thunder(target,damage)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if not target then return end
    if not damage then return end

    local pos = target:GetAbsOrigin()
    local damage = math.min(damage,999999)
    local particle = ParticleManager:CreateParticle("particles/rebuild/artifact/thunder_lance/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z+64))
    ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
    ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
    ParticleManager:ReleaseParticleIndex( particle )
    DestroyParticleByDelay(particle,2)
    EmitSoundOnLocationWithCaster(pos, "Hero_Zuus.LightningBolt", target)


    local damage_table 			= {
        attacker 		= self:GetParent(),
        victim          = target,
        ability 		= self:GetAbility(),
        damage_type 	= DAMAGE_TYPE_PHYSICAL ,
        damage			= damage*0.5,
        damage_flags    = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
        hd_flags        = HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
    }
    ApplyDamage(damage_table)
    if self.level >= 40 and target:IsAlive() then
       target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_hd_thunder_lance_effects_lv40",{crit = self.bcrit_index_4}) 
    end
end
---------
modifier_item_hd_thunder_lance_effects_lv20 = advanced_modifier({})

function modifier_item_hd_thunder_lance_effects_lv20:IsDebuff() return false end
function modifier_item_hd_thunder_lance_effects_lv20:IsHidden() return true end
function modifier_item_hd_thunder_lance_effects_lv20:IsPurgable() return false end
function modifier_item_hd_thunder_lance_effects_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    self.ability = self:GetAbility()
    self.crit_bonus_2 = self.ability:GetArtifactSpecialValueFor("crit_bonus_2")
    self:SetStackCount(self.crit_bonus_2)
end
function modifier_item_hd_thunder_lance_effects_lv20:OnRefresh(keys)
    if not self:GetAbility() then return end
    self.crit_bonus_2 = self.ability:GetArtifactSpecialValueFor("crit_bonus_2")
    self:SetStackCount(self.crit_bonus_2)
end
function modifier_item_hd_thunder_lance_effects_lv20:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
    }
end
function modifier_item_hd_thunder_lance_effects_lv20:Advanced_GetModifier_PhysicalCriticalAmp(keys)
    if not self:GetAbility() then return end
	return self:GetStackCount()*0.5
end
------------
modifier_item_hd_thunder_lance_effects_already = advanced_modifier({})

function modifier_item_hd_thunder_lance_effects_already:IsDebuff() return false end
function modifier_item_hd_thunder_lance_effects_already:IsHidden() return true end
function modifier_item_hd_thunder_lance_effects_already:IsPurgable() return false end
function modifier_item_hd_thunder_lance_effects_already:RemoveOnDeath() return false end
------------
modifier_item_hd_thunder_lance_effects_lv30_already = advanced_modifier({})

function modifier_item_hd_thunder_lance_effects_lv30_already:IsDebuff() return false end
function modifier_item_hd_thunder_lance_effects_lv30_already:IsHidden() return true end
function modifier_item_hd_thunder_lance_effects_lv30_already:IsPurgable() return false end
function modifier_item_hd_thunder_lance_effects_lv30_already:RemoveOnDeath() return false end
---------
modifier_item_hd_thunder_lance_effects_lv40 = advanced_modifier({})

function modifier_item_hd_thunder_lance_effects_lv40:IsDebuff() return true end
function modifier_item_hd_thunder_lance_effects_lv40:IsHidden() return false end
function modifier_item_hd_thunder_lance_effects_lv40:IsPurgable() return false end
function modifier_item_hd_thunder_lance_effects_lv40:GetTexture() return "item_artifact_10" end
function modifier_item_hd_thunder_lance_effects_lv40:OnCreated(keys)
    if IsServer() then
        self.crit = keys.crit or 0
        self:SetStackCount(self.crit)
    end
end
function modifier_item_hd_thunder_lance_effects_lv40:OnRefresh(keys)
    if IsServer() then
        self.crit = keys.crit or 0
        self:SetStackCount(self.crit)
    end
end
function modifier_item_hd_thunder_lance_effects_lv40:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE
    }
end
function modifier_item_hd_thunder_lance_effects_lv40:Advanced_GetModifierCriticalStrikeDamageTarget(keys)
	return self:GetStackCount()*0.3
end
function modifier_item_hd_thunder_lance_effects_lv40:Advanced_GetModifierPhysicalArmorBonusPercentage(keys)
	return -self:GetStackCount()
end