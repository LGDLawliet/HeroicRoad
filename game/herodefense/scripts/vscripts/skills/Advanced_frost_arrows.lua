
--特效优化 √
Advanced_frost_arrows = class({})

LinkLuaModifier("modifier_Advanced_frost_arrows_attack", "skills/Advanced_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_frost_arrows_active", "skills/Advanced_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_frost_arrows_slow", "skills/Advanced_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_frost_arrows_unlock1", "skills/Advanced_frost_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_frost_arrows_damage_delay", "skills/Advanced_frost_arrows", LUA_MODIFIER_MOTION_NONE)

function Advanced_frost_arrows:GetIntrinsicModifierName()   return "modifier_Advanced_frost_arrows_attack" end
function Advanced_frost_arrows:CheckKV(key)
	local table = {
		damage = 0.02,
	}
	local value = table[key] or -1
	return value
end
function Advanced_frost_arrows:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_frost_arrows_unlock1",{})
	return true
end
function Advanced_frost_arrows:UnlockSecondCore(key)
	return true
end
function Advanced_frost_arrows:UnlockThirdCore(key)
	return true
end

function Advanced_frost_arrows:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/frost_arrows/unlock1/effect_start_pos.vpcf", context )
end

function Advanced_frost_arrows:OnProjectileHit_ExtraData(target, location, keys)
    if not IsServer() then return end
    if not target or not target:IsAlive() or target:IsMagicImmune() then return end
    local caster = self:GetCaster()
    local attacker = caster
    self.advanced_level = self:GetSpecialValueFor("advanced_level")
    self.freezing = self:GetSpecialValueFor("freezing")
    self.duration = self:GetSpecialValueFor("duration")
    self.damage = self:GetSpecialValueFor("damage")

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
        local freezing = (self.advanced_level >= 5 and 0.5 or self.freezing) *attacker:GetAverageTrueAttackDamage(nil)
        target:Freezing(attacker, self, freezing)

        local st_index = self.advanced_level >= 15 and 0.5 or 1
        local nega_index = self.advanced_level >= 15 and 1.25 or 1
        local duration = target:GetHDStatusResistanceIndex(st_index)*attacker:GetModifierStatusNegativeGainIndex(nega_index) * (self.advanced_level >= 20 and 2+self.duration or self.duration)
        if duration > 0 then
            target:AddNewModifier(caster, self, "modifier_Advanced_frost_arrows_slow", {duration = duration}) 
        end

        if self.unlock2 then
            local freeze = target:FindModifierByName("modifier_hd_freezing")
            if freeze then
                target:ActiveFreezing(caster, self, 1.1, 0)
                freeze:Destroy()
            end
        end
    end
end







modifier_Advanced_frost_arrows_attack = advanced_modifier({})

function modifier_Advanced_frost_arrows_attack:IsPassive()          return true end
function modifier_Advanced_frost_arrows_attack:IsBuff()				return true end
function modifier_Advanced_frost_arrows_attack:IsPurgable()     	return false end
function modifier_Advanced_frost_arrows_attack:IsPurgeException() 	return false end
function modifier_Advanced_frost_arrows_attack:IsHidden()			return true end
function modifier_Advanced_frost_arrows_attack:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow.vpcf" 
    end	

end 

function modifier_Advanced_frost_arrows_attack:OnCreated()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.freezing = self.ability:GetSpecialValueFor("freezing")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")
end

function modifier_Advanced_frost_arrows_attack:OnRefresh()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.freezing = self.ability:GetSpecialValueFor("freezing")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.advanced_level = self.ability:GetSpecialValueFor("advanced_level")
end

function modifier_Advanced_frost_arrows_attack:DeclareFunctions()
	return {
	    MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_Advanced_frost_arrows_attack:ADDeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(), nil},
	}
end

function modifier_Advanced_frost_arrows_attack:OnAttackLanded(keys)
    if not IsServer() then return end  
	local ability = self:GetAbility()
	if not self.parent:IsRangedAttacker() or self.parent:PassivesDisabled() or not self.parent:IsAlive() or self.parent:IsIllusion() then return end
    local attacker = keys.attacker
    local target = keys.target
    if not target or not target:IsAlive() or target:IsMagicImmune() then return end

    --该技能需要从网表拿等级数据 自定义变量拿不到该值
    local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
    self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
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
        local freezing = (self.advanced_level >= 5 and 0.5 or self.freezing) *attacker:GetAverageTrueAttackDamage(nil)
        target:Freezing(attacker, self.ability, freezing)
        
        local st_index = self.advanced_level >= 15 and 0.5 or 1
        local nega_index = self.advanced_level >= 15 and 1.25 or 1
        local duration = target:GetHDStatusResistanceIndex(st_index)*attacker:GetModifierStatusNegativeGainIndex(nega_index) * (self.advanced_level >= 20 and 2+self.duration or self.duration)
        if duration > 0 then
            target:AddNewModifier(self.caster, self.ability, "modifier_Advanced_frost_arrows_slow", {duration = duration})
        end

        if ability.unlock2 then
            local freeze = target:FindModifierByName("modifier_hd_freezing")
            if freeze then
                target:ActiveFreezing(self.caster, self.ability, 1.1, 0)
                freeze:Destroy()
            end
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


