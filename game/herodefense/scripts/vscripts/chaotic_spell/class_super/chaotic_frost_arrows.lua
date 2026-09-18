
--特效优化 √
chaotic_frost_arrows = class({})

LinkLuaModifier("modifier_chaotic_frost_arrows_attack", "chaotic_spell/class_super/chaotic_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_frost_arrows_active", "chaotic_spell/class_super/chaotic_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_frost_arrows_slow", "chaotic_spell/class_super/chaotic_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_frost_arrows_unlock1", "chaotic_spell/class_super/chaotic_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_frost_arrows_damage_delay", "chaotic_spell/class_super/chaotic_frost_arrows", LUA_MODIFIER_MOTION_NONE)

function chaotic_frost_arrows:GetIntrinsicModifierName()   return "modifier_chaotic_frost_arrows_attack" end

function chaotic_frost_arrows:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/frost_arrows/unlock1/effect_start_pos.vpcf", context )
end

function chaotic_frost_arrows:OnProjectileHit_ExtraData(target, location, keys)
    if not IsServer() then return end
    if not target or not target:IsAlive() or target:IsMagicImmune() then return end
    local caster = self:GetCaster()
    local attacker = caster

    self.freezing = self:GetSpecialValueFor("freezing")
    self.duration = self:GetSpecialValueFor("duration")
    self.damage = self:GetSpecialValueFor("damage")

    if self:GetRuneType()==1 then
        self.duration = self.duration + self:GetSpecialValueFor("rune_1_duration")
    end

    local damagetable = {
        damage = self.damage*attacker:GetAverageTrueAttackDamage(nil),
        apply_damage_init = false, --在第一次施加时立即结算第一次伤害
        apply_damage_interval = 0.1, --伤害结算间隔
        ability = self, --伤害来源
        attacker = attacker, --伤害来源
        damage_type = self:GetAbilityDamageType(), --伤害类型
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --伤害标志
        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE, 
    }
    target:ApplyMergeDamage(damagetable)

    if target:IsAlive() then
        local freezing = self.freezing *attacker:GetAverageTrueAttackDamage(nil)
        target:Freezing(attacker, self, freezing)

        local duration = target:GetHDStatusResistanceIndex(0.5)*attacker:GetModifierStatusNegativeGainIndex(0.75) *self.duration
        if duration > 0 then
            target:AddNewModifier(caster, self, "modifier_chaotic_frost_arrows_slow", {duration = duration}) 
        end
    end
end







modifier_chaotic_frost_arrows_attack = advanced_modifier({})

function modifier_chaotic_frost_arrows_attack:IsPassive()          return true end
function modifier_chaotic_frost_arrows_attack:IsBuff()				return true end
function modifier_chaotic_frost_arrows_attack:IsPurgable()     	return false end
function modifier_chaotic_frost_arrows_attack:IsPurgeException() 	return false end
function modifier_chaotic_frost_arrows_attack:IsHidden()			return true end
function modifier_chaotic_frost_arrows_attack:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow.vpcf" 
    end	

end 

function modifier_chaotic_frost_arrows_attack:OnCreated()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.freezing = self.ability:GetSpecialValueFor("freezing")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.type = self.ability:GetRuneType()

    if self.type == 1 then
        self.duration = self.ability:GetSpecialValueFor("rune_1_duration")
    end
end

function modifier_chaotic_frost_arrows_attack:OnRefresh()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.freezing = self.ability:GetSpecialValueFor("freezing")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.type = self.ability:GetRuneType()

    if self.type == 1 then
        self.duration = self.ability:GetSpecialValueFor("rune_1_duration")
    end
end

function modifier_chaotic_frost_arrows_attack:DeclareFunctions()
	return {
	    MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_chaotic_frost_arrows_attack:ADDeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(), nil},
	}
end

