
LinkLuaModifier("modifier_Middle_presence_of_the_dark_lord_aura", "skills/Middle_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_presence_of_the_dark_lord_debuff", "skills/Middle_presence_of_the_dark_lord", LUA_MODIFIER_MOTION_NONE)


Middle_presence_of_the_dark_lord	= Middle_presence_of_the_dark_lord or class({})
require("internal/timers")

-- function Middle_presence_of_the_dark_lord:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", context )
-- end
function Middle_presence_of_the_dark_lord:GetIntrinsicModifierName()
	return "modifier_Middle_presence_of_the_dark_lord_aura"
end
function Middle_presence_of_the_dark_lord:Spawn()
	self.bonus_reduce = 0
end
function Middle_presence_of_the_dark_lord:GetBonusReduce()
	return self.bonus_reduce
end

function Middle_presence_of_the_dark_lord:SetBonusReduce(value)
	self.bonus_reduce = value
end

modifier_Middle_presence_of_the_dark_lord_aura =modifier_Middle_presence_of_the_dark_lord_aura or  advanced_modifier({})
function modifier_Middle_presence_of_the_dark_lord_aura:IsDebuff()	return false end
function modifier_Middle_presence_of_the_dark_lord_aura:IsHidden()	return false end
function modifier_Middle_presence_of_the_dark_lord_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	
	return true
end

function modifier_Middle_presence_of_the_dark_lord_aura:GetModifierAura()
	return "modifier_Middle_presence_of_the_dark_lord_debuff"
end
function modifier_Middle_presence_of_the_dark_lord_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_Middle_presence_of_the_dark_lord_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_Middle_presence_of_the_dark_lord_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_Middle_presence_of_the_dark_lord_aura:GetAuraRadius()
	return self.aura_radius
end
function modifier_Middle_presence_of_the_dark_lord_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.self_reduce = 0
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_presence_of_the_dark_lord_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Middle_presence_of_the_dark_lord_aura:OnIntervalThink()
	local parent = self:GetParent()

	local armor = parent:GetPhysicalArmorValue(false)+self.self_reduce  --得到本来的护甲值
	if armor>0 then
		self.self_reduce = math.min(armor*0.2,40)
	else
		self.self_reduce = 0
	end
	self:GetAbility():SetBonusReduce(self.self_reduce*0.5)
	self:SetStackCount(self.self_reduce)
end


function modifier_Middle_presence_of_the_dark_lord_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Middle_presence_of_the_dark_lord_aura:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Middle_presence_of_the_dark_lord_aura:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Middle_presence_of_the_dark_lord_aura:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()
end




modifier_Middle_presence_of_the_dark_lord_debuff =modifier_Middle_presence_of_the_dark_lord_debuff or  advanced_modifier({})

function modifier_Middle_presence_of_the_dark_lord_debuff:IsDebuff()	return true end
function modifier_Middle_presence_of_the_dark_lord_debuff:IsHidden()	return false end
function modifier_Middle_presence_of_the_dark_lord_debuff:IsPurgable() return false end
function modifier_Middle_presence_of_the_dark_lord_debuff:IsPurgeException() return false end
function modifier_Middle_presence_of_the_dark_lord_debuff:OnCreated( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" )
	if IsServer() then
		self:SetStackCount(self:GetAbility():GetBonusReduce())
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_presence_of_the_dark_lord_debuff:OnRefresh( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" )
end

function modifier_Middle_presence_of_the_dark_lord_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	self:SetStackCount(ability:GetBonusReduce())
end



function modifier_Middle_presence_of_the_dark_lord_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Middle_presence_of_the_dark_lord_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Middle_presence_of_the_dark_lord_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Middle_presence_of_the_dark_lord_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor_reduction-self:GetStackCount()
end