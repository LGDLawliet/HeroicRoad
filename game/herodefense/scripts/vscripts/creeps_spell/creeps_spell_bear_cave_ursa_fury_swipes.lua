creeps_spell_bear_cave_ursa_fury_swipes = class({})
LinkLuaModifier("modifier_creeps_spell_bear_cave_ursa_fury_swipes", "creeps_spell/creeps_spell_bear_cave_ursa_fury_swipes", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff", "creeps_spell/creeps_spell_bear_cave_ursa_fury_swipes", LUA_MODIFIER_MOTION_NONE)

--预加载技能特效D:\steam\steamapps\common\dota 2 beta\content\dota\particles\units\heroes\hero_ursa\ursa_fury_swipes_debuff.vpcf
function creeps_spell_bear_cave_ursa_fury_swipes:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf", context)
end

function creeps_spell_bear_cave_ursa_fury_swipes:GetIntrinsicModifierName()
    return "modifier_creeps_spell_bear_cave_ursa_fury_swipes"
end
--每次攻击增加当前难度*self.bonus的攻击力攻击速度和移动速度
modifier_creeps_spell_bear_cave_ursa_fury_swipes = class({})
function modifier_creeps_spell_bear_cave_ursa_fury_swipes:IsDebuff()return false end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes:IsHidden()return true end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes:IsPurgable() return false end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT} end
--on_attack_landed 就给自己增加一层攻击力攻击速度和移动速度的buff，持续时间为当前难度，百相难度下会突破移动速度限制
function modifier_creeps_spell_bear_cave_ursa_fury_swipes:OnAttackLanded(keys)
    if not IsServer() then
        return 
    end
    if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
        return
    end
    local difficulty_INDEX = self:GetAbility():GetSpecialValueFor("duration")
    --print("difficulty_INDEX",difficulty_INDEX)
    local ability = self:GetAbility()
    --如果没有"modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff则添加buff，有则增加一层
    local modifier =   keys.attacker:FindModifierByName("modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff") 
    if modifier then
        modifier:IncrementStackCount()
        modifier:SetDuration(difficulty_INDEX, true)

    else
        keys.attacker:AddNewModifier(self:GetCaster(), ability, "modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff", {duration = difficulty_INDEX}) 

    end
    --每次攻击召唤一个小的npc_dota_creature_bear_cave_ursa，持续时间为当前难度系数
    --如果keys.attacker的模型大小为0.5则不会再生成小熊
    if keys.attacker:GetModelScale() == 0.5 then
        return
    end
    local attribute =  self:GetAbility():GetSpecialValueFor("attribute")*0.01
    local unit=keys.attacker:SummonUnit("npc_dota_creature_bear_cave_ursa",-1,keys.attacker:GetAbsOrigin(),nil,ability,0,keys.attacker:GetMaxHealth()*attribute,0,keys.attacker:GetDamageMax()*attribute,keys.attacker:GetPhysicalArmorValue(false)*0.1,0,0)
    --设置模型大小为0.5
    unit:SetModelScale(0.5)
    --设置移动速度为550
    unit:SetBaseMoveSpeed(1000)
    
    

end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes:GetModifierIgnoreMovespeedLimit() 
    return 1
end
--攻击力攻击速度和移动速度的buff
modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff = class({})
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:IsDebuff()return false end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:IsHidden()return false end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:IsPurgable() return false end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:IsPurgeException() return false end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:RemoveOnDeath() return true end

--oncreated时设置为一层
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:OnCreated()
    self.bonus = self:GetAbility():GetSpecialValueFor("bonus_per_attack")
    self.bonus_max = self:GetAbility():GetSpecialValueFor("bonus_max")
    if IsServer() then
        self:SetStackCount(1)
    end
end
--特效位置D:\steam\steamapps\common\dota 2 beta\content\dota\particles\units\heroes\hero_ursa\ursa_fury_swipes_debuff.vpcf
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:GetEffectName() return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf" end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:DeclareFunctions()	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:GetModifierAttackSpeedBonus_Constant()
    local stcak = self:GetStackCount()
    return math.min( self.bonus_max ,self.bonus*stcak)
end
--MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:GetModifierMoveSpeedBonus_Constant() 
    local stcak = self:GetStackCount()
        return math.min( self.bonus_max ,self.bonus*stcak)
    
end
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:GetModifierPreAttack_BonusDamage() 
    local stcak = self:GetStackCount()
    return math.min( self.bonus_max ,self.bonus*stcak)
end
--check_state,如果移动速度大于550则设置为没有碰撞体积
function modifier_creeps_spell_bear_cave_ursa_fury_swipes_buff:CheckState() 
    if self:GetParent():GetIdealSpeed() > 550 then
        return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
    end
end