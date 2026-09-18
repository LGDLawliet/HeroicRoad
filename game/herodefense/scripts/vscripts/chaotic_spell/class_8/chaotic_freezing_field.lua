LinkLuaModifier( "modifier_chaotic_freezing_field_slow", "chaotic_spell/class_8/chaotic_freezing_field.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_freezing_field_thinker", "chaotic_spell/class_8/chaotic_freezing_field.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_freezing_field_incoming", "chaotic_spell/class_8/chaotic_freezing_field.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_freezing_field = class({})

function chaotic_freezing_field:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1_shard.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_ice_age.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", context )
end
function chaotic_freezing_field:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function chaotic_freezing_field:GetChannelTime()
	return self:GetSpecialValueFor("max_channel_time")
end

function chaotic_freezing_field:OnSpellStart()
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")

	self.sound_cast = "hero_Crystal.freezingField.wind"
    EmitSoundOn( self.sound_cast, caster)
	-- 创建思考者实体来控制爆炸
	self.thinker = CreateUnitByName("npc_dota_thinker", target_point, false, caster, caster, caster:GetTeam())
	self.thinker:AddNewModifier(caster, self, "modifier_chaotic_freezing_field_thinker", {radius = radius, duration = self:GetChannelTime()})
    self.buff = caster:AddNewModifier(caster, self, "modifier_chaotic_freezing_field_incoming", {duration = self:GetChannelTime()})
end

function chaotic_freezing_field:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	StopSoundOn( self.sound_cast, caster)
	-- 如果被中断，移除思考者
	if bInterrupted then
		if self.thinker then
            self.thinker:RemoveSelf()
            self.thinker = nil
        end
        if self.buff then
            self.buff:Destroy()
            self.buff = nil
        end
	end
end

function chaotic_freezing_field:ExplosionEffect(center_pos, radius)
	-- 播放爆炸粒子效果
    local caster = self:GetCaster()
	local particle_explosion = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf"
	
	-- 生成三个不同的随机位置
	local positions = {}
	local attempts = 0
	local max_attempts = 20
	
	while #positions < 5 and attempts < max_attempts do
		local random_angle = math.random() * 2 * math.pi
		local random_distance = math.random() * radius
		local new_pos = center_pos + Vector(math.cos(random_angle) * random_distance, math.sin(random_angle) * random_distance, 0)
		-- 检查是否与已有位置重复
		local is_duplicate = false
		for _, existing_pos in pairs(positions) do
			if (new_pos - existing_pos):Length2D() < 50 then -- 最小距离50单位
				is_duplicate = true
				break
			end
		end
		if not is_duplicate then
			table.insert(positions, new_pos)
		end
		attempts = attempts + 1
	end
	
	-- 在三个位置创建爆炸效果
	for _, position in pairs(positions) do
		local effect_explosion = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect_explosion, 0, position)
		ParticleManager:SetParticleControl(effect_explosion, 1, Vector(100, 0, 0)) -- 设置爆炸半径
		ParticleManager:ReleaseParticleIndex(effect_explosion)

        local sound_cast = "hero_Crystal.freezingField.explosion"
	    EmitSoundOnLocationWithCaster( position, sound_cast, caster)
	end
end

-- 减伤modifier
modifier_chaotic_freezing_field_incoming = advanced_modifier({})

function modifier_chaotic_freezing_field_incoming:IsHidden() return true end
function modifier_chaotic_freezing_field_incoming:IsDebuff() return false end
function modifier_chaotic_freezing_field_incoming:IsPurgable() return false end
function modifier_chaotic_freezing_field_incoming:OnCreated()
    self.ability = self:GetAbility()
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.caster = self:GetCaster()
    self.parent = self:GetParent()

    if self.ability:GetRuneType() == 1 then
        self.incoming = self.ability:GetSpecialValueFor("rune_1_incoming")
        self.rune_1_radius = self.ability:GetSpecialValueFor("rune_1_radius")
        self.rune_1_freezing = self.ability:GetSpecialValueFor("rune_1_freezing")
        if IsServer() then
            self:StartIntervalThink(1)
            self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0,self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(self.rune_1_radius,self.rune_1_radius,self.rune_1_radius), false )
            self:AddParticle( self.nFXIndex, false, false, -1, false, false )
        end
    end
