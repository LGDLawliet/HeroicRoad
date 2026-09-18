
heroTalent_npc_dota_hero_primal_beast_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_primal_beast_3", "heroTalent/heroTalent_npc_dota_hero_primal_beast_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff", "heroTalent/heroTalent_npc_dota_hero_primal_beast_3", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip", "heroTalent/heroTalent_npc_dota_hero_primal_beast_3", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_primal_beast_3:Precache( context )
	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", context )
end

-- 获取施法时的动画
function heroTalent_npc_dota_hero_primal_beast_3:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end
-- 获取技能引导时间
function heroTalent_npc_dota_hero_primal_beast_3:GetChannelTime()
    local duration = self:GetSpecialValueFor( "channel_time" )
    local talentgain = self:GetTalentGain(0.75)
    duration = duration*talentgain
	return duration
end
function heroTalent_npc_dota_hero_primal_beast_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip"
end
-- 存储被该技能影响的目标修饰器
heroTalent_npc_dota_hero_primal_beast_3.modifiers = {}
-- 技能开始施法时调用
function heroTalent_npc_dota_hero_primal_beast_3:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "channel_time" )
    local talentgain = self:GetTalentGain(0.75)
    duration = duration*talentgain
	-- 给目标添加负面效果修饰器（控制目标）
	local mod = target:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff",{ duration = duration, time = duration })
	-- 记录该修饰器
	self.modifiers[mod] = true
	-- 给施法者添加正面效果修饰器（限制施法者转向）
	caster:AddNewModifier(caster,self, "modifier_heroTalent_npc_dota_hero_primal_beast_3",{ duration = duration })

	EmitSoundOn( "Hero_PrimalBeast.Pulverize.Cast", caster )
end

function heroTalent_npc_dota_hero_primal_beast_3:OnChannelFinish( bInterrupted )
	-- 移除所有目标上的修饰器
	for mod,_ in pairs(self.modifiers) do
		if not mod:IsNull() then
			mod:Destroy()
		end
	end
	self.modifiers = {}

	-- 移除施法者身上的修饰器
	local self_mod = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_primal_beast_3" )
	if self_mod then
		self_mod:Destroy()
	end
end

-- 当某个目标的修饰器被移除时调用
function heroTalent_npc_dota_hero_primal_beast_3:RemoveModifier( mod )
	-- 从记录中移除该修饰器
	self.modifiers[mod] = nil
	-- 检查是否还有其他目标被控制
	local has_enemies = false
	for _,mod in pairs(self.modifiers) do
		has_enemies = true
	end

	-- 如果没有目标被控制，则结束技能引导
	if not has_enemies then
		self:EndChannel( true )
	end
end


-- 施法者修饰器：限制施法者转向
modifier_heroTalent_npc_dota_hero_primal_beast_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_primal_beast_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:GetEffectName()	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:CheckState()
	return{
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,  -- 禁止转向
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,  -- 禁止转向
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:GetModifierDisableTurning()
	return 1  
end
function modifier_heroTalent_npc_dota_hero_primal_beast_3:Advanced_GetModifierIncomingDamage_Percentage()
	return -90
end
-- 目标修饰器：控制目标单位
modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:IsStunDebuff() return true end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:OnCreated( kv )
	self.parent = self:GetParent() 
	self.caster = self:GetCaster() 
	self.ability = self:GetAbility() 

	self.interval = self.ability:GetSpecialValueFor( "interval" )        -- 伤害间隔
	self.radius = self.ability:GetSpecialValueFor( "splash_radius" )     -- 溅射范围
	self.ministun = self.ability:GetSpecialValueFor( "ministun" )        -- 眩晕时间
	self.animrate = self.ability:GetSpecialValueFor( "animation_rate" )  -- 动画速率
    self.damage = self.ability:GetSpecialValueFor( "damage" )     -- 伤害值 

    self.bonus = self.ability:GetSpecialValueFor( "bonus" )*0.01
    self:SetStackCount(0)

    self.talentgain = self.ability:GetTalentGain(0.8)
    self.damage_t = self.damage*self.talentgain

	if not IsServer() then return end
    self.time = kv.time
	self.abilityDamageType = self.ability:GetAbilityDamageType()  -- 伤害类型
	self.abilityTargetTeam = self.ability:GetAbilityTargetTeam()  -- 目标队伍
	self.abilityTargetType = self.ability:GetAbilityTargetType()  -- 目标类型
	self.abilityTargetFlags = self.ability:GetAbilityTargetFlags()-- 目标标记

	-- 引导中断的位置数据
	self.interrupt_pos = self.caster:GetOrigin() + self.caster:GetForwardVector() * 200  -- 中断位置
	self.cast_pos = self.caster:GetOrigin()        -- 施法位置
	self.pos_threshold = 100                       -- 位置阈值

	-- 查找施法者的附着点
	local attach_rollback = {
		[1] = "attach_pummel",
		[2] = "attach_attack1",
		[3] = "attach_attack",
		[4] = "attach_hitloc",
	}
	-- 按优先级查找可用的附着点
	for i,name in ipairs(attach_rollback) do
		self.attach_name = name
		if self.caster:ScriptLookupAttachment( name )~=0 then
			break
		end
	end

	-- 计算目标单位的偏移位置
	local hitloc_enum = self.parent:ScriptLookupAttachment( "attach_hitloc" )
	local hitloc_pos = self.parent:GetAttachmentOrigin( hitloc_enum )
	self.deltapos = self.parent:GetOrigin() - hitloc_pos

	-- 应用水平运动控制器
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
		return
	end
	
	-- 应用垂直运动控制器
	if not self:ApplyVerticalMotionController() then
		self:Destroy()
		return
	end

	-- 设置运动控制器优先级为最高
	self:SetPriority( DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST )

	-- 开始定时器，定期造成伤害
	self:StartIntervalThink( self.interval )
end

-- 修饰器销毁时调用
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:OnDestroy()
	if not IsServer() then return end
    local time = self:GetRemainingTime()
    local max_time = self.time
	local used_time_pct = 1-time/max_time
	local newcooldown = self:GetAbility():GetCooldownTimeRemaining()*(used_time_pct)
	self:GetAbility():EndCooldown()
	self:GetAbility():StartCooldown(newcooldown)

	-- 移除水平运动控制器
	self.parent:RemoveHorizontalMotionController( self )


	self.caster:GameTimer(0.03, function()
        FindClearSpaceForUnit( self.parent, self.interrupt_pos, false )
        -- 恢复单位的原始角度
        self.parent:SetAbsAngles(0, 0, 0)
        self.__destroyed = true
        self.ability:RemoveModifier( self )
	end)
end

-- 声明要修改的属性
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,      -- 覆盖动画
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE, -- 覆盖动画速率
	}

	return funcs
