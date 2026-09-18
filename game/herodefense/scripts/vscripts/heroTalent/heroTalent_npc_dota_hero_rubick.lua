heroTalent_npc_dota_hero_rubick = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_rubick", "heroTalent/heroTalent_npc_dota_hero_rubick", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_rubick:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_rubick"
end
function heroTalent_npc_dota_hero_rubick:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_rubick")
	if modifier then
		modifier:LevelUpGain()
		modifier:ForceRefresh()
	end
end
modifier_heroTalent_npc_dota_hero_rubick = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_rubick:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_rubick:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_rubick:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_rubick:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_rubick:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_rubick:OnCreated() 
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")

	self.talentgain = self.ability:GetTalentGain(1)
	if IsServer() then
		self:LevelUpGain()
	end
end
function modifier_heroTalent_npc_dota_hero_rubick:OnRefresh() 
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")

	self.talentgain = self.ability:GetTalentGain(1)
end
function modifier_heroTalent_npc_dota_hero_rubick:LevelUpGain()
	local parent = self:GetParent()
	parent:SetBaseStrength(8)
	parent:SetBaseAgility(8)
	parent:SetBaseIntellect(15)
end
function modifier_heroTalent_npc_dota_hero_rubick:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end
function modifier_heroTalent_npc_dota_hero_rubick:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_heroTalent_npc_dota_hero_rubick:Advanced_GetModifierSpellAmplifyBonus()
	self.talentgain = self.ability:GetTalentGain(1)
	local spell_amp = self.spell_amp + (self.talentgain-1)*100
	return spell_amp
end
function modifier_heroTalent_npc_dota_hero_rubick:OnTooltip()
	return self:Advanced_GetModifierSpellAmplifyBonus()
end