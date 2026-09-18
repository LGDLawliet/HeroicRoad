LinkLuaModifier("modifier_act4_fire", "modifier/modifier_shrine_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_act4_earth", "modifier/modifier_shrine_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_act4_storm", "modifier/modifier_shrine_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_act4_void", "modifier/modifier_shrine_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_act4_earth_magnetize_debuff", "modifier/modifier_shrine_logic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_act4_void_debuff", "modifier/modifier_shrine_logic", LUA_MODIFIER_MOTION_NONE)

modifier_shrine_logic = advanced_modifier({})

function modifier_shrine_logic:IsHidden() return false end
function modifier_shrine_logic:IsPurgable() return false end

function modifier_shrine_logic:OnCreated(kv)
    self.parent = self:GetParent()


    if IsServer() then
        self.origin = self.parent:GetAbsOrigin()
        self.shrine_type = kv.type
        if self.shrine_type == 1 then
            self.color = Vector(75,0,130) --紫色
        elseif self.shrine_type == 2 then
            self.color = Vector(178,34,34) --红色
        elseif self.shrine_type == 3 then
            self.color = Vector(50,205,50) --黄色
        elseif self.shrine_type == 4 then
            self.color = Vector(100,149,237) --青色
        end
        local pfx = ParticleManager:CreateParticle("particles/rebuild/act4/light_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx, 61, self.color)
        self:AddParticle(pfx, false, false, -1, false, false)
        
        local pfx2 = ParticleManager:CreateParticle("particles/rebuild/act4/player_effect.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(pfx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx2, 61, self.color)
        self:AddParticle(pfx2, false, false, -1, false, false)
    end
end

function modifier_shrine_logic:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true, 
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
    }
end

function modifier_shrine_logic:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        UTIL_Remove(parent)
    end
end

function modifier_shrine_logic:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ORDER = {nil,nil}
    }
end

function modifier_shrine_logic:OnOrder( params )
	if IsServer() then
		local unit = params.unit 
		local target = params.target
		local order_type = params.order_type
        if unit and unit:IsAlive() and unit:IsHero() and order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
            if target and target == self.parent and order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
                local distance = CalculateDistance(unit, target)
                if distance <= 200 then
                    self:OnInteracted(unit)
                else
                    ExecuteOrderFromTable({
                        UnitIndex = unit:entindex(),
                        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                        Position = target:GetAbsOrigin(),
                        Queue = false,
                    })
                    unit:SetContextThink("MoveToStone", function()
                        if not self or self:IsNull() then return nil end
                        local parent = self:GetParent()
                        if not parent or parent:IsNull() or not parent:IsAlive() then return nil end
                        if not unit:IsMoving() then return nil end
                        if not target or target:IsNull() or not target:IsAlive() then return nil end
                        if not unit or unit:IsNull() or not unit:IsAlive() then return nil end
                        
                        if not unit:IsMoving() then return nil end

                        if (unit:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 200 then
                            self:OnInteracted(unit)
                            return nil
                        end
                        return 0.1
                    end, 0.1)
                end
            end
        end
	end
	return 0
end

function modifier_shrine_logic:OnInteracted(source)
    if not IsServer() then return end
    
    if not self or self:IsNull() then return end
    
    local parent = self:GetParent()
    if not parent or parent:IsNull() then return end

    local type = self.shrine_type
    local duration = 28

    parent:EmitSound("DOTA_Item.Refresher.Activate")

    local modifier_name 
    if type == 1 then
        modifier_name = "modifier_act4_void"
     elseif type == 2 then
        modifier_name = "modifier_act4_fire"
    elseif type == 3 then
        modifier_name = "modifier_act4_earth"
    elseif type == 4 then
        modifier_name = "modifier_act4_storm"
    end

    if modifier_name then

        local heroes = GetAllRealHeroes()
        for _, hero in pairs(heroes) do
            if hero:IsAlive() then
                if type == 3 then
                    hero:RemoveModifierByName(modifier_name)
                end
                local modifier = hero:AddNewModifier(hero, nil, modifier_name, {
                    duration = duration,
                    pos_x = parent:GetAbsOrigin().x,
                    pos_y = parent:GetAbsOrigin().y,
                    pos_z = parent:GetAbsOrigin().z,
                })
            end
        end

        local gameEvent = {}
        gameEvent["message"] = "#DOTA_HUD_act4_active_info"
        gameEvent["locstring_value"] = source:GetUnitName()
        gameEvent["locstring_value2"] = "#DOTA_Tooltip_" .. modifier_name
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )

    end

    self:Destroy()
