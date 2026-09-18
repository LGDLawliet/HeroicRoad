item_chaotic_arcane_ring = class({})


function item_chaotic_arcane_ring:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", context )
end

function item_chaotic_arcane_ring:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.ArcaneRing.Cast")
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)
	local mana = self:GetSpecialValueFor("mana")
    caster:GiveMana(mana)
    
end




