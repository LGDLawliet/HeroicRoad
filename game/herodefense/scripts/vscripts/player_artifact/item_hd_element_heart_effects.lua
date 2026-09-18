-- 重写完成
item_hd_element_heart_effects = class({})
LinkLuaModifier("modifier_item_hd_element_heart_effects", "player_artifact/item_hd_element_heart_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_element_heart_effects_count", "player_artifact/item_hd_element_heart_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_element_heart_effects_active", "player_artifact/item_hd_element_heart_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_element_heart_effects_active_lv20cd", "player_artifact/item_hd_element_heart_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_element_heart_effects_cd", "player_artifact/item_hd_element_heart_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_element_heart_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_element_heart_effects"
end
function item_hd_element_heart_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_2021_immortal/aa_2021_immortal_chilling_projectile.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_base_attack.vpcf", context )
    PrecacheResource( "particle", "particles/events/crownfall/survivors/abilities/skywrath/skywrath_arcane_bolt.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf", context )
end
modifier_item_hd_element_heart_effects = advanced_modifier({})

function modifier_item_hd_element_heart_effects:IsDebuff() return false end
function modifier_item_hd_element_heart_effects:IsHidden() return true end
function modifier_item_hd_element_heart_effects:IsPurgable() return false end
function modifier_item_hd_element_heart_effects:RemoveOnDeath() return false end

function modifier_item_hd_element_heart_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.count = self.ability:GetArtifactSpecialValueFor("count")
    self.cd = self.ability:GetArtifactSpecialValueFor("cd")
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")

    self.spell_1 = self.ability:GetArtifactSpecialValueFor("spell_1")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_element_heart_effects")
    if self.level >= 10 then
        self.bonus_spell_amp =  self.bonus_spell_amp + self.spell_1
    end
end

function modifier_item_hd_element_heart_effects:OnRefresh(keys)
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.count = self.ability:GetArtifactSpecialValueFor("count")
    self.cd = self.ability:GetArtifactSpecialValueFor("cd")
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")

    self.spell_1 = self.ability:GetArtifactSpecialValueFor("spell_1")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_element_heart_effects")
    if self.level >= 10 then
        self.bonus_spell_amp =  self.bonus_spell_amp + self.spell_1
    end
end

function modifier_item_hd_element_heart_effects:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

function modifier_item_hd_element_heart_effects:Advanced_GetModifierSpellAmplifyBonus()
    return self.bonus_spell_amp
end

function modifier_item_hd_element_heart_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if not attacker or attacker ~= self:GetParent() then return end
    if not IsElementDamage(keys) then return end
    if not attacker:IsAlive() then return end
    local cdmodifier = attacker:HasModifier("modifier_item_hd_element_heart_effects_cd")
    if cdmodifier then return end
    --print("判定生效")

    local modifier = attacker:FindModifierByName("modifier_item_hd_element_heart_effects_count")
    if modifier then
        modifier:SetStackCount(math.min(modifier:GetStackCount() + self.count, self.line))
        if modifier:GetStackCount() >= self.line then
            modifier:SetStackCount(0)
            attacker:AddNewModifier(attacker, self.ability, "modifier_item_hd_element_heart_effects_active", {stack = self.outgoing, duration = self.duration})
            self:PlayEffects(attacker)
        end
    else
        attacker:AddNewModifier(attacker, self.ability, "modifier_item_hd_element_heart_effects_count", {stack = self.count})
    end
    attacker:AddNewModifier(attacker,self.ability,"modifier_item_hd_element_heart_effects_cd",{duration = self.cd})
    return self.outgoing
end

function modifier_item_hd_element_heart_effects:PlayEffects(unit)
    if not IsServer() then return end
    if not unit then return end
    -- 做特效和音效
end
-----
modifier_item_hd_element_heart_effects_cd = advanced_modifier({})

function modifier_item_hd_element_heart_effects_cd:IsDebuff() return false end
function modifier_item_hd_element_heart_effects_cd:IsHidden() return true end
function modifier_item_hd_element_heart_effects_cd:IsPurgable() return false end
-----
modifier_item_hd_element_heart_effects_count = advanced_modifier({})

function modifier_item_hd_element_heart_effects_count:IsDebuff() return false end
function modifier_item_hd_element_heart_effects_count:IsHidden() return false end
function modifier_item_hd_element_heart_effects_count:IsPurgable() return false end
function modifier_item_hd_element_heart_effects_count:GetTexture() return "invoker/immortal/invoker_alacrity" end
function modifier_item_hd_element_heart_effects_count:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then return end
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
-----
modifier_item_hd_element_heart_effects_active_lv20cd = advanced_modifier({})

function modifier_item_hd_element_heart_effects_active_lv20cd:IsDebuff() return false end
function modifier_item_hd_element_heart_effects_active_lv20cd:IsHidden() return true end
function modifier_item_hd_element_heart_effects_active_lv20cd:IsPurgable() return false end
-----
modifier_item_hd_element_heart_effects_active = advanced_modifier({})

function modifier_item_hd_element_heart_effects_active:IsDebuff() return false end
function modifier_item_hd_element_heart_effects_active:IsHidden() return false end
function modifier_item_hd_element_heart_effects_active:IsPurgable() return false end
function modifier_item_hd_element_heart_effects_active:GetTexture() return "invoker_invoke" end
function modifier_item_hd_element_heart_effects_active:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then return end
    self.parent = self:GetParent()
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")

    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.mpregen_2 = self.ability:GetArtifactSpecialValueFor("mpregen_2")*0.01
    self.cd_2 = self.ability:GetArtifactSpecialValueFor("cd_2")
    self.cast_speed_3 = self.ability:GetArtifactSpecialValueFor("cast_speed_3")
    self.damage_3 = self.ability:GetArtifactSpecialValueFor("damage_3")
    self.cd_3 = self.ability:GetArtifactSpecialValueFor("cd_3")
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.damage_7 = self.ability:GetArtifactSpecialValueFor("damage_7")

    self.level = GetArtifactLevel(self.parent:GetPlayerOwnerID(),"item_hd_element_heart_effects")

    if self.level >= 30 then
        self.damage = self.damage_3
    end
    if self.level >= 40 then
        self.chance_2 = self.chance_4
    end
    if self.level >= 70 then
       self.damage = self.damage_7 
    end

    self.effecttable = {
        [1] = {"particles/econ/items/ancient_apparition/aa_2021_immortal/aa_2021_immortal_chilling_projectile.vpcf", "Hero_Ancient_Apparition.ChillingTouch.Target"},--冰
        [2] = {"particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf","skeleton_king_skel_arc_ability_hellfire_01"},--火
        [3] = {"particles/units/heroes/hero_disruptor/disruptor_base_attack.vpcf","Hero_Disruptor.ThunderStrike.Thunderator"},--电
        [4] = {"particles/events/crownfall/survivors/abilities/skywrath/skywrath_arcane_bolt.vpcf","Hero_SkywrathMage.ArcaneBolt.Impact"},--暗
        [5] = {"particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf","skywrath_mage_drag_concussive_shot_01"},--光
    }
    if IsServer() then
        self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
        hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
        }
        if self.level >= 40 then
            local i = 0
            self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
            self.max_4 = self.ability:GetArtifactSpecialValueFor("max_4")
            local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius_4, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for _, enemy in pairs(enemies) do
                self:ElementalStrike(enemy)

                i = i + 1
                if i >= self.max_4 then
                    break 
                end
            end
        end
        self:SetStackCount(keys.stack)
        self:StartIntervalThink(self.interval)
    end
