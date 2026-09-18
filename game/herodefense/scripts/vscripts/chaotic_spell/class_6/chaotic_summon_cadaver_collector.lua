chaotic_summon_cadaver_collector = class({})

LinkLuaModifier("modifier_chaotic_summon_cadaver_collector_buff", "chaotic_spell/class_6/chaotic_summon_cadaver_collector", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_cadaver_collector_passive", "chaotic_spell/class_6/chaotic_summon_cadaver_collector", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_cadaver_collector:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_loadout.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", context )

	
end

function chaotic_summon_cadaver_collector:GetIntrinsicModifierName()
	return "modifier_chaotic_summon_cadaver_collector_passive"
end

function chaotic_summon_cadaver_collector:IsSummonSpell()return true end
function chaotic_summon_cadaver_collector:Spawn()
	self.stack = 0
end
function chaotic_summon_cadaver_collector:GetStack()
	return self.stack 
end

function chaotic_summon_cadaver_collector:InCrementStack()
	self.stack   = self.stack  + 1
	local modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
	if modifier then
		modifier:SetStackCount(self.stack)
	end
end
function chaotic_summon_cadaver_collector:OnSpellStart()

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
	local bonus_base_atk = self:GetSpecialValueFor("base_damage") + self.stack*self:GetSpecialValueFor("bonus_atk_per_kill")
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+gain*bonus_base_atk)
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_cadaver_collector",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_POINT, unit)
	-- ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Greevil.FleshGolem.Cast")
	unit:AddActivityModifier("loadout")
	unit:GameTimer(0.06, function()
		unit:StartGesture(ACT_DOTA_SPAWN)
	end)
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_cadaver_collector_buff", {})

end


modifier_chaotic_summon_cadaver_collector_buff = advanced_modifier({})

function modifier_chaotic_summon_cadaver_collector_buff:IsDebuff() return false end
function modifier_chaotic_summon_cadaver_collector_buff:IsHidden() return true end
function modifier_chaotic_summon_cadaver_collector_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_cadaver_collector_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_cadaver_collector_buff:RemoveOnDeath()  return false end



function modifier_chaotic_summon_cadaver_collector_buff:ADDeclareFunctions()
	local funcs = {}
	funcs["MODIFIER_EVENT_ON_DEATH"] = {self:GetParent(), nil}
    
	if self:GetAbility():GetRuneType()==1 then
		funcs["MODIFIER_EVENT_ON_DEATH"]= {nil, nil}--ADD事件cy
	end
    return funcs
end

function modifier_chaotic_summon_cadaver_collector_buff:OnDeath(keys)
	if IsServer() then

		local unit = keys.unit
		local attacker = keys.attacker
		
		if IsEnemy(unit,attacker) then
			if attacker:GetPlayerOwnerID()~=self:GetParent():GetPlayerOwnerID() then
				return
			end
			
			local ability = self:GetAbility()
			if ability then
				ability:InCrementStack()
				attacker:StartGesture(ACT_DOTA_UNDYING_SOUL_RIP)

				local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_POINT, attacker)
				-- ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
				ParticleManager:SetParticleControlEnt( infest_particle, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc" , attacker:GetOrigin(), true )
				ParticleManager:SetParticleControlEnt( infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
				ParticleManager:SetParticleControlEnt( infest_particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc" , unit:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex(infest_particle)
				

			end

		end
	end
end




modifier_chaotic_summon_cadaver_collector_passive = advanced_modifier({})

function modifier_chaotic_summon_cadaver_collector_passive:IsDebuff() return false end
function modifier_chaotic_summon_cadaver_collector_passive:IsHidden() return false end
function modifier_chaotic_summon_cadaver_collector_passive:IsPurgable() 		return false end
function modifier_chaotic_summon_cadaver_collector_passive:IsPurgeException() 	return false end
function modifier_chaotic_summon_cadaver_collector_passive:RemoveOnDeath()  return false end
function modifier_chaotic_summon_cadaver_collector_passive:OnCreated(keys)
	self.bonus_atk_per_kill = self:GetAbility():GetSpecialValueFor("bonus_atk_per_kill")
	if IsServer() then
		self:SetStackCount(self:GetAbility():GetStack())
	end
end

function modifier_chaotic_summon_cadaver_collector_passive:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end


function modifier_chaotic_summon_cadaver_collector_passive:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus_atk_per_kill * self:GetStackCount()
	end
end