end

--================================================================================
-- 1. 灵体附身：灰烬之灵 (Fire)
--================================================================================
modifier_act4_fire = advanced_modifier({})

function modifier_act4_fire:IsHidden() return false end
function modifier_act4_fire:IsPurgable() return false end
function modifier_act4_fire:IsPurgeException() return false end
function modifier_act4_fire:GetTexture()    return "ember_spirit/ti9_immortal_shoulder/ember_spirit_flame_guard_immortal" end
function modifier_act4_fire:OnCreated()

    self.crit_chance = 50
    self.crit_damage = 170
    self.magic_mult =  2
    self.fist_mult_atk = 1.5
    self.fist_mult_atb = 10
    self.trigger_count = 20
    self.outgoing = 50
    self.count = 10
    self.radius = 1200
    self.parent = self:GetParent()
    
    if IsServer() then
        local pfx2 = ParticleManager:CreateParticle("particles/rebuild/act4/player_effect.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(pfx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx2, 61,Vector(178,34,34))
        self:AddParticle(pfx2, false, false, -1, false, false)

        self.timer = GameRules:GetGameTime()
        self.crit = {}
        self.damage_table = {
            ability = nil,
            attacker = self:GetParent(),
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
            apply_damage_interval = 0.2,
        }
        self:SetStackCount(0) -- 用于记录攻击次数
        self:TriggerSleightOfFist()
    end
end

function modifier_act4_fire:OnRefresh()
    self.crit_chance = 50
    self.crit_damage = 170
    self.magic_mult =  2
    self.fist_mult_atk = 1.5
    self.fist_mult_atb = 10
    self.trigger_count = 20
    self.outgoing = 50
    self.count = 10
    self.radius = 1000
        if IsServer() then
        self:TriggerSleightOfFist()
    end
end

function modifier_act4_fire:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_act4_fire:ADDeclareFunctions()
    local funcs = 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }

	return funcs
end

function modifier_act4_fire:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.outgoing
end

function modifier_act4_fire:OnAttackFail(keys) self.crit[keys.record] = nil end

function modifier_act4_fire:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

    local attacker = keys.attacker
    local target = keys.target

    
    self.crit[keys.record] = nil

    -- local forward = (target:GetOrigin()-attacker:GetOrigin()):Normalized()
    -- local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    -- ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
    -- ParticleManager:SetParticleControlEnt( effect_cast, 1, target, PATTACH_POINT_FOLLOW,"attach_hitloc", target:GetOrigin(),true)
    -- ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
    -- ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
    -- ParticleManager:ReleaseParticleIndex( effect_cast )
    attacker:EmitSound("chaotic_kalia_swordcraft_hit")

    if target:IsAlive() then
        self.damage_table.damage = self.magic_mult * attacker:HDGetPrimaryStatValue()
        target:ApplyMergeDamage(self.damage_table)
    end

    

    local current_stack = self:GetStackCount() + 1
    self:SetStackCount(math.min(current_stack, self.trigger_count))


    if current_stack >= self.trigger_count then
        local time = GameRules:GetGameTime()
        if time - self.timer >= 2 then
            self.timer = time

            self:SetStackCount(0)
            self:TriggerSleightOfFist()
        end
    end	
end

function modifier_act4_fire:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
		if self.crit_chance >= math.random(1,100) then
			self.crit[keys.record] = true
			return self.crit_damage
		end
	end
end

function modifier_act4_fire:OnAttackRecordDestroy(keys)
	if self.crit[keys.record] then
        self.crit[keys.record] = nil
    end
end

