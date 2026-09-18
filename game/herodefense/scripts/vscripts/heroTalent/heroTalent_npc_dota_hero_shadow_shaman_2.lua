heroTalent_npc_dota_hero_shadow_shaman_2 = advanced_modifier({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman_2", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman_2_health", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon_model_lock", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman_2", LUA_MODIFIER_MOTION_NONE)
function heroTalent_npc_dota_hero_shadow_shaman_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_shadow_shaman_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_shadow_shaman_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_shadow_shaman_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_shadow_shaman_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_shadow_shaman_2" end
-- function heroTalent_npc_dota_hero_shadow_shaman_2:IsRefreshable() return false end
-- function heroTalent_npc_dota_hero_shadow_shaman_2:GetCooldown(iLevel)
-- 	return 60 /(math.max(self:GetCaster():GetCooldownReduction(),0.001))
-- end

function heroTalent_npc_dota_hero_shadow_shaman_2:OnSpellStart()
    local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_shadow_shaman_2")
    if modifier then
        modifier:OnWaveStart()
    end
end

function heroTalent_npc_dota_hero_shadow_shaman_2:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end


modifier_heroTalent_npc_dota_hero_shadow_shaman_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        self.unit = caster:SummonUnit("npc_hd_shadowshaman_totem",-1,
        caster:GetAbsOrigin()-caster:GetForwardVector()*100,
        caster:GetForwardVector(),self:GetAbility(),nil,caster:GetMaxHealth(),nil,caster:GetAverageTrueAttackDamage(nil)*0.6,0,1,0)
        -- unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon_model_lock", {})
        self.unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon", {})
        local attack_lock = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
        -- local angle = caster:GetAttachmentAngles(caster:ScriptLookupAttachment("attach_attack1"))
        self.unit:SetOrigin(attack_lock)
		-- unit:SetAngles(angle.x, angle.y, angle.z)
        self.unit:SetParent(caster,"attach_attack1")

        self.unit2 = caster:SummonUnit("npc_hd_shadowshaman_totem",-1,
        caster:GetAbsOrigin()-caster:GetForwardVector()*100,
        caster:GetForwardVector(),self:GetAbility(),nil,caster:GetMaxHealth(),nil,caster:GetAverageTrueAttackDamage(nil)*0.6,0,1,0)
        -- unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon_model_lock", {})
        self.unit2 :AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon", {})
        local attack_lock = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack2"))
        -- local angle = caster:GetAttachmentAngles(caster:ScriptLookupAttachment("attach_attack2"))
        self.unit2:SetOrigin(attack_lock)
		-- unit:SetAngles(angle.x, angle.y, angle.z)
        self.unit2:SetParent(caster,"attach_attack2")

    end
end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:OnWaveStart()
    if self.unit and not self.unit:IsNull() then
        -- print("remove")
        self.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = 0.04}) --召唤持续时间
        -- UTIL_Remove(self.unit)
        self.unit = nil

    end
    if self.unit2 and not self.unit2:IsNull() then
        -- print("remove")
        
        -- UTIL_Remove(self.unit2)
        self.unit2:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = 0.04}) --召唤持续时间
        self.unit2 = nil
    end
    local caster = self:GetCaster()
    self.unit = caster:SummonUnit("npc_hd_shadowshaman_totem",-1,
    caster:GetAbsOrigin()-caster:GetForwardVector()*100,
    caster:GetForwardVector(),self:GetAbility(),0,caster:GetMaxHealth(),nil,caster:GetAverageTrueAttackDamage(nil)*0.6,0,1,0)
    -- unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon_model_lock", {})
    self.unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon", {})
    local attack_lock = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
    -- local angle = caster:GetAttachmentAngles(caster:ScriptLookupAttachment("attach_attack1"))
    self.unit:SetOrigin(attack_lock)
    -- unit:SetAngles(angle.x, angle.y, angle.z)
    self.unit:SetParent(caster,"attach_attack1")

    self.unit2 = caster:SummonUnit("npc_hd_shadowshaman_totem",-1,
    caster:GetAbsOrigin()-caster:GetForwardVector()*100,
    caster:GetForwardVector(),self:GetAbility(),0,caster:GetMaxHealth(),nil,caster:GetAverageTrueAttackDamage(nil)*0.6,0,1,0)
    -- unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon_model_lock", {})
    self.unit2 :AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon", {})
    local attack_lock = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack2"))
    -- local angle = caster:GetAttachmentAngles(caster:ScriptLookupAttachment("attach_attack2"))
    self.unit2:SetOrigin(attack_lock)
    -- unit:SetAngles(angle.x, angle.y, angle.z)
    self.unit2:SetParent(caster,"attach_attack2")

end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end







modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:CheckState() 
    local funcs = {
        -- [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true, 
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
    if not self:GetCaster():IsAlive() then
        funcs[MODIFIER_STATE_DISARMED] = true
    end
    return funcs
end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:OnCreated(keys)
	if IsServer() then
        self.bonus = self:GetCaster():Script_GetAttackRange()
		self:StartIntervalThink(0.5)

	end
end




function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:DeclareFunctions() return 
	{
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_DISABLE_TURNING,

        MODIFIER_EVENT_ON_ATTACK
    } 
end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:GetModifierDisableTurning() 
    return 1
end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:GetModifierIgnoreCastAngle()
    return 1
end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:Advanced_GetModifierAttackRangeOverride()
    if IsServer() then
        return  self.bonus+50
    end
end



function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:OnIntervalThink()
    local parent =  self:GetParent()

    self.bonus = self:GetCaster():Script_GetAttackRange()
  

	local enemy = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,  self.bonus,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemy>0 and enemy[1]:IsAlive() then
        parent:SetForceAttackTarget(enemy[1])
    else
        parent:SetForceAttackTarget(nil)
    end
end


function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:OnAttack(keys)
	if not IsServer() then return end

	-- if not self:GetAbility():IsCooldownReady() then
	-- 	return
	-- end
	
	-- "Secondary arrows are not released upon attacking allies."
	-- The "not keys.no_attack_cooldown" clause seems to make sure the function doesn't trigger on PerformAttacks with that false tag so this thing doesn't crash
	if keys.attacker == self:GetParent() then	
        local info = 
        {
            Target = keys.target,
            -- Source =  keys.attacker,
            Ability = self:GetAbility(),	
            EffectName = self:GetParent():GetRangedProjectileName(),
            iMoveSpeed = self:GetParent():GetProjectileSpeed(),
            -- sourceloc = keys.unit:GetOrigin(),
            -- caster:GetProjectileSpeed()
            -- vSourceLoc = keys.attacker:GetOrigin(),
            vSourceLoc = keys.attacker:GetAttachmentOrigin(keys.attacker:ScriptLookupAttachment("attach_attack1")),
            bDrawsOnMinimap = false,  --？？
            bDodgeable = true,   --可躲闪
            bIsAttack = false,   --攻击效果
            bVisibleToEnemies = true,  --对敌人可视
            bReplaceExisting = false, --替换现有的
            flExpireTime = GameRules:GetGameTime() + 10, --存在时间
            bProvidesVision = false, --提供视野
            ExtraData = {}   --额外的数据
        }
        ProjectileManager:CreateTrackingProjectile(info)
	end
end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only,
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,

    }
end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_2_summon:Advanced_GetModifier_FlyingPathing()	
	return 1
end