end

-- 获取覆盖动画
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:GetOverrideAnimation()
	-- 其他单位使用挣扎动画
	return ACT_DOTA_FLAIL
end

-- 获取覆盖动画速率
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:GetOverrideAnimationRate()
	return self.animrate
end

-- 设置单位状态
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,                  -- 眩晕状态
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true, -- 无法被运动控制
	}

	return state
end

-- 定时器回调函数，定期造成伤害
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:OnIntervalThink()
    self.talentgain = self.ability:GetTalentGain(0.8)
    self.damage_t = self.damage*self.talentgain


    self.final_radius = self.radius*(1+self:GetStackCount()*self.bonus)
    self.final_damage = self.damage_t*(1+self:GetStackCount()*self.bonus)
	-- 获取伤害中心位置
	local origin = self.interrupt_pos
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),    -- 施法者队伍
		origin,                         -- 中心点
		nil,                            -- 缓存单位
		self.final_radius,                    -- 范围
		self.abilityTargetTeam,         -- 目标队伍
		self.abilityTargetType,         -- 目标类型
		self.abilityTargetFlags,        -- 目标标记
		0,                              -- 排序方式
		false                           -- 是否警戒模式
	)
	local damageTable = {
		-- victim = target,
		attacker = self.caster,
		-- damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	}
    damageTable.damage = self.final_damage * self.caster:HDGetPrimaryStatValue()
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)  -- 应用伤害

		-- 添加眩晕修饰器
		enemy:AddNewModifier(
			self.caster, 
			self,
			"modifier_stunned", 
			{ duration = self.ministun }
		)
		EmitSoundOn( "Hero_PrimalBeast.Pulverize.Stun", self.caster )
	end
	self:PlayEffects( origin, self.final_radius )

	-- 检查施法者是否移动过远，如果是则中断技能
	-- if (self.caster:GetOrigin()-self.cast_pos):Length2D()>self.pos_threshold then
	-- 	self:Destroy()
	-- 	return		
	-- end

    self:SetStackCount(self:GetStackCount()+1)
end

-- 更新水平运动
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:UpdateHorizontalMotion( me, dt )
    if self.__destroyed then
        return
    end
	-- 如果目标处于不可用状态，则销毁修饰器
	if self.parent:IsOutOfGame() or self.parent:IsInvulnerable() then
		self:Destroy()
		return
	end

	-- 获取施法者附着点的位置和角度
	local attach = self.caster:ScriptLookupAttachment( self.attach_name )
	local pos = self.caster:GetAttachmentOrigin( attach )
	local angles = self.caster:GetAttachmentAngles( attach )

	-- 设置目标的角度
	me:SetLocalAngles( 180-angles.x, 180+angles.y, 0 )

	-- 计算并设置目标的位置
	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	me:SetOrigin( pos )
end

-- 水平运动中断时调用
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

-- 更新垂直运动
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:UpdateVerticalMotion( me, dt )
    if self.__destroyed then
        return
    end
	-- 获取施法者附着点的位置和角度
	local attach = self.caster:ScriptLookupAttachment( self.attach_name )
	local pos = self.caster:GetAttachmentOrigin( attach )
	local angles = self.caster:GetAttachmentAngles( attach )

	-- 计算并设置目标的垂直位置
	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	local mepos = me:GetOrigin()
	mepos.z = pos.z
	me:SetOrigin( mepos )
end

-- 获取运动控制器优先级
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

-- 获取运动控制器优先级（兼容性方法）
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

-- 播放技能特效
function modifier_heroTalent_npc_dota_hero_primal_beast_3_debuff:PlayEffects( origin, radius )
	-- 特效和音效资源
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf"
	local sound_cast = "Hero_PrimalBeast.Pulverize.Impact"

	-- 创建粒子特效
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
    ParticleManager:SetParticleControl( effect_cast, 3, Vector(radius, radius, radius) )
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- 播放音效
	EmitSoundOnLocationWithCaster( self.parent:GetOrigin(), sound_cast, self.caster )
end

--展示用的tooltip

modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_primal_beast_3_tooltip:OnTooltip()
	self.ability = self:GetAbility()
    self.talentgain_duration = self.ability:GetTalentGain(0.75)
	self.talentgain_damage = self.ability:GetTalentGain(0.8)
	self.duration_t = self.ability:GetSpecialValueFor("channel_time") * self.talentgain_duration
    self.damage_t = self.ability:GetSpecialValueFor("damage") * self.talentgain_damage

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.duration_t
    elseif self._tooltip == 2 then
        return self.damage_t
    end
end

