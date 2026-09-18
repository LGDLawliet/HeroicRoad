
Primary_Malefice = class({})

LinkLuaModifier("modifier_Primary_Malefice", "skills/Primary_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)



function Primary_Malefice:IsHiddenWhenStolen() 		return false end
function Primary_Malefice:IsRefreshable() 			return true  end
function Primary_Malefice:IsStealable() 			return true  end
function Primary_Malefice:IsNetherWardStealable() 	return true end
function Primary_Malefice:SetPos(pos) 	
	self.pos = pos
end
function Primary_Malefice:GetPos() 	
	return self.pos
end

function Primary_Malefice:GetAOERadius()
	
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_enigma") then
		return  self:GetSpecialValueFor("effect_radius")+200
	end
	return self:GetSpecialValueFor("effect_radius") 
end

function Primary_Malefice:GetCooldown(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_enigma")
		if modifier then
			return 20 - modifier:GetSpecialValueFor("cd_reduce")
		end
		return 20
	end
end
function Primary_Malefice:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(caster, self, "modifier_Primary_Malefice", {duration = self:GetSpecialValueFor("total_duration")})
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Enigma.Malefice", target)
end

modifier_Primary_Malefice = advanced_modifier({})

function modifier_Primary_Malefice:IsDebuff()			return true end
function modifier_Primary_Malefice:IsHidden() 			return false end
function modifier_Primary_Malefice:IsPurgable() 		return true end
function modifier_Primary_Malefice:IsPurgeException() 	return true end
function modifier_Primary_Malefice:GetStatusEffectName() return "particles/status_fx/status_effect_enigma_malefice.vpcf" end
function modifier_Primary_Malefice:StatusEffectPriority() return 15 end
function modifier_Primary_Malefice:GetEffectName() return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf" end
function modifier_Primary_Malefice:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_Malefice:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("effect_interval"))
		self:OnIntervalThink()
	end
end

function modifier_Primary_Malefice:OnIntervalThink()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local ability_talent = caster:FindAbilityByName("heroTalent_npc_dota_hero_enigma")
	local radius = ability:GetSpecialValueFor("effect_radius")
	if ability_talent then
		radius = ability:GetSpecialValueFor("effect_radius") + ability_talent:GetSpecialValueFor("radius")
	end

	local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * ability:GetSpecialValueFor( "intelligence_index" )
	local damage_type = ability:GetAbilityDamageType()
	if ability_talent then
		damage = (ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * ability:GetSpecialValueFor( "intelligence_index" ))*(1+ability_talent:GetSpecialValueFor("damage")*0.01)
	end

	for i=1, #enemy do
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance =  enemy[i]:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
		enemy[i]:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")*StatusResistance})
		local damageTable = {
							victim = enemy[i],
							attacker = caster,
							damage = damage,
							damage_type = damage_type,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		if not target:IsAlive() and not self:GetAbility():IsCooldownReady() then
			local time = self:GetAbility():GetSpecialValueFor("cd_reduce")
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - time
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
		enemy[i]:EmitSound("Hero_Enigma.MaleficeTick")	
	end


	local hole_pfx = "particles/rebuild/spell/malefice/active.vpcf"
	local pos = self:GetParent():GetAbsOrigin()
	self.pos = pos
	self:GetAbility():SetPos(pos)
	pos.z = pos.z + 100
	local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	self:AddParticle(pfx, false, false, 15, false, false)
end

function modifier_Primary_Malefice:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_Primary_Malefice:OnDeath(keys)
	if IsServer() then
		if not self:GetAbility():IsCooldownReady() then
			local time = self:GetAbility():GetSpecialValueFor("cd_reduce")
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - time
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
	end
end
