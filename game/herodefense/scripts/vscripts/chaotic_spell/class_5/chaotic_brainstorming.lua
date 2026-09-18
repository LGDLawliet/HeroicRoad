LinkLuaModifier("modifier_chaotic_brainstorming", "chaotic_spell/class_5/chaotic_brainstorming", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_brainstorming_debuff", "chaotic_spell/class_5/chaotic_brainstorming", LUA_MODIFIER_MOTION_NONE)

chaotic_brainstorming = class({})
function chaotic_brainstorming:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_buff.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_damage.vpcf", context )
end

function chaotic_brainstorming:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function chaotic_brainstorming:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function chaotic_brainstorming:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end

function chaotic_brainstorming:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if self:GetToggleState() then
		if caster:HasModifier("modifier_chaotic_brainstorming_debuff") then
			self:ToggleAbility()
			self:SetActivated(false)
			return
		end
		caster:AddNewModifier(caster, self, "modifier_chaotic_brainstorming", {duration = -1})

	else

		local modifier = caster:FindModifierByName("modifier_chaotic_brainstorming")
		if modifier then
			if modifier.intellect_reduction_record <= 0 then
				modifier:SafeDestroy()
				caster:EmitSound("Hero_Mars.Spear.Cast")
			end
		end
	end
	
end

modifier_chaotic_brainstorming = advanced_modifier({})

function modifier_chaotic_brainstorming:IsHidden() return false end
function modifier_chaotic_brainstorming:IsPurgable() return false end
function modifier_chaotic_brainstorming:IsDebuff()
	if self:GetDuration() == self.duration then
		return true
	end
	return false 
end
function modifier_chaotic_brainstorming:GetTexture() return "bane/bane_fall20_immortal_ability_icon/bane_fall20_immortal_fiends_grip" end

function modifier_chaotic_brainstorming:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.crit_damage = self.ability:GetSpecialValueFor("crit_damage")
	self.intellect_reduction = self.ability:GetSpecialValueFor("intellect_reduction")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.intellect_reduction_record =  self.intellect_reduction
	self.pfx_debuff = nil
	-- self.time_require = 0
	self.crit = {}

	self:StartIntervalThink(0.1)

	self.interval = 1
	if self.ability:GetRuneType()==1 and self.ability:GetAutoCastState() then
		self.interval = self.interval * (1-self.ability:GetSpecialValueFor("rune_1_interval")*0.01)
		local gain = 1+0.01*self.ability:GetSpecialValueFor("rune_1_bonus")
		self.bonus_strength = self.bonus_strength * gain
		self.bonus_agility = self.bonus_agility * gain
		self.crit_damage = (self.crit_damage-100)*gain+100
	end
	self.timer =  GameRules:GetGameTime()

	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_buff.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		self:AddParticle(self.pfx, false, false, -1, false, false)
	
		self.parent:EmitSound("Hero_Mars.Spear.Cast")
	end

end

function modifier_chaotic_brainstorming:OnRefresh()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.crit = {}
	self.intellect_reduction_record = self.intellect_reduction_record+ self.intellect_reduction

	if IsServer() then

		if self.pfx_debuff then
			ParticleManager:DestroyParticle(self.pfx_debuff, true)
			self.pfx_debuff = nil
		end
	
		if not self.pfx then
			self.pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_buff.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
			ParticleManager:SetParticleControlEnt(self.pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			self:AddParticle(self.pfx, false, false, -1, false, false)
		end

		self.parent:EmitSound("Hero_Mars.Spear.Cast")
	end
end

function modifier_chaotic_brainstorming:OnIntervalThink()

	if self:GetDuration() == self.duration then
		return
	end
	if GameRules:GetGameTime()>=self.timer then
		self.intellect_reduction_record = self.intellect_reduction_record + self.intellect_reduction
		self.timer = self.timer + self.interval

	end


	if IsServer() then
		if self.ability:GetToggleState() then
			if self.parent:GetIntellect(false) <= 0 then
				self:SafeDestroy()
				self.ability:ToggleAbility()
				self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_brainstorming_debuff", {})
			end
		else
			if self.intellect_reduction_record > 0 then
				self:SetDuration(self.duration, true)	
				if self.pfx then
					ParticleManager:DestroyParticle(self.pfx, true)
					self.pfx = nil
				end
				if not self.pfx_debuff then
					self.pfx_debuff = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_debuff.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
					ParticleManager:SetParticleControlEnt(self.pfx_debuff, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
					self:AddParticle(self.pfx_debuff, false, false, -1, false, false)
					self.parent:EmitSound("Hero_Lion.Hex.Fishstick")
				end		
			end
		end
	end
end

function modifier_chaotic_brainstorming:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if self.crit[keys.record] then

		local pfx_name = "particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_damage.vpcf"

		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
		ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		DestroyParticleByDelay(pfx,1)

        self.parent:EmitSound("Hero_Mars.Spear.Target")
	end
	self.crit[keys.record] = nil
end

function modifier_chaotic_brainstorming:OnAttackFail(keys) self.crit[keys.record] = nil end

function modifier_chaotic_brainstorming:OnAttackRecordDestroy(keys)
	if self.crit[keys.record] then
        self.crit[keys.record] = nil
    end
end

function modifier_chaotic_brainstorming:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_chaotic_brainstorming:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBonusStats_Strength()
	end
	if self._tooltip == 2 then
		return self:Advanced_GetModifierBonusStats_Agility()
	end
	if self._tooltip == 3 then
		if self:GetDuration() == self.duration then
			return 0
		end
		return 100
	end
	if self._tooltip == 4 then
		return self:Advanced_GetModifierBonusStats_Intellect()
	end

end

function modifier_chaotic_brainstorming:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_chaotic_brainstorming:Advanced_GetModifierCriticalStrike(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent then
		return
	end
	if keys.target:IsBuilding() then
		return
	end
	if keys.target:IsOther() then
		return
	end
	if self:GetDuration() == self.duration then
		return
	end
	self.crit[keys.record] = true
	return self.crit_damage
end

function modifier_chaotic_brainstorming:Advanced_GetModifierBonusStats_Strength()
	if self:GetDuration() == self.duration then
		return 0
	end
	return self.bonus_strength
end
function modifier_chaotic_brainstorming:Advanced_GetModifierBonusStats_Agility()	
	if self:GetDuration() == self.duration then
		return 0
	end
	return self.bonus_agility
end
function modifier_chaotic_brainstorming:Advanced_GetModifierBonusStats_Intellect()	
	return -self.intellect_reduction_record
end












modifier_chaotic_brainstorming_debuff = advanced_modifier({})

function modifier_chaotic_brainstorming_debuff:IsHidden() return false end
function modifier_chaotic_brainstorming_debuff:IsPurgable() return false end
function modifier_chaotic_brainstorming_debuff:IsDebuff() return true end
function modifier_chaotic_brainstorming_debuff:RemoveOnDeath()  return false end
function modifier_chaotic_brainstorming_debuff:GetTexture() return "bane/bane_fall20_immortal_ability_icon/bane_fall20_immortal_fiends_grip" end
function modifier_chaotic_brainstorming_debuff:RemoveOnSell() return false end
function modifier_chaotic_brainstorming_debuff:OnCreated()

	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.intellect_lose = self.ability:GetSpecialValueFor("intellect_lose")

	if IsServer() then
		self.pfx_debuff = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_brainstorming/effect_debuff.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.pfx_debuff, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		self:AddParticle(self.pfx_debuff, false, false, -1, false, false)
		self.parent:EmitSound("Hero_Lion.Hex.Fishstick")
	end
end

function modifier_chaotic_brainstorming_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	} 
end

function modifier_chaotic_brainstorming_debuff:OnTooltip() 

	return self:Advanced_GetModifierBonusStats_Intellect()

end

function modifier_chaotic_brainstorming_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_chaotic_brainstorming_debuff:Advanced_GetModifierBonusStats_Intellect()	
	return -self.intellect_lose
end