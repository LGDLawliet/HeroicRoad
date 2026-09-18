-- 重写完成
item_hd_mirror_effects = class({})
LinkLuaModifier("modifier_item_hd_mirror_effects", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mirror_effects_lv30", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv10", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_0", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_1", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_2", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_3", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_4", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_5", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_6", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_7", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_2_debuff", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_7_debuff", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_6_trigger", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_effects_lv40_5_debuff", "player_artifact/item_hd_mirror_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_mirror_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_mirror_effects"
end
function item_hd_mirror_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/artifact/mirror/econ/items/chaos_knight/chaos_knight_ti7_shield/mirror_chance.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_hold_monster/effect_target/effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ruby_reverse_radiation/main_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_jump_armor_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_swoop_parent.vpcf", context )
    
end
modifier_item_hd_mirror_effects = advanced_modifier({})

function modifier_item_hd_mirror_effects:IsDebuff() return false end
function modifier_item_hd_mirror_effects:IsHidden() return false end
function modifier_item_hd_mirror_effects:IsPurgable() return false end
function modifier_item_hd_mirror_effects:RemoveOnDeath() return false end
function modifier_item_hd_mirror_effects:GetTexture() return "item_artifact_60" end

function modifier_item_hd_mirror_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.elite_outgoing_mul = self.ability:GetArtifactSpecialValueFor("elite_outgoing_mul")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")

    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.speed_2 = self.ability:GetArtifactSpecialValueFor("speed_2")
    self.cooldown_2 = self.ability:GetArtifactSpecialValueFor("cooldown_2")
    self.radius_3 = self.ability:GetArtifactSpecialValueFor("radius_3")
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.duration_ally_4 = self.ability:GetArtifactSpecialValueFor("duration_ally_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.bonus_chance = 0

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_mirror_effects")
    if self.level >= 40 then
        self.duration_3 = self.duration_4
    end
    self.npc_handler = {
        ["npc_monster_wave_thirsty_servant_elite"] = "modifier_item_hd_mirror_effects_lv40_1",
        ["npc_monster_wave_lava_golem"] = "modifier_chaotic_era_lava_attack",
        ["npc_monster_wave_evil_flower"] = "modifier_chaotic_era_hypnotic_pollen",
        ["npc_monster_wave_evil_chaos_form"] = "modifier_item_hd_mirror_effects_lv40_2",
        ["npc_monster_wave_thirsty_deep_guardian"] = "modifier_item_hd_mirror_effects_lv40_3",
        ["npc_monster_wave_immortal_stumps"] = "modifier_item_hd_mirror_effects_lv40_4",
        ["npc_monster_wave_chaotic_executive"] = "modifier_item_hd_mirror_effects_lv40_5",
        ["npc_monster_wave_5_1_chaotic"] = "modifier_item_hd_mirror_effects_lv40_6",
        ["npc_monster_wave_big_slime"] = "modifier_item_hd_mirror_effects_lv40_7",
    }
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_mirror_effects:OnRefresh(keys)
    self.elite_outgoing_mul = self.ability:GetArtifactSpecialValueFor("elite_outgoing_mul")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")

    self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
    self.speed_2 = self.ability:GetArtifactSpecialValueFor("speed_2")
    self.cooldown_2 = self.ability:GetArtifactSpecialValueFor("cooldown_2")
    self.radius_3 = self.ability:GetArtifactSpecialValueFor("radius_3")
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.duration_ally_4 = self.ability:GetArtifactSpecialValueFor("duration_ally_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.bonus_chance = 0

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_mirror_effects")
    if self.level >= 40 then
        self.duration_3 = self.duration_4
    end
end

function modifier_item_hd_mirror_effects:OnIntervalThink()
    local unit = self:GetParent()
    local random = math.random(0,1)
    self:SetStackCount(random)
    if self.level >= 10 then
        unit:AddNewModifier(unit, self.ability, "modifier_item_hd_mirror_effects_lv10", {})
    end
    if self.level >= 20 then
        if self.level < 70 then
            if self.chance_2 >= math.random(1,100) then
                self:SetStackCount(2)
            end
        else
            if self.chance_2 + self.bonus_chance >= math.random(1,100) then
                self:SetStackCount(2)
                self.bonus_chance = 0
            else
                self.bonus_chance = self.bonus_chance + self.chance_7
            end
        end
    end

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/artifact/mirror/econ/items/chaos_knight/chaos_knight_ti7_shield/mirror_chance.vpcf", PATTACH_WORLDORIGIN , unit)
    local pos = unit:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle_cast_fx, 1, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
    ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
    unit:GameTimer(0.5, function()
        ParticleManager:DestroyParticle(particle_cast_fx, false)
        ParticleManager:ReleaseParticleIndex(particle_cast_fx)
    end)
    unit:EmitSoundParams("Hero_ChaosKnight.RealityRift", 0, 0.6, 0)
end

function modifier_item_hd_mirror_effects:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MODEL_SCALE_CONSTANT
    }
end
function modifier_item_hd_mirror_effects:GetModifierModelScaleConstant()
    if self:GetStackCount() == 1 then
        return 1.3
    elseif self:GetStackCount() == 0 then
        return 0.5
    end
    return 1
end
function modifier_item_hd_mirror_effects:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierIncomingDamage_Percentage() 
	end
	if self._tooltip == 2 then
		if self:GetStackCount() == 0 or self:GetStackCount() == 2 then
            return self.outgoing
        end
	end
end

function modifier_item_hd_mirror_effects:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
    }
end

function modifier_item_hd_mirror_effects:Advanced_GetModifierCooldownReduction()
    if self:GetStackCount() == 2 then
        return self.cooldown_2
    end
    return 0
end

function modifier_item_hd_mirror_effects:Advanced_GetModifierAttackSpeedPercentage()
    if self:GetStackCount() == 2 then
        return self.speed_2
    end
    return 0
end

function modifier_item_hd_mirror_effects:Advanced_GetModifierIncomingDamage_Percentage()
    if self:GetStackCount() >= 1 then
        return -self.incoming
    end
    return 0
end

function modifier_item_hd_mirror_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    self.final = 0
    if self:GetStackCount() == 0 or self:GetStackCount() == 2 then
        self.final = self.final + self.outgoing
    end
    if keys.target and keys.target:IsChaoticEraElite() then
        self.final = ((1 + self.final*0.01)*(1+self.elite_outgoing_mul*0.01)-1)*100
    end
    return self.final
end

function modifier_item_hd_mirror_effects:OnDeath(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local unit = keys.unit
    if not unit then return end
    if attacker ~= self:GetParent() then return end
    local unit_name = unit:GetUnitName()
    if self.level < 30 then return end
    
    local modifiername = self.npc_handler[unit_name]
    if modifiername then
        attacker:AddNewModifier(attacker,self.ability,modifiername,{duration = self.duration_3})
    end

    if attacker:HasModifier("modifier_super_elite_debuff") then
        attacker:AddNewModifier(attacker,self.ability,"modifier_item_hd_mirror_effects_lv40_0",{duration = self.duration_3})
    end
    
    if self.level >= 40 then
        local allys = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _, ally in ipairs(allys) do
			if ally:IsAlive() and ally ~= attacker then
                if ally:IsAlive() then
                    if modifiername then
                        ally:AddNewModifier(attacker,self.ability,modifiername,{duration = self.duration_ally_4})
                    end
                
                    if attacker:HasModifier("modifier_super_elite_debuff") then
                        ally:AddNewModifier(attacker,self.ability,"modifier_item_hd_mirror_effects_lv40_0",{duration = self.duration_ally_4})
                    end
                    break
                end
			end
		end
    end
end
-----
modifier_item_hd_mirror_effects_lv10 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv10:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv10:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv10:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv10:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv10:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then return end
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
end
function modifier_item_hd_mirror_effects_lv10:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_mirror_effects_lv10:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv10:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.incoming_1
	end
end
function modifier_item_hd_mirror_effects_lv10:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then 
        self:Destroy()
    end

    if not self.already then
        self:SetDuration(self.duration_1, true)
        self.already = true
    end
    
    return -self.incoming_1
end
-----精英教育，吸血减伤
modifier_item_hd_mirror_effects_lv40_0 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_0:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_0:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_0:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_0:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_0:OnCreated(keys)
    self.ability = self:GetAbility()
    self.heal =  0.02
    self.incoming = 18

    local parent = self:GetParent()
	local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_swoop_parent.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, parent, PATTACH_CENTER_FOLLOW, nil, parent:GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
end
function modifier_item_hd_mirror_effects_lv40_0:OnRefresh(keys)
    self.heal =  0.02
    self.incoming = 18
end
function modifier_item_hd_mirror_effects_lv40_0:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
end
function modifier_item_hd_mirror_effects_lv40_0:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return -self.incoming
end
function modifier_item_hd_mirror_effects_lv40_0:OnAttackLanded(tg)
    if IsServer() then   
        if not self:GetAbility() then return end
        local attacker = tg.attacker
        if attacker ~= self:GetParent() then return end
        
		local hp = attacker:GetMaxHealth()*self.heal
        attacker:Heal(hp, self.ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, hp, nil)
    end 
end
function modifier_item_hd_mirror_effects_lv40_0:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_0:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.heal*100
    elseif self._tooltip == 2 then
       return self.incoming 
    end
end
-----饥渴先锋，攻击力护甲
modifier_item_hd_mirror_effects_lv40_1 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_1:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_1:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_1:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_1:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_1:OnCreated(keys)
    self.ability = self:GetAbility()
    self.attack =  18
    self.armor = 10
end
function modifier_item_hd_mirror_effects_lv40_1:OnRefresh(keys)
    self.attack =  18
    self.armor = 10
end
function modifier_item_hd_mirror_effects_lv40_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_mirror_effects_lv40_1:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.attack
end
function modifier_item_hd_mirror_effects_lv40_1:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.armor
end
function modifier_item_hd_mirror_effects_lv40_1:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.attack
    elseif self._tooltip == 2 then
       return self.armor 
    end
end
-----混乱化身，法强上古
modifier_item_hd_mirror_effects_lv40_2 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_2:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_2:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_2:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_2:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_2:OnCreated(keys)
    self.ability = self:GetAbility()
    self.spell_amp =  35
end
function modifier_item_hd_mirror_effects_lv40_2:OnRefresh(keys)
    self.spell_amp =  35
end
function modifier_item_hd_mirror_effects_lv40_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end
function modifier_item_hd_mirror_effects_lv40_2:Advanced_GetModifierSpellAmplifyBonus()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.spell_amp
end

function modifier_item_hd_mirror_effects_lv40_2:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_2:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.spell_amp
    end
end
function modifier_item_hd_mirror_effects_lv40_2:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end
		if keys.damage_type~=DAMAGE_TYPE_MAGICAL  then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

		if unit:HasModifier("modifier_item_hd_mirror_effects_lv40_2_debuff") then
			return
		end
		local ability = self:GetAbility()
		unit:AddNewModifier(attacker,ability, "modifier_item_hd_mirror_effects_lv40_2_debuff", {duration = 2})
    end 
end

modifier_item_hd_mirror_effects_lv40_2_debuff = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_2_debuff:IsDebuff() return true end
function modifier_item_hd_mirror_effects_lv40_2_debuff:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_2_debuff:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_2_debuff:IsPurgeException() return false end
function modifier_item_hd_mirror_effects_lv40_2_debuff:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_2_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.magical_res_reduce = -14
	if IsServer() then
		self:PlayEffects()
	end
end
function modifier_item_hd_mirror_effects_lv40_2_debuff:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
end
function modifier_item_hd_mirror_effects_lv40_2_debuff:GetModifierMagicalResistanceBonus()
    if not self.ability then 
        self:Destroy()
        return 
    end
    return self.magical_res_reduce 
end
function modifier_item_hd_mirror_effects_lv40_2_debuff:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf"
	local sound_cast = "Hero_SkywrathMage.AncientSeal.Target"
	local parent = self:GetParent()
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOn( sound_cast, parent )
end
-----深海卫士，攻击力穿甲
modifier_item_hd_mirror_effects_lv40_3 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_3:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_3:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_3:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_3:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_3:OnCreated(keys)
    self.ability = self:GetAbility()
    self.attack = 21
    self.no_armor = 6
end
function modifier_item_hd_mirror_effects_lv40_3:OnRefresh(keys)
    self.attack =  21
    self.no_armor = 6
end
function modifier_item_hd_mirror_effects_lv40_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
    }
end
function modifier_item_hd_mirror_effects_lv40_3:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.attack
end
function modifier_item_hd_mirror_effects_lv40_3:Advanced_GetModifierAttackArmor_Ignore()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.no_armor
end
function modifier_item_hd_mirror_effects_lv40_3:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_3:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.attack
    elseif self._tooltip == 2 then
       return self.no_armor 
    end
end
-----不朽树墩，最大血量，回血
modifier_item_hd_mirror_effects_lv40_4 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_4:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_4:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_4:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_4:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_4:OnCreated(keys)
    self.ability = self:GetAbility()
    self.maxhp =  30
    self.regen = 3
end
function modifier_item_hd_mirror_effects_lv40_4:OnRefresh(keys)
    self.maxhp =  30
    self.regen = 3
end
function modifier_item_hd_mirror_effects_lv40_4:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end
function modifier_item_hd_mirror_effects_lv40_4:AdvancedGetModifierExtraHealthPercentage()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.maxhp
end
function modifier_item_hd_mirror_effects_lv40_4:AdvancedGetModifierConstantHealthRegenPercentage()
    if not self:GetAbility() then 
        self:Destroy()
    end
    return self.regen
end
function modifier_item_hd_mirror_effects_lv40_4:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_4:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.maxhp
    elseif self._tooltip == 2 then
       return self.regen 
    end
end
-----执政官，减
modifier_item_hd_mirror_effects_lv40_5 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_5:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_5:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_5:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_5:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_5:OnCreated(keys)
    self.ability = self:GetAbility()
    self.interval = 6
    self.radius = 800
    self.max = 3
    self.armor_down =  40
    self.magic_res = 30
    if IsServer() then 
        self:StartIntervalThink(self.interval)
    end
end
function modifier_item_hd_mirror_effects_lv40_5:OnRefresh(keys)
    self.interval = 4
    self.radius = 800
    self.max = 3
    self.armor_down =  40
    self.magic_res = 30
end
function modifier_item_hd_mirror_effects_lv40_5:OnIntervalThink()
    local parent = self:GetParent()
    if parent:IsAlive() and self.ability then      
        local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	    for i, unit in ipairs(enemies) do
            if unit:IsAlive() then
                self:ApplyModifier(unit)
                if i > self.max then
                    break
                end
            end
	    end
        
    end
end

function modifier_item_hd_mirror_effects_lv40_5:ApplyModifier(target)
	local caster = self:GetCaster()

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_item_hd_mirror_effects_lv40_5_debuff", {duration = self.interval})

	EmitSoundOn("chaotic_ruby_reverse_radiation_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_ruby_reverse_radiation/main_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	local dis = CalculateDistance(target,caster)
	local dir = CalculateDirection(target,caster)
	local randomRange = math.min(dis*0.1,450)
	ParticleManager:SetParticleControl(head_particle, 6, caster:GetAbsOrigin()+dir*dis*0.35 + RandomVector(randomRange) )
	ParticleManager:SetParticleControl(head_particle, 10, caster:GetAbsOrigin()+dir*dis*0.7 + RandomVector(randomRange) )

	ParticleManager:ReleaseParticleIndex(head_particle)
end

function modifier_item_hd_mirror_effects_lv40_5:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_5:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 5 + 1
	if self._tooltip == 1 then
		return self.interval
    elseif self._tooltip == 2 then
       return self.radius 
    elseif self._tooltip == 3 then
       return self.max
    elseif self._tooltip == 4 then
        return self.armor_down
    elseif self._tooltip == 5 then
        return self.magic_res
    end
end
modifier_item_hd_mirror_effects_lv40_5_debuff = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_5_debuff:IsDebuff() return true end
function modifier_item_hd_mirror_effects_lv40_5_debuff:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_5_debuff:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_5_debuff:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_5_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.armor_down =  40
    self.magic_res = 30
end
function modifier_item_hd_mirror_effects_lv40_5_debuff:OnRefresh(keys)
    self.armor_down =  40
    self.magic_res = 30
end
function modifier_item_hd_mirror_effects_lv40_5_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE
    }
end
function modifier_item_hd_mirror_effects_lv40_5_debuff:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end
function modifier_item_hd_mirror_effects_lv40_5_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.armor_down
    elseif self._tooltip == 2 then
       return self.magic_res 
    end
end
function modifier_item_hd_mirror_effects_lv40_5_debuff:Advanced_GetModifierPhysicalArmorBonusPercentage(tg)
    if not self.ability then 
        self:Destroy()
        return 
    end
    return -self.armor_down
end
function modifier_item_hd_mirror_effects_lv40_5_debuff:GetModifierMagicalResistanceBonus(tg)
    if not self.ability then 
        self:Destroy()
        return 
    end
    return -self.magic_res
end
-----雷兽，电圈
modifier_item_hd_mirror_effects_lv40_6 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_6:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_6:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_6:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_6:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_6:OnCreated(keys)
    self.ability = self:GetAbility()
    self.interval = 4
    self.damage = 40
    if IsServer() then 
        self:StartIntervalThink(self.interval)
    end
end
function modifier_item_hd_mirror_effects_lv40_6:OnRefresh(keys)
    self.interval = 4
    self.damage = 40
end
function modifier_item_hd_mirror_effects_lv40_6:OnIntervalThink()
    local parent = self:GetParent()
    if parent:IsAlive() and self.ability then      
        parent:AddNewModifier(parent, self.ability, "modifier_item_hd_mirror_effects_lv40_6_trigger", {damage = self.damage})
    end
end
function modifier_item_hd_mirror_effects_lv40_6:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_6:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.interval
    elseif self._tooltip == 2 then
       return self.damage 
    end
end
modifier_item_hd_mirror_effects_lv40_6_trigger = advanced_modifier({})
function modifier_item_hd_mirror_effects_lv40_6_trigger:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_6_trigger:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_6_trigger:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_6_trigger:IsPurgeException() return false end
function modifier_item_hd_mirror_effects_lv40_6_trigger:IsStunDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_6_trigger:AllowIllusionDuplicate() return false end
function modifier_item_hd_mirror_effects_lv40_6_trigger:OnCreated(keys)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetParent()
	self.iRadius = 600
	self.iSpeed = 800
    self.iDamage = self.hCaster:HDGetPrimaryStatValue()*keys.damage
    self.enemy_number = 0

	self.tEnemies = {}
	self.iDur = 1   --控制移动方向
	self.fCurDis = 0
	self.iEffectWidth = 100
	if IsServer() then
		self.hCaster:EmitSound("Ability.PlasmaField")
		self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, self.hCaster:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_item_hd_mirror_effects_lv40_6_trigger:OnIntervalThink()
	if IsServer() then
        if not self:GetAbility() then return end
        if self.hCaster:IsAlive() then
            --先将搜寻到的敌人插入表中
            local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil,
             self.fCurDis+self.iEffectWidth,
              DOTA_UNIT_TARGET_TEAM_ENEMY,
               DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for _, enemy in pairs(enemies) do
                --如果是正向
				if self.iDur == 1 then
					if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.hCaster)>=(self.fCurDis-self.iEffectWidth) then
						enemy.IsFlag = false
						table.insert(self.tEnemies, enemy)
                    end
                --否则为反向
                else
                    --判断当前特效的距离，如果小于敌人与施法者的距离
					if self.fCurDis <= CalculateDistance(enemy,self.hCaster) then
						if not IsInTable(enemy,self.tEnemies)then
							enemy.IsFlag = false
							table.insert(self.tEnemies, enemy)
						end
					end
				end
            end
            --敌人入表结束
            if self.tEnemies then
                --取出单位造成伤害，并将已伤害标记为true
				for _, enemy in pairs(self.tEnemies) do
					if not enemy.IsFlag then
                        self.enemy_number = self.enemy_number + 1
						local iDamage = self.iDamage
	
						local tDamage = {
							ability = self:GetAbility(),
							attacker = self.hCaster,
							victim = enemy,
							damage = iDamage,
							damage_type = DAMAGE_TYPE_PURE,
                            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
						}
						ApplyDamage(tDamage)
						enemy.IsFlag = true
					end
				end
            end
            
            --伤害结束，移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则结束
            if self.fCurDis == self.iRadius then
                self:SafeDestroy()
            end
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)
		end
	end
