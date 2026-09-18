LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tusk","heroTalent/heroTalent_npc_dota_hero_tusk",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit","heroTalent/heroTalent_npc_dota_hero_tusk",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying","heroTalent/heroTalent_npc_dota_hero_tusk",LUA_MODIFIER_MOTION_NONE)


heroTalent_npc_dota_hero_tusk = class({})

function heroTalent_npc_dota_hero_tusk:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_tusk"
end

function heroTalent_npc_dota_hero_tusk:Spawn()
    if IsServer() then
        self.punch_count = 0
        self.punch_count_send = false
        local unit = self:GetCaster()
        if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())),"Walrus_punch_1") then
            -- print("海民天赋激活")
            unit:InitAchievement("Walrus_punch_1")

		end
    end
end

function heroTalent_npc_dota_hero_tusk:CastWalrusPunch(hTarget)
    local caster = self:GetCaster()
    local target = hTarget

    local duration = self:GetSpecialValueFor("fly_time")
	--local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	--local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
    caster:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit",{})
    target:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying",{duration = duration})
	target:AddNewModifier(caster,self,"modifier_tusk_walrus_punch_air_time",{duration = duration})
	
    -- Text particles
    -- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_txt_ult.vpcf", PATTACH_ABSORIGIN, caster)
    -- ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin()+Vector(0,0,175))
    -- ParticleManager:ReleaseParticleIndex(particle)

    caster:EmitSound("Hero_Tusk.WalrusPunch.Target")
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    if not self.punch_count_send then
        self.punch_count = self.punch_count + 1
        if self.punch_count>=250 then
            -- print("send")
            local modifier = self:GetCaster():FindModifierByName("modifier_hero_custom_data_manager")
            if modifier then
                modifier:UnlockCustomData("Walrus_punch_1")
            end
            self.punch_count_send = true
        end
    end
end


modifier_heroTalent_npc_dota_hero_tusk = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_tusk:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_tusk:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tusk:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tusk:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tusk:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tusk:IsPermanent() return true end

function modifier_heroTalent_npc_dota_hero_tusk:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.crit_multiplier = self.ability:GetSpecialValueFor("crit_mult")
    self.no_armor = self.ability:GetSpecialValueFor("no_armor")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.crit_multiplier_t = self.crit_multiplier*self.talentgain
    self.no_armor_t = self.no_armor*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_tusk:OnRefresh()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.crit_multiplier = self.ability:GetSpecialValueFor("crit_mult")
    self.no_armor = self.ability:GetSpecialValueFor("no_armor")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.crit_multiplier_t = self.crit_multiplier*self.talentgain
    self.no_armor_t = self.no_armor*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_tusk:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_tusk:IsValidToTrigger(hTarget)
    -- Rejection based on target
    if hTarget:GetTeamNumber() ==  self:GetCaster():GetTeamNumber() then return false end
    if hTarget:IsBuilding() or hTarget:IsOther() then return false end

    
    if not self:GetAbility():IsCooldownReady()  then return false end
	if self:GetParent():PassivesDisabled()  then return false end
    self:GetAbility():UseResources(true,false,true,true)
    return true
end

function modifier_heroTalent_npc_dota_hero_tusk:OnAttackStart(keys)
    local target = keys.target
    local ability = self:GetAbility()
    if not self:GetParent():IsRealHero() then
		return false
	end
    if keys.attacker ~= self:GetCaster() then return end
    if not self:IsValidToTrigger(target) then return end
    
    self.no_armor = self.ability:GetSpecialValueFor("no_armor")
	self.talentgain = self.ability:GetTalentGain(0.7)
    self.no_armor_t = self.no_armor*self.talentgain

    if IsServer() then
        ability:CastWalrusPunch(target)
    end
   
end

function modifier_heroTalent_npc_dota_hero_tusk:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
    }
end

function modifier_heroTalent_npc_dota_hero_tusk:Advanced_GetModifierAttackArmor_Ignore()
    if self.ability:IsCooldownReady() then
        return self.no_armor_t
    end
    return 0
end

function modifier_heroTalent_npc_dota_hero_tusk:OnTooltip()
	self.crit_multiplier = self.ability:GetSpecialValueFor("crit_mult")
    self.no_armor = self.ability:GetSpecialValueFor("no_armor")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.crit_multiplier_t = self.crit_multiplier*self.talentgain
    self.no_armor_t = self.no_armor*self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.crit_multiplier_t
    elseif self._tooltip == 2 then
        return self.no_armor_t
	end
end

modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:RemoveOnDeath() return true end

function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.crit_multiplier = self.ability:GetSpecialValueFor("crit_mult")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.crit_multiplier_t = self.crit_multiplier*self.talentgain

    if IsServer() then
        local unit = self:GetParent()
        if unit:HaveAchievement("Walrus_punch_1") then
            self.crit_multiplier = self.crit_multiplier + 150
        end
    end
end

function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:Advanced_GetModifierCriticalStrike(keys)
    return self.crit_multiplier_t
end

---@override
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_crit:OnAttackLanded()
    self:GetCaster():EmitSound("Hero_heroTalent_npc_dota_hero_tusk.WalrusPunch.Target")
    self:SafeDestroy()
end


modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying = class({})


function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:IsPurgable() 		    return true end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:IsPurgeException() return true end
function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = IsServer(), -- Not showing the status bar
    }
end


function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end


function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end


function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:OnCreated(keys)
    if IsServer() then


		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
		
		self.forward = self:GetParent():GetForwardVector()
		-- self.newpos = self.pos + self.forward *200
		self.next_step = 0
        self:StartIntervalThink(FrameTime())
    end
end


function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:OnIntervalThink()
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


function modifier_heroTalent_npc_dota_hero_tusk_walrus_punch_flying:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(),self:GetParent():GetAbsOrigin(),true)
		self:GetParent():SetForwardVector( self.forward )
		-- self:GetParent():SetAngles(self.angles.x, self.angles.y, self.angles.z)
    end
end

