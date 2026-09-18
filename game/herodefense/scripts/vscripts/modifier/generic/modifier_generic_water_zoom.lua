
LinkLuaModifier( "modifier_generic_water_zoom_buff", "modifier/generic/modifier_generic_water_zoom", LUA_MODIFIER_MOTION_NONE )

modifier_generic_water_zoom = class({})
function modifier_generic_water_zoom:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/normal/puddle/effect.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
end
function modifier_generic_water_zoom:IsAura()return true end
function modifier_generic_water_zoom:OnCreated(keys)
	if IsServer() then
		self.radius			= keys.radius
        self.searchTeam = keys.team
		self.particle = ParticleManager:CreateParticle("particles/rebuild/normal/puddle/effect.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(self.radius, 1, 1)))
        

        local particle =  ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(particle, 1, (Vector(self.radius, 1, 1)))
        ParticleManager:ReleaseParticleIndex(particle)

	end
end


function modifier_generic_water_zoom:GetAuraRadius()return self.radius end
function modifier_generic_water_zoom:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_generic_water_zoom:GetAuraSearchTeam() return IsServer() and self.searchTeam end
function modifier_generic_water_zoom:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_generic_water_zoom:GetModifierAura()return "modifier_generic_water_zoom_buff" end


function modifier_generic_water_zoom:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
	end
end



modifier_generic_water_zoom_buff = modifier_generic_water_zoom_buff or class({})

function modifier_generic_water_zoom_buff:IsDebuff()return false end
function modifier_generic_water_zoom_buff:IsPurgable()return false end
function modifier_generic_water_zoom_buff:IsPurgeException() return false end
function modifier_generic_water_zoom_buff:GetTexture() return "naga_siren_rip_tide" end