end
function modifier_item_hd_mirror_effects_lv40_6_trigger:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
-----大黏黏，减甲
modifier_item_hd_mirror_effects_lv40_7 = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_7:IsDebuff() return false end
function modifier_item_hd_mirror_effects_lv40_7:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_7:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_7:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_7:OnCreated(keys)
    self.ability = self:GetAbility()
    self.armor_down =  1
    self.armor_max = 40
end
function modifier_item_hd_mirror_effects_lv40_7:OnRefresh(keys)
    self.armor_down =  1
    self.armor_max = 40
end
function modifier_item_hd_mirror_effects_lv40_7:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end
function modifier_item_hd_mirror_effects_lv40_7:OnAttackLanded(tg)
    if IsServer() then   
        if not self:GetAbility() then return end
        local attacker = tg.attacker
        if attacker ~= self:GetParent() then return end
        local target = tg.target
        if not target or not  target:IsAlive() then return end

        target:AddNewModifier(attacker,self.ability,"modifier_item_hd_mirror_effects_lv40_7_debuff",{stack = self.armor_down})
    end 
end

function modifier_item_hd_mirror_effects_lv40_7:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_7:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.armor_down
    elseif self._tooltip == 2 then
       return self.armor_max 
    end
end
modifier_item_hd_mirror_effects_lv40_7_debuff = advanced_modifier({})

