

LinkLuaModifier("modifier_creeps_spell_Counter_Helix_passive", "creeps_spell/creeps_spell_Counter_Helix", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Counter_time", "creeps_spell/creeps_spell_Counter_Helix", LUA_MODIFIER_MOTION_NONE)

creeps_spell_Counter_Helix =class({})

function creeps_spell_Counter_Helix:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function creeps_spell_Counter_Helix:GetIntrinsicModifierName()
	return "modifier_creeps_spell_Counter_Helix_passive"
end

-------------------------------------------
-- Counter Helix modifier
-------------------------------------------

modifier_creeps_spell_Counter_Helix_passive =  class({})


function modifier_creeps_spell_Counter_Helix_passive:IsDebuff()			    return false end
function modifier_creeps_spell_Counter_Helix_passive:IsHidden() 			return true end
function modifier_creeps_spell_Counter_Helix_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Counter_Helix_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Counter_Helix_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Counter_Helix_passive:OnCreated(table)
	self.damage = 50
	self.radius = 200
	self.trigger = 0
	self.count = 0
end
function modifier_creeps_spell_Counter_Helix_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		-- MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_creeps_spell_Counter_Helix_passive:GetMinHealth() 
        return 100000
end


function modifier_creeps_spell_Counter_Helix_passive:OnTakeDamage(keys)
	-- "Cannot proc on attacks from buildings, wards and allies."
	if(keys.unit == self:GetParent() ) then
		if not self:GetAbility():IsCooldownReady() then
			return
		end
		--刃甲伤害不要
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			return
		end
		--生命丢失也不要
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
			return 0
		end
		if self.count >=1 then
			self.count = 0
			self:Spin(self.allow_repeat)
			-- self:GetAbility():UseResources(true, true, true,true)
			self:GetAbility():StartCooldown(0.1)
		else
			self.count = self.count +1
		end
		
		if self.trigger == 0 then

			self.trigger = 1
            self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_kill", {duration = 60})
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_creeps_spell_Counter_time", {duration = 60})
		end
		
	end
end

function modifier_creeps_spell_Counter_Helix_passive:Spin( repeat_allowed )
	self.caster = self:GetParent()
	self.helix_pfx_1 = ParticleManager:CreateParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(self.helix_pfx_1, 0, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.helix_pfx_1)

--	self.helix_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
--	ParticleManager:SetParticleControl(self.helix_pfx_2, 0, self.caster:GetAbsOrigin())
--	ParticleManager:ReleaseParticleIndex(self.helix_pfx_2)

	self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self.caster:EmitSound("Hero_Axe.CounterHelix")

	local radius = self.radius
	local damage = self.damage
	self.damage = self.damage +1
	self.radius = self.radius + 4
	-- Find nearby enemies
	self.enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, radius, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	-- Apply damage to valid enemies
	for _,enemy in pairs(self.enemies) do
		-- If an enemy is tauned, increase damage on it
		ApplyDamage({attacker = self.caster, victim = enemy, ability = self:GetAbility(), damage = damage*2, damage_type = DAMAGE_TYPE_PURE})
	end
end

function modifier_creeps_spell_Counter_Helix_passive:OnDestroy(keys)
    if not IsServer() then
        return
    end

    -- if keys.unit == self:GetParent() then
        local gold = 0
		local radius = self.radius - 200
		if radius < 100 then
			gold = 500
		elseif radius<200 then
			gold = 800
		elseif radius<300 then	
			gold = 1200
		elseif radius<400 then
			gold = 1800
		elseif radius<500 then
			gold = 2800
		elseif radius<600 then
			gold = 4000
		else
			gold = 4000+(radius-600)*15
		end
		local heroes = GetAllRealHeroes()
		for  _, hero in pairs(heroes) do
		--    hero:SetGold(hero:GetGold() + self.gold, true)
			hero:ModifyGoldFiltered(gold,true,DOTA_ModifyGold_CreepKill )
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,hero, gold, nil)
		end

	-- end
   
end



modifier_creeps_spell_Counter_time =  class({})


function modifier_creeps_spell_Counter_time:IsDebuff()			    return false end
function modifier_creeps_spell_Counter_time:IsHidden() 			return false end
function modifier_creeps_spell_Counter_time:IsPurgable() 		    return false end
function modifier_creeps_spell_Counter_time:IsPurgeException() 	return false end