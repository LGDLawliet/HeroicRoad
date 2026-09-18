
Primary_purification = class({})


function Primary_purification:IsHiddenWhenStolen()
	return false
end
function Primary_purification:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	return radius
end

function Primary_purification:OnSpellStart()
	if not IsServer() then
		return
	end
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local rare_cast_response = "omniknight_omni_ability_purif_03"
	local target_cast_response = {"omniknight_omni_ability_purif_01", "omniknight_omni_ability_purif_02", "omniknight_omni_ability_purif_04", "omniknight_omni_ability_purif_05", "omniknight_omni_ability_purif_06", "omniknight_omni_ability_purif_07", "omniknight_omni_ability_purif_08"}
	local self_cast_response = {"omniknight_omni_ability_purif_01", "omniknight_omni_ability_purif_05", "omniknight_omni_ability_purif_06", "omniknight_omni_ability_purif_07", "omniknight_omni_ability_purif_08"}
	local sound_cast = "Hero_Omniknight.Purification"    
	-- Play cast responses    
	if caster == target then
		if RollPercentage(50) then
			EmitSoundOn(self_cast_response[math.random(1, #self_cast_response)], caster)
		end
	else
		-- Roll for rare response
		if RollPercentage(5) then
			EmitSoundOn(rare_cast_response, caster)

		-- Roll for normal reponse
		elseif RollPercentage(50) then
			EmitSoundOn(target_cast_response[math.random(1,#target_cast_response)], caster)
		end
	end
	EmitSoundOn(sound_cast, caster)
	
	--命石：洗礼，目标修改
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_holy_cross_cloak")
	if equip_sp then
		local targets = GetAllRealHeroes()
		for _,target in pairs(targets)do
			self:Purification(caster, ability, target)
		end
	else
		self:Purification(caster, ability, target)
	end
end

function Primary_purification:Purification(caster, ability, target)
	if not IsServer() then
		return
	end
	-- Ability properties
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_aoe = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local particle_hit = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
	local modifier_purifiception = "modifier_imba_purification_buff"    

	-- Ability specials
	local heal_amount = ability:GetSpecialValueFor("basic_damage")
	local radius = ability:GetSpecialValueFor("radius")

	-- #8 Talent: Purification heal/damage increase
	heal_amount = heal_amount + caster:GetStrength()*ability:GetSpecialValueFor("bonus_damage")

	--命石：洗礼，治疗修改1
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_holy_cross_cloak")
	if equip_sp then
		heal_amount = heal_amount*(1+equip_sp:GetAbility():GetSpecialValueFor("bonus_damage")*0.01)
		radius = radius*(1+equip_sp:GetAbility():GetSpecialValueFor("bonus_radius")*0.01)
	end
	-- Add cast particle
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	-- Add AoE particle
	local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_aoe_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)    


	-- Calculate final heal/damage values
	local heal = heal_amount
	local damage = heal

	--命石：洗礼，治疗修改2
	if not equip_sp then
		local healing = HealWithGain(heal,caster,target,self)
    	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
	end
    target:Purge(false, true, false, false, true) --强驱散
	-- Find enemies around it
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  target:GetAbsOrigin(),
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)

	
	for i,enemy in pairs(enemies) do
		-- If they're not magic immune, damage them
		if not enemy:IsMagicImmune() then--
			local damageTable = {
				victim = enemy,
				attacker = caster, 
				damage = damage,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				ability = ability,
				hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
			}
		
			ApplyDamage(damageTable)  

			-- Add hit particle
			local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(particle_hit_fx, 3, Vector(radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(particle_hit_fx)
		end
		if i>=5 then
			break
		end
	end        
end