LinkLuaModifier( "modifier_chaotic_ass_heal_auto", "chaotic_spell/class_1/chaotic_ass_heal.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_ass_heal = class({})

function chaotic_ass_heal:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context )
end
function chaotic_ass_heal:GetIntrinsicModifierName()
	return "modifier_chaotic_ass_heal_auto"
end
function chaotic_ass_heal:GetManaCost()
	return self:GetCaster():GetMaxMana()*self:GetSpecialValueFor("mana_cost")*0.01
end
function chaotic_ass_heal:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") + self:GetCaster():GetCastRangeBonus()
end
function chaotic_ass_heal:OnSpellStart()
	local target = self:GetCursorTarget()
	self:HealForUnit(target)
end
function chaotic_ass_heal:HealForUnit(unit)
	if not IsServer() then return end
	if not unit or not unit:IsAlive() then return end

	if not self.count then
		self.count = 1
	else
		self.count = self.count + 1
	end
	if self.count >= self:GetSpecialValueFor("count") then
		self.count = 0
		unit:Purge(false, true, false, false, false)
	end

	local caster = self:GetCaster()
	local heal = self:GetSpecialValueFor("heal") + self:GetSpecialValueFor("bonus_heal")*caster:HDGetPrimaryStatValue()
	local healing = HealWithGain(heal,caster,unit,self)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)

	local particle_aoe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(particle_aoe_fx, 0, unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(200, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)    
end
---------------------------------------------------------------------
modifier_chaotic_ass_heal_auto = advanced_modifier({})

function modifier_chaotic_ass_heal_auto:IsHidden()		return true end
function modifier_chaotic_ass_heal_auto:IsPurgable()	return false end
function modifier_chaotic_ass_heal_auto:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_chaotic_ass_heal_auto:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability and self:GetParent():IsAlive() and caster:GetCurrentActiveAbility()==nil and not caster:IsChanneling() then
		if ability:IsCooldownReady() and ability:GetAutoCastState() then
			local unit = FinDLowestHealthPerHeroInRange_includeself(caster,ability:GetCastRange())
			if unit then
				caster:CastAbilityOnTarget(unit, ability, caster:GetPlayerOwnerID())
			end
		end
	end
end