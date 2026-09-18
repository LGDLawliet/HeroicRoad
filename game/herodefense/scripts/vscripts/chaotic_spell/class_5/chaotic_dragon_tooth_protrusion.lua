
chaotic_dragon_tooth_protrusion = class({})

LinkLuaModifier("modifier_chaotic_dragon_tooth_protrusion_caster_motion", "chaotic_spell/class_5/chaotic_dragon_tooth_protrusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_dragon_tooth_protrusion_debuff", "chaotic_spell/class_5/chaotic_dragon_tooth_protrusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_dragon_tooth_protrusion_debuff_rune1", "chaotic_spell/class_5/chaotic_dragon_tooth_protrusion", LUA_MODIFIER_MOTION_NONE)

function chaotic_dragon_tooth_protrusion:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_dragon_tooth_protrusion/chaotic_dragon_tooth_protrusion/effect_pos.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_dragon_tooth_protrusion/effect_main/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/drow/drow_arcana/drow_arcana_lifesteal.vpcf", context )


	
end

function chaotic_dragon_tooth_protrusion:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_dragon_tooth_protrusion:GetCooldown()
	local cd = self:GetSpecialValueFor("cooldown")
	if self:GetRuneType()==3 then
		cd = cd * (1-self:GetSpecialValueFor("rune_3_cd")*0.01)
	end
	return cd
end
function chaotic_dragon_tooth_protrusion:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_dragon_tooth_protrusion:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self:GetSpecialValueFor("width"),100,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end


function chaotic_dragon_tooth_protrusion:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = distance * (1+self:GetSpecialValueFor("rune_2_distance")*0.01)
	end
	local target_pos = caster_loc + direction* distance

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)

end

function chaotic_dragon_tooth_protrusion:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_dragon_tooth_protrusion:GetCastRange()
	if IsClient() then
		
		local caster = self:GetCaster()
		local distance = self:GetSpecialValueFor("distance")
		if self:GetRuneType()==2 then
			distance = distance * (1+self:GetSpecialValueFor("rune_2_distance")*0.01)
		end
		return distance - caster:GetCastRangeBonus()
	end
	if IsServer() then
		return 30000
	end

end

