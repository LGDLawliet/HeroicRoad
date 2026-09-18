--特效优化 √


LinkLuaModifier("modifier_Advanced_Lightning_Bolt_debuff", "skills/Advanced_Lightning_Bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Lightning_Bolt_passive", "skills/Advanced_Lightning_Bolt", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
Advanced_Lightning_Bolt = class({})
function Advanced_Lightning_Bolt:CheckKV(key)
	local table = {

	

		basic_damage = 10,
		bonus_damage = 0.1,



	}
	local value = table[key] or -1
	return value

end

function Advanced_Lightning_Bolt:UnlockFirstCore(key)
	return true
end
function Advanced_Lightning_Bolt:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Lightning_Bolt_passive",{})
	return true
end
function Advanced_Lightning_Bolt:UnlockThirdCore(key)
	return true
end
function Advanced_Lightning_Bolt:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/invincible_army/lightning/lightning_bolt.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context )
	
	

end
function Advanced_Lightning_Bolt:GetCooldown(iLevel)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return 7
		end
	end
	return 10
end

function Advanced_Lightning_Bolt:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AOE
		elseif coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		elseif coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_AOE
		end
		
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function Advanced_Lightning_Bolt:GetAOERadius()
	return self:GetSpecialValueFor("spread_aoe")	 
end

function Advanced_Lightning_Bolt:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")

	return true
end

function Advanced_Lightning_Bolt:OnSpellStart()
	if IsServer() then
		local caster 		= self:GetCaster()
		local target_point 	= self:GetCursorPosition()
		local target 		= self:GetCursorTarget()
		--local item = self:GetCaster():HasItemInInventory("item_hd_thunder")

		if self.unlock3 then
			local true_sight_radius 	= self:GetSpecialValueFor("true_sight_radius")
			local sight_duration 		= self:GetSpecialValueFor("sight_duration")
			CreateModifierThinker(caster, ability, "modifier_true_sight_dummy", {duration = sight_duration,stack=true_sight_radius},  Vector(target_point.x, target_point.y, 0), caster:GetTeamNumber(), false)


			local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, caster)

			ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, 5000))
			ParticleManager:SetParticleControl(particle, 1, target_point)
			-- ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
			ParticleManager:ReleaseParticleIndex(particle)
			caster:EmitSound("Hero_Zuus.LightningBolt")

			local units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				self:GetSpecialValueFor("spread_aoe"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_NONE, 
				FIND_FARTHEST, 
				false
			)
			local damage = (self:GetSpecialValueFor("basic_damage") +(self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false))*2
			local damagetable= {
				attacker = caster,

				damage_type = self:GetAbilityDamageType(),
				ability = self,
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			}
	
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local stun_duration 		= self:GetSpecialValueFor("stun_duration")
			for _, unit in ipairs(units) do
				
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				local modifier = unit:FindModifierByName("modifier_Advanced_Lightning_Bolt_debuff")
				local bonus_damage_index = 1
				if modifier then
					bonus_damage_index = bonus_damage_index  +modifier:GetStackCount()*0.2
				end
				damagetable.damage			= damage * bonus_damage_index
				damagetable.victim 		= unit
				
				ApplyDamage(damagetable)

				unit:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration * StatusResistance})
				unit:AddNewModifier(caster, self, "modifier_Advanced_Lightning_Bolt_debuff", {duration = 50 * StatusResistance})
			end
			
			if #units>0 then
				local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, unit in ipairs(heroes) do
					if unit~=caster then
						local ability = unit:FindAbilityByName("Advanced_Lightning_Bolt")
						if ability then
							ability:CastLightningBolt(unit, ability, units[RandomInt(1, #units)], target_point)
							break
						end 
					end
					
				end
			end




		else
		
			if target:TriggerSpellAbsorb(self) then
				return
			end
	
			self:CastLightningBolt(caster, self, target, target_point)
			if self.unlock1 then
				local triggerMana = caster:GetManaPercent()-50
				if triggerMana>=10 then
					local count = math.floor(triggerMana/10)
					if count>0 then
						caster:SpendMana( caster:GetMaxMana()*count*0.05, self )
						for i = 1, count, 1 do
							self:CastLightningBolt(caster, self, target, target_point)
						end
					end
			
	
					
				end
	
			else
				--LV15解锁互感
				if self.advanced_level>=15 then
					local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
					for _, unit in ipairs(units) do
						if unit~=caster then
							local ability = unit:FindAbilityByName("Advanced_Lightning_Bolt")
							if ability and self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
								ability:CastLightningBolt(unit, ability, target, target_point)
								break
							end 
						end
						
					end
				end
			end
		end


	end
end

function Advanced_Lightning_Bolt:CastLightningBolt(caster, ability, target, target_point, nimbus)
	if IsServer() then
		local spread_aoe 			= ability:GetSpecialValueFor("spread_aoe")
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local stun_duration 		= ability:GetSpecialValueFor("stun_duration")
		local particleName = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
		if self.unlock2 then
			particleName = "particles/rebuild/spell/invincible_army/lightning/lightning_bolt.vpcf"
		end


		local z_pos 				= 3000

		if nimbus then
			nimbus:EmitSound("Hero_Zuus.LightningBolt")
		else
			caster:EmitSound("Hero_Zuus.LightningBolt")
		end
		if target == nil then
			return
		end
		local level = self.advanced_level

		target_point = target:GetAbsOrigin()
		local damage = ability:GetSpecialValueFor("basic_damage") +(ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
		local unit = target


		local modifier = unit:FindModifierByName("modifier_Advanced_Lightning_Bolt_debuff")
		local bonus_damage_index = 1
		if modifier then
			bonus_damage_index = bonus_damage_index  +modifier:GetStackCount()*0.15
		end

		local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
		local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
		ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, z_pos))
		ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration * StatusResistance})
		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= damage *bonus_damage_index
		damage_table.victim 		= unit
		damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		ApplyDamage(damage_table)

		local gain_duration = 15
		--LV10解锁电透+
		if level>=10 then
			gain_duration=25
		end
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Lightning_Bolt_debuff", {duration = gain_duration * StatusResistance})


		local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

			-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				target_flags, 
				FIND_FARTHEST, 
				false
			)
			if #nearby_enemy_units == 0 then
				return
			end

			local ex_unit = 2
			--LV20解锁魔法五重化
			if level>=20 and self:GetAutoCastState() and not self.unlock1 then
				if caster:GetManaPercent()>=50 then
					caster:SpendMana(caster:GetMaxMana()*0.1, self)
					ex_unit = 4
				end
				
			elseif self.unlock2 then
				ex_unit = 4
			end

			--LV5解锁
			if level>=5 then
				--可作用相同单位
				for i = 1, ex_unit do
					local unit = nearby_enemy_units[RandomInt(1, #nearby_enemy_units)]
					local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
					local pos = unit:GetAbsOrigin()
					if self.unlock1 then
						pos.x = pos.x + RandomInt(-1000, 1000)
						pos.y = pos.y + RandomInt(-1000, 1000)
					end
					ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, z_pos))
					ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
					-- ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
					ParticleManager:ReleaseParticleIndex(particle)
	
					local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration * StatusResistance})
	
	
					local modifier = unit:FindModifierByName("modifier_Advanced_Lightning_Bolt_debuff")
					local bonus_damage_index = 1
					if modifier then
						bonus_damage_index = bonus_damage_index  +modifier:GetStackCount()*0.15
					end
	
	
					local damage_table 			= {}
					damage_table.attacker 		= caster
					damage_table.ability 		= ability
					damage_table.damage_type 	= ability:GetAbilityDamageType() 
					damage_table.damage			= damage * bonus_damage_index
					damage_table.victim 		= unit
					damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
					ApplyDamage(damage_table)
	

					if not unit:IsNull() and unit:IsAlive() then
						unit:AddNewModifier(caster, ability, "modifier_Advanced_Lightning_Bolt_debuff", {duration = gain_duration * StatusResistance})
					end
					

				end
			else
				--无法作用相同单位
				local index = 0
				for _, unit in ipairs(nearby_enemy_units) do
					if unit~=target then
						local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
						local pos = unit:GetAbsOrigin()
						  ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
						ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, z_pos))
						ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
						ParticleManager:ReleaseParticleIndex(particle)
						local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
						local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
						unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration * StatusResistance})
		
		
		
						local modifier = unit:FindModifierByName("modifier_Advanced_Lightning_Bolt_debuff")
						local bonus_damage_index = 1
						if modifier then
							bonus_damage_index = bonus_damage_index  +modifier:GetStackCount()*0.15
						end
		
						local damage_table 			= {}
						damage_table.attacker 		= caster
						damage_table.ability 		= ability
						damage_table.damage_type 	= ability:GetAbilityDamageType() 
						damage_table.damage			= damage *bonus_damage_index
						damage_table.victim 		= unit
						damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
						ApplyDamage(damage_table)
		

						unit:AddNewModifier(caster, ability, "modifier_Advanced_Lightning_Bolt_debuff", {duration = gain_duration * StatusResistance})



						index = index +1
						if index>=2 then
							break
						end
					end
					
				end
			end




		CreateModifierThinker(caster, ability, "modifier_true_sight_dummy", {duration = sight_duration,stack=true_sight_radius},  Vector(target_point.x, target_point.y, 0), caster:GetTeamNumber(), false)


		


	end
