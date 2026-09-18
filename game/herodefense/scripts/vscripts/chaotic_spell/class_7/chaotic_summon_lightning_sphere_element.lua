chaotic_summon_lightning_sphere_element = class({})

LinkLuaModifier("modifier_chaotic_summon_lightning_sphere_element_buff", "chaotic_spell/class_7/chaotic_summon_lightning_sphere_element", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_summon_lightning_sphere_element_passive", "chaotic_spell/class_6/chaotic_summon_lightning_sphere_element", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_lightning_sphere_element:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", context )
end
function chaotic_summon_lightning_sphere_element:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end

-- function chaotic_summon_lightning_sphere_element:GetIntrinsicModifierName()
-- 	return "modifier_chaotic_summon_lightning_sphere_element_passive"
-- end

function chaotic_summon_lightning_sphere_element:IsSummonSpell()return true end
-- function chaotic_summon_lightning_sphere_element:Spawn()
-- 	self.stack = 0
-- end
-- function chaotic_summon_lightning_sphere_element:GetStack()
-- 	return self.stack 
-- end

-- function chaotic_summon_lightning_sphere_element:InCrementStack()
-- 	self.stack   = self.stack  + 1
-- 	local modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
-- 	if modifier then
-- 		modifier:SetStackCount(self.stack)
-- 	end
-- end
function chaotic_summon_lightning_sphere_element:GetManaCost(iLevel)
	local base_cost =  self.BaseClass.GetManaCost(self,iLevel)
	if self:GetRuneType()==1 and self:GetAutoCastState() then
		local cost = self:GetSpecialValueFor("rune_1_bonus")*0.01*self:GetCaster():GetMaxMana()
		cost = math.min(cost,self:GetSpecialValueFor("rune_1_max_cost"))
		base_cost = base_cost + cost
		if IsServer() then
			self.rune_1_cost = cost
		end
	end
	return base_cost
end

function chaotic_summon_lightning_sphere_element:OnSpellStart()

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

	local unit = caster:SummonUnit("npc_hd_lightning_sphere_element",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_POINT, unit)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	ParticleManager:SetParticleControl(infest_particle, 1, Vector(200,0,0))
	ParticleManager:SetParticleControl(infest_particle, 2, Vector(0.5,0,0))
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_Zuus.StaticField")
	-- unit:StartGesture(ACT_DOTA_SPAWN)

	
	if self.rune_1_cost and self:GetAutoCastState() then
		-- local require = self:GetSpecialValueFor("rune_1_require")

		unit:AddNewModifier(caster, self, "modifier_chaotic_summon_lightning_sphere_element_buff", {rune_1_cost=self.rune_1_cost})
	else
		unit:AddNewModifier(caster, self, "modifier_chaotic_summon_lightning_sphere_element_buff", {})
	end
end


modifier_chaotic_summon_lightning_sphere_element_buff = advanced_modifier({})

function modifier_chaotic_summon_lightning_sphere_element_buff:IsDebuff() return false end
function modifier_chaotic_summon_lightning_sphere_element_buff:IsHidden() return false end
function modifier_chaotic_summon_lightning_sphere_element_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_lightning_sphere_element_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_lightning_sphere_element_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_lightning_sphere_element_buff:OnCreated(keys)
	if IsServer() then
		self.lighting = self:GetParent():FindAbilityByName("chaotic_lightning_bolt")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.timer =  GameRules:GetGameTime()
		if keys.rune_1_cost then
			self.interval = self.interval - math.floor(keys.rune_1_cost/self:GetAbility():GetSpecialValueFor("rune_1_require"))*self:GetAbility():GetSpecialValueFor("rune_1_reduce")
		end

		if self.lighting then
			self.lighting:StartCooldown(5)
			self.lighting:SetFrozenCooldown(true)
			
			self:StartIntervalThink(0.2)
		end
		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_chaotic_summon_lightning_sphere_element_buff:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.lighting:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.lighting:EndCooldown()
			self.timer = time + self.interval
			-- ExecuteOrderFromTable({
			-- 	UnitIndex = parent:entindex(),
			-- 	OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			-- 	Position = target:GetAbsOrigin(),
			-- 	AbilityIndex = self.lighting:entindex(),
			-- 	Queue = false,
			-- })
			parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.lighting, parent:GetPlayerOwnerID())
		end
	-- else
	-- 	self.lighting:StartCooldown(600)
	end
end


function modifier_chaotic_summon_lightning_sphere_element_buff:ADDeclareFunctions()
	local funcs = {

		advanced_MODIFIER_PROPERTY_CastPoint
    }

	return funcs

end


function modifier_chaotic_summon_lightning_sphere_element_buff:Advanced_GetModifier_CastPoint() 
	return 100
end


function modifier_chaotic_summon_lightning_sphere_element_buff:AddCustomTransmitterData( )
	return
	{
		interval = self.interval,
	}
end

function modifier_chaotic_summon_lightning_sphere_element_buff:HandleCustomTransmitterData( data )
	self.interval = data.interval
end




function modifier_chaotic_summon_lightning_sphere_element_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end







function modifier_chaotic_summon_lightning_sphere_element_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1+ 1
	if self._tooltip == 1 then
		return  self.interval
	end
end