function chaotic_dragon_tooth_protrusion:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = distance * (1+self:GetSpecialValueFor("rune_2_distance")*0.01)
	end
	local width = self:GetSpecialValueFor("width")
	local direction = (pos - caster_loc):Normalized()
	local pos = caster_loc + direction * distance
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
	    bDeleteOnHit = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    EffectName = "particles/rebuild/chaotic_dragon_tooth_protrusion/chaotic_dragon_tooth_protrusion/effect_pos.vpcf",
	    fDistance = distance,
	    fStartRadius = 100,
	    fEndRadius = width,
		vVelocity = direction * 2800,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)	
	caster:AddNewModifier(caster, self, "modifier_chaotic_dragon_tooth_protrusion_caster_motion", {duration = -1, direction_x = direction.x, direction_y = direction.y, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	caster:EmitSound("chaotic_dragon_tooth_protrusion_cast")
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_dragon_tooth_protrusion/effect_main/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	-- ParticleManager:SetParticleControlEnt( effect_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "" , self:GetCaster():GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControlEnt( effect_cast, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( effect_cast, 2, caster_loc)
	ParticleManager:SetParticleControl( effect_cast, 4, caster_loc)
	ParticleManager:SetParticleControl( effect_cast, 3, direction)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	
end

modifier_chaotic_dragon_tooth_protrusion_caster_motion = class({})

function modifier_chaotic_dragon_tooth_protrusion_caster_motion:IsDebuff()					return false end
function modifier_chaotic_dragon_tooth_protrusion_caster_motion:IsHidden() 				return true end
function modifier_chaotic_dragon_tooth_protrusion_caster_motion:IsPurgable() 				return false end
function modifier_chaotic_dragon_tooth_protrusion_caster_motion:IsPurgeException() 		return false end
function modifier_chaotic_dragon_tooth_protrusion_caster_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
-- function modifier_chaotic_dragon_tooth_protrusion_caster_motion:IsMotionController() return true end
function modifier_chaotic_dragon_tooth_protrusion_caster_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_chaotic_dragon_tooth_protrusion_caster_motion:OnCreated(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.caster_loc = self.caster:GetAbsOrigin()
		self.direction = Vector(keys.direction_x, keys.direction_y, 0)
		self.hitted = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.width = self:GetAbility():GetSpecialValueFor("width")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.bonus_damage_max = self:GetAbility():GetSpecialValueFor("bonus_damage_max")
		self.distance =  self:GetAbility():GetSpecialValueFor("distance")
		self.ability = self:GetAbility()
		self.next_pos = 0
		self.effect_gain =  self:GetAbility():GetEffectGain()
		-- if self:CheckMotionControllers() then
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
		-- else
		-- 	self:SafeDestroy()
		-- end
		if self:GetAbility():GetRuneType()==2 then
			self.distance = self.distance * (1+self:GetAbility():GetSpecialValueFor("rune_2_distance")*0.01)
		end
		if self:GetAbility():GetRuneType()==3 then
			self.bonus_damage = self.bonus_damage*(1-self:GetAbility():GetSpecialValueFor("rune_3_damage")*0.01)
			self.bonus_damage_max = self.bonus_damage_max*(1-self:GetAbility():GetSpecialValueFor("rune_3_damage")*0.01)
		end
	end
end

function modifier_chaotic_dragon_tooth_protrusion_caster_motion:OnIntervalThink()
	if not IsServer() then
		return
	end
	local distance = self.distance / (0.25 / FrameTime())
	self.next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	if (self.next_pos - self.caster_loc):Length2D() > self.distance + 50 then
		self:Destroy()
		return
	end	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self:GetParent():SetOrigin(self.next_pos)

	for _, enemy in pairs(enemies) do
		enemy:SetOrigin(self.next_pos)
		if not IsInTable(enemy, self.hitted) then
			table.insert(self.hitted, enemy)
		end
	end
end

function modifier_chaotic_dragon_tooth_protrusion_caster_motion:OnDestroy()
	if IsServer() then
		if not IsValid(self.ability) then
			return
		end
		local damage = self.caster:HDGetPrimaryStatValue() * self.bonus_damage * self.effect_gain 
		local damage_max = self.caster:HDGetPrimaryStatValue() * self.bonus_damage_max * self.effect_gain 
		local damageTable = {
			attacker = self.caster,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, 
			ability = self.ability,
			hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE,
		}

		local arti_douqi = self:GetCaster():FindAbilityByName("item_hd_douqi_effects")
		local arti_douqi_level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_douqi_effects")
		if arti_douqi and arti_douqi_level then
			if arti_douqi_level >= 40 then
				damageTable.hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			end
		end


		if self:GetAbility():GetRuneType()==2 then
			damageTable.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
		end
		local ModifierStatusNegativeGain = self.caster:GetModifierStatusNegativeGainIndex()
		damageTable.damage = math.min(damage_max,damage*#self.hitted)
		local total_damage_rune1 = 0
		for _, enemy in pairs(self.hitted) do
			if IsValid(enemy) and enemy:IsAlive() then
				FindClearSpaceForUnit(enemy, self.pos, true)
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier(self.caster, self.ability, "modifier_chaotic_dragon_tooth_protrusion_debuff", {duration = self.duration*StatusResistance})
				damageTable.victim = enemy

				local health = enemy:GetHealth()
				ApplyDamage(damageTable)
				if not enemy:IsAlive() then
					if (damageTable.damage-health)>0 then
						total_damage_rune1 = total_damage_rune1 + (damageTable.damage-health)
					end
				end
				
			end
			
		end
		if self.ability:GetRuneType()==1 then
			local duration = self.ability:GetSpecialValueFor("rune_1_duration")
			local damage_rune1 = self.ability:GetSpecialValueFor("rune_1_gain")*0.01*total_damage_rune1
			for _, enemy in pairs(self.hitted) do
				if IsValid(enemy) and enemy:IsAlive() then
					enemy:AddNewModifier(self.caster, self.ability, "modifier_chaotic_dragon_tooth_protrusion_debuff_rune1", {duration = duration+RandomFloat(-0.2, 0.2),damage = damage_rune1})
				end
				
			end
		end


		FindClearSpaceForUnit(self:GetParent(), self.pos, true)

	end
end

modifier_chaotic_dragon_tooth_protrusion_debuff = advanced_modifier({})

function modifier_chaotic_dragon_tooth_protrusion_debuff:IsDebuff()			return true end
function modifier_chaotic_dragon_tooth_protrusion_debuff:IsHidden() 		return false end
function modifier_chaotic_dragon_tooth_protrusion_debuff:IsPurgable() 		return false end
function modifier_chaotic_dragon_tooth_protrusion_debuff:IsPurgeException() return false end

function modifier_chaotic_dragon_tooth_protrusion_debuff:OnCreated()
    self.move_speed_reduction = self:GetAbility():GetSpecialValueFor("move_speed_reduction")
	self.attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
end

function modifier_chaotic_dragon_tooth_protrusion_debuff:OnRefresh() 
    self.move_speed_reduction = self:GetAbility():GetSpecialValueFor("move_speed_reduction")
	self.attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
end

function modifier_chaotic_dragon_tooth_protrusion_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_dragon_tooth_protrusion_debuff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 2 + 1

    if self._tooltip == 1 then
        return self:GetModifierMoveSpeedBonus_Constant()
	end

	if self._tooltip == 2 then
        return self:GetModifierAttackSpeedBonus_Constant()
	end
end

function modifier_chaotic_dragon_tooth_protrusion_debuff:GetModifierMoveSpeedBonus_Constant() 
    return -self.move_speed_reduction
end

function modifier_chaotic_dragon_tooth_protrusion_debuff:GetModifierAttackSpeedBonus_Constant()	return -self.attack_speed_reduction end





modifier_chaotic_dragon_tooth_protrusion_debuff_rune1 = advanced_modifier({})

function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:IsDebuff()			return true end
function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:IsHidden() 		return false end
function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:IsPurgable() 		return false end
function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:IsPurgeException() return false end
function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:OnCreated(keys)
	if IsServer() then
		self.damage = keys.damage
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "" , self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlEnt( effect_cast, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( effect_cast, 2, caster_loc)
		-- ParticleManager:SetParticleControl( effect_cast, 4, caster_loc)
		-- ParticleManager:SetParticleControl( effect_cast, 3, direction)
		ParticleManager:ReleaseParticleIndex(effect_cast)
		
	end
end

function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsAlive() then
			local ability = self:GetAbility()
			if not ability then
				return
			end
			parent:EmitSound("Furion_Treant.Attack")
			local damageTable = {
				attacker = self:GetCaster(),
				damage = self.damage,
				victim = parent,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION , 
				hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
				ability = ability,
			}

			
			ApplyDamage(damageTable)
		end
	end
end

function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:CheckState()
	if IsServer() then
		return {
			[MODIFIER_STATE_STUNNED] = true,
		}
	end
	return
end

function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_chaotic_dragon_tooth_protrusion_debuff_rune1:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end