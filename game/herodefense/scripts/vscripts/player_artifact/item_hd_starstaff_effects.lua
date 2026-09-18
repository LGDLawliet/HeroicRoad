-- 重做完成
item_hd_starstaff_effects = class({})
LinkLuaModifier("modifier_item_hd_starstaff_effects", "player_artifact/item_hd_starstaff_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_starstaff_effects_thinker", "player_artifact/item_hd_starstaff_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_starstaff_effects_lv70", "player_artifact/item_hd_starstaff_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_starstaff_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_starstaff_effects"
end

function item_hd_starstaff_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/fellomen/bad_21/effect_snapfire_lizard_blobs_arced.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/creeps/spell/fellomen_bad_21/effect.vpcf", context )
end

modifier_item_hd_starstaff_effects = advanced_modifier({})

function modifier_item_hd_starstaff_effects:IsDebuff() return false end
function modifier_item_hd_starstaff_effects:IsHidden() return true end
function modifier_item_hd_starstaff_effects:IsPurgable() return false end
function modifier_item_hd_starstaff_effects:OnCreated(keys)
    local caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
    self.aoe_radius = self.ability:GetArtifactSpecialValueFor("aoe_radius")
    self.cost_get = self.ability:GetArtifactSpecialValueFor("trigger")*self.interval
    self.cost = self.ability:GetArtifactSpecialValueFor("cost")

    self.mp_damage_1 = self.ability:GetArtifactSpecialValueFor("mp_damage_1")*0.007
    self.damage_2 = self.ability:GetArtifactSpecialValueFor("damage_2")
    self.trigger_2 = self.ability:GetArtifactSpecialValueFor("trigger_2")*self.interval
    self.cost_3 = self.ability:GetArtifactSpecialValueFor("cost_3")
    self.cost_back_4 = self.ability:GetArtifactSpecialValueFor("cost_back_4")*0.01
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    self.num_10  = self.ability:GetArtifactSpecialValueFor("num_10")
    self.level = GetArtifactLevel(caster:GetPlayerOwnerID(),"item_hd_starstaff_effects")

    if self.level >= 20 then
        self.cost_get = self.trigger_2
        self.damage = self.damage_2*0.8
    end
    if self.level >= 30 then
        self.cost = self.cost_3
    end
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_starstaff_effects:OnRefresh(keys)
    local caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
    self.aoe_radius = self.ability:GetArtifactSpecialValueFor("aoe_radius")
    self.cost_get = self.ability:GetArtifactSpecialValueFor("trigger")*self.interval
    self.cost = self.ability:GetArtifactSpecialValueFor("cost")

    self.mp_damage_1 = self.ability:GetArtifactSpecialValueFor("mp_damage_1")*0.007
    self.damage_2 = self.ability:GetArtifactSpecialValueFor("damage_2")
    self.trigger_2 = self.ability:GetArtifactSpecialValueFor("trigger_2")*self.interval
    self.cost_3 = self.ability:GetArtifactSpecialValueFor("cost_3")
    self.cost_back_4 = self.ability:GetArtifactSpecialValueFor("cost_back_4")*0.01
    self.level = GetArtifactLevel(caster:GetPlayerOwnerID(),"item_hd_starstaff_effects")
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    self.num_10  = self.ability:GetArtifactSpecialValueFor("num_10")
    if self.level >= 20 then
        self.cost_get = self.trigger_2
        self.damage = self.damage_2*0.8
    end
    if self.level >= 30 then
        self.cost = self.cost_3
    end
end

function modifier_item_hd_starstaff_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end

function modifier_item_hd_starstaff_effects:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp 
end

function modifier_item_hd_starstaff_effects:OnIntervalThink()
    local caster = self:GetCaster()
    local cost_get = self.cost_get
    local cost = self.cost


    caster:AddNewModifier(caster,self.ability,"modifier_hd_trigger",{cost_get = cost_get})

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemies <= 0 then return end

    local trigger = self:GetCaster():FindModifierByName("modifier_hd_trigger")
    if trigger and trigger:GetStackCount() >= cost  then
        self:Starfall(enemies[1],self.cost)
    end

    if self.level >= 100 then
        for i = 1, self.num_10 do
            self:Starfall(enemies[RandomInt(1, #enemies)], 0)
        end
    end
end

function modifier_item_hd_starstaff_effects:Starfall(target,cost)
    local caster = self:GetCaster()
    if not target then return end

    local trigger = self:GetCaster():FindModifierByName("modifier_hd_trigger")
    trigger:SetStackCount(trigger:GetStackCount() - cost)

    local pos_source = caster:GetAbsOrigin() + Vector(RandomInt(-500, 500),RandomInt(-500, 500),3000)
	local pos = target:GetAbsOrigin()
	local vec = pos-pos_source

	local travel_time = 0.8
	local speed= vec:Length()/travel_time
		
	local thinker = CreateModifierThinker(
		caster, -- player source
		nil, -- ability source
		"modifier_item_hd_starstaff_effects_thinker", -- modifier name

		{ travel_time =travel_time }, -- kv
		pos,
		caster:GetTeamNumber(),
		false
	)
	local info = {
        Target = thinker,
        --Source = caster, -- 这里的 Source 主要用于判定攻击者归属（反刃甲等）
        Ability = self:GetAbility(),    
        EffectName = "particles/rebuild/fellomen/bad_21/effect_snapfire_lizard_blobs_arced.vpcf",
        iMoveSpeed = speed,
        bDodgeable = false,

        vSourceLoc = pos_source, 
        --iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION, 
        
        bDrawsOnMinimap = false,
        bVisibleToEnemies = true,
        bProvidesVision = true,
        iVisionRadius = 200, -- 既然提供了 Vision，最好给个半径
        iVisionTeamNumber = caster:GetTeamNumber()
    }

    -- 创建弹道
    ProjectileManager:CreateTrackingProjectile(info)

    local location = pos
    -- 圣物无法做出投射物，因此拟似成立
	caster:GameTimer(0.83, function()
		UTIL_Remove(thinker)
        if not self or not self:GetAbility() then return end

	    local damage = self.damage*caster:HDGetPrimaryStatValue()
	    local impact_radius = self.aoe_radius - 50

        if self.level >= 10 then
            damage = self.mp_damage_1*caster:GetMaxMana() + self.damage*caster:HDGetPrimaryStatValue()
        end
        if cost <= 0 then
            damage = damage* 0.25
        end
	    local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
        hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE,
	    }
        if self.level >= 30 then
            damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE
        end

	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),location,nil,	impact_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	0,	0,	false )
	    for _,enemy in pairs(enemies) do
		    enemy:ApplyMergeDamage(damageTable)
            if self.level >= 40 then
                if not enemy:IsAlive() then
                    local back = self.cost*self.cost_back_4
                    caster:AddNewModifier(caster,self:GetAbility(),"modifier_hd_trigger",{cost_get = back})
                else
                    if self.level >= 70 then
                        local duration = enemy:GetHDStatusResistanceIndex(1)*self.duration_7
                        enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_starstaff_effects_lv70",{duration = duration})
                    end
                end
            end
	    end

	    local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/creeps/spell/fellomen_bad_21/effect.vpcf", PATTACH_WORLDORIGIN, nil)
	    ParticleManager:SetParticleControl(particle_main_fx, 0, location)
	    ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(impact_radius-25, 0, 0))
	    ParticleManager:ReleaseParticleIndex(particle_main_fx)
	    EmitSoundOnLocationWithCaster(location,"Hero_Invoker.ChaosMeteor.Impact",caster)

        
	end)   
end


modifier_item_hd_starstaff_effects_thinker = advanced_modifier({})

modifier_item_hd_starstaff_effects_lv70 = advanced_modifier({})

function modifier_item_hd_starstaff_effects_lv70:IsDebuff() return true end
function modifier_item_hd_starstaff_effects_lv70:IsHidden() return false end
function modifier_item_hd_starstaff_effects_lv70:IsPurgable() return false end
function modifier_item_hd_starstaff_effects_lv70:CheckState()
    return{
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end