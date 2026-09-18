LinkLuaModifier("modifier_heroTalent_npc_dota_hero_slark_3", "heroTalent/heroTalent_npc_dota_hero_slark_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_slark_3_buff", "heroTalent/heroTalent_npc_dota_hero_slark_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_slark_3_debuff", "heroTalent/heroTalent_npc_dota_hero_slark_3", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_slark_3 = class({})

function heroTalent_npc_dota_hero_slark_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_slark_3"
end
function heroTalent_npc_dota_hero_slark_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", context )
	PrecacheResource("particle", "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", context)
end
-- legend_talent_2成就解锁判断
function heroTalent_npc_dota_hero_slark_3:Unlockachievement()
	--print("成就已解锁")
	self.customAchievement = true
end
-- 发送数据包，解锁成就
function heroTalent_npc_dota_hero_slark_3:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("legend_talent_2")
		end
	end
end
-- 判断是否是排行榜难度
function heroTalent_npc_dota_hero_slark_3:IsRangedMode()
	if not IsServer() then
		return
	end
	if  _G.GAME_CHANLLENGE_Contest_Type == 1 or _G.GAME_CHANLLENGE_Contest_Type == 2 then
		return true
	end
	return false
end
-- 主动：黑暗契约
function heroTalent_npc_dota_hero_slark_3:OnSpellStart()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("dmg_radius")
    local base_damage = self:GetSpecialValueFor("damage")
    local agi_damage = self:GetSpecialValueFor("agi_damage") * caster:GetAgility()
    local regen_damage = self:GetSpecialValueFor("regen_damage") * caster:GetHealthRegen()
    local total_damage = base_damage + agi_damage + regen_damage
    local index = self:GetSpecialValueFor("index")*0.01
    local ignore_resist = self:GetLevel() >= self:GetMaxLevel() -- 满级无视正向魔抗

    local damageTable = {
        --victim = caster,
        attacker = caster,
        damage = total_damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE,
    }

    -- 弱驱散自身
    caster:Purge(false, true, false, false, false)

    -- 对自身和周围敌人造成伤害
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, target in pairs(enemies) do
        damageTable.victim = target
        local modifier
        -- 满级无视正向魔抗
        if ignore_resist then
            local resist = target:Script_GetMagicalArmorValue(true, self)
            if resist > 0 then
                modifier = target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_slark_3_debuff", {duration = 0.1, stack = resist*100})
            end
        end
        ApplyDamage(damageTable)
        if modifier then
            modifier:Destroy()
        end
    end
    -- 自身也受伤害
    damageTable.victim = caster
    damageTable.damage = total_damage*index
    damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
    damageTable.hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_DARK_DAMAGE
    ApplyDamage(damageTable)

    -- 音效/特效
    caster:EmitSoundParams("Hero_Slark.DarkPact.Cast",0,0.3,0)
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(pfx, 2, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)
end

-- 被动主挂载
modifier_heroTalent_npc_dota_hero_slark_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_slark_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_slark_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slark_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slark_3:OnCreated()
    self.ability = self:GetAbility()
    self.cd_reduce = self.ability:GetSpecialValueFor("cd_reduce")*0.01
    self.cd_reduce_2 = self.ability:GetSpecialValueFor("cd_reduce_2")*0.01
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.line = self.ability:GetSpecialValueFor("line")
    self.bonus = 1 + self:GetAbility():GetSpecialValueFor("legend_bonus")*0.01

    if not IsServer() then return end
    self:StartIntervalThink(0.5)
    self:GetAbility():Unlockachievement()
end

function modifier_heroTalent_npc_dota_hero_slark_3:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
    }
end

-- 普攻命中返还主动技能冷却
function modifier_heroTalent_npc_dota_hero_slark_3:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    local ability = self:GetAbility()
    if not ability or ability:IsCooldownReady() then return end

    local cd = ability:GetCooldownTimeRemaining()
    ability:EndCooldown()
    ability:StartCooldown(cd * (1 - self.cd_reduce))
end

-- 击杀返还更多冷却并强驱散
function modifier_heroTalent_npc_dota_hero_slark_3:OnDeath(params)
    if not IsServer() then return end
    if params.attacker ~= self:GetParent() then return end
    local ability = self:GetAbility()
    if not ability or ability:IsCooldownReady() then return end

    local cd = ability:GetCooldownTimeRemaining()
    ability:EndCooldown()
    ability:StartCooldown(cd * (1 - self.cd_reduce_2))
    -- 强驱散自身
    if not ability:IsRangedMode() then
        self:GetParent():Purge(false, true, false, true, true)
    end
end

function modifier_heroTalent_npc_dota_hero_slark_3:OnIntervalThink()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    if not ability then return end
    local radius = self.radius
    local line = self.line
    local enemies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )
    local hp_pct = parent:GetHealthPercent()
    if #enemies == 0 or hp_pct <= line then
        if not parent:HasModifier("modifier_heroTalent_npc_dota_hero_slark_3_buff") then
            parent:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_slark_3_buff", {duration = 1})
        end
    else
        if parent:HasModifier("modifier_heroTalent_npc_dota_hero_slark_3_buff") then
            parent:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_slark_3_buff")
        end
    end

    if ability and parent:IsAlive() then
		if ability:IsCooldownReady() and ability:GetAutoCastState() then
			parent:CastAbilityNoTarget(ability, parent:GetPlayerOwnerID())
		end
	end
end

-- 阴影之舞buff
modifier_heroTalent_npc_dota_hero_slark_3_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_slark_3_buff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_slark_3_buff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slark_3_buff:OnCreated()
    self.regen = self:GetAbility():GetSpecialValueFor("regen")*0.01
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(particle, false, false, -1, false, false)
end
function modifier_heroTalent_npc_dota_hero_slark_3_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_heroTalent_npc_dota_hero_slark_3_buff:AdvancedGetModifierConstantHealthRegen()
    local ability = self:GetAbility()
    if not ability then return 0 end
    local parent = self:GetParent()
    local lost = parent:GetMaxHealth()-parent:GetHealth()

    if ability:IsRangedMode() then
        lost = 0.5*lost
    end
    return lost*self.regen
end
function modifier_heroTalent_npc_dota_hero_slark_3_buff:CheckState()
    return {
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
    }
end

-- 满级主动无视正向魔抗
modifier_heroTalent_npc_dota_hero_slark_3_debuff = class({})
function modifier_heroTalent_npc_dota_hero_slark_3_debuff:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_slark_3_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_slark_3_debuff:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(keys.stack or 0)
    end
end
function modifier_heroTalent_npc_dota_hero_slark_3_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end
function modifier_heroTalent_npc_dota_hero_slark_3_debuff:GetModifierMagicalResistanceBonus()
    if not self:GetAbility() then self:Destroy() return end
    return -self:GetStackCount()
end
