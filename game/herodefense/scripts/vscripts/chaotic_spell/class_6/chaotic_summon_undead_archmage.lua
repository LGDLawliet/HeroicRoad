chaotic_summon_undead_archmage = class({})

LinkLuaModifier("modifier_chaotic_summon_undead_archmage_rune_1_buff", "chaotic_spell/class_6/chaotic_summon_undead_archmage", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_undead_archmage_passive", "chaotic_spell/class_6/chaotic_summon_undead_archmage", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_undead_archmage:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_loadout.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", context )

	
end

-- function chaotic_summon_undead_archmage:GetIntrinsicModifierName()
-- 	return "modifier_chaotic_summon_undead_archmage_passive"
-- end

function chaotic_summon_undead_archmage:IsSummonSpell()return true end
-- function chaotic_summon_undead_archmage:Spawn()
-- 	self.stack = 0
-- end
-- function chaotic_summon_undead_archmage:GetStack()
-- 	return self.stack 
-- end

-- function chaotic_summon_undead_archmage:InCrementStack()
-- 	self.stack   = self.stack  + 1
-- 	local modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
-- 	if modifier then
-- 		modifier:SetStackCount(self.stack)
-- 	end
-- end
function chaotic_summon_undead_archmage:OnSpellStart()

	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	
	local caster =self:GetCaster()
	
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local gain = self:GetEffectGain()
	local bonus_base_atk = self:GetSpecialValueFor("base_damage")
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+gain*bonus_base_atk)
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_undead_archmage",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_POINT, unit)
	-- ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Greevil.FleshGolem.Cast")
	-- unit:AddActivityModifier("loadout")
	unit:GameTimer(0.06, function()
		unit:StartGesture(ACT_DOTA_SPAWN)
	end)
	if self:GetRuneType()==1 then
		unit:AddNewModifier(caster, self, "modifier_chaotic_summon_undead_archmage_rune_1_buff", {})
	end
	-- unit:AddNewModifier(caster, self, "modifier_chaotic_summon_undead_archmage_rune_1_buff", {})

end


modifier_chaotic_summon_undead_archmage_rune_1_buff = advanced_modifier({})

function modifier_chaotic_summon_undead_archmage_rune_1_buff:IsDebuff() return false end
function modifier_chaotic_summon_undead_archmage_rune_1_buff:IsHidden() return true end
function modifier_chaotic_summon_undead_archmage_rune_1_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_undead_archmage_rune_1_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_undead_archmage_rune_1_buff:RemoveOnDeath()  return false end

function modifier_chaotic_summon_undead_archmage_rune_1_buff:OnCreated(keys)
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("chaotic_fire_ball")
		self.timer = GameRules:GetGameTime()
		self.rune_1_distance = self:GetAbility():GetSpecialValueFor("rune_1_distance")
		self.rune_1_cooldown = self:GetAbility():GetSpecialValueFor("rune_1_cooldown")
		self.rune_1_chance = self:GetAbility():GetSpecialValueFor("rune_1_chance")

		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_fire_ball")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(14)
			self.creep_ability:SetFrozenCooldown(true)
			-- self.lighting:StartCooldown(600)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_undead_archmage_rune_1_buff:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
		end
	end
end

function modifier_chaotic_summon_undead_archmage_rune_1_buff:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { nil,nil },
	}
end




function modifier_chaotic_summon_undead_archmage_rune_1_buff:OnAbilityFullyCast(keys)
	-- print("1111111111111")
	if keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
		return 
	end
	-- print(" keys.inflictor=", keys.ability)
	if keys.ability and keys.ability:GetAbilityName()=="chaotic_fire_ball" then
		if self.timer>=GameRules:GetGameTime() then
			return
		end
		if not self:GetParent():IsAlive() then
			return
		end
		
		if CalculateDistance(keys.unit,self:GetParent())<=self.rune_1_distance then
			local target = self:GetParent():GetAggroTarget()
			if not target then
				return
			end
			if self:GetCaster():RollRandom(self.rune_1_chance,1) then
				self.timer = GameRules:GetGameTime() + self.rune_1_cooldown
				if IsValid(self.ability) then
					self.ability:ApplyEffect(target:GetAbsOrigin())
				end
			end
		end
	end
	-- local ability = self:GetAbility()
	-- if not ability:IsCooldownReady() then
	-- 	local newCooldown = ability:GetCooldownTimeRemaining() - ability:GetSpecialValueFor("cooldown_reduction")
		
	-- 	ability:EndCooldown()
	-- 	if newCooldown>=0 then
	-- 		ability:StartCooldown(newCooldown)
	-- 	end
	-- end
end




-- modifier_chaotic_summon_undead_archmage_passive = advanced_modifier({})

-- function modifier_chaotic_summon_undead_archmage_passive:IsDebuff() return false end
-- function modifier_chaotic_summon_undead_archmage_passive:IsHidden() return false end
-- function modifier_chaotic_summon_undead_archmage_passive:IsPurgable() 		return false end
-- function modifier_chaotic_summon_undead_archmage_passive:IsPurgeException() 	return false end
-- function modifier_chaotic_summon_undead_archmage_passive:RemoveOnDeath()  return false end
-- function modifier_chaotic_summon_undead_archmage_passive:OnCreated(keys)
-- 	self.bonus_atk_per_kill = self:GetAbility():GetSpecialValueFor("bonus_atk_per_kill")
-- 	if IsServer() then
-- 		self:SetStackCount(self:GetAbility():GetStack())
-- 	end
-- end

-- function modifier_chaotic_summon_undead_archmage_passive:DeclareFunctions()
-- 	return {

-- 		MODIFIER_PROPERTY_TOOLTIP,  
-- 	}
-- end


-- function modifier_chaotic_summon_undead_archmage_passive:OnTooltip()
-- 	self._tooltip = (self._tooltip or 0) % 1 + 1
-- 	if self._tooltip == 1 then
-- 		return  self.bonus_atk_per_kill * self:GetStackCount()
-- 	end
-- end
