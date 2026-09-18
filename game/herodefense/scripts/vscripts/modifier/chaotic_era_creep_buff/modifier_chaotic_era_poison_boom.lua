LinkLuaModifier("modifier_chaotic_era_poison_boom_debuff", "modifier/chaotic_era_creep_buff/modifier_chaotic_era_poison_boom", LUA_MODIFIER_MOTION_NONE)
modifier_chaotic_era_poison_boom = advanced_modifier({})

function modifier_chaotic_era_poison_boom:IsHidden()return false end
function modifier_chaotic_era_poison_boom:IsDebuff()return false end
function modifier_chaotic_era_poison_boom:IsPurgable()return false end
function modifier_chaotic_era_poison_boom:IsPurgeException() 	return false end
function modifier_chaotic_era_poison_boom:RemoveOnDeath() return true end
function modifier_chaotic_era_poison_boom:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_poison_boom:GetTexture() return self.texture end
function modifier_chaotic_era_poison_boom:DestroyOnExpire() return false end
    
function modifier_chaotic_era_poison_boom:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus1 = GetChaticEraCreep_BuffSpecial(self,"value1")
    self.bonus2 = GetChaticEraCreep_BuffSpecial(self,"value2")
    self.bonus3 = GetChaticEraCreep_BuffSpecial(self,"value3")

    if IsServer() then
        self:SetDuration(self.bonus1, true)
        self:StartIntervalThink(0.5)
    end
end

function modifier_chaotic_era_poison_boom:OnIntervalThink()
	if self:GetRemainingTime() < 0 then
		if self:GetParent():IsAlive() then
			self:GetParent():Kill(nil,nil)
		end
	end
end

function modifier_chaotic_era_poison_boom:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}

	return funcs
end

function modifier_chaotic_era_poison_boom:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit ~= self:GetParent() then
		return
	end
	local heroes = GetAllRealHeroes()

	if self:GetRemainingTime() >= 0 then
        return
	else
		for _, hero in pairs(heroes)do
			hero:AddNewModifier(self:GetParent(), nil, "modifier_chaotic_era_poison_boom_debuff", {stack = self.bonus2})
            hero:Poison(self:GetParent(),nil,self:GetParent():GetMaxHealth()*self.bonus3*0.01)
			self:PlayEffects()
		end
	end
end

function modifier_chaotic_era_poison_boom:PlayEffects()
	-- 特效
	if not IsServer() then return end
	
	local caster = self:GetParent()

	caster:EmitSound("Hero_Venomancer.PoisonNova")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(3000, 1, 3000))
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx3, 1, Vector(3000, 1, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_chaotic_era_poison_boom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_poison_boom:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.bonus1
	end
    if self._tooltip == 2 then
		return  self.bonus2
	end
    if self._tooltip == 1 then
		return  self.bonus3
	end
end



modifier_chaotic_era_poison_boom_debuff = advanced_modifier({})

function modifier_chaotic_era_poison_boom_debuff:IsHidden()return false end
function modifier_chaotic_era_poison_boom_debuff:IsDebuff()return true end
function modifier_chaotic_era_poison_boom_debuff:IsPurgable()return false end
function modifier_chaotic_era_poison_boom_debuff:IsPurgeException() 	return false end
function modifier_chaotic_era_poison_boom_debuff:RemoveOnDeath() return false end
function modifier_chaotic_era_poison_boom_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_poison_boom_debuff:GetTexture() return self.texture end
function modifier_chaotic_era_poison_boom_debuff:OnCreated(keys)
    if not IsServer() then return end
    self.value = keys.stack or 30
    self:SetStackCount(self:GetStackCount() + self.value)
end
function modifier_chaotic_era_poison_boom_debuff:OnRefresh(keys)
    if not IsServer() then return end
    self.value = keys.stack or 30
    self:SetStackCount(self:GetStackCount() + self.value)
end
function modifier_chaotic_era_poison_boom_debuff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_chaotic_era_poison_boom_debuff:Advanced_GetModifierBonusStats_Strength()
    return -self:GetStackCount()
end
function modifier_chaotic_era_poison_boom_debuff:Advanced_GetModifierBonusStats_Agility()
    return -self:GetStackCount()
end 
function modifier_chaotic_era_poison_boom_debuff:Advanced_GetModifierBonusStats_Intellect()
    return -self:GetStackCount()
end