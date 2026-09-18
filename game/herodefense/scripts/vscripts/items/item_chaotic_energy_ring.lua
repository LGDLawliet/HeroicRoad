item_chaotic_energy_ring = class({})


function item_chaotic_energy_ring:Precache( context )
	PrecacheResource( "particle", "particles/items5_fx/essence_ring_burst.vpcf", context )
end

function item_chaotic_energy_ring:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.EssenceRing.Cast")
	self.particle = ParticleManager:CreateParticle("particles/items5_fx/essence_ring_burst.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)
	local heal = self:GetSpecialValueFor("heal")
    local fhealing =  HealWithGain(heal,caster,caster,self) --返回治疗的数值
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,caster, fhealing, nil) 
end




