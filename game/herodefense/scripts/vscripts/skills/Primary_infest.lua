

LinkLuaModifier("modifier_Primary_infest", "skills/Primary_infest", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_infest_effect", "skills/Primary_infest", LUA_MODIFIER_MOTION_NONE)

Primary_infest = class ({})

function Primary_infest:GetAbilityTargetTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function Primary_infest:CastFilterResultTarget(target)
	if not IsServer() then return end

	if target == self:GetCaster() or target:GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
		return UF_FAIL_OTHER
	else
		return UF_SUCCESS
	end
	
	return UF_SUCCESS
end

function Primary_infest:GetCastRange()
	local caster = self:GetCaster()
	return 150 - caster:GetCastRangeBonus()

end

function Primary_infest:OnAbilityPhaseStart()
	local target = self:GetCursorTarget()
	
	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then
		return false
	else
		return true
	end
end

function Primary_infest:OnSpellStart()
	local target = self:GetCursorTarget()

	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then 
		self:RefundManaCost()
		self:EndCooldown()
		return
	end
	local modifier = self:GetCaster():FindModifierByName("modifier_Primary_infest")
	if modifier then
		modifier:SafeDestroy()
	end

	self:GetCaster():EmitSound("Hero_LifeStealer.Infest")


	
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, target)
	ParticleManager:SetParticleControl(infest_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(infest_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	

	self:GetCaster():Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge(self:GetCaster())

	local duration = self:GetSpecialValueFor("duration")
	local infest_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_infest", 
	{
		duration =duration,
		target_ent		= target:entindex(),
	})
	
	local infest_effect_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_Primary_infest_effect", {duration=duration})
	
	if infest_modifier and infest_effect_modifier then
		infest_modifier.infest_effect_modifier	= infest_effect_modifier
		infest_effect_modifier.infest_modifier	= infest_modifier
	end
	
	

	
end

---------------------
-- INFEST MODIFIER --
---------------------
modifier_Primary_infest = advanced_modifier ({})
function modifier_Primary_infest:IsHidden()	return true end
function modifier_Primary_infest:IsPurgable()	return false end
function modifier_Primary_infest:GetPriority()
	return 20
end

function modifier_Primary_infest:OnCreated(params)
	local ability = self:GetAbility()
	self.radius	= ability:GetSpecialValueFor("radius")
	
	self.cost = ability:GetSpecialValueFor("cost")*0.01
	self.regen_down = ability:GetSpecialValueFor("regen_down")
	
	if not IsServer() then return end
	self.damage	= ability:GetSpecialValueFor("basic_damage")+ability:GetSpecialValueFor("bonus_damage")+self:GetCaster():HDGetPrimaryStatValue()
	self.timer = GameRules:GetGameTime()
	self.ability_damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.target_ent	= EntIndexToHScript(params.target_ent)
	self:GetParent():AddNoDraw()

	
	self:StartIntervalThink(FrameTime())
end

function modifier_Primary_infest:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not self.target_ent or self.target_ent:IsNull() then
		self:SafeDestroy()
		return
	end
	local time = GameRules:GetGameTime()
	if time - self.timer >= 0.5 then
		self.timer = time
		local health_cost = math.max(parent:GetMaxHealth()*self.cost, 30)*0.5
		local mana_cost = math.max(parent:GetMaxMana()*self.cost, 30)*0.5
		
		if parent:GetHealth() > health_cost then
			parent:ModifyHealth(parent:GetHealth() - health_cost, ability, false, 0)
		else
			self.target_ent:ModifyHealth(self.target_ent:GetHealth() - math.max(self.target_ent:GetMaxHealth()*self.cost, 30)*0.5, ability, false, 0)
		end

		if parent:GetMana() > mana_cost then
			parent:Script_ReduceMana(mana_cost, ability)
		else
			self.target_ent:Script_ReduceMana(math.max(self.target_ent:GetMaxMana()*self.cost, 30)*0.5, ability)
		end	
	end

	self:GetParent():SetAbsOrigin(self.target_ent:GetAbsOrigin())
	self:GetParent():AddNoDraw()
end

function modifier_Primary_infest:OnDestroy()
	if not IsServer() then return end
	
    self:GetParent():EmitSound("Hero_LifeStealer.Consume")
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
    ParticleManager:ReleaseParticleIndex(infest_particle)
    
    self:GetParent():StartGesture(ACT_DOTA_SPAWN)
    
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
    for _, enemy in pairs(enemies) do
        local damageTable = {
            victim 			= enemy,
            damage 			= self.damage,
            damage_type		= self.ability_damage_type,
            damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
            attacker 		= self:GetCaster(),
            ability 		= self:GetAbility()
        }

        ApplyDamage(damageTable)
    end
    
    FindClearSpaceForUnit(self:GetParent(),  self:GetParent():GetAbsOrigin(), false)
	
	self:GetParent():RemoveNoDraw()
	-- Wearable:ShowWearables(self:GetParent())
	
	if self.infest_effect_modifier  then
		self.infest_effect_modifier:SafeDestroy()
	end
end

function modifier_Primary_infest:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
	
	}
end

function modifier_Primary_infest:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return -self.regen_down
end

function modifier_Primary_infest:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return -self.regen_down
end

function modifier_Primary_infest:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
	}
end

function modifier_Primary_infest:OnOrder(keys)
	if not IsServer() then return end
	if keys.unit == self:GetParent() then
        if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self:SafeDestroy()
		end
	end
end

function modifier_Primary_infest:CheckState(keys)
	if not IsServer() then return end

	-- Defaults
	local state = {
		[MODIFIER_STATE_SILENCED]						= true,
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_UNSELECTABLE]						= true,
		
		[MODIFIER_STATE_MUTED]						= true,
	}
	

	return state
end



----------------------------
-- INFEST EFFECT MODIFIER --
----------------------------
modifier_Primary_infest_effect = advanced_modifier ({})

function modifier_Primary_infest_effect:IsHidden()		return false end
function modifier_Primary_infest_effect:IsPurgable()		return false end
function modifier_Primary_infest_effect:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_infest_effect:ShouldUseOverheadOffset() return true end

function modifier_Primary_infest_effect:OnCreated()
	local ability = self:GetAbility()
	self.radius	= ability:GetSpecialValueFor("radius")
	self.bonus_attack= ability:GetSpecialValueFor("bonus_attack")
	self.bonus_health= ability:GetSpecialValueFor("bonus_health")
	self.bonus_spell = ability:GetSpecialValueFor("bonus_spell")
	--
	
	if not IsServer() then return end
	
	local infest_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	self:AddParticle(infest_overhead_particle, false, false, -1, true, false)
end

function modifier_Primary_infest_effect:OnDestroy()
	if not IsServer() then return end
	if self.infest_modifier then
		self.infest_modifier:SafeDestroy()
	end
end

function modifier_Primary_infest_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,                     --生命值,
	
	}
end

function modifier_Primary_infest_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	
	}
end

function modifier_Primary_infest_effect:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_attack
end

function modifier_Primary_infest_effect:AdvancedGetModifierHealthBonus()
	return self.bonus_health
end

function modifier_Primary_infest_effect:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell
end

function modifier_Primary_infest_effect:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    elseif self._tooltip == 2 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
	elseif self._tooltip == 3 then
        return self:AdvancedGetModifierHealthBonus()
    end
end
