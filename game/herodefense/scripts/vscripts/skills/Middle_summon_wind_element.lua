
LinkLuaModifier("modifier_wind_element_death", "skills/Primary_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_summon_wind_element_buff", "skills/Middle_summon_wind_element", LUA_MODIFIER_MOTION_NONE)

Middle_summon_wind_element	= Middle_summon_wind_element or class({})
require("internal/timers")

function Middle_summon_wind_element:IsSummonSpell()return true end
function Middle_summon_wind_element:IsElementSummon()return true end

function Middle_summon_wind_element:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
end
function Middle_summon_wind_element:OnSpellStart()

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
	unit:AddNewModifier(caster, self, "modifier_Middle_summon_wind_element_buff", {})

end



function Middle_summon_wind_element:OnProjectileThink_ExtraData(vLocation, ExtraData)
    if IsServer() then 

		local sound = EntIndexToHScript(ExtraData.tornado_dummy_unit)
		
		if IsValid(sound) then
			sound:SetOrigin(vLocation)
		end
    end
end


function Middle_summon_wind_element:OnProjectileHit_ExtraData(target, location, ExtraData)
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




modifier_Middle_summon_wind_element_buff = modifier_Middle_summon_wind_element_buff or advanced_modifier({})

function modifier_Middle_summon_wind_element_buff:IsDebuff()			return false end
function modifier_Middle_summon_wind_element_buff:IsHidden() 			return false end
function modifier_Middle_summon_wind_element_buff:IsPurgable() 		return false end
function modifier_Middle_summon_wind_element_buff:IsPurgeException() 	return false  end
function modifier_Middle_summon_wind_element_buff:DestroyOnExpire() return false end
function modifier_Middle_summon_wind_element_buff:DeclareFunctions() 
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP
    } 
end


function modifier_Middle_summon_wind_element_buff:Advanced_GetModifierIncomingDamage_Percentage( params )
	local avoid_chance = self:GetAbility():GetSpecialValueFor("avoid_chance")
	if not IsServer() then
		return
	end
	if avoid_chance >= RandomInt(1, 100) then
		self:SpellToTarget()
		return -100
	end

end
function modifier_Middle_summon_wind_element_buff:OnTooltip()
	local avoid_chance = self:GetAbility():GetSpecialValueFor("avoid_chance")
	return avoid_chance
end



function modifier_Middle_summon_wind_element_buff:SpellToTarget()
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


function modifier_Middle_summon_wind_element_buff:TryTriggerEffect()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local cooldown = ability:GetSpecialValueFor("exchange_CD")
	local damage_index = ability:GetSpecialValueFor("exchange_damage")*0.01
	local range = ability:GetSpecialValueFor("exchange_range")

	local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, range, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)--可以与任意小兵单位换位

	for _, target in ipairs(units) do
		--if target~=parent and target:HasModifier("modifier_Middle_summon_wind_element_buff") then
		if target~=parent then	--可以与任意小兵单位换位
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

			self:SetDuration(cooldown, true)
			Timers(cooldown+1, function()
				if tornado_dummy_unit and not tornado_dummy_unit:IsNull() then
					UTIL_Remove(tornado_dummy_unit)
				end
			end)
			break	
		end
	end
  



end

function modifier_Middle_summon_wind_element_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
------------------------------------------------------------------------------------------------
