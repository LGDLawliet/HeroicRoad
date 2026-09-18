LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tusk_2","heroTalent/heroTalent_npc_dota_hero_tusk_2",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit","heroTalent/heroTalent_npc_dota_hero_tusk_2",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying","heroTalent/heroTalent_npc_dota_hero_tusk_2",LUA_MODIFIER_MOTION_NONE)


heroTalent_npc_dota_hero_tusk_2 = class({})
function heroTalent_npc_dota_hero_tusk_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/tusk_walruspunch_txt_ult.vpcf", context )

end


function heroTalent_npc_dota_hero_tusk_2:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_tusk_2"
end

function heroTalent_npc_dota_hero_tusk_2:CastWalrusPunch(hTarget)
    local caster = self:GetCaster()
    local target = hTarget

    local duration = 2
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
    caster:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit",{})
    target:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying",{duration = duration*StatusResistance})
	target:AddNewModifier(caster,self,"modifier_tusk_walrus_punch_air_time",{duration = duration*StatusResistance})
	
    -- Text particles
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_txt_ult.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin()+Vector(0,0,175))
    ParticleManager:ReleaseParticleIndex(particle)

    caster:EmitSound("Hero_Tusk.WalrusPunch.Target")
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

end


modifier_heroTalent_npc_dota_hero_tusk_2 = class({})


function modifier_heroTalent_npc_dota_hero_tusk_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tusk_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tusk_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tusk_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_tusk_2:IsPermanent() return true end


function modifier_heroTalent_npc_dota_hero_tusk_2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end
function modifier_heroTalent_npc_dota_hero_tusk_2:OnCreated(keys)
    if IsServer() then
        self.continuous_punch_send = false
        self.continuous_punch = 0
        self.chance = 10
        local unit = self:GetParent()
        if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())),"Walrus_punch_2") then
            self.chance = self.chance + 1
			-- unit:InitAchievement("Walrus_punch_1")
		end
    end
end

function modifier_heroTalent_npc_dota_hero_tusk_2:IsValidToTrigger(hTarget)
    -- Rejection based on target
    if hTarget:GetTeamNumber() ==  self:GetCaster():GetTeamNumber() then return false end
    if hTarget:IsBuilding() or hTarget:IsOther() then return false end

    
    if not self:GetAbility():IsCooldownReady()  then return false end
	if self:GetParent():PassivesDisabled()  then return false end
    if self.chance>=RandomInt(1, 100) then
        self:GetAbility():UseResources(true,false,true,true)
        
        if not self.continuous_punch_send then
            self.continuous_punch = self.continuous_punch + 1
            if self.continuous_punch>=7 then
                self.continuous_punch_send = true
                local modifier = self:GetCaster():FindModifierByName("modifier_hero_custom_data_manager")
                if modifier then
                    modifier:UnlockCustomData("Walrus_punch_2")
                end
            end
        end
        return true
    else
        self.continuous_punch = 0
    end
    
    return false
end

function modifier_heroTalent_npc_dota_hero_tusk_2:OnAttackStart(keys)
    local target = keys.target
    local ability = self:GetAbility()
    if not self:GetParent():IsRealHero() then
		return false
	end
    if keys.attacker ~= self:GetCaster() then return end
    if not self:IsValidToTrigger(target) then return end
    -- I prefer to use the ability for this
    ability:CastWalrusPunch(target)
end


modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:RemoveOnDeath() return true end

function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:OnCreated()
    if IsServer() then
        self.crit_multiplier = 500
    end
end


-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:Advanced_GetModifierCriticalStrike(keys)
    return self.crit_multiplier 
end


---@override
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_crit:OnAttackLanded()
    self:GetCaster():EmitSound("Hero_heroTalent_npc_dota_hero_tusk_2.WalrusPunch.Target")
    self:SafeDestroy()
end


modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying = class({})


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:IsPurgable() 		    return true end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:IsPurgeException() return true end
function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = IsServer(), -- Not showing the status bar
    }
end


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:OnCreated(keys)
    if IsServer() then


		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
		
		self.forward = self:GetParent():GetForwardVector()
		-- self.newpos = self.pos + self.forward *200
		self.next_step = 0
        self:StartIntervalThink(FrameTime())
    end
end


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:OnIntervalThink()
    local unit = self:GetParent()

    -- self.direction.z = self.direction.z - (self.z_vel *2  *FrameTime())
    -- unit:SetAbsOrigin(unit:GetAbsOrigin() + self.direction *  FrameTime())


	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 1000
	local next_pos = GetGroundPosition(unit:GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)


	-- local forward = unit:GetForwardVector()

	self.next_step = self.next_step + 33
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, self.next_step ,0 ), Vector(0,1,0) )
	-- self.facing = RotatePosition(self.pos, QAngle( -self.next_step*self.forward.x, 0 ,-self.next_step*self.forward.y ), self.newpos )
	-- print(self.facing)
	-- self.facing = (self.facing - self.pos):Normalized()

	
	-- print(forward)
	-- print(self.facing)
	-- self.facing.x = forward.x
	-- self.facing.y = forward.y
	unit:SetForwardVector( self.facing )

	-- self:GetParent():SetAngles(newpos1)
end


function modifier_heroTalent_npc_dota_hero_tusk_2_walrus_punch_flying:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(),self:GetParent():GetAbsOrigin(),true)
		self:GetParent():SetForwardVector( self.forward )
		-- self:GetParent():SetAngles(self.angles.x, self.angles.y, self.angles.z)
    end
end