end














modifier_Advanced_Lightning_Bolt_debuff = class({})

function modifier_Advanced_Lightning_Bolt_debuff:IsHidden()	return false end
function modifier_Advanced_Lightning_Bolt_debuff:IsDebuff()	return true end
function modifier_Advanced_Lightning_Bolt_debuff:IsPurgable()	return false end





function modifier_Advanced_Lightning_Bolt_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_Lightning_Bolt_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		
		if self:GetStackCount()>= 20 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_Lightning_Bolt_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end




modifier_Advanced_Lightning_Bolt_passive = class({})

function modifier_Advanced_Lightning_Bolt_passive:IsDebuff()			return false end
function modifier_Advanced_Lightning_Bolt_passive:IsHidden() 			return false end
function modifier_Advanced_Lightning_Bolt_passive:IsPurgable() 		return false end
function modifier_Advanced_Lightning_Bolt_passive:IsPurgeException() 	return false end
function modifier_Advanced_Lightning_Bolt_passive:RemoveOnDeath() return false end
function modifier_Advanced_Lightning_Bolt_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Lightning_Bolt_passive:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Lightning_Bolt_passive:OnIntervalThink()
	local ability = self:GetAbility()
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	local caster = self:GetCaster()
	if caster:IsSilenced() or not caster:IsAlive() then
		return
	end
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if unit then
			ability:UseResources(false, true, true,true)
			-- caster:CastAbilityOnTarget(unit,ability, caster:GetPlayerID())
			caster:SetCursorCastTarget(unit)

			ability:OnSpellStart()
			break
		end
	end
		
end