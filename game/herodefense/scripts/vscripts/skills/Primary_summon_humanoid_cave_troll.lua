

Primary_summon_humanoid_cave_troll						= Primary_summon_humanoid_cave_troll or class({})


function Primary_summon_humanoid_cave_troll:IsSummonSpell()return true end


function Primary_summon_humanoid_cave_troll:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_humanoid_cave_troll/effect_explosion.vpcf", context )
end

function Primary_summon_humanoid_cave_troll:OnSpellStart()

	
	local caster =self:GetCaster()




	EmitSoundOn("Hero_TrollWarlord.BattleTrance.Cast", self:GetCaster())	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	
	for i = 1, 1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((self:GetSpecialValueFor("wolves_count") - 1) / 2)))
		local unit = caster:SummonUnit("npc_hd_cave_troll",life_duration,
		pos,
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)

		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_humanoid_cave_troll/effect_explosion.vpcf", PATTACH_ABSORIGIN, unit)
		-- ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_cast_fx, 3, unit, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)



		

	end	

end
