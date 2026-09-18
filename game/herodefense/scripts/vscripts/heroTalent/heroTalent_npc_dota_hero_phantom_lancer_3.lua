LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer_3", LUA_MODIFIER_MOTION_NONE)
heroTalent_npc_dota_hero_phantom_lancer_3 = class({})
function heroTalent_npc_dota_hero_phantom_lancer_3:IsRefreshable()
	return false
end
function heroTalent_npc_dota_hero_phantom_lancer_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/phantom_lancer_3/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", context )
end
function heroTalent_npc_dota_hero_phantom_lancer_3:GetCastRange()
	return 1000
end

function heroTalent_npc_dota_hero_phantom_lancer_3:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local origin = caster:GetOrigin()

    local talentgain = self:GetTalentGain(2)--200%精通
    local attack = self:GetSpecialValueFor("attack")*talentgain
    local duration = self:GetSpecialValueFor("duration")
    caster:Purge(false, true, false, true, true) --可移除眩晕的强驱散

    local distance 	= (point - origin):Length2D()
	distance = math.min(distance,self:GetCastRange())
	local dir = CalculateDirection(point, origin)
	point = origin +dir*distance
    
    local delay = 1
    
    local count = self:GetSpecialValueFor("count")
    
    caster:EmitSound("Hero_PhantomLancer.Doppelganger.Cast")
    local start_pfx = ParticleManager:CreateParticle("particles/rebuild/talent/phantom_lancer_3/effect.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(start_pfx, 0, origin)
    ParticleManager:ReleaseParticleIndex(start_pfx)
    caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase", {duration = delay})

    caster:GameTimer(delay, function()
        FindClearSpaceForUnit(caster, point, true)
        caster:EmitSound("Hero_PhantomLancer.Doppelganger.Appear")
        local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:ReleaseParticleIndex(caster_pfx)
        for i = 1, count do
            -- 随机位置偏移
            local random = math.random(75,300)
            local offset = RandomVector(random)
            local illusion_pos = point + offset
            local illusion = caster:MakeCustomIllusion(illusion_pos)
            
            local illusion_appear_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_spawn_illusion.vpcf", PATTACH_ABSORIGIN, illusion)
            ParticleManager:ReleaseParticleIndex(illusion_appear_pfx)
            
            illusion:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion", {duration = duration})
			caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff", {duration = duration, attack = attack})
        end
    end)
    
end

modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase:OnCreated( kv )
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
	if not IsServer() then return end
	self.parent:AddNoDraw()
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase:OnDestroy()
	if not IsServer() then return end
	if not self.ability then return end
	self.parent:RemoveNoDraw()
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_phase:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_STUNNED] = true
    }
end


modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:CheckState() return 
	{
    [MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true, 
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
    } 
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:DeclareFunctions() return 
    {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

	end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:GetModifierAttackSpeedBaseOverride(keys)
	return self:GetCaster():GetAttackSpeed(false)
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:GetModifierIgnoreMovespeedLimit(keys)
	return 1
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetAbility():GetCaster()  --技能的拥有者
	local parent = self:GetCaster()               --幻象跟随者
	local parent_pos = parent:GetAbsOrigin()      --幻象跟随者位置
	local self_pos = self:GetParent():GetAbsOrigin()--幻象位置
	local distance = (parent_pos - self_pos):Length2D()
	--距离太远就走进跟随者
	if distance >1500 then 
		self:GetParent():SetForceAttackTarget(nil) 
		self:GetParent():MoveToPosition(parent_pos)
		return
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	local caster = ability:GetCaster() 
	
	target:EmitSound("Hero_PhantomLancer.Attack")

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, true, true, true, false, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_illusion:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		UTIL_Remove( parent )
	end
end


modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    if IsServer() then
        self.attack = keys.attack
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:OnRefresh(keys)
    self.ability = self:GetAbility()
    if IsServer() then
        self.attack = keys.attack
    end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:OnTooltip()
    return self.attack
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:Advanced_GetModifierIncomingDamage_Percentage()
    return -100
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:Advanced_GetModifierDamageOutgoing_Percentage()
    return self.attack
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:AddCustomTransmitterData( )
	return
	{
		attack = self.attack,
	}
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_3_buff:HandleCustomTransmitterData( data )
	self.attack = data.attack
end