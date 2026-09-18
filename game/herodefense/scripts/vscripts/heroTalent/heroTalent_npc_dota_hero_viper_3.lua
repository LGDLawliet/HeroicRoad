LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_viper_3", "heroTalent/heroTalent_npc_dota_hero_viper_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_heroTalent_viper_3", "heroTalent/heroTalent_npc_dota_hero_viper_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_viper_3_toxic_body", "heroTalent/heroTalent_npc_dota_hero_viper_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_viper_3_toxic_saliva", "heroTalent/heroTalent_npc_dota_hero_viper_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_viper_3_break", "heroTalent/heroTalent_npc_dota_hero_viper_3", LUA_MODIFIER_MOTION_NONE)


heroTalent_npc_dota_hero_viper_3 = class({})

function heroTalent_npc_dota_hero_viper_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_viper_3"
end

function heroTalent_npc_dota_hero_viper_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_viper/viper_poison_attack.vpcf", context )
end

function heroTalent_npc_dota_hero_viper_3:GetAbilityTextureName()
	local texture_ori = "viper_nethertoxin"
	local texture_1 = "viper_nose_dive"
	local texture_2 = "viper/immortal/viper_poison_attack"
	if self:GetCaster():HasModifier("modifier_heroTalent_viper_3_toxic_saliva") then
		return texture_2
	end
	if self:GetCaster():HasModifier("modifier_heroTalent_viper_3_toxic_body") then
		return texture_1
	end
	return texture_ori
end

function heroTalent_npc_dota_hero_viper_3:GetBehavior()
	if self:GetCaster():HasModifier("modifier_heroTalent_viper_3_toxic_saliva") or self:GetCaster():HasModifier("modifier_heroTalent_viper_3_toxic_body") or self:GetCaster():GetLevel() < self:GetSpecialValueFor("lvl") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function heroTalent_npc_dota_hero_viper_3:OnSpellStart()
	if self:GetAutoCastState() then
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_heroTalent_viper_3_toxic_saliva")-- 自动开唾液
	else
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_heroTalent_viper_3_toxic_body")-- 普通开毒躯
	end
end
-- 基础modifier，处理属性加成和觉醒选择
modifier_heroTalent_viper_3 = advanced_modifier({})

function modifier_heroTalent_viper_3:IsHidden() return true end
function modifier_heroTalent_viper_3:IsDebuff() return false end
function modifier_heroTalent_viper_3:IsPurgable() return false end
function modifier_heroTalent_viper_3:RemoveOnDeath() return false end

function modifier_heroTalent_viper_3:OnCreated()
	self.each_str = self:GetAbility():GetSpecialValueFor("each_str")
	self.each_agi = self:GetAbility():GetSpecialValueFor("each_agi")
end


function modifier_heroTalent_viper_3:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_heroTalent_viper_3:AdvancedGetModifierHealthBonus()
	if self:GetParent():HasModifier("modifier_heroTalent_viper_3_toxic_saliva") then return 0 end
	return self:GetParent():GetStrength() * self.each_str
end

function modifier_heroTalent_viper_3:Advanced_GetModifierPreAttack_BonusDamage()
	return self:GetParent():GetAgility() * self.each_agi
end

-- 猛毒之躯觉醒
modifier_heroTalent_viper_3_toxic_body = advanced_modifier({})

function modifier_heroTalent_viper_3_toxic_body:IsHidden() return true end
function modifier_heroTalent_viper_3_toxic_body:IsDebuff() return false end
function modifier_heroTalent_viper_3_toxic_body:IsPurgable() return false end
function modifier_heroTalent_viper_3_toxic_body:RemoveOnDeath() return false end

function modifier_heroTalent_viper_3_toxic_body:OnCreated()
	local ability = self:GetAbility()
	self.armor = ability:GetSpecialValueFor("armor")
	self.magic_res = ability:GetSpecialValueFor("magic_res")
	self.poison = ability:GetSpecialValueFor("poison")*0.01
end

function modifier_heroTalent_viper_3_toxic_body:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_heroTalent_viper_3_toxic_body:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_STR,
		advanced_MODIFIER_PROPERTY_BONUS_STR_PER_LEVEL,
		advanced_MODIFIER_PROPERTY_BONUS_AGI_PER_LEVEL
	}
end
function modifier_heroTalent_viper_3_toxic_body:Advanced_GetModifierBonusSTR_PerLevel()
	return self:GetAbility():GetSpecialValueFor("str_up")
end
function modifier_heroTalent_viper_3_toxic_body:Advanced_GetModifierBonusAGI_PerLevel()
	return -self:GetAbility():GetSpecialValueFor("str_up")
end
function modifier_heroTalent_viper_3_toxic_body:Advanced_GetModifier_PrimaryAttributeOverride_Str()
	return 1 
end
function modifier_heroTalent_viper_3_toxic_body:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_heroTalent_viper_3_toxic_body:GetModifierMagicalResistanceBonus()
	return self.magic_res
end

function modifier_heroTalent_viper_3_toxic_body:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() and params.attacker:IsAlive() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local poison_amount = self:GetParent():GetMaxHealth() * self.poison
			params.attacker:Poison(self:GetParent(), self:GetAbility(), poison_amount)
		end
	end
end

-- 烈毒唾液觉醒
modifier_heroTalent_viper_3_toxic_saliva = advanced_modifier({})

function modifier_heroTalent_viper_3_toxic_saliva:IsHidden() return true end
function modifier_heroTalent_viper_3_toxic_saliva:IsDebuff() return false end
function modifier_heroTalent_viper_3_toxic_saliva:IsPurgable() return false end
function modifier_heroTalent_viper_3_toxic_saliva:RemoveOnDeath() return false end

function modifier_heroTalent_viper_3_toxic_saliva:OnCreated()
	self.index = self:GetAbility():GetSpecialValueFor("index")*0.01
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_heroTalent_viper_3_toxic_saliva:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
end
function modifier_heroTalent_viper_3_toxic_saliva:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_heroTalent_viper_3_toxic_saliva:GetModifierProjectileName()
    return "particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end

function modifier_heroTalent_viper_3_toxic_saliva:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local target = params.target
			target:AddNewModifier(
					self:GetParent(),
					self:GetAbility(),
					"modifier_heroTalent_viper_3_break",
					{duration = self.duration}
				)

			local poison_modifier = target:FindModifierByName("modifier_hd_poison")
			if poison_modifier then
				local poison_damage = poison_modifier:GetPoisonStackCount() * self.index
				ApplyPoisonDamage(self:GetParent(), self:GetAbility(), target, poison_damage)
				poison_modifier:Destroy()
			end
		end
	end
end

-- 破坏效果modifier
modifier_heroTalent_viper_3_break = class({})

function modifier_heroTalent_viper_3_break:IsHidden() return true end
function modifier_heroTalent_viper_3_break:IsDebuff() return true end
function modifier_heroTalent_viper_3_break:IsPurgable() return false end

function modifier_heroTalent_viper_3_break:CheckState()
	return {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end