end
function modifier_item_hd_element_heart_effects_active:OnRefresh(keys)
    self.ability = self:GetAbility()
    if not self.ability then return end
    self.parent = self:GetParent()
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")

    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.mpregen_2 = self.ability:GetArtifactSpecialValueFor("mpregen_2")*0.01
    self.cd_2 = self.ability:GetArtifactSpecialValueFor("cd_2")
    self.cast_speed_3 = self.ability:GetArtifactSpecialValueFor("cast_speed_3")
    self.damage_3 = self.ability:GetArtifactSpecialValueFor("damage_3")
    self.cd_3 = self.ability:GetArtifactSpecialValueFor("cd_3")
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.damage_7 = self.ability:GetArtifactSpecialValueFor("damage_7")

    self.level = GetArtifactLevel(self.parent:GetPlayerOwnerID(),"item_hd_element_heart_effects")

    if self.level >= 30 then
        self.damage = self.damage_3
    end
    if self.level >= 40 then
        self.chance_2 = self.chance_4
    end
    if self.level >= 70 then
        self.damage = self.damage_7 
     end

    if IsServer() then
        self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
        hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
        }
        if self.level >= 40 then
            local i = 0
            self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
            self.max_4 = self.ability:GetArtifactSpecialValueFor("max_4")
            local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius_4, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for _, enemy in pairs(enemies) do
                self:ElementalStrike(enemy)

                i = i + 1
                if i >= self.max_4 then
                    break 
                end
            end
        end
        self:SetStackCount(keys.stack)
    end
