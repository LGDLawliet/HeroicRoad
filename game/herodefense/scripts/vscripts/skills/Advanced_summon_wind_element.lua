
LinkLuaModifier("modifier_wind_element_death", "skills/Primary_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_summon_wind_element_buff", "skills/Advanced_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_summon_wind_element_unlock2", "skills/Advanced_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_summon_wind_element_unlock2_debuff", "skills/Advanced_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_summon_wind_element_unlock3", "skills/Advanced_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_summon_wind_element_unlock3_buff", "skills/Advanced_summon_wind_element", LUA_MODIFIER_MOTION_NONE)


Advanced_summon_wind_element	= Advanced_summon_wind_element or class({})
require("internal/timers")

function Advanced_summon_wind_element:IsSummonSpell()return true end
function Advanced_summon_wind_element:IsElementSummon()return true end


function Advanced_summon_wind_element:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf", context )


	
end
function Advanced_summon_wind_element:CheckKV(key)
	local table = {
		bonus_damage=5,
		bonus_health=0.5,



	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_wind_element:UnlockFirstCore(key)
	return true
end
function Advanced_summon_wind_element:UnlockSecondCore(key)
	return true
end
function Advanced_summon_wind_element:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_summon_wind_element_unlock3",{})
	return true
end
function Advanced_summon_wind_element:OnSpellStart()

	local caster =self:GetCaster()
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)+self:GetSpecialValueFor("basic_armor")
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 


	local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_storm_spirit_4")
	if ability then
		if ability:IsCooldownReady() then
			local cooldown = self:GetCooldownTimeRemaining()
			self:EndCooldown()
			ability:StartCooldown(ability:GetSpecialValueFor("CD_index")*cooldown)
		end
		damage = damage + (ability:GetSpecialValueFor("bonus_damage")*0.01)*caster:GetAverageTrueAttackDamage(nil)
	end

	EmitSoundOn("Hero_Windrunner.GaleForce", caster)	
	local pfx_name = "particles/rebuild/spell/summon_wind_element/effect.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, unit_pos)
	DestroyParticleByDelay(pfx,3)
	

	local unit = caster:SummonUnit("npc_hd_wind_element",life_duration,
	unit_pos,
	self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	unit:AddNewModifier(caster, self, "modifier_wind_element_death", {})
	unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wind_element_buff", {})
	if self.unlock2 then
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wind_element_unlock2", {})
	end
end



function Advanced_summon_wind_element:OnProjectileThink_ExtraData(vLocation, ExtraData)
    if IsServer() then 

		local sound = EntIndexToHScript(ExtraData.tornado_dummy_unit)
		
		if IsValid(sound) then
			sound:SetOrigin(vLocation)
		end
    end
end


function Advanced_summon_wind_element:OnProjectileHit_ExtraData(target, location, ExtraData)
    if IsServer() then
        if target ~= nil then 
            local caster = self:GetCaster()
			local damageTable_enemy = {
				victim 			= target,
				attacker 		= caster,
				damage 			= ExtraData.damage,
				damage_type 	= self:GetAbilityDamageType(),
				ability 		= self,
				damage_flags	= DOTA_DAMAGE_FLAG_NONE
			}
			ApplyDamage(damageTable_enemy)
			-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			-- target:AddNewModifier(caster, self, "modifier_creeps_spell_Wind_Howled_silend", {duration=self:GetSpecialValueFor("duration")*StatusResistance})
		else
			local tornado_dummy_unit = EntIndexToHScript(ExtraData.tornado_dummy_unit)
			if tornado_dummy_unit and not tornado_dummy_unit:IsNull() then
				UTIL_Remove(tornado_dummy_unit)
			end

        end
		
    end
end




modifier_Advanced_summon_wind_element_buff = modifier_Advanced_summon_wind_element_buff or advanced_modifier({})

function modifier_Advanced_summon_wind_element_buff:IsDebuff()			return false end
function modifier_Advanced_summon_wind_element_buff:IsHidden() 			return false end
function modifier_Advanced_summon_wind_element_buff:IsPurgable() 		return false end
function modifier_Advanced_summon_wind_element_buff:IsPurgeException() 	return false  end
function modifier_Advanced_summon_wind_element_buff:DestroyOnExpire() return false end
function modifier_Advanced_summon_wind_element_buff:OnCreated(keys)
	local ability = self:GetAbility()
	if ability:GetUnlock(1)==1 then
		self.unlock1 = true
	end
	if IsServer() then
		self.effect_cooldown = ability:GetSpecialValueFor("exchange_CD")--交换时间
		local interval = ability:GetSpecialValueFor("grow_CD")--成长时间

		self.max_bonus = ability:GetSpecialValueFor("grow_max")--成长上限
		if ability.advanced_level>=5 then
			self.effect_cooldown = 2
			if ability.advanced_level>=10 then
				interval = 2
				if ability.advanced_level>=15 then
					self.lv15 = true
					if ability.advanced_level>=20 then
						self.max_bonus = 35
						self.lv20 = true
						
					end
					
				end
			end
		end
		if not self.unlock1 then
			self:StartIntervalThink(interval)
		end
		self.lv15Time = GameRules:GetGameTime()
		
	end
end
function modifier_Advanced_summon_wind_element_buff:OnIntervalThink()
	if self.unlock1 then
		return
	end
	self:SetStackCount(math.min(self:GetStackCount()+1,self.max_bonus))
end
function modifier_Advanced_summon_wind_element_buff:DeclareFunctions() 
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP
    } 
