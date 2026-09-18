chaotic_summon_chaotic_executive = class({})

LinkLuaModifier("modifier_chaotic_summon_chaotic_executive_buff", "chaotic_spell/class_9/chaotic_summon_chaotic_executive", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_chaotic_executive_passive", "chaotic_spell/class_6/chaotic_summon_chaotic_executive", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_chaotic_executive:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", context )
end

-- function chaotic_summon_chaotic_executive:GetIntrinsicModifierName()
-- 	return "modifier_chaotic_summon_chaotic_executive_passive"
-- end

function chaotic_summon_chaotic_executive:IsSummonSpell()return true end
-- function chaotic_summon_chaotic_executive:Spawn()
-- 	self.stack = 0
-- end
-- function chaotic_summon_chaotic_executive:GetStack()
-- 	return self.stack 
-- end

-- function chaotic_summon_chaotic_executive:InCrementStack()
-- 	self.stack   = self.stack  + 1
-- 	local modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
-- 	if modifier then
-- 		modifier:SetStackCount(self.stack)
-- 	end
-- end
function chaotic_summon_chaotic_executive:OnSpellStart()

	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	
	local caster =self:GetCaster()
	
	local gain = self:GetEffectGain()
	local life_duration = self:GetSpecialValueFor("duration") 

	local base_health = self:GetSpecialValueFor("base_health")
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth() + base_health*gain
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)

	-- local bonus_base_atk = self:GetSpecialValueFor("base_damage")
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7))
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_chaotic_executive",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", PATTACH_POINT, unit)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt( infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( infest_particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(infest_particle, 1, Vector(200,0,0))
	-- ParticleManager:SetParticleControl(infest_particle, 2, Vector(0.5,0,0))
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_ChaosKnight.RealityRift")
	-- unit:StartGesture(ACT_DOTA_SPAWN)
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_chaotic_executive_buff", {})

end


modifier_chaotic_summon_chaotic_executive_buff = advanced_modifier({})

function modifier_chaotic_summon_chaotic_executive_buff:IsDebuff() return false end
function modifier_chaotic_summon_chaotic_executive_buff:IsHidden() return true end
function modifier_chaotic_summon_chaotic_executive_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_chaotic_executive_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_chaotic_executive_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_chaotic_executive_buff:OnCreated(keys)
	if IsServer() then
		self.creeps_spell = self:GetParent():FindAbilityByName("chaotic_ruby_reverse_radiation")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		local interval_reduction = self:GetAbility():GetSpecialValueFor("interval_reduction")
		local min_interval = self:GetAbility():GetSpecialValueFor("min_interval")
		local health_reqire = self:GetAbility():GetSpecialValueFor("health_reqire")
		local health = self:GetParent():GetMaxHealth()
		self.interval = math.max(self.interval-math.floor(health/health_reqire*interval_reduction),min_interval)
		self.timer =  GameRules:GetGameTime()
		if self.creeps_spell then
			self.creeps_spell:SetFrozenCooldown(true)
			-- self.creeps_spell:StartCooldown(600)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_chaotic_executive_buff:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creeps_spell:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creeps_spell:EndCooldown()
			self.timer = time + self.interval
			-- ExecuteOrderFromTable({
			-- 	UnitIndex = parent:entindex(),
			-- 	OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			-- 	Position = target:GetAbsOrigin(),
			-- 	AbilityIndex = self.creeps_spell:entindex(),
			-- 	Queue = false,
			-- })
			parent:CastAbilityOnTarget(target, self.creeps_spell, parent:GetPlayerOwnerID())
			-- parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.lighting, parent:GetPlayerOwnerID())
		end
	-- else
	-- 	self.lighting:StartCooldown(600)
	end
end


function modifier_chaotic_summon_chaotic_executive_buff:ADDeclareFunctions()
	local funcs = {

		advanced_MODIFIER_PROPERTY_CastPoint,
		
    }
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN_MUL)
	end

	return funcs

end


function modifier_chaotic_summon_chaotic_executive_buff:Advanced_GetModifier_CastPoint() 
	return 100
end



function modifier_chaotic_summon_chaotic_executive_buff:Advanced_GetModifier_ChaoticSpellEffectGain_Mul() 
	return self:GetAbility():GetSpecialValueFor("rune_1_bonus")
end



