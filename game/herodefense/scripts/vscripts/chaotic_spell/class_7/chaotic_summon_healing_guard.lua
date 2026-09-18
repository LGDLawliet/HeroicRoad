chaotic_summon_healing_guard = class({})
LinkLuaModifier("modifier_chaotic_summon_healing_guard_ice", "chaotic_spell/class_7/chaotic_summon_healing_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_healing_guard_buff", "chaotic_spell/class_7/chaotic_summon_healing_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_healing_guard_buff_effect", "chaotic_spell/class_7/chaotic_summon_healing_guard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_healing_guard_passive", "chaotic_spell/class_6/chaotic_summon_healing_guard", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_healing_guard:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast.vpcf", context )
end

function chaotic_summon_healing_guard:IsSummonSpell()return true end

function chaotic_summon_healing_guard:OnSpellStart()
	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	local caster =self:GetCaster()
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7))
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_healing_guard",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast.vpcf", PATTACH_POINT, unit)
	ParticleManager:SetParticleControl(infest_particle, 1, unit_pos)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("DOTA_Item.SentryWard.Activate")

	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_healing_guard_buff", {})
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_healing_guard_ice", {})
end


modifier_chaotic_summon_healing_guard_buff = advanced_modifier({})

function modifier_chaotic_summon_healing_guard_buff:IsDebuff() return false end
function modifier_chaotic_summon_healing_guard_buff:IsHidden() return false end
function modifier_chaotic_summon_healing_guard_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_healing_guard_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_healing_guard_buff:RemoveOnDeath()  return false end

function modifier_chaotic_summon_healing_guard_buff:IsAura() return true end
function modifier_chaotic_summon_healing_guard_buff:GetModifierAura()	return "modifier_chaotic_summon_healing_guard_buff_effect" end
function modifier_chaotic_summon_healing_guard_buff:GetAuraRadius()	return self.ally_radius end
function modifier_chaotic_summon_healing_guard_buff:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_chaotic_summon_healing_guard_buff:GetAuraSearchType()	return DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_summon_healing_guard_buff:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end

function modifier_chaotic_summon_healing_guard_buff:OnCreated(keys)
	self.ally_radius = self:GetAbility():GetSpecialValueFor("ally_radius")
	if IsServer() then
		self.creep_spell = self:GetParent():FindAbilityByName("chaotic_mass_healing_word")
		self.interval = 4
		self.timer =  GameRules:GetGameTime()
		if self.creep_spell then
			self.creep_spell:StartCooldown(4)
			self.creep_spell:SetFrozenCooldown(true)
			
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_healing_guard_buff:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_spell:IsCooldownReady() then
		self.creep_spell:EndCooldown()
		if parent:GetCurrentActiveAbility() then
			return
		end
		if ability:GetRuneType()==1 then
			local parent = self:GetParent()
			local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.creep_spell:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local pass = false
			for index, unit in ipairs(units) do
				if unit:GetHealthPercent()<100 then
					pass = true
				end
			end
			if pass then
				self.timer = self.timer + self.interval
				parent:CastAbilityNoTarget( self.creep_spell, parent:GetPlayerOwnerID())
			end
		
		else
			self.timer = time + self.interval
			parent:CastAbilityNoTarget( self.creep_spell, parent:GetPlayerOwnerID())
		end
	end
end

modifier_chaotic_summon_healing_guard_buff_effect = advanced_modifier({})

function modifier_chaotic_summon_healing_guard_buff_effect:IsDebuff() return false end
function modifier_chaotic_summon_healing_guard_buff_effect:IsHidden() return false end
function modifier_chaotic_summon_healing_guard_buff_effect:IsPurgable() 		return false end
function modifier_chaotic_summon_healing_guard_buff_effect:IsPurgeException() 	return false end
function modifier_chaotic_summon_healing_guard_buff_effect:OnCreated(keys)
	self.ability = self:GetAbility()
	self.ally_outgoing = self.ability:GetSpecialValueFor("ally_outgoing")
    self.ally_incoming = self.ability:GetSpecialValueFor("ally_incoming")
    self.ally_elemental = self.ability:GetSpecialValueFor("ally_elemental")
    self.type = self.ability:GetRuneType()
end



function modifier_chaotic_summon_healing_guard_buff_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_chaotic_summon_healing_guard_buff_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if not self:GetAbility() then self:Destroy() return end
    return self.ally_outgoing
end
function modifier_chaotic_summon_healing_guard_buff_effect:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return -self.ally_incoming
end
function modifier_chaotic_summon_healing_guard_buff_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    if not IsElementDamage(keys) then return end
    return self.ally_elemental
end

function modifier_chaotic_summon_healing_guard_buff_effect:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_healing_guard_buff_effect:OnTooltip() 
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self.ally_outgoing
	end
    if self._tooltip == 2 then
		return self.ally_incoming
	end
    if self._tooltip == 3 then
		return self.ally_elemental
	end
end

modifier_chaotic_summon_healing_guard_ice = advanced_modifier({})

function modifier_chaotic_summon_healing_guard_ice:IsDebuff() return false end
function modifier_chaotic_summon_healing_guard_ice:IsHidden() return true end
function modifier_chaotic_summon_healing_guard_ice:IsPurgable() 		return false end
function modifier_chaotic_summon_healing_guard_ice:IsPurgeException() 	return false end
function modifier_chaotic_summon_healing_guard_ice:RemoveOnDeath()  return false end
function modifier_chaotic_summon_healing_guard_ice:OnCreated(keys)
	if IsServer() then
		self.creep_spell = self:GetParent():FindAbilityByName("chaotic_ice_storm")
		self.interval = 15
		self.timer =  GameRules:GetGameTime()
		if self.creep_spell then
			self.creep_spell:StartCooldown(15)
			self.creep_spell:SetFrozenCooldown(true)
			
			self:StartIntervalThink(1)
		end
	end
end

function modifier_chaotic_summon_healing_guard_ice:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_spell:IsCooldownReady() then

		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, target in pairs(units) do
			if target:IsAlive() then
				self.creep_spell:EndCooldown()
				self.timer = time + self.interval
				parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_spell, parent:GetPlayerOwnerID())
				break
			end
		end
		
	end
end

