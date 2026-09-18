LinkLuaModifier("modifier_chaotic_nether_swap", "chaotic_spell/class_4/chaotic_nether_swap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_nether_swap_debuff", "chaotic_spell/class_4/chaotic_nether_swap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)




chaotic_nether_swap = class({})
function chaotic_nether_swap:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_nether_swap/chaotic_nether_swap_3.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_nether_swap/debuff_effect/ghosts_ambient.vpcf", context )

end
function chaotic_nether_swap:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_nether_swap:OnSpellStart()

	if not IsServer() then
		return
	end

	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = caster:GetAbsOrigin()

	local pos = target:GetAbsOrigin()

	target:AddNewModifier(nil, nil, "modifier_chaotic_nether_swap_debuff", {})

	local eff_length = Vector(0,0,0)

	local eff_radius = Vector(self:GetAOERadius(),self:GetAOERadius() * 0.6,0)

	local eff_number = 0
	
	local duration = self:GetSpecialValueFor("duration")
				
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    local particle_cast = "particles/rebuild/chaotic_spell/chaotic_nether_swap/chaotic_nether_swap_3_electrichits_2.vpcf"

    caster:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Cast")

	for i = 0 , 0.4 , 0.01 do

		caster:GameTimer(i,function()

			if not IsValid(self) then
				return
			end

			eff_length.x = eff_length.x + 10

			local particle_cast = "particles/rebuild/chaotic_spell/chaotic_nether_swap/chaotic_nether_swap_3.vpcf"

			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( effect_cast, 0, point)
			ParticleManager:SetParticleControl( effect_cast, 1, pos)
			ParticleManager:SetParticleControl( effect_cast, 2, Vector(0,0,0))
			ParticleManager:SetParticleControl( effect_cast, 3, eff_length)
			ParticleManager:SetParticleControl( effect_cast, 4, Vector(0,0,0))
			DestroyParticleByDelay(effect_cast,0.1)

			eff_number = eff_number + 0.01

			if eff_number >= 0.4 then

				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( effect_cast, 0, point)
				ParticleManager:SetParticleControl( effect_cast, 1, pos)
				ParticleManager:SetParticleControl( effect_cast, 2, eff_radius)
				ParticleManager:SetParticleControl( effect_cast, 3, eff_length)
				ParticleManager:SetParticleControl( effect_cast, 4, Vector(500,0,0))
				DestroyParticleByDelay(effect_cast,0.5)

				eff_number = 0

				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, eff_radius.x, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

				caster:EmitSound("Hero_Dawnbreaker.Luminosity.PowerUp")

				for i = 0 , 1 , 0.2 do
	
					caster:GameTimer(i,function()

						if not IsValid(self) then
							return
						end
			
						eff_radius.x = eff_radius.x - ( self:GetAOERadius() - 100 ) / 5

						eff_radius.y = eff_radius.y - ( self:GetAOERadius() * 0.6 - 70 ) / 5

						eff_number = eff_number + 0.2

						local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl( effect_cast, 0, point)
						ParticleManager:SetParticleControl( effect_cast, 1, pos)
						ParticleManager:SetParticleControl( effect_cast, 2, eff_radius)
						ParticleManager:SetParticleControl( effect_cast, 3, eff_length)
						ParticleManager:SetParticleControl( effect_cast, 4, Vector(500,0,0))
						DestroyParticleByDelay(effect_cast,0.4)

						for a=1, #enemies do
							
							if (enemies[a]:GetAbsOrigin() - pos):Length2D() >= eff_radius.x then

								enemies[a]:SetAbsOrigin(pos)
		
								enemies[a]:AddNewModifier(nil, nil, "modifier_chaotic_nether_swap_debuff", {})

							end

						end

						enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, eff_radius.x, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

						if eff_number > 1 then

							for a=1, #enemies do
							
								if (enemies[a]:GetAbsOrigin() - pos):Length2D() <= eff_radius.x and not enemies[a]:HasModifier("modifier_chaotic_nether_swap_debuff") then
	
									enemies[a]:SetAbsOrigin(pos)
			
									enemies[a]:AddNewModifier(nil, nil, "modifier_chaotic_nether_swap_debuff", {})
	
								end
	
							end

							local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl( effect_cast, 0, point)
							ParticleManager:SetParticleControl( effect_cast, 1, pos)
							ParticleManager:SetParticleControl( effect_cast, 2, eff_radius)
							ParticleManager:SetParticleControl( effect_cast, 3, eff_length)
							ParticleManager:SetParticleControl( effect_cast, 4, Vector(500,0,0))
							DestroyParticleByDelay(effect_cast,0.3)

							caster:GameTimer(0.3,function()

								if not IsValid(self) then
									return
								end

								for a=1, #enemies do
	
									enemies[a]:SetAbsOrigin(caster:GetAbsOrigin())

									enemies[a]:RemoveModifierByName("modifier_chaotic_nether_swap_debuff")

									enemies[a]:AddNewModifier(nil, nil, "modifier_phased", {duration=0.01})

									local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

									local StatusResistance = enemies[a]:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain

									enemies[a]:AddNewModifier(caster, self, "modifier_stunned", {duration = duration*StatusResistance})

									if a == #enemies then

										if not self:GetAutoCastState() then

											caster:SetAbsOrigin(pos)
											caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.01})
		
										end

									end
		
								end

								caster:EmitSound("Hero_Dawnbreaker.Celestial_Hammer.Impact")
								
							end)
						end
					end)
				end
			end
		end)
	end
end

modifier_chaotic_nether_swap_debuff = advanced_modifier({})

function modifier_chaotic_nether_swap_debuff:IsDebuff()			return true end
function modifier_chaotic_nether_swap_debuff:IsHidden() 			return true end
function modifier_chaotic_nether_swap_debuff:IsPurgable() 			return false end
function modifier_chaotic_nether_swap_debuff:IsPurgeException() 	return false end
function modifier_chaotic_nether_swap_debuff:IsStunDebuff()		return true end
function modifier_chaotic_nether_swap_debuff:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end