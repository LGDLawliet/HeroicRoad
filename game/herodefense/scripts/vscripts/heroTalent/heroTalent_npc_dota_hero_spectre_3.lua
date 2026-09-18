heroTalent_npc_dota_hero_spectre_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spectre_3", "heroTalent/heroTalent_npc_dota_hero_spectre_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_spectre_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_spectre_3"
end

function heroTalent_npc_dota_hero_spectre_3:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_spectre_3")
	if modifier then
		modifier:LevelUpGain()
	end
end
-----------------------------
modifier_heroTalent_npc_dota_hero_spectre_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spectre_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spectre_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spectre_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spectre_3:OnCreated(keys)
	if IsClient() then
		return
	end

	--智力不用改
	self.base_atb = self:GetAbility():GetSpecialValueFor("base_atb")
	self.lvl_atb = self:GetAbility():GetSpecialValueFor("lvl_atb")
	self.hp_line = self:GetAbility():GetSpecialValueFor("hp_line")
	self.no_damage = self:GetAbility():GetSpecialValueFor("no_damage")
	local parent = self:GetParent()
	local level = parent:GetLevel()-1
	parent:SetBaseStrength(self.base_atb+level*self.lvl_atb)
	parent:SetBaseAgility(self.base_atb+level*self.lvl_atb)
	parent:SetBaseIntellect(self.base_atb+level*self.lvl_atb)
end

function modifier_heroTalent_npc_dota_hero_spectre_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_ALL,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_spectre_3:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	if self:GetParent() ~= keys.target then
		return
	end
	if self:GetParent():GetHealthPercent() > self.hp_line then
		return
	end
	if keys.attacker then
		local chance = self.no_damage
		local random = math.random

		if chance >= random(1, 100)  then
			if not keys.attacker:IsAlive() then
				keys.attacker:SetHealth(1)
			end

			return -100
		end
	end
	return 0
end

function modifier_heroTalent_npc_dota_hero_spectre_3:LevelUpGain()
	local parent = self:GetParent()
	local str_gain = parent:GetStrengthGain()
	local agi_gain = parent:GetAgilityGain()
	local int_gain = parent:GetIntellectGain()
	parent:SetBaseStrength(parent:GetBaseStrength() + (self.lvl_atb-str_gain))
	parent:SetBaseAgility(parent:GetBaseAgility() + (self.lvl_atb-agi_gain))
	parent:SetBaseIntellect(parent:GetBaseIntellect() + (self.lvl_atb-int_gain))

end




function modifier_heroTalent_npc_dota_hero_spectre_3:Advanced_GetModifier_PrimaryAttributeOverride_All()
    return 1
end
