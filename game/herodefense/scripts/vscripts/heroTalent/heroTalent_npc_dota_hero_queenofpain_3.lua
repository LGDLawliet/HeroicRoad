LinkLuaModifier("modifier_heroTalent_npc_dota_hero_queenofpain_3", "heroTalent/heroTalent_npc_dota_hero_queenofpain_3", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_queenofpain_3 = class({})

function heroTalent_npc_dota_hero_queenofpain_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_queenofpain_3"
end

modifier_heroTalent_npc_dota_hero_queenofpain_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_queenofpain_3:IsHidden()return false end
function modifier_heroTalent_npc_dota_hero_queenofpain_3:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_queenofpain_3:RemoveOnDeath()return false end

function modifier_heroTalent_npc_dota_hero_queenofpain_3:OnCreated()
    self.poison_index = self:GetAbility():GetSpecialValueFor("poison_index")*0.01
    self.line = self:GetAbility():GetSpecialValueFor("line")
    self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
    self.kill_count = 0
    if IsServer() then
        self:SetStackCount(self.kill_count)
    end
end

function modifier_heroTalent_npc_dota_hero_queenofpain_3:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_heroTalent_npc_dota_hero_queenofpain_3:OnTakeDamage(params)
    if not IsServer() then return end
    
    local attacker = params.attacker
    local target = params.unit
    local damage = params.damage
    if not params.target then
        params.target = target
    end
    if attacker ~= self:GetParent() then return end
    if attacker:GetTeamNumber() == target:GetTeamNumber() then return end
    
    if DamageFilter(params.record,HD_DAMAGE_FLAG_POISON) then
        return 
    end

    local damageindex_add = GetTotalDamageOutgoing(attacker,params) or 0
    local damageindex_mult = GetOutgoingDamagePercentFinal(attacker, params) or 1

    local final_index = (1+damageindex_add*0.01)*damageindex_mult*0.01
    target:Poison(attacker, self:GetAbility(), damage*self.poison_index/final_index)
   
end

function modifier_heroTalent_npc_dota_hero_queenofpain_3:OnDeath(params)
    if not IsServer() then return end
    
    local attacker = params.attacker
    local target = params.unit
    
    -- 检查是否是我们的英雄击杀的，且目标有中毒效果
    if attacker == self:GetParent() and target:HasModifier("modifier_hd_poison") then
        self.kill_count = self.kill_count + 1
        self:SetStackCount(self.kill_count)
    end
end

function modifier_heroTalent_npc_dota_hero_queenofpain_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(params)
    -- 检查是否已达到所需击杀数，且目标有中毒效果
    if self.kill_count >= self.line and params.target:HasModifier("modifier_hd_poison") then
        return self.outgoing
    end
    return 0
end
