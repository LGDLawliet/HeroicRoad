
Middle_Boundless_Strike = class({})

LinkLuaModifier( "modifier_Middle_Boundless_Strike_buff", "skills/Middle_Boundless_Strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Middle_Boundless_Strike_thinker", "skills/Middle_Boundless_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Boundless_Strike_effect", "skills/Middle_Boundless_Strike", LUA_MODIFIER_MOTION_NONE)

function Middle_Boundless_Strike:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function Middle_Boundless_Strike:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function Middle_Boundless_Strike:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function Middle_Boundless_Strike:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("range")

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(200,200,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function Middle_Boundless_Strike:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end
function Middle_Boundless_Strike:IsHiddenWhenStolen() 	return false end
function Middle_Boundless_Strike:IsRefreshable() 		return true end
function Middle_Boundless_Strike:IsStealable() 			return true end
function Middle_Boundless_Strike:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("range") - caster:GetCastRangeBonus()

end

function Middle_Boundless_Strike:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/boundless_strike/boundless_strike_model.vpcf", context )
	
	
	-- PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast_modelonly.vpcf", context )

end
function Middle_Boundless_Strike:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_monkey_king" then
		return ACT_DOTA_MK_STRIKE
	end
	return ACT_DOTA_ATTACK
end
function Middle_Boundless_Strike:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("range")
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster_loc  )
	ParticleManager:SetParticleControl( pfx, 1, target_pos  )
	ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
	self:StopEffects( false )
	local mod = caster:AddNewModifier(caster, self,"modifier_Middle_Boundless_Strike_buff", {duration = 0.1})

	local max_count = self:GetSpecialValueFor("max_number")
	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, target_pos,nil, 200,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local stun_duration = self:GetSpecialValueFor("duration")
	for i, enemy in pairs(tTargets) do
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration*StatusResistance})
		
		caster:PerformAttack( enemy, true, true, true, true, false, false, true )


		if i>=max_count then
			break
		end
	end

	if mod then
		mod:SafeDestroy()
	end


	
	local thinker =CreateModifierThinker(
		caster,
		self,
		"modifier_Middle_Boundless_Strike_thinker",
		{
			duration = 5,
		},
		pos,
		caster:GetTeamNumber(),
		false
	)
end


function Middle_Boundless_Strike:OnAbilityPhaseStart()
	local pos = self:GetCursorPosition()
	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("range")
	self.pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( self.pfx, 0, caster_loc  )
	ParticleManager:SetParticleControl( self.pfx, 2, caster_loc  )
	ParticleManager:SetParticleControl( self.pfx, 1, target_pos  )
	ParticleManager:SetParticleControl( self.pfx, 1, Vector(1,0,0)  )
	ParticleManager:SetParticleControlForward(self.pfx, 0, direction)  --方向


	-- self.pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast_modelonly.vpcf", PATTACH_CUSTOMORIGIN, caster )
	-- ParticleManager:SetParticleControl( self.pfx, 0, caster_loc  )
	-- ParticleManager:SetParticleControl( self.pfx, 1, target_pos  )
	caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

	return true -- if success
end

function Middle_Boundless_Strike:OnAbilityPhaseInterrupted()
	self:StopEffects( true )
	-- self:StopEffects2( true )
end
function Middle_Boundless_Strike:StopEffects(destroy)
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, destroy)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
	end
end

-- function Middle_Boundless_Strike:StopEffects2(destroy)
-- 	if self.pfx2 then
-- 		ParticleManager:DestroyParticle(self.pfx2, destroy)
-- 		ParticleManager:ReleaseParticleIndex(self.pfx2)
-- 		self.pfx2 = nil
-- 	end
-- end




modifier_Middle_Boundless_Strike_buff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Boundless_Strike_buff:IsHidden()	return true end
function modifier_Middle_Boundless_Strike_buff:IsDebuff()	return false end
function modifier_Middle_Boundless_Strike_buff:IsPurgable()	return false end
function modifier_Middle_Boundless_Strike_buff:OnCreated( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if IsServer() then
		local caster = self:GetParent()
		local keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave = 1,
			iDisableSplit = 1,

		}
		self.attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),keys)
	end
end


function modifier_Middle_Boundless_Strike_buff:OnDestroy()
	if IsServer() then
		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end
	end
end


function modifier_Middle_Boundless_Strike_buff:Advanced_GetModifierCriticalStrike(keys)
	return  self.bonus
end

function modifier_Middle_Boundless_Strike_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end





modifier_Middle_Boundless_Strike_thinker = class({})
function modifier_Middle_Boundless_Strike_thinker:IsAura()	return true end
function modifier_Middle_Boundless_Strike_thinker:GetModifierAura()	return "modifier_Middle_Boundless_Strike_effect" end
function modifier_Middle_Boundless_Strike_thinker:GetAuraRadius()	return self.radius  end
function modifier_Middle_Boundless_Strike_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_Boundless_Strike_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Middle_Boundless_Strike_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Middle_Boundless_Strike_thinker:OnCreated(params)
	if IsServer() then
		self.radius = 500
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/boundless_strike/boundless_strike_model.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,0,0) )
		ParticleManager:ReleaseParticleIndex(effect_cast)

	end
end
function modifier_Middle_Boundless_Strike_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	UTIL_Remove( self:GetParent() )
end









modifier_Middle_Boundless_Strike_effect = advanced_modifier({})

function modifier_Middle_Boundless_Strike_effect:IsHidden()	return false end
function modifier_Middle_Boundless_Strike_effect:IsDebuff()	return false end
function modifier_Middle_Boundless_Strike_effect:IsPurgable()	return false end
function modifier_Middle_Boundless_Strike_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Boundless_Strike_effect:OnCreated(keys)
	self.bonus_range = 200
	if self:GetParent():Script_GetAttackRange()>=1000 then
		self.bonus_range = 0
	end
	self.bonus_damage = 20
end

function modifier_Middle_Boundless_Strike_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,      
	}

	return funcs
end

function modifier_Middle_Boundless_Strike_effect:GetModifierBaseDamageOutgoing_Percentage()	return self.bonus_damage end
function modifier_Middle_Boundless_Strike_effect:Advanced_GetModifierAttackRangeBonus()	return self.bonus_range end

function modifier_Middle_Boundless_Strike_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end