end

function modifier_chaotic_freezing_field_incoming:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end

    self.caster:EmitSound("Hero_Lich.IceAge.Tick")
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector(self.rune_1_radius,self.rune_1_radius,self.rune_1_radius))
	ParticleManager:ReleaseParticleIndex( effect_cast )
    
    local freezing = self.rune_1_freezing*self.caster:HDGetPrimaryStatValue()
    local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.rune_1_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i , enemy in ipairs(enemies) do
        enemy:Freezing(self.caster, self.ability, freezing)
    end
end

function modifier_chaotic_freezing_field_incoming:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_chaotic_freezing_field_incoming:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return -self.incoming
end

-- thinker的modifier
modifier_chaotic_freezing_field_thinker = advanced_modifier({})

function modifier_chaotic_freezing_field_thinker:IsHidden() return true end
function modifier_chaotic_freezing_field_thinker:IsDebuff() return false end
function modifier_chaotic_freezing_field_thinker:IsPurgable() return false end

function modifier_chaotic_freezing_field_thinker:OnCreated(kv)
	if not IsServer() then return end
	
	self.radius = kv.radius
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.freezing = self.ability:GetSpecialValueFor("freezing")
    self.bonus_freezing = self.ability:GetSpecialValueFor("bonus_freezing")
    self.max_stack = self.ability:GetSpecialValueFor("max_stack")

	local particle_cast = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1_shard.vpcf"
    
    self.particle = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius*1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)

	self:StartIntervalThink(1)
end

function modifier_chaotic_freezing_field_thinker:OnDestroy(keys)
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
		end
		UTIL_Remove(self:GetParent())
	end
end

function modifier_chaotic_freezing_field_thinker:CheckState()
	return{
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}
end

function modifier_chaotic_freezing_field_thinker:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    -- 随机爆炸特效
	local center_pos = self.parent:GetAbsOrigin()
	self.ability:ExplosionEffect(center_pos, self.radius)

    local freezing = self.freezing + self.bonus_freezing*self.caster:HDGetPrimaryStatValue()
    local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i , enemy in ipairs(enemies) do
        enemy:Freezing(self.caster, self.ability, freezing)

        if not enemy:HasModifier("modifier_hd_freezing_frozen") then
            local slow = enemy:FindModifierByName("modifier_chaotic_freezing_field_slow")
            if slow then
                slow:ForceRefresh()
                slow:SetDuration(2, true)
                slow:SetStackCount(math.min(slow:GetStackCount()+1, self.max_stack))
                if slow:GetStackCount() >= self.max_stack then
                    slow:Destroy()
                    enemy:AddNewModifier(self.caster, self.ability, "modifier_hd_freezing_frozen", {duration = 3})
                end
            else
                local slow = enemy:AddNewModifier(self.caster, self.ability, "modifier_chaotic_freezing_field_slow", {duration = 2})
				if slow then
                	slow:SetStackCount(1)
				end
            end
        end
    end
end



-- 减速
modifier_chaotic_freezing_field_slow = advanced_modifier({})

function modifier_chaotic_freezing_field_slow:IsHidden() return false end
function modifier_chaotic_freezing_field_slow:IsDebuff() return true end
function modifier_chaotic_freezing_field_slow:IsPurgable() return true end

function modifier_chaotic_freezing_field_slow:OnCreated()
	self.slow_movement = self:GetAbility():GetSpecialValueFor("move")
	self.slow_attack = self:GetAbility():GetSpecialValueFor("attack_slow")
end

function modifier_chaotic_freezing_field_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_freezing_field_slow:GetModifierMoveSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
	return -self.slow_movement*self:GetStackCount()
end

function modifier_chaotic_freezing_field_slow:GetModifierAttackSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
	return -self.slow_attack*self:GetStackCount()
end

function modifier_chaotic_freezing_field_slow:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:GetModifierMoveSpeedBonus_Percentage()
	end
	if self._tooltip == 2 then
		return  self:GetModifierAttackSpeedBonus_Constant()
	end
end
