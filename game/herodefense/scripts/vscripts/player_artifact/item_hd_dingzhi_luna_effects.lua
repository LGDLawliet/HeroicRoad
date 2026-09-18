-- 重写完成
item_hd_dingzhi_luna_effects = class({})
LinkLuaModifier("modifier_item_hd_dingzhi_luna_effects", "player_artifact/item_hd_dingzhi_luna_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_effects_cd", "player_artifact/item_hd_dingzhi_luna_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_effects_lv20", "player_artifact/item_hd_dingzhi_luna_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_dingzhi_luna_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_dingzhi_luna_effects"
end
function item_hd_dingzhi_luna_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf", context )
end
function item_hd_dingzhi_luna_effects:GetArtifactSpecialList()
    local list = {}
    list["76561198200656253"] = true
    return list
end
function item_hd_dingzhi_luna_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_luna_effects:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end
modifier_item_hd_dingzhi_luna_effects = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_effects:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_effects:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_effects:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_effects:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_luna_effects:GetTexture() return "item_artifact_63" end
function modifier_item_hd_dingzhi_luna_effects:DestroyOnExpire() return false end
function modifier_item_hd_dingzhi_luna_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_int = self.ability:GetArtifactSpecialValueFor("bonus_int")
    self.bonus_agi = self.ability:GetArtifactSpecialValueFor("bonus_agi")
    self.need = self.ability:GetArtifactSpecialValueFor("need")
    self.attack_speed = self.ability:GetArtifactSpecialValueFor("attack_speed")
    self.spell_amp = self.ability:GetArtifactSpecialValueFor("spell_amp")
    self.stack_max = self.ability:GetArtifactSpecialValueFor("stack_max")

    self.damage_1 = self.ability:GetArtifactSpecialValueFor("damage_1")
    self.cd_1 = self.ability:GetArtifactSpecialValueFor("cd_1")
    self.time_reduce_1 = self.ability:GetArtifactSpecialValueFor("time_reduce_1")*0.01
    self.int_line_2 = self.ability:GetArtifactSpecialValueFor("int_line_2")
    self.stack_max_2 = self.ability:GetArtifactSpecialValueFor("stack_max_2")
    self.agi_line_2 = self.ability:GetArtifactSpecialValueFor("agi_line_2")
    self.defense_down_2 = self.ability:GetArtifactSpecialValueFor("defense_down_2")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.int_line_3 = self.ability:GetArtifactSpecialValueFor("int_line_3")
    self.outgoing_3 = self.ability:GetArtifactSpecialValueFor("outgoing_3")
    self.cd_reduce_4 = self.ability:GetArtifactSpecialValueFor("cd_reduce_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.max_4 = self.ability:GetArtifactSpecialValueFor("max_4")
    self.stack_max_7 = self.ability:GetArtifactSpecialValueFor("stack_max_7")
    self.int_check_2 = false
    self.lightning_outgoing = 0
    self:SetStackCount(0)
    
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_effects")
    if self.level >= 70 then
        self.stack_max = self.stack_max + self.stack_max_7
    end
    if IsServer() then
        self:StartIntervalThink(1)
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_item_hd_dingzhi_luna_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_int = self.ability:GetArtifactSpecialValueFor("bonus_int")
    self.bonus_agi = self.ability:GetArtifactSpecialValueFor("bonus_agi")
    self.need = self.ability:GetArtifactSpecialValueFor("need")
    self.attack_speed = self.ability:GetArtifactSpecialValueFor("attack_speed")
    self.attack_speed_max = self.ability:GetArtifactSpecialValueFor("attack_speed_max")
    self.spell_amp = self.ability:GetArtifactSpecialValueFor("spell_amp")
    self.spell_amp_max = self.ability:GetArtifactSpecialValueFor("spell_amp_max")

    self.damage_1 = self.ability:GetArtifactSpecialValueFor("damage_1")
    self.cd_1 = self.ability:GetArtifactSpecialValueFor("cd_1")
    self.time_reduce_1 = self.ability:GetArtifactSpecialValueFor("time_reduce_1")*0.01
    self.int_line_2 = self.ability:GetArtifactSpecialValueFor("int_line_2")
    self.attack_speed_max_2 = self.ability:GetArtifactSpecialValueFor("attack_speed_max_2")
    self.agi_line_2 = self.ability:GetArtifactSpecialValueFor("agi_line_2")
    self.defense_down_2 = self.ability:GetArtifactSpecialValueFor("defense_down_2")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.int_line_3 = self.ability:GetArtifactSpecialValueFor("int_line_3")
    self.outgoing_3 = self.ability:GetArtifactSpecialValueFor("outgoing_3")
    self.cd_reduce_4 = self.ability:GetArtifactSpecialValueFor("cd_reduce_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.max_4 = self.ability:GetArtifactSpecialValueFor("max_4")
    self.stack_max_7 = self.ability:GetArtifactSpecialValueFor("stack_max_7")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_effects")
    if self.level >= 70 then
        self.stack_max = self.stack_max + self.stack_max_7
    end
end

function modifier_item_hd_dingzhi_luna_effects:OnIntervalThink()
    self.int_check_2 = false
    if (self.level >=20 and self:GetParent():GetIntellect(false) >= self.int_line_2) or self.level >= 100 then
        self.int_check_2 = true
    end
    local parent = self:GetParent()
    self.stack = math.floor((parent:GetAgility()+parent:GetIntellect(false))/self.need)
    self.max = self.stack_max
    if self.int_check_2 then
        self.max = self.stack_max_2
        if self.level >= 70 then
           self.max = self.stack_max_2 + self.stack_max_7 
        end
    end
    self.stack = math.min(self.stack,self.max)
    self:SetStackCount(self.stack)
end

function modifier_item_hd_dingzhi_luna_effects:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_dingzhi_luna_effects:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_item_hd_dingzhi_luna_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    local attacker = keys.attacker
    local target = keys.target
    if attacker ~= self:GetParent() or attacker:IsInSpecialAttack() then return end
    if not target or not target:IsAlive() then return end
    if self.level < 10 then return end
    
    local time = self:GetRemainingTime()
    if time >= 0 then
        local time_reduce = math.max(self.time_reduce_1*time, 0.05)
        self:SetDuration(time-time_reduce, true)
        return
    end
    local apply_debuff = false
    if (self.level >= 20 and attacker:GetAgility() >= self.agi_line_2) or self.level >= 100 then
        apply_debuff = true
    end
    self:Thunder(target, apply_debuff, 1)  

    local cd = self.cd_1
    if self.level >= 40 then
        cd = math.max(self.cd_1 - math.floor(attacker:GetAgility()/self.int_line_3)*self.cd_reduce_4, self.cd_4)
    end
    self:SetDuration(cd, true)
end 

function modifier_item_hd_dingzhi_luna_effects:Thunder(target, apply_debuff, index)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if not target or not target:IsAlive() then return end
    local caster = self:GetCaster()
    local agint = caster:GetAgility() + caster:GetIntellect(false)

    if apply_debuff then
        target:AddNewModifier(caster,self.ability,"modifier_item_hd_dingzhi_luna_effects_lv20",{stack = self.defense_down_2, duration = self.duration_2}) 
    end

    local damage_table = {
        attacker 		= caster,
        victim          = target,
        ability 		= self:GetAbility(),
        damage_type 	= DAMAGE_TYPE_MAGICAL ,
        damage			= agint*self.damage_1*index,
        damage_flags    = DOTA_DAMAGE_FLAG_NONE,
        hd_flags        = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
    }

    local dingzhi_luna_2 = caster:FindModifierByName("modifier_item_hd_dingzhi_luna_2_effects")
    if dingzhi_luna_2 then
        if dingzhi_luna_2.level >= 30 then
           if agint >= dingzhi_luna_2.line_3 then
                damage_table.damage = damage_table.damage + dingzhi_luna_2.damage_3
                damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE
           end
        end
    end

    ApplyDamage(damage_table)
    self:PlayEffects(target)
end

function modifier_item_hd_dingzhi_luna_effects:PlayEffects(target)

	local particle_cast = "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf"
	local sound_cast = "Hero_Disruptor.ThunderStrike.Target"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, target )
	local pos = target:GetOrigin()
	ParticleManager:SetParticleControl( effect_cast, 2, pos )
	ParticleManager:SetParticleControl( effect_cast, 5, pos )
	pos.z = pos.z +10
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 7, Vector(150,0,0))
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster(target:GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_item_hd_dingzhi_luna_effects:Advanced_GetModifierBonusStats_Agility(keys)
    return self.bonus_agi
end
function modifier_item_hd_dingzhi_luna_effects:Advanced_GetModifierBonusStats_Intellect(keys)
    return self.bonus_int
end
function modifier_item_hd_dingzhi_luna_effects:Advanced_GetModifierAttackSpeedPercentage()
    return self:GetStackCount()*self.attack_speed
end
function modifier_item_hd_dingzhi_luna_effects:Advanced_GetModifierSpellAmplifyBonus()
    return self:GetStackCount()*self.spell_amp
end
function modifier_item_hd_dingzhi_luna_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if not IsServer() then return end
    if not IsLightningDamage(keys) or self.level < 30 then return end
    local parent = self:GetParent()
    self.lightning_outgoing = math.floor((self.level >= 100 and math.max(parent:GetIntellect(false),parent:GetAgility()) or parent:GetIntellect(false))/self.int_line_3)*self.outgoing_3
    return self.lightning_outgoing
end

function modifier_item_hd_dingzhi_luna_effects:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()
    elseif self._tooltip == 2 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
    -- elseif self._tooltip == 3 then
    --     return self.lightning_outgoing
    end
end

function modifier_item_hd_dingzhi_luna_effects:OnDeath(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    local attacker = keys.attacker
    local unit = keys.unit
    if attacker ~= self:GetParent() then return end
    if not unit or not unit:HasModifier("modifier_item_hd_dingzhi_luna_effects_lv20") then return end
    if self.level < 40 then return end
    
    local apply_debuff = false
    if attacker:GetAgility() >= self.agi_line_2 then
        apply_debuff = true
    end
    local i = 0
    local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.radius_4, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        if enemy:IsAlive() then
           self:Thunder(enemy, apply_debuff, 0.4) 
           i = i + 1
        end
        if i >= self.max_4 then
            break
        end
    end
end 

function modifier_item_hd_dingzhi_luna_effects:AddCustomTransmitterData( )
	return
	{
		lightning_outgoing = self.lightning_outgoing,
	}
end
function modifier_item_hd_dingzhi_luna_effects:HandleCustomTransmitterData( data )
	self.lightning_outgoing = data.lightning_outgoing
end
---------
modifier_item_hd_dingzhi_luna_effects_lv20 = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_effects_lv20:IsDebuff() return true end
function modifier_item_hd_dingzhi_luna_effects_lv20:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_effects_lv20:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_effects_lv20:GetTexture() return "item_artifact_63" end
function modifier_item_hd_dingzhi_luna_effects_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_item_hd_dingzhi_luna_effects_lv20:OnRefresh(keys)
    if not self:GetAbility() then return end
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_item_hd_dingzhi_luna_effects_lv20:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_hd_dingzhi_luna_effects_lv20:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not self:GetAbility() then return end
	return self:GetStackCount()
end
------------
modifier_item_hd_dingzhi_luna_effects_cd = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_effects_cd:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_effects_cd:IsHidden() return true end
function modifier_item_hd_dingzhi_luna_effects_cd:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_effects_cd:RemoveOnDeath() return false end
------------