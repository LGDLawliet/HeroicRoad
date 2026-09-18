heroTalent_npc_dota_hero_pugna_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_pugna_3", "heroTalent/heroTalent_npc_dota_hero_pugna_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_pugna_3_draining", "heroTalent/heroTalent_npc_dota_hero_pugna_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_pugna_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_pugna_3"
end
function heroTalent_npc_dota_hero_pugna_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf", context )
end
function heroTalent_npc_dota_hero_pugna_3:LifeDrain(target)
    if not IsServer() then return end
    if not target then return end

	local caster = self:GetCaster()
	local target_ent = target:entindex()
	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_pugna_3_draining", {duration = 3600, target = target_ent})

	caster:EmitSound("Hero_Pugna.LifeDrain.Cast")
	target:EmitSound("Hero_Pugna.LifeDrain.Target")
	target:EmitSound("Hero_Pugna.LifeDrain.Loop")
end
-------
modifier_heroTalent_npc_dota_hero_pugna_3_draining = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_pugna_3_draining:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_pugna_3_draining:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_pugna_3_draining:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_pugna_3_draining:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_pugna_3_draining:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_pugna_3_draining:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.hpcut = self.ability:GetSpecialValueFor("hpcut")*0.01
    self.heal = self.ability:GetSpecialValueFor("heal")*0.01
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.talentgain = self.ability:GetTalentGain(0.75)
	self.hpcut_t = self.hpcut * self.talentgain
	self.heal_t = self.heal * self.talentgain

	if IsServer() then
		self:StartIntervalThink(1)
		self.time = 1
		self.target = EntIndexToHScript(keys.target)
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		local caster = self.caster
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_CENTER_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
	end
end

function modifier_heroTalent_npc_dota_hero_pugna_3_draining:OnIntervalThink()
	local caster = self:GetCaster()
    local ability = self:GetAbility()
	local target = self.target
    local dis = self.radius + 50

	if not target or target:IsNull() then self:SafeDestroy() return end
	if CalculateDistance(caster, target) > dis or not target:IsAlive() or target:IsOutOfGame() then self:SafeDestroy() return end

    self.talentgain = self.ability:GetTalentGain(0.75)
	self.hpcut_t = self.hpcut * self.talentgain
	self.heal_t = self.heal * self.talentgain
	local hpcut = math.max(self.hpcut_t*target:GetHealth(), caster:HDGetPrimaryStatValue()*0.7)
    local heal = self.heal_t*(caster:GetMaxHealth() - caster:GetHealth())
    target:ModifyHealth(target:GetHealth() - hpcut, ability, false, 0)
	if target:GetHealth() <= 1 then
		target:Kill(ability, caster)
	end
	HealWithGain(heal, caster,caster, ability)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal, nil) 
end

function modifier_heroTalent_npc_dota_hero_pugna_3_draining:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self.target = nil
		local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_pugna_3")
		if modifier then
			modifier:SetStackCount(math.max(0, modifier:GetStackCount() - 1))
		end
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
	end
end

--------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_pugna_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_pugna_3:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_pugna_3:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_pugna_3:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_pugna_3:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_pugna_3:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.str_spell = self.ability:GetSpecialValueFor("str_spell")
    self.count = self.ability:GetSpecialValueFor("count")
    self.hpcut = self.ability:GetSpecialValueFor("hpcut")*0.01
    self.heal = self.ability:GetSpecialValueFor("heal")*0.01
    self.talentgain = self.ability:GetTalentGain(0.75)
	self.hpcut_t = self.hpcut * self.talentgain
	self.heal_t = self.heal * self.talentgain

    self:SetStackCount(0)
	if IsServer() then
        self:StartIntervalThink(0.2)
	end
end
function modifier_heroTalent_npc_dota_hero_pugna_3:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_pugna_3:Advanced_GetModifierSpellAmplifyBonus()
    return self.str_spell*self.parent:GetStrength()
end
function modifier_heroTalent_npc_dota_hero_pugna_3:OnIntervalThink()
	if not self.parent:IsAlive() then return end
	if not self.ability:IsCooldownReady() then return end
	
	local caster = self.parent
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

	-- 获取当前已连接的目标
	local connectedTargets = {}
	local currentConnections = 0
	local modifiers = caster:FindAllModifiersByName("modifier_heroTalent_npc_dota_hero_pugna_3_draining")
	for _, mod in ipairs(modifiers) do
		if mod.target and not mod.target:IsNull() then
			connectedTargets[mod.target] = true
			currentConnections = currentConnections + 1
		end
	end

	-- 如果已连接数达到上限，则不再连接新目标
	if currentConnections >= self.count then return end

	-- 找出生命值最高的可用敌人
	local target = nil
	local maxHealth = 0
	for _, enemy in ipairs(enemies) do
		if enemy:IsAlive() and not enemy:IsOutOfGame() and not connectedTargets[enemy] then
			local health = enemy:GetHealth()
			if health > maxHealth then
				maxHealth = health
				target = enemy
			end
		end
	end

	-- 如果找到目标，执行生命吸取并进入冷却
	if target then
		self.ability:LifeDrain(target)
		self:SetStackCount(currentConnections + 1)
		self.ability:UseResources(true, true, true, true)
	end
end
function modifier_heroTalent_npc_dota_hero_pugna_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_pugna_3:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.75)
	self.hpcut_t = self.hpcut * self.talentgain
	self.heal_t = self.heal * self.talentgain
	
	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.hpcut_t*100
    end
    if self._tooltip == 2 then
        return self.heal_t*100
    end
    if self._tooltip == 3 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
    end
end