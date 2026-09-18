chaotic_summon_insects_fanged_seeker = class({})

LinkLuaModifier("modifier_chaotic_summon_insects_fanged_seeker_buff", "chaotic_spell/class_8/chaotic_summon_insects_fanged_seeker", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_chaotic_summon_insects_fanged_seeker_passive", "chaotic_spell/class_6/chaotic_summon_insects_fanged_seeker", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff", "chaotic_spell/class_8/chaotic_summon_insects_fanged_seeker", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_insects_fanged_seeker:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/venomancer/veno_2022_immortal_tail/veno_2022_immortal_poison_nova_drops.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_latent_poison_projectile_endcap.vpcf", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_noxious_plague_projectile.vpcf", context )


	
	
end


function chaotic_summon_insects_fanged_seeker:IsSummonSpell()return true end

function chaotic_summon_insects_fanged_seeker:OnSpellStart()

	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	
	local caster =self:GetCaster()
	local gain = self:GetEffectGain()
	local base_health = self:GetSpecialValueFor("base_health")*gain
	local base_armor = self:GetSpecialValueFor("base_armor")*gain


	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()+base_health
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)+base_armor

	local bonus_base_atk = self:GetSpecialValueFor("base_damage")
	local damage = (self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+gain*bonus_base_atk)
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 

	local unit = caster:SummonUnit("npc_hd_fanged_seeker",life_duration,
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
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_insects_fanged_seeker_buff", {})

end


function chaotic_summon_insects_fanged_seeker:OnProjectileHit_ExtraData(target, location, keys)
	local caster = self:GetCaster()
	if not target then
		-- EmitSoundOnLocationWithCaster(location, "chaotic_magic_missile_hit", caster)
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end
	if keys.rune_1_posion_record then
		target:EmitSound("Hero_Venomancer.NoxiousPlague.Damage")
		target:Poison(self:GetCaster(), self, keys.rune_1_posion_record)
	end


	

end




modifier_chaotic_summon_insects_fanged_seeker_buff = advanced_modifier({})

function modifier_chaotic_summon_insects_fanged_seeker_buff:IsDebuff() return false end
function modifier_chaotic_summon_insects_fanged_seeker_buff:IsHidden() return false end
function modifier_chaotic_summon_insects_fanged_seeker_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_insects_fanged_seeker_buff:IsPurgeException() 	return false end
-- function modifier_chaotic_summon_insects_fanged_seeker_buff:RemoveOnDeath()  return false end
function modifier_chaotic_summon_insects_fanged_seeker_buff:OnCreated(keys)
	if IsServer() then
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_ray_of_sickness")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.require_count = self:GetAbility():GetSpecialValueFor("require_count")
		self.poison_active_index = self:GetAbility():GetSpecialValueFor("poison_active_index")
		self.poison_index = self:GetAbility():GetSpecialValueFor("poison_index")*0.01
		self:SetStackCount(self.require_count)
		self.timer =  GameRules:GetGameTime()
		if self:GetAbility():GetRuneType()==1 then
			self.rune_1_posion_record = 0
		end
		if self:GetAbility():GetRuneType()==2 then
			self.rune_2_record = {}
			self.rune_2_bonus = self:GetAbility():GetSpecialValueFor("rune_2_bonus")*0.01
			self.rune_2_duration =  self:GetAbility():GetSpecialValueFor("rune_2_duration")
		end
		if self.creep_ability then
			self.creep_ability:SetFrozenCooldown(true)
			-- self.lighting:StartCooldown(600)
			-- self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_insects_fanged_seeker_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability then
			if self.rune_1_posion_record and self.rune_1_posion_record>=1 then
				local radius = ability:GetSpecialValueFor("rune_1_radius")
				self.rune_1_posion_record = self.rune_1_posion_record * (ability:GetSpecialValueFor("rune_1_bonus")*0.01)
				local parent = self:GetParent()
				local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

				local info = 
				{
					-- Target = target,
					Source = parent,
					Ability = ability,	
					EffectName = "particles/units/heroes/hero_venomancer/venomancer_noxious_plague_projectile.vpcf",
					iMoveSpeed = 1000,
					vSourceLoc = parent:GetAbsOrigin(),
					bDrawsOnMinimap = false,  --？？
					bDodgeable = true,   --可躲闪
					bIsAttack = false,   --攻击效果
					bVisibleToEnemies = true,  --对敌人可视
					bReplaceExisting = false, --替换现有的
					flExpireTime = GameRules:GetGameTime() + 10, --存在时间
					bProvidesVision = false, --提供视野
					ExtraData = {
						rune_1_posion_record =self.rune_1_posion_record
					}   --额外的数据
				}
				parent:EmitSound("Conquest.PoisonTrap.Generic")
				for index, unit in ipairs(units) do
					info.Target = unit
					ProjectileManager:CreateTrackingProjectile(info)
				end
			end
			
		
		end
	end

end






-- function modifier_chaotic_summon_insects_fanged_seeker_buff:OnIntervalThink()
-- 	local parent = self:GetParent()
-- 	if not parent:IsAlive() then
-- 		return
-- 	end
	
-- 	local time =  GameRules:GetGameTime()
-- 	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
-- 		local target = parent:GetAggroTarget()
-- 		if target then
-- 			self.creep_ability:EndCooldown()
-- 			self.timer = time + self.interval
-- 			-- ExecuteOrderFromTable({
-- 			-- 	UnitIndex = parent:entindex(),
-- 			-- 	OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
-- 			-- 	Position = target:GetAbsOrigin(),
-- 			-- 	AbilityIndex = self.lighting:entindex(),
-- 			-- 	Queue = false,
-- 			-- })
-- 			parent:CastAbilityOnTarget(target, self.creep_ability, parent:GetPlayerOwnerID())
-- 			-- parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.lighting, parent:GetPlayerOwnerID())
-- 		end
-- 	-- else
-- 	-- 	self.lighting:StartCooldown(600)
-- 	end
-- end


