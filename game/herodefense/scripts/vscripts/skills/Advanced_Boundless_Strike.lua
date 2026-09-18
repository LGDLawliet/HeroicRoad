
Advanced_Boundless_Strike = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Boundless_Strike_buff", "skills/Advanced_Boundless_Strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Boundless_Strike_buff2", "skills/Advanced_Boundless_Strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_Boundless_Strike_thinker", "skills/Advanced_Boundless_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Boundless_Strike_effect", "skills/Advanced_Boundless_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Boundless_Strike_unlock1_passive", "skills/Advanced_Boundless_Strike", LUA_MODIFIER_MOTION_NONE)

function Advanced_Boundless_Strike:CheckKV(key)
	local table = {
		bonus_damage =12,

	}
	local value = table[key] or -1
	return value

end



function Advanced_Boundless_Strike:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Boundless_Strike_unlock1_passive",{})
	return true
end
function Advanced_Boundless_Strike:UnlockSecondCore(key)
	return true
end
function Advanced_Boundless_Strike:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Boundless_Strike_unlock1_passive",{})
	return true
end


function Advanced_Boundless_Strike:GetCooldown(iLevel)
	if self:GetUnlock(1)==1 then
		return 3.5
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end

function Advanced_Boundless_Strike:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function Advanced_Boundless_Strike:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function Advanced_Boundless_Strike:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function Advanced_Boundless_Strike:UpdateCustomIndicator( loc )
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

function Advanced_Boundless_Strike:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function Advanced_Boundless_Strike:IsHiddenWhenStolen() 	return false end
function Advanced_Boundless_Strike:IsRefreshable() 		return true end
function Advanced_Boundless_Strike:IsStealable() 			return true end
function Advanced_Boundless_Strike:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("range") - caster:GetCastRangeBonus()

end

function Advanced_Boundless_Strike:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/boundless_strike/boundless_strike_model.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_crimson_strike.vpcf", context )

end
function Advanced_Boundless_Strike:GetCastAnimation()
	if self:GetCaster():GetUnitName()=="npc_dota_hero_monkey_king" then
		return ACT_DOTA_MK_STRIKE
	end
	return ACT_DOTA_ATTACK
end
function Advanced_Boundless_Strike:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()  --目标点
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local stun_duration = self:GetSpecialValueFor("duration")
	local target_pos = caster_loc + direction* self:GetSpecialValueFor("range")
	local max_count = self:GetSpecialValueFor("max_number")
	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, target_pos,nil, 200,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	if self.unlock3 then
		local mod = caster:AddNewModifier(caster, self,"modifier_Advanced_Boundless_Strike_buff", {duration = 0.1})
		
		local new_caster_pos1 = RotatePosition(caster_loc, QAngle(0, 90, 0), target_pos) 
		local new_caster_pos2 = RotatePosition(caster_loc, QAngle(0, -90, 0), target_pos) 
		local new_dir_1 = (new_caster_pos1 - caster_loc):Normalized()
		local new_dir_2 = (new_caster_pos2 - caster_loc):Normalized()
		for i = 1, 5, 1 do
			local new_pos = caster_loc+new_dir_1 * i*150
			local new_target_pos = new_pos + direction * self:GetSpecialValueFor("range")
			local new_dir = (new_target_pos - new_pos):Normalized()
			local pfx = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_crimson_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, new_pos  )
			ParticleManager:SetParticleControl( pfx, 1, new_target_pos  )
			ParticleManager:SetParticleControlForward(pfx, 0, new_dir)  --方向
			ParticleManager:ReleaseParticleIndex(pfx)
			caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), new_pos, new_target_pos,nil, 200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			for i, enemy in pairs(tTargets) do
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration*StatusResistance})
				caster:PerformAttack( enemy, true, true, true, true, false, false, true )
				if i>=max_count then
					break
				end
			end
		end
		for i = 1, 5, 1 do
			local new_pos = caster_loc+new_dir_2 * i*150
			local new_target_pos = new_pos + direction * self:GetSpecialValueFor("range")
			local new_dir = (new_target_pos - new_pos):Normalized()
			local pfx = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_crimson_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, new_pos  )
			ParticleManager:SetParticleControl( pfx, 1, new_target_pos  )
			ParticleManager:SetParticleControlForward(pfx, 0, new_dir)  --方向
			ParticleManager:ReleaseParticleIndex(pfx)
			caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), new_pos, new_target_pos,nil, 200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			for i, enemy in pairs(tTargets) do
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration*StatusResistance})
				caster:PerformAttack( enemy, true, true, true, true, false, false, true )
				if i>=max_count then
					break
				end
			end
		end
		local pfx = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_crimson_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_loc  )
		ParticleManager:SetParticleControl( pfx, 1, target_pos  )
		ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
		self:StopEffects( false )
	
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
	else
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster_loc  )
		ParticleManager:SetParticleControl( pfx, 1, target_pos  )
		ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
		self:StopEffects( false )
		local mod = caster:AddNewModifier(caster, self,"modifier_Advanced_Boundless_Strike_buff", {duration = 0.1})

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
	end



	
	local thinker =CreateModifierThinker(
		caster,
		self,
		"modifier_Advanced_Boundless_Strike_thinker",
		{
			duration = 5,
		},
		pos,
		caster:GetTeamNumber(),
		false
	)
	caster:AddNewModifier(caster, self,"modifier_Advanced_Boundless_Strike_buff2", {duration = 10})


	if self.unlock2 then
		for i = 1, 5, 1 do
			local new_pos =pos + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
			local new_dir = (new_pos - pos):Normalized()
			local new_caster_pos = pos + new_dir* self:GetSpecialValueFor("range")

			Timers:CreateTimer(RandomFloat(0.1, 1), function()
				if self and not self:IsNull() then
					local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
					ParticleManager:SetParticleControl( pfx, 0, new_caster_pos  )
					ParticleManager:SetParticleControl( pfx, 1, pos  )
					ParticleManager:SetParticleControlForward(pfx, 0, -new_dir)  --方向
					ParticleManager:ReleaseParticleIndex(pfx)
					caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
					local tTargets2 = FindUnitsInLine(caster:GetTeamNumber(), new_caster_pos, target_pos,nil, 250,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE)
					local mod = caster:AddNewModifier(caster, self,"modifier_Advanced_Boundless_Strike_buff", {duration = 0.1})
					for i, enemy in pairs(tTargets2) do
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
	
	
				end
			end)
		end
	else
		
	if self.advanced_level>=15 and #tTargets<5 then
		Timers:CreateTimer(0.3, function()
			if self and not self:IsNull() then
				local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( pfx, 0, caster_loc  )
				ParticleManager:SetParticleControl( pfx, 1, target_pos  )
				ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
				ParticleManager:ReleaseParticleIndex(pfx)
				caster:EmitSound("Hero_MonkeyKing.Strike.Impact")
				local tTargets2 = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, target_pos,nil, 200,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE)
				local mod = caster:AddNewModifier(caster, self,"modifier_Advanced_Boundless_Strike_buff", {duration = 0.1})
				for i, enemy in pairs(tTargets2) do
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


			end
		end)
	end