modifier_Advanced_frost_arrows_slow = advanced_modifier({})
function modifier_Advanced_frost_arrows_slow:IsDebuff()				return true  end
function modifier_Advanced_frost_arrows_slow:IsPurgable() 			return true end
function modifier_Advanced_frost_arrows_slow:IsPurgeException() 	    return true end
function modifier_Advanced_frost_arrows_slow:IsHidden()				return false end
function modifier_Advanced_frost_arrows_slow:OnCreated()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("move_slow")
    self.advanced_level  = self.ability:GetSpecialValueFor("advanced_level")
    if IsServer() then
        if self.advanced_level >= 20 then
            self:AddStackDuration(1, self:GetDuration(), 20)
        end
    end
end

function modifier_Advanced_frost_arrows_slow:OnRefresh()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("move_slow")
    self.advanced_level  = self.ability:GetSpecialValueFor("advanced_level")
    if IsServer() then
        if self.advanced_level >= 20 then
            self:AddStackDuration(1, self:GetDuration(), 20)
        end
    end
end

function modifier_Advanced_frost_arrows_slow:DeclareFunctions() 
    local decfuncs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP,
    }

    if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 then
        table.insert(decfuncs,MODIFIER_PROPERTY_MOVESPEED_LIMIT)
    end

	return decfuncs
end

function modifier_Advanced_frost_arrows_slow:GetModifierMoveSpeed_Limit() 
    if not self:GetAbility() then self:Destroy() return end
    return 550
end

function modifier_Advanced_frost_arrows_slow:GetModifierMoveSpeedBonus_Constant() 
    if not self:GetAbility() then self:Destroy() return end
    return -math.min(math.max(self.slow*self:GetStackCount(), self.slow), 450)
end

function modifier_Advanced_frost_arrows_slow:Advanced_GetModifierPhysicalArmorBonus(keys)
    if not self:GetAbility() then self:Destroy() return end
    return -1*self:GetStackCount()
end

function modifier_Advanced_frost_arrows_slow:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not self:GetAbility() then self:Destroy() return end
    if IsClient() then
        return 
    end
    if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
        return 60
    end
    return 0
end

function modifier_Advanced_frost_arrows_slow:ADDeclareFunctions()
    local funcs = {}
    if self:GetAbility():GetSpecialValueFor("advanced_level") >= 20 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
    end
    if self:GetAbility():GetUnlock(3)==3 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
    end
	return funcs
end

function modifier_Advanced_frost_arrows_slow:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:GetModifierMoveSpeedBonus_Constant()
	elseif self._tooltip == 2 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end

modifier_Advanced_frost_arrows_unlock1 = class({})

function modifier_Advanced_frost_arrows_unlock1:IsDebuff() return false end
function modifier_Advanced_frost_arrows_unlock1:IsHidden() return false end
function modifier_Advanced_frost_arrows_unlock1:IsPurgable() 		return false end
function modifier_Advanced_frost_arrows_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_frost_arrows_unlock1:RemoveOnDeath()  return false end
function modifier_Advanced_frost_arrows_unlock1:DestroyOnExpire()	return false end

function modifier_Advanced_frost_arrows_unlock1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	}
end
function modifier_Advanced_frost_arrows_unlock1:OnAttackLanded(keys)


	if IsServer() then

		if keys.attacker == self:GetParent()then

            if self:GetRemainingTime()<=0 then
                self:SetDuration(5, true)
                local caster = self:GetCaster()
                local enemies = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil,800,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
                if #enemies<=0 then
                    return
                end
                local count = RandomInt(10, 17)
                for i = 1, count, 1 do

                    Timers:CreateTimer(RandomFloat(0.05, 1), function()
                        local target = enemies[RandomInt(1, #enemies)]
                        if target:IsNull() then
                            return
                        end
                        target:EmitSound("Hero_DrowRanger.Attack")
                        local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/frost_arrows/unlock1/effect_start_pos.vpcf", PATTACH_WORLDORIGIN, nil )
                        ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
                        ParticleManager:SetParticleControl( effect_cast, 1, caster:GetOrigin() )
                        ParticleManager:ReleaseParticleIndex( effect_cast )
                        if target:IsAlive() then
                            local modifier_keys = {
                                duration = 0.1,
                                iSpecialAttack = 1,
                                iDisableApplyModifier = 0,
                                iDisableCleave =0,
                                iDisableSplit = 0,
                        
                            }
                            local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
                            caster:PerformAttack( target, true, true, true, true, false, false, true )
                            if IsValid(attackEffectRecord) then
                                attackEffectRecord:Destroy()
                            end
                        end
                    end)
                end
            end

		end
	end
end

