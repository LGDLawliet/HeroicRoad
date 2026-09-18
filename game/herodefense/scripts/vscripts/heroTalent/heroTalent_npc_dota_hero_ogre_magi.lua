heroTalent_npc_dota_hero_ogre_magi = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ogre_magi", "heroTalent/heroTalent_npc_dota_hero_ogre_magi", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_ogre_magi:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_ogre_magi"
end



modifier_heroTalent_npc_dota_hero_ogre_magi = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_ogre_magi:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi:GetPriority() return 500 end
function modifier_heroTalent_npc_dota_hero_ogre_magi:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.int_limit = self.ability:GetSpecialValueFor("int_limit")
	self.str_mana = self.ability:GetSpecialValueFor("str_mana")
	self.str_mana_regen = self.ability:GetSpecialValueFor("str_mana_regen")

	if IsServer() then
		self.talentgain1 = self.ability:GetTalentGain(0.5)
		self.talentgain2 = self.ability:GetTalentGain(0.4)
		self.str_spell_amp = self.ability:GetSpecialValueFor("str_spell_amp")*self.talentgain1
		self.chance = self.ability:GetSpecialValueFor("chance")*self.talentgain2
		self:StartIntervalThink(3)
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end

function modifier_heroTalent_npc_dota_hero_ogre_magi:OnIntervalThink()
	self.talentgain1 = self.ability:GetTalentGain(0.5)
	self.talentgain2 = self.ability:GetTalentGain(0.4)
	self.str_spell_amp = self.ability:GetSpecialValueFor("str_spell_amp")*self.talentgain1
	self.chance = self.ability:GetSpecialValueFor("chance")*self.talentgain2
end

function modifier_heroTalent_npc_dota_hero_ogre_magi:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, 
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_ogre_magi:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_BONUS,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_ogre_magi:AdvancedGetModifierManaBonus()
	return self.parent:GetStrength()*self.str_mana
end
function modifier_heroTalent_npc_dota_hero_ogre_magi:AdvancedGetModifierConstantManaRegen()
	return self.parent:GetStrength()*self.str_mana_regen
end
function modifier_heroTalent_npc_dota_hero_ogre_magi:Advanced_GetModifierSpellAmplifyBonus()
	return math.floor(self.parent:GetStrength()/10)*self.str_spell_amp
end
function modifier_heroTalent_npc_dota_hero_ogre_magi:Advanced_GetModifierBonusStats_Intellect()
	if self.flag then return end
	
	self.flag = true
	local int_change = self.parent:GetIntellect(false) - self.int_limit
	self.flag = false
	return -int_change
end

function modifier_heroTalent_npc_dota_hero_ogre_magi:OnTooltip(keys)
	self.talentgain1 = self.ability:GetTalentGain(0.5)
	self.talentgain2 = self.ability:GetTalentGain(0.4)
	self.str_spell_amp = self.ability:GetSpecialValueFor("str_spell_amp")*self.talentgain1
	self.chance = self.ability:GetSpecialValueFor("chance")*self.talentgain2
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.str_spell_amp
	elseif self._tooltip == 2 then
		return self.chance
	end
end
function modifier_heroTalent_npc_dota_hero_ogre_magi:AddCustomTransmitterData( )
	return
	{
		str_spell_amp = self.str_spell_amp,
		chance = self.chance,
	}
end
function modifier_heroTalent_npc_dota_hero_ogre_magi:HandleCustomTransmitterData( data )
	self.str_spell_amp = data.str_spell_amp
	self.chance = data.chance
end
function modifier_heroTalent_npc_dota_hero_ogre_magi:OnAbilityFullyCast(keys)
	if IsServer() then
		local chance = self.chance
		local random = math.random
		local ability_used = keys.ability
		if keys.unit ~= self.parent then return end
		if not ability_used:IsRefreshable() then return end
		
		if (not ability_used:IsCooldownReady()) and chance >= random(1,100) then
			if not ability_used then return end
	
			ability_used:EndCooldown()

			local p_name = "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf"
			local nFXIndex = ParticleManager:CreateParticle( p_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.x1")
		end
	end
end