end


function modifier_Advanced_summon_wind_element_buff:Advanced_GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then
		return
	end
	local avoid_chance = self:OnTooltip()
	if self.lv15 and self.lv15Time> GameRules:GetGameTime()then
		avoid_chance = 90
	end
	
	avoid_chance = math.min(avoid_chance,99)
	if avoid_chance >= RandomInt(1, 100) then
		self:SpellToTarget()
		if self.lv20 and 20>=RandomInt(1, 100) then
			self:OnIntervalThink()
		end
		return -1000
	end

end

function modifier_Advanced_summon_wind_element_buff:OnTooltip()
	local avoid_chance = self:GetAbility():GetSpecialValueFor("avoid_chance")
	local grow = self:GetAbility():GetSpecialValueFor("grow")
	if self.unlock1 then
		return math.max(avoid_chance + self:GetStackCount()*grow,85)
	end
	return avoid_chance + self:GetStackCount()*grow
end



function modifier_Advanced_summon_wind_element_buff:SpellToTarget()
	if IsServer() then
		local parent = self:GetParent()
		if self:GetRemainingTime()<=0 then
			self:TryTriggerEffect()
		end
        local particle = ParticleManager:CreateParticle("particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", PATTACH_POINT_FOLLOW, parent)
        -- ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
        DestroyParticleByDelay(particle,1)
    
	end

end


function modifier_Advanced_summon_wind_element_buff:TryTriggerEffect()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local cooldown = ability:GetSpecialValueFor("exchange_CD")
	local damage_index = ability:GetSpecialValueFor("exchange_damage")*0.01
	local range = ability:GetSpecialValueFor("exchange_range")

	local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, range, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)--可以与任意小兵单位换位

	for _, target in ipairs(units) do
		--if target~=parent and target:HasModifier("modifier_Advanced_summon_wind_element_buff") then
		if target~=parent then	
			local parent_loc = parent:GetAbsOrigin()
			local target_loc = target:GetAbsOrigin()
			parent:EmitSound("Hero_VengefulSpirit.NetherSwap")
			target:EmitSound("Hero_VengefulSpirit.NetherSwap")
			target:InterruptChannel()
			local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx1, 0, parent, PATTACH_POINT, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx1, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx1)
			local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx2, 1, parent, PATTACH_POINT, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx2)
			FindClearSpaceForUnit(parent, target_loc, true)
			FindClearSpaceForUnit(target, parent_loc, true)

			--换位完成
			local ability 					= self:GetAbility()
			local tornado_travel_distance 	=  (parent_loc - target_loc):Length2D()
			local area_of_effect 			= 200
			local travel_speed 				= 1500
			local tornado_duration 			= tornado_travel_distance / travel_speed
			local tornado_dummy_unit =  CreateModifierThinker(parent, self, nil, {},parent_loc, parent:GetTeamNumber(), false)
			tornado_dummy_unit:EmitSound("Hero_Invoker.Tornado")
			--------------------------------------------------------
			local tornado_projectile_table =  
			{
				EffectName 			= "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
				Ability 			= ability,
				vSpawnOrigin 		= parent_loc,
				fDistance 			= tornado_travel_distance,
				fStartRadius 		= area_of_effect,
				fEndRadius 			= area_of_effect,
				Source 				= tornado_dummy_unit,
				bHasFrontalCone 	= false,
				iMoveSpeed 			= travel_speed,
				bReplaceExisting 	= false,
				bProvidesVision 	= true,
				iVisionTeamNumber 	= caster:GetTeam(),
				iVisionRadius 		= 250,
				bDrawsOnMinimap 	= false,
				bVisibleToEnemies 	= true, 
				iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				fExpireTime 		= GameRules:GetGameTime() + tornado_duration + 20,
				ExtraData 			= 	
				{	
					tornado_dummy_unit 		= tornado_dummy_unit:entindex(),
					damage = parent:GetAverageTrueAttackDamage(nil)*damage_index,
				}
			}

			local point_difference_normalized 	= (target_loc - parent_loc):Normalized()	
			local projectile_vvelocity 			= point_difference_normalized * travel_speed
			projectile_vvelocity.z = 0
			tornado_projectile_table.vVelocity 	= projectile_vvelocity	
			ProjectileManager:CreateLinearProjectile(tornado_projectile_table)
			self:SetDuration(self.effect_cooldown, true)
			
			if self.lv15 then
				self.lv15Time = GameRules:GetGameTime()+2
			end
			
			Timers(5, function()
				if tornado_dummy_unit and not tornado_dummy_unit:IsNull() then
					UTIL_Remove(tornado_dummy_unit)
				end
			end)
			break	
		end
	end
  



