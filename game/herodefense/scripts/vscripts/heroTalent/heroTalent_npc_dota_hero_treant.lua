heroTalent_npc_dota_hero_treant = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant", "heroTalent/heroTalent_npc_dota_hero_treant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_buff", "heroTalent/heroTalent_npc_dota_hero_treant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_cd", "heroTalent/heroTalent_npc_dota_hero_treant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_treant_debuff", "heroTalent/heroTalent_npc_dota_hero_treant", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_treant:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_treant"
end



modifier_heroTalent_npc_dota_hero_treant = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_treant:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_treant:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_treant:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_treant:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_treant:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_heroTalent_npc_dota_hero_treant:OnCreated(keys)
	self.ability = self:GetAbility()
	self.line = self.ability:GetSpecialValueFor("line")
	self.cd = self.ability:GetSpecialValueFor("cd")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.root = self.ability:GetSpecialValueFor("root")
	self.duration = self.ability:GetSpecialValueFor("duration")
	

	self.talentgain_cd = self.ability:GetTalentGain(0.4)
	self.talentgain_effect = self.ability:GetTalentGain(0.8)
	self.cd_t = math.max(self.cd/self.talentgain_cd, 10)
	self.root_t = self.root*self.talentgain_effect
	self.duration_t = self.duration*self.talentgain_effect
end

function modifier_heroTalent_npc_dota_hero_treant:DeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_treant:OnTakeDamage(keys)
	if not IsServer() then return end
	
	local unit = keys.unit
	local caster = self:GetCaster()
	if not unit:IsHero() then return end
	if IsEnemy(caster, unit) then return end
	if unit:GetHealthPercent() > self.line then return end
	local cd = unit:HasModifier("modifier_heroTalent_npc_dota_hero_treant_cd")
	if cd then return end

	self.talentgain_cd = self.ability:GetTalentGain(0.4)
	self.talentgain_effect = self.ability:GetTalentGain(0.8)
	self.cd_t = math.max(self.cd/self.talentgain_cd, 10)
	self.root_t = self.root*self.talentgain_effect
	self.duration_t = self.duration*self.talentgain_effect

	if not unit:IsAlive() or unit:GetHealth() <= 0 then
		unit:SetHealth(1)
	end

	self:TreeArmor(unit)
	self:CrazyGrow(unit)
	unit:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_treant_cd", {duration = self.cd_t})
end

function modifier_heroTalent_npc_dota_hero_treant:TreeArmor(target)
	if not IsServer() then return end
	if not target then return end
	local caster = self:GetCaster()
	
	target:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_treant_buff", {duration = self.duration_t})
end

function modifier_heroTalent_npc_dota_hero_treant:CrazyGrow(target)
	if not IsServer() then return end
	if not target then return end
	local caster = self:GetCaster()
	
    local cast_particle = ParticleManager:CreateParticle("particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(cast_particle, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(cast_particle)
    target:EmitSound("Hero_Treant.Overgrowth.Cast")

    local enemies = FindUnitsInRadius(
        target:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster,self.ability,"modifier_heroTalent_npc_dota_hero_treant_debuff",{duration = self.root_t})
    end
end

function modifier_heroTalent_npc_dota_hero_treant:OnTooltip(keys)
	self.talentgain_cd = self.ability:GetTalentGain(0.4)
	self.talentgain_effect = self.ability:GetTalentGain(0.8)
	self.cd_t = math.max(self.cd/self.talentgain_cd, 10)
	self.root_t = self.root*self.talentgain_effect
	self.duration_t = self.duration*self.talentgain_effect

	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.cd_t
	end
	if self._tooltip == 2 then
		return  self.root_t
	end
	if self._tooltip == 3 then
		return  self.duration_t
	end
end

---
modifier_heroTalent_npc_dota_hero_treant_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_treant_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_treant_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_treant_buff:GetEffectName() return "particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor.vpcf" end
function modifier_heroTalent_npc_dota_hero_treant_buff:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_heroTalent_npc_dota_hero_treant_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.hpregen = self.ability:GetSpecialValueFor("hpregen")
end

function modifier_heroTalent_npc_dota_hero_treant_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_heroTalent_npc_dota_hero_treant_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self.incoming
end

function modifier_heroTalent_npc_dota_hero_treant_buff:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.hpregen
end

---
modifier_heroTalent_npc_dota_hero_treant_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_treant_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_treant_debuff:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_treant_debuff:CheckState()
	return{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
---
modifier_heroTalent_npc_dota_hero_treant_cd = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_treant_cd:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_treant_cd:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_treant_cd:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_treant_cd:IsPurgeException() return false end
