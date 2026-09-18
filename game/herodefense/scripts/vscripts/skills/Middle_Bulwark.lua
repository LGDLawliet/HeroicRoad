
--------------------------------------------------------------------------------
Middle_Bulwark =Middle_Bulwark or  class({})	
LinkLuaModifier( "modifier_Middle_Bulwark", "skills/Middle_Bulwark", LUA_MODIFIER_MOTION_NONE )	--注释掉避免和里技能减伤重复
LinkLuaModifier( "modifier_Middle_Bulwark_mars_talent", "skills/Middle_Bulwark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_steady", "skills/Middle_Bulwark", LUA_MODIFIER_MOTION_NONE )

function Middle_Bulwark:GetIntrinsicModifierName()
	return "modifier_Middle_Bulwark"
end

function Middle_Bulwark:GetBehavior()
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_mars_2") then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	return self.BaseClass.GetBehavior(self)
end

function Middle_Bulwark:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Middle_Bulwark:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Middle_Bulwark:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then

		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_Bulwark_mars_talent", {})
	else


		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Middle_Bulwark_mars_talent", self:GetCaster())
	end
	
end








--------------------------------------------------------------------------------
modifier_Middle_Bulwark = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Bulwark:IsHidden()return false end
function modifier_Middle_Bulwark:IsDebuff()return false end
function modifier_Middle_Bulwark:IsStunDebuff()return false end
function modifier_Middle_Bulwark:IsPurgable() 		return false end
function modifier_Middle_Bulwark:IsPurgeException() 	return false end
function modifier_Middle_Bulwark:RemoveOnDeath()  return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Bulwark:OnCreated( kv )
	-- references
	self.reduction_front = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" )/2
	self.bangbangchance = self:GetAbility():GetSpecialValueFor("bangbangchance")
	self.hp_accumul = self:GetAbility():GetSpecialValueFor("hp_accumul")
	self.mul_index = self:GetAbility():GetSpecialValueFor("mul_index")
	if IsServer() then
		self.parent = self:GetParent()
		if self.parent:GetUnitName()=="npc_dota_hero_mars" then
			self.mars = true
		end
	end
end

function modifier_Middle_Bulwark:OnRefresh( kv )
	-- references
	self.reduction_front = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" )/2
	self.bangbangchance = self:GetAbility():GetSpecialValueFor("bangbangchance")
	self.hp_accumul = self:GetAbility():GetSpecialValueFor("hp_accumul")
	self.mul_index = self:GetAbility():GetSpecialValueFor("mul_index")
end

function modifier_Middle_Bulwark:OnRemoved()
end

function modifier_Middle_Bulwark:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
-- function modifier_Middle_Bulwark:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		
-- 	}

-- 	return funcs
-- end

-- function modifier_Middle_Bulwark:GetModifierPhysical_ConstantBlock( keys )
-- 	-- cancel if from ability
-- 	if keys.inflictor then return 0 end

-- 	-- cancel if break
-- 	if keys.target:PassivesDisabled() then return 0 end

-- 	-- get data
-- 	local parent = keys.target
-- 	local attacker = keys.attacker
-- 	local reduction = 0

-- 	-- Check target position
-- 	local facing_direction = parent:GetAnglesAsVector().y
-- 	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
-- 	local attacker_direction = VectorToAngles( attacker_vector ).y
-- 	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

-- 	-- calculate damage reduction
-- 	if angle_diff < self.angle_front then
-- 		reduction = self.reduction_front
-- 		if self:GetCaster():GetRandomEffect(40,INT_TYPE,1) >=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( true)

-- 	elseif angle_diff < self.angle_side then
-- 		reduction = self.reduction_side
-- 		if self:GetCaster():GetRandomEffect(40,INT_TYPE,1) >=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( false)
-- 	end

-- 	return reduction*keys.damage/100
-- end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_Bulwark:PlayEffects( front )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"

	if not front then
		particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
		sound_cast = "Hero_Mars.Shield.BlockSmall"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	if self.mars then
		self.parent:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_2, 1.5)
	end
end



-- function modifier_Middle_Bulwark:ADDeclareFunctions()
-- 	return {
-- 		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL
-- 	}
-- end
-- function modifier_Middle_Bulwark:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
-- 	if IsClient() then
-- 		return 0
-- 	end
-- 	if keys.block_disabled then
--         return 0 
--     end
-- 	if keys.inflictor then return 0 end
-- 	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
-- 		return 0
-- 	end

-- 	-- cancel if break
-- 	if keys.target:PassivesDisabled() then return 0 end

-- 	-- get data
-- 	local parent = keys.target
-- 	local attacker = keys.attacker
-- 	local reduction = 0

-- 	-- Check target position
-- 	local facing_direction = parent:GetAnglesAsVector().y
-- 	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
-- 	local attacker_direction = VectorToAngles( attacker_vector ).y
-- 	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

-- 	-- calculate damage reduction
-- 	if angle_diff < self.angle_front then
-- 		reduction = self.reduction_front
-- 		if self:GetCaster():GetRandomEffect(40,INT_TYPE,1) >=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( true)

-- 	elseif angle_diff < self.angle_side then
-- 		reduction = self.reduction_side
-- 		if self:GetCaster():GetRandomEffect(40,INT_TYPE,1) >=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( false)
-- 	end

-- 	return reduction*keys.damage/100
-- end


function modifier_Middle_Bulwark:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
				  advanced_MODIFIER_PROPERTY_FALSE_DEATH_MUL_EFFECT,}
	return funcs
