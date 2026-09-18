heroTalent_npc_dota_hero_viper = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_viper", "heroTalent/heroTalent_npc_dota_hero_viper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_viper_debuff", "heroTalent/heroTalent_npc_dota_hero_viper", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_viper:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_viper"
end


modifier_heroTalent_npc_dota_hero_viper = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_viper:IsHidden() 	return false end
function modifier_heroTalent_npc_dota_hero_viper:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_viper:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_viper:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_viper:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_heroTalent_npc_dota_hero_viper:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.poison = self.ability:GetSpecialValueFor("poison")
	self.magic_res_down = self.ability:GetSpecialValueFor("magic_res_down")
	self.magic_res_down_max = self.ability:GetSpecialValueFor("magic_res_down_max")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.max_index = self.ability:GetSpecialValueFor("max_index")*0.01

	self.talentgain = self.ability:GetTalentGain(0.75)
	self.poison_t = self.poison*self.talentgain
	self.magic_res_down_t = self.magic_res_down*self.talentgain
end
function modifier_heroTalent_npc_dota_hero_viper:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}	
	
end
function modifier_heroTalent_npc_dota_hero_viper:GetModifierProjectileName()
	return	"particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end
function modifier_heroTalent_npc_dota_hero_viper:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end
function modifier_heroTalent_npc_dota_hero_viper:OnAttackLanded(keys)
    if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

    if attacker ~= self.parent then return end
    if not target or not target:IsAlive() then return end

	self.talentgain = self.ability:GetTalentGain(0.75)
	self.poison_t = self.poison*self.talentgain
	self.magic_res_down_t = self.magic_res_down*self.talentgain

    -- 计算基础中毒伤害：主属性 * 中毒系数 * 人物等级
    local base_poison = self.parent:HDGetPrimaryStatValue() * self.poison_t * self.parent:GetLevel()
    
    -- 获取目标已损失的生命值百分比（0-100范围）
    local missing_health_percent = 100 - target:GetHealthPercent()
    
    -- 基于已损失生命值百分比计算增强倍数
    -- 当目标生命值越低，毒素效果越强，最多提升到max_index倍
    local bonus_multiplier = 1 + (missing_health_percent * 0.01 * self.max_index)
    
    -- 计算最终中毒伤害
    local poison = base_poison * bonus_multiplier
	print("poison",poison)
    target:Poison(self.parent, self.ability, poison)
	local debuff = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_viper_debuff")
	if debuff then
		debuff:ForceRefresh()
		debuff:SetDuration(self.duration, true)
		debuff:SetStackCount(math.min(debuff:GetStackCount() + self.magic_res_down_t*10, self.magic_res_down_max*self.magic_res_down_t*10))
	else
		local newdebuff = target:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_viper_debuff", {duration = self.duration})
		newdebuff:SetStackCount(self.magic_res_down_t*10)
	end
end
function modifier_heroTalent_npc_dota_hero_viper:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.75)
	self.poison_t = self.poison*self.talentgain
	self.magic_res_down_t = self.magic_res_down*self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return (self.poison_t * self.parent:GetLevel())
	elseif self._tooltip == 2 then
        return (self.magic_res_down_t)
	end
end

function modifier_heroTalent_npc_dota_hero_viper:GetProjectileName()
	return "particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end


modifier_heroTalent_npc_dota_hero_viper_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_viper_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_viper_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_viper_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_viper_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_viper_debuff:GetEffectName()	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf" end
function modifier_heroTalent_npc_dota_hero_viper_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_viper_debuff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}	
	
end
function modifier_heroTalent_npc_dota_hero_viper_debuff:GetModifierMagicalResistanceBonus( params )
	return -self:GetStackCount()*0.1
end
function modifier_heroTalent_npc_dota_hero_viper_debuff:OnTooltip( params )
	return self:GetStackCount()*0.1
end
