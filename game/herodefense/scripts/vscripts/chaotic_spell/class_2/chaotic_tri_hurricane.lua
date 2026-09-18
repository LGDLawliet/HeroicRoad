
chaotic_tri_hurricane = class({})

LinkLuaModifier("modifier_chaotic_tri_hurricane", "chaotic_spell/class_2/chaotic_tri_hurricane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_hurricane_move", "chaotic_spell/class_2/chaotic_tri_hurricane", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_chaotic_tri_hurricane_rune_3", "chaotic_spell/class_2/chaotic_tri_hurricane", LUA_MODIFIER_MOTION_NONE)
function chaotic_tri_hurricane:GetIntrinsicModifierName()
    return "modifier_chaotic_tri_hurricane"
end
function chaotic_tri_hurricane:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", context )

end

modifier_chaotic_tri_hurricane = class({})


function modifier_chaotic_tri_hurricane:IsHidden()return true end
function modifier_chaotic_tri_hurricane:IsDebuff()return false end
function modifier_chaotic_tri_hurricane:IsPurgable()return false end
function modifier_chaotic_tri_hurricane:GetTexture()return "sandking_sand_storm" end

function modifier_chaotic_tri_hurricane:OnCreated()
    self.cost = self:GetAbility():GetSpecialValueFor("cost")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.cd = self:GetAbility():GetSpecialValueFor("cd")
    self.count = 0
end

function modifier_chaotic_tri_hurricane:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
    if self:GetAbility():GetRuneType()==1 then
        table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT)
    end
    return funcs
end

function modifier_chaotic_tri_hurricane:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("rune_1_speed")
end

function modifier_chaotic_tri_hurricane:OnAbilityExecuted(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    local parent = self:GetParent()
    local ability = self:GetAbility()
    self.cost_get = params.ability:GetCooldown(params.ability:GetLevel()) *ability:GetSpecialValueFor("cost_get")
    parent:AddNewModifier(parent,ability,"modifier_hd_trigger",{cost_get = self.cost_get})

    local trigger = parent:FindModifierByName("modifier_hd_trigger")
    if trigger and trigger:GetStackCount() >= self.cost and ability:GetAutoCastState() and ability:IsCooldownReady() then
        local position = ability:GetCursorPosition()
        if self:GetAbility():GetRuneType()==3 then
            position = parent:GetAbsOrigin()
            parent:AddNewModifier(parent,ability,"modifier_chaotic_tri_hurricane_rune_3",{duration = ability:GetSpecialValueFor("rune_3_duration")})
        end
        self:Hurricane(position)
        trigger:SetStackCount(trigger:GetStackCount() - self.cost)
        ability:StartCooldown(self.cd)
    end 
end

function modifier_chaotic_tri_hurricane:Hurricane(position)
    -- 获取鼠标位置
    local cursor_pos = position
    local radius = self.radius
    local parent = self:GetParent()
    local ability = self:GetAbility()
    
    if self:GetAbility():GetRuneType()==2 then
        self.count = self.count + 1
        if self.count >= 4 then
            self.count = 0
            radius = self.radius + self:GetAbility():GetSpecialValueFor("rune_2_radius")
        end
    end
    -- 播放音效
    EmitSoundOnLocationWithCaster(cursor_pos, "Hero_Sandking.SandStorm.loop", parent)
    
    -- 创建沙尘暴特效
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(particle, 0, cursor_pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
    
    -- 查找范围内的敌人
    local units = FindUnitsInRadius(
        parent:GetTeamNumber(),
        cursor_pos,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        0,
        false
    )
    
    -- 处理每个敌人
    for _, unit in pairs(units) do
        -- 添加眩晕状态
        unit:AddNewModifier(parent, ability, "modifier_stunned", {duration = self.duration})
        -- 将单位移动到中心点
        unit:AddNewModifier(parent, ability,"modifier_chaotic_tri_hurricane_move",{duration = 0.3, x = cursor_pos.x, y = cursor_pos.y,})
    end
    
    -- 延迟清理特效
    parent:GameTimer(0.5, function()
        ParticleManager:DestroyParticle(particle, false)
        StopSoundOn("Hero_Sandking.SandStorm.loop", parent)
    end)
end



-------------------------------------------------------------------
modifier_chaotic_tri_hurricane_move = advanced_modifier({})

function modifier_chaotic_tri_hurricane_move:IsHidden()return false end
function modifier_chaotic_tri_hurricane_move:IsDebuff()return true end
function modifier_chaotic_tri_hurricane_move:IsStunDebuff()return true end
function modifier_chaotic_tri_hurricane_move:IsPurgable()return false end


function modifier_chaotic_tri_hurricane_move:OnCreated( kv )
    if not IsServer() then
        return
    end

	local center = Vector( kv.x, kv.y, 0 )
	self.direction = center - self:GetParent():GetOrigin()
	self.speed = self.direction:Length2D()/self:GetDuration()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_chaotic_tri_hurricane_move:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_chaotic_tri_hurricane_move:OnDestroy()
	if not IsServer() then
        return
    end
	self:GetParent():RemoveHorizontalMotionController( self )
    self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.05}) --提供相位，防止卡位
end

function modifier_chaotic_tri_hurricane_move:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_chaotic_tri_hurricane_move:UpdateHorizontalMotion( me, dt )
	local target = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( target )
end

function modifier_chaotic_tri_hurricane_move:OnHorizontalMotionInterrupted()
	self:Destroy()
end

-------------------------------------------------------------------
modifier_chaotic_tri_hurricane_rune_3 = advanced_modifier({})

function modifier_chaotic_tri_hurricane_rune_3:IsHidden()return true end
function modifier_chaotic_tri_hurricane_rune_3:IsDebuff()return false end
function modifier_chaotic_tri_hurricane_rune_3:IsPurgable()return false end
function modifier_chaotic_tri_hurricane_rune_3:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_chaotic_tri_hurricane_rune_3:Advanced_GetModifierIncomingDamage_Percentage()
    return -self:GetAbility():GetSpecialValueFor("rune_3_incoming")
end