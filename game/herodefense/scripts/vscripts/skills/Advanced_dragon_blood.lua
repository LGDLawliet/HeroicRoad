--特效优化 √
Advanced_dragon_blood = class({})
-- LinkLuaModifier("modifier_Advanced_dragon_blood_arua", "items/Advanced_dragon_blood", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_dragon_blood_arua_effect", "items/Advanced_dragon_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_dragon_blood", "skills/Advanced_dragon_blood", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_dragon_blood_active", "skills/Advanced_dragon_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_dragon_blood_unlock3_passive", "skills/Advanced_dragon_blood", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
-- require('internal/timers')   --计时器功能
function Advanced_dragon_blood:GetIntrinsicModifierName()
	return "modifier_Advanced_dragon_blood"
end


function Advanced_dragon_blood:CheckKV(key)
	local table = {

		bonus_health_regeneration =2,
		bonus_armor = 0.5,

	}
	local value = table[key] or -1
	return value

end



function Advanced_dragon_blood:UnlockFirstCore(key)
	return true
end
function Advanced_dragon_blood:UnlockSecondCore(key)
	return true
end
function Advanced_dragon_blood:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_dragon_blood_unlock3_passive",{})
	return true
end

function Advanced_dragon_blood:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/dragon_blood/unlock3/effect.vpcf", context )

end
function Advanced_dragon_blood:EarthElementUnlock1(unit)
	unit:AddNewModifier(self:GetCaster(),self,"modifier_Advanced_dragon_blood",{})
	if self.unlock3 then
		unit:AddNewModifier(self:GetCaster(),self,"modifier_Advanced_dragon_blood_unlock3_passive",{})
	end
end

modifier_Advanced_dragon_blood = advanced_modifier({})

function modifier_Advanced_dragon_blood:IsDebuff() return false end
function modifier_Advanced_dragon_blood:IsHidden() return false end
function modifier_Advanced_dragon_blood:IsPurgable() 		return false end
function modifier_Advanced_dragon_blood:IsPurgeException() 	return false end
function modifier_Advanced_dragon_blood:RemoveOnDeath()  return false end
function modifier_Advanced_dragon_blood:DestroyOnExpire()	return false end
function modifier_Advanced_dragon_blood:OnCreated(table)
	self.advanced_level = 1
	self:StartIntervalThink(0.1)
	-- if IsServer() then
	-- 	self:StartIntervalThink(0.1)
	-- end
end

function modifier_Advanced_dragon_blood:OnIntervalThink(table)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	-- self.bonus_health_regeneration = self:GetAbility():GetSpecialValueFor("bonus_health_regeneration")
	-- self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	if IsServer() then
		if not self:GetAbility() then
			return 0
		end
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local caster = self:GetCaster()
		--LV15龙吼
		if self.advanced_level>=15 and  self:GetRemainingTime()<0 and parent:IsAlive() then
			if ability.unlock1 then
				self:SetDuration(10, true)
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				parent:EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
				--伤害与眩晕
				local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
		   		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
				local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
				local damagetable= {
					attacker = caster,
					damage = parent:GetHealthRegen()*10,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = ability,
					}
				
			   	for i, unit in pairs(units) do
					local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					unit:AddNewModifier(parent, ability, "modifier_stunned", {duration = 1.5 * StatusResistance})
					damagetable.victim =unit
					ApplyDamage(damagetable)
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, parent)
					ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle)
					local units2 = FindUnitsInRadius(parent:GetTeamNumber(), unit:GetAbsOrigin(), nil, 700,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
					for i, unit2 in pairs(units2) do
						local StatusResistance = unit2:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
						unit2:AddNewModifier(parent, ability, "modifier_stunned", {duration = 1.5 * StatusResistance})
						damagetable.victim =unit2
						ApplyDamage(damagetable)
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, unit)
						ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
						ParticleManager:SetParticleControl(particle, 1, unit2:GetAbsOrigin())
						ParticleManager:ReleaseParticleIndex(particle)
						if i>=3 then
							break
						end
					end
					-------------
				if i>=4 then
					break
				end
	
	
			   end
	
			else
				self:SetDuration(18, true)
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				parent:EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
				--伤害与眩晕
						local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 400,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
				local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
				local damagetable= {
					attacker = caster,
					damage = parent:GetHealthRegen()*2,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = ability,
					}
				
			   for i, unit in pairs(units) do
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				unit:AddNewModifier(parent, ability, "modifier_stunned", {duration = 1.5 * StatusResistance})
				damagetable.victim =unit
				ApplyDamage(damagetable)
				if i>=4 then
					break
				end
	
	
			   end
	
			end


		end
		if ability:IsCooldownReady()  and parent:GetHealthPercent()<=50 and parent:IsAlive()  then
			ability:StartCooldown(45)
			
			local ModifierStatusGain =  parent:GetModifierDurationGainIndex(1)
			parent:Purge(false, true, false, false, true) --强驱散
			local duration = 10
			--LV10解锁龙化+
			if self.advanced_level>=10 then
				duration = 15
			end
			parent:AddNewModifier(parent, ability, "modifier_Advanced_dragon_blood_active", {duration = duration*ModifierStatusGain})
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball_projectile_b.vpcf", PATTACH_POINT_FOLLOW, parent)
			ParticleManager:SetParticleControl(particle, 3, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			parent:EmitSound("Hero_DragonKnight.ElderDragonForm")


		end
	end
end
function modifier_Advanced_dragon_blood:DeclareFunctions()
	return {

		-- MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

	}
end



function modifier_Advanced_dragon_blood:GetModifierBonusStats_Strength()	return self:GetStackCount()*5 end
function modifier_Advanced_dragon_blood:GetModifierBonusStats_Intellect()	return self:GetStackCount()*5 end
function modifier_Advanced_dragon_blood:GetModifierBonusStats_Agility()	return self:GetStackCount()*5 end


-- function modifier_Advanced_dragon_blood:OnDeath(keys)
-- 	if IsServer() then
-- 		local unit = keys.unit
-- 		if self:GetParent() ~= unit then
-- 			return
-- 		end
-- 		if not unit:IsRealHero() then
-- 			return
-- 		end
-- 		local duration = 30
-- 		if self:GetAbility().unlock2 then
-- 			duration = 15
-- 			self:SetStackCount(math.min(self:GetStackCount()+1,30))
-- 			local parent = self:GetParent()
-- 			local pos = parent:GetAbsOrigin()
-- 			local pos2 = pos + parent:GetForwardVector()*700
-- 			parent:EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
-- 			for i = 1, 6, 1 do
-- 				-- print("aa")
-- 				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_WORLDORIGIN, NIL)
-- 				local new_pos = RotatePosition(pos, QAngle(0, i*60, 0), pos2)
-- 				ParticleManager:SetParticleControl(particle, 0, new_pos)
-- 				ParticleManager:SetParticleControl(particle, 1, pos)
-- 				ParticleManager:ReleaseParticleIndex(particle)
-- 				-- print("??")
-- 			end
-- 		end
		
