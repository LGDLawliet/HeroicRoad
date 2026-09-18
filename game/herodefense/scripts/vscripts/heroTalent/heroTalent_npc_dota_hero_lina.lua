LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lina", "heroTalent/heroTalent_npc_dota_hero_lina.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lina_fiery_soul", "heroTalent/heroTalent_npc_dota_hero_lina.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lina_overheat", "heroTalent/heroTalent_npc_dota_hero_lina.lua", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_lina = class({})

function heroTalent_npc_dota_hero_lina:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_lina"
end

function heroTalent_npc_dota_hero_lina:Precache(context)
    PrecacheResource("particle", "particles/rebuild/spell/lina_ambient/lina_fiery_soul_c.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", context)
end

-- 主被动管理modifier
modifier_heroTalent_npc_dota_hero_lina = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_lina:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_lina:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lina:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_lina:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_lina:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.stack_max = self.ability:GetSpecialValueFor("stack_max")
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.level = self.ability:GetSpecialValueFor("level")
	self.duration_2 = self.ability:GetSpecialValueFor("duration_2")
	self.speed = self.ability:GetSpecialValueFor("speed")
	self.spell = self.ability:GetSpecialValueFor("spell")
	self.burning = self.ability:GetSpecialValueFor("burning")

	self.talentgain_1 = self.ability:GetTalentGain(0.8)
	self.talentgain_2 = self.ability:GetTalentGain(1.2)
	self.speed_t = self.speed*self.talentgain_1
	self.spell_t = self.spell*self.talentgain_1
	self.burning_t = self.burning*self.talentgain_2
	self.duration_2_t = self.duration_2*self.talentgain_1
end

function modifier_heroTalent_npc_dota_hero_lina:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_lina:OnTooltip(keys)
	self.talentgain_1 = self.ability:GetTalentGain(0.8)
	self.talentgain_2 = self.ability:GetTalentGain(1.2)
	self.speed_t = self.speed*self.talentgain_1
	self.spell_t = self.spell*self.talentgain_1
	self.burning_t = self.burning*self.talentgain_2
	self.duration_2_t = self.duration_2*self.talentgain_1

	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self.speed_t
	end
	if self._tooltip == 2 then
		return  self.spell_t
	end
	if self._tooltip == 3 then
		return  self.burning_t*self.parent:GetLevel()
	end
	if self._tooltip == 4 then
		return self.duration_2_t
	end
end

function modifier_heroTalent_npc_dota_hero_lina:OnAbilityFullyCast(keys)
    if not IsServer() then return end
	local unit = keys.unit
	local ability_cast = keys.ability

    if unit ~= self.parent then return end
    if ability_cast:IsItem() or ability_cast:IsToggle() then return end
    if ability_cast:GetCooldown(ability_cast:GetLevel()) < self.cd then return end
    if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_lina_overheat") then return end

	self.talentgain_1 = self.ability:GetTalentGain(0.8)
	self.talentgain_2 = self.ability:GetTalentGain(1.2)
	self.speed_t = self.speed*self.talentgain_1
	self.spell_t = self.spell*self.talentgain_1
	self.burning_t = self.burning*self.talentgain_2
	self.duration_2_t = self.duration_2*self.talentgain_1

	local bonus_stack = 1
	if self.parent:GetLevel() >= self.level then
		if self.chance >= math.random(1,100) then
			bonus_stack = bonus_stack + 1
		end
	end

    local buff = self.parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_lina_fiery_soul")
    if not buff then
        buff = self.parent:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_lina_fiery_soul", {
			duration = self.duration, 
			speed = self.speed_t, 
			spell = self.spell_t
			})
	else
		buff:SetStackCount(math.min(buff:GetStackCount() + bonus_stack, self.stack_max))
		buff:ForceRefresh()
		buff:SetDuration(self.duration, true)
	end

	-- 过热
    if buff:GetStackCount() >= self.stack_max then
		buff:SetStackCount(0)
		buff:Destroy()
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_lina_overheat", {
			duration = self.duration_2_t,
			burning = self.burning_t*self.parent:GetLevel(), 
			speed = self.speed_t*self.stack_max, 
			spell = self.spell_t*self.stack_max
			})
    end