function modifier_chaotic_frost_arrows_attack:OnAttackLanded(keys)
    if not IsServer() then return end  
	local ability = self:GetAbility()
	if not self.parent:IsAlive() or self.parent:IsIllusion() then return end
    local attacker = keys.attacker
    local target = keys.target
    if not target or not target:IsAlive() or target:IsMagicImmune() then return end

    self.damage = self.ability:GetSpecialValueFor("damage")
    local damagetable = {
        damage = self.damage*attacker:GetAverageTrueAttackDamage(nil),
        apply_damage_init = false, --在第一次施加时立即结算第一次伤害
        apply_damage_interval = 0.1, --伤害结算间隔
        ability = self.ability, --伤害来源
        attacker = attacker, --伤害来源
        damage_type = self.ability:GetAbilityDamageType(), --伤害类型
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --伤害标志
        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE, 
    }
    target:ApplyMergeDamage(damagetable)

    if target:IsAlive() then
        local freezing = self.freezing *attacker:GetAverageTrueAttackDamage(nil)
        target:Freezing(attacker, self.ability, freezing)
        
        local duration = target:GetHDStatusResistanceIndex(0.5)*attacker:GetModifierStatusNegativeGainIndex(0.75) * self.duration
        if duration > 0 then
            target:AddNewModifier(self.caster, self.ability, "modifier_chaotic_frost_arrows_slow", {duration = duration})
        end
    end

    local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
    if #enemies > 0 then
        for i, unit in pairs(enemies) do
            if unit:IsAlive() and unit ~= target then
                local info = 
                {
                    Target = unit,
                    -- Source = keys.target,
                    Ability = ability,	
                    EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow.vpcf",
                    iMoveSpeed = attacker:GetProjectileSpeed(),
                    vSourceLoc = target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")),
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
                break
            end
        end
    end
end  


modifier_chaotic_frost_arrows_slow = advanced_modifier({})
function modifier_chaotic_frost_arrows_slow:IsDebuff()				return true  end
function modifier_chaotic_frost_arrows_slow:IsPurgable() 			return true end
function modifier_chaotic_frost_arrows_slow:IsPurgeException() 	    return true end
function modifier_chaotic_frost_arrows_slow:IsHidden()				return false end
function modifier_chaotic_frost_arrows_slow:OnCreated()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("move_slow")
    self.armor = self.ability:GetSpecialValueFor("rune_1_armor")
    self.type = self.ability:GetRuneType()
    if IsServer() then
        if self.type == 1 then
            self:AddStackDuration(1, self:GetDuration(), self.ability:GetSpecialValueFor("rune_1_max_stack"))
        end
    end
end

function modifier_chaotic_frost_arrows_slow:OnRefresh()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("move_slow")
    self.armor = self.ability:GetSpecialValueFor("rune_1_armor")
    self.type = self.ability:GetRuneType()
    if IsServer() then
        if self.type == 1 then
            self:AddStackDuration(1, self:GetDuration(), self.ability:GetSpecialValueFor("rune_1_max_stack"))
        end
    end
end

function modifier_chaotic_frost_arrows_slow:DeclareFunctions() 
    local decfuncs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP,
    }
	return decfuncs
end

function modifier_chaotic_frost_arrows_slow:GetModifierMoveSpeedBonus_Constant() 
    if not self:GetAbility() then self:Destroy() return end
    return -math.min(math.max(self.slow*self:GetStackCount(), self.slow), 450)
end

function modifier_chaotic_frost_arrows_slow:Advanced_GetModifierPhysicalArmorBonus(keys)
    if not self:GetAbility() then self:Destroy() return end
    return -self.armor*self:GetStackCount()
end

function modifier_chaotic_frost_arrows_slow:ADDeclareFunctions()
    local funcs = {}
    if self:GetAbility():GetRuneType() == 1 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
    end
	return funcs
end

function modifier_chaotic_frost_arrows_slow:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:GetModifierMoveSpeedBonus_Constant()
	elseif self._tooltip == 2 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end
