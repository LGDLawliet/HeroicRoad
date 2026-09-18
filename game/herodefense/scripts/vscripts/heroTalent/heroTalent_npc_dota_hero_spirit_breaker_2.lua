heroTalent_npc_dota_hero_spirit_breaker_2 = class({})

--基础modifier：每移动move_need距离获得1层[虚数潜航]，失去单位碰撞体积，突破移动速度限制。
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spirit_breaker_2", "heroTalent/heroTalent_npc_dota_hero_spirit_breaker_2", LUA_MODIFIER_MOTION_NONE )
--主·虚数潜航modifier：每层提供bonus_move移动速度，think1如果大于mid_stacks添加inv_duration秒隐身。onattacklanded造成bonus_cri暴击，bonus_range范围的bonus_range_damage分裂并消除层数添加stun_duration[实数证明]。
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag", "heroTalent/heroTalent_npc_dota_hero_spirit_breaker_2", LUA_MODIFIER_MOTION_NONE )
--隐身
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv", "heroTalent/heroTalent_npc_dota_hero_spirit_breaker_2", LUA_MODIFIER_MOTION_NONE )
--实数证明：100抗100状态抗魔免，眩晕
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed", "heroTalent/heroTalent_npc_dota_hero_spirit_breaker_2", LUA_MODIFIER_MOTION_NONE )
--特效2：满速跑提示
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect", "heroTalent/heroTalent_npc_dota_hero_spirit_breaker_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_spirit_breaker_2:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/talent/spirit_breaker_2/charge.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/spirit_breaker_2/explosionife_break_gold.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/spirit_breaker_2/max_fire.vpcf", context )
end

function heroTalent_npc_dota_hero_spirit_breaker_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_spirit_breaker_2"
end


----------基础modifier：每移动move_need距离获得1层[虚数潜航]，失去单位碰撞体积，突破移动速度限制。--------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_spirit_breaker_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:OnCreated(table)
    if IsServer() then
        
        self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.prevLoc = self.parent:GetAbsOrigin()
        self.move_dis = 0
        self:StartIntervalThink(0.03)
    end
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:OnIntervalThink()
    if IsClient() then
        return
    end
    
    --每移动move_need距离获得1层[虚数潜航]
    local dis = CalculateDistance(self.prevLoc, self.parent)
    self.move_dis = self.move_dis + dis

    local ability = self:GetAbility()
    local caster = self:GetCaster()

    local move_need = ability:GetSpecialValueFor("move_need")
    local duration = ability:GetSpecialValueFor("stacks_duration")
    local gain = caster:GetModifierDurationGainIndex(1)--正面增强100%

    if self.move_dis >= move_need then
        self.move_dis  = 0
        caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag", {duration = duration*gain})
    end    
    self.prevLoc = self:GetParent():GetAbsOrigin()       
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,--移动速度突破
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:CheckState()
    return{
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,--无视单位碰撞
    }
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2:GetModifierIgnoreMovespeedLimit()
    return 1 
end

----------主·虚数潜航modifier：每层提供bonus_move移动速度，think1如果大于mid_stacks添加inv_duration秒隐身。onattacklanded造成bonus_cri暴击，bonus_range范围的bonus_range_damage分裂并消除层数添加stun_duration[实数证明]。------
modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:RemoveOnDeath() return false end

--每移动move_need距离获得1层[虚数潜航],think1
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:OnCreated(keys)
    local ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.max_stacks = ability:GetSpecialValueFor("max_stacks")
    self.vision = ability:GetSpecialValueFor("vision")
    self.bonus_move = ability:GetSpecialValueFor("bonus_move")
    self.bonus_cri = ability:GetSpecialValueFor("bonus_cri")

    if IsServer() then
        self:StartIntervalThink(1)
        --特效1--------------------------------------------------------------------------------------------------------------
        self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/talent/spirit_breaker_2/charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
        self:AddParticle(self.nFXIndex, false, false, -1, false, false)	
    end

    
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:OnRefresh(keys)
    local ability = self:GetAbility()
    self.vision = ability:GetSpecialValueFor("vision")
    self.bonus_move = ability:GetSpecialValueFor("bonus_move")
    self.bonus_cri = ability:GetSpecialValueFor("bonus_cri")

    if IsServer() then
        self:SetStackCount(math.min(self:GetStackCount()+1,self.max_stacks))
    end
    
end

