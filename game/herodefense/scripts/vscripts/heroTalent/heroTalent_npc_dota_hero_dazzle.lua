heroTalent_npc_dota_hero_dazzle = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_dazzle", "heroTalent/heroTalent_npc_dota_hero_dazzle", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_dazzle:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_dazzle" end
function heroTalent_npc_dota_hero_dazzle:GetManaCost(iLevel)
	local caster = self:GetCaster()
	local mana_cost = self.BaseClass.GetManaCost(self,iLevel) + self:GetSpecialValueFor("mana_cost")*0.01*caster:GetMaxMana()
	return mana_cost
end
function heroTalent_npc_dota_hero_dazzle:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_inverse.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf", context )
end
function heroTalent_npc_dota_hero_dazzle:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_dazzle")
	if IsValid(modifier) then
		modifier:ForceRefresh()
	end
end
modifier_heroTalent_npc_dota_hero_dazzle = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dazzle:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_dazzle:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_dazzle:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_dazzle:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dazzle:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dazzle:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_nothl_voyage_soul.vpcf" end
function modifier_heroTalent_npc_dota_hero_dazzle:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_dazzle:OnCreated(table)
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonuce_radius = self.ability:GetSpecialValueFor("bounce_radius")
	self.damage_radius = self.ability:GetSpecialValueFor("damage_radius")
	self.mana_cost = self.ability:GetSpecialValueFor("mana_cost")*0.01

	self.talentgain1 = self.ability:GetTalentGain(0.6)
	self.talentgain2 = self.ability:GetTalentGain(1)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.damage_t = self.damage*self.talentgain2
end
function modifier_heroTalent_npc_dota_hero_dazzle:OnRefresh(table)
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonuce_radius = self.ability:GetSpecialValueFor("bounce_radius")
	self.damage_radius = self.ability:GetSpecialValueFor("damage_radius")
	self.mana_cost = self.ability:GetSpecialValueFor("mana_cost")*0.01

	self.talentgain1 = self.ability:GetTalentGain(0.6)
	self.talentgain2 = self.ability:GetTalentGain(1)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.damage_t = self.damage*self.talentgain2
end
function modifier_heroTalent_npc_dota_hero_dazzle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_dazzle:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if keys.damage_category == "DOTA_DAMAGE_CATEGORY_SPELL" then
		self.talentgain1 = self.ability:GetTalentGain(0.6)
		self.outgoing_t = self.outgoing*self.talentgain1

		return self.outgoing_t
	end
end
function modifier_heroTalent_npc_dota_hero_dazzle:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end

function modifier_heroTalent_npc_dota_hero_dazzle:OnTooltip()
	self.talentgain1 = self.ability:GetTalentGain(0.6)
	self.talentgain2 = self.ability:GetTalentGain(1)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.damage_t = self.damage*self.talentgain2

    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.outgoing_t
    elseif self._tooltip == 2 then
        return self.damage_t
	end
end

function modifier_heroTalent_npc_dota_hero_dazzle:OnAttackLanded(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if not target or not target:IsAlive() then return end
	if attacker:IsInSpecialAttack() or not self.ability:GetAutoCastState() then return end

	local mana_need = self.ability:GetManaCost(1)
	if attacker:GetMana() < mana_need or not self.ability:IsCooldownReady() then return end

	local keys = {
		caster = attacker,
		target = target,
	}
	self:Shadow_Wave(keys)
	self.ability:UseResources(true, true, true, true)
end

function modifier_heroTalent_npc_dota_hero_dazzle:Shadow_Wave(keys)
	if not IsServer() then return end
	local caster = keys.caster	
	local target = keys.target

	self.talentgain1 = self.ability:GetTalentGain(0.6)
	self.talentgain2 = self.ability:GetTalentGain(1)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.damage_t = self.damage*self.talentgain2
	local units = {}
	local radius = self.bonuce_radius
	local damage = caster:HDGetPrimaryStatValue()*self.damage_t
	units[#units + 1] = target
	local max_target = 1
	for _, aunit in pairs(units) do
		local units1 = FindUnitsInRadius(caster:GetTeamNumber(), aunit:GetAbsOrigin(), nil, radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit1 in pairs(units1) do
			local no_yet = true
			for _, unit in pairs(units) do
				if unit == unit1 or unit1 == caster then  --判断取出的单位是否是施法者或已存在于列表中
					no_yet = false                        --如果是 则纪录
					break
				end
			end
			if no_yet then
				units[#units + 1] = unit1
				break
			end
			if #units > max_target then
				break
			end
		end
	end

	table.insert(units, 1, caster)



	for k, unit in pairs(units) do
		local i = (k == #units) and k or (k + 1)
		if unit ~= caster then
			local damageTable = {
				victim = unit,
				attacker = caster,
				damage = damage,
				damage_type = self.ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				ability = self.ability,
				}
			ApplyDamage(damageTable)

			local allies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.damage_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)			
			for _, ally in pairs(allies) do
				local health = damage*0.33
				local healing = HealWithGain(health, caster,ally,self.ability)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, healing, nil)
				self:PlayEffect_Target(ally)
			end
		end
		self:PlayEffect(unit,units[i])
	end
end

function modifier_heroTalent_npc_dota_hero_dazzle:PlayEffect(target, source)
	if not IsServer() then return end
    if not target then
		target = source
	end
    local caster = self:GetCaster()
    local particle = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_inverse.vpcf" 
    local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
	if target == caster then
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	else
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end
	ParticleManager:SetParticleControlEnt(pfx, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
    EmitSoundOnLocationWithCaster(source:GetAbsOrigin(), "Hero_Dazzle.Shadow_Wave", source)
end

function modifier_heroTalent_npc_dota_hero_dazzle:PlayEffect_Target(target) 
    if not IsServer() then return end
    local particle = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetOrigin(),true)
	ParticleManager:ReleaseParticleIndex(effect_cast)
    target:EmitSound("Hero_Dazzle.BadJuJu.Target")
end
