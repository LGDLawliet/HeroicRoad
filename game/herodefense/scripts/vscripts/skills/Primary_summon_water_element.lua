
-- LinkLuaModifier( "modifier_Primary_summon_water_element_debuff", "skills/Primary_summon_water_element", LUA_MODIFIER_MOTION_NONE )
Primary_summon_water_element						= Primary_summon_water_element or class({})
require("internal/timers")
function Primary_summon_water_element:IsSummonSpell()return true end
function Primary_summon_water_element:IsElementSummon()return true end

function Primary_summon_water_element:OnSpellStart()

	
	local caster =self:GetCaster()


	
	



	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 



	-- Add spawn particles in spawn location
	EmitSoundOn("Hero_Morphling.Waveform", caster)	
	local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
	for i = 1, 10, 1 do
		local pos =  unit_pos  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
		local new_pos = unit_pos+(pos-unit_pos):Normalized()*300
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, new_pos)
		ParticleManager:SetParticleControl(pfx, 1, (unit_pos - new_pos):Normalized() * 300)
		Timers(1.3, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex( pfx )
		end)	

	end

	local ability = self
	Timers(1.0, function()
		if not ability or ability:IsNull() then
			return
		end
		local unit = caster:SummonUnit("npc_hd_water_element",life_duration,
		unit_pos,
		self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
	end)


	-- -- Add cast particles
	-- local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_soulchain_proc_rope.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- local pos = self:GetCaster():GetAbsOrigin()
	-- local pos2 = unit:GetAbsOrigin()
	-- pos.z = pos.z +64
	-- pos2.z = pos2.z +64
	
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 1, pos2)
	-- ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	-- caster:AddNewModifier(caster, self, "modifier_Primary_summon_water_element_debuff", 
	-- {duration = self:GetSpecialValueFor("debuff_duration"),str=str,agi=agi,int=int})

end