end

-- 炽魂buff
modifier_heroTalent_npc_dota_hero_lina_fiery_soul = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    if IsServer() then
        if keys then
            self.speed = keys.speed or self.speed
            self.spell = keys.spell or self.spell
        end
        if not self.effect then
            self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControl(self.effect, 1, Vector(self:GetStackCount(), 0, 0))
            self:AddParticle(self.effect, false, false, -1, false, false)
        else
            ParticleManager:SetParticleControl(self.effect, 1, Vector(self:GetStackCount(), 0, 0))
        end
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:OnRefresh(keys)
    if IsServer() and keys then
        self.speed = keys.speed or self.speed
        self.spell = keys.spell or self.spell
    end
    if IsServer() then
        if self.effect then
            ParticleManager:SetParticleControl(self.effect, 1, Vector(self:GetStackCount(), 0, 0))
        end
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:OnDestroy()
    if IsServer() then
        if self.effect then
			ParticleManager:DestroyParticle(self.effect, false)
		end
    end
end

function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:Advanced_GetModifierAttackSpeedPercentage()
    return self:GetStackCount() * self.speed
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:GetModifierMoveSpeedBonus_Percentage()
    return self:GetStackCount() * self.speed
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:Advanced_GetModifierSpellAmplifyBonus()
    return self:GetStackCount() * self.spell
end

function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.speed*self:GetStackCount()
	end
	if self._tooltip == 2 then
		return  self.spell*self:GetStackCount()
	end
end
function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:AddCustomTransmitterData( )
	return
	{
		speed = self.speed,
		spell = self.spell,
	}
end

function modifier_heroTalent_npc_dota_hero_lina_fiery_soul:HandleCustomTransmitterData( data )
	self.speed = data.speed
	self.spell = data.spell
end



-- 过热状态
modifier_heroTalent_npc_dota_hero_lina_overheat = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_lina_overheat:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_lina_overheat:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lina_overheat:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_lina_overheat:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_lina_overheat:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    if IsServer() then
        if keys then
            self.speed = keys.speed or self.speed
            self.spell = keys.spell or self.spell
            self.burning = keys.burning or self.burning
        end
        -- 明显的火焰特效
        self.effect = ParticleManager:CreateParticle("particles/rebuild/spell/lina_ambient/lina_fiery_soul_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        self:AddParticle(self.effect, false, false, -1, false, false)
        self:SetHasCustomTransmitterData( true )-- 同步cy
		self.parent:EmitSound("CNY_Beast.HandOfGodHealHero")
    end
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:OnRefresh(keys)
    if IsServer() and keys then
        self.speed = keys.speed or self.speed
        self.spell = keys.spell or self.spell
        self.burning = keys.burning or self.burning

        if self.effect then
            ParticleManager:SetParticleControl(self.effect, 1, Vector(0, 0, 0))
        end
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:OnDestroy()
    if IsServer() then
        if self.effect then
			ParticleManager:DestroyParticle(self.effect, false)
		end
    end
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
    }
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:Advanced_GetModifierAttackSpeedPercentage()
    return self.speed
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:GetModifierMoveSpeedBonus_Percentage()
    return self.speed
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell
end

function modifier_heroTalent_npc_dota_hero_lina_overheat:OnAttackLanded(keys)
    if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

    if attacker ~= self.parent then return end
    if not target or not target:IsAlive() then return end

    local burning = self.parent:HDGetPrimaryStatValue()*self.burning
    target:Burning(self.parent, self.ability, burning)
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.speed
	end
	if self._tooltip == 2 then
		return  self.spell
	end
	if self._tooltip == 3 then
		return  self.burning
	end
end
function modifier_heroTalent_npc_dota_hero_lina_overheat:AddCustomTransmitterData( )
	return
	{
		speed = self.speed,
		spell = self.spell,
		burning = self.burning,
	}
end

function modifier_heroTalent_npc_dota_hero_lina_overheat:HandleCustomTransmitterData( data )
	self.speed = data.speed
	self.spell = data.spell
	self.burning = data.burning
end