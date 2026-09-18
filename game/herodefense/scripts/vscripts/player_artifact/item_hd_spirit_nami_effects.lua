-- 重写完成
item_hd_spirit_nami_effects = class({})
LinkLuaModifier("modifier_item_hd_spirit_nami_effects", "player_artifact/item_hd_spirit_nami_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spirit_nami_effects_lv20", "player_artifact/item_hd_spirit_nami_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spirit_nami_effects_lv30", "player_artifact/item_hd_spirit_nami_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spirit_nami_effects_buff", "player_artifact/item_hd_spirit_nami_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spirit_nami_effects_lv70", "player_artifact/item_hd_spirit_nami_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_spirit_nami_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_spirit_nami_effects"
end
function item_hd_spirit_nami_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/particle_effect/attach_92/effect_lv2_buff_beams.vpcf", context )
end
modifier_item_hd_spirit_nami_effects = advanced_modifier({})

function modifier_item_hd_spirit_nami_effects:IsDebuff() return false end
function modifier_item_hd_spirit_nami_effects:IsHidden() return true end
function modifier_item_hd_spirit_nami_effects:IsPurgable() return false end
function modifier_item_hd_spirit_nami_effects:RemoveOnDeath() return false end

function modifier_item_hd_spirit_nami_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.attack_index = self.ability:GetArtifactSpecialValueFor("attack_index")*0.01
    self.hp_index = self.ability:GetArtifactSpecialValueFor("hp_index")*0.01
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01

    self.mana_cost_1 = self.ability:GetArtifactSpecialValueFor("mana_cost_1")
    self.summon_pick_4 = self.ability:GetArtifactSpecialValueFor("summon_pick_4")*0.01
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    self.summon_amp_10 = self.ability:GetArtifactSpecialValueFor("summon_amp_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_spirit_nami_effects")

    if self.level >= 100 then
        self.bonus_summon_intensity = self.bonus_summon_intensity + self.summon_amp_10
    end
end

function modifier_item_hd_spirit_nami_effects:OnRefresh(keys)
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.attack_index = self.ability:GetArtifactSpecialValueFor("attack_index")*0.01
    self.hp_index = self.ability:GetArtifactSpecialValueFor("hp_index")*0.01
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01

    self.mana_cost_1 = self.ability:GetArtifactSpecialValueFor("mana_cost_1")
    self.summon_pick_4 = self.ability:GetArtifactSpecialValueFor("summon_pick_4")*0.01
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    self.summon_amp_10 = self.ability:GetArtifactSpecialValueFor("summon_amp_10")

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_spirit_nami_effects")
    if self.level >= 100 then
        self.bonus_summon_intensity = self.bonus_summon_intensity + self.summon_amp_10
    end
end


function modifier_item_hd_spirit_nami_effects:OnSummonUnit(keys)
    if not IsServer() then return end
    local target = keys.target
    if not target then return end
    if not target:IsSpriteSummon() then return end
    
    target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_spirit_nami_effects_buff", {level = self.level})
    if self.level >= 20 then
        local random = math.random
        if self.chance_2 >= random(1,100) then
            target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_spirit_nami_effects_lv20", {})
        end
    end
    if self.level >= 70 then
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_spirit_nami_effects_lv70", {duration = self.duration_7})
    end
end

function modifier_item_hd_spirit_nami_effects:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity
    }
end

function modifier_item_hd_spirit_nami_effects:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end
------------------------------------------
modifier_item_hd_spirit_nami_effects_buff = advanced_modifier({})

function modifier_item_hd_spirit_nami_effects_buff:IsDebuff() return false end
function modifier_item_hd_spirit_nami_effects_buff:IsHidden() return true end
function modifier_item_hd_spirit_nami_effects_buff:IsPurgable() return false end
function modifier_item_hd_spirit_nami_effects_buff:RemoveOnDeath() return false end
function modifier_item_hd_spirit_nami_effects_buff:DestroyOnExpire() return false end

