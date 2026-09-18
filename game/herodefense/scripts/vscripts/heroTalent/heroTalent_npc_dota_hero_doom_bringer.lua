heroTalent_npc_dota_hero_doom_bringer = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_doom_bringer", "heroTalent/heroTalent_npc_dota_hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_doom_bringer_eatting", "heroTalent/heroTalent_npc_dota_hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_doom_bringer_burning", "heroTalent/heroTalent_npc_dota_hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_doom_bringer_already", "heroTalent/heroTalent_npc_dota_hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_doom_bringer:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )
end

function heroTalent_npc_dota_hero_doom_bringer:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_doom_bringer"
end

modifier_heroTalent_npc_dota_hero_doom_bringer = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_doom_bringer:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_doom_bringer:OnCreated(kv)
	self.ability = self:GetAbility()
    self.digest_duration = self.ability:GetSpecialValueFor("eat_duration") -- 消化时间
    self.all_stats = self.ability:GetSpecialValueFor("atb")         -- 消化完成获得的全属性
    self.stun_duration = 0.1  											-- 眩晕时间
	self.index = self.ability:GetSpecialValueFor("index")*0.01 
	self.base_damage = self.ability:GetSpecialValueFor("damage")  -- 阎刃基础伤害系数
	self.dot_damage = self.ability:GetSpecialValueFor("dot_damage")  -- 阎刃持续伤害系数
	self.burn_duration = self.ability:GetSpecialValueFor("duration")  -- 阎刃持续时间
	self:SetStackCount(0)

	self.talentgain = self.ability:GetTalentGain(1)
	self.base_damage_t = self.base_damage*self.talentgain  -- 精通阎刃基础伤害
	self.dot_damage_t = self.dot_damage*self.talentgain  -- 精通阎刃持续伤害
	self.burn_duration_t = self.burn_duration*self.talentgain  -- 精通阎刃持续时间

    if IsServer() then
		self.devoured_units = {}
    	self.digesting_units = {}
    	self:StartIntervalThink(1)
	end
end

function modifier_heroTalent_npc_dota_hero_doom_bringer:OnIntervalThink()
    if not IsServer() then return end
    local current_time = GameRules:GetGameTime()
    -- 检查消化中的单位
    for unit_name, digest_end_time in pairs(self.digesting_units) do
        if current_time >= digest_end_time then
            self.digesting_units[unit_name] = nil
            self.devoured_units[unit_name] = true
        end
    end
end
function modifier_heroTalent_npc_dota_hero_doom_bringer:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_doom_bringer:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(1)
	self.base_damage_t = self.base_damage*self.talentgain  -- 精通阎刃基础伤害
	self.dot_damage_t = self.dot_damage*self.talentgain  -- 精通阎刃持续伤害
	self.burn_duration_t = self.burn_duration*self.talentgain  -- 精通阎刃持续时间

    self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self.base_damage_t*(1+self.index*self:GetStackCount())
    elseif self._tooltip == 2 then
        return self.dot_damage_t*(1+self.index*self:GetStackCount())
    elseif self._tooltip == 3 then
        return self.burn_duration_t*(1+self.index*self:GetStackCount())
	elseif self._tooltip == 4 then
		return self:GetStackCount()
	end
end
function modifier_heroTalent_npc_dota_hero_doom_bringer:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
    }
