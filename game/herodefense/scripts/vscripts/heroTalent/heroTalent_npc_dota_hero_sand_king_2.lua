LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sand_king_2", "heroTalent/heroTalent_npc_dota_hero_sand_king_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sand_king_2_debuff", "heroTalent/heroTalent_npc_dota_hero_sand_king_2.lua", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_sand_king_2 = class({})

function heroTalent_npc_dota_hero_sand_king_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sand_king_2"
end


modifier_heroTalent_npc_dota_hero_sand_king_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_sand_king_2:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_sand_king_2:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_sand_king_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_sand_king_2:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack_range = self.ability:GetSpecialValueFor("attack_range")
	self.poison = self.ability:GetSpecialValueFor("poison")
	self.bonus_poison = self.ability:GetSpecialValueFor("bonus_poison")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.slow = self.ability:GetSpecialValueFor("slow")

	self.talentgain = self.ability:GetTalentGain(0.9)
	self.bonus_poison_t = self.bonus_poison * self.talentgain
	self.slow_t = self.slow * self.talentgain
end

function modifier_heroTalent_npc_dota_hero_sand_king_2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_heroTalent_npc_dota_hero_sand_king_2:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.9)
	self.bonus_poison_t = self.bonus_poison * self.talentgain
	self.slow_t = self.slow * self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.bonus_poison_t
    elseif self._tooltip == 2 then
        return self.slow_t
    end
end

function modifier_heroTalent_npc_dota_hero_sand_king_2:ADDeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
end

function modifier_heroTalent_npc_dota_hero_sand_king_2:Advanced_GetModifierAttackRangeBonus()
	return self.attack_range
end

function modifier_heroTalent_npc_dota_hero_sand_king_2:OnAttackLanded(event)
    if not IsServer() then return end
    
    local target = event.target
    if not target or target:IsNull() or not target:IsAlive() then
        return
    end

    self.talentgain = self.ability:GetTalentGain(0.9)
	self.bonus_poison_t = self.bonus_poison * self.talentgain
	self.slow_t = self.slow * self.talentgain

    local poison = self.poison + self.bonus_poison_t*self.parent:GetAverageTrueAttackDamage(nil)
	target:Poison(self.parent, self.ability, poison)

	local slow = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_sand_king_2_debuff")
    if slow then
		slow:SetDuration(self.duration, true)
		slow:SetStackCount(self.slow_t)
    else
        target:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_sand_king_2_debuff", {duration = self.duration, slow = self.slow_t})
    end
end

--

modifier_heroTalent_npc_dota_hero_sand_king_2_debuff = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_sand_king_2_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_sand_king_2_debuff:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_sand_king_2_debuff:OnCreated(params)
    if not IsServer() then return end
    self:SetStackCount(params.slow)
end

function modifier_heroTalent_npc_dota_hero_sand_king_2_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_heroTalent_npc_dota_hero_sand_king_2_debuff:GetModifierMoveSpeedBonus_Constant()
    return -self:GetStackCount()
end
