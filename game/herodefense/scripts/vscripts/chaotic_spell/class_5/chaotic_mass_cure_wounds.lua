
chaotic_mass_cure_wounds = class({})
function chaotic_mass_cure_wounds:Precache( context )
	-- PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_mass_cure_wounds/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_mass_cure_wounds/main/chaotic_mass_cure_wounds_main.vpcf", context )
end
function chaotic_mass_cure_wounds:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_mass_cure_wounds:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Dawnbreaker.Luminosity.Heal")  
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local heal =  self:GetSpecialValueFor("base_damage")+self:GetSpecialValueFor("bonus_damage") * caster:HDGetPrimaryStatValue()
	-- local count = self:GetSpecialValueFor("count")
	local gain = self:GetEffectGain()
	heal = heal * gain
	local rune_1_bonus =  self:GetSpecialValueFor("rune_1_bonus")*0.01
	for _, unit in ipairs(units) do
		-- if unit:IsRealHero() then
		-- 	self:PlayEffect(unit)
		-- end
		local current_health = unit:GetHealth()
		local fhealing =  HealWithGain(heal,caster,unit,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil) 
		if unit:IsRealHero() then
			self:PlayEffect(unit)
			if self:GetRuneType()==1 then
				local mana_regen = (unit:GetHealth()-current_health)*rune_1_bonus
				if mana_regen>0 then
					unit:GiveMana(mana_regen)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, unit, mana_regen, nil)
				end
			end
		end
	end





	
end


function chaotic_mass_cure_wounds:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_mass_cure_wounds/main/chaotic_mass_cure_wounds_main.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControl( effect_cast1, 0, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	-- target:EmitSound("chaotic_mass_cure_wounds_target")
end

