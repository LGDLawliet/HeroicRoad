
chaotic_ray_of_sickness = class({})
LinkLuaModifier("modifier_chaotic_ray_of_sickness", "chaotic_spell/class_1/chaotic_ray_of_sickness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_ray_of_sickness_debuff", "chaotic_spell/class_1/chaotic_ray_of_sickness", LUA_MODIFIER_MOTION_NONE)

function chaotic_ray_of_sickness:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ray_of_sickness/effect_cast/effect.vpcf", context )

end

function chaotic_ray_of_sickness:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end
	if self:GetRuneType()==2 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return self.BaseClass.GetBehavior(self)
end

function chaotic_ray_of_sickness:GetAOERadius()
	if self:GetRuneType()==1 then
		return  self:GetSpecialValueFor("rune_1_radius")
	end
	if self:GetRuneType()==2 then
		return  self:GetSpecialValueFor("rune_2_radius")
	end
	return 0
end

function chaotic_ray_of_sickness:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	if target:TriggerSpellAbsorb(self) then
		return
	end
	self:PlayEffect(target)
	   

	local type = self:GetRuneType()
	if type==1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local count = self:GetSpecialValueFor("rune_1_bouns_count")
		for index, unit in ipairs(enemies) do
			if unit~=target then
				count = count - 1
				self:PlayEffect(unit)
				if count<=0 then
					break
				end
			end
		end
	end
end

function chaotic_ray_of_sickness:PlayEffect(target)
	EmitSoundOn("chaotic_ray_of_sickness_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ray_of_sickness/effect_cast/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(head_particle)

	local gain = self:GetEffectGain()
	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage*gain,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	if self:GetRuneType()==3 then
		damageTable.damage = damage*gain*(1+self:GetSpecialValueFor( "rune_3_bonus_damage" )*0.01)
	end
	ApplyDamage(damageTable)
	if IsValid(target) and target:IsAlive() then
		local poison = self:GetSpecialValueFor( "poison_apply" ) + self:GetSpecialValueFor( "bonus_poison_apply" )*self:GetCaster():HDGetPrimaryStatValue()
		target:Poison(self:GetCaster(), self, poison*gain)
	end

	if self:GetRuneType()==2 then
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local count = self:GetSpecialValueFor("rune_2_bonus_count")
		local cleave = self:GetSpecialValueFor("rune_2_cleave")*0.01
		for index, unit in ipairs(enemies) do
			if unit~=target then
				count = count - 1
				damageTable.victim = unit
				damageTable.damage = damage*gain*cleave
				ApplyDamage(damageTable)
				if count<=0 then
					break
				end
			end
		end
	end
end


function chaotic_ray_of_sickness:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	if self:GetRuneType()==3 then
		cost = cost * (1+self:GetSpecialValueFor("rune_3_bonus_cost")*0.01) 
	end
	cost = cost * self:GetManaCostGain()
	return cost
end


