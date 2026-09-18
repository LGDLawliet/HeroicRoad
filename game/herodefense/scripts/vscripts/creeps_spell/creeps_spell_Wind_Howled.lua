creeps_spell_Wind_Howled = class({})

LinkLuaModifier("modifier_creeps_spell_Wind_Howled", "creeps_spell/creeps_spell_Wind_Howled", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wind_Howled_silend", "creeps_spell/creeps_spell_Wind_Howled", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Wind_Howled_death", "creeps_spell/creeps_spell_Wind_Howled", LUA_MODIFIER_MOTION_NONE)




function creeps_spell_Wind_Howled:IsHiddenWhenStolen() 		return false end
function creeps_spell_Wind_Howled:IsRefreshable() 			return true end
function creeps_spell_Wind_Howled:IsStealable() 				return true end
function creeps_spell_Wind_Howled:IsNetherWardStealable()		return true end
function creeps_spell_Wind_Howled:GetIntrinsicModifierName() return "modifier_creeps_spell_Wind_Howled" end

function creeps_spell_Wind_Howled:Spawn()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Wind_Howled_death", {})
	end
end



modifier_creeps_spell_Wind_Howled = class({})

function modifier_creeps_spell_Wind_Howled:IsDebuff()			return false end
function modifier_creeps_spell_Wind_Howled:IsHidden() 			return true end
function modifier_creeps_spell_Wind_Howled:IsPurgable() 		    return false end
function modifier_creeps_spell_Wind_Howled:IsPurgeException() 	return false end

function modifier_creeps_spell_Wind_Howled:DeclareFunctions() return 
    {MODIFIER_EVENT_ON_TAKEDAMAGE,
 } end


function modifier_creeps_spell_Wind_Howled:OnTakeDamage(keys)
	-- "Cannot proc on attacks from buildings, wards and allies."
	if keys.damage_category==0 then
		return
	end
	if(keys.unit == self:GetParent() and self:GetAbility():IsCooldownReady()) then
        local caster = self:GetCaster()
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("distance"), 
        DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
    if enemies[1] ==nil or enemies[1]==self:GetParent() or self:GetParent():PassivesDisabled() then
        return
    end
    self:GetAbility():UseResources(false, false,false, true)
    self:GetAbility():StartCooldown(self:GetAbility():GetCooldownTimeRemaining() + RandomInt(1, 6))
	local target = enemies[1]
    local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()
	local pos = {}
	table.insert(pos, caster_loc)
	table.insert(pos, target_loc)
	caster:EmitSound("Hero_VengefulSpirit.NetherSwap")
	target:EmitSound("Hero_VengefulSpirit.NetherSwap")
	target:InterruptChannel()
	local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx1, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx1)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx2, 1, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx2)
	FindClearSpaceForUnit(caster, target_loc, true)
	FindClearSpaceForUnit(target, caster_loc, true)
	GridNav:DestroyTreesAroundPoint(target_loc, 300, true)
	GridNav:DestroyTreesAroundPoint(caster_loc, 300, true)
    --换位完成
    local ability 					= self:GetAbility()
	local tornado_travel_distance 	=  (caster_loc - target_loc):Length2D()
	local area_of_effect 			= 200
	local travel_speed 				= ability:GetSpecialValueFor("speed")
	local tornado_duration 			= tornado_travel_distance / travel_speed
	local daze_duration 			= 0
    local tornado_dummy_unit =  CreateModifierThinker(caster, self, nil, {},caster_loc, caster:GetTeamNumber(), false)
    tornado_dummy_unit:EmitSound("Hero_Invoker.Tornado")
    --------------------------------------------------------
    local tornado_projectile_table =  
				{
					EffectName 			= "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
					Ability 			= ability,
					vSpawnOrigin 		= caster_loc,
					fDistance 			= tornado_travel_distance,
					fStartRadius 		= area_of_effect,
					fEndRadius 			= area_of_effect,
					Source 				= tornado_dummy_unit,
					bHasFrontalCone 	= false,
					iMoveSpeed 			= travel_speed,
					bReplaceExisting 	= false,
					bProvidesVision 	= true,
					iVisionTeamNumber 	= caster:GetTeam(),
					iVisionRadius 		= vision_distance,
					bDrawsOnMinimap 	= false,
					bVisibleToEnemies 	= true, 
					iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					fExpireTime 		= GameRules:GetGameTime() + tornado_duration + 20,
					ExtraData 			= 	{	
												tornado_dummy_unit 		= tornado_dummy_unit:entindex()
											}
				}
    --------------------------------------------------------
	-- Normalize the vector for the difference between the points.
	local point_difference_normalized 	= (target_loc - caster_loc):Normalized()	
	-- Set direction and travel_speed of Tornado
	local projectile_vvelocity 			= point_difference_normalized * travel_speed
	projectile_vvelocity.z = 0
	tornado_projectile_table.vVelocity 	= projectile_vvelocity	
	-- Crate the acctual projectile
	local tornado_projectile = ProjectileManager:CreateLinearProjectile(tornado_projectile_table)

	
	end
