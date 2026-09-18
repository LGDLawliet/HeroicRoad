-- 重写完成
item_hd_ice_slash_effects = class({})
LinkLuaModifier("modifier_item_hd_ice_slash_effects", "player_artifact/item_hd_ice_slash_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_slash_effects_debuff", "player_artifact/item_hd_ice_slash_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_slash_effects_lv40", "player_artifact/item_hd_ice_slash_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_ice_slash_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_ice_slash_effects"
end
function item_hd_ice_slash_effects:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf", context )
end
modifier_item_hd_ice_slash_effects = advanced_modifier({})

function modifier_item_hd_ice_slash_effects:IsDebuff() return false end
function modifier_item_hd_ice_slash_effects:IsHidden() return true end
function modifier_item_hd_ice_slash_effects:IsPurgable() return false end
function modifier_item_hd_ice_slash_effects:RemoveOnDeath() return false end
function modifier_item_hd_ice_slash_effects:DestroyOnExpire() return false end

function modifier_item_hd_ice_slash_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_attack = self.ability:GetArtifactSpecialValueFor("bonus_attack")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.crit_mult = self.ability:GetArtifactSpecialValueFor("crit_mult")
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.hpcost = self.ability:GetArtifactSpecialValueFor("hpcost")*0.01
    self.chance_1 = self.ability:GetArtifactSpecialValueFor("chance_1")
    self.steal_3 = self.ability:GetArtifactSpecialValueFor("steal_3")*0.01
    self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.crit_mult_4 = self.ability:GetArtifactSpecialValueFor("crit_mult_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.crit_mult_10 = self.ability:GetArtifactSpecialValueFor("crit_mult_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_ice_slash_effects")

    if self.level >= 20 then
        self.incoming = self.ability:GetArtifactSpecialValueFor("incoming_2")
        self.duration = self.ability:GetArtifactSpecialValueFor("duration_2")
    end
    if self.level >= 70 then
        self.chance = self.chance_7
    end
    if self.level >= 100 then
        self.crit_mult_4 = self.crit_mult_10
    end
    self.record = {}
end

function modifier_item_hd_ice_slash_effects:OnRefresh(keys)
    self.bonus_attack = self.ability:GetArtifactSpecialValueFor("bonus_attack")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.crit_mult = self.ability:GetArtifactSpecialValueFor("crit_mult")
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.hpcost = self.ability:GetArtifactSpecialValueFor("hpcost")*0.01
    self.chance_1 = self.ability:GetArtifactSpecialValueFor("chance_1")
    self.steal_3 = self.ability:GetArtifactSpecialValueFor("steal_3")*0.01
    self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.crit_mult_4 = self.ability:GetArtifactSpecialValueFor("crit_mult_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.crit_mult_10 = self.ability:GetArtifactSpecialValueFor("crit_mult_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_ice_slash_effects")

    if self.level >= 20 then
        self.incoming = self.ability:GetArtifactSpecialValueFor("incoming_2")
        self.duration = self.ability:GetArtifactSpecialValueFor("duration_2")
    end
    if self.level >= 70 then
        self.chance = self.chance_7
    end
    if self.level >= 100 then
        self.crit_mult_4 = self.crit_mult_10
    end
end

function modifier_item_hd_ice_slash_effects:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end

function modifier_item_hd_ice_slash_effects:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_hd_ice_slash_effects:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack
end

function modifier_item_hd_ice_slash_effects:Advanced_GetModifierCriticalStrike( keys )
	if not IsServer() then return end
    local target = keys.target
	local random = math.random
    local chance = self.chance
    
    local modifier = target:HasModifier("modifier_item_hd_ice_slash_effects_debuff")
    if modifier and self.level >= 10  then
        chance = chance + self.chance_1
    end

    local modifier_lv40 = target:HasModifier("modifier_item_hd_ice_slash_effects_lv40")

    local randomint = random(1,100)
	if chance >= randomint then
        
		self.record[keys.record] = true
		local crit_mult = self.crit_mult

        if self.level < 10 or not modifier then 
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_ice_slash_effects_debuff", {duration = self.duration, stack = self.incoming})
        end
        if self.level >= 40 and self:GetRemainingTime() < 0  then
            self:SetDuration(self.cd_4, true)
            self:BloodSlash(target)
        end
        self:PlayEffects2( target )
		return crit_mult
	else
        self.record[keys.record] = nil
        if self.level >= 40 and modifier_lv40 then
            self:PlayEffects2( target )
            return self.crit_mult_4
        end
        return 0
    end
    return 0
end

function modifier_item_hd_ice_slash_effects:OnTakeDamage( params )
	if not IsServer() then return end   
    if self.level < 30 then return end
    if params.attacker ~= self:GetParent() then return end
    
	local pass = false
	if self.record[params.record] then
		pass = true
		self.record[params.record]= nil
	end

	if pass then
		local heal = params.damage * self.steal_3
		local gain = self:GetParent():GetModifierLifeStealGain(1)
		local flLifesteal =heal*gain
        if self:GetParent():GetHealthPercent() <= self.line_3 then
            flLifesteal = flLifesteal*2
        end
		self:GetParent():Heal( flLifesteal, self:GetAbility())
    end
end

function modifier_item_hd_ice_slash_effects:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg.vpcf"
	local sound_target = "Hero_Grimstroke.DarkArtistry.Damage"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_target, target )
end

function modifier_item_hd_ice_slash_effects:BloodSlash(target)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if not target then return end

	local caster = self:GetCaster()
	local point = target:GetAbsOrigin() 

	local projectile_name = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf"
	local distance = 1200
	local start_radius = 150
	local end_radius = 150
	local speed = 2400

	local spawnPos = caster:GetAbsOrigin()
    if point==spawnPos then
		point = point +caster:GetForwardVector()
	end
	local direction = point-spawnPos
	direction.z = 0
	direction = direction:Normalized()
    local target_pos = spawnPos + direction* distance


	local info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = spawnPos,
		
	    bDeleteOnHit = false,

	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius =end_radius,
		vVelocity = direction * speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = true,

		EffectSound = "Hero_Grimstroke.DarkArtistry.Projectile",
		ProjectileSound = "Hero_Grimstroke.DarkArtistry.Projectile",
		SoundName = "Hero_Grimstroke.DarkArtistry.Projectile",
		Sound = "Hero_Grimstroke.DarkArtistry.Projectile",
		SoundEvent = "Hero_Grimstroke.DarkArtistry.Projectile",
	}
	local particle = ProjectileManager:CreateLinearProjectile(info)
    local enemies = FindUnitsInLine(caster:GetTeamNumber(), spawnPos, target_pos,nil, start_radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
    for _,enemy in pairs(enemies)do
        local distance = CalculateDistance(enemy,target)
        local delay = distance/speed
        caster:GameTimer(delay,function(...)
            if self:GetAbility() and enemy:IsAlive() then
                self:PlayEffects2( enemy )
                enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_ice_slash_effects_lv40", {duration = self.duration_4})
            end
        end)
    end
    
    -- 当等级 >= 100 时，创建左右各30度的额外弹道
    if self.level >= 100 then
        -- 计算旋转30度的方向向量
        local angle_rad = math.rad(30) -- 30度转换为弧度
        local cos_angle = math.cos(angle_rad)
        local sin_angle = math.sin(angle_rad)
        
        -- 左侧30度方向 (逆时针旋转)
        local left_direction = Vector(
            direction.x * cos_angle - direction.y * sin_angle,
            direction.x * sin_angle + direction.y * cos_angle,
            0
        )
        left_direction = left_direction:Normalized()
        local left_target_pos = spawnPos + left_direction * distance
        
        -- 右侧30度方向 (顺时针旋转)
        local right_direction = Vector(
            direction.x * cos_angle + direction.y * sin_angle,
            -direction.x * sin_angle + direction.y * cos_angle,
            0
        )
        right_direction = right_direction:Normalized()
        local right_target_pos = spawnPos + right_direction * distance
        
        -- 创建左侧弹道 (复用基础info并修改方向)
        local left_info = {}
        for k, v in pairs(info) do
            left_info[k] = v
        end
        left_info.vVelocity = left_direction * speed
        
        local left_particle = ProjectileManager:CreateLinearProjectile(left_info)
        local left_enemies = FindUnitsInLine(caster:GetTeamNumber(), spawnPos, left_target_pos, nil, start_radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
        for _,enemy in pairs(left_enemies) do
            local distance = CalculateDistance(enemy, target)
            local delay = distance/speed
            caster:GameTimer(delay, function(...)
                if self:GetAbility() and enemy:IsAlive() then
                    self:PlayEffects2( enemy )
                    enemy:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_ice_slash_effects_lv40", {duration = self.duration_4})
                end
            end)
        end
        
        -- 创建右侧弹道 (复用基础info并修改方向)
        local right_info = {}
        for k, v in pairs(info) do
            right_info[k] = v
        end
        right_info.vVelocity = right_direction * speed
        
        local right_particle = ProjectileManager:CreateLinearProjectile(right_info)
        local right_enemies = FindUnitsInLine(caster:GetTeamNumber(), spawnPos, right_target_pos, nil, start_radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
        for _,enemy in pairs(right_enemies) do
            local distance = CalculateDistance(enemy, target)
            local delay = distance/speed
            caster:GameTimer(delay, function(...)
                if self:GetAbility() and enemy:IsAlive() then
                    self:PlayEffects2( enemy )
                    enemy:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_ice_slash_effects_lv40", {duration = self.duration_4})
                end
            end)
        end
    end
end
-----
modifier_item_hd_ice_slash_effects_debuff = advanced_modifier({})

function modifier_item_hd_ice_slash_effects_debuff:IsDebuff() return true end
function modifier_item_hd_ice_slash_effects_debuff:IsHidden() return false end
function modifier_item_hd_ice_slash_effects_debuff:IsPurgable() return false end
function modifier_item_hd_ice_slash_effects_debuff:GetTexture() return "item_artifact_57" end

function modifier_item_hd_ice_slash_effects_debuff:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
		self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
	end
end

function modifier_item_hd_ice_slash_effects_debuff:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_item_hd_ice_slash_effects_debuff:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_ice_slash_effects_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if keys.damage_type == DAMAGE_TYPE_PHYSICAL then
        return self:GetStackCount()
    end
	return 0
end
function modifier_item_hd_ice_slash_effects_debuff:OnTooltip()
	return self:GetStackCount()
end

-----
modifier_item_hd_ice_slash_effects_lv40= advanced_modifier({})

function modifier_item_hd_ice_slash_effects_lv40:IsDebuff() return true end
function modifier_item_hd_ice_slash_effects_lv40:IsHidden() return false end
function modifier_item_hd_ice_slash_effects_lv40:IsPurgable() return false end
function modifier_item_hd_ice_slash_effects_lv40:GetTexture() return "item_artifact_57" end