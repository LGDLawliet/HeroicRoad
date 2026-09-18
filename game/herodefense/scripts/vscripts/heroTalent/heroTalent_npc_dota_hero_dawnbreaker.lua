heroTalent_npc_dota_hero_dawnbreaker = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dawnbreaker", "heroTalent/heroTalent_npc_dota_hero_dawnbreaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dawnbreaker_buff", "heroTalent/heroTalent_npc_dota_hero_dawnbreaker", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_dawnbreaker:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dawnbreaker"
end



modifier_heroTalent_npc_dota_hero_dawnbreaker = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dawnbreaker:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.atk_need = self.ability:GetSpecialValueFor("count")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.regen = self.ability:GetSpecialValueFor("regen")
	self.bonus_regen = self.ability:GetSpecialValueFor("bonus_regen")
	self.heal = self.ability:GetSpecialValueFor("heal")
	self:SetStackCount(0)

	self.talentgain = self.ability:GetTalentGain(0.6)
	self.regen_t = self.regen * self.talentgain
	self.bonus_regen_t = self.bonus_regen * self.talentgain
	self.heal_t = self.heal * self.talentgain
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	if attacker ~= self.parent then return end
	if not attacker:IsAlive() then return end
	
	self:SetStackCount(self:GetStackCount()+1)
	if self:GetStackCount() >= self.atk_need then
		self:SetStackCount(0)

		self:HPRegen(attacker)
		local unit = FinDLowestHealthPerAllyHeroInRange(self.parent, self.radius)
		if unit then
			self:HPRegen(unit)
		end
		
		local gain = attacker:GetModifierDurationGainIndex(0.4)
		local duration = self.duration*gain
		attacker:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_dawnbreaker_buff", {duration = duration})
	end
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:HPRegen(unit)
	if not IsServer() then return end
	if not unit or not unit:IsAlive() then return end

	self.talentgain = self.ability:GetTalentGain(0.6)
	self.regen_t = self.regen * self.talentgain
	self.bonus_regen_t = self.bonus_regen * self.talentgain

	local heal = self.regen_t + self.bonus_regen_t*self.parent:GetStrength()
	local healing = HealWithGain(heal, self.parent, unit, self.ability)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil) 
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:PlayEffects(target, ally)
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity.vpcf"
	local sound_target = "Hero_Dawnbreaker.Luminosity.Heal"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, ally)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effect_cast, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast)

	EmitSoundOn( sound_target, ally )
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.regen_t = self.regen * self.talentgain
	self.bonus_regen_t = self.bonus_regen * self.talentgain
	self.heal_t = self.heal * self.talentgain
	local regen = self.regen_t + self.bonus_regen_t*self.parent:GetStrength()
	
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return regen
    end
    if self._tooltip == 2 then
        return self.heal_t
    end
end

--------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_dawnbreaker_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.line = self.ability:GetSpecialValueFor("line")
	self.heal = self.ability:GetSpecialValueFor("heal")*0.01

	self.talentgain = self.ability:GetTalentGain(0.6)
	self.heal_t = self.heal * self.talentgain
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		--当叠加乘数没达到最高时
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, 
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}, 
    }
	return funcs
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:Advanced_GetModifierAttackSpeedPercentage()	return self:GetStackCount()*self.attack_speed end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:Advanced_GetModifierIncomingDamage_Percentage()	return -math.min(self:GetStackCount()*self.incoming, 60) end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:GetActivityTranslationModifiers()
	if self:GetStackCount() >= self.line then
		if not self.nohammer then
			local hammer = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
			if hammer ~= nil then
				hammer:AddEffects( EF_NODRAW )
			end
			self.nohammer =true
		end
		return "no_hammer"
	end
	if self.nohammer then
		local hammer = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hammer ~= nil then
			hammer:RemoveEffects( EF_NODRAW )
		end
		self.nohammer =false
	end
	return ""
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	if attacker ~= self.parent then return end
	if not attacker:IsAlive() then return end
	if self:GetStackCount() < self.line then return end
	
	self:LightHeal(attacker)
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:LightHeal(unit)
	if not IsServer() then return end
	if not unit then return end
	
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.heal_t = self.heal * self.talentgain
	local losthp = unit:GetMaxHealth() - unit:GetHealth()
	local healing = losthp*self.heal_t
	if healing > 0 then
		unit:Heal(healing, self.ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
	end
end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierAttackSpeedPercentage()
    end
	if self._tooltip == 2 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
	end
end




