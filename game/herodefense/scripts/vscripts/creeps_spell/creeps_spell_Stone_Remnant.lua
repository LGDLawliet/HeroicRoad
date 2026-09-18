LinkLuaModifier("modifier_creeps_spell_Stone_Remnant", "creeps_spell/creeps_spell_Stone_Remnant", LUA_MODIFIER_MOTION_NONE)

--Abilities
if creeps_spell_Stone_Remnant == nil then
	creeps_spell_Stone_Remnant = class({})
end
function creeps_spell_Stone_Remnant:IsStealable()return false end

function creeps_spell_Stone_Remnant:CastFilterResultTarget(hTarget)
	if hTarget == self:GetCaster() then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM
end


function creeps_spell_Stone_Remnant:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	local fDuration = self:GetSpecialValueFor("duration")

	local hStone = CreateUnitByName("npc_dota_earth_spirit_stone", vPoint + RandomVector(1), true, nil, nil, hCaster:GetTeamNumber())
	hStone:AddNewModifier(hCaster, self, "modifier_creeps_spell_Stone_Remnant", { duration = fDuration })

end

function creeps_spell_Stone_Remnant:OnInit()
	if self:GetLevel() < 1 then
		self:UpgradeAbility(false)
	end
end

---------------------------------------------------------------------
-- Modifiers
if modifier_creeps_spell_Stone_Remnant == nil then
	modifier_creeps_spell_Stone_Remnant = class({})
end
function modifier_creeps_spell_Stone_Remnant:IsHidden()return true end
function modifier_creeps_spell_Stone_Remnant:IsPurgable()return false end
function modifier_creeps_spell_Stone_Remnant:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = self:GetParent():IsHero(),
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end

function modifier_creeps_spell_Stone_Remnant:OnCreated(params)
	if not IsServer() then
		return
	end

	local hParent = self:GetParent()

	if not hParent:IsHero() then
		local sParticleName = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_earth_spirit/espirit_stoneremnant.vpcf", self:GetCaster())
		local iParticle = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticle, 1, hParent:GetOrigin())
		self:AddParticle(iParticle, false, false, 0, false, false)
		hParent:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact")

	else
		local sParticleName = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_earth_spirit/earthspirit_petrify_debuff_stoned.vpcf", self:GetCaster())
		local iParticle = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticle, false, false, 10, false, false)
		hParent:EmitSound("Hero_EarthSpirit.Petrify")

	end
end
function modifier_creeps_spell_Stone_Remnant:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:EmitSound("Hero_EarthSpirit.StoneRemnant.Destroy")
		if IsValid(hParent) and not hParent:IsHero() then
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_creeps_spell_Stone_Remnant:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end
function modifier_creeps_spell_Stone_Remnant:GetModifierProvidesFOWVision(params)
	return 1
end
