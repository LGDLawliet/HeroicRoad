item_chaotic_class_gold_later = class({})

function item_chaotic_class_gold_later:OnSpellStart()
	if IsServer() then
        local gold = self:GetSpecialValueFor("gold")
		local caster = self:GetCaster()

		chaotic_era_spawner:PlayerGetGoldBounty(caster, gold, self)
        SendOverheadEventMessage(caster, OVERHEAD_ALERT_GOLD, caster, gold, nil)

        local particle_cast = "particles/econ/events/newbloom_2020/high_five_newbloom_golden.vpcf"
		local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( particle_cast_fx, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
		DestroyParticleByDelay(particle_cast_fx,1.5)

		self:SpendCharge(0)
	end
end