
chaotic_chain_lightning = class({})
function chaotic_chain_lightning:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_chain_lightning/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", context )

end
function chaotic_chain_lightning:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



function chaotic_chain_lightning:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_lightning_bolt_cast")

	
	local damageTable = {
		attacker	= self:GetCaster(),
		victim = target,
		damage		= self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"),
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}


	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_chain_lightning/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( pfx, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(pfx)

	local gain = self:GetEffectGain()
	damageTable.damage = damageTable.damage * gain
	local pos = target:GetAbsOrigin()

	if target:HasModifier("modifier_hd_elecshocking") then
		damageTable.damage = damageTable.damage * (1+self:GetSpecialValueFor("index")*0.01)
	end
	ApplyDamage(damageTable)
	if not target:IsAlive() then
		damageTable.damage = damageTable.damage * (1+self:GetSpecialValueFor("bonus_damage_kill")*0.01)
	end

	local count = self:GetSpecialValueFor("count")
	caster:GameTimer(0.1, function()
		if IsValid(self) then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, unit in ipairs(enemies) do
				if unit~=target and IsValid(unit) and unit:IsAlive() then
					count = count - 1
					damageTable.victim = unit
					self:PlayEffect(target,unit)
					ApplyDamage(damageTable)
					if self:GetRuneType()==1 then
						local chance = self:GetSpecialValueFor("rune_1_chance")
						if caster:RollRandom(chance,1) then
							local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
							for _, new_target in ipairs(enemies) do
								if new_target~=target and new_target~=unit and IsValid(new_target) and new_target:IsAlive() then
									damageTable.victim = new_target
									self:PlayEffect(unit,new_target)
									ApplyDamage(damageTable)
									break
								end
							end
						end
						
					end
					if count<=0 then
						break
					end
				end
			end
		end
	end)



	
end


function chaotic_chain_lightning:PlayEffect(source,target)
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(head_particle, 1, source, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(head_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 5, 0))
	ParticleManager:ReleaseParticleIndex(head_particle)
	target:EmitSound("chaotic_chain_lightning_target")
end

