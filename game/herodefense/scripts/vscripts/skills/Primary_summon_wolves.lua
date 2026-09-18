

Primary_summon_wolves						= Primary_summon_wolves or class({})

function Primary_summon_wolves:IsSummonSpell()return true end

function Primary_summon_wolves:OnSpellStart()

	
	local caster =self:GetCaster()

	
	-- 移除先前的召唤物
	-- for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
	-- 	for i = 1, 6 do	
	-- 		if unit:GetUnitName() == "npc_hd_normal_wolf" and unit:GetPlayerOwnerID() == player_id then
	-- 			unit:ForceKill(false)				
	-- 		end
	-- 	end
	-- end
	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			unit:ForceKill(false)	
		end
	end
	

	EmitSoundOn("Hero_Lycan.SummonWolves", self:GetCaster())	
	
	-- Add cast particles
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_cast_fx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	
	local wolves_spawn_particle = nil
	self.summon_table = {}  --储存召唤物 用于在重复召唤时候移除它们



	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local summon_count = self:GetSpecialValueFor("wolves_count")
	if caster:HasAbility("heroTalent_npc_dota_hero_lycan_2") then 
		summon_count = summon_count + 2
	end
	local start_left = -120 * (summon_count*0.5)
	
	for i = 0, summon_count - 1 do		
		local unit = caster:SummonUnit("npc_hd_normal_wolf",life_duration,
		self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * (start_left+120 * i)),
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)


		table.insert(self.summon_table,unit)
		
		-- Add spawn particles in spawn location
		wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)



		

	end	

end