end

	



end


function Advanced_Boundless_Strike:OnAbilityPhaseStart()
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

function Advanced_Boundless_Strike:OnAbilityPhaseInterrupted()
	self:StopEffects( true )
	-- self:StopEffects2( true )
end
function Advanced_Boundless_Strike:StopEffects(destroy)
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, destroy)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
	end
end

-- function Advanced_Boundless_Strike:StopEffects2(destroy)
-- 	if self.pfx2 then
-- 		ParticleManager:DestroyParticle(self.pfx2, destroy)
-- 		ParticleManager:ReleaseParticleIndex(self.pfx2)
-- 		self.pfx2 = nil
-- 	end
-- end




modifier_Advanced_Boundless_Strike_buff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Boundless_Strike_buff:IsHidden()	return true end
function modifier_Advanced_Boundless_Strike_buff:IsDebuff()	return false end
function modifier_Advanced_Boundless_Strike_buff:IsPurgable()	return false end
function modifier_Advanced_Boundless_Strike_buff:OnCreated( kv )
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


function modifier_Advanced_Boundless_Strike_buff:OnDestroy()
	if IsServer() then
		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end
	end
end

function modifier_Advanced_Boundless_Strike_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
function modifier_Advanced_Boundless_Strike_buff:Advanced_GetModifierCriticalStrike(keys)
	return self.bonus 
end




modifier_Advanced_Boundless_Strike_thinker = class({})
function modifier_Advanced_Boundless_Strike_thinker:IsAura()	return self:GetAbility() end
function modifier_Advanced_Boundless_Strike_thinker:GetModifierAura()	return "modifier_Advanced_Boundless_Strike_effect" end
function modifier_Advanced_Boundless_Strike_thinker:GetAuraRadius()	return self.radius  end
function modifier_Advanced_Boundless_Strike_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Boundless_Strike_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Boundless_Strike_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_Boundless_Strike_thinker:OnCreated(params)
	if IsServer() then
		self.radius = 500
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/boundless_strike/boundless_strike_model.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,0,0) )
		ParticleManager:ReleaseParticleIndex(effect_cast)

	end
end
function modifier_Advanced_Boundless_Strike_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	UTIL_Remove( self:GetParent() )
end









modifier_Advanced_Boundless_Strike_effect = advanced_modifier({})

