chaotic_black_hole = class({})



LinkLuaModifier("modifier_chaotic_black_hole_singularity", "chaotic_spell/class_super/chaotic_black_hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_black_hole_thinker", "chaotic_spell/class_super/chaotic_black_hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_black_hole_out_pull", "chaotic_spell/class_super/chaotic_black_hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_black_hole_aura", "chaotic_spell/class_super/chaotic_black_hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_black_hole_rune1", "chaotic_spell/class_super/chaotic_black_hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)

function chaotic_black_hole:GetBehavior() 
    if self:GetRuneType() == 1 then
        return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
    end
    return self.BaseClass.GetBehavior( self )
end

function chaotic_black_hole:GetChannelTime() 
    return self:GetSpecialValueFor("duration")
end

function chaotic_black_hole:GetAOERadius() 
	local caster = self:GetCaster()
    return self:GetSpecialValueFor("radius") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_radius")
end

function chaotic_black_hole:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
    local type = self:GetRuneType()
    self.radius = self:GetSpecialValueFor("radius") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_radius")
	self.radius = math.min(self.radius, 2000)
	
	if type == 1 then
		pos = caster:GetAbsOrigin()
		self.pos = caster:GetAbsOrigin()
		caster:AddNewModifier(caster, self, "modifier_chaotic_black_hole_rune1", {duration = self:GetChannelTime()})
	end

    self.pos = pos
	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetChannelTime() + FrameTime() * 2}, pos, caster:GetTeamNumber(), false)
	self.thinker:AddNewModifier(caster, self, "modifier_chaotic_black_hole_thinker", {duration = self:GetChannelTime()})
end

function chaotic_black_hole:OnChannelFinish(a)
	if self.thinker and not self.thinker:IsNull() then
		UTIL_Remove(self.thinker)
		self.thinker = nil
	end
end
-------------------
modifier_chaotic_black_hole_thinker = advanced_modifier({})

function modifier_chaotic_black_hole_thinker:OnCreated()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    self.ability = self:GetAbility()
    self.interval = self.ability:GetSpecialValueFor("interval")
    self.type = self.ability:GetRuneType()
    self.kill_line = self.ability:GetSpecialValueFor("kill_line")

    self.rune_1_outgoing = self.ability:GetSpecialValueFor("rune_1_outgoing")
    self.rune_1_index = self.ability:GetSpecialValueFor("rune_1_index")

	if IsServer() then
        self.radius = self.ability:GetSpecialValueFor("radius") + caster:HDGetPrimaryStatValue()*self.ability:GetSpecialValueFor("bonus_radius")
        if self.ability:GetRuneType() == 1 then
            self.radius = self.radius*(1+self.ability:GetSpecialValueFor("rune_1_radius")*0.01)
        end

        self.damageTable = {
            --victim = enemy[i],
			attacker = caster,
			--damage = dmg,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self.ability, --Optional.
            hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
        }

		local pos = parent:GetAbsOrigin()
		pos.z = pos.z + 100

		local hole_pfx = "particles/units/heroes/hero_enigma/enigma_blackhole_rebuild.vpcf"
		local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		local index = self.radius/450
		ParticleManager:SetParticleControl(pfx, 10, Vector(index,0,0))
        parent:EmitSound("Hero_Enigma.Black_Hole")

		-- if radius >= 500 then
		-- 	ParticleManager:SetParticleControl(pfx, 60, Vector(30,30,30))
		-- 	ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
		-- 	parent:EmitSound("Imba.EnigmaBlackHoleTobi0"..math.random(1, 5))
		-- end
		self:AddParticle(pfx, false, false, 15, false, false)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_chaotic_black_hole_thinker:OnIntervalThink()
	local caster = self:GetCaster()
    local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ability then self:SafeDestroy() return end

    local dmg = (self.ability:GetSpecialValueFor("damage") + self.ability:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())
    self.damageTable.damage = dmg

	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
    if self.type == 1 then
        local rune1 = caster:FindModifierByName("modifier_chaotic_black_hole_rune1")
        if rune1 then
            rune1:SetStackCount(0)
            for i=1, #enemy do
                if enemy[i]:IsChaoticEraElite() then
                    rune1:SetStackCount(rune1:GetStackCount() + self.rune_1_index*self.rune_1_outgoing)
                else
                    rune1:SetStackCount(rune1:GetStackCount() + self.rune_1_outgoing)
                end
            end
        end
    end

    for i=1, #enemy do
        

        self.damageTable.victim = enemy[i]
		ApplyDamage(self.damageTable)
        if enemy[i]:IsAlive() then
            if enemy[i]:GetHealthPercent() <= self.kill_line then
                TrueKill(caster,enemy[i])
            end
        end
	end

    

	local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1, #enemies2 do
		if not enemies2[i]:HasModifier("modifier_chaotic_black_hole_aura") then
			enemies2[i]:AddNewModifier(caster, ability, "modifier_chaotic_black_hole_out_pull", {})
		end
	end
