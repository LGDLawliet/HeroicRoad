LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_monkey_king_3", "heroTalent/heroTalent_npc_dota_hero_monkey_king_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_monkey_king_3_active", "heroTalent/heroTalent_npc_dota_hero_monkey_king_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heroTalent_npc_dota_hero_monkey_king_3 == nil then
	heroTalent_npc_dota_hero_monkey_king_3 = class({})
end
function heroTalent_npc_dota_hero_monkey_king_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_monkey_king_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_heroTalent_npc_dota_hero_monkey_king_3 == nil then
	modifier_heroTalent_npc_dota_hero_monkey_king_3 = advanced_modifier({})
end
function modifier_heroTalent_npc_dota_hero_monkey_king_3:IsHidden()
	return false
end
function modifier_heroTalent_npc_dota_hero_monkey_king_3:OnCreated(params)

	local ability = self:GetAbility()
	self.attack_need = ability:GetSpecialValueFor("attack_need")-1
	self.bat = ability:GetSpecialValueFor("base_attack_time")
	self.attack_range = ability:GetSpecialValueFor("bonus_attack_range")
	self.agi = ability:GetSpecialValueFor("bonus_agi_lvl")
	self.duration = ability:GetSpecialValueFor("duration")
end
function modifier_heroTalent_npc_dota_hero_monkey_king_3:OnRefresh(params)

	local ability = self:GetAbility()
	self.attack_need = ability:GetSpecialValueFor("attack_need")-1
	self.bat = ability:GetSpecialValueFor("base_attack_time")
	self.attack_range = ability:GetSpecialValueFor("bonus_attack_range")
	self.agi = ability:GetSpecialValueFor("bonus_agi_lvl")
	self.duration = ability:GetSpecialValueFor("duration")
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACKED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_BONUS_AGI_PER_LEVEL,
    }
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3:OnAttacked(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		if keys.attacker==self:GetParent() then
			if self:GetStackCount() >= self.attack_need then
				self:SetStackCount(0)
				self.bufforigin = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_monkey_king_3_active", {duration = self.duration})
			else
				self:IncrementStackCount()
			end

		end
	end
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3:Advanced_GetModifierBonusAGI_PerLevel()
	if self:GetAbility():GetAutoCastState() then 
		return self.agi
	end
	return 0 
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3:Advanced_GetModifierAttackRangeBonus()
	if self:GetAbility():GetAutoCastState() then 
		return 0
	end
	return self.attack_range
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3:GetModifierBaseAttackTimeConstant()
	if self:GetAbility():GetAutoCastState() then 
		return self.bat
	end
	return 0
end

--------------------------------------------------------------------

if modifier_heroTalent_npc_dota_hero_monkey_king_3_active == nil then
	modifier_heroTalent_npc_dota_hero_monkey_king_3_active = advanced_modifier({})
end
function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:IsHidden()
	return false
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:OnCreated(params)
	local ability = self:GetAbility()
	self.attack_index = ability:GetSpecialValueFor("attack_index")
	self.Diff_effciency = ability:GetSpecialValueFor("Diff_effciency")*0.01*0.6
	self.cleave_radius = ability:GetSpecialValueFor("cleave_radius")
	self.attack_need = ability:GetSpecialValueFor("attack_need")

end
function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:OnRefresh(params)
	local ability = self:GetAbility()
	self.attack_index = ability:GetSpecialValueFor("attack_index")
	self.Diff_effciency = ability:GetSpecialValueFor("Diff_effciency")*0.01*0.6
	self.cleave_radius = ability:GetSpecialValueFor("cleave_radius")

end


function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local caster =  self:GetCaster()
	local attacker = keys.attacker
	local ability = self:GetAbility()
	if attacker ~= caster or caster:PassivesDisabled() or attacker:IsDisableCleave() then return end

	local damage = keys.damage * self.Diff_effciency
	local target = keys.target


	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, self.cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		if enemy ~= target then
			AttackCleaveDelay(attacker, enemy, ability, damage)
		end
	end

	self:GetParent():GameTimer(0.03, function()
		if IsValid(self) then
			self:SafeDestroy()
		end
	end)
end



function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.attack_index*0.5
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
		self.record = keys.record--record判定需要这个函数来完成，在前面的record if
		return self.attack_index*0.5	
	end
	return 0
end

function modifier_heroTalent_npc_dota_hero_monkey_king_3_active:ADDeclareFunctions()
	return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},	
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
	}
end
