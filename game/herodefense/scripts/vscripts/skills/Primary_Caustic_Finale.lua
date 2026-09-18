
Primary_Caustic_Finale = class({})

LinkLuaModifier("modifier_Primary_Caustic_Finale_passive", "skills/Primary_Caustic_Finale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Caustic_Finale", "skills/Primary_Caustic_Finale", LUA_MODIFIER_MOTION_NONE)

function Primary_Caustic_Finale:GetIntrinsicModifierName() return "modifier_Primary_Caustic_Finale_passive" end
----------------------------
modifier_Primary_Caustic_Finale_passive = advanced_modifier({})

function modifier_Primary_Caustic_Finale_passive:IsDebuff()			return false end
function modifier_Primary_Caustic_Finale_passive:IsHidden() 			return true end
function modifier_Primary_Caustic_Finale_passive:IsPurgable() 			return false end
function modifier_Primary_Caustic_Finale_passive:IsPurgeException() 	return false end

function modifier_Primary_Caustic_Finale_passive:ADDeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}}
end
function modifier_Primary_Caustic_Finale_passive:OnCreated(table)
	self.each_cd = self:GetAbility():GetSpecialValueFor("each_cd")
	self.cd_line = self:GetAbility():GetSpecialValueFor("cd_line")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
function modifier_Primary_Caustic_Finale_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.damage <= 0 then
		return
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 
	end

	if not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and keys.attacker == self:GetParent()
	 and not keys.unit:IsBuilding() and not keys.unit:IsOther() and not keys.unit:IsCourier() and not keys.unit:HasModifier("modifier_Primary_Caustic_Finale") and
	  not keys.unit:IsMagicImmune() and IsEnemy(keys.attacker, keys.unit) then
		if keys.inflictor and (keys.inflictor:GetName() == "Primary_Caustic_Finale"  ) then --伤害来源不能是自己
			return
		end
		local ability =self:GetAbility()
		local cooldown = ability:GetCooldownTimeRemaining()
		if cooldown >= self.cd_line then
			return
		end
		if keys.unit:GetHealth() > 0 then
			keys.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Primary_Caustic_Finale", {duration = self.duration})
			ability:StartCooldown(cooldown + self.each_cd)
		end
	end
end
--------------------------------------------------------------------------
modifier_Primary_Caustic_Finale = advanced_modifier({})

function modifier_Primary_Caustic_Finale:IsDebuff()			return true end
function modifier_Primary_Caustic_Finale:IsHidden() 			return false end
function modifier_Primary_Caustic_Finale:IsPurgable() 			return false end
function modifier_Primary_Caustic_Finale:IsPurgeException() 	return false end
function modifier_Primary_Caustic_Finale:GetEffectName() return "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf" end
function modifier_Primary_Caustic_Finale:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_Caustic_Finale:OnCreated()
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self:StartIntervalThink(1)
	end
end

function modifier_Primary_Caustic_Finale:OnIntervalThink()
	if not self:GetParent() then
		return
	end
	local poison = self:GetAbility():GetSpecialValueFor("poison")*self:GetCaster():GetMaxHealth()*0.01
	self:GetParent():Poison(self:GetCaster(),self:GetAbility(),poison)
end

function modifier_Primary_Caustic_Finale:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_Primary_Caustic_Finale:OnDeath(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		local parent = self:GetParent()
		parent:EmitSound("Ability.SandKing_CausticFinale")
		local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetMaxHealth()*0.01
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local damageTable = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end