--如果大于mid_stacks添加inv_duration秒隐身，不受到修正。
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:OnIntervalThink()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local mid_stacks = ability:GetSpecialValueFor("mid_stacks")
    local inv_duration = ability:GetSpecialValueFor("inv_duration")
    
    
    if IsServer() then
        if self:GetStackCount() >= mid_stacks then
            self.bufforigin = self.caster:AddNewModifier(self.caster, ability, "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv", {duration = inv_duration})
            self.effectorigin = self.caster:AddNewModifier(self.caster, ability, "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect", {duration = 1})--添加一个不可注销的特效的方式。
        end   --特效2：满速跑------------------------------------------------------------------------------------------------------------
       
        --特效1：拉刀光------------------------------------------------------------------------------------------------------------
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/talent/spirit_breaker_2/charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		end
	    --特效1：拉刀光--------------------------------------------------------------------------------------------------------------
    end
end

--onattacklanded
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:OnAttackLanded(params)

    --生效大环境判断
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    
    --bonus_range范围的bonus_range_damage分裂并消除层数
    if params.attacker == parent and self:GetStackCount() > 0 then
        local ability = self:GetAbility()
        -- local parent = self:GetParent()
    
        local bonus_range = ability:GetSpecialValueFor("bonus_range")--每层分裂范围
        local bonus_range_damage = ability:GetSpecialValueFor("bonus_range_damage")--每层分裂伤害
        local bonus_stun_duration =ability:GetSpecialValueFor("bonus_stun_duration")--每层[实数证明时间]

        local range = bonus_range * self:GetStackCount()
        local range_damage = bonus_range_damage * self:GetStackCount()*0.01
        local stun_duration = bonus_stun_duration * self:GetStackCount()

        local enemies = FindUnitsInRadius(
            parent:GetTeamNumber(), 
            parent:GetAbsOrigin(), 
            nil, 
            range, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
            FIND_ANY_ORDER, 
            false
        )--遍历敌人
        
        for _, enemy in pairs(enemies) do
            if enemy ~= target then
                local damageTable = {
                                    victim = enemy,
                                    attacker = parent,
                                    damage = params.damage * range_damage,
                                    damage_type = DAMAGE_TYPE_PHYSICAL,
                                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
                                    ability = nil, --Optional.
                                    }
                ApplyDamage(damageTable)
            end
        end--适用攻击
        EmitSoundOn( "Hero_Invoker.ChaosMeteor.Impact", parent )
        --特效12：攻击时注销-------
        if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
        --if self.nFXIndex2 then
		--	ParticleManager:DestroyParticle(self.nFXIndex2, true)
		--	ParticleManager:ReleaseParticleIndex(self.nFXIndex2)
		--	self.nFXIndex2 = nil
		--end
        --特效3：攻击-------------------------------------------------------------------------------------------------------------- 
        local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/talent/spirit_breaker_2/explosionife_break_gold.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetAbsOrigin() )
        ParticleManager:SetParticleControl( effect_cast, 1, (Vector(range, range, range)) )
        ParticleManager:SetParticleControl( effect_cast, 3, (Vector(range, range, range)) )
		ParticleManager:SetParticleControl( effect_cast, 5, (Vector(range, range, range)) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
        

        --特效3：攻击--------------------------------------------------------------------------------------------------------------         
    
        --添加stun_duration[实数证明],不被修正。
        parent:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed", {duration = stun_duration})
        self:SetStackCount(0)--层数置0
    end
end

--每层提供bonus_move移动速度
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end



function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,--暴击
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE


    }
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:GetModifierMoveSpeedBonus_Constant()--移动速度
    return self.bonus_move * self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:Advanced_GetBonusVisionPercentage()--视野
    return self.vision
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_imag:Advanced_GetModifierCriticalStrike(keys)--暴击伤害
	return self.bonus_cri* self:GetStackCount()
end

----------隐身--------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_inv:CheckState()
    return{
        [MODIFIER_STATE_INVISIBLE] = true,--隐身
        [MODIFIER_STATE_INVULNERABLE] = true,--无敌
    }
end

----------实数证明：100抗100状态抗魔免，眩晕-----------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,--伤害抗性
        advanced_MODIFIER_PROPERTY_STATUS_RESISTANCE,--状态抗性
    }
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:CheckState()
    return{
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,--魔免
        [MODIFIER_STATE_STUNNED] = true--眩晕
    }
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:Advanced_GetModifierIncomingDamage_Percentage()
    return -100
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_qed:Advanced_GetModifier_StatusResistance()
    return 100
end

--特效modifier：满速跑--------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:GetEffectName()
    return "particles/rebuild/talent/spirit_breaker_2/max_fire.vpcf"
end

function modifier_heroTalent_npc_dota_hero_spirit_breaker_2_effect:GetEffectAttachType()
    return "attach_hitloc"
end