end
function modifier_Middle_Bulwark:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	if keys.inflictor then return 0 end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end

	-- cancel if break
	if keys.target:PassivesDisabled() then return 0 end

	-- get data
	local parent = keys.target
	local attacker = keys.attacker
	local reduction = 0

	-- Check target position
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	-- calculate damage reduction
	if angle_diff < self.angle_front then
		reduction = self.reduction_front
		if 40 >=RandomInt(1, 100) then
			reduction = reduction * 2
		end
		self:PlayEffects( true)

	elseif angle_diff < self.angle_side then
		reduction = self.reduction_side
		if 40 >=RandomInt(1, 100) then
			reduction = reduction * 2
		end
		self:PlayEffects( false)
	end
	--同普通部分
	local ability = self:GetAbility()
	local hp_need = self:GetParent():GetMaxHealth()*self.hp_accumul/100
	ability.damage = -keys.damage*reduction/100 + (ability.damage or 0)
	--print("check damage:",ability.damage,",hp_need:",hp_need,",cdcheck:",self.DeathAgainCD)
	self.DeathAgainCD = self.DeathAgainCD or false
	if ability.damage >= hp_need and (self.DeathAgainCD == false) then 
		ability.damage = 0
		local table = {
			mulEffect = true,
			multiTrigger = true,
			unit = self:GetParent(),
			modifier = self,
			ability = self:GetAbility()
		}
		FireDeathAgainEvent(table)
		self.DeathAgainCD = true
		Timers:CreateTimer(3,function()
			self.DeathAgainCD = false
		end)	
		--print("正常触发")
		if self:GetParent():HasModifier("modifier_steady") then
			local modifier_origin =  self:GetParent():FindModifierByName("modifier_steady")
			modifier_origin:SetStackCount(min(modifier_origin:GetStackCount()+1, 10))
		else
			local modifier_origin = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_steady",{duration = -1})
			modifier_origin:SetStackCount(1)
		end
		
	end
	
	return reduction
end

function modifier_Middle_Bulwark:Advanced_GetFalseDeathMulEffect( keys )
	if self.mul_index then
		return self.mul_index
	end
	return 0
end
-------------------------------------------------------------------------------
--基础稳固buff
modifier_steady = class({})
function modifier_steady:IsHidden()return false end
function modifier_steady:IsDebuff()return false end
function modifier_steady:IsStunDebuff()return false end
function modifier_steady:IsPurgable() 		return false end
function modifier_steady:IsPurgeException() 	return false end
function modifier_steady:RemoveOnDeath()  return false end
function modifier_steady:OnCreated()
	self.flag = false
	self.armor = self:GetParent():GetPhysicalArmorValue(false)
	self.flag = true
	self:StartIntervalThink(0.1)
end

function modifier_steady:OnIntervalThink()
	self.armor = 0
	self.flag = false
	self.armor = self:GetParent():GetPhysicalArmorValue(false)
	self.flag = true
end

function modifier_steady:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
end

function modifier_steady:GetModifierPhysicalArmorBonus()
	if self.flag == true then
		return self.armor * self:GetStackCount()*2 * 0.01
	end
	return 0
end
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
modifier_Middle_Bulwark_mars_talent = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Bulwark_mars_talent:IsHidden()return true end
function modifier_Middle_Bulwark_mars_talent:IsDebuff()return false end
function modifier_Middle_Bulwark_mars_talent:IsStunDebuff()return false end
function modifier_Middle_Bulwark_mars_talent:IsPurgable() 		return false end
function modifier_Middle_Bulwark_mars_talent:IsPurgeException() 	return false end
function modifier_Middle_Bulwark_mars_talent:RemoveOnDeath()  return false end
function modifier_Middle_Bulwark_mars_talent:OnRemoved()
end

function modifier_Middle_Bulwark_mars_talent:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_Bulwark_mars_talent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}

	return funcs
end

function modifier_Middle_Bulwark_mars_talent:GetModifierPhysical_ConstantBlock( keys )
	-- cancel if from ability
	if keys.inflictor then return 0 end
	-- cancel if break
	if keys.target:PassivesDisabled() then return 0 end
	local parent = keys.target
	local attacker = keys.attacker
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	-- calculate damage reduction
	if angle_diff < 37.5 then
		self:CheckTrigger()
	end

	return 0
end

function modifier_Middle_Bulwark_mars_talent:CheckTrigger()

	if 18>=RandomInt(1, 100) then
		local ability = self:FindTalentAbility()
		if ability:IsCooldownReady() then
			local rebuke = self:FindGodsRebukeAbility()
			if rebuke then
				local caster = self:GetCaster()
				caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 5)
				rebuke:TalentEffect(caster:GetOrigin()+caster:GetForwardVector()*100)
				ability:UseResources(true, true, true, true)
			end
		end
	end
end
function modifier_Middle_Bulwark_mars_talent:FindTalentAbility()
	if self.talent then
		return self.talent
	end
	self.talent = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_mars_2")
	return self.talent
end
function modifier_Middle_Bulwark_mars_talent:FindGodsRebukeAbility()
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Gods_Rebuke")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Gods_Rebuke")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Gods_Rebuke")
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end

function modifier_Middle_Bulwark_mars_talent:GetActivityTranslationModifiers()
	return "bulwark"
end

function modifier_Middle_Bulwark_mars_talent:GetModifierDisableTurning()
	return 1
end
function modifier_Middle_Bulwark_mars_talent:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_Middle_Bulwark_mars_talent:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	


	return state
end