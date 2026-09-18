

Primary_summon_Slime						= Primary_summon_Slime or class({})




function Primary_summon_Slime:IsSummonSpell()return true end


function Primary_summon_Slime:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_slime/summon_slime.vpcf", context )


end

function Primary_summon_Slime:OnSpellStart()

	
	local caster =self:GetCaster()




	EmitSoundOn("Hero_Slardar.Slithereen_Crush", self:GetCaster())	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	
	for i = 1, 1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((self:GetSpecialValueFor("wolves_count") - 1) / 2)))
		local unit = caster:SummonUnit("npc_hd_Slime",life_duration,
		pos,
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)

		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_slime/summon_slime.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)



		

	end	

end
