
Primary_Midnight_Pulse = class({})

LinkLuaModifier("modifier_Primary_Midnight_Pulse_thinker", "skills/Primary_Midnight_Pulse", LUA_MODIFIER_MOTION_NONE)


function Primary_Midnight_Pulse:IsHiddenWhenStolen() 	return false end
function Primary_Midnight_Pulse:IsRefreshable() 		return false  end
function Primary_Midnight_Pulse:IsStealable() 			return true  end
function Primary_Midnight_Pulse:IsNetherWardStealable() return true end

function Primary_Midnight_Pulse:GetAOERadius() return self:GetSpecialValueFor("radius") end


function Primary_Midnight_Pulse:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_Primary_Midnight_Pulse_thinker", {duration = self:GetSpecialValueFor('duration')}, pos, caster:GetTeamNumber(), false)
end

modifier_Primary_Midnight_Pulse_thinker = class({})

function modifier_Primary_Midnight_Pulse_thinker:RemoveOnDeath() return true end

function modifier_Primary_Midnight_Pulse_thinker:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()

		--上值为当前的伤害倍数
		self:GetParent():EmitSound("Hero_Enigma.Midnight_Pulse")
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetAOERadius(), false)
		self:StartIntervalThink(0.25)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetAbility():GetAOERadius(), self:GetAbility():GetAOERadius(), self:GetAbility():GetAOERadius()))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.count = 0
	end
end
function modifier_Primary_Midnight_Pulse_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

function modifier_Primary_Midnight_Pulse_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	self.count = self.count + 1
	
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, ability:GetAOERadius(),
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	   DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	

	local damage = ability:GetSpecialValueFor("basic_damage") +  caster:GetIntellect(false) * ability:GetSpecialValueFor("intelligence_index")
	for i=1, #enemy do
		if self.count >= 4 then

			local damageTable = {
								victim = enemy[i],
								attacker = self:GetCaster(),
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
		end
		if i>=10 then
			break
		end
	end
	if self.count >=4 then
		self.count = 0
	end

end