end

function modifier_chaotic_black_hole_thinker:IsAura() return true end
function modifier_chaotic_black_hole_thinker:GetAuraDuration() return 0.1 end
function modifier_chaotic_black_hole_thinker:GetModifierAura() return "modifier_chaotic_black_hole_aura" end
function modifier_chaotic_black_hole_thinker:GetAuraRadius() return self.radius end
function modifier_chaotic_black_hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_chaotic_black_hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_black_hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_chaotic_black_hole_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
	end
end
----------------------
modifier_chaotic_black_hole_aura = advanced_modifier({})

function modifier_chaotic_black_hole_aura:IsDebuff()			return true end
function modifier_chaotic_black_hole_aura:IsHidden() 			return false end
function modifier_chaotic_black_hole_aura:IsPurgable() 			return false end
function modifier_chaotic_black_hole_aura:IsPurgeException() 	return false end
function modifier_chaotic_black_hole_aura:IsStunDebuff()		return true end
function modifier_chaotic_black_hole_aura:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_chaotic_black_hole_aura:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_chaotic_black_hole_aura:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_chaotic_black_hole_aura:IsMotionController() return true end
function modifier_chaotic_black_hole_aura:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_chaotic_black_hole_aura:OnCreated()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	self.parent  = self:GetParent()
	if IsServer() then
		self.radius = self.ability:GetSpecialValueFor("radius") + caster:HDGetPrimaryStatValue()*self.ability:GetSpecialValueFor("bonus_radius")
    	if self.ability:GetRuneType() == 1 then
       	 	self.radius = self.radius*(1+self.ability:GetSpecialValueFor("rune_1_radius")*0.01)
    	end

		if self:CheckMotionControllers() then
			if self.parent:IsHero() then
				local pfx = ParticleManager:CreateParticleForPlayer("particles/hero/enigma/screen_blackhole_indicator.vpcf", PATTACH_EYES_FOLLOW, self.parent, PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()))
			    self:AddParticle(pfx, false, false, 15, false, false)
				PlayerResource:SetCameraTarget(self.parent:GetPlayerOwnerID(), self.parent)
			end
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_chaotic_black_hole_aura:OnIntervalThink()
    local ability = self:GetAbility()
    local distance = (self.parent:GetAbsOrigin() - ability.pos):Length2D()
    
    -- 获取技能持续时间
    local duration = ability:GetChannelTime()
    -- 计算所需的最小速度（确保在70%时间内到达）
    local min_speed = (distance / (duration * 0.7)) * (1.0 / FrameTime())
    
    -- 使用较大的速度值，但保持较小的基础速度以维持漩涡效果
    local in_pull = math.max(250, min_speed * 0.15)  -- 降低速度系数以保持漩涡效果
    
    -- 保持旋转效果
    local new_pos = GetGroundPosition(RotatePosition(ability.pos, QAngle(0,3,0), self.parent:GetAbsOrigin()),self.parent)
    if distance > 20 then
        local direction = (ability.pos - new_pos):Normalized()
        direction.z = 0.0
        new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
    end
    self.parent:SetOrigin(new_pos)