function modifier_item_hd_spirit_nami_effects_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)
    end

    self.cd = self:GetAbility():GetArtifactSpecialValueFor("cd")
    self.chance = self:GetAbility():GetArtifactSpecialValueFor("chance")
    self.damage = self:GetAbility():GetArtifactSpecialValueFor("damage")
    self.outgoing_1 = self:GetAbility():GetArtifactSpecialValueFor("outgoing_1")
    self.stun_3 = self:GetAbility():GetArtifactSpecialValueFor("stun_3")
    self.duration_3 = self:GetAbility():GetArtifactSpecialValueFor("duration_3")
    self.damage_4 = self:GetAbility():GetArtifactSpecialValueFor("damage_4")
    self.damage_10 = self:GetAbility():GetArtifactSpecialValueFor("damage_10")*0.01


    self.damageTable1 = {
						--victim = enemy,
						attacker = self:GetParent(),
						--damage = cleave_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags =  DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
	}

    self.damageTable2 = {
						--victim = enemy,
						attacker = self:GetParent(),
						--damage = cleave_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags =  DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
	}       
    
    if self:GetStackCount() >= 100 then
        self.damageTable1.damage_type = DAMAGE_TYPE_PURE
        self.damageTable2.damage_type = DAMAGE_TYPE_PURE
    end
end

function modifier_item_hd_spirit_nami_effects_buff:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
    if self:GetStackCount() >= 10 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
    end
    return funcs
end

function modifier_item_hd_spirit_nami_effects_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    return self.outgoing_1
end

function modifier_item_hd_spirit_nami_effects_buff:Icehit(target)
    if not IsServer() then return end
    if not target then return end
    if not self:GetAbility() then return end
    local caster = self:GetCaster()

    self.damageTable1.damage = self:GetParent():GetAverageTrueAttackDamage(nil)*self.damage
    if self:GetStackCount() >= 100 then
        self.damageTable1.damage = self.damageTable1.damage*(1+self.damage_10)
    end

    local target_pos = target:GetAbsOrigin()

    local particle4 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle4, 0, target_pos)

    local dis = 100
    local dis_min = 200
    local pos2 = target_pos.z + 1000
    local ability = self:GetAbility()
    caster:GameTimer(4, function()
        pos2=pos2-dis
        ParticleManager:SetParticleControl( particle4, 3,Vector(target_pos.x,target_pos.y,pos2))
        if pos2<=dis_min then
            caster:GameTimer(0.1, function()
                ParticleManager:DestroyParticle( particle4, false )
                ParticleManager:ReleaseParticleIndex( particle4 )
            end)
            if not ability or ability:IsNull() then
                return
            end
            local particle2 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_WORLDORIGIN, caster) 
            ParticleManager:SetParticleControl( particle2, 0,target_pos)
            ParticleManager:SetParticleControl( particle2, 3,target_pos)
            EmitSoundOnLocationWithCaster(target_pos, "Hero_Ancient_Apparition.IceBlast.Target", caster)  

            target:ApplyMergeDamage(self.damageTable1)
            if target and target:IsAlive() and self:GetStackCount() >= 30 then
                target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_stunned",{duration = self.stun_3})
                self:GetParent():AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_spirit_nami_effects_lv30",{duration = self.duration_3})
                if self:GetStackCount() >= 40 then
                   self:Fireblast(target) 
                end
            end
            return nil
        else
            return FrameTime()
        end
    end)
end