function modifier_Advanced_Boundless_Strike_effect:IsHidden()	return false end
function modifier_Advanced_Boundless_Strike_effect:IsDebuff()	return false end
function modifier_Advanced_Boundless_Strike_effect:IsPurgable()	return false end
function modifier_Advanced_Boundless_Strike_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Boundless_Strike_effect:OnCreated(keys)
	self.bonus_range = 200
	self.bonus_damage = 20
	local ability = self:GetAbility()
	if ability then
		if ability:GetSpecialValueFor("advanced_level")>=5 then
			self.bonus_range = self.bonus_range*1.5
			self.bonus_damage = self.bonus_damage*1.5
		end
	end

	if self:GetParent():Script_GetAttackRange()>=1000 then
		self.bonus_range = 0
	end
	if IsServer() then
		if self:GetAbility():GetUnlock(1)==1 then
			self.unlock1 = true
		end
	end
	
end

function modifier_Advanced_Boundless_Strike_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,      
    

	}


	return funcs
end

function modifier_Advanced_Boundless_Strike_effect:GetModifierBaseDamageOutgoing_Percentage()	return self.bonus_damage end
function modifier_Advanced_Boundless_Strike_effect:Advanced_GetModifierAttackRangeBonus()	return self.bonus_range end

function modifier_Advanced_Boundless_Strike_effect:CheckState()
	local state = {}
	
	if self.unlock1 then   
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end


function modifier_Advanced_Boundless_Strike_effect:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end



modifier_Advanced_Boundless_Strike_buff2 = advanced_modifier({})

function modifier_Advanced_Boundless_Strike_buff2:IsHidden()	return false end
function modifier_Advanced_Boundless_Strike_buff2:IsDebuff()	return false end
function modifier_Advanced_Boundless_Strike_buff2:IsPurgable()	return false end
function modifier_Advanced_Boundless_Strike_buff2:OnCreated(keys)
	local stack = 3
	local ability = self:GetAbility()
	local level = ability:GetSpecialValueFor("advanced_level")
	self.bonus = 0
	if ability and level>=10 then
		stack = 5
		if level>=20 then
			self.bonus = ability:GetSpecialValueFor("bonus_damage")*0.5
		end
	end
	if IsServer() then

		self:SetStackCount(stack)
		local caster = self:GetCaster()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true )
		if caster:GetUnitName()=="npc_dota_hero_monkey_king" then
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true )
		else
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
		end


		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end
function modifier_Advanced_Boundless_Strike_buff2:OnRefresh(keys)
	local stack = 3
	local ability = self:GetAbility()
	local level = ability:GetSpecialValueFor("advanced_level")
	self.bonus = 0
	if ability and level>=10 then
		stack = 5
		if level>=20 then
			self.bonus = ability:GetSpecialValueFor("bonus_damage")*0.5
		end
	end
	if IsServer() then

		self:SetStackCount(stack)
	end
end

function modifier_Advanced_Boundless_Strike_buff2:DeclareFunctions()
	local fus = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
    return fus
end




function modifier_Advanced_Boundless_Strike_buff2:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		local parent = self:GetParent()
		if parent:IsInSpecialAttack() then
			return
		end
		local target = keys.target
		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), target:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave = 1,
			iDisableSplit = 1,

		}
		self.attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),keys)
		for _, unit in ipairs(enemies) do
			if unit~=target then
				parent:PerformAttack( unit, true, true, true, true, false, false, true )
			end
		end
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,0,0))
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		parent:EmitSound("Hero_MonkeyKing.Spring.Impact")

		if IsValid(self.attackEffectRecord) then
			self.attackEffectRecord:Destroy()
		end

		self:DecrementStackCount()
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
		
	end
end


function modifier_Advanced_Boundless_Strike_buff2:ADDeclareFunctions()
	local fus = {

	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then

		fus ={
			advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		}
	end
    return fus
end
function modifier_Advanced_Boundless_Strike_buff2:Advanced_GetModifierCriticalStrike(keys)
	return self.bonus
end





-- modifier_Advanced_Boundless_Strike_unlock1_passive = class({})

-- function modifier_Advanced_Boundless_Strike_unlock1_passive:IsDebuff()			return false end
-- function modifier_Advanced_Boundless_Strike_unlock1_passive:IsHidden() 			return true end
-- function modifier_Advanced_Boundless_Strike_unlock1_passive:IsPurgable() 		return false end
-- function modifier_Advanced_Boundless_Strike_unlock1_passive:IsPurgeException() 	return false end
-- function modifier_Advanced_Boundless_Strike_unlock1_passive:RemoveOnDeath() return false end
-- function modifier_Advanced_Boundless_Strike_unlock1_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end


-- function modifier_Advanced_Boundless_Strike_unlock1_passive:OnCreated()
-- 	if IsServer() then
-- 		self.thiker_table = {}
-- 	end
-- end


-- function modifier_Advanced_Boundless_Strike_unlock1_passive:OnDestroy()
-- 	if IsServer() then
-- 		for _, thinker in pairs(self.thiker_table) do
-- 			if thinker and not thinker:IsNull() then
-- 				local modifier = thinker:FindModifierByName("modifier_Advanced_Boundless_Strike_thinker")
-- 				if modifier then
-- 					modifier:Destroy()
-- 				end
-- 			end
-- 		end
-- 	end
-- end