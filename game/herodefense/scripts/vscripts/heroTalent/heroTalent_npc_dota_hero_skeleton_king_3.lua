
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_skeleton_king_3", "heroTalent/heroTalent_npc_dota_hero_skeleton_king_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_skeleton_king_3_already", "heroTalent/heroTalent_npc_dota_hero_skeleton_king_3", LUA_MODIFIER_MOTION_NONE)
heroTalent_npc_dota_hero_skeleton_king_3 = class({})


function heroTalent_npc_dota_hero_skeleton_king_3:GetIntrinsicModifierName()
    return  "modifier_heroTalent_npc_dota_hero_skeleton_king_3"
end
function heroTalent_npc_dota_hero_skeleton_king_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_critical.vpcf", context )

end

modifier_heroTalent_npc_dota_hero_skeleton_king_3 = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_skeleton_king_3:IsHidden()
    return true
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_3:IsPurgable()
    return false
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_3:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_3:OnAttackLanded(keys)
    if not IsServer() then return end
    
    
    
    local attacker = keys.attacker
    local target = keys.target
    self.cut = self:GetAbility():GetSpecialValueFor("hp_cut")
    self.delay = self:GetAbility():GetSpecialValueFor("delay")
    self.index = self:GetAbility():GetSpecialValueFor("index")*0.01
    if attacker ~= self:GetParent() then return end
    -- 检查目标是否有效
    if not target or target:IsNull() then return end
    -- 检查是否是敌人
    if target:GetTeamNumber() == attacker:GetTeamNumber() then return end
    -- 检查是否已经攻击过该目标
    local modifier = target:HasModifier("modifier_heroTalent_npc_dota_hero_skeleton_king_3_already")   
    if modifier then
        return
    end
    -- 计算要削减的生命值
    local hp_to_cut = target:GetMaxHealth() * (self.cut / 100)
    -- 削减生命值
    target:ModifyHealth(target:GetHealth()-hp_to_cut, self:GetAbility(), false, 0)
    target:AddNewModifier(attacker,self:GetAbility(),"modifier_heroTalent_npc_dota_hero_skeleton_king_3_already",{})
    -- 创建特效
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_critical.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    
    -- 播放音效
    target:EmitSound("Hero_SkeletonKing.CriticalStrike")
    
    -- 延迟恢复生命值
    Timers:CreateTimer(self.delay, function()
        if not target:IsNull() and target:IsAlive() then
            target:ModifyHealth(target:GetHealth() + hp_to_cut*self.index,self:GetAbility(),false,0)
            -- 创建恢复特效
            local heal_particle = ParticleManager:CreateParticle(
                "particles/generic_gameplay/generic_lifesteal.vpcf",
                PATTACH_ABSORIGIN_FOLLOW,
                target
            )
            ParticleManager:ReleaseParticleIndex(heal_particle)
        end
    end)
end



modifier_heroTalent_npc_dota_hero_skeleton_king_3_already = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_skeleton_king_3_already:IsHidden()
    return true
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_3_already:IsPurgable()
    return false
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_3_already:RemoveOnDeath()
    return false
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_3_already:IsDebuff()
    return false
end
