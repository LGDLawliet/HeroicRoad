item_hd_dingzhi_lingyin_effects = class({})
LinkLuaModifier("modifier_item_hd_dingzhi_lingyin_effects", "player_artifact/item_hd_dingzhi_lingyin_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_lingyin_effects_lv70", "player_artifact/item_hd_dingzhi_lingyin_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_lingyin_effects_lv40", "player_artifact/item_hd_dingzhi_lingyin_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_lingyin_effects_buff", "player_artifact/item_hd_dingzhi_lingyin_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_dingzhi_lingyin_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_dingzhi_lingyin_effects"
end
function item_hd_dingzhi_lingyin_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf", context )
end
function item_hd_dingzhi_lingyin_effects:GetArtifactSpecialList()
    local list = {}
    list["76561198340659423"] = true
    return list
end
function item_hd_dingzhi_lingyin_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_lingyin_effects:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end
modifier_item_hd_dingzhi_lingyin_effects = advanced_modifier({})

function modifier_item_hd_dingzhi_lingyin_effects:IsDebuff() return false end
function modifier_item_hd_dingzhi_lingyin_effects:IsHidden() return true end
function modifier_item_hd_dingzhi_lingyin_effects:IsPurgable() return false end
function modifier_item_hd_dingzhi_lingyin_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
	self.nova_radius = self.ability:GetArtifactSpecialValueFor("nova_radius")
	self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
	self.summon_index = self.ability:GetArtifactSpecialValueFor("summon_index")*0.01
	self.need_1 = self.ability:GetArtifactSpecialValueFor("need_1")
	self.interval_down_1 = self.ability:GetArtifactSpecialValueFor("interval_down_1")
	self.interval = self.ability:GetArtifactSpecialValueFor("interval")
	self.interval_down_max_1 = self.ability:GetArtifactSpecialValueFor("interval_down_max_1")
	self.sunmmon_index_2 = self.ability:GetArtifactSpecialValueFor("sunmmon_index_2")*0.01
    self.summon_3 = self.ability:GetArtifactSpecialValueFor("summon_3")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")*0.01
    self.radius_10 = self.ability:GetArtifactSpecialValueFor("radius_10")
	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_lingyin_effects")
	
    if self.level >= 20 then
        self.summon_index = self.sunmmon_index_2
    end
    if self.level >= 30 then
        self.bonus_summon_intensity = self.bonus_summon_intensity + self.summon_3
    end
    if self.level >= 100 then
        self.nova_radius = self.radius_10
    end
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(1)
    end
end

function modifier_item_hd_dingzhi_lingyin_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
	self.nova_radius = self.ability:GetArtifactSpecialValueFor("nova_radius")
	self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
	self.summon_index = self.ability:GetArtifactSpecialValueFor("summon_index")*0.01
	self.need_1 = self.ability:GetArtifactSpecialValueFor("need_1")
	self.interval_down_1 = self.ability:GetArtifactSpecialValueFor("interval_down_1")
	self.interval = self.ability:GetArtifactSpecialValueFor("interval")
	self.interval_down_max_1 = self.ability:GetArtifactSpecialValueFor("interval_down_max_1")
	self.sunmmon_index_2 = self.ability:GetArtifactSpecialValueFor("sunmmon_index_2")*0.01
    self.summon_3 = self.ability:GetArtifactSpecialValueFor("summon_3")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")*0.01
    self.radius_10 = self.ability:GetArtifactSpecialValueFor("radius_10")
	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_lingyin_effects")
	
    if self.level >= 20 then
        self.summon_index = self.sunmmon_index_2
    end
    if self.level >= 30 then
        self.bonus_summon_intensity = self.bonus_summon_intensity + self.summon_3
    end
    if self.level >= 100 then
        self.nova_radius = self.radius_10
    end
end

function modifier_item_hd_dingzhi_lingyin_effects:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
        advanced_MODIFIER_PROPERTY_Summon_Intensity
	}
end

function modifier_item_hd_dingzhi_lingyin_effects:Advanced_GetModifier_Summon_Intensity()
	return self.bonus_summon_intensity
end

function modifier_item_hd_dingzhi_lingyin_effects:OnIntervalThink()
    local caster = self:GetCaster()
    local interval_down = math.floor(((caster:GetSummonIntensityIndex(1)*100-100)/self.need_1)) * self.interval_down_1
    local interval = math.max(self.interval - interval_down, self.interval_down_max_1)

    self:SetStackCount(self:GetStackCount()+1)
    if self:GetStackCount() >= interval then
        local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            0,
            false
        )

        if #enemies > 0 then
            self:PlayEffect(caster:GetAbsOrigin())
            self:Blast(enemies[1]:GetAbsOrigin(), caster:GetAverageTrueAttackDamage(nil))
            self:SetStackCount(0)
        end
    end
end

function modifier_item_hd_dingzhi_lingyin_effects:OnSummonUnitFinished(keys)
    if not IsServer() then return end
    local summoner = self.parent
    local target = keys.target
    if not IsValid(target) then return end
    if (not target:IsSpriteSummon()) then return end

    local enemies = FindUnitsInRadius(
        summoner:GetTeamNumber(),
        summoner:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )
    if #enemies > 0 then
        self:PlayEffect(summoner:GetAbsOrigin())
        self:Blast(enemies[1]:GetAbsOrigin(), target:GetAverageTrueAttackDamage(nil))
    end

    if self.level >= 70 then
        local outgoing = (summoner:GetSummonIntensityIndex(1)*100-100)*self.outgoing_7
        target:AddNewModifier(target, self.ability, "modifier_item_hd_dingzhi_lingyin_effects_lv70", {outgoing = outgoing})
    end
