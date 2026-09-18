LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dazzle_2", "heroTalent/heroTalent_npc_dota_hero_dazzle_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dazzle_2_active", "heroTalent/heroTalent_npc_dota_hero_dazzle_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dazzle_2_passive", "heroTalent/heroTalent_npc_dota_hero_dazzle_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dazzle_2_shield", "heroTalent/heroTalent_npc_dota_hero_dazzle_2.lua", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_dazzle_2 = class({})

function heroTalent_npc_dota_hero_dazzle_2:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_dazzle_2_passive"
end

function heroTalent_npc_dota_hero_dazzle_2:OnSpellStart()
	local talentgain = self:GetTalentGain(0.6)
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration")
    local min_hp_pct = self:GetSpecialValueFor("minhp")*0.01
    local outgoing_per_sec = self:GetSpecialValueFor("outgoing")*talentgain

    local allies = GetAllRealHeroes()
    for _,ally in pairs(allies) do
        ally:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_dazzle_2_active", {
            duration = duration,
            min_hp_pct = min_hp_pct,
            outgoing_per_sec = outgoing_per_sec
        })
    end
    caster:EmitSound("Hero_Dazzle.Shallow_Grave")
end
function heroTalent_npc_dota_hero_dazzle_2:IsRefreshable()
	return false
end
-- 主动效果 modifier
modifier_heroTalent_npc_dota_hero_dazzle_2_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_dazzle_2_active:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf" end
function modifier_heroTalent_npc_dota_hero_dazzle_2_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_dazzle_2_active:OnCreated(kv)
	self.ability = self:GetAbility()
    if not IsServer() then return end
    self.min_hp_pct = kv.min_hp_pct 
    self.outgoing_per_sec = kv.outgoing_per_sec
    self:SetStackCount(0)
    self:StartIntervalThink(1)
	self:SetHasCustomTransmitterData( true )-- 同步cy
end
function modifier_heroTalent_npc_dota_hero_dazzle_2_active:OnRefresh(kv)
	self.ability = self:GetAbility()
    if not IsServer() then return end
    self.min_hp_pct = kv.min_hp_pct 
    self.outgoing_per_sec = kv.outgoing_per_sec
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:OnIntervalThink()
    if not IsServer() then return end
    self:IncrementStackCount()
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:ADDeclareFunctions()
    return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:GetMinHealth()
    return self:GetParent():GetMaxHealth()*self.min_hp_pct
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self:GetStackCount()*self.outgoing_per_sec
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:GetStackCount()*self.outgoing_per_sec
	end
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:AddCustomTransmitterData( )
	return
	{
		outgoing_per_sec = self.outgoing_per_sec,
	}
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_active:HandleCustomTransmitterData( data )
	self.outgoing_per_sec = data.outgoing_per_sec
end
-- 被动效果 modifier
modifier_heroTalent_npc_dota_hero_dazzle_2_passive = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dazzle_2_passive:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_dazzle_2_passive:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_dazzle_2_passive:OnCreated(kv)
	self.ability = self:GetAbility()
	self.shield_pct = self.ability:GetSpecialValueFor("shield")*0.01
	self.shield_duration = self.ability:GetSpecialValueFor("shield_duration")
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_passive:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标 heal:治疗量
	if IsServer() then
        local healer = keys.unit
        local target = keys.target
		local heal = keys.heal
		if heal < 1 then return end
		if healer ~= self:GetParent() then return end
        if not target:IsAlive() then return end
        if IsEnemy(healer, target) then return end

		target:AddNewModifier(healer, self.ability, "modifier_heroTalent_npc_dota_hero_dazzle_2_shield", {duration = self.shield_duration, shield = heal*self.shield_pct})			

	end
end

-- 护盾 modifier
modifier_heroTalent_npc_dota_hero_dazzle_2_shield = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dazzle_2_shield:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_dazzle_2_shield:GetEffectName() return "particles/items3_fx/lotus_orb_shield.vpcf" end

function modifier_heroTalent_npc_dota_hero_dazzle_2_shield:OnCreated(kv)
    if not IsServer() then return end
    self.shield = kv.shield 
	self:SetStackCount(self.shield)
end

function modifier_heroTalent_npc_dota_hero_dazzle_2_shield:OnRefresh(kv)
    if not IsServer() then return end
    self.shield = kv.shield 
	self:SetStackCount(math.min(self:GetStackCount() + self.shield, self:GetParent():GetMaxHealth()))
end


function modifier_heroTalent_npc_dota_hero_dazzle_2_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_heroTalent_npc_dota_hero_dazzle_2_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
    return stack
end

