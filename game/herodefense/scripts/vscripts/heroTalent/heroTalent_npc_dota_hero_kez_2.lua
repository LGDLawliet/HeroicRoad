LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kez_2", "heroTalent/heroTalent_npc_dota_hero_kez_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kez_2_mark", "heroTalent/heroTalent_npc_dota_hero_kez_2.lua", LUA_MODIFIER_MOTION_NONE )


heroTalent_npc_dota_hero_kez_2 = class({})
function heroTalent_npc_dota_hero_kez_2:Precache(context)
	PrecacheResource( "particle", "particles/events/crownfall/survivors/abilities/kez/kez_vulnerable_marker.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_kez/kez_sai_ultimate_crit.vpcf", context )
end
function heroTalent_npc_dota_hero_kez_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_kez_2"
end

modifier_heroTalent_npc_dota_hero_kez_2 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_kez_2:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_kez_2:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_kez_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_kez_2:OnCreated(params)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.magicres = self.ability:GetSpecialValueFor("magicres")
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.crit = self.ability:GetSpecialValueFor("crit")-100
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.chance = self.ability:GetSpecialValueFor("chance")

    self.talentgain = self.ability:GetTalentGain(0.75)
	self.crit_t = self.crit * self.talentgain + 100
	self.armor_t = self.armor * self.talentgain
    self.magicres_t = self.magicres * self.talentgain
    if IsServer() then
        self.parent:AddActivityModifier("kunai")
    end
end
function modifier_heroTalent_npc_dota_hero_kez_2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_kez_2:ADDeclareFunctions()
	return {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
	}
end
function modifier_heroTalent_npc_dota_hero_kez_2:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.75)
	self.crit_t = self.crit * self.talentgain + 100
	self.armor_t = self.armor * self.talentgain
    self.magicres_t = self.magicres * self.talentgain

	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.armor_t
    elseif self._tooltip == 2 then
        return self.magicres_t
    elseif self._tooltip == 3 then
        return self.crit_t
    end
end
function modifier_heroTalent_npc_dota_hero_kez_2:Advanced_GetModifierCriticalStrike(keys)
    if not IsServer() then return end

    local attacker = keys.attacker
    local target = keys.target

    if attacker ~= self.parent then return end
    if not target or not target:IsAlive() or not attacker:IsAlive() then return end

    self.talentgain = self.ability:GetTalentGain(0.75)
	self.crit_t = self.crit * self.talentgain + 100
	self.armor_t = self.armor * self.talentgain
    self.magicres_t = self.magicres * self.talentgain

    local mark = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_kez_2_mark")
    if mark then 
        mark:Destroy()
        local pfx_name = "particles/units/heroes/hero_kez/kez_sai_ultimate_crit.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx, 0, attacker:GetForwardVector() * -1, attacker:GetRightVector(), attacker:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx)
        return self.crit_t
    elseif self.chance >= math.random(1,100) then
        target:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_kez_2_mark", {duration = self.duration})
    end
end


---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_kez_2_mark = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_kez_2_mark:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_kez_2_mark:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_kez_2_mark:GetEffectName()
    return "particles/events/crownfall/survivors/abilities/kez/kez_vulnerable_marker.vpcf"
end
function modifier_heroTalent_npc_dota_hero_kez_2_mark:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
function modifier_heroTalent_npc_dota_hero_kez_2_mark:OnCreated(params)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.magicres = self.ability:GetSpecialValueFor("magicres")
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.duration = self.ability:GetSpecialValueFor("duration")

    self.talentgain = self.ability:GetTalentGain(0.75)
	self.armor_t = self.armor * self.talentgain
    self.magicres_t = self.magicres * self.talentgain
end

function modifier_heroTalent_npc_dota_hero_kez_2_mark:OnRefresh(params)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.magicres = self.ability:GetSpecialValueFor("magicres")
    self.armor = self.ability:GetSpecialValueFor("armor")

    self.talentgain = self.ability:GetTalentGain(0.75)
	self.armor_t = self.armor * self.talentgain
    self.magicres_t = self.magicres * self.talentgain
end

function modifier_heroTalent_npc_dota_hero_kez_2_mark:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_kez_2_mark:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_kez_2_mark:Advanced_GetModifierPhysicalArmorBonus()
    return -self.armor_t
end

function modifier_heroTalent_npc_dota_hero_kez_2_mark:GetModifierMagicalResistanceBonus()
    return -self.magicres_t
end

function modifier_heroTalent_npc_dota_hero_kez_2_mark:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
    elseif self._tooltip == 2 then
        return self:GetModifierMagicalResistanceBonus()
    end
end