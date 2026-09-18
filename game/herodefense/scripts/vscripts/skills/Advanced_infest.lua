
--特效优化 √
LinkLuaModifier("modifier_Advanced_infest", "skills/Advanced_infest", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_infest_effect", "skills/Advanced_infest", LUA_MODIFIER_MOTION_NONE)

Advanced_infest = class ({})
function Advanced_infest:CheckKV(key)
	local table = {
		basic_damage = 15,
		bonus_damage = 0.1,
		bonus_health = 20,
	}
	local value = table[key] or -1
	return value

end
function Advanced_infest:GetCastRange()
	local caster = self:GetCaster()
	return 150 - caster:GetCastRangeBonus()

end
function Advanced_infest:UnlockFirstCore(key)

	return true
end
function Advanced_infest:UnlockSecondCore(key)
	return true
end
function Advanced_infest:UnlockThirdCore(key)
	return true
end
function Advanced_infest:GetAbilityTargetTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function Advanced_infest:CastFilterResultTarget(target)
	if not IsServer() then return end

	if target == self:GetCaster() or target:GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
		return UF_FAIL_OTHER
	else
		return UF_SUCCESS
	end
	
	return UF_SUCCESS
end


-- Why does this block even need to be a thing
-- Infest can go into dead enemies without this and then the whole thing explodes
function Advanced_infest:OnAbilityPhaseStart()
	local target = self:GetCursorTarget()
	
	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then
		return false
	else
		return true
	end
end



function Advanced_infest:OnSpellStart()
	local target = self:GetCursorTarget()

	-- Some really messy stuff happening if this line isn't in...
	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then 
		self:RefundManaCost()
		self:EndCooldown()
		return
	end

	self:GetCaster():EmitSound("Hero_LifeStealer.Infest")

	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_infest")
	if modifier then
		modifier:SafeDestroy()
	end
	
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, target)
	ParticleManager:SetParticleControl(infest_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(infest_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	
	self:GetCaster():Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge(self:GetCaster())

	local duration = self:GetSpecialValueFor("duration")*2

	if self.advanced_level>=20 then
		duration = -1
	end

	local spell_damage = 0
	if self.unlock3 then
		spell_damage = self:GetCaster():GetSpellAmplification(false)*60
		if spell_damage<0 then
			spell_damage = 0
		end
	end
	local infest_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_infest", 
	{
		duration =duration,
		target_ent		= target:entindex(),
		spell_damage = spell_damage,
	})
	
	local infest_effect_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_infest_effect", {duration=duration,spell_damage = spell_damage})
	
	if infest_modifier and infest_effect_modifier then
		infest_modifier.infest_effect_modifier	= infest_effect_modifier
		infest_effect_modifier.infest_modifier	= infest_modifier
	end
	
	

	
end


modifier_Advanced_infest = advanced_modifier ({})
function modifier_Advanced_infest:IsPurgable()	return false end

function modifier_Advanced_infest:OnCreated(params)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local ability = self:GetAbility()
	self.radius	= ability:GetSpecialValueFor("radius")
	
	self.cost = ability:GetSpecialValueFor("cost")*0.01
	self.regen_down = ability:GetSpecialValueFor("regen_down")
	self.interval = ability:GetSpecialValueFor("interval")
	
	if self.advanced_level >= 20 then
		self.interval = self.interval - 2
	end


	if not IsServer() then return end
	self.damage	= ability:GetSpecialValueFor("basic_damage")+(ability:GetSpecialValueFor("bonus_damage"))+self:GetCaster():HDGetPrimaryStatValue()
	self.timer = GameRules:GetGameTime()
	self.boom_timer = GameRules:GetGameTime()
	self:SetStackCount(params.spell_damage)
	
	self.ability_damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.target_ent	= EntIndexToHScript(params.target_ent)
	self:GetParent():AddNoDraw()

	
	self:StartIntervalThink(FrameTime())
end

function modifier_Advanced_infest:OnIntervalThink()
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

	if time - self.boom_timer >= self.interval then
		self.boom_timer = time
		self:ApplyBlast()
	end

	self:GetParent():SetAbsOrigin(self.target_ent:GetAbsOrigin())
	self:GetParent():AddNoDraw()
end

function modifier_Advanced_infest:ApplyBlast()
	self:GetParent():EmitSound("Hero_LifeStealer.Consume")
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(infest_particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(infest_particle)

	local total_damage = 0
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
        local damage = ApplyDamage(damageTable)
        total_damage = total_damage + damage
    end

	if total_damage > 0 and self.advanced_level >= 10 then
		self:GetParent():Heal(math.min(total_damage*0.03, self:GetParent():GetMaxHealth()*0.1), self:GetAbility())
		self:GetParent():GiveMana(math.min(total_damage*0.03, self:GetParent():GetMaxMana()*0.1))
	end
end

function modifier_Advanced_infest:OnDestroy()
	if not IsServer() then return end

	self:ApplyBlast()
	
    self:GetParent():StartGesture(ACT_DOTA_SPAWN)
    FindClearSpaceForUnit(self:GetParent(),  self:GetParent():GetAbsOrigin(), false)
	self:GetParent():RemoveNoDraw()

	if self.infest_effect_modifier then
		self.infest_effect_modifier:SafeDestroy()
	end
end

function modifier_Advanced_infest:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end

function modifier_Advanced_infest:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return -self.regen_down
end

function modifier_Advanced_infest:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return -self.regen_down
end

function modifier_Advanced_infest:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
	}
end

function modifier_Advanced_infest:Advanced_GetModifierSpellAmplifyBonus()	return -self:GetStackCount() end

function modifier_Advanced_infest:OnOrder(keys)
	if not IsServer() then return end
	if keys.unit == self:GetParent() then
        if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_infest:GetPriority()
	return 20
end


function modifier_Advanced_infest:CheckState(keys)
	if not IsServer() then return end

	-- Defaults
	local state = {
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		-- [MODIFIER_STATE_OUT_OF_GAME]						= true,
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_UNSELECTABLE]						= true,
		[MODIFIER_STATE_SILENCED]						= true,
		[MODIFIER_STATE_MUTED]						= true,
	}
	if self.advanced_level>=5 then
		state[MODIFIER_STATE_MUTED] = false
	end
	if self:GetAbility().unlock1 then
		state[MODIFIER_STATE_SILENCED] = false
	end

	return state
