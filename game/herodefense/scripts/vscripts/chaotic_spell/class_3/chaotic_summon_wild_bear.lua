chaotic_summon_wild_bear = class({})

LinkLuaModifier("modifier_chaotic_summon_wild_bear_buff", "chaotic_spell/class_3/chaotic_summon_wild_bear", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_wild_bear:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_summon_wild_bear/effects.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_impact.vpcf", context )
end


function chaotic_summon_wild_bear:IsSummonSpell()return true end

function chaotic_summon_wild_bear:OnSpellStart()

	
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
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local unit = caster:SummonUnit("npc_hd_wild_bear",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	local infest_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_summon_wild_bear/effects.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_LoneDruid.SpiritBear.Cast")

	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_wild_bear_buff", {gain=gain})

	table.insert(self.summon_table,unit)

end


modifier_chaotic_summon_wild_bear_buff = advanced_modifier({})

function modifier_chaotic_summon_wild_bear_buff:IsDebuff() return false end
function modifier_chaotic_summon_wild_bear_buff:IsHidden() return false end
function modifier_chaotic_summon_wild_bear_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_wild_bear_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_wild_bear_buff:RemoveOnDeath()  return false end

function modifier_chaotic_summon_wild_bear_buff:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.health_reduction = self.ability:GetSpecialValueFor("health_reduction")
	self.bonus_attack_damage = self.ability:GetSpecialValueFor("bonus_attack_damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.attack_damage = 1 - (self.health_reduction - self.bonus_attack_damage) / self.health_reduction
	if IsServer() then
		self.cooldown_time = self.ability:GetSpecialValueFor("cooldown_time")
		self.timer = GameRules:GetGameTime()
		self.damage  = self.damage  * keys.gain
		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_chaotic_summon_wild_bear_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},

		-- advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	
    }
	if self:GetAbility():GetRuneType()==1 then
		self.rune1_record = {}
		self.rune1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
	end
    return funcs
    
end


function modifier_chaotic_summon_wild_bear_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return ((self.parent:GetMaxHealth() - self.parent:GetHealth()) / self.parent:GetMaxHealth()) * 100 * self.attack_damage
end

function modifier_chaotic_summon_wild_bear_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_wild_bear_buff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self.health_reduction
	end
	if self._tooltip == 2 then
		return self.bonus_attack_damage
	end	
	if self._tooltip == 3 then
		return self.radius
	end
	if self._tooltip == 4 then
		return self.damage
	end		
end

function modifier_chaotic_summon_wild_bear_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if not IsValid(self.ability) then
		return
	end
	local time = GameRules:GetGameTime()
	if self.timer>=time then
		return
	end
	self.timer = time + self.cooldown_time
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local damage =  self.parent:GetAverageTrueAttackDamage(nil) * self.damage*0.01
	local damageTable = {
		attacker = self.parent,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self.ability,
	}
	for _, enemy in pairs(enemies) do
		if enemy~=keys.target then
			damageTable.victim = enemy
			ApplyDamage(damageTable)	
		end
		
	end
	local effect_damage = ParticleManager:CreateParticle( "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(effect_damage,0,keys.target:GetOrigin())
	DestroyParticleByDelay(effect_damage,2)
	local sound_cast = "Hero_LoneDruid.ProjectileImpact"
	EmitSoundOnLocationWithCaster(keys.target:GetOrigin(),sound_cast, self.parent)
end



function modifier_chaotic_summon_wild_bear_buff:AddCustomTransmitterData( )
	return
	{
		damage = self.damage,
	}
end

function modifier_chaotic_summon_wild_bear_buff:HandleCustomTransmitterData( data )
	self.damage = data.damage
end



function modifier_chaotic_summon_wild_bear_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if keys.target then
		if not self.rune1_record[keys.target]  then
			self.rune1_record[keys.target] = true
			return self.rune1_bonus
		end
	end
	return 0
end

