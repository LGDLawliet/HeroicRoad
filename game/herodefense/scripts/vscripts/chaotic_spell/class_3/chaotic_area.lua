chaotic_area = class({})

LinkLuaModifier("modifier_chaotic_area_thinker", "chaotic_spell/class_3/chaotic_area", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_area_buff", "chaotic_spell/class_3/chaotic_area", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_area_debuff", "chaotic_spell/class_3/chaotic_area", LUA_MODIFIER_MOTION_NONE)

function chaotic_area:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_area/effect/effect.vpcf", context )
end


function chaotic_area:OnSpellStart()

	local caster = self:GetCaster()
	local casterPos = caster:GetAbsOrigin()
	local duration = self:GetSpecialValueFor("duration")
	if IsValid(self.thinker) then
		self.thinker:Destroy()
	end

	local thinker = CreateModifierThinker(
		caster, 
		self, 
		"modifier_chaotic_area_thinker",
		{duration = duration},
		casterPos,
		caster:GetTeamNumber(),
		false
	)
	self.thinker  = thinker:FindModifierByName("modifier_chaotic_area_thinker")
end


modifier_chaotic_area_thinker = advanced_modifier({})
function modifier_chaotic_area_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.radius =self:GetAbility():GetSpecialValueFor("radius")
	self:PlayEffects(self.caster:GetAbsOrigin())
end

function modifier_chaotic_area_thinker:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.radius =self:GetAbility():GetSpecialValueFor("radius")
	self:PlayEffects(self.caster:GetAbsOrigin())
end

function modifier_chaotic_area_thinker:OnDestroy()
	if not IsServer() then return end
	if self.thinkerParticle then
		ParticleManager:DestroyParticle( self.thinkerParticle,true)
	end
	if self.ability.thinker then
		self.ability.thinker = nil
	end
	UTIL_Remove( self:GetParent() )
end


function modifier_chaotic_area_thinker:IsAura()	return true end
function modifier_chaotic_area_thinker:GetModifierAura()
	return "modifier_chaotic_area_debuff" 
end
function modifier_chaotic_area_thinker:GetAuraRadius()	return self.radius end
function modifier_chaotic_area_thinker:GetAuraDuration()	return 0.03 end
function modifier_chaotic_area_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_chaotic_area_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_chaotic_area_thinker:GetAuraEntityReject(hEntity)
	if hEntity == self:GetCaster() then
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_chaotic_area_buff",{duration = 0.06})
		return true
	end
	if hEntity:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	return false
end

function modifier_chaotic_area_thinker:PlayEffects( loc )
	if not IsServer() then
		return
	end
	self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_area/effect/effect.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
	ParticleManager:SetParticleControl( self.particle, 0,self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl( self.particle, 1,Vector(self.radius,self.radius,self.radius) )
	self:AddParticle(self.particle, false, false, -1, false, false)
	local sound_location = "Hero_Grimstroke.InkSwell.Target"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end

modifier_chaotic_area_buff = advanced_modifier({})
function modifier_chaotic_area_buff:IsHidden()	return false end
function modifier_chaotic_area_buff:IsDebuff()	return false end
function modifier_chaotic_area_buff:IsPurgable()	return false end

function modifier_chaotic_area_buff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.miss = self.ability:GetSpecialValueFor("miss")
end

function modifier_chaotic_area_buff:OnRefresh()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.miss = self.ability:GetSpecialValueFor("miss")
end

function modifier_chaotic_area_buff:OnDestroy()
	if IsServer() then
		if IsValid(self.ability) and  IsValid(self.ability.thinker) then
			if self.ability:GetRuneType()==1 then
				return
			end
			self.ability.thinker:Destroy()
		end
	end
end

function modifier_chaotic_area_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_chaotic_area_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then 
		return 0 
	end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then
		return 0
	end
	if self.miss >= RandomInt(1, 100) then
		return -100
	end
	return 0
end

function modifier_chaotic_area_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_area_buff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.miss
	end

end

modifier_chaotic_area_debuff = advanced_modifier({})
function modifier_chaotic_area_debuff:IsHidden()	return false end
function modifier_chaotic_area_debuff:IsDebuff()	return true end
function modifier_chaotic_area_debuff:IsPurgable()	return false end

function modifier_chaotic_area_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
end

function modifier_chaotic_area_debuff:OnRefresh()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
end

function modifier_chaotic_area_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_chaotic_area_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then 
		return 0 
	end
	if keys.attacker ~= self.caster then
		return 0
	end
	return self.bonus_damage
end

function modifier_chaotic_area_debuff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_area_debuff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.bonus_damage
	end

end