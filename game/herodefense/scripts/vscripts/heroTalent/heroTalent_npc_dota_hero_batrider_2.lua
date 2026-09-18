LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_batrider_2", "heroTalent/heroTalent_npc_dota_hero_batrider_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_batrider_2_caster", "heroTalent/heroTalent_npc_dota_hero_batrider_2.lua", LUA_MODIFIER_MOTION_NONE )


if heroTalent_npc_dota_hero_batrider_2 == nil then
	heroTalent_npc_dota_hero_batrider_2 = class({})
end

function heroTalent_npc_dota_hero_batrider_2:Unlockachievement()
	-- print("ok")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_batrider_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("binder_1")
		end
	end

end




function heroTalent_npc_dota_hero_batrider_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf", context )

end





function heroTalent_npc_dota_hero_batrider_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_batrider_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_batrider_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_batrider_2:IsNetherWardStealable()		return true end
-- function heroTalent_npc_dota_hero_batrider_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_batrider_2" end
function heroTalent_npc_dota_hero_batrider_2:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function heroTalent_npc_dota_hero_batrider_2:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end



function heroTalent_npc_dota_hero_batrider_2:OnSpellStart()
	if self.modifier and not self.modifier:IsNull() then
		self.modifier:SafeDestroy()
	end
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	-- caster:EmitSound("Ability.static.start")
	self.modifier = target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_batrider_2", {duration =-1})
	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_batrider_2_caster", {duration =-1,target	= target:entindex()})

end


modifier_heroTalent_npc_dota_hero_batrider_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_batrider_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_batrider_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_batrider_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_batrider_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_batrider_2:RemoveOnDeath() return true end
-- function modifier_heroTalent_npc_dota_hero_batrider_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_batrider_2:GetPriority() return 9999 end
function modifier_heroTalent_npc_dota_hero_batrider_2:OnCreated(keys)
	if IsServer() then
		self:GetCaster():EmitSound("Hero_Batrider.FlamingLasso.Cast")
		self:StartIntervalThink(FrameTime())
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "lasso_attack", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		
		self.thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_generic_soundPlayer", {duration = 10,attach_caster = 1}, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false)
		self.thinker:EmitSound("Hero_Batrider.FlamingLasso.Loop")

		self.achievement_timer = GameRules:GetGameTime()+15
	end
end
function modifier_heroTalent_npc_dota_hero_batrider_2:OnIntervalThink()

	local parnet = self:GetParent()
	if parnet:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	local pos_caster = caster:GetAbsOrigin()
	local pos_target = parnet:GetAbsOrigin()
	local dis = CalculateDistance(pos_caster,pos_target)
	if dis>400 then
		if dis>=2000 then
			FindClearSpaceForUnit(parnet, pos_caster-caster:GetForwardVector()*399, true)
			return
		end
		-- local direction = (pos_caster-pos_target):Normalized()
		local direction = (pos_target-pos_caster):Normalized()
		direction.z = 0  
		
		-- local speed = dis
		-- local dt = FrameTime()
		-- local new_pos = parnet:GetAbsOrigin() + direction * (speed / (1.0 / dt))  
		local new_pos = pos_caster +direction*399
		new_pos = GetGroundPosition(new_pos, nil)   
		parnet:SetOrigin(new_pos)  
		-- ResolveNPCPositions(new_pos, 70)
		-- FindClearSpaceForUnit(parnet, new_pos, true)
	end
	

end


function modifier_heroTalent_npc_dota_hero_batrider_2:OnDestroy()

	if IsServer() then
		
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		self:GetCaster():EmitSound("Hero_Batrider.FlamingLasso.End")
		ParticleManager:DestroyParticle(self.nFXIndex,false)
		-- StopSoundEvent( "Ability.static.loop", self:GetCaster())
		if not self.thinker:IsNull() then
			self.thinker:StopSound("Hero_Batrider.FlamingLasso.Loop")
			self.thinker:FindModifierByName("modifier_generic_soundPlayer"):SafeDestroy()
		end
		local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_batrider_2_caster")
		if modifier then
			modifier:SafeDestroy()
		end

		if GameRules:GetGameTime()>= self.achievement_timer then
			self:GetAbility():Unlockachievement()
		end
	end
end
function modifier_heroTalent_npc_dota_hero_batrider_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,

		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end


function modifier_heroTalent_npc_dota_hero_batrider_2:Advanced_GetModifierAttackRangeBonus(params)
	return 250
end
function modifier_heroTalent_npc_dota_hero_batrider_2:GetModifierMoveSpeed_Limit(params)
	return 1
end

function modifier_heroTalent_npc_dota_hero_batrider_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetName()=="Default_Move" then
		self:SafeDestroy()
	end

end

function modifier_heroTalent_npc_dota_hero_batrider_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

modifier_heroTalent_npc_dota_hero_batrider_2_caster = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_batrider_2_caster:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:IsPurgeException() return false end
-- function modifier_heroTalent_npc_dota_hero_batrider_2_caster:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:OnCreated(keys)
	self.bonus_move = 100
	if IsServer() then
		self.target = EntIndexToHScript(keys.target)
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"binder_1") then
			-- print("获得奖励")
			self.bonus_move =self.bonus_move+15
		end
	end
end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:OnDestroy()
	if IsServer() then
		if self.target and not self.target:IsNull() then
			local modifier = self.target:FindModifierByName("modifier_heroTalent_npc_dota_hero_batrider_2")
			if modifier then
				modifier:SafeDestroy()
			end
		end
	end
end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end

function modifier_heroTalent_npc_dota_hero_batrider_2_caster:GetOverrideAnimation(params)
	return ACT_DOTA_LASSO_LOOP
end
function modifier_heroTalent_npc_dota_hero_batrider_2_caster:GetModifierMoveSpeedBonus_Constant(params)
	return self.bonus_move
end



function modifier_heroTalent_npc_dota_hero_batrider_2_caster:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying,

    }
end

function modifier_heroTalent_npc_dota_hero_batrider_2_caster:Advanced_GetModifier_Flying()	
	return 1
end


