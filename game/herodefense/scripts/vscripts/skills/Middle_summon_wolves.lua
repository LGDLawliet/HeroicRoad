
LinkLuaModifier( "modifier_Middle_summon_wolves", "skills/Middle_summon_wolves", LUA_MODIFIER_MOTION_NONE )


Middle_summon_wolves						= Middle_summon_wolves or class({})

function Middle_summon_wolves:IsSummonSpell()return true end

function Middle_summon_wolves:OnSpellStart()

	
	local caster =self:GetCaster()

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

		unit:AddNewModifier(caster, self, "modifier_Middle_summon_wolves", {})

	end	
end





modifier_Middle_summon_wolves= class({})

function modifier_Middle_summon_wolves:IsDebuff()			return false end
function modifier_Middle_summon_wolves:IsHidden() 			return true end
function modifier_Middle_summon_wolves:IsPurgable() 		return false end
function modifier_Middle_summon_wolves:IsPurgeException() 	return false end
function modifier_Middle_summon_wolves:DeclareFunctions() return 
	{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
} end




function modifier_Middle_summon_wolves:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit



		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		local Ability = params.inflictor
		local flDamage = params.damage
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		-- if self:GetParent():PassivesDisabled() then
		-- 	return
		-- end
		local unit_list = self:GetAbility().summon_table
		local flLifesteal = flDamage * 0.15
		if flLifesteal<=0 then
			return
		end
		for key, unit in pairs(unit_list) do
			--不为自己治疗
			if IsValidEntity(unit) and unit:IsAlive() and unit:GetHealthPercent()<100 and  unit~=Attacker then
				local healing = HealWithGain(flLifesteal,caster,unit,self:GetAbility())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

			end
			
		end


	end

	return 0.0

end

