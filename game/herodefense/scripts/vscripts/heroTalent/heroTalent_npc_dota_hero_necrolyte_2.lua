heroTalent_npc_dota_hero_necrolyte_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_necrolyte_2", "heroTalent/heroTalent_npc_dota_hero_necrolyte_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff", "heroTalent/heroTalent_npc_dota_hero_necrolyte_2", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_necrolyte_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_necrolyte_2"
end

function heroTalent_npc_dota_hero_necrolyte_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf", context )
end


modifier_heroTalent_npc_dota_hero_necrolyte_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_necrolyte_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:DestroyOnExpire() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:StatusEffectPriority()return MODIFIER_PRIORITY_ULTRA end
function modifier_heroTalent_npc_dota_hero_necrolyte_2:GetEffectAttachType()return PATTACH_POINT_FOLLOW end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.mrs_down = self.ability:GetSpecialValueFor("mrs_down")
	self.bonus_mrs_down = self.ability:GetSpecialValueFor("bonus_mrs_down")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.talentgain = self.ability:GetTalentGain(0.35)

	self.mrs_down_t = self.mrs_down * self.talentgain
	self.bonus_mrs_down_t = self.bonus_mrs_down * self.talentgain

	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self:StartIntervalThink(0.5)
	end
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:OnRefresh()
	self:OnCreated()
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED = {self:GetParent(), nil},
    }
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return self:CalculateTotalMrsdown()
    end
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:CalculateTotalMrsdown()
	self.talentgain = self.ability:GetTalentGain(0.35)
	self.mrs_down_t = self.mrs_down * self.talentgain
	self.bonus_mrs_down_t = self.bonus_mrs_down * self.talentgain

	self.total_mrs_down = self.mrs_down_t + self.bonus_mrs_down_t * self:GetStackCount()

	return self.total_mrs_down
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:OnIntervalThink()
	if not IsServer() then return end
	if not self.parent:IsAlive() then return end

	local mrs_down = self:CalculateTotalMrsdown()

	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		enemy:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff")
		enemy:AddNewModifier(self.caster, self.ability, "modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff", {
			duration = 1.5,
			stack = mrs_down,
		})
	end
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2:OnAbilityExecuted(params)
    if not IsServer() then return end
    local unit = params.unit
    if unit ~= self:GetParent() then return end
    local ability = params.ability
    if not ability or ability:IsItem() or ability:IsToggle() or ability:GetCooldown(ability:GetLevel()) <= 0 then return end

	local time = GameRules:GetGameTime()
	if time - self.timer < 0.3 then return end
	self.timer = time

	self:AddStackDuration(1, self.duration)
end


------
modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:OnCreated(kv)
	if IsServer() then
		self.stack = kv.stack
		self:SetStackCount(self.stack)
	end
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_necrolyte_2_debuff:OnTooltip()
	return self:GetStackCount()
end