end
function modifier_item_hd_element_heart_effects_active:OnIntervalThink()
    local parent = self:GetParent()
    if not self.ability or not parent:IsAlive() then return end
    self.i = nil
    
    local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for i, enemy in ipairs(enemies) do
        self:ElementalStrike(enemy)
        if self.level >= 10 then
            if self.i then
                break
            end
            self.i = true
        else
            break
        end
    end
end
function modifier_item_hd_element_heart_effects_active:ElementalStrike(target)
    if not IsServer() then return end
    local caster = self:GetParent()
    if not self.ability or not caster:IsAlive() then return end
    if not target then return end
    
    if self.level >= 20 then
        local cdmodifier = caster:HasModifier("modifier_item_hd_element_heart_effects_active_lv20cd")
        if not cdmodifier then 
            local chance = self.chance_2
            local random = math.random
            if chance >= random(1,100) then
                self:SetDuration(self:GetRemainingTime() + self.duration_2, true)
                caster:GiveMana((caster:GetMaxMana()-caster:GetMana())*self.mpregen_2)
                caster:AddNewModifier(caster, self.ability,"modifier_item_hd_element_heart_effects_active_lv20cd",{duration = self.cd_2})
            end
        end
    end
    
    local delay = CalculateDistance(caster,target)/3000
    self.damageTable.damage = caster:HDGetPrimaryStatValue() * self.damage*0.5
    self.info = 
	{
		Target = target,
		Source = caster,
		Ability = self.ability,	
		--EffectName = "particles/rebuild/chaotic_spell/chaotic_ice_knife/effect_projecile/effect.vpcf",
		--iMoveSpeed = 1000,
		vSourceLoc = self:GetParent():GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = false,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = true, --提供视野
		ExtraData = {}   --额外的数据
	}
    for i = 1, 5, 1 do
        self.info.EffectName = self.effecttable[i][1]
        self.info.iMoveSpeed = 3000 -80*i
	    ProjectileManager:CreateTrackingProjectile(self.info)
    end

    caster:GameTimer(delay,function ()
        if not self.ability or not target:IsAlive() then return end
        self.damageTable.victim = target
        ApplyDamage(self.damageTable)
        for i = 1, 5, 1 do
            EmitSoundOn(self.effecttable[i][2], target)
        end
    end)
end
function modifier_item_hd_element_heart_effects_active:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_element_heart_effects_active:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()
    elseif self._tooltip == 2 then
        return self.interval
    end
end
function modifier_item_hd_element_heart_effects_active:ADDeclareFunctions()
    local funcs = 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    if self.level >= 30 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_CastPoint)
        table.insert(funcs,advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION)
    end
    return funcs
end
function modifier_item_hd_element_heart_effects_active:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if not attacker or attacker ~= self:GetParent() then return end
    if not IsElementDamage(keys) then return end
    if not attacker:IsAlive() then return end
    if not self.ability then return end

    return self:GetStackCount()
end

function modifier_item_hd_element_heart_effects_active:Advanced_GetModifier_CastPoint()
    return self.cast_speed_3
end
function modifier_item_hd_element_heart_effects_active:Advanced_GetModifierCooldownReduction()
    return self.cd_3
end