
modifier_chaotic_era_sea_attack = advanced_modifier({})

function modifier_chaotic_era_sea_attack:IsHidden()return false end
function modifier_chaotic_era_sea_attack:IsDebuff()return false end
function modifier_chaotic_era_sea_attack:IsPurgable()return false end
function modifier_chaotic_era_sea_attack:IsPurgeException() 	return false end
function modifier_chaotic_era_sea_attack:RemoveOnDeath() return true end
function modifier_chaotic_era_sea_attack:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_sea_attack:GetTexture() return self.texture end
function modifier_chaotic_era_sea_attack:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
end
function modifier_chaotic_era_sea_attack:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.no_armor = GetChaticEraCreep_BuffSpecial(self,"value1")
    self.line = GetChaticEraCreep_BuffSpecial(self,"value2")
	self.duration = GetChaticEraCreep_BuffSpecial(self,"value3")
end

function modifier_chaotic_era_sea_attack:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
        advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
	}
	return funcs
end

function modifier_chaotic_era_sea_attack:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	if keys.target:GetPhysicalArmorValue(false) >= self.line then return end

    local particle_cast_fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", PATTACH_ABSORIGIN, keys.target)
	ParticleManager:SetParticleControl(particle_cast_fx2, 0, keys.target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx2)
    keys.target:AddNewModifier(keys.attacker, nil, "modifier_stunned", {duration = self.duration})
end
function modifier_chaotic_era_sea_attack:Advanced_GetModifierAttackArmor_Ignore()
    return self.no_armor
end

function modifier_chaotic_era_sea_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_sea_attack:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.no_armor
	elseif self._tooltip == 2 then
		return  self.line
    elseif self._tooltip == 3 then
		return  self.duration
	end
end

