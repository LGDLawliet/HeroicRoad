
chaotic_high_fighting_spirit = class({})


LinkLuaModifier("modifier_chaotic_high_fighting_spirit", "chaotic_spell/class_5/chaotic_high_fighting_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_high_fighting_spirit_summon_buff", "chaotic_spell/class_5/chaotic_high_fighting_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_high_fighting_spirit_passive", "chaotic_spell/class_5/chaotic_high_fighting_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_high_fighting_spirit_buff", "chaotic_spell/class_5/chaotic_high_fighting_spirit", LUA_MODIFIER_MOTION_NONE)


function chaotic_high_fighting_spirit:GetIntrinsicModifierName() return "modifier_chaotic_high_fighting_spirit" end
function chaotic_high_fighting_spirit:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_high_fighting_spirit/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_high_fighting_spirit/effect_buff.vpcf", context )
end




modifier_chaotic_high_fighting_spirit= class({})

function modifier_chaotic_high_fighting_spirit:IsDebuff()			return false end
function modifier_chaotic_high_fighting_spirit:IsHidden() 			return true end
function modifier_chaotic_high_fighting_spirit:IsPurgable() 		return false end
function modifier_chaotic_high_fighting_spirit:IsPurgeException() 	return false end


function modifier_chaotic_high_fighting_spirit:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local gain =  self:GetCaster():GetModifierDurationGainIndex(1)
		local duration = self:GetAbility():GetSpecialValueFor("duration")*gain
		
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaotic_high_fighting_spirit_summon_buff", {duration = duration})
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaotic_high_fighting_spirit_passive", {})
		unit:EmitSound("Hero_Enigma.Malefice")
	end
end



modifier_chaotic_high_fighting_spirit_summon_buff = advanced_modifier({})

function modifier_chaotic_high_fighting_spirit_summon_buff:IsDebuff() return false end
function modifier_chaotic_high_fighting_spirit_summon_buff:IsHidden() return false end
function modifier_chaotic_high_fighting_spirit_summon_buff:IsPurgable() return false end
function modifier_chaotic_high_fighting_spirit_summon_buff:IsPurgeException() return false end
function modifier_chaotic_high_fighting_spirit_summon_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	local gain =  self.ability:GetEffectGain()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")*gain
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")*gain
	if IsServer() then
		local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_high_fighting_spirit/effect_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 4, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, true, false, -1, false, false)
	end
end
function modifier_chaotic_high_fighting_spirit_summon_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_chaotic_high_fighting_spirit_summon_buff:Advanced_GetModifierPhysicalArmorBonus()	return self.bonus_armor * self:GetRemainingTime() / self:GetDuration() end
function modifier_chaotic_high_fighting_spirit_summon_buff:Advanced_GetModifierAttackSpeedPercentage()	return self.bonus_attack_speed * self:GetRemainingTime() / self:GetDuration() end

function modifier_chaotic_high_fighting_spirit_summon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_chaotic_high_fighting_spirit_summon_buff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()
	end
	if self._tooltip == 2 then
		return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end

modifier_chaotic_high_fighting_spirit_passive = advanced_modifier({})

function modifier_chaotic_high_fighting_spirit_passive:IsDebuff() return false end
function modifier_chaotic_high_fighting_spirit_passive:IsHidden() return true end
function modifier_chaotic_high_fighting_spirit_passive:IsPurgable() return false end
function modifier_chaotic_high_fighting_spirit_passive:IsPurgeException() return false end
function modifier_chaotic_high_fighting_spirit_passive:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.buff_duration = self.ability:GetSpecialValueFor("buff_duration")
end

function modifier_chaotic_high_fighting_spirit_passive:OnDestroy(keys)

	if not IsServer() then
		return
	end
	if IsValid(self.ability) then
		local gain =  self:GetCaster():GetModifierDurationGainIndex(1)
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_chaotic_high_fighting_spirit_buff", {duration = self.buff_duration*gain})
	end
	
end



modifier_chaotic_high_fighting_spirit_buff = advanced_modifier({})

function modifier_chaotic_high_fighting_spirit_buff:IsDebuff() return false end
function modifier_chaotic_high_fighting_spirit_buff:IsHidden() return false end
function modifier_chaotic_high_fighting_spirit_buff:IsPurgable() return false end
function modifier_chaotic_high_fighting_spirit_buff:IsPurgeException() return false end
function modifier_chaotic_high_fighting_spirit_buff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_attack_damage = self.ability:GetSpecialValueFor("bonus_attack_damage")
	self.max_stack = math.floor(self.ability:GetSpecialValueFor("max_stack"))

	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_high_fighting_spirit/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, true, false, -1, false, false)
		self:StartIntervalThink(0.1)
	end

end
function modifier_chaotic_high_fighting_spirit_buff:OnRefresh()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_attack_damage = self.ability:GetSpecialValueFor("bonus_attack_damage")
	self.max_stack = math.floor(self.ability:GetSpecialValueFor("max_stack"))

	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount() >= self.max_stack then
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })
		else
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end

end
function modifier_chaotic_high_fighting_spirit_buff:OnIntervalThink()
	if IsClient() then
		return
	end
	local fGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].dieTime then
			table.remove(self.tData, i)
			self:DecrementStackCount()
		end
	end
end
function modifier_chaotic_high_fighting_spirit_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,

    }
end
function modifier_chaotic_high_fighting_spirit_buff:Advanced_GetModifierBaseAttack_BonusDamage()
	return self.bonus_attack_damage * self:GetStackCount()
end

function modifier_chaotic_high_fighting_spirit_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_chaotic_high_fighting_spirit_buff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBaseAttack_BonusDamage()
	end
end
