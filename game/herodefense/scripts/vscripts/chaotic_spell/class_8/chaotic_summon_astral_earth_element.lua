chaotic_summon_astral_earth_element = class({})

LinkLuaModifier("modifier_chaotic_summon_astral_earth_element_buff", "chaotic_spell/class_8/chaotic_summon_astral_earth_element", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_astral_earth_element_passive", "chaotic_spell/class_6/chaotic_summon_astral_earth_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff", "chaotic_spell/class_8/chaotic_summon_astral_earth_element", LUA_MODIFIER_MOTION_NONE)
function chaotic_summon_astral_earth_element:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era_spell/chaotic_summon_astral_earth_element/effect_rune2/effect.vpcf", context )
end


function chaotic_summon_astral_earth_element:IsSummonSpell()return true end

function chaotic_summon_astral_earth_element:OnSpellStart()

	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	
	local caster =self:GetCaster()
	
	local life_duration = self:GetSpecialValueFor("duration") 
	local gain = self:GetEffectGain()
	local base_health = self:GetSpecialValueFor("base_health")*gain
	local base_armor = self:GetSpecialValueFor("base_armor")*gain


	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()+base_health
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)+base_armor
	-- local bonus_base_atk = self:GetSpecialValueFor("base_damage")
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7))
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_astral_earth_element",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_POINT, unit)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	-- ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	ParticleManager:SetParticleControl(infest_particle, 1, Vector(1,0,0))
	-- ParticleManager:SetParticleControl(infest_particle, 2, Vector(0.5,0,0))
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_EarthShaker.Fissure")
	-- unit:StartGesture(ACT_DOTA_SPAWN)
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_astral_earth_element_buff", {})



	if self:GetRuneType()==1 then
		local gain = caster:GetModifierDurationGainIndex(1)
		unit:AddNewModifier(caster, self, "modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff", {duration = self:GetSpecialValueFor("rune_1_duration")*gain})

		
	end

end


modifier_chaotic_summon_astral_earth_element_buff = advanced_modifier({})

function modifier_chaotic_summon_astral_earth_element_buff:IsDebuff() return false end
function modifier_chaotic_summon_astral_earth_element_buff:IsHidden() return true end
function modifier_chaotic_summon_astral_earth_element_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_astral_earth_element_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_astral_earth_element_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_astral_earth_element_buff:OnCreated(keys)
	if IsServer() then
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_stoneskin")
		-- self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.armor_to_damage = self:GetAbility():GetSpecialValueFor("armor_to_damage")
		-- self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:SetFrozenCooldown(true)
			self:GetParent():GameTimer(0.03, function()
				self:GetParent():CastAbilityOnTarget(self:GetParent(), self.creep_ability, self:GetParent():GetPlayerOwnerID())
			end)
		
			-- self.lighting:StartCooldown(600)
			-- self:StartIntervalThink(0.2)
		end
		if self:GetAbility():GetRuneType()==2 then
			-- "rune_2_interval"   "2"
			self.rune_2 = true
			self.rune_2_radius = self:GetAbility():GetSpecialValueFor("rune_2_radius")
			self.rune_2_count = self:GetAbility():GetSpecialValueFor("rune_2_count")
			-- "rune_2_radius"  "500"
			-- "rune_2_count"  "10"
			self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rune_2_interval"))
		end
	end
end

function modifier_chaotic_summon_astral_earth_element_buff:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	if self.rune_2 and not parent:IsMoving() then
		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.rune_2_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 0,

		}
		local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		local pass = false
		for i, enemy in pairs(enemies) do				
			pass = true
			parent:PerformAttack(enemy, false, true, true, false, true, false, true)
			if i>=self.rune_2_count then
				break
			end
		end

		if pass then
			local infest_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_era_spell/chaotic_summon_astral_earth_element/effect_rune2/effect.vpcf", PATTACH_POINT, parent)
			ParticleManager:SetParticleControl(infest_particle, 0, parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(infest_particle, 2, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(infest_particle)
			parent:EmitSound("Hero_AbyssalUnderlord.Firestorm.Cast")
		end
	end


	

	
end


function modifier_chaotic_summon_astral_earth_element_buff:ADDeclareFunctions()
	local funcs = {

		advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
    }

	return funcs

end


function modifier_chaotic_summon_astral_earth_element_buff:Advanced_GetModifier_CastPoint() 
	return 100
end

function modifier_chaotic_summon_astral_earth_element_buff:Advanced_GetModifierProcAttack_BonusDamage_Physical()	
	return self.armor_to_damage*self:GetParent():GetPhysicalArmorValue(false)
end


function modifier_chaotic_summon_astral_earth_element_buff:CheckState()
	if self.rune_2 then
		return {
			[MODIFIER_STATE_DISARMED] = true,
		}
	end
	return
end


function modifier_chaotic_summon_astral_earth_element_buff:DeclareFunctions() 
	local funcs = {}
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,MODIFIER_PROPERTY_OVERRIDE_ANIMATION)
		table.insert(funcs,MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE)
	end
	return funcs
end
function modifier_chaotic_summon_astral_earth_element_buff:GetOverrideAnimation( params ) return ACT_DOTA_CHANNEL_ABILITY_1 end
function modifier_chaotic_summon_astral_earth_element_buff:GetOverrideAnimationRate( params ) return 0.5 end




modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff = advanced_modifier({})

function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:IsDebuff() return false end
function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:IsHidden() return false end
function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:OnCreated(keys)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
end
function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
			MODIFIER_PROPERTY_TOOLTIP

	}
end


function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end





function modifier_chaotic_summon_astral_earth_element_buff_rune_1_buff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

    if self._tooltip == 1 then
        return self:GetModifierAttackSpeedBonus_Constant()
    end     
    
end

