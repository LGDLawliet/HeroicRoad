
LinkLuaModifier( "modifier_Middle_summons_undead_jack_the_ripper_buff", "skills/Middle_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summons_undead_jack_the_ripper_buff_attack", "skills/Middle_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
Middle_summons_undead_jack_the_ripper						= Middle_summons_undead_jack_the_ripper or class({})
-- require("internal/timers")

function Middle_summons_undead_jack_the_ripper:IsSummonSpell()return true end

function Middle_summons_undead_jack_the_ripper:OnSpellStart()

	
	local caster =self:GetCaster()


	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			unit:ForceKill(false)	
		end
	end
	

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local unit = caster:SummonUnit("npc_hd_jack_the_ripper",life_duration,
	unit_pos,
	self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	-- Add spawn particles in spawn location
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt(infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_LifeStealer.Consume")
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW,  unit)
    ParticleManager:ReleaseParticleIndex(infest_particle)
 

	unit:AddNewModifier(caster, self, "modifier_Middle_summons_undead_jack_the_ripper_buff", {})

	-- -- Add cast particles
	-- local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_soulchain_proc_rope.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- local pos = self:GetCaster():GetAbsOrigin()
	-- local pos2 = unit:GetAbsOrigin()
	-- pos.z = pos.z +64
	-- pos2.z = pos2.z +64
	
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, pos2)
	-- ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	-- caster:AddNewModifier(caster, self, "modifier_Middle_summons_undead_jack_the_ripper_debuff", 
	-- {duration = self:GetSpecialValueFor("debuff_duration"),str=str,agi=agi,int=int})
	table.insert(self.summon_table,unit)
end




modifier_Middle_summons_undead_jack_the_ripper_buff = class({})

function modifier_Middle_summons_undead_jack_the_ripper_buff:IsDebuff() return false end
function modifier_Middle_summons_undead_jack_the_ripper_buff:IsHidden() return true end
function modifier_Middle_summons_undead_jack_the_ripper_buff:IsPurgable() 		return false end
function modifier_Middle_summons_undead_jack_the_ripper_buff:IsPurgeException() 	return false end
function modifier_Middle_summons_undead_jack_the_ripper_buff:RemoveOnDeath()  return false end

function modifier_Middle_summons_undead_jack_the_ripper_buff:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,

	}
end


function modifier_Middle_summons_undead_jack_the_ripper_buff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if Attacker:PassivesDisabled() then
			return
		end
		if self:GetParent():GetHealthPercent()>=100 then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * 0.1*gain
		Attacker:Heal( flLifesteal, self:GetAbility() )
	end

	return 0.0

end



function modifier_Middle_summons_undead_jack_the_ripper_buff:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end

	local stack =100- keys.target:GetHealthPercent()
	keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_summons_undead_jack_the_ripper_buff_attack", {duration = 1,stack = stack})
end




modifier_Middle_summons_undead_jack_the_ripper_buff_attack = advanced_modifier({})

function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:IsHidden()	return true end
function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:IsDebuff()	return false end
function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:IsPurgable()	return false end

function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:Advanced_GetModifierAttackSpeedPercentage()	return self:GetStackCount() end
function modifier_Middle_summons_undead_jack_the_ripper_buff_attack:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end