end

function modifier_chaotic_black_hole_aura:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.parent, self.parent:GetOrigin(), true)
		if self.parent:IsHero() then
		PlayerResource:SetCameraTarget(self.parent:GetPlayerID(), nil)
	end
	end
end
-------------
modifier_chaotic_black_hole_out_pull = advanced_modifier({})

function modifier_chaotic_black_hole_out_pull:IsDebuff()			return false end
function modifier_chaotic_black_hole_out_pull:IsHidden() 			return true end
function modifier_chaotic_black_hole_out_pull:IsPurgable() 			return false end
function modifier_chaotic_black_hole_out_pull:IsPurgeException() 	return false end
function modifier_chaotic_black_hole_out_pull:IsMotionController() return true end
function modifier_chaotic_black_hole_out_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_chaotic_black_hole_out_pull:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_chaotic_black_hole_out_pull:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_chaotic_black_hole_aura") then
        self:SafeDestroy()
        return
    end
    
    local ability = self:GetAbility()
    local out_distance = ability:GetSpecialValueFor("pull_distance")
    
    if not ability:IsChanneling() or (self:GetParent():GetAbsOrigin() - ability.pos):Length2D() > out_distance or self:GetParent():IsBoss() then
        self:SafeDestroy()
    end
    
    -- 计算当前距离
    local distance = (self:GetParent():GetAbsOrigin() - ability.pos):Length2D()
    -- 获取技能持续时间
    local duration = ability:GetChannelTime()
    -- 计算最小所需速度
    local min_speed = distance / duration
    -- 使用较大的速度值
    local out_pull = math.max(ability:GetSpecialValueFor("pull_speed"), min_speed)
    
    local direction = (ability.pos - self:GetParent():GetAbsOrigin()):Normalized()
    direction.z = 0.0
    local new_pos = self:GetParent():GetAbsOrigin() + direction * (out_pull / (1.0 / FrameTime()))
    
    self:GetParent():SetOrigin(new_pos)
end

function modifier_chaotic_black_hole_out_pull:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_chaotic_black_hole_aura") then
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x,pos.y,pos.z) ,true)
	end
end

----------------------
modifier_chaotic_black_hole_rune1 = advanced_modifier({})

function modifier_chaotic_black_hole_rune1:IsHidden()	return false end
function modifier_chaotic_black_hole_rune1:IsDebuff()	return false end
function modifier_chaotic_black_hole_rune1:IsPurgable()	return false end
function modifier_chaotic_black_hole_rune1:RemoveOnDeath()	return false end
function modifier_chaotic_black_hole_rune1:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end
function modifier_chaotic_black_hole_rune1:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_chaotic_black_hole_rune1:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return  self:GetStackCount()
end
function modifier_chaotic_black_hole_rune1:OnCreated()
    self.ability = self:GetAbility()
    self.rune_1_duration = self.ability:GetSpecialValueFor("rune_1_duration")
    self:SetStackCount(0)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self:GetCaster():AddNoDraw()
	end
end
function modifier_chaotic_black_hole_rune1:OnIntervalThink()
	if not self:GetCaster():IsChanneling() then
		self:SafeDestroy()
	end
end
function modifier_chaotic_black_hole_rune1:OnDestroy()
    local caster = self:GetCaster()
	if IsServer() then
		caster:RemoveNoDraw()
        if not self:GetAbility() then return end
        
        if caster:IsAlive() then
            caster:ModifyHealth(caster:GetMaxHealth(), self:GetAbility(), false, 0)
            caster:GiveMana(caster:GetMaxMana())
            caster:AddNewModifier(caster,self:GetAbility(),"modifier_invulnerable",{duration = self.rune_1_duration})
        end
    end
end