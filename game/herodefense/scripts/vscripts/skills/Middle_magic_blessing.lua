
LinkLuaModifier("modifier_Middle_magic_blessing_meditate", "skills/Middle_magic_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_magic_blessing", "skills/Middle_magic_blessing", LUA_MODIFIER_MOTION_NONE)

Middle_magic_blessing							= class({})


function Middle_magic_blessing:GetIntrinsicModifierName()
	return "modifier_Middle_magic_blessing_meditate"
end

function Middle_magic_blessing:ProcsMagicStick() return false end

function Middle_magic_blessing:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Middle_magic_blessing:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Middle_magic_blessing:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_KeeperOfTheLight.ManaLeak.Cast")
		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_magic_blessing", {})
	else
		self:GetCaster():EmitSound("Hero_Antimage.ManaBreak")

		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Middle_magic_blessing", self:GetCaster())
	end
	
end

-----------------------------------
-- MANA SHIELD MEDITATE MODIFIER --
-----------------------------------
modifier_Middle_magic_blessing_meditate		= advanced_modifier({})

function modifier_Middle_magic_blessing_meditate:IsHidden()	return true end
function modifier_Middle_magic_blessing_meditate:IsPurgable() 		return false end
function modifier_Middle_magic_blessing_meditate:IsPurgeException() 	return false end
function modifier_Middle_magic_blessing_meditate:RemoveOnDeath()  return false end
function modifier_Middle_magic_blessing_meditate:DeclareFunctions()
	local decFuncs = {	
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
    }

    return decFuncs
end
function modifier_Middle_magic_blessing_meditate:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Middle_magic_blessing_meditate:OnCreated(table)

	self.bonus_spell_damage_amplification = 0
	self.mana_regen = 0
	-- self.advanced_level = 1
	self:StartIntervalThink(1)
end
function modifier_Middle_magic_blessing_meditate:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.mana_regen = caster:GetIntellect(false)*0.1
	self.bonus_spell_damage_amplification = ability:GetSpecialValueFor("bonus_spell_damage_amplification")
end
-- function modifier_Middle_magic_blessing_meditate:GetModifierManaBonus()	return self.bonus_mana end
function modifier_Middle_magic_blessing_meditate:Advanced_GetModifierSpellAmplifyBonus()	return self:GetParent():PassivesDisabled() and 0 or  self.bonus_spell_damage_amplification end
function modifier_Middle_magic_blessing_meditate:GetModifierConstantManaRegen()	return self:GetParent():PassivesDisabled() and 0 or  self.mana_regen end
--------------------------
-- MANA SHIELD MODIFIER --
--------------------------
modifier_Middle_magic_blessing				= class({})


function modifier_Middle_magic_blessing:IsPurgable() 		return false end
function modifier_Middle_magic_blessing:RemoveOnDeath()	return false end

function modifier_Middle_magic_blessing:OnCreated(table)
	if IsClient() then
		return
	end
	self.mana_regen = 0
	self:StartIntervalThink(1)
end
function modifier_Middle_magic_blessing:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.mana_regen = caster:GetIntellect(false)*0.05
	if caster:GetHealth()<=0 then
		return
	end

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	table.remove(units,1)
	for _, unit in ipairs(units) do
		if unit:IsRealHero() then

			local mana_regen = unit:GetManaRegen()*0.5
			if mana_regen<=0 then
				return
			end

			local pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_magic_blessing.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			caster:GiveMana(mana_regen)
			unit:Script_ReduceMana(mana_regen,ability)

		end
	end




end