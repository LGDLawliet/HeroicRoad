item_hd_yogsword_effects = class({})
LinkLuaModifier("modifier_item_hd_yogsword_effects", "player_artifact/item_hd_yogsword_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yogsword_effects_cd40", "player_artifact/item_hd_yogsword_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_yogsword_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_yogsword_effects"
end
function item_hd_yogsword_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_dust_hit_ring.vpcf", context )
end

modifier_item_hd_yogsword_effects = advanced_modifier({})

function modifier_item_hd_yogsword_effects:IsDebuff() return false end
function modifier_item_hd_yogsword_effects:IsHidden() return true end
function modifier_item_hd_yogsword_effects:IsPurgable() return false end
-- function modifier_item_hd_yogsword_effects:GetTexture() return "item_artifact_26" end
function modifier_item_hd_yogsword_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.mp_cost = self.ability:GetArtifactSpecialValueFor("mp_cost")*0.01
    self.mp_cost_1 = self.ability:GetArtifactSpecialValueFor("mp_cost_1")*0.01
    self.mp_cost_2 = self.ability:GetArtifactSpecialValueFor("mp_cost_2")*0.01
    self.hp_cut_4 = self.ability:GetArtifactSpecialValueFor("hp_cut_4")*0.01
    self.max_4 = self.ability:GetArtifactSpecialValueFor("max_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.crit_chance_3 = self.ability:GetArtifactSpecialValueFor("crit_chance_3")
    self.crit_damage_3 = self.ability:GetArtifactSpecialValueFor("crit_damage_3")-100
    self.crit_cost_3 = self.ability:GetArtifactSpecialValueFor("crit_cost_3")*0.01
    self.lostmp_index = self.ability:GetArtifactSpecialValueFor("lostmp_index")*0.01
    self.lostmp_index_2 = self.ability:GetArtifactSpecialValueFor("lostmp_index_2")*0.01
    self.index_1 = 0
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_yogsword_effects")
    if self.level >= 10 then
        self.mp_cost = self.mp_cost_1
        self.index_1 = self.ability:GetArtifactSpecialValueFor("index_1")*0.01
    end
    if self.level >= 20 then
        self.mp_cost = self.mp_cost_2
        self.lostmp_index = self.lostmp_index_2
    end
    
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_item_hd_yogsword_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_amp = self.ability:GetArtifactSpecialValueFor("bonus_spell_amp")
    self.mp_cost = self.ability:GetArtifactSpecialValueFor("mp_cost")*0.01
    self.mp_cost_1 = self.ability:GetArtifactSpecialValueFor("mp_cost_1")*0.01
    self.mp_cost_2 = self.ability:GetArtifactSpecialValueFor("mp_cost_2")*0.01
    self.hp_cut_4 = self.ability:GetArtifactSpecialValueFor("hp_cut_4")*0.01
    self.max_4 = self.ability:GetArtifactSpecialValueFor("max_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.crit_chance_3 = self.ability:GetArtifactSpecialValueFor("crit_chance_3")
    self.crit_damage_3 = self.ability:GetArtifactSpecialValueFor("crit_damage_3")-100
    self.crit_cost_3 = self.ability:GetArtifactSpecialValueFor("crit_cost_3")*0.01
    self.lostmp_index = self.ability:GetArtifactSpecialValueFor("lostmp_index")*0.01
    self.lostmp_index_2 = self.ability:GetArtifactSpecialValueFor("lostmp_index_2")*0.01
    self.index_1 = 0
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_yogsword_effects")
    if self.level >= 10 then
        self.mp_cost = self.mp_cost_1
        self.index_1 = self.ability:GetArtifactSpecialValueFor("index_1")*0.01
    end
    if self.level >= 20 then
        self.mp_cost = self.mp_cost_2
        self.lostmp_index = self.lostmp_index_2
    end
end

function modifier_item_hd_yogsword_effects:OnIntervalThink()
    local mp_cost = self.mp_cost
    local mana_cost = self:GetParent():GetMana()*mp_cost
    self:GetParent():Script_ReduceMana(mana_cost, self:GetAbility())
end

function modifier_item_hd_yogsword_effects:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
    return funcs
end

function modifier_item_hd_yogsword_effects:OnAbilityExecuted(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    local caster = self:GetCaster()
    if self.level < 40 then
        return 
    end
    
    local cd = caster:FindModifierByName("modifier_item_hd_yogsword_effects_cd40")
    if cd then
        return 
    end

    for i=0, keys.unit:GetAbilityCount() - 1 do
        local Ability = keys.unit:GetAbilityByIndex(i)
        if Ability ~= nil and Ability:GetAbilityName() ~= "Default_Move" then
            self.castbility = Ability
            break
        end
    end

    local cd_4 = self.cd_4
    if self.castbility:GetCooldown(keys.ability:GetLevel()) < cd_4 then
        return
    end
    if keys.ability ~= self.castbility then return end
    
    local radius = self.radius_4
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    for _,enemy in pairs(enemies) do
        local hp_cut = self.hp_cut_4*enemy:GetMaxHealth()
        local max = self.max_4

        local particle_cast1 = "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_dust_hit_ring.vpcf"
        enemy:EmitSound("Hero_KeeperOfTheLight.BlindingLight")
        local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_CUSTOMORIGIN, enemy )
        ParticleManager:SetParticleControlEnt( effect_cast1, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
        DestroyParticleByDelay(effect_cast1,2)

        enemy:ModifyHealth(enemy:GetHealth()-hp_cut, self:GetAbility(), false, 0)  
        -- self:GetParent():GiveMana(math.min(hp_cut,max))
        -- SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetParent(), math.min(hp_cut,max), nil)
        break
    end
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_yogsword_effects_cd40", {duration = self.cd_4})
end

function modifier_item_hd_yogsword_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_item_hd_yogsword_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
    
	if keys.attacker ~= self:GetParent() then--是自己打的
		return
	end
    if self.level < 30 then
        return 
    end
	if not IsEnemy(target,attacker) then--打的是敌人
		return
	end
	if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then--用的技能伤害
		return 
	end
	if Cannotcrit(keys) then--不是不能暴击的那种
		return
	end
    if attacker:HasModifier("modifier_chaotic_rune11_amn") or attacker:HasModifier("modifier_chaotic_arcane_supremacy") or attacker:HasModifier("modifier_Primary_arcane_supremacy") or attacker:HasModifier("modifier_Middle_arcane_supremacy") or attacker:HasModifier("modifier_Advanced_arcane_supremacy") then
        return 
    end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end--不是生命流失
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end--不是无任何追加
	
	local chance = self.crit_chance_3
	local crit = self.crit_damage_3

	local random = math.random
	if chance >= random(1,100) then
        local mana_cost = self:GetParent():GetMana()*self.crit_cost_3
        attacker:Script_ReduceMana(mana_cost, self:GetAbility())
		return crit
	end
	return 0
end

function modifier_item_hd_yogsword_effects:Advanced_GetModifierSpellAmplifyBonus()
    local parent = self:GetParent()
    local max_mana = parent:GetMaxMana()
    local mana = parent:GetMana()
    local now_mana_pct
    local lost_mana_pct = (max_mana-mana)*100/max_mana
    if self.level >= 70 then
        now_mana_pct = mana*100/max_mana
        lost_mana_pct = math.max(lost_mana_pct, now_mana_pct)
    end

    local lostmp_index = self.lostmp_index
    local spell_amp_count = lost_mana_pct*lostmp_index
    local spell_amp_10 = self.index_1

    return self.bonus_spell_amp + spell_amp_count + spell_amp_10
end
---------------------------------------------
modifier_item_hd_yogsword_effects_cd40 = advanced_modifier({})

function modifier_item_hd_yogsword_effects_cd40:IsDebuff() return false end
function modifier_item_hd_yogsword_effects_cd40:IsHidden() return true end
function modifier_item_hd_yogsword_effects_cd40:IsPurgable() return false end