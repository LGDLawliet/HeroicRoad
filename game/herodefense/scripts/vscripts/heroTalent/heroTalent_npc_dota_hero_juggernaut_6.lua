LinkLuaModifier("modifier_heroTalent_npc_dota_hero_juggernaut_6", "heroTalent/heroTalent_npc_dota_hero_juggernaut_6", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_juggernaut_6 = class({})

function heroTalent_npc_dota_hero_juggernaut_6:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_juggernaut_6"
end
----
modifier_heroTalent_npc_dota_hero_juggernaut_6 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_juggernaut_6:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:OnCreated()
    
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

    self.line = self.ability:GetSpecialValueFor("line")*0.01
    self.max = self.ability:GetSpecialValueFor("max")
    self.delay = self.ability:GetSpecialValueFor("delay")
    self.agi = self.ability:GetSpecialValueFor("agi")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
    self.move = self.ability:GetSpecialValueFor("move")
	self.level = self.ability:GetSpecialValueFor("level")
	self.min = self.ability:GetSpecialValueFor("min")
	self:SetStackCount(0)
    if IsServer() then
        self:StartIntervalThink(0.2)
    end
end

function modifier_heroTalent_npc_dota_hero_juggernaut_6:ResetStack()
	if self.parent:GetLevel() < self.level then
		self:SetStackCount(0)
	else
		self:SetStackCount(self.min)
	end
end

function modifier_heroTalent_npc_dota_hero_juggernaut_6:OnIntervalThink()
    if not IsServer() then return end
    if not self.parent:IsAlive() then self:SetStackCount(0) return end
	if self.ability:IsCooldownReady() then

		if self:GetStackCount() >= self.max then return end

		if self.parent:GetLevel() >= self.level and self:GetStackCount() < self.min then
			self:SetStackCount(self.min)
		end
		self:SetStackCount(math.min(self:GetStackCount()+1, self.max))
		self.ability:UseResources(true, true, true, true)
	end
end

function modifier_heroTalent_npc_dota_hero_juggernaut_6:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()}
    }
end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:Advanced_GetModifierBonusStats_Agility()
    return self:GetStackCount() * (self.agi + self.parent:GetLevel() * self.bonus_agi)
end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:GetModifierMoveSpeedBonus_Percentage()
    return self:GetStackCount() * self.move
end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Agility()
    end
    if self._tooltip == 2 then
        return self:GetModifierMoveSpeedBonus_Percentage()
    end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_6:OnTakeDamage(params)
    if not IsServer() then return end
	local unit = params.unit
	local attacker = params.attacker
	
    if unit ~= self.parent then return end
    if attacker and IsEnemy(attacker, self.parent) then
		local line = self.parent:GetMaxHealth()*self.line
		if params.damage >= line then
			if not self.already then
				unit:GameTimer(self.delay, function()
					self:ResetStack()
					self.already = nil
				end)
				self.already = true
			end
		end
    end
end