end


----------------------------
-- INFEST EFFECT MODIFIER --
----------------------------
modifier_Advanced_infest_effect = advanced_modifier ({})

function modifier_Advanced_infest_effect:IsHidden()		return false end
function modifier_Advanced_infest_effect:IsPurgable()		return false end
function modifier_Advanced_infest_effect:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_infest_effect:ShouldUseOverheadOffset() return true end

function modifier_Advanced_infest_effect:OnCreated(params)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local ability = self:GetAbility()

	self.bonus_attribute= 0
	if self.advanced_level>=15 then
		self.bonus_attribute = 30
	end
	

	self.radius	= ability:GetSpecialValueFor("radius")
	self.bonus_attack= ability:GetSpecialValueFor("bonus_attack")
	self.bonus_health= ability:GetSpecialValueFor("bonus_health")
	self.bonus_spell = ability:GetSpecialValueFor("bonus_spell")
	self.armor = ability:GetSpecialValueFor("armor")
	self.mrs = ability:GetSpecialValueFor("mrs")
	self.outgoing = ability:GetSpecialValueFor("outgoing")


	self.unlock2_attribute_str = 0
	self.unlock2_attribute_agi = 0
	self.unlock2_attribute_int = 0
	
	if not IsServer() then return end
	self:SetStackCount(params.spell_damage)
	if ability.unlock2 then
		local caster = self:GetCaster()
		self.unlock2_attribute_str = caster:GetStrength()*0.6
		self.unlock2_attribute_agi =  caster:GetAgility()*0.6
		self.unlock2_attribute_int =  caster:GetIntellect(false)*0.6
	end
	self:StartIntervalThink(1)
	
	local infest_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	
	self:AddParticle(infest_overhead_particle, false, false, -1, true, false)
	

end



function modifier_Advanced_infest_effect:OnDestroy()
	if not IsServer() then return end
	
	if self.infest_modifier then
		self.infest_modifier:SafeDestroy()
	end

end

function modifier_Advanced_infest_effect:OnIntervalThink()
	if self:GetAbility().unlock2 then
		local caster = self:GetCaster()
		self.unlock2_attribute_str = math.min(caster:GetStrength()*0.6,self.unlock2_attribute_str)
		self.unlock2_attribute_agi =    math.min(caster:GetAgility()*0.6,self.unlock2_attribute_agi)
		self.unlock2_attribute_int =  math.min(caster:GetIntellect(false)*0.6,self.unlock2_attribute_int)
	end
end

function modifier_Advanced_infest_effect:CheckState()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and (self:GetParent():IsHero() or self:GetParent():IsBuilding() or self:GetParent():IsOther()) then
		return {[MODIFIER_STATE_SPECIALLY_DENIABLE] = true}
	end
end

function modifier_Advanced_infest_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS, 
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	
	}
end

function modifier_Advanced_infest_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_TOOLTIP,
	
	}
end
function modifier_Advanced_infest_effect:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_attack
end

function modifier_Advanced_infest_effect:AdvancedGetModifierHealthBonus()
	return self.bonus_health
end

function modifier_Advanced_infest_effect:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell + self:GetStackCount()
end
function modifier_Advanced_infest_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self.outgoing
end
function modifier_Advanced_infest_effect:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_Advanced_infest_effect:GetModifierMagicalResistanceBonus()
	return self.mrs
end

function modifier_Advanced_infest_effect:GetModifierBonusStats_Strength()	return self.bonus_attribute+self.unlock2_attribute_str end
function modifier_Advanced_infest_effect:GetModifierBonusStats_Intellect()	return self.bonus_attribute+self.unlock2_attribute_int end
function modifier_Advanced_infest_effect:GetModifierBonusStats_Agility()	return self.bonus_attribute+self.unlock2_attribute_agi end


function modifier_Advanced_infest_effect:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 6 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    elseif self._tooltip == 2 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
	elseif self._tooltip == 3 then
        return self:AdvancedGetModifierHealthBonus()
	elseif self._tooltip == 4 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	elseif self._tooltip == 5 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
	elseif self._tooltip == 6 then
        return self:GetModifierMagicalResistanceBonus()
    end
end