end



--计时器设置狂风马甲的位置
function modifier_creeps_spell_Wind_Howled:OnProjectileThink_ExtraData(vLocation, ExtraData)
    if IsServer() then 

		local sound = EntIndexToHScript(ExtraData.tornado_dummy_unit)
		
		if IsValid(sound) then
			sound:SetOrigin(vLocation)
		end
    end
end


function creeps_spell_Wind_Howled:OnProjectileHit_ExtraData(target, location, ExtraData)
    if IsServer() then
        if target ~= nil then 
            local caster = self:GetCaster()
            local damage = self:GetSpecialValueFor("damage")*caster:GetDamageMax()
            
		local damageTable_enemy = {
			victim 			= target,
			attacker 		= caster,
			damage 			= damage,
			damage_type 	= self:GetAbilityDamageType(),
			ability 		= self,
			damage_flags	= DOTA_DAMAGE_FLAG_NONE
		}
		ApplyDamage(damageTable_enemy)
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
        target:AddNewModifier(caster, self, "modifier_creeps_spell_Wind_Howled_silend", {duration=self:GetSpecialValueFor("duration")*StatusResistance})
        end
		UTIL_Remove(EntIndexToHScript(ExtraData.tornado_dummy_unit))
    end
end

modifier_creeps_spell_Wind_Howled_silend = class({})

function modifier_creeps_spell_Wind_Howled_silend:IsDebuff()			return true end
function modifier_creeps_spell_Wind_Howled_silend:IsHidden() 			return false end
function modifier_creeps_spell_Wind_Howled_silend:IsPurgable() 			return true end
function modifier_creeps_spell_Wind_Howled_silend:IsPurgeException() 	return true end
function modifier_creeps_spell_Wind_Howled_silend:CheckState() return {[MODIFIER_STATE_SILENCED] = true, } end

function modifier_creeps_spell_Wind_Howled_silend:OnCreated()
	if IsServer() then
		self.silenceParticle = "particles/generic_gameplay/generic_silence.vpcf"
		self.parent = self:GetParent()
        self.particle = ParticleManager:CreateParticle(self.silenceParticle, PATTACH_OVERHEAD_FOLLOW, self.parent)
	end
end
function modifier_creeps_spell_Wind_Howled_silend:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end


require('internal/timers')   --计时器功能
modifier_creeps_spell_Wind_Howled_death = class({})

function modifier_creeps_spell_Wind_Howled_death:IsDebuff()			return false end
function modifier_creeps_spell_Wind_Howled_death:IsHidden() 			return true end
function modifier_creeps_spell_Wind_Howled_death:IsPurgable() 		return false end
function modifier_creeps_spell_Wind_Howled_death:IsPurgeException() 	return false  end
function modifier_creeps_spell_Wind_Howled_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_storm_death.vpcf", context )
end

function modifier_creeps_spell_Wind_Howled_death:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_storm_death.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		local scale = parent:GetModelScale()
		local timer = 0
		Timers:CreateTimer(FrameTime(), function()
			timer = timer + FrameTime()
			if timer>=0.4 then
				parent:AddNoDraw()
				return nil
			end
			scale = scale*0.95
			parent:SetModelScale(scale)

			return FrameTime()
			
		end)
		
	end
end