chaotic_imprint_falcon = class({})
LinkLuaModifier("modifier_chaotic_imprint_falcon_passive", "chaotic_spell/class_5/chaotic_imprint_falcon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_imprint_falcon_buff", "chaotic_spell/class_5/chaotic_imprint_falcon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_imprint_falcon_target", "chaotic_spell/class_5/chaotic_imprint_falcon", LUA_MODIFIER_MOTION_NONE)

function chaotic_imprint_falcon:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_imprint_falcon/effect_projectile/effectspell_storm_beltpell_storm_bolt.vpcf", context )
end

function chaotic_imprint_falcon:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end
function chaotic_imprint_falcon:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_imprint_falcon:GetIntrinsicModifierName()
	return "modifier_chaotic_imprint_falcon_passive"
end




-- function chaotic_imprint_falcon:CastFilterResultLocation()
-- 	if IsServer() then
-- 		local modifier = self:GetCaster():FindModifierByName("modifier_chaotic_imprint_falcon_passive")
-- 		if modifier then
-- 			local stack = modifier:GetStackCount()
-- 			local stack_require = math.floor(self:GetSpecialValueFor("stack_require"))
-- 			if stack<stack_require then
--                 self.error = "#dota_hud_not_enough_energy"
-- 				return UF_FAIL_CUSTOM
-- 			end				
-- 		end
-- 		return UF_SUCCESS
-- 	end	
-- end
-- function chaotic_imprint_falcon:GetCustomCastErrorLocation()
--     return self.error
-- end



function chaotic_imprint_falcon:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
	caster:AddNewModifier(caster, self, "modifier_chaotic_imprint_falcon_buff", {duration = self:GetSpecialValueFor("duration")*caster:GetModifierDurationGainIndex(1)})

    local modifier = caster:FindModifierByName("modifier_chaotic_imprint_falcon_passive")
	if modifier then
		modifier:SetStackCount(0)
        self:SetActivated(false)
	end

	local casterPos = caster:GetAbsOrigin()
	local vec = point-casterPos	

	local travel_time = (vec:Length2D())/2000
	local speed= vec:Length2D()/travel_time

	local thinker = CreateModifierThinker(
		caster,
		self,
		"modifier_chaotic_imprint_falcon_target",
		{ travel_time = travel_time+0.5 },
		point,
		caster:GetTeamNumber(),
		false
	)
    caster:EmitSound("chaotic_imprint_falcon_cast")
    ---------弹射物info与引用-------------------------------
    local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
	local info = {
		Ability = self,	
		--EffectName = "particles/new_effect/unit/brain_worm/acid_bomb/acid_bombsnapfire_lizard_blobs_arced.vpcf",
		EffectName = "particles/rebuild/chaotic_spell/chaotic_imprint_falcon/effect_projectile/effectspell_storm_beltpell_storm_bolt.vpcf",
		iMoveSpeed = speed,
		bDodgeable = false,                           -- Optional
		Target = thinker,
		vSourceLoc = attack_lock,                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile( info )

   

end

function chaotic_imprint_falcon:OnProjectileHit( target, location )
	if not target then return end
    target:EmitSound("chaotic_imprint_falcon_hit")
	-- local damage = (self:GetSpecialValueFor("damage") + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetSpecialValueFor("damage_index"))
    local damage = (self:GetSpecialValueFor("damage") + self:GetCaster():GetAttackDamage()*self:GetSpecialValueFor("damage_index"))
	
    
    local impact_radius = self:GetSpecialValueFor("radius")


	-- 定义伤害
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE
	}
    --定义敌人
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		impact_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
    --遍历敌人使用伤害
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	
end
---------------modifier：被动叠层--------------------------
modifier_chaotic_imprint_falcon_passive = advanced_modifier({})

function modifier_chaotic_imprint_falcon_passive:IsHidden() 	return false end
function modifier_chaotic_imprint_falcon_passive:IsPurgable() 		    return false end
function modifier_chaotic_imprint_falcon_passive:IsPurgeException() return false end
function modifier_chaotic_imprint_falcon_passive:RemoveOnDeath() return false end

function modifier_chaotic_imprint_falcon_passive:OnCreated( keys )
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
	if IsServer() then
        self.stack_attack = self:GetAbility():GetSpecialValueFor("stack_attack")
        self.stack_require = math.floor(self:GetAbility():GetSpecialValueFor("stack_require"))
        self:GetAbility():SetActivated(false)
    end
end
function modifier_chaotic_imprint_falcon_passive:OnRefresh( keys )
	self:OnCreated(keys)
end



function modifier_chaotic_imprint_falcon_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end


function modifier_chaotic_imprint_falcon_passive:ADDeclareFunctions()
	local funcs =  {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		
    }
	if self:GetAbility():GetRuneType()==1 then
		funcs["MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER"] = {self:GetParent(),nil}
	end
    return funcs
   
end



function modifier_chaotic_imprint_falcon_passive:OnAttackLanded( params )
	if IsServer() then
        if params.attacker==self:GetParent() then
            self:SetStackCount(math.min( self.stack_require,self:GetStackCount()+self.stack_attack))
			
            if self:GetStackCount()>=self.stack_require then
                self:GetAbility():SetActivated(true)
            end
        end
    end
end

function modifier_chaotic_imprint_falcon_passive:GetModifierAttackSpeedBonus_Constant(params)
	return self.attack_speed
end
function modifier_chaotic_imprint_falcon_passive:AdvancedOnCriticalStrikeTrigger(keys)

	if IsServer() then
		-- local unit =  keys.unit
		if keys.attacker==self:GetParent() then
			self:SetStackCount(math.min( self.stack_require,self:GetStackCount()+self.rune_1_bonus))
		end

	end
end



------------------modifier:鹰眼BUFF-----------------------
modifier_chaotic_imprint_falcon_buff = advanced_modifier({})

function modifier_chaotic_imprint_falcon_buff:IsHidden() 	return false end
function modifier_chaotic_imprint_falcon_buff:IsPurgable() 		    return false end
function modifier_chaotic_imprint_falcon_buff:IsPurgeException() return false end
function modifier_chaotic_imprint_falcon_buff:RemoveOnDeath() return false end
function modifier_chaotic_imprint_falcon_buff:OnCreated(keys)

    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_chaotic_imprint_falcon_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end


function modifier_chaotic_imprint_falcon_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	return self.bonus_damage
end
function modifier_chaotic_imprint_falcon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_chaotic_imprint_falcon_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	end
end



-----------------modifier:袭击区域-------------------------
--计时器
modifier_chaotic_imprint_falcon_target = class({})
function modifier_chaotic_imprint_falcon_target:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

