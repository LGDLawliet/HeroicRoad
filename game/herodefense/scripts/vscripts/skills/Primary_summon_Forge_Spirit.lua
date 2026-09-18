

Primary_summon_Forge_Spirit						= Primary_summon_Forge_Spirit or class({})



function Primary_summon_Forge_Spirit:IsSummonSpell()return true end
function Primary_summon_Forge_Spirit:IsElementSummon()return true end


function Primary_summon_Forge_Spirit:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient_spawn_bloom.vpcf", context )
	PrecacheResource( "model", "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl", context )
end





function Primary_summon_Forge_Spirit:OnSpellStart()

	
	local caster =self:GetCaster()

	
	-- 移除先前的召唤物
	-- for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
	-- 	for i = 1, 6 do	
	-- 		if unit:GetUnitName() == "npc_hd_normal_wolf" and unit:GetPlayerOwnerID() == player_id then
	-- 			unit:ForceKill(false)				
	-- 		end
	-- 	end
	-- end


	EmitSoundOn("Hero_Invoker.ColdSnap", self:GetCaster())	
	
	-- Add cast particles
	-- local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, self:GetCaster():GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(particle_cast_fx)




	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local summon_count = 2
	for i = 0,summon_count-1 do		
		local unit = caster:SummonUnit("npc_forge_spirit",life_duration,
		self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((summon_count- 1) / 2))),
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)
		
		-- Add spawn particles in spawn location
		local particle_summon = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient_spawn_bloom.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(particle_summon,0,unit:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle_summon)



		

	end	

end