-- 		if unit.reincarnation_trigger==3 then

-- 			Timers:CreateTimer(0.1, function()
-- 				local pos = unit:GetAbsOrigin()
-- 				unit:SetTimeUntilRespawn(duration)
-- 				Timers:CreateTimer(duration, function()
-- 				if not unit:IsAlive() then --防止二次复活
-- 					unit:RespawnHero(false,false)
-- 					FindClearSpaceForUnit( unit, pos, true )
-- 				end
-- 				end)
-- 			end)
		

-- 		end
-- 	end
-- end

function modifier_Advanced_dragon_blood:AdvancedGetModifierConstantHealthRegen()	
	if not self:GetAbility() then
		return 0
	end
	local bonus_health_regeneration = self:GetAbility():GetSpecialValueFor("bonus_health_regeneration") 
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_dragon_knight") then
		bonus_health_regeneration = bonus_health_regeneration *1.4 
	end

	return bonus_health_regeneration
end


function modifier_Advanced_dragon_blood:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_SPECIAL_Reincarnate= {nil,self:GetParent()},
	}
end
function modifier_Advanced_dragon_blood:Advanced_GetModifierMagicalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled and self.advanced_level<5 then
        return 0 
    end
	if not self:GetAbility() then
		return 0
	end
	local block = self:GetCaster():GetStrength()
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_dragon_knight") then
		block = block *1.4
	end
	return block
