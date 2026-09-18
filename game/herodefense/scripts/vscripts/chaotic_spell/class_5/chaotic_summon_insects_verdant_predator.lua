chaotic_summon_insects_verdant_predator = class({})

LinkLuaModifier("modifier_chaotic_summon_insects_verdant_predator_buff", "chaotic_spell/class_5/chaotic_summon_insects_verdant_predator", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_insects_verdant_predator_passive", "chaotic_spell/class_6/chaotic_summon_insects_verdant_predator", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_insects_verdant_predator:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/venomancer/veno_2022_immortal_tail/veno_2022_immortal_poison_nova_drops.vpcf", context )
end


function chaotic_summon_insects_verdant_predator:IsSummonSpell()return true end

function chaotic_summon_insects_verdant_predator:OnSpellStart()

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

	local unit = caster:SummonUnit("npc_hd_verdant_predator",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/econ/items/venomancer/veno_2022_immortal_tail/veno_2022_immortal_poison_nova_drops.vpcf", PATTACH_POINT, unit)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	-- ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(infest_particle, 1, Vector(200,0,0))
	-- ParticleManager:SetParticleControl(infest_particle, 2, Vector(0.5,0,0))
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_Venomancer.Latent_Poison")
	-- unit:StartGesture(ACT_DOTA_SPAWN)
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_insects_verdant_predator_buff", {})

end


modifier_chaotic_summon_insects_verdant_predator_buff = advanced_modifier({})

function modifier_chaotic_summon_insects_verdant_predator_buff:IsDebuff() return false end
function modifier_chaotic_summon_insects_verdant_predator_buff:IsHidden() return true end
function modifier_chaotic_summon_insects_verdant_predator_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_insects_verdant_predator_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_insects_verdant_predator_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_insects_verdant_predator_buff:OnCreated(keys)
	if IsServer() then
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_ray_of_sickness")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.poison_index = self:GetAbility():GetSpecialValueFor("poison_index")*0.01
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(10)
			self.creep_ability:SetFrozenCooldown(true)
			-- self.lighting:StartCooldown(600)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_insects_verdant_predator_buff:OnIntervalThink()
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
			-- ExecuteOrderFromTable({
			-- 	UnitIndex = parent:entindex(),
			-- 	OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			-- 	Position = target:GetAbsOrigin(),
			-- 	AbilityIndex = self.lighting:entindex(),
			-- 	Queue = false,
			-- })
			parent:CastAbilityOnTarget(target, self.creep_ability, parent:GetPlayerOwnerID())
			-- parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.lighting, parent:GetPlayerOwnerID())
		end
	-- else
	-- 	self.lighting:StartCooldown(600)
	end
end


function modifier_chaotic_summon_insects_verdant_predator_buff:ADDeclareFunctions()
	local funcs = {

		advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
	if self:GetAbility():GetRuneType()==1 then
		self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
		table.insert(funcs,advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS)
	end

	return funcs

end


function modifier_chaotic_summon_insects_verdant_predator_buff:Advanced_GetModifier_CastPoint() 
	return 100
end

function modifier_chaotic_summon_insects_verdant_predator_buff:Advanced_GetModifierCastRangeBonusStacking() 
	return 2500
end

function modifier_chaotic_summon_insects_verdant_predator_buff:Advanced_GetModifierAttackRangeBonus() 
	return self.bonus_attack_range
end


function modifier_chaotic_summon_insects_verdant_predator_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker==self:GetParent() then
		if not self:GetCaster() then
			return
		end
		if not self:GetAbility() then
			return
		end
		keys.target:Poison(self:GetCaster(), self:GetAbility(), self.poison_index*keys.attacker:GetAverageTrueAttackDamage(nil))
	end
end


