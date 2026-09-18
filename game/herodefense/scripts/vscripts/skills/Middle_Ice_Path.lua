
Middle_Ice_Path = class({})
LinkLuaModifier("modifier_Middle_Ice_Path_debuff", "skills/Middle_Ice_Path", LUA_MODIFIER_MOTION_NONE)



function Middle_Ice_Path:IsHiddenWhenStolen() 		return false end
function Middle_Ice_Path:IsRefreshable() 			return true end
function Middle_Ice_Path:IsStealable() 			return true end
function Middle_Ice_Path:IsNetherWardStealable() 	return true end
--add by MB 0823
--------------------------------------------------------------------
function Middle_Ice_Path:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	if pos==caster:GetOrigin() then
		pos = pos + caster:GetForwardVector()
	end
	local caster_pos = caster:GetAbsOrigin()
	local hpos = caster:GetUpVector()*100 
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local length = self:GetCastRange(pos, caster) + caster:GetCastRangeBonus()
	length = math.max(length,100)
	local end_pos = caster_pos + caster:GetForwardVector() * length
	--ability kv
	local path_radius = self:GetSpecialValueFor("path_radius")
	local duration = self:GetSpecialValueFor("path_duration")
	--wearable kv 
	local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
	local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
	local sound_name = "Hero_Jakiro.IcePath"
	local projectile_name = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
	--音效
	EmitSoundOn( sound_name, caster )
	--特效
	local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 1, end_pos + hpos )
	ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
	DestroyParticleByDelay(pfx,duration+3)
	local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
	ParticleManager:SetParticleControl( pfx2, 1, end_pos + hpos)
	ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
	ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
	DestroyParticleByDelay(pfx2,duration+3)
	--抛射物
	local info =
	{
		Ability = self,
		vSpawnOrigin = caster_pos,
		EffectName = projectile_name,
		fDistance = length,
		fStartRadius = path_radius,
		fEndRadius = path_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime	= GameRules:GetGameTime() +10,
		vVelocity	= direction * 3000,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	} 
	ProjectileManager:CreateLinearProjectile( info )

end
--------------------------------------------------------------------
function Middle_Ice_Path:Spell_SplitIcePath(vSource,vCount)
	local caster = vSource
	local caster_pos = caster:GetAbsOrigin()
	local hpos = caster:GetUpVector()*100 
	local length = self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + self:GetCaster():GetCastRangeBonus()
	length = math.max(length,100)
	local end_pos = caster_pos + caster:GetForwardVector():Normalized() * length
	--ability kv
	local path_radius = self:GetSpecialValueFor("path_radius")
	local duration = self:GetSpecialValueFor("duration")
	--wearable kv 
	local pfx_name = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
	local pfx_name_2 = "particles/rebuild/spell/ice_path/unlock3/effect_b.vpcf"
	local sound_name = "Hero_Jakiro.IcePath"
	local projectile_name = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
	--音效
	EmitSoundOn( sound_name, self:GetCaster() ) 
	--抛射物
	local info =
	{
		Ability = self,
		vSpawnOrigin = caster_pos,
		EffectName = projectile_name,
		fDistance = length,
		fStartRadius = path_radius,
		fEndRadius = path_radius,
		Source = self:GetCaster(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime	= GameRules:GetGameTime() +10,
		--vVelocity	= direction * 3000,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber()
	} 
	--多道冰封路径
	for i=0, vCount-1 do
		local pos = GetGroundPosition(RotatePosition(caster_pos, QAngle(0,i * (360 / vCount),0), end_pos), nil)
		local direction = (pos - caster:GetAbsOrigin()):Normalized()
		direction.z = 0 
		--print("IcePath Direction",direction,i)
		--特效
		local pfx = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( pfx, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx, 1, pos + hpos ) --end_pos
		ParticleManager:SetParticleControl( pfx, 2, caster_pos + hpos )
		DestroyParticleByDelay(pfx,duration+3)
		local pfx2 = ParticleManager:CreateParticle( pfx_name_2, PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( pfx2, 0, caster_pos + hpos )
		ParticleManager:SetParticleControl( pfx2, 1, pos + hpos) --end_pos
		ParticleManager:SetParticleControl( pfx2, 2, Vector( duration , 0, 0 ) )
		ParticleManager:SetParticleControl( pfx2, 9, caster_pos + hpos )
		DestroyParticleByDelay(pfx2,duration+3)
		--抛射物修改
		info.vVelocity = direction * 3000
		ProjectileManager:CreateLinearProjectile( info )
	end
end
--------------------------------------------------------------------
function Middle_Ice_Path:OnProjectileHit_ExtraData(target, location, kv)
	
	if not target then
		return
	end
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.5)
	local StatusResistance =  target:GetHDStatusResistanceIndex(0.45)*ModifierStatusNegativeGain
	local duration = self:GetSpecialValueFor("path_duration")*StatusResistance
	local damage = self:GetSpecialValueFor("basic_damage") + self:GetCaster():GetIntellect(false)*self:GetSpecialValueFor("intelligence_index")
	if not target:IsMagicImmune() then
		target:AddNewModifier(  self:GetCaster(), self, "modifier_Middle_Ice_Path_debuff", {duration = duration} )
     	local damage_type = self:GetAbilityDamageType()
	    local damageTable = {
			victim = target,
			attacker =  self:GetCaster(),
			damage = damage,
			damage_type = damage_type,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = self,
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
		}
		ApplyDamage(damageTable)
	end
end

modifier_Middle_Ice_Path_debuff = class({})

function modifier_Middle_Ice_Path_debuff:IsDebuff()	return true end
function modifier_Middle_Ice_Path_debuff:IsHidden()	return false end
function modifier_Middle_Ice_Path_debuff:IsPurgable()	return false end
function modifier_Middle_Ice_Path_debuff:IsPurgeException()	return true end
function modifier_Middle_Ice_Path_debuff:IsStunDebuff() return true end
function modifier_Middle_Ice_Path_debuff:GetStatusEffectName()	return "particles/status_fx/status_effect_frost_lich.vpcf"	end
function modifier_Middle_Ice_Path_debuff:StatusEffectPriority() return 100	end
function modifier_Middle_Ice_Path_debuff:GetEffectName()	return "particles/generic_gameplay/generic_frozen.vpcf"	end
function modifier_Middle_Ice_Path_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW	end
function modifier_Middle_Ice_Path_debuff:CheckState()	
	return	{
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true}
end

function modifier_Middle_Ice_Path_debuff:DeclareFunctions() return
	{MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Middle_Ice_Path_debuff:GetModifierMagicalResistanceBonus() return (0 - self:GetAbility():GetSpecialValueFor("bonus_damage")) end