end

function modifier_Advanced_dragon_blood:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then
		return 0
	end
	local bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor") 
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_dragon_knight") then
		bonus_armor = bonus_armor *1.4 
	end
	return bonus_armor
end

function modifier_Advanced_dragon_blood:AdvancedGetModifierReincarnate(keys)
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then

		local duration = 30
		if self:GetAbility().unlock2 then
			duration = 15
			self:SetStackCount(math.min(self:GetStackCount()+1,30))
			local parent = self:GetParent()
			local pos = parent:GetAbsOrigin()
			local pos2 = pos + parent:GetForwardVector()*700
			parent:EmitSound("Hero_Beastmaster.Primal_Roar.ti7")
			for i = 1, 6, 1 do
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_WORLDORIGIN, NIL)
				local new_pos = RotatePosition(pos, QAngle(0, i*60, 0), pos2)
				ParticleManager:SetParticleControl(particle, 0, new_pos)
				ParticleManager:SetParticleControl(particle, 1, pos)
				ParticleManager:ReleaseParticleIndex(particle)
			end
		end
		local data = {
			modifier = self,
			time = duration,
			priority = -9999,
			invulnerable_time = 2,
	
		}
		return data
	end

	return nil
	
end

function modifier_Advanced_dragon_blood:OnReincarnateTrigger(keys)

end






modifier_Advanced_dragon_blood_active = advanced_modifier({})

function modifier_Advanced_dragon_blood_active:IsDebuff() return false end
function modifier_Advanced_dragon_blood_active:IsHidden() return false end
function modifier_Advanced_dragon_blood_active:IsPurgable() return false end
function modifier_Advanced_dragon_blood_active:GetEffectName() return "particles/new_effect/status/new_status_effect_advanced_dragon_blood.vpcf" end
function modifier_Advanced_dragon_blood_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_dragon_blood_active:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}


	return state
end



function modifier_Advanced_dragon_blood_active:OnCreated(table)
	self.health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regeneration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end


function modifier_Advanced_dragon_blood_active:AdvancedGetModifierConstantHealthRegen()	return self.health_regen end

function modifier_Advanced_dragon_blood_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end
function modifier_Advanced_dragon_blood_active:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end




modifier_Advanced_dragon_blood_unlock3_passive = advanced_modifier({})

function modifier_Advanced_dragon_blood_unlock3_passive:IsDebuff()			return false end
function modifier_Advanced_dragon_blood_unlock3_passive:IsHidden() 			return true end
function modifier_Advanced_dragon_blood_unlock3_passive:IsPurgable() 		return false end
function modifier_Advanced_dragon_blood_unlock3_passive:IsPurgeException() 	return false end
function modifier_Advanced_dragon_blood_unlock3_passive:RemoveOnDeath() return false end
function modifier_Advanced_dragon_blood_unlock3_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_dragon_blood_unlock3_passive:OnCreated()
	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/dragon_blood/unlock3/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(650,1,1) )
	ParticleManager:SetParticleControl( nFXIndex, 60, Vector(0,65,90) )
	ParticleManager:SetParticleControl( nFXIndex, 61, Vector(1,0,0) )
	self:AddParticle( nFXIndex, false, false, -1, true, false )
end



function modifier_Advanced_dragon_blood_unlock3_passive:Advanced_GetModifierPhysicalArmorBonus() 
	if not self:GetAbility() then
		return 0
	end
	local bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor") *1.5
	return bonus_armor
end

function modifier_Advanced_dragon_blood_unlock3_passive:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end


function modifier_Advanced_dragon_blood_unlock3_passive:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return -1000
end
