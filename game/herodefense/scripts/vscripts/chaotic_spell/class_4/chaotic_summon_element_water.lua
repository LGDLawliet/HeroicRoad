chaotic_summon_element_water = class({})

LinkLuaModifier("modifier_chaotic_summon_element_water_rune1", "chaotic_spell/class_4/chaotic_summon_element_water", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_element_water_buff", "chaotic_spell/class_4/chaotic_summon_element_water", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_element_water_buff_effect", "chaotic_spell/class_4/chaotic_summon_element_water", LUA_MODIFIER_MOTION_NONE)
function chaotic_summon_element_water:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_waveform.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context )
end
function chaotic_summon_element_water:IsSummonSpell()return true end

function chaotic_summon_element_water:OnSpellStart()

	local ability = self
	local count = self:GetSpecialValueFor("max_count")
	local caster =self:GetCaster()
	
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	local gain = self:GetEffectGain()
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+ self:GetSpecialValueFor("base_damage")*gain
	local mp_regen = self:GetSpecialValueFor("mp_regen")*0.01 * caster:GetMaxMana()

	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local unit = caster:SummonUnit("npc_hd_chaotic_water",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlEnt(pfx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlForward(pfx, 1, unit:GetForwardVector())  --方向
    ParticleManager:ReleaseParticleIndex(pfx)
    unit:EmitSound("Hero_Morphling.AdaptiveStrikeAgi.Target")

	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_element_water_buff", {gain=gain, mp_regen = mp_regen})
	if ability and ability:GetRuneType() == 1 then
        local ability = unit:AddAbility("heroTalent_npc_dota_hero_morphling_2")
		if ability then
			ability:SetLevel(1)
		end
        unit:AddNewModifier(caster, self, "modifier_chaotic_summon_element_water_rune1", {})
    end
	table.insert(self.summon_table,unit)
end

modifier_chaotic_summon_element_water_rune1 = advanced_modifier({})

function modifier_chaotic_summon_element_water_rune1:IsDebuff() return false end
function modifier_chaotic_summon_element_water_rune1:IsHidden() return true end
function modifier_chaotic_summon_element_water_rune1:IsPurgable() return false end

function modifier_chaotic_summon_element_water_rune1:OnCreated(keys)
    if not self:GetAbility() then return end
    self.interval_4 = self:GetAbility():GetSpecialValueFor("rune_1_interval")
    self.creep_ability = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_morphling_2")
	self.timer =  GameRules:GetGameTime()
	if IsServer() then
        if self.creep_ability then
            self.creep_ability:StartCooldown(8)
            self.creep_ability:SetFrozenCooldown(true)
        end
		self:StartIntervalThink(0.2)
	end
end

function modifier_chaotic_summon_element_water_rune1:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval_4
			local pos = target:GetAbsOrigin()  + parent:GetForwardVector()*300
			parent:CastAbilityOnPosition(pos, self.creep_ability, parent:GetPlayerOwnerID())
		end
	end
end

modifier_chaotic_summon_element_water_buff_effect = advanced_modifier({})

function modifier_chaotic_summon_element_water_buff_effect:IsDebuff() return false end
function modifier_chaotic_summon_element_water_buff_effect:IsHidden() return (not self:GetParent():IsSpriteSummon()) end
function modifier_chaotic_summon_element_water_buff_effect:IsPurgable() 		return false end
function modifier_chaotic_summon_element_water_buff_effect:IsPurgeException() 	return false end
function modifier_chaotic_summon_element_water_buff_effect:OnCreated(keys)
	self.ability = self:GetAbility()
	self.range = self.ability:GetSpecialValueFor("range")
end
function modifier_chaotic_summon_element_water_buff_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end
function modifier_chaotic_summon_element_water_buff_effect:Advanced_GetModifierAttackRangeBonus()
    if not self:GetAbility() then return end
    if not self:GetParent():IsSpriteSummon() then return end
    return self.range
end
function modifier_chaotic_summon_element_water_buff_effect:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_element_water_buff_effect:OnTooltip() 
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.range
	end
end
modifier_chaotic_summon_element_water_buff = advanced_modifier({})

function modifier_chaotic_summon_element_water_buff:IsDebuff() return false end
function modifier_chaotic_summon_element_water_buff:IsHidden() return false end
function modifier_chaotic_summon_element_water_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_element_water_buff:IsPurgeException() 	return false end

function modifier_chaotic_summon_element_water_buff:IsAura() return true end
function modifier_chaotic_summon_element_water_buff:GetModifierAura()	return "modifier_chaotic_summon_element_water_buff_effect" end
function modifier_chaotic_summon_element_water_buff:GetAuraRadius()	return self.radius end
function modifier_chaotic_summon_element_water_buff:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_chaotic_summon_element_water_buff:GetAuraSearchType()	return DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_summon_element_water_buff:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end

function modifier_chaotic_summon_element_water_buff:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.radius = self.ability:GetSpecialValueFor("radius")
	if IsServer() then
		self.mp_regen = keys.mp_regen or 1
        self:SetStackCount(self.mp_regen)
	end
end

function modifier_chaotic_summon_element_water_buff:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	
    }
    return funcs
end

function modifier_chaotic_summon_element_water_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_element_water_buff:OnTooltip() 
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()
	end
	if self._tooltip == 2 then
		return self.radius
	end	
end

function modifier_chaotic_summon_element_water_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if not IsValid(self.ability) then
		return
	end
    if not self:GetCaster() or not self:GetCaster():IsAlive() then return end
    self:GetCaster():GiveMana(self:GetStackCount())
end

