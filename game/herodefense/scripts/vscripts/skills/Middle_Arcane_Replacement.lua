
Middle_Arcane_Replacement = class({})


LinkLuaModifier("modifier_Middle_Arcane_Replacement", "skills/Middle_Arcane_Replacement", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_Arcane_Replacement_effect", "skills/Middle_Arcane_Replacement", LUA_MODIFIER_MOTION_NONE)


function Middle_Arcane_Replacement:GetIntrinsicModifierName() return "modifier_Middle_Arcane_Replacement" end
function Middle_Arcane_Replacement:IsHiddenWhenStolen() 		return false end
function Middle_Arcane_Replacement:IsRefreshable() 			return true  end
function Middle_Arcane_Replacement:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/arcane_replacement/effect.vpcf", context )
end




function Middle_Arcane_Replacement:ReleasePower(stack)
	local caster = self:GetCaster()
	local effect_count = 1
	local unlock2 = false
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		attacker = caster,
		damage = stack,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self, --Optional.
	}


	for _, unit in ipairs(enemies) do
		self:PlayEffect(caster,unit)
		damageTable.victim = unit
		ApplyDamage(damageTable)
		unit:EmitSound("Hero_Luna.Eclipse.Target")
		local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local count = 3
		for _, target in ipairs(units) do
			if unit~=target then
				count = count - 1
				self:PlayEffect(unit,target)
				damageTable.victim = target
				ApplyDamage(damageTable)
				if count<=0 then
					break
				end
			end
		end
		effect_count = effect_count -1
		if effect_count<=0 then
			break
		end
	end
	
	
	return stack

end
function Middle_Arcane_Replacement:PlayEffect(source,target)
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/arcane_replacement/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, source, PATTACH_POINT_FOLLOW, "attach_attack1", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
end



modifier_Middle_Arcane_Replacement= class({})

function modifier_Middle_Arcane_Replacement:IsDebuff()			return false end
function modifier_Middle_Arcane_Replacement:IsHidden() 			return false end
function modifier_Middle_Arcane_Replacement:IsPurgable() 		return false end
function modifier_Middle_Arcane_Replacement:IsPurgeException() 	return false end
function modifier_Middle_Arcane_Replacement:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.change_percentage = ability:GetSpecialValueFor("change_percentage")*0.01
		-- self.change_limit = ability:GetSpecialValueFor("change_limit")
		self.change_limit2 = ability:GetSpecialValueFor("change_limit2")
		self:StartIntervalThink(0.3)
	end
end
function modifier_Middle_Arcane_Replacement:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.change_percentage = ability:GetSpecialValueFor("change_percentage")*0.01
		-- self.change_limit = ability:GetSpecialValueFor("change_limit")
		self.change_limit2 = ability:GetSpecialValueFor("change_limit2")
	end
end
function modifier_Middle_Arcane_Replacement:OnCustomModifierFunction_Heal(keys)
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		if keys.unit:PassivesDisabled() then
			return
		end
		if keys.heal<5 then
			return
		end
		-- local heal = math.min(keys.heal *self.change_percentage,keys.unit:HDGetPrimaryStatValue()*self.change_limit)
		local heal = keys.heal *self.change_percentage
		self:SetStackCount(math.min(self:GetStackCount()+heal,keys.unit:HDGetPrimaryStatValue()*self.change_limit2))


	end
end
function modifier_Middle_Arcane_Replacement:OnIntervalThink(keys)
	local stack = self:GetStackCount()
	if stack>=100 then
		local ability = self:GetAbility()
		local reduce = ability:ReleasePower(stack)
		self:SetStackCount(stack-reduce)
	end
	
end










