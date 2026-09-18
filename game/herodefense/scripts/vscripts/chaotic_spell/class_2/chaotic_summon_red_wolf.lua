chaotic_summon_red_wolf = class({})

LinkLuaModifier("modifier_chaotic_summon_red_wolf_buff", "chaotic_spell/class_2/chaotic_summon_red_wolf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_red_wolf_buff_rune1", "chaotic_spell/class_2/chaotic_summon_red_wolf", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_red_wolf:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_summon_red_wolf/effect.vpcf", context )
end


function chaotic_summon_red_wolf:IsSummonSpell()return true end

function chaotic_summon_red_wolf:OnSpellStart()

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
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*3) + self:GetSpecialValueFor("base_damage")*gain
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local unit = caster:SummonUnit("npc_hd_red_wolf",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	local infest_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_summon_red_wolf/effect.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_Lycan.SummonWolves")

	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_red_wolf_buff", {gain=gain})
	if self:GetRuneType()==1 then
		unit:AddNewModifier(caster, self, "modifier_chaotic_summon_red_wolf_buff_rune1", {})
	end
	table.insert(self.summon_table,unit)

end


modifier_chaotic_summon_red_wolf_buff = advanced_modifier({})

function modifier_chaotic_summon_red_wolf_buff:IsDebuff() return false end
function modifier_chaotic_summon_red_wolf_buff:IsHidden() return false end
function modifier_chaotic_summon_red_wolf_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_red_wolf_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_red_wolf_buff:RemoveOnDeath()  return false end

function modifier_chaotic_summon_red_wolf_buff:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.health = self.ability:GetSpecialValueFor("health")
	self.damage = self.ability:GetSpecialValueFor("damage")
	if IsServer() then
		self.damage = self.damage * keys.gain
		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_chaotic_summon_red_wolf_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
    }
end


function modifier_chaotic_summon_red_wolf_buff:Advanced_GetModifierProcAttack_BonusDamage_Physical(keys)
	if not IsServer() then
		return
	end
	if keys.target:GetHealth() / keys.target:GetMaxHealth() > self.health * 0.01 then
		return 0
	end
	local bonus_life_steal = keys.damage * self.damage * 0.01
	local fhealing =  HealWithGain(bonus_life_steal,self.parent,self.parent,self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.parent, fhealing, nil)
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_gluttony/effect_main/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(effect_cast, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",self.parent:GetOrigin(), false)
	-- DestroyParticleByDelay(effect_cast,1)
	ParticleManager:ReleaseParticleIndex(effect_cast)
	local effect_damage = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_summon_red_wolf/effect_light.vpcf.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(effect_damage, 0,  keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc",keys.target:GetOrigin(), false)
	ParticleManager:ReleaseParticleIndex(effect_damage)
	self.parent:EmitSound("Hero_ElderTitan.AncestralSpirit.Buff")
	return keys.damage * self.damage * 0.01
end

function modifier_chaotic_summon_red_wolf_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_red_wolf_buff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.health
	end
	if self._tooltip == 2 then
		return self.damage
	end	
end


function modifier_chaotic_summon_red_wolf_buff:AddCustomTransmitterData( )
	return
	{
		damage = self.damage,
	}
end

function modifier_chaotic_summon_red_wolf_buff:HandleCustomTransmitterData( data )
	self.damage = data.damage
end








modifier_chaotic_summon_red_wolf_buff_rune1 = advanced_modifier({})

function modifier_chaotic_summon_red_wolf_buff_rune1:IsDebuff() return false end
function modifier_chaotic_summon_red_wolf_buff_rune1:IsHidden() return true end
function modifier_chaotic_summon_red_wolf_buff_rune1:IsPurgable() 		return false end
function modifier_chaotic_summon_red_wolf_buff_rune1:IsPurgeException() 	return false end
-- function modifier_chaotic_summon_red_wolf_buff_rune1:RemoveOnDeath()  return false end

function modifier_chaotic_summon_red_wolf_buff_rune1:OnCreated(keys)
	if IsServer() then
		self.distance = self:GetAbility():GetSpecialValueFor("rune_1_distance")

		self:StartIntervalThink(0.5)
	end
end
function modifier_chaotic_summon_red_wolf_buff_rune1:OnIntervalThink()
	local dis = CalculateDistance(self:GetParent(),self:GetCaster())
	if dis>=self.distance then
		if IsValid(self.modifier) then
			self.modifier:SetDuration(0.6, false)
		else
			self.modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 0.6})
		end
		
	end
end

function modifier_chaotic_summon_red_wolf_buff_rune1:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	

	return state
end
