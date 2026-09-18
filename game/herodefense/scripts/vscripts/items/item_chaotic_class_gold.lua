item_chaotic_class_gold = class({})

function item_chaotic_class_gold:OnSpellStart()
	if IsServer() then
        local gold = self:GetSpecialValueFor("gold")
		local num_1 = self:GetSpecialValueFor("num_1")
		local num_2 = self:GetSpecialValueFor("num_2")
		local caster = self:GetCaster()

		chaotic_era_spawner:PlayerGetGoldBounty(caster, gold, self)
        SendOverheadEventMessage(caster, OVERHEAD_ALERT_GOLD, caster, gold, nil)
		for i=1 ,num_1 do
			caster:AddItemByName("item_chaotic_skill_book_1")
		end
		for i=1 ,num_2 do
			caster:AddItemByName("item_chaotic_skill_book_2")
		end

        local particle_cast = "particles/econ/events/newbloom_2020/high_five_newbloom_golden.vpcf"
		local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( particle_cast_fx, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
		DestroyParticleByDelay(particle_cast_fx,1.5)

		self:SpendCharge(0)
	end
end