function modifier_item_hd_spirit_nami_effects_buff:Fireblast(target)
    if not IsServer() then return end
    if not target then return end
    if not self:GetAbility() then return end

    self.damageTable2.damage = self:GetParent():GetAverageTrueAttackDamage(nil)*self.damage_4
    if self:GetStackCount() >= 100 then
        self.damageTable2.damage = self.damageTable2.damage*(1+self.damage_10)
    end

    local effect_fire = ParticleManager:CreateParticle("particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effect_fire, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(effect_fire, 1, Vector(100, 100, 0))
	ParticleManager:ReleaseParticleIndex(effect_fire)
    EmitSoundOnLocationWithCaster(target:GetOrigin(), "Ability.LightStrikeArray", target )

    target:ApplyMergeDamage(self.damageTable2)
end

function modifier_item_hd_spirit_nami_effects_buff:OnAttackLanded(keys)
	if not IsServer() then return end
    if not self:GetAbility() then return end
    local attacker = keys.attacker
    local target = keys.target
    if attacker ~= self:GetParent() then return end
	if attacker:IsInSpecialAttack() then return end
    if not target or not target:IsAlive() then return end
    if self:GetRemainingTime() >= 0 then return end
    local random = math.random
    if self.chance >= random(1,100) then
        self:Icehit(target)
        self:SetDuration(self.cd, true)
    end
end
------------------------------------------
modifier_item_hd_spirit_nami_effects_lv30 = advanced_modifier({})

function modifier_item_hd_spirit_nami_effects_lv30:IsDebuff() return false end
function modifier_item_hd_spirit_nami_effects_lv30:IsHidden() return false end
function modifier_item_hd_spirit_nami_effects_lv30:IsPurgable() return false end
function modifier_item_hd_spirit_nami_effects_lv30:GetTexture() return "item_artifact_53" end
function modifier_item_hd_spirit_nami_effects_lv30:OnCreated(keys)
    if not self:GetAbility() then return end
    self.attack_speed_3 = self:GetAbility():GetArtifactSpecialValueFor("attack_speed_3")
end
function modifier_item_hd_spirit_nami_effects_lv30:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end
function modifier_item_hd_spirit_nami_effects_lv30:GetModifierAttackSpeedBonus_Constant()
    if not self:GetAbility() then return end
    return self.attack_speed_3
end
------------------------------------------------
modifier_item_hd_spirit_nami_effects_lv20 = advanced_modifier({})

function modifier_item_hd_spirit_nami_effects_lv20:IsDebuff() return false end
function modifier_item_hd_spirit_nami_effects_lv20:IsHidden() return false end
function modifier_item_hd_spirit_nami_effects_lv20:IsPurgable() return false end
function modifier_item_hd_spirit_nami_effects_lv20:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_spirit_nami_effects_lv20:GetTexture() return "item_artifact_53" end
function modifier_item_hd_spirit_nami_effects_lv20:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_spirit_nami_effects_lv20:GetEffectName() return "particles/rebuild/particle_effect/attach_92/effect_lv2_buff_beams.vpcf" end

function modifier_item_hd_spirit_nami_effects_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    self.radius_2 = self:GetAbility():GetArtifactSpecialValueFor("radius_2")
    self.attack_each_2 = self:GetAbility():GetArtifactSpecialValueFor("attack_each_2")
    self.attack_max_2 = self:GetAbility():GetArtifactSpecialValueFor("attack_max_2")
    if IsServer() then
        self:StartIntervalThink(3)
    end
end
function modifier_item_hd_spirit_nami_effects_lv20:OnIntervalThink()
    local caster = self:GetParent()
    self:SetStackCount(0)
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius_2, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    for _ , unit in pairs(units) do
        if unit:IsSpriteSummon() then
            self:SetStackCount(self:GetStackCount() + 1)
        end
    end
end
function modifier_item_hd_spirit_nami_effects_lv20:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_spirit_nami_effects_lv20:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MODEL_SCALE_CONSTANT
    }
end
function modifier_item_hd_spirit_nami_effects_lv20:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return math.min(self:GetStackCount()*self.attack_each_2, self.attack_max_2)
end
function modifier_item_hd_spirit_nami_effects_lv20:GetModifierModelScaleConstant()
    return 2
end

------------------------------------------------
modifier_item_hd_spirit_nami_effects_lv70 = advanced_modifier({})

function modifier_item_hd_spirit_nami_effects_lv70:IsDebuff() return false end
function modifier_item_hd_spirit_nami_effects_lv70:IsHidden() return true end
function modifier_item_hd_spirit_nami_effects_lv70:IsPurgable() return false end
function modifier_item_hd_spirit_nami_effects_lv70:GetTexture() return "item_artifact_53" end

function modifier_item_hd_spirit_nami_effects_lv70:OnCreated()
    self.outgoing_7 = self:GetAbility():GetArtifactSpecialValueFor("outgoing_7")
end
function modifier_item_hd_spirit_nami_effects_lv70:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_spirit_nami_effects_lv70:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then return end
    return self.outgoing_7
end
function modifier_item_hd_spirit_nami_effects_lv70:Advanced_GetModifierIncomingDamage_Percentage()
    return -100
end