end
function modifier_heroTalent_npc_dota_hero_doom_bringer:Advanced_GetModifierBonusStats_Strength(keys)
	return self.all_stats*self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_doom_bringer:Advanced_GetModifierBonusStats_Agility(keys)
	return self.all_stats*self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_doom_bringer:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.all_stats*self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_doom_bringer:OnDeath(keys)
    if not IsServer() then return end
    
    local attacker = keys.attacker
    local unit = keys.unit
    
    if attacker == self:GetParent() then
        local unit_name = unit:GetUnitName()
        if not self.devoured_units[unit_name] and not self.digesting_units[unit_name] then
            -- 开始消化新单位
            self.digesting_units[unit_name] = GameRules:GetGameTime() + self.digest_duration
			attacker:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_doom_bringer_eatting", {duration = self.digest_duration})
			-- 消化完成倒计时
			attacker:GameTimer(self.digest_duration,function ()
				if not attacker:IsAlive() then
					return 0.03
				end
				self:SetStackCount(self:GetStackCount()+1)
			end)
            
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(particle, 1, attacker:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
            unit:EmitSound("Hero_DoomBringer.Devour")
        end
    end
end

function modifier_heroTalent_npc_dota_hero_doom_bringer:OnAttackStart(keys)
    if not IsServer() then return end
    
    local attacker = keys.attacker
    local target = keys.target
    
    if attacker == self:GetParent() and target and self.devoured_units[target:GetUnitName()] then
        self.will_hellblade = true
	else
		self.will_hellblade = false
	end
end

function modifier_heroTalent_npc_dota_hero_doom_bringer:OnAttackLanded(keys)
    if not IsServer() then return end
    
    local attacker = keys.attacker
    local target = keys.target
    
    if attacker == self:GetParent() and self.will_hellblade and target and target:IsAlive() then
		local already = target:HasModifier("modifier_heroTalent_npc_dota_hero_doom_bringer_already")
		if already then return end
		
		--特效
		local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf"
		local sound_cast = "Hero_DoomBringer.InfernalBlade.Target"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOn( sound_cast, target)
		-- 眩晕效果
        target:AddNewModifier(attacker, self.ability, "modifier_stunned", {duration = self.stun_duration})
        self.will_hellblade = false
        

		self.talentgain = self.ability:GetTalentGain(1)
		self.base_damage_t = self.base_damage*self.talentgain  -- 精通阎刃基础伤害
		self.dot_damage_t = self.dot_damage*self.talentgain  -- 精通阎刃持续伤害
		self.burn_duration_t = self.burn_duration*self.talentgain  -- 精通阎刃持续时间

		-- 计算伤害
		local strength = attacker:GetStrength()
		local index = (1 + self:GetStackCount()*self.index)
        local damage = strength*self.base_damage_t*index
        -- 造成伤害和眩晕
        local damage_table = {
            victim = target,
            attacker = attacker,
            damage = damage,
            damage_type = self.ability:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
        }
        ApplyDamage(damage_table)
        if target:IsAlive() then
			target:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_doom_bringer_burning", {duration = self.burn_duration_t, index = index})
			target:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_doom_bringer_already", {})
		end
    end
end
-------------
modifier_heroTalent_npc_dota_hero_doom_bringer_eatting = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:OnCreated(kv)
	self.ability = self:GetAbility()
		
	self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")       -- 消化期间恢复
    self.bonus_armor = self.ability:GetSpecialValueFor("armor")       -- 消化期间护甲
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:ADDeclareFunctions()
    return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:Advanced_GetModifierPhysicalArmorBonusPercentage()
    return self.bonus_armor
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_eatting:AdvancedGetModifierConstantHealthRegenPercentage()
    return self.hp_regen
end
--------------
modifier_heroTalent_npc_dota_hero_doom_bringer_burning = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:GetEffectName()	return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf" end
function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:OnCreated(kv)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	local caster = self:GetCaster()
	self.talentgain = self.ability:GetTalentGain(1)
	self.dot_damage = self.ability:GetSpecialValueFor("dot_damage")
	self.dot_damage_t = self.dot_damage*self.talentgain
	if IsServer() then
		self.index = kv.index or 1
		-- 造成伤害
        self.damageTable = {
            victim = self.parent,
            attacker = caster,
            damage = caster:GetStrength()*self.dot_damage_t*self.index,
            damage_type = self.ability:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
        }
		ApplyDamage(self.damageTable)
		self:StartIntervalThink(1)
	end
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_burning:OnIntervalThink()
	if not self:GetAbility() then return end
	local caster = self:GetCaster()
	self.talentgain = self.ability:GetTalentGain(1)
	self.dot_damage_t = self.dot_damage*self.talentgain
	self.damageTable.damage = caster:GetStrength()*self.dot_damage_t*self.index
	ApplyDamage(self.damageTable)
end
-----------
modifier_heroTalent_npc_dota_hero_doom_bringer_already = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_doom_bringer_already:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_doom_bringer_already:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_already:IsPurgable() return false end