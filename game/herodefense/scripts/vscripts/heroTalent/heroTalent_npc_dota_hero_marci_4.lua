LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_4", "heroTalent/heroTalent_npc_dota_hero_marci_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_4_buff", "heroTalent/heroTalent_npc_dota_hero_marci_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_4_damage", "heroTalent/heroTalent_npc_dota_hero_marci_4", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_marci_4 = class({})

function heroTalent_npc_dota_hero_marci_4:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if #GetAllRealHeroes() <= 1 then
        caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_marci_4_damage", {})
        return
    end

    if target == caster or not target:IsRealHero() then
        return
    end

    -- 移除之前的看护关系
    if caster.guardian_target then
        caster.guardian_target:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_marci_4_buff")
        caster.guardian_target:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_marci_4_damage")
    end
    caster:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_marci_4")
    caster:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_marci_4_damage")

    -- 绑定新目标
    caster.guardian_target = target
    caster.guardian_target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_marci_4_buff", {})
    caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_marci_4", {})

end



-- 主体modifier，挂在Marci身上
modifier_heroTalent_npc_dota_hero_marci_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_marci_4:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_marci_4:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_marci_4:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_marci_4:OnCreated()
    self.ability = self:GetAbility()
    self.atb_pct = self.ability:GetSpecialValueFor("atb_pct")*0.01
    self.range = self.ability:GetSpecialValueFor("range")

    self.atb_str = 0
    self.atb_agi = 0
    self.atb_int = 0

    if not IsServer() then return end
    self:StartIntervalThink(1)
    self:SetHasCustomTransmitterData( true )-- 同步cy
    self:PlayEffects1()
end

function modifier_heroTalent_npc_dota_hero_marci_4:OnIntervalThink()
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local target = caster.guardian_target

    -- 目标无效
    if target and target:IsAlive() then
        if target:IsAlive() then
            self.atb_str = self.atb_pct*target:GetStrength()
            self.atb_agi = self.atb_pct*target:GetAgility()
            self.atb_int = self.atb_pct*target:GetIntellect(false)

            local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
            caster:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_marci_4_damage")
            target:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_marci_4_damage")
            if distance <= self.range then
                caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_marci_4_damage", {duration = 3})
                target:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_marci_4_damage", {duration = 3})
            end
        else
            self.atb_str = 0
            self.atb_agi = 0
            self.atb_int = 0
        end

    end
    self:SendBuffRefreshToClients()
end

function modifier_heroTalent_npc_dota_hero_marci_4:ADDeclareFunctions()
    return { 
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
end

function modifier_heroTalent_npc_dota_hero_marci_4:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_marci_4:Advanced_GetModifierBonusStats_Strength()
    return self.atb_str
end

function modifier_heroTalent_npc_dota_hero_marci_4:Advanced_GetModifierBonusStats_Agility()
    return self.atb_agi
end

function modifier_heroTalent_npc_dota_hero_marci_4:Advanced_GetModifierBonusStats_Intellect()
    return self.atb_int
end

function modifier_heroTalent_npc_dota_hero_marci_4:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.atb_str
	elseif self._tooltip == 2 then
		return  self.atb_agi
    elseif self._tooltip == 3 then
		return  self.atb_int
	end
end

function modifier_heroTalent_npc_dota_hero_marci_4:AddCustomTransmitterData( )
	return
	{
		atb_str = self.atb_str,
		atb_agi = self.atb_agi,
        atb_int = self.atb_int,
	}
end

function modifier_heroTalent_npc_dota_hero_marci_4:HandleCustomTransmitterData( data )
	self.atb_str = data.atb_str
	self.atb_agi = data.atb_agi
    self.atb_int = data.atb_int
end

function modifier_heroTalent_npc_dota_hero_marci_4:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
	if self:GetParent()~=self:GetCaster() then
		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
	end

	local sound_target = "Hero_Marci.Guardian.Applied"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
-- 友军获得攻击力/技能增强加成
modifier_heroTalent_npc_dota_hero_marci_4_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_marci_4_buff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_marci_4_buff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_marci_4_buff:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.attack_pct = self.ability:GetSpecialValueFor("attack_pct")*0.01
    self.spell_amp_pct = self.ability:GetSpecialValueFor("spell_amp_pct")*0.01
    
    
    if IsServer() then
        self.ally_attack = 0
        self.ally_spell_amp = 0
        self:StartIntervalThink(1)
        self:SetHasCustomTransmitterData( true )-- 同步cy
        self:PlayEffects1()
    end
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:OnIntervalThink()
    self.talent_gain = self.ability:GetTalentGain(1)

    if self.caster:IsAlive() then
        self.ally_attack = self.caster:GetAverageTrueAttackDamage(nil)*self.attack_pct*self.talent_gain
        self.ally_spell_amp = self.caster:GetSpellAmplification(false)*self.spell_amp_pct*100*self.talent_gain
    else
        self.ally_attack = 0
        self.ally_spell_amp = 0
    end
    self:SendBuffRefreshToClients()

end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:ADDeclareFunctions()
    return { 
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS }
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:Advanced_GetModifierPreAttack_BonusDamage()
    if not self:GetAbility() then return end
    return self.ally_attack
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:Advanced_GetModifierSpellAmplifyBonus()
    if not self:GetAbility() then return end
    return self.ally_spell_amp
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.ally_attack
	elseif self._tooltip == 2 then
		return  self.ally_spell_amp
	end
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:AddCustomTransmitterData( )
	return
	{
		ally_attack = self.ally_attack,
		ally_spell_amp = self.ally_spell_amp,
	}
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:HandleCustomTransmitterData( data )
	self.ally_attack = data.ally_attack
	self.ally_spell_amp = data.ally_spell_amp
end

function modifier_heroTalent_npc_dota_hero_marci_4_buff:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
	if self:GetParent()~=self:GetCaster() then
		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
	end

	local sound_target = "Hero_Marci.Guardian.Applied"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
-- 距离内双方获得伤害加成
modifier_heroTalent_npc_dota_hero_marci_4_damage = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_marci_4_damage:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_marci_4_damage:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_marci_4_damage:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_marci_4_damage:OnCreated(table)
    self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
end
function modifier_heroTalent_npc_dota_hero_marci_4_damage:ADDeclareFunctions()
    return { advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE }
end

function modifier_heroTalent_npc_dota_hero_marci_4_damage:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then return end
    return self.outgoing
end