function modifier_item_hd_mirror_effects_lv40_7_debuff:IsDebuff() return true end
function modifier_item_hd_mirror_effects_lv40_7_debuff:IsHidden() return false end
function modifier_item_hd_mirror_effects_lv40_7_debuff:IsPurgable() return false end
function modifier_item_hd_mirror_effects_lv40_7_debuff:GetTexture() return "item_artifact_60" end
function modifier_item_hd_mirror_effects_lv40_7_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.armor_down =  1
    self.armor_max = 40
    if IsServer() then 
        self.stack = keys.stack
        self:SetStackCount(math.min(self.stack,self.armor_max))
    end
end
function modifier_item_hd_mirror_effects_lv40_7_debuff:OnRefresh(keys)
    self.armor_down =  1
    self.armor_max = 40
    if IsServer() then 
        self.stack = self.stack + keys.stack
        self:SetStackCount(math.min(self.stack,self.armor_max))
    end
end
function modifier_item_hd_mirror_effects_lv40_7_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE
    }
end
function modifier_item_hd_mirror_effects_lv40_7_debuff:Advanced_GetModifierPhysicalArmorBonusPercentage(tg)
    if not self.ability then 
        self:Destroy()
        return 
    end
    return -self:GetStackCount()*self.armor_down
end

function modifier_item_hd_mirror_effects_lv40_7_debuff:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_mirror_effects_lv40_7_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()*self.armor_down
    end
end