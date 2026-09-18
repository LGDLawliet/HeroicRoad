creeps_spell_Ball_Lightning = creeps_spell_Ball_Lightning or class({})
require("internal/timers")
LinkLuaModifier("modifier_creeps_spell_Ball_Lightning", "creeps_spell/creeps_spell_Ball_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Static_Remnant_thinker", "creeps_spell/creeps_spell_Static_Remnant", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_Ball_Lightning:GetCastRange()
	if IsClient() then		-- Indicating no-remnant maximum range
		return self:GetSpecialValueFor("cast_range")
	else					-- So you can click wherever and roll in that direction, even if its out of range
		return 30000
	end
end



function creeps_spell_Ball_Lightning:OnSpellStart()
	if IsServer() then
		-- Prevent some stupid shit that happens when you try to zip while already zipping
		if self:GetCaster():FindModifierByName("modifier_creeps_spell_Ball_Lightning") then
			self:RefundManaCost()
			return
		end

		-- if self:GetCaster():HasTalent("special_bonus_unique_storm_spirit_4") then
		-- 	self.remnant = self:GetCaster():FindAbilityByName("imba_storm_spirit_static_remnant")
		-- end
        self.remnant = self:GetCaster():FindAbilityByName("creeps_spell_Static_Remnant")
		-- Ability properties
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		-- Ability parameters
		local speed 			=	self:GetSpecialValueFor("ball_lightning_move_speed")
		local damage_radius 	= 	self:GetSpecialValueFor("ball_lightning_aoe")
		local vision 			= 	self:GetSpecialValueFor("ball_lightning_vision_radius")
		local tree_radius 		= 	100
		local damage 			= 	self:GetSpecialValueFor("damage")*self:GetCaster():GetBaseDamageMax()
		local base_mana_cost	= 	0
		local pct_mana_cost		= 	0
		local total_mana_cost 	=	base_mana_cost + pct_mana_cost
		local max_spell_amp_range	=	1500

		-- Motion control properties
		self.traveled 	= 0
		self.distance 	= (target_loc - caster_loc):Length2D()
        if self.distance >self:GetSpecialValueFor("cast_range") then
            self.distance  = self:GetSpecialValueFor("cast_range")
        end
		self.direction 	= (target_loc - caster_loc):Normalized()

		-- Play the cast sound
		caster:EmitSound("Hero_StormSpirit.BallLightning")
		
		-- A bit arbitrary but I'm trying to prevent lingering loop sounds
		if (target_loc - caster_loc):Length2D() > 130 then
			caster:EmitSound("Hero_StormSpirit.BallLightning.Loop")
		end
		
		-- Fire the ball of death!
		-- local projectile =
		-- {
		-- 	Ability				= self,
		-- 	-- EffectName			= "particles/hero/storm_spirit/no_particle_particle.vpcf",
		-- 	vSpawnOrigin		= caster_loc,
		-- 	fDistance			= self.distance,
		-- 	fStartRadius		= damage_radius,
		-- 	fEndRadius			= damage_radius,
		-- 	Source				= caster,
		-- 	bHasFrontalCone		= false,
		-- 	bReplaceExisting	= false,
		-- 	iUnitTargetTeam		= self:GetAbilityTargetTeam(),
		-- 	iUnitTargetFlags	= self:GetAbilityTargetFlags(),
		-- 	iUnitTargetType		= self:GetAbilityTargetType(),
		-- 	bDeleteOnHit		= false,
		-- 	vVelocity 			= self.direction * speed * Vector(1, 1, 0),
		-- 	bProvidesVision		= true,
		-- 	iVisionRadius 		= vision,
		-- 	iVisionTeamNumber 	= caster:GetTeamNumber(),
		-- 	ExtraData			= {damage = damage,
		-- 		tree_radius = tree_radius,
		-- 		base_mana_cost = base_mana_cost,
		-- 		pct_mana_cost = pct_mana_cost,
		-- 		total_mana_cost = total_mana_cost,
		-- 		speed = speed * FrameTime(),
		-- 		max_spell_amp_range = max_spell_amp_range
		-- 	}
		-- }

		-- self.projectileID = ProjectileManager:CreateLinearProjectile(projectile)


        local info = {
            Ability = self,
            vSpawnOrigin = caster_loc,
            vVelocity = self.direction * speed * Vector(1, 1, 0),
            fDistance = self.distance,
            fStartRadius = damage_radius,
            fEndRadius = damage_radius,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            bProvidesVision = true,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iVisionRadius = vision,
            ExtraData =        {
                damage = damage,
				tree_radius = tree_radius,
				base_mana_cost = base_mana_cost,
				pct_mana_cost = pct_mana_cost,
				total_mana_cost = total_mana_cost,
				speed = speed * FrameTime(),
				max_spell_amp_range = max_spell_amp_range
            }
        }
    
        self.projectileID = ProjectileManager:CreateLinearProjectile(info)

		-- Add Motion-Controller Modifier
		caster:AddNewModifier(caster, self, "modifier_creeps_spell_Ball_Lightning", {duration=5})
--		StartAnimation(self:GetCaster(), {duration=10.0, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.0})
	end
end

function creeps_spell_Ball_Lightning:OnProjectileThink_ExtraData(location, ExtraData)
	-- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
	local caster = self:GetCaster()

	if (self.traveled + ExtraData.speed < self.distance) and caster:IsAlive() and (caster:GetMana() > ExtraData.total_mana_cost * 0.01 ) then
		-- Destroy the trees in the way
		GridNav:DestroyTreesAroundPoint(location, ExtraData.tree_radius, false)

		-- Set the caster slightly forwards
		caster:SetAbsOrigin(Vector(location.x, location.y, GetGroundPosition(location, caster).z))
		caster:Purge(false, true, true, true, true)


		-- Calculate the new travel distance
		self.traveled = self.traveled + ExtraData.speed

		self.units_traveled_in_last_tick = ExtraData.speed

		-- Use up mana for traveling
		caster:Script_ReduceMana(( (ExtraData.pct_mana_cost * 0.01) + ExtraData.base_mana_cost ) * self.units_traveled_in_last_tick * 0.01,self)
		-- Note: the last *0.01 in the calculation is because the manacost is calculated for every 100 units.

		-- if self.traveled_remnant ~= nil and self.remnant then
		-- 	self.traveled_remnant = self.traveled_remnant + ExtraData.speed
		-- 	local remant_interval = caster:FindTalentValue("special_bonus_unique_storm_spirit_4")
		-- 	if self.traveled_remnant - remant_interval >= 0 then
		-- 		self.traveled_remnant = self.traveled_remnant - remant_interval
		-- 		local cast_sound			=	"Hero_StormSpirit.StaticRemnantPlant"
		-- 		EmitSoundOn(cast_sound,caster)
		-- 		--Create remnant
		-- 		local dummy = CreateUnitByName( "npc_imba_dota_stormspirit_remnant", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
		-- 		-- Give it the necessary modifier
		-- 		dummy:AddNewModifier(caster, self.remnant, "modifier_imba_static_remnant", {duration = self.remnant:GetSpecialValueFor("duration"), ballLightning = true})
		-- 	end
		-- end
		-- Once the caster can no longer travel, remove this projectile
	else
		-- Emit end response
		local responses = {"stormspirit_ss_ability_lightning_04", "stormspirit_ss_ability_lightning_05", "stormspirit_ss_ability_lightning_06", "stormspirit_ss_ability_lightning_07",
			"stormspirit_ss_ability_lightning_08", "stormspirit_ss_ability_lightning_09", "stormspirit_ss_ability_lightning_10", "stormspirit_ss_ability_lightning_13",
			"stormspirit_ss_ability_lightning_14", "stormspirit_ss_ability_lightning_18", "stormspirit_ss_ability_lightning_20", "stormspirit_ss_ability_lightning_21",
			"stormspirit_ss_ability_lightning_22", "stormspirit_ss_ability_lightning_23", "stormspirit_ss_ability_lightning_24", "stormspirit_ss_ability_lightning_25",
			"stormspirit_ss_ability_lightning_26", "stormspirit_ss_ability_lightning_27", "stormspirit_ss_ability_lightning_28", "stormspirit_ss_ability_lightning_29",
			"stormspirit_ss_ability_lightning_30", "stormspirit_ss_ability_lightning_31", "stormspirit_ss_ability_lightning_32",
		}


		-- Find a clear space to stand on
		-- caster:SetUnitOnClearGround()

		-- Destroying sound handled in the Ball Lightning modifier (doing it here results in looping sound not stopping if ability is cast in place)
		-- caster:StopSound("Hero_StormSpirit.BallLightning.Loop")

		-- Get rid of the Ball
		if caster:FindModifierByName("modifier_creeps_spell_Ball_Lightning") then
			caster:FindModifierByName("modifier_creeps_spell_Ball_Lightning"):SafeDestroy()
		end
		ProjectileManager:DestroyLinearProjectile(self.projectileID)
	end
end

function creeps_spell_Ball_Lightning:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target then
			local caster = self:GetCaster()
			local damage = ExtraData.damage
			local damage_flags = DOTA_DAMAGE_FLAG_NONE

			-- Prevent spell amp at large distances

			-- Deal damage
			local damageTable = {victim = target,
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				attacker = caster,
				ability = self,
				damage_flags = damage_flags
			}

			ApplyDamage(damageTable)
			if caster.pattern_2 and target:IsRealHero() then
				local dummy = CreateUnitByName( "npc_dota_thinker", target:GetAbsOrigin(), false, self:GetCaster(), nil, self:GetCaster():GetTeamNumber() )
            	-- Give it the necessary modifier
           	 	dummy:AddNewModifier(self:GetCaster(), self.remnant, "modifier_creeps_spell_Static_Remnant_thinker", {duration = self.remnant:GetSpecialValueFor("duration"), ballLightning = true})
            	dummy:SetForwardVector(self:GetCaster():GetForwardVector())
			end

		end

	end
end

-- Custom mana cost for Ball Lightning
function creeps_spell_Ball_Lightning:GetManaCost(iLevel)
    local hCaster = self:GetCaster()
    -- if not IsValid(hCaster) then
    --     return self.BaseClass.GetManaCost(self, iLevel)
    -- end

    -- if IsServer() and hCaster:HasModifier("modifier_creeps_spell_Ball_Lightning") then
    --     return self.fManaCost or 0
    -- end
    return hCaster:GetMaxMana() * self:GetSpecialValueFor("mana_percentage") * 0.01
end

--- BALL LIGHTNING MODIFIER
modifier_creeps_spell_Ball_Lightning = modifier_creeps_spell_Ball_Lightning or class({})

-- Modifier properties
function modifier_creeps_spell_Ball_Lightning:IsDebuff() 	return false end
function modifier_creeps_spell_Ball_Lightning:IsHidden() 	return false end
function modifier_creeps_spell_Ball_Lightning:IsPurgable() return false end

function modifier_creeps_spell_Ball_Lightning:GetEffectName()
	return "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
end

-- Once again with the Rubick exceptions...
function modifier_creeps_spell_Ball_Lightning:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_creeps_spell_Ball_Lightning:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then
		self:SafeDestroy()
	end
end

function modifier_creeps_spell_Ball_Lightning:OnDestroy()
	if not IsServer() then return end
	
	self:GetCaster():StopSound("Hero_StormSpirit.BallLightning.Loop")
	
	
	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(self:GetParent())
    local caster = self:GetParent()

	caster:AddNewModifier(caster, self:GetAbility(), "modifier_phased", {duration=0.1}) --提供相位，防止卡位

    local ability = self:GetAbility()
    local cost = self:GetCaster():GetMaxMana() * self:GetAbility():GetSpecialValueFor("mana_percentage") * 0.01
    if cost <= self:GetParent():GetMana() then
        Timers:CreateTimer(0.02, function()
            local unit = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
            if #unit==0 then
                return
            end
            local distance = (unit[1]:GetOrigin()-caster:GetOrigin()):Normalized()
            local new_pos = unit[1]:GetOrigin() + distance * 1000
            caster:SetCursorPosition(new_pos)
            ability:OnSpellStart()
            caster:SpendMana(cost, ability)
			
        end)

    end
    -- if self:GetAbility():GetManaCost() <= self:GetParent():GetMana() then
    --     local unit = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
    --     if #unit==0 then
    --         return
    --     end
    --     local distance = (unit[1]:GetOrigin()-self:GetParent():GetOrigin()):Normalized()
    --     local new_pos = unit[1]:GetOrigin() + distance * 1000
    --     self:GetCaster():SetCursorPosition(new_pos)
    --     self:GetAbility():OnSpellStart()
    --     self:GetParent():SpendMana(self:GetAbility():GetManaCost(), self:GetAbility())
    -- end
end



-- function modifier_creeps_spell_Ball_Lightning:CheckState()
	-- local state	=	{
-- --		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	-- }
	-- return state
-- end

function modifier_creeps_spell_Ball_Lightning:GetEffectAttachType()
	-- Yep, this is a thing.
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_creeps_spell_Ball_Lightning:DeclareFunctions()
	local funcs	=	{
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

--	function modifier_creeps_spell_Ball_Lightning:GetOverrideAnimation()
--		return ACT_DOTA_OVERRIDE_ABILITY_4
--	end

function modifier_creeps_spell_Ball_Lightning:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_creeps_spell_Ball_Lightning:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_creeps_spell_Ball_Lightning:GetAbsoluteNoDamagePure()
	return 1
end