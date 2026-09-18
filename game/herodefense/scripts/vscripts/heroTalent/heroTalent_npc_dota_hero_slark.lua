heroTalent_npc_dota_hero_slark = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slark", "heroTalent/heroTalent_npc_dota_hero_slark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slark_buff", "heroTalent/heroTalent_npc_dota_hero_slark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slark_debuff", "heroTalent/heroTalent_npc_dota_hero_slark", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_slark:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_slark"
end


modifier_heroTalent_npc_dota_hero_slark = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_slark:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_slark:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_slark:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_slark:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_slark:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slark:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.duration = self.ability:GetSpecialValueFor("duration")

	self.agi_up = self.ability:GetSpecialValueFor("agi_up")
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.agi_up_t = self.agi_up*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_slark:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
end

function modifier_heroTalent_npc_dota_hero_slark:OnAttackLanded(params)
	if not IsServer() then return end

	local ability = self:GetAbility()
	local attacker = params.attacker
	local target = params.target
	if attacker ~= self.parent then return end

	local Gain = attacker:GetModifierDurationGainIndex(0.5)
	attacker:AddNewModifier(attacker, ability, "modifier_heroTalent_npc_dota_hero_slark_buff", {duration = self.duration*Gain})

	self:PlayEffects(target)
end

function modifier_heroTalent_npc_dota_hero_slark:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
function modifier_heroTalent_npc_dota_hero_slark:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_slark:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.agi_up_t = self.agi_up*self.talentgain
	return self.agi_up_t
end
----
modifier_heroTalent_npc_dota_hero_slark_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_slark_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_slark_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_slark_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_slark_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_slark_buff:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.45)
    self.agi_up_t = self.agi_up*self.talentgain
	return self:Advanced_GetModifierBonusStats_Agility()
end

function modifier_heroTalent_npc_dota_hero_slark_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_slark_buff:Advanced_GetModifierBonusStats_Agility()	return self:GetStackCount()*self.agi_up_t end

function modifier_heroTalent_npc_dota_hero_slark_buff:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.agi_up = self.ability:GetSpecialValueFor("agi_up")
	self.base_limit = self.ability:GetSpecialValueFor("base_limit")
	self.bonus_limit = self.ability:GetSpecialValueFor("bonus_limit")

	self.talentgain = self.ability:GetTalentGain(0.45)
    self.agi_up_t = self.agi_up*self.talentgain

	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_slark_buff:OnRefresh(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.agi_up = self.ability:GetSpecialValueFor("agi_up")
	self.base_limit = self.ability:GetSpecialValueFor("base_limit")
	self.bonus_limit = self.ability:GetSpecialValueFor("bonus_limit")

	self.talentgain = self.ability:GetTalentGain(0.45)
    self.agi_up_t = self.agi_up*self.talentgain

	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount() >= (self.base_limit + self.bonus_limit*self.parent:GetLevel()) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_slark_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end



