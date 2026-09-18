LinkLuaModifier("modifier_chaotic_getsuga_tenshou_death_determination", "chaotic_spell/class_9/chaotic_getsuga_tenshou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_getsuga_tenshou_debuff", "chaotic_spell/class_9/chaotic_getsuga_tenshou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_getsuga_tenshou_buff", "chaotic_spell/class_9/chaotic_getsuga_tenshou", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_time_cleave_damage", "chaotic_spell/class_9/chaotic_time_cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_time_cleave_debuff", "chaotic_spell/class_9/chaotic_time_cleave", LUA_MODIFIER_MOTION_NONE)
chaotic_getsuga_tenshou = class({})


function chaotic_getsuga_tenshou:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_getsuga_tenshou:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_getsuga_tenshou:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_getsuga_tenshou:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpellDistance()

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self:GetSpecialValueFor("width"),self:GetSpecialValueFor("width"),0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_getsuga_tenshou:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end
function chaotic_getsuga_tenshou:GetSpellDistance()
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = 30000
	end
	return distance
end

function chaotic_getsuga_tenshou:GetCastRange()
	if IsServer() then
		return 30000
	else
		local caster = self:GetCaster()
		return self:GetSpellDistance()- caster:GetCastRangeBonus()
	end
end

function chaotic_getsuga_tenshou:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_getsuga_tenshou/effect/shockwave/effect.vpcf", context )
end


function chaotic_getsuga_tenshou:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpellDistance()
	local width = self:GetSpecialValueFor("width")
	
	local speed = 7500

	

	local damage = (caster:HDGetPrimaryStatValue() * self:GetSpecialValueFor("bonus_damage") + self:GetSpecialValueFor("damage")) *self:GetEffectGain()
	if self:GetRuneType()==3 and not caster:HasAbility("chaotic_time_cleave")then
		damage = damage*(1+self:GetSpecialValueFor("rune_3_damage")*0.01)
	end

	local projectileTable =
	{
		EffectName ="particles/rebuild/chaotic_spell/chaotic_getsuga_tenshou/effect/shockwave/effect.vpcf",
		Ability = self,
		vSpawnOrigin =caster_loc,
		vVelocity = direction * speed,
		fDistance =distance,
		fStartRadius = width,
		fEndRadius = width,
		Source = caster,
		-- TreeBehavior = PROJECTILES_NOTHING,
		-- bCutTrees = true,
		-- bTreeFullCollision = false,
		-- bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
		bProvidesVision = true,
		iVisionRadius  = 700,
		iVisionTeamNumber = caster:GetTeamNumber(),
		bDeleteOnHit = false,
		ExtraData = {
			damage = damage,
			direction_x = direction.x,
			direction_y = direction.y,

		}   --额外的数据

	}



	ProjectileManager:CreateLinearProjectile( projectileTable )

	local sound_cast = "Hero_Juggernaut.BladeDance"
	caster:EmitSound(sound_cast)

	
end

function chaotic_getsuga_tenshou:OnProjectileHit_ExtraData(target, location, kv)
	if not IsServer() then
		return
	end
	
	if target~=nil then
		local ability = self
		local caster = ability:GetCaster()
		-- local enemy_direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		--local debuff_duration = self:GetSpecialValueFor("debuff_duration")
		local repel_distance = self:GetSpecialValueFor("repel_distance")

		
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex()
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		--target:AddNewModifier(caster, ability, "modifier_chaotic_getsuga_tenshou_debuff", {duration = debuff_duration*StatusResistance})
		local pos = target:GetAbsOrigin()-Vector(kv.direction_x,kv.direction_y,0)*50
		
		target:EmitSound("Hero_Juggernaut.BladeDance")
	
		if self:GetRuneType()==3 then
			local ability_rune_3 = caster:FindAbilityByName("chaotic_time_cleave")
			if ability_rune_3 then
				local armor_reduction_duration = ability_rune_3:GetSpecialValueFor("armor_reduction_duration")
				local duration = ability_rune_3:GetSpecialValueFor("duration")
				local gain = ability_rune_3:GetEffectGain()
				target:AddNewModifier(caster, ability_rune_3, "modifier_chaotic_time_cleave_damage", {duration = duration,gain=gain})
				target:AddNewModifier(caster, ability_rune_3, "modifier_chaotic_time_cleave_debuff", {duration = armor_reduction_duration})
				target:EmitSound("chaotic_six_light_continuous_slash_cast")
			end
		end

		local damageTable = {
			victim = target,
			attacker = caster,
			damage =  kv.damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = ability,
			hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE
		}

		local arti_douqi = self:GetCaster():FindAbilityByName("item_hd_douqi_effects")
		local arti_douqi_level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_douqi_effects")
		if arti_douqi and arti_douqi_level then
			if arti_douqi_level >= 40 then
				damageTable.hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			end
		end

		ApplyDamage(damageTable)
		if IsValid(target) and target:IsAlive() then
			local knockback =
			{
				knockback_duration = 0.2,
				duration = 0.15,
				knockback_distance = repel_distance,
				knockback_height = 20,
				center_x = pos.x,
				center_y = pos.y,
				center_z = pos.z,
			}
			target:RemoveModifierByName("modifier_knockback")
			target:AddNewModifier(caster, self, "modifier_knockback", knockback)
		else
			--死了 
			local buff_duration = self:GetSpecialValueFor("buff_duration")
			caster:AddNewModifier(caster, self, "modifier_chaotic_getsuga_tenshou_buff", {duration = buff_duration})
			local cooldown_reduction = self:GetSpecialValueFor("cooldown_reduction")
			local cooldown_min = self:GetSpecialValueFor("cooldown_min")
			local StartCooldown = self:GetCooldownTimeRemaining() - cooldown_reduction
			if StartCooldown >= cooldown_min or self:GetRuneType()==1 then
				self:EndCooldown()
				if StartCooldown>0 then
					self:StartCooldown(StartCooldown)
				end
				
			end
		end
	end
end


------------------------------------------------------------

modifier_chaotic_getsuga_tenshou_debuff = advanced_modifier({})

function modifier_chaotic_getsuga_tenshou_debuff:IsHidden() return false end
function modifier_chaotic_getsuga_tenshou_debuff:IsPurgable() return false end
function modifier_chaotic_getsuga_tenshou_debuff:IsDebuff() return true end

function modifier_chaotic_getsuga_tenshou_debuff:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.move_speed_reduction = self.ability:GetSpecialValueFor("move_speed_reduction")
end

function modifier_chaotic_getsuga_tenshou_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_getsuga_tenshou_debuff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

    if self._tooltip == 1 then
        return self:GetModifierMoveSpeedBonus_Constant()
	end
end

function modifier_chaotic_getsuga_tenshou_debuff:GetModifierMoveSpeedBonus_Constant() 
    return -self.move_speed_reduction
end
---------------------------------------------
modifier_chaotic_getsuga_tenshou_buff = advanced_modifier({})

function modifier_chaotic_getsuga_tenshou_buff:IsHidden() return false end
function modifier_chaotic_getsuga_tenshou_buff:IsPurgable() return false end
function modifier_chaotic_getsuga_tenshou_buff:IsDebuff() return false end

function modifier_chaotic_getsuga_tenshou_buff:OnCreated()
	--self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	if not IsServer() then
		return
	end
	local bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	bonus_attack_damage = bonus_attack_damage
	self:SetStackCount(bonus_attack_damage)
end

function modifier_chaotic_getsuga_tenshou_buff:OnRefresh()
	self:OnCreated()
end

function modifier_chaotic_getsuga_tenshou_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_getsuga_tenshou_buff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

	if self._tooltip == 1 then
        return self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end

function modifier_chaotic_getsuga_tenshou_buff:ADDeclareFunctions()
    return 
    {
		--advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end


function modifier_chaotic_getsuga_tenshou_buff:Advanced_GetModifierAttackRangeBonus()
	if not self:GetParent():IsRangedAttacker() then
		return self.bonus_attack_range 
	end
	return 0
end

function modifier_chaotic_getsuga_tenshou_buff:Advanced_GetModifierPreAttack_BonusDamage()
	if not self:GetParent():IsRangedAttacker() then
		return self:GetStackCount()
	end
	return 0
end