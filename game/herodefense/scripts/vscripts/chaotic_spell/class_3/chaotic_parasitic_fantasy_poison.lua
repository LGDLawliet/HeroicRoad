
chaotic_parasitic_fantasy_poison = class({})
LinkLuaModifier("modifier_chaotic_parasitic_fantasy_poison", "chaotic_spell/class_3/chaotic_parasitic_fantasy_poison", LUA_MODIFIER_MOTION_NONE)



function chaotic_parasitic_fantasy_poison:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_parasitic_fantasy_poison/chaotic_parasitic_fantasy_poison.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/modifier_chaotic_parasitic_fantasy_poison/modifier_chaotic_parasitic_fantasy_poison14_imps.vpcf", context )

end

function chaotic_parasitic_fantasy_poison:GetBehavior()
	if self:GetRuneType() == 3 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return self.BaseClass.GetBehavior( self )
end

function chaotic_parasitic_fantasy_poison:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_parasitic_fantasy_poison:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		-- cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
		local bonus_cost = self:GetSpecialValueFor("extra_mana_cost")*0.01
		if self:GetRuneType()==1 then
			bonus_cost = bonus_cost * (100-self:GetSpecialValueFor("rune_1_cost_reduce"))*0.01
		end
		cost = cost * (1+bonus_cost)
	end
	cost = cost  *  self:GetManaCostGain()
	
	return cost
end

function chaotic_parasitic_fantasy_poison:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local duration = self:GetSpecialValueFor("duration")

	if self:GetRuneType() == 3 then
		self:ApplyModifier(caster, duration)
		return
	end

	if target:TriggerSpellAbsorb(self) then
		return
	end

	if self:GetAutoCastState() then
		local count = self:GetSpecialValueFor("count")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		self:ApplyModifier(target, duration)
		for _, unit in ipairs(enemies) do
			if unit~=target then
				count = count - 1
				self:ApplyModifier(unit, duration)
				if count<=0 then
					break
				end
			end
		end
	else
		self:ApplyModifier(target, duration)
	end



	
end



function chaotic_parasitic_fantasy_poison:ApplyModifier(target, duration)
	EmitSoundOn("Hero_Dazzle.BadJuJu.Target", target)    
	local particle_cast = "particles/rebuild/spell/chaotic_parasitic_fantasy_poison/chaotic_parasitic_fantasy_poison.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,2)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:RemoveModifierByName("modifier_chaotic_parasitic_fantasy_poison")
	target:AddNewModifier(caster, self, "modifier_chaotic_parasitic_fantasy_poison", {duration = duration*StatusResistance})

end


modifier_chaotic_parasitic_fantasy_poison = advanced_modifier({})

function modifier_chaotic_parasitic_fantasy_poison:IsHidden() return false end
function modifier_chaotic_parasitic_fantasy_poison:IsPurgable() return true end
function modifier_chaotic_parasitic_fantasy_poison:IsDebuff() return false end
function modifier_chaotic_parasitic_fantasy_poison:GetEffectName() return "particles/rebuild/spell/modifier_chaotic_parasitic_fantasy_poison/modifier_chaotic_parasitic_fantasy_poison14_imps.vpcf" end

function modifier_chaotic_parasitic_fantasy_poison:OnCreated(keys)

	if not IsServer() then
		return
	end

	self.parent = self:GetParent()
	self.damage = (self:GetAbility():GetSpecialValueFor("bonus_damage") * 0.01) * self:GetAbility():GetEffectGain()
	self.max = self:GetAbility():GetSpecialValueFor("damage_max")
	self.damageTable = {
		victim = self.parent,
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	self.rune_3_radius = self:GetAbility():GetSpecialValueFor("rune_3_radius")
	self.rune_3_incoming = self:GetAbility():GetSpecialValueFor("rune_3_incoming")
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end

function modifier_chaotic_parasitic_fantasy_poison:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	self.parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0, 0.9, 2)
	self.damageTable.damage = math.min(self.parent:GetAverageTrueAttackDamage(nil) * self.damage , self:GetCaster():HDGetPrimaryStatValue()*self.max)

	self.parent:GameTimer(0.25,function()
		if self.parent:HasModifier("modifier_chaotic_parasitic_fantasy_poison") then
			ApplyDamage(self.damageTable)
		end
	end)
	if self:GetAbility():GetRuneType() == 2 then
		self:GetCaster():GiveMana((self:GetCaster():GetMaxMana()-self:GetCaster():GetMana())*self:GetAbility():GetSpecialValueFor("rune_2_lostmp_regen")*0.01)
	end
	if self:GetAbility():GetRuneType() == 3 then
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.rune_3_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage(self.damageTable)
		end
	end
end

function modifier_chaotic_parasitic_fantasy_poison:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_DISARMED] = true,
		 
	}

	return state
end

function modifier_chaotic_parasitic_fantasy_poison:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility() and self:GetAbility():GetRuneType() == 3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
	return funcs
end

function modifier_chaotic_parasitic_fantasy_poison:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then return end
	return -self.rune_3_incoming
end