heroTalent_npc_dota_hero_sniper = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sniper", "heroTalent/heroTalent_npc_dota_hero_sniper", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_sniper:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sniper"
end
function heroTalent_npc_dota_hero_sniper:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_sniper")
	if modifier then
		modifier:ForceRefresh()
	end
end
modifier_heroTalent_npc_dota_hero_sniper = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_sniper:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_sniper:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sniper:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sniper:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sniper:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_sniper:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.attack_range = self.ability:GetSpecialValueFor("attack_range")
	
	self.talentgain = self.ability:GetTalentGain(2.5)
end
function modifier_heroTalent_npc_dota_hero_sniper:CheckState()
	return{
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
end
function modifier_heroTalent_npc_dota_hero_sniper:OnRefresh() 
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.attack_range = self.ability:GetSpecialValueFor("attack_range")

	self.talentgain = self.ability:GetTalentGain(2.5)
end
function modifier_heroTalent_npc_dota_hero_sniper:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end
function modifier_heroTalent_npc_dota_hero_sniper:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_TOOLTIP,  
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	}
end
function modifier_heroTalent_npc_dota_hero_sniper:GetModifierProjectileSpeedBonus()
	return 1500
end
function modifier_heroTalent_npc_dota_hero_sniper:Advanced_GetModifierAttackRangeBonus()
	self.talentgain = self.ability:GetTalentGain(2.5)
	local attack_range = self.attack_range + (self.talentgain-1)*100
	return attack_range
end
function modifier_heroTalent_npc_dota_hero_sniper:OnTooltip()
	return self:Advanced_GetModifierAttackRangeBonus()
end
