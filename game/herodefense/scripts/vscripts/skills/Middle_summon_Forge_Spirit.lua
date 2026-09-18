


Middle_summon_Forge_Spirit						= Middle_summon_Forge_Spirit or class({})



function Middle_summon_Forge_Spirit:IsSummonSpell()return true end
function Middle_summon_Forge_Spirit:IsElementSummon()return true end



function Middle_summon_Forge_Spirit:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient_spawn_bloom.vpcf", context )
	PrecacheResource( "model", "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl", context )
end





function Middle_summon_Forge_Spirit:OnSpellStart()
	local caster =self:GetCaster()
	EmitSoundOn("Hero_Invoker.ColdSnap", self:GetCaster())	
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local summon_count = 2
	for i = 0,summon_count-1 do		
		local unit = caster:SummonUnit("npc_forge_spirit",life_duration,
		self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((summon_count- 1) / 2))),
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)
		local particle_summon = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient_spawn_bloom.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(particle_summon,0,unit:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle_summon)

	end	

end