function modifier_chaotic_summon_insects_fanged_seeker_buff:ADDeclareFunctions()
	local funcs = {

		-- advanced_MODIFIER_PROPERTY_CastPoint,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only
    }

	return funcs

end


function modifier_chaotic_summon_insects_fanged_seeker_buff:Advanced_GetModifier_CastPoint() 
	return 100
end



function modifier_chaotic_summon_insects_fanged_seeker_buff:OnAttackLanded(keys)
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
		self:DecrementStackCount()
		if self:GetStackCount()<=0 then
			self:SetStackCount(self.require_count)
			local poison = keys.target:ActivePoison(self:GetCaster(), self:GetAbility(), self.poison_active_index,0)
			if self.rune_1_posion_record then
				self.rune_1_posion_record = self.rune_1_posion_record + poison
			end
			local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_latent_poison_projectile_endcap.vpcf", PATTACH_POINT, keys.target)
			-- ParticleManager:SetParticleControl(infest_particle, 0, keys.target_pos)
			ParticleManager:SetParticleControlEnt( infest_particle, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc" , keys.target:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( infest_particle, 3, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc" , keys.target:GetOrigin(), true )
			-- ParticleManager:SetParticleControl(infest_particle, 1, Vector(200,0,0))
			-- ParticleManager:SetParticleControl(infest_particle, 2, Vector(0.5,0,0))
			ParticleManager:ReleaseParticleIndex(infest_particle)
			keys.target:EmitSound("hero_viper.poisonAttack.Cast")


			
			
		end
		if self.rune_2_record and not self.rune_2_record[keys.target] then
			self.rune_2_record[keys.target] = true
			local stack = self.rune_2_bonus * self:GetParent():GetAverageTrueAttackDamage(nil)
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff", {duration = self.rune_2_duration,stack=stack})
			
		end
	end
end



function modifier_chaotic_summon_insects_fanged_seeker_buff:Advanced_GetModifier_FlyingPathing()	
	return 1
end



modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff = advanced_modifier({})

function modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff:IsDebuff() return true end
function modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff:IsHidden() return false end
function modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff:IsPurgable() 		return false end
function modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff:IsPurgeException() 	return false end
function modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_summon_insects_fanged_seeker_rune_2_debuff:OnIntervalThink()
	self:GetParent():Poison(self:GetCaster(), self:GetAbility(), self:GetStackCount())
end