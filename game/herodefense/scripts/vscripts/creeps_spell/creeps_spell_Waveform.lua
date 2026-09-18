
creeps_spell_Waveform = class({})
LinkLuaModifier("modifier_creeps_spell_Waveform_motion", "creeps_spell/creeps_spell_Waveform", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Waveform_Upgrade", "creeps_spell/creeps_spell_Waveform", LUA_MODIFIER_MOTION_NONE)
-- require("internal/abilitychargecontroller")
function creeps_spell_Waveform:IsHiddenWhenStolen() 		return false end
function creeps_spell_Waveform:IsRefreshable() 			return true end
function creeps_spell_Waveform:IsStealable() 			return true end
function creeps_spell_Waveform:IsNetherWardStealable()	return true end

------------------------------------------------------------------------------------------------------------------------------------------
function creeps_spell_Waveform:GetCastRange(location , target)
	if IsClient() then
		return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
	end
end

-- function creeps_spell_Waveform:OnUpgrade()
-- 	--充能设置
-- 	if not AbilityChargeController:IsChargeTypeAbility(self) then
-- 		AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
-- 	else
-- 		AbilityChargeController:ChangeChargeAbilityConfig(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
-- 	end
-- end

function creeps_spell_Waveform:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local direction = (target_pos - caster_pos):Normalized()
	direction.z = 0.0
	local range = self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus()
	local speed = self:GetSpecialValueFor("speed")

	local pos = ((target_pos - caster_pos):Length2D() <= range) and target_pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_Waveform_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	caster:EmitSound("Hero_Morphling.Waveform")
	ProjectileManager:ProjectileDodge(caster)
end

modifier_creeps_spell_Waveform_motion = class({})

function modifier_creeps_spell_Waveform_motion:IsDebuff()			return false end
function modifier_creeps_spell_Waveform_motion:IsHidden() 			return true end
function modifier_creeps_spell_Waveform_motion:IsPurgable() 		return false end
function modifier_creeps_spell_Waveform_motion:IsPurgeException() 	return false end
function modifier_creeps_spell_Waveform_motion:IsStunDebuff()		return true end
--状态无敌
function modifier_creeps_spell_Waveform_motion:CheckState() 
	return 
	{
		[MODIFIER_STATE_ROOTED] = true,
	 	[MODIFIER_STATE_DISARMED] = true,
	  	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	   	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true ,
		[MODIFIER_STATE_INVULNERABLE] = true ,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	} 
end

function modifier_creeps_spell_Waveform_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_creeps_spell_Waveform_motion:GetModifierDisableTurning() return 1 end
function modifier_creeps_spell_Waveform_motion:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_creeps_spell_Waveform_motion:IsMotionController() return true end
function modifier_creeps_spell_Waveform_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_creeps_spell_Waveform_motion:OnCreated(keys)
	if IsServer() then
		self.hitted = {}
		self.hitted_friendly = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.damageTable = {
			attacker = self:GetParent(),
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
------------------------------------------------------------------------------------------------------------------------------------------
			--特效
			local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
			--local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			local pfx_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetUpVector() * 50
			ParticleManager:SetParticleControl(self.pfx, 0, pfx_pos)
			ParticleManager:SetParticleControl(self.pfx, 1, (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.speed)
			self:AddParticle(self.pfx, false, false, 15, false, false)
------------------------------------------------------------------------------------------------------------------------------------------
		else
			self:SafeDestroy()
		end
	end
end

function modifier_creeps_spell_Waveform_motion:OnIntervalThink()
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	local width = self:GetAbility():GetSpecialValueFor("width")
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	--local enemies = FindUnitsInRadius(

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(),
	nil, width,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER, false)
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(),
	nil, width,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER, false)

	table.insert(self.hitted_friendly,self:GetAbility():GetCaster())
	for _, unit in pairs(units) do
		if not IsInTable(unit, self.hitted_friendly) then
			unit:AddNewModifier(unit, self:GetAbility(), "modifier_creeps_spell_Waveform_Upgrade", {})
			table.insert(self.hitted_friendly,unit)
		end
	end
	--------------------------------------------------
	local damage = self:GetAbility():GetSpecialValueFor("damage" ) * self:GetCaster():GetBaseDamageMax()
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			if not enemy:IsMagicImmune() then 
				--造成伤害
				self.damageTable.victim = enemy
				self.damageTable.damage = damage
				ApplyDamage(self.damageTable)
				table.insert(self.hitted,enemy)
			end
		end
	end
end

function modifier_creeps_spell_Waveform_motion:OnDestroy() 
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.hitted = nil
		self.pos = nil
		self.speed = nil
		self:GetParent():SetForwardVector(Vector(self:GetParent():GetForwardVector()[1], self:GetParent():GetForwardVector()[2], 0))
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

	end
end



modifier_creeps_spell_Waveform_Upgrade = advanced_modifier({})

function modifier_creeps_spell_Waveform_Upgrade:IsDebuff()			return false end
function modifier_creeps_spell_Waveform_Upgrade:IsHidden() 			return false end
function modifier_creeps_spell_Waveform_Upgrade:IsPurgable() 		return false end
function modifier_creeps_spell_Waveform_Upgrade:IsPurgeException() 	return false end

function modifier_creeps_spell_Waveform_Upgrade:GetTexture()
    return "morphling_waveform"
end

function modifier_creeps_spell_Waveform_Upgrade:OnCreated()
    self:IncrementStackCount()
end
function modifier_creeps_spell_Waveform_Upgrade:OnRefresh(table)
    self:IncrementStackCount()
end

function modifier_creeps_spell_Waveform_Upgrade:DeclareFunctions() return 
    {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP} 
end

function modifier_creeps_spell_Waveform_Upgrade:GetModifierBaseDamageOutgoing_Percentage() 
    return self:GetStackCount()*2
end

function modifier_creeps_spell_Waveform_Upgrade:GetModifierAttackSpeedBonus_Constant() 
    return self:GetStackCount()*3
end



-- advanced_modifier



function modifier_creeps_spell_Waveform_Upgrade:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end

function modifier_creeps_spell_Waveform_Upgrade:AdvancedGetModifierExtraHealthPercentage(keys)
	return self:GetStackCount()*2
end






function modifier_creeps_spell_Waveform_Upgrade:OnTooltip()
	return self:AdvancedGetModifierExtraHealthPercentage()
end













