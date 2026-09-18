heroTalent_npc_dota_hero_silencer = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_silencer", "heroTalent/heroTalent_npc_dota_hero_silencer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_silencer_int", "heroTalent/heroTalent_npc_dota_hero_silencer", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_silencer:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_silencer"
end

function heroTalent_npc_dota_hero_silencer:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_silencer/silencer_last_word_steal.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_silencer/silencer_last_word_steal_count.vpcf", context)
end

function heroTalent_npc_dota_hero_silencer:GetCastRange()
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

modifier_heroTalent_npc_dota_hero_silencer = modifier_heroTalent_npc_dota_hero_silencer or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_silencer:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_silencer:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_silencer:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_silencer:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_silencer:OnCreated() 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.wave_limit = self.ability:GetSpecialValueFor("wave_limit") --预设是300层，在表里面
	self.int = self.ability:GetSpecialValueFor("int") --基数
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.int_t = self.int*self.talentgain

    if IsServer() then
        self.death_gain_int = 0
        self:SetStackCount(0)
		self:SetHasCustomTransmitterData( true )-- 同步cy
		self:StartIntervalThink(3)
    end
end

function modifier_heroTalent_npc_dota_hero_silencer:OnRefresh()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.wave_limit = self.ability:GetSpecialValueFor("wave_limit") --预设是300层，在表里面
	self.int = self.ability:GetSpecialValueFor("int") --基数
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.int_t = self.int*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_silencer:OnIntervalThink()
	self.int = self.ability:GetSpecialValueFor("int") --基数
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.int_t = self.int*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_silencer:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        MODIFIER_EVENT_ON_WAVE_START = {},
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
    }
end

function modifier_heroTalent_npc_dota_hero_silencer:OnWaveStart()
	if not IsServer() then return end
	if Game_State:IsInChaoticEra() then return end

    self.death_gain_int = 0
end

function modifier_heroTalent_npc_dota_hero_silencer:OnChaoticEraRoundChange(keys)
	if not IsServer() then return end
	if not Game_State:IsInChaoticEra() then return end

	self.death_gain_int = 0
end

function modifier_heroTalent_npc_dota_hero_silencer:OnDeath(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local victim = keys.unit
    if not victim then return end
    if not IsEnemy(victim, self.caster) then return end

    self.death_gain_int = self.death_gain_int or 0
    if self.death_gain_int >= self.wave_limit then return end

	self.modifier_check = false
	local all_modifiers = victim:FindAllModifiers()
	if all_modifiers then
		for _, modifier in pairs(all_modifiers) do
			if modifier:IsDebuff() and modifier:GetCaster() == self.caster and not modifier:IsHidden() then
				self.modifier_check = true
				break
			end
		end
	end

    if (attacker and attacker == self.caster) or self.modifier_check == true then
        local keys = {
            target = victim,
            ignore_dis = 1,
        }
        local int_back = self:GainInt(keys)
        if int_back then
            self.death_gain_int = self.death_gain_int + int_back
        end
    else
        local keys = {
            target = victim,
            ignore_dis = 0,
        }
        local int_back = self:GainInt(keys)
        if int_back then
            self.death_gain_int = self.death_gain_int + int_back
        end
    end
end


--target 偷取目标
--ignore_dis 1/0 无视距离
--返回实际获取值
function modifier_heroTalent_npc_dota_hero_silencer:GainInt(keys)
    if not IsServer() then return end
    local target = keys.target
    local caster = self.caster
    local ignore_dis = keys.ignore_dis

    if not target then
        return 0
    end
    if ignore_dis ~= 1 and CalculateDistance(target, caster) > self.radius then return end

	self.int = self.ability:GetSpecialValueFor("int")
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.int_t = self.int*self.talentgain
    local gain = self.int_t

    self:SetStackCount(self:GetStackCount() + 1)

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_steal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(pfx, 0, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(pfx)

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_steal_count.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(pfx, 0, target:GetOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector("1"..1,0,0))
    ParticleManager:ReleaseParticleIndex(pfx)

    return gain
end

function modifier_heroTalent_npc_dota_hero_silencer:Advanced_GetModifierBonusStats_Intellect() 
    return self:GetStackCount()*self.int_t
end   

function modifier_heroTalent_npc_dota_hero_silencer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_silencer:OnTooltip()
	self.int = self.ability:GetSpecialValueFor("int")
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.int_t = self.int*self.talentgain
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBonusStats_Intellect()
	end
end

function modifier_heroTalent_npc_dota_hero_silencer:AddCustomTransmitterData( )
	return
	{
		int_t = self.int_t,

	}
end

function modifier_heroTalent_npc_dota_hero_silencer:HandleCustomTransmitterData( data )
	self.int_t = data.int_t
end