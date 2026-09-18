item_hd_dead_sword_effects = class({})

LinkLuaModifier("modifier_item_hd_dead_sword_effects", "player_artifact/item_hd_dead_sword_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dead_sword_effects_debuff", "player_artifact/item_hd_dead_sword_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_dead_sword_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_dead_sword_effects"
end

function item_hd_dead_sword_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf", context )
end
---------------------
modifier_item_hd_dead_sword_effects = advanced_modifier({})

function modifier_item_hd_dead_sword_effects:IsHidden() return true end
function modifier_item_hd_dead_sword_effects:IsPurgable() return false end

function modifier_item_hd_dead_sword_effects:OnCreated(kv)
    self.ability = self:GetAbility()
    
    self.bonus_health = self.ability:GetArtifactSpecialValueFor("bonus_health")
    self.hp_lost = self.ability:GetArtifactSpecialValueFor("hp_lost")*0.01
    self.count = self.ability:GetArtifactSpecialValueFor("count")
    self.heal_1 = self.ability:GetArtifactSpecialValueFor("heal_1")*0.01
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.hp_2 = self.ability:GetArtifactSpecialValueFor("hp_2")
    self.count_3 = self.ability:GetArtifactSpecialValueFor("count_3")
    self.min_3 = self.ability:GetArtifactSpecialValueFor("min_3")*0.01
    self.hp_lost_4 = self.ability:GetArtifactSpecialValueFor("hp_lost_4")*0.01
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.heal_7 = self.ability:GetArtifactSpecialValueFor("heal_7")*0.01
    self.count_10 = self.ability:GetArtifactSpecialValueFor("count_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dead_sword_effects")
end

function modifier_item_hd_dead_sword_effects:OnRefresh()
    self.bonus_health = self.ability:GetArtifactSpecialValueFor("bonus_health")
    self.hp_lost = self.ability:GetArtifactSpecialValueFor("hp_lost")*0.01
    self.count = self.ability:GetArtifactSpecialValueFor("count")
    self.heal_1 = self.ability:GetArtifactSpecialValueFor("heal_1")*0.01
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.hp_2 = self.ability:GetArtifactSpecialValueFor("hp_2")
    self.count_3 = self.ability:GetArtifactSpecialValueFor("count_3")
    self.min_3 = self.ability:GetArtifactSpecialValueFor("min_3")*0.01
    self.hp_lost_4 = self.ability:GetArtifactSpecialValueFor("hp_lost_4")*0.01
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.heal_7 = self.ability:GetArtifactSpecialValueFor("heal_7")*0.01
    self.count_10 = self.ability:GetArtifactSpecialValueFor("count_10")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dead_sword_effects")
end

function modifier_item_hd_dead_sword_effects:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}  
    }
end

function modifier_item_hd_dead_sword_effects:AdvancedGetModifierHealthBonus()
    return self.bonus_health
end
function modifier_item_hd_dead_sword_effects:Advanced_GetModifierIncomingDamage_Percentage()
    if self.level >= 20 then
        return -self.incoming_2
    end
    return 
end
function modifier_item_hd_dead_sword_effects:AdvancedGetModifierExtraHealthPercentage()
    if self.level >= 20 then
        return self.hp_2
    end
    return 
end
function modifier_item_hd_dead_sword_effects:OnTakeDamage(keys)
    if not IsServer() then return end
    local unit = keys.unit
    local attacker = keys.attacker
    if unit ~= self:GetParent() then return end
    if keys.damage <= 0 then return end
   
    if self.level >= 10 then
        local heal = (unit:GetMaxHealth()-unit:GetHealth())*self.heal_1
        local fhealing =  HealWithGain(heal,unit,unit,self:GetAbility())
        -- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil) 
    end
    
    if not attacker then return end
    if not attacker:IsAlive() or attacker:GetTeamNumber() == unit:GetTeamNumber() then return end
   
    local already = attacker:FindModifierByName("modifier_item_hd_dead_sword_effects_debuff")
    if already then return end
   
    local count = self.count
    local lost_min = 0
    if self.level >= 30 then
       count = self.count_3
       lost_min = unit:GetMaxHealth()*self.min_3
    end

    local hp_lost = self.hp_lost
    local chance = 0
    if self.level >= 40 then
        hp_lost = self.hp_lost_4
        chance = self.chance_4
    end
    if self.level >= 100 then
        count = self.count_10
    end

    attacker:AddNewModifier(unit, self:GetAbility(), "modifier_item_hd_dead_sword_effects_debuff", {count = count, hp_lost = hp_lost, lost_min = lost_min, chance = chance})
end


---------------------
modifier_item_hd_dead_sword_effects_debuff = advanced_modifier({})

function modifier_item_hd_dead_sword_effects_debuff:IsHidden() return self:GetStackCount()<1 end
function modifier_item_hd_dead_sword_effects_debuff:IsPurgable() return false end
function modifier_item_hd_dead_sword_effects_debuff:IsDebuff() return true end
function modifier_item_hd_dead_sword_effects_debuff:GetTexture() return "item_artifact_47" end
function modifier_item_hd_dead_sword_effects_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.heal_7 = self.ability:GetArtifactSpecialValueFor("heal_7")*0.01
    self.hp_lost_10 = self.ability:GetArtifactSpecialValueFor("hp_lost_10")*0.01
    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_dead_sword_effects")
    if IsServer() then 
        self.count = keys.count
        self.hp_lost = keys.hp_lost
        self.lost_min = keys.lost_min
        self.chance = keys.chance
        self:SetStackCount(self.count)
    end
end

function modifier_item_hd_dead_sword_effects_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
end

function modifier_item_hd_dead_sword_effects_debuff:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
    }
end

function modifier_item_hd_dead_sword_effects_debuff:OnAttack(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:SetStackCount(0) return end
    if not self:GetCaster() then return end
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then return end
    local caster = self:GetCaster()
    if self:GetStackCount() <= 0 then return end
    
    local hp_lost = math.max(attacker:GetHealth()*self.hp_lost,self.lost_min)
    if self.level >= 100 then
        hp_lost = math.max(attacker:GetHealth()*self.hp_lost + attacker:GetMaxHealth()*self.hp_lost_10,self.lost_min)
    end

    attacker:ModifyHealth(attacker:GetHealth()-hp_lost, self:GetAbility(), false, 0)
    local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
    self:SetStackCount(self:GetStackCount()-1)

    if self.level >=70 and not attacker:IsAlive() then
        caster:Heal((caster:GetMaxHealth()-caster:GetHealth())*self.heal_7, self.ability)
    end
end

function modifier_item_hd_dead_sword_effects_debuff:GetModifierMiss_Percentage()
    if self:GetStackCount() >= 1 then
	    return self.chance
    end
    return
end