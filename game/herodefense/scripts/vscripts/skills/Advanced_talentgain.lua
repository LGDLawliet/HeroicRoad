LinkLuaModifier( "modifier_Advanced_talentgain", "skills/Advanced_talentgain.lua", LUA_MODIFIER_MOTION_NONE )

Advanced_talentgain = class({})

function Advanced_talentgain:GetIntrinsicModifierName()
	return "modifier_Advanced_talentgain"
end

function Advanced_talentgain:CheckKV(key)
	local table = {
		profic = 1,
		atb = 1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_talentgain:UnlockFirstCore(key)
	return true
end
function Advanced_talentgain:UnlockSecondCore(key)
	local caster = self:GetCaster()
	local item = caster:FindItemInInventory("item_hd_third_eye")
	if item then
		for i=1, math.random(1,4) do
			caster:AddItemByName("item_hd_enhancement_wise")
		end
	end
	return true
end
function Advanced_talentgain:UnlockThirdCore(key)
	return true
end
function Advanced_talentgain:OnAdvancedUpgrade()
	if self.advanced_level==25 or self.advanced_level==26 then
		local caster = self:GetCaster()
		caster:AddItemByName("item_hd_enhancement_wise")
	end
end
modifier_Advanced_talentgain = advanced_modifier({})

function modifier_Advanced_talentgain:IsDebuff() 	return false end
function modifier_Advanced_talentgain:IsHidden() 	return true end
function modifier_Advanced_talentgain:IsPurgable() 		return false end
function modifier_Advanced_talentgain:IsPurgeException() 	return false end
function modifier_Advanced_talentgain:RemoveOnDeath() 	return false end
function modifier_Advanced_talentgain:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.atb = self.ability:GetSpecialValueFor("atb")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.bonus = self.ability:GetSpecialValueFor("bonus")*0.01
	self.final_profic = self.profic

	--这类纯被动技能需要用think去网表里面拿值
	local NetTable_key = tostring(self.parent:GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_talentgain:OnRefresh()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.atb = self.ability:GetSpecialValueFor("atb")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.bonus = self.ability:GetSpecialValueFor("bonus")*0.01
	self.final_profic = self.profic

	--这类纯被动技能需要用think去网表里面拿值
	local NetTable_key = tostring(self.parent:GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
end

function modifier_Advanced_talentgain:OnIntervalThink()
	--这类纯被动技能需要用think去网表里面拿值
	local NetTable_key = tostring(self.parent:GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level


	local chance = self.chance
	if self.advanced_level >= 15 then
		chance = 25
		if self.on_wave_start then
			chance = 50
		end
	end
	if self.ability:GetUnlock(1)==1 then
		chance = 80
		if self.on_wave_start then
			chance = 100
		end
	end

	self.final_profic = self.profic
	if chance >= math.random(1,100) then
		self.final_profic = self.profic * (1+self.bonus)
	end
end

function modifier_Advanced_talentgain:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN_MUL,

		MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
		MODIFIER_EVENT_ON_Wave_Start = {},
	}
end
function modifier_Advanced_talentgain:Advanced_GetModifier_TalentEffectGain()
	return self.final_profic
end
function modifier_Advanced_talentgain:Advanced_GetModifierBonusStats_Strength()
	return self.atb
end
function modifier_Advanced_talentgain:Advanced_GetModifierBonusStats_Agility()
	return self.atb
end
function modifier_Advanced_talentgain:Advanced_GetModifierBonusStats_Intellect()
	return self.atb
end
function modifier_Advanced_talentgain:Advanced_GetModifier_TalentEffectGain_Mul()
	if self.ability:GetUnlock(3)==3 then
		return 10 + self.parent:GetLevel()
	end

	if self.advanced_level >= 10 then
		return 10
	end
end
function modifier_Advanced_talentgain:OnWaveStart()
	if not IsServer() then return end
	if Game_State:IsInChaoticEra() then return end
	if self.advanced_level >= 15 then
		self.on_wave_start = true
		self:GetParent():GameTimer(30,function()
			self.on_wave_start = false
		end)
	end
end
function modifier_Advanced_talentgain:OnChaoticEraRoundChange(keys)
	if not IsServer() then return end
	if not Game_State:IsInChaoticEra() then return end
	if self.advanced_level >= 15 then
		self.on_wave_start = true
		self:GetParent():GameTimer(30,function()
			self.on_wave_start = false
		end)
	end
end

function modifier_Advanced_talentgain:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return 0 end
	local ability = keys.inflictor
	if self.advanced_level >= 5 then
		if ability and string.find(ability:GetAbilityName(), "heroTalent_npc_dota_hero_") then
			return 20
		end
		return 8
	else
		if ability and string.find(ability:GetAbilityName(), "heroTalent_npc_dota_hero_") then
			return self.outgoing
		end
	end
end