end

function modifier_Advanced_summon_wind_element_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



modifier_Advanced_summon_wind_element_unlock2 = modifier_Advanced_summon_wind_element_unlock2 or class({})

function modifier_Advanced_summon_wind_element_unlock2:IsDebuff()			return false end
function modifier_Advanced_summon_wind_element_unlock2:IsHidden() 			return true end
function modifier_Advanced_summon_wind_element_unlock2:IsPurgable() 		return false end
function modifier_Advanced_summon_wind_element_unlock2:IsPurgeException() 	return false  end
function modifier_Advanced_summon_wind_element_unlock2:OnDestroy()
	if IsServer() then
		-- particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf
		local parent = self:GetParent()
		local pos = parent:GetAbsOrigin()
		for i = 1, 10, 1 do
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(particle, 0, pos+Vector(RandomInt(-100, 100),RandomInt(-100, 100),0))
			DestroyParticleByDelay(particle,1.5)
			parent:EmitSound("Hero_Windrunner.ShackleshotStun.TI8_layer")
		end
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 400, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
	
		local ability = self:GetAbility()
		for _, target in ipairs(units) do
			target:AddNewModifier(caster, ability, "modifier_Advanced_summon_wind_element_unlock2_debuff", {duration = 7})
		end


	end
end




modifier_Advanced_summon_wind_element_unlock2_debuff = modifier_Advanced_summon_wind_element_unlock2_debuff or advanced_modifier({})

function modifier_Advanced_summon_wind_element_unlock2_debuff:IsDebuff()			return true end
function modifier_Advanced_summon_wind_element_unlock2_debuff:IsHidden() 			return false end
function modifier_Advanced_summon_wind_element_unlock2_debuff:IsPurgable() 		return false end
function modifier_Advanced_summon_wind_element_unlock2_debuff:IsPurgeException() 	return false  end
function modifier_Advanced_summon_wind_element_unlock2_debuff:CheckState()
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
	return state
end

function modifier_Advanced_summon_wind_element_unlock2_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_summon_wind_element_unlock2_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_summon_wind_element_unlock2_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_summon_wind_element_unlock2_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -200
end


modifier_Advanced_summon_wind_element_unlock3=modifier_Advanced_summon_wind_element_unlock3 or  class({})

function modifier_Advanced_summon_wind_element_unlock3:IsDebuff()			return false end
function modifier_Advanced_summon_wind_element_unlock3:IsHidden() 			return true end
function modifier_Advanced_summon_wind_element_unlock3:IsPurgable() 		return false end
function modifier_Advanced_summon_wind_element_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_summon_wind_element_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_summon_wind_element_unlock3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if unit:GetUnitName()=="npc_hd_wind_element" then
			return
		end
		local ability = self:GetAbility()

		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_summon_wind_element_unlock3_buff", {})
	end
end



modifier_Advanced_summon_wind_element_unlock3_buff = modifier_Advanced_summon_wind_element_unlock3_buff or advanced_modifier({})

function modifier_Advanced_summon_wind_element_unlock3_buff:IsDebuff()			return false end
function modifier_Advanced_summon_wind_element_unlock3_buff:IsHidden() 			return false end
function modifier_Advanced_summon_wind_element_unlock3_buff:IsPurgable() 		return false end
function modifier_Advanced_summon_wind_element_unlock3_buff:IsPurgeException() 	return false  end
function modifier_Advanced_summon_wind_element_unlock3_buff:DestroyOnExpire() return false end
function modifier_Advanced_summon_wind_element_unlock3_buff:DeclareFunctions() 
    return 
    {

		MODIFIER_PROPERTY_TOOLTIP
    } 
end


function modifier_Advanced_summon_wind_element_unlock3_buff:Advanced_GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then
		return
	end

	local chance = self:OnTooltip()

	if chance>=RandomInt(1, 100) then
		self:SpellToTarget()
		return -1000
	end

end
function modifier_Advanced_summon_wind_element_unlock3_buff:OnTooltip()
	return 40
end

function modifier_Advanced_summon_wind_element_unlock3_buff:SpellToTarget()
	if IsServer() then
		local parent = self:GetParent()
        local particle = ParticleManager:CreateParticle("particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", PATTACH_POINT_FOLLOW, parent)
        -- ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
        DestroyParticleByDelay(particle,1)
    
	end

end


function modifier_Advanced_summon_wind_element_unlock3_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