end

function modifier_item_hd_dingzhi_lingyin_effects:Blast(pos, attack)
    if not IsServer() then return end
    if not pos then return end
    local caster = self.parent
    local attack = attack or caster:GetAverageTrueAttackDamage(nil)
    local radius = self.nova_radius
    local damage = attack*self.damage*caster:GetSummonIntensityIndex(self.summon_index)
    --print("全额攻击力"..attack.."伤害系数"..self.damage.."召唤强度"..caster:GetSummonIntensityIndex(self.summon_index))

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        pos,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )
    for i,enemy in ipairs(enemies) do
        enemy:Freezing(caster,self.ability,damage)
        if IsValid(enemy) and enemy:IsAlive() then
            enemy:AddNewModifier(caster, self.ability, "modifier_item_hd_dingzhi_lingyin_effects_lv40", {duration = self.duration_4,incoming = self.incoming_4})
        end
        if i >= self.max then
            break 
        end
    end

    local particle_cast = "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf"
    local sound_cast = "Hero_Crystal.CrystalNova"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect_cast, 0, pos)
    ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius*2, 0, radius*2))
    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOnLocationWithCaster(pos, sound_cast, caster)
end

function modifier_item_hd_dingzhi_lingyin_effects:PlayEffect(pos)
    if not IsServer() then return end
    if not pos then pos = self.parent:GetAbsOrigin() end

    local count = 1
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	local caster = self:GetCaster()
    local armor = 1
	local life_duration = 3

    local heal = 100
	local damage = 0
	local unit_pos = pos + (caster:GetForwardVector() * 300) 
	local unit = caster:SummonUnit("npc_hd_artifact_dingzhi_lingyin",life_duration,unit_pos,caster:GetForwardVector(),self.ability,0,heal,nil,damage,armor,0,0)
	table.insert(self.summon_table,unit)
	unit:AddNewModifier(caster, self.ability, "modifier_item_hd_dingzhi_lingyin_effects_buff", {})

    unit_pos = unit:GetAbsOrigin()
	local particle_explosion = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf"
    local effect_explosion = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_explosion, 0, unit_pos)
	ParticleManager:SetParticleControl(effect_explosion, 1, Vector(300, 0, 0)) -- 设置爆炸半径
	ParticleManager:ReleaseParticleIndex(effect_explosion)
    local sound_cast = "hero_Crystal.freezingField.explosion"
	EmitSoundOnLocationWithCaster(unit_pos, sound_cast, caster)
end
---------
modifier_item_hd_dingzhi_lingyin_effects_buff = advanced_modifier({})
function modifier_item_hd_dingzhi_lingyin_effects_buff:IsDebuff() return false end
function modifier_item_hd_dingzhi_lingyin_effects_buff:IsHidden() return true end
function modifier_item_hd_dingzhi_lingyin_effects_buff:IsPurgable() return false end
function modifier_item_hd_dingzhi_lingyin_effects_buff:OnCreated() 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    if IsServer() then
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
end
function modifier_item_hd_dingzhi_lingyin_effects_buff:CheckState() 
    return{
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end

function modifier_item_hd_dingzhi_lingyin_effects_buff:OnDestroy()
    if IsServer() then
        self.parent:RemoveSelf()
    end
end
---------
modifier_item_hd_dingzhi_lingyin_effects_lv40 = advanced_modifier({})
function modifier_item_hd_dingzhi_lingyin_effects_lv40:IsDebuff() return false end
function modifier_item_hd_dingzhi_lingyin_effects_lv40:IsHidden() return true end
function modifier_item_hd_dingzhi_lingyin_effects_lv40:IsPurgable() return false end
function modifier_item_hd_dingzhi_lingyin_effects_lv40:OnCreated(keys) 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_lingyin_effects")
    if IsServer() then
        self:SetStackCount(keys.incoming)
    end
end
function modifier_item_hd_dingzhi_lingyin_effects_lv40:ADDeclareFunctions() 
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_dingzhi_lingyin_effects_lv40:Advanced_GetModifierIncomingDamage_Percentage(keys) 
    if not self:GetAbility() then self:Destroy() return end
    local attacker = keys.attacker
    if attacker and attacker:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID() and attacker:IsSpriteSummon() then
        return self:GetStackCount()
    end
    if attacker and attacker:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID() and self.level >= 100 then
        return self:GetStackCount()
    end
    return 0
end
---------
modifier_item_hd_dingzhi_lingyin_effects_lv70 = advanced_modifier({})
function modifier_item_hd_dingzhi_lingyin_effects_lv70:IsDebuff() return false end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:IsHidden() return false end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:IsPurgable() return false end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:GetTexture() return "item_artifact_31" end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:OnCreated(keys) 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    if IsServer() then
        self:SetStackCount(keys.outgoing)
    end
end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:ADDeclareFunctions() 
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:DeclareFunctions() 
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:OnTooltip(keys) 
    return self:GetStackCount()
end
function modifier_item_hd_dingzhi_lingyin_effects_lv70:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys) 
    if not self:GetAbility() then self:Destroy() return end
    if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
        return self:GetStackCount()
    end
    return 0
end