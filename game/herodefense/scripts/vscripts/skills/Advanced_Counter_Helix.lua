--特效优化 √
Advanced_Counter_Helix = class({})

LinkLuaModifier("modifier_Advanced_Counter_Helix", "skills/Advanced_Counter_Helix", LUA_MODIFIER_MOTION_NONE)
require("internal.timers")

function Advanced_Counter_Helix:CheckKV(key)
	local table = {
		radius =10,
		damage = 6,
		bonus_damage = 0.06,
		proc_chance = 0.3,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Counter_Helix:UnlockFirstCore(key)
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Counter_Helix")
	if modifier then
		modifier:StartIntervalThink(1)
	end
	return true
end
function Advanced_Counter_Helix:UnlockSecondCore(key)
	return true
end
function Advanced_Counter_Helix:UnlockThirdCore(key)

	return true
end


function Advanced_Counter_Helix:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		end
		
	end
	return self.BaseClass.GetBehavior(self)
end


function Advanced_Counter_Helix:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Counter_Helix")
	if modifier and modifier:GetStackCount()>=1 then
		modifier:StartIntervalThink(0.2)
	end
end


function Advanced_Counter_Helix:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/counterhelix/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/counterhelix/unlock1_plus/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_counterhelix_ad.vpcf", context )

	
	

end




function Advanced_Counter_Helix:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Advanced_Counter_Helix:GetIntrinsicModifierName() return "modifier_Advanced_Counter_Helix" end
function Advanced_Counter_Helix:Spawn()
	if not IsServer() then return end
	self:GetCaster().Advanced_Counter_Helix_bonus_damage = 0
	self:GetCaster().Advanced_Counter_Helix_bonus_radius = 0
end



function Advanced_Counter_Helix:GetCastRange(vLocation, hTarget) 

	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	-- local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	return  self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() 
end


modifier_Advanced_Counter_Helix = class({})

function modifier_Advanced_Counter_Helix:IsDebuff()				return false end
function modifier_Advanced_Counter_Helix:IsPurgable() 			return false end
function modifier_Advanced_Counter_Helix:IsPurgeException() 	return false end
function modifier_Advanced_Counter_Helix:IsHidden()				return self:GetStackCount()<=0 end
function modifier_Advanced_Counter_Helix:RemoveOnDeath() return false end
function modifier_Advanced_Counter_Helix:OnIntervalThink()
	if self:GetAbility().unlock3 then
		self:Helix(true)
		self:DecrementStackCount()
		if self:GetStackCount()<=0 then
			self:StartIntervalThink(-1)
		end
		return
	end
	if Game_State:IsInBattle() and self:GetParent():IsMoving() then
		self:Helix_Unlock1()
		
	end
	
end
function modifier_Advanced_Counter_Helix:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

function modifier_Advanced_Counter_Helix:Helix(unlock3)
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock1 then
			self:Helix_Unlock1()
			return
		end
		local parent = self:GetParent()
		local caster = self:GetCaster()

		-- parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		parent:EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")

		local dmg = ability:GetSpecialValueFor("damage")+ parent:GetStrength() * (ability:GetSpecialValueFor("bonus_damage"))

		local particle_name = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
		--LV20解锁血能
		if self.level>=20 then
			if caster:GetHealthPercent()>70 then
				local health_reduce = caster:GetMaxHealth()*0.01
				caster:SetHealth(caster:GetHealth()-health_reduce)
				dmg = dmg +health_reduce*2
				particle_name = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf"
			end
		end
		if unlock3 then
			particle_name = 'particles/units/heroes/hero_axe/axe_counterhelix_ad.vpcf'
		end

		local pfx1 = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(pfx1)
		ParticleManager:ReleaseParticleIndex(pfx2)

		dmg = dmg*(1+caster.Advanced_Counter_Helix_bonus_damage)

		local radius = ability:GetSpecialValueFor("radius")+math.min(caster.Advanced_Counter_Helix_bonus_radius ,500)

		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i,enemy in pairs(enemies) do
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = dmg,
								damage_type = ability:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = ability, --Optional.
								}
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
		caster.Advanced_Counter_Helix_bonus_damage = caster.Advanced_Counter_Helix_bonus_damage+0.05
		caster.Advanced_Counter_Helix_bonus_radius = caster.Advanced_Counter_Helix_bonus_radius +10

		local reduce_time = 15
		--LV5解锁动能维续+
		if self.level>=5 then
			reduce_time = 25
		end
		
		Timers:CreateTimer(reduce_time, function()
			caster.Advanced_Counter_Helix_bonus_damage = caster.Advanced_Counter_Helix_bonus_damage-0.05
			caster.Advanced_Counter_Helix_bonus_radius = caster.Advanced_Counter_Helix_bonus_radius -10
		end)
	end

end


function modifier_Advanced_Counter_Helix:Helix_Unlock1()
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local caster = self:GetCaster()

		-- parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		parent:EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")

		local dmg = ability:GetSpecialValueFor("damage")+ parent:GetStrength() * (ability:GetSpecialValueFor("bonus_damage"))

		local particle_name = "particles/rebuild/spell/counterhelix/unlock1_plus/effect.vpcf"
		--解锁血能
		if caster:GetHealthPercent()>70 then
			local health_reduce = caster:GetMaxHealth()*0.01
			caster:SetHealth(caster:GetHealth()-health_reduce)
			dmg = dmg +health_reduce*2
			particle_name = "particles/rebuild/spell/counterhelix/unlock1/effect.vpcf"
		end
		local radius = ability:GetSpecialValueFor("radius")+math.min(caster.Advanced_Counter_Helix_bonus_radius ,500)
		local pfx1 = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx1, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx1, 61, Vector(radius, 0, 0))
		ParticleManager:SetParticleControlEnt(pfx1, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx1, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true)
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(pfx1)
		ParticleManager:ReleaseParticleIndex(pfx2)

		dmg = dmg*(1+caster.Advanced_Counter_Helix_bonus_damage)



		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i,enemy in pairs(enemies) do
			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = dmg,
								damage_type = ability:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = ability, --Optional.
								}
			ApplyDamage(damageTable)
			if i>=7 then
				break
			end
		end
		caster.Advanced_Counter_Helix_bonus_damage = caster.Advanced_Counter_Helix_bonus_damage+0.10
		caster.Advanced_Counter_Helix_bonus_radius = caster.Advanced_Counter_Helix_bonus_radius +20

		local reduce_time = 25

		
		Timers:CreateTimer(reduce_time, function()
			caster.Advanced_Counter_Helix_bonus_damage = caster.Advanced_Counter_Helix_bonus_damage-0.10
			caster.Advanced_Counter_Helix_bonus_radius = caster.Advanced_Counter_Helix_bonus_radius -20
		end)
	end

end



function modifier_Advanced_Counter_Helix:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if self:GetParent():PassivesDisabled() or not ability:IsCooldownReady() or not self:GetParent():IsAlive() then
		return
	end

	if ability.unlock2 or keys.target == self:GetParent() then
		if self:GetParent():IsHexed() then
			return
		end
	
		self.level =ability.advanced_level
		local chance = ability:GetSpecialValueFor("proc_chance")
		if not (self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100)) then
			return
		end
		--LV15解锁快速冷却
		if self.level>=15 then
			ability:StartCooldown(0.05)
		else
			ability:UseResources(true, true, true, true)
		end
		
		self:Helix()
		if ability.unlock3 then
			self:SetStackCount(math.min(50,self:GetStackCount()+1))
		end
		if self:GetCaster():GetRandomEffect(25,INT_TYPE,1) >=RandomInt(1, 100) then
			Timers:CreateTimer(0.1, function()
				self:Helix()
				if ability.unlock3 then
					self:SetStackCount(math.min(50,self:GetStackCount()+1))
				end
				
				--LV10解锁喜加一+
				if self.level>=10 and self:GetCaster():GetRandomEffect(40,INT_TYPE,1) >=RandomInt(1, 100) then
					Timers:CreateTimer(0.1, function()
						if self and not self:IsNull() then
							self:Helix()
							if ability.unlock3 then
								self:SetStackCount(math.min(50,self:GetStackCount()+1))
							end
						end
					end)
				
				end
			end)


	
		end
		
	end
end