function modifier_act4_fire:TriggerSleightOfFist()
    if not IsServer() then return end
    local overhead_pfx = {}
    local attacker = self:GetParent()
    local pos = attacker:GetAbsOrigin() + attacker:GetForwardVector() * 400
    local cast_pos = attacker:GetAbsOrigin()
    local adaptdamagetable = GetAdaptDamage(attacker:GetAverageTrueAttackDamage(nil), self.fist_mult_atk, attacker:HDGetPrimaryStatValue(), self.fist_mult_atb)
    self.damage_table.damage = adaptdamagetable.damage

    local pfx_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_cast, 0,  pos)
	ParticleManager:SetParticleControl(pfx_cast, 1, Vector(self.radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx_cast)

    local enemies = FindUnitsInRadius(
        attacker:GetTeamNumber(),
        pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for i = #enemies, 2, -1 do
        local j = RandomInt(1, i)
        enemies[i], enemies[j] = enemies[j], enemies[i]
    end

    local count = 0
    local pfx_self = nil

	if #enemies > 0 then
		pfx_self = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx_self, 0, cast_pos)
		ParticleManager:SetParticleControlEnt(pfx_self, 1, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", cast_pos, true)
		ParticleManager:SetParticleControlForward(pfx_self, 1, (pos - cast_pos):Normalized())

        for i, enemy in pairs(enemies) do
            if count >= self.count then break end
            
            overhead_pfx[i] = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, enemy)
            
            -- local forward = (enemy:GetOrigin()-attacker:GetOrigin()):Normalized()
            -- local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
            -- ParticleManager:SetParticleControlEnt(effect_cast, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true)
            -- ParticleManager:SetParticleControlEnt( effect_cast, 1, enemy, PATTACH_POINT_FOLLOW,"attach_hitloc",enemy:GetOrigin(),true)
            -- ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
            -- ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
            -- ParticleManager:ReleaseParticleIndex( effect_cast )

            enemy:ApplyMergeDamage(self.damage_table)
            
            EmitSoundOn("Hero_EmberSpirit.SleightOfFist.Damage", enemy)
            if overhead_pfx[i] ~= nil and type(overhead_pfx[i]) == "number" then
				ParticleManager:DestroyParticle(overhead_pfx[i], false)
				ParticleManager:ReleaseParticleIndex(overhead_pfx[i])
				overhead_pfx[i] = nil
			end

            count = count + 1
        end

        if pfx_self then
			ParticleManager:DestroyParticle(pfx_self, false)
			ParticleManager:ReleaseParticleIndex(pfx_self)
			pfx_self = nil
		end
	end

    
end

function modifier_act4_fire:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 5 + 1
    if self._tooltip == 1 then return self.crit_chance end
    if self._tooltip == 2 then return self.crit_damage end
    if self._tooltip == 3 then return self.magic_mult end
    if self._tooltip == 4 then return self.outgoing end
    if self._tooltip == 5 then return self.trigger_count - self:GetStackCount() end
    return 0
end

--================================================================================
-- 2. 灵体附身：风暴之灵 (Storm)
--================================================================================
modifier_act4_storm = advanced_modifier({})

function modifier_act4_storm:IsHidden() return false end
function modifier_act4_storm:IsPurgable() return false end
function modifier_act4_storm:IsPurgeException() return false end
function modifier_act4_storm:GetTexture()    return "storm_spirit_static_remnant" end
function modifier_act4_storm:OnCreated()
    -- 获取数值
    self.mana_regen = 0.5
    self.mana_cost_reduce = 90
    self.cdr = 60
    self.trigger_count = 3
    self.radius = 650
    self.storm_mult_atk = 1.2
    self.storm_mult_atb = 8
    self.parent = self:GetParent()
    
    if IsServer() then
        self.timer = GameRules:GetGameTime()
        self.damage_table = {
            ability = nil,
            attacker = self:GetParent(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
            apply_damage_interval = 0.1,
        }
        self:SetStackCount(0)
        self:TriggerLightningBlast()

        local pfx2 = ParticleManager:CreateParticle("particles/rebuild/act4/player_effect.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(pfx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx2, 61,    Vector(100,149,237))
        self:AddParticle(pfx2, false, false, -1, false, false)
    end
end

function modifier_act4_storm:OnRefresh()
    -- 获取数值
    self.mana_regen = 0.5
    self.mana_cost_reduce = 90
    self.cdr = 60
    self.trigger_count = 3
    self.radius = 650
    self.storm_mult_atk = 1.2
    self.storm_mult_atb = 8
    if IsServer() then
        self:TriggerLightningBlast()
    end
end

function modifier_act4_storm:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
    }
end

function modifier_act4_storm:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED = {self:GetParent(), nil},
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_act4_storm:AdvancedGetModifierConstantManaRegen()
    return self.mana_regen * self:GetParent():GetMaxMana()
end

function modifier_act4_storm:GetModifierPercentageManacostStacking()
    return self.mana_cost_reduce
end

function modifier_act4_storm:Advanced_GetModifierCooldownReduction()
    return self.cdr
end

function modifier_act4_storm:OnAbilityExecuted(params)
    if not IsServer() then return end
    local unit = params.unit
    if unit ~= self:GetParent() then return end

    
    -- 排除物品和切换类技能，以及自身触发的技能（防止死循环，虽然这里没创建新技能）
    local ability = params.ability
    if not ability or ability:IsItem() or ability:IsToggle() or ability:GetCooldown(ability:GetLevel()) <= 0 then return end

    local current_stack = self:GetStackCount() + 1
    self:SetStackCount(math.min(current_stack, self.trigger_count))

    if current_stack >= self.trigger_count then
        local time = GameRules:GetGameTime()
        if time - self.timer >= 1.5 then
            self.timer = time

            self:SetStackCount(0)
            self:TriggerLightningBlast()
        end
    end
end

function modifier_act4_storm:TriggerLightningBlast()
    local caster = self:GetParent()
    
    -- 特效
    local pfx = ParticleManager:CreateParticle("particles/rebuild/act4/storm_effect.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)
    
    EmitSoundOn("Hero_StormSpirit.Overload", caster)

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    local adaptdamagetable = GetAdaptDamage(caster:GetAverageTrueAttackDamage(nil), self.storm_mult_atk, caster:HDGetPrimaryStatValue(), self.storm_mult_atb)
    self.damage_table.damage = adaptdamagetable.damage

    for _, enemy in pairs(enemies) do
        enemy:ApplyMergeDamage(self.damage_table)
    end

end

function modifier_act4_storm:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 4 + 1
    if self._tooltip == 1 then return self:AdvancedGetModifierConstantManaRegen() end
    if self._tooltip == 2 then return self:GetModifierPercentageManacostStacking() end
    if self._tooltip == 3 then return self:Advanced_GetModifierCooldownReduction() end
    if self._tooltip == 4 then return self.trigger_count - self:GetStackCount() end
    return 0
end


--================================================================================
-- 3. 灵体附身：大地之灵 (Earth)
--================================================================================
modifier_act4_earth = advanced_modifier({})
function modifier_act4_earth:IsHidden() return false end
function modifier_act4_earth:IsPurgable() return false end
function modifier_act4_earth:IsPurgeException() return false end
function modifier_act4_earth:GetTexture()    return "earth_spirit_stone_caller" end
function modifier_act4_earth:OnCreated()
    self.dmg_reduce = 99
    self.str_bonus = 0.3 * self:GetParent():GetStrength()
    self.trigger_interval = 5
    self.radius = 900
    self.duration = 3
    self.parent = self:GetParent()
    if IsServer() then
        self:StartIntervalThink(self.trigger_interval)
        self:TriggerMagnetize()

        local pfx2 = ParticleManager:CreateParticle("particles/rebuild/act4/player_effect.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(pfx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx2, 61, Vector(50,205,50))
        self:AddParticle(pfx2, false, false, -1, false, false)
    end
end

function modifier_act4_earth:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_act4_earth:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
    }
end

function modifier_act4_earth:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end

	local parent = self:GetParent()
	local health = parent:GetMaxHealth()*0.1
	if keys.damage>=health then
		
		parent:EmitSound("hd_electric.hit")
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/reactive_armor_unlock1/effect_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt(effect_cast, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		DestroyParticleByDelay(effect_cast,1)
		return keys.damage - health
	end
	return 0 
end


function modifier_act4_earth:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.dmg_reduce
end

function modifier_act4_earth:Advanced_GetModifierBonusStats_Strength()
    return self.str_bonus + 40
end

function modifier_act4_earth:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetParent():IsAlive() then return end

    self:TriggerMagnetize()
end

function modifier_act4_earth:TriggerMagnetize()
    local caster = self:GetParent()

    -- 特效
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 2, Vector(self.radius+50, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)
    
    EmitSoundOn("Hero_EarthSpirit.Magnetize.Cast", caster)

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
        ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(pfx)

        enemy:AddNewModifier(caster, nil, "modifier_act4_earth_magnetize_debuff", {duration = self.duration})
    end
end


function modifier_act4_earth:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then return self:Advanced_GetModifierIncomingDamage_Percentage() end
    if self._tooltip == 2 then return self:Advanced_GetModifierBonusStats_Strength() end
    if self._tooltip == 3 then return self.trigger_interval end
    return 0
end

-- 土猫磁化易伤 Debuff
modifier_act4_earth_magnetize_debuff = advanced_modifier({})

function modifier_act4_earth_magnetize_debuff:IsHidden() return false end
function modifier_act4_earth_magnetize_debuff:IsDebuff() return true end
function modifier_act4_earth_magnetize_debuff:IsPurgable() return false end
function modifier_act4_earth_magnetize_debuff:GetTexture()    return "earth_spirit_stone_caller" end
function modifier_act4_earth_magnetize_debuff:GetEffectName()
    return "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_target_trailsmoke.vpcf"
end

function modifier_act4_earth_magnetize_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_act4_earth_magnetize_debuff:CheckState()
    return {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end

function modifier_act4_earth_magnetize_debuff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_act4_earth_magnetize_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    return 50
end

function modifier_act4_earth_magnetize_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_act4_earth_magnetize_debuff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then return self:Advanced_GetModifierIncomingDamage_Percentage() end
    return 0
end
--================================================================================
-- 4. 灵体附身：虚无之灵 (Void)
--================================================================================
modifier_act4_void = advanced_modifier({})

function modifier_act4_void:IsHidden() return false end
function modifier_act4_void:IsPurgable() return false end
function modifier_act4_void:IsPurgeException() return false end
function modifier_act4_void:GetTexture()    return "void_spirit_aether_remnant" end
function modifier_act4_void:OnCreated(kv)
    self.radius = 2000
    self.distance = 2000
    self.width = 175
    self.str_to_res = 0.1
    self.agi_to_crit = 0.04
    self.int_to_amp = 0.08
    self.kill_threshold = 5
    self.parent = self:GetParent()
    
    if IsServer() then
        self.timer = GameRules:GetGameTime()

        self:SetStackCount(0) -- 击杀计数
        self.start_pos = Vector(kv.pos_x, kv.pos_y, kv.pos_z)
        self:CastAstralStep()
        self.start_pos = nil


        local pfx2 = ParticleManager:CreateParticle("particles/rebuild/act4/player_effect.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(pfx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx2, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx2, 61, Vector(75,0,130))
        self:AddParticle(pfx2, false, false, -1, false, false)
    end
end

function modifier_act4_void:OnRefresh(kv)
    self.radius = 2000
    self.distance = 2000
    self.width = 125
    self.str_to_res = 0.1
    self.agi_to_crit = 0.04
    self.int_to_amp = 0.08
    self.kill_threshold = 5
    self.parent = self:GetParent()
    
    if IsServer() then
        self.start_pos = Vector(kv.pos_x, kv.pos_y, kv.pos_z)
        self:CastAstralStep()
        self.start_pos = nil
    end
end

function modifier_act4_void:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_act4_void:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
    }
end


function modifier_act4_void:GetModifierMagicalResistanceBonus()
    if not self.parent:IsHero() then return 0 end
    return self.parent:GetStrength() * self.str_to_res + 10
end

function modifier_act4_void:Advanced_GetModifier_PhysicalCriticalAmp()
    if not self.parent:IsHero() then return 0 end
    return self.parent:GetAgility() * self.agi_to_crit + 20
end

function modifier_act4_void:Advanced_GetModifierSpellAmplifyBonus()
    if not self.parent:IsHero() then return 0 end   
    return self.parent:GetIntellect(false) * self.int_to_amp + 20
end

-- 击杀计数逻辑
function modifier_act4_void:OnDeath(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local unit = params.unit
    if not attacker or attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID() then return end

    -- 击杀非友军单位，且非建筑
    if unit:GetTeamNumber() ~= self.parent:GetTeamNumber() then
        local current_kills = self:GetStackCount() + 1
        self:SetStackCount(math.min(current_kills, self.kill_threshold))   

        

        if current_kills >= self.kill_threshold then
            local time = GameRules:GetGameTime()
            if time - self.timer >= 1.1 then
                self.timer = time

                self:SetStackCount(0)
                self:CastAstralStep()
            end
        end
    end
end

-- 封装的太虚之径函数
function modifier_act4_void:CastAstralStep()
    if not IsServer() then return end
    local caster = self:GetParent()
    local origin = self.start_pos or caster:GetAbsOrigin()
    local target = origin + caster:GetForwardVector() * self.distance

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        origin,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    if enemies[1] then
        target = enemies[1]:GetAbsOrigin()
    end
    local dir = CalculateDirection(target, origin)
    target = target + dir*300

    local particle = ParticleManager:CreateParticle(
    "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf",
    PATTACH_WORLDORIGIN,
    caster
    )
    ParticleManager:SetParticleControl(particle, 0, origin)
    ParticleManager:SetParticleControl(particle, 1, target)
    ParticleManager:ReleaseParticleIndex(particle)
        
    EmitSoundOnLocationWithCaster(origin, "Hero_VoidSpirit.AstralStep.Start", caster)
    EmitSoundOnLocationWithCaster(target, "Hero_VoidSpirit.AstralStep.End", caster)

    local width = 150
    local enemies = FindUnitsInLine(
        caster:GetTeamNumber(),
        origin,
        target,
        nil,
        width,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE
    )

    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, nil, "modifier_act4_void_debuff", {duration = 1.25})

        local particle = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf",
            PATTACH_ABSORIGIN_FOLLOW,
            enemy
        )
        ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)
    end
end


function modifier_act4_void:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 4 + 1
    if self._tooltip == 1 then return self:GetModifierMagicalResistanceBonus() end
    if self._tooltip == 2 then return self:Advanced_GetModifier_PhysicalCriticalAmp() end
    if self._tooltip == 3 then return self:Advanced_GetModifierSpellAmplifyBonus() end
    if self._tooltip == 4 then return self.kill_threshold - self:GetStackCount() end
    return 0
end

------------------------
modifier_act4_void_debuff = modifier_act4_void_debuff or advanced_modifier({})

function modifier_act4_void_debuff:IsHidden() return true end
function modifier_act4_void_debuff:IsDebuff() return true end
function modifier_act4_void_debuff:IsPurgable() return false end
function modifier_act4_void_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_act4_void_debuff:GetTexture()    return "void_spirit_aether_remnant" end
function modifier_act4_void_debuff:OnCreated(kv)
    local caster = self:GetCaster()
    
    if IsServer() then
        local adaptdamagetable = GetAdaptDamage(caster:GetAverageTrueAttackDamage(nil), 1.5, caster:HDGetPrimaryStatValue(), 10)

        self.damagetable = {
            victim = target,
            attacker = caster,
            damage = adaptdamagetable.damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = nil,
            hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
        }

    end
end

function modifier_act4_void_debuff:OnDestroy()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local target = self:GetParent()

    target:ApplyMergeDamage(self.damagetable)
    self:PlayExplosionEffect()
end

function modifier_act4_void_debuff:GetEffectName()
    return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_act4_void_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_act4_void_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_act4_void_debuff:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end

function modifier_act4_void_debuff:PlayExplosionEffect()
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetParent()
    )
    ParticleManager:ReleaseParticleIndex(particle)
    
    EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_VoidSpirit.AstralStep.MarkExplosion", self:GetCaster())
end