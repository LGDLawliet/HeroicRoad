
Primary_Viscous_Nasal_Goo = class({})


LinkLuaModifier("modifier_goo_stack", "skills/Primary_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)


function Primary_Viscous_Nasal_Goo:IsHiddenWhenStolen() 		return false end
function Primary_Viscous_Nasal_Goo:IsRefreshable() 			return true  end
function Primary_Viscous_Nasal_Goo:IsStealable() 			return true  end
function Primary_Viscous_Nasal_Goo:IsNetherWardStealable()	return true end

-----[[ CDOTABaseAbility:GetMaxAbilityCharges   ]]
function Primary_Viscous_Nasal_Goo:OnSpellStart(origin,caster_ball)
	local caster = self:GetCaster()
	EmitSoundOn("Hero_Bristleback.ViscousGoo.Cast", caster)
	local target = self:GetCursorTarget()
	self:start(target,caster)
end

function Primary_Viscous_Nasal_Goo:start(target, caster)
		local info1 = 
			{
				Target = target,
				Source = caster,
				Ability = self,	
				EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
				iMoveSpeed = 1000,
				vSourceLoc= caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,	
				ExtraData = {hit = 1}   --额外的数据
			}
		if target ~= nil then
			ProjectileManager:CreateTrackingProjectile(info1)
		end        
end
function Primary_Viscous_Nasal_Goo:start2(target, caster ,pfx)
	local info1 = 
		{
			Target = target,
			Source = caster,
			Ability = self,	
			EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
			iMoveSpeed = 1000,
			vSourceLoc= caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = false,	
			-- ExtraData = {hit = 0}   --额外的数据
		}
	if target ~= nil then
		ProjectileManager:CreateTrackingProjectile(info1)
	end        
end

function Primary_Viscous_Nasal_Goo:OnProjectileHit_ExtraData(target, pos,keys)
	local caster = self:GetCaster()
	if not target then
		return
	end
	if target:TriggerSpellAbsorb(self) then
		return
	end 
	if keys.hit then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.35)*ModifierStatusNegativeGain

		target:AddNewModifier(caster,self,"modifier_goo_stack",{duration = self:GetSpecialValueFor("duration")*StatusResistance})
	end
end


	
--鼻涕叠加
modifier_goo_stack=advanced_modifier({})
function modifier_goo_stack:IsHidden() return false end
function modifier_goo_stack:IsPurgable() return true end
function modifier_goo_stack:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end
function modifier_goo_stack:GetStatusEffectName()
	return "particles/status_fx/status_effect_goo.vpcf"
end
function modifier_goo_stack:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	} 
end

function modifier_goo_stack:Advanced_GetModifierPhysicalArmorBonus() return self.base_armor + self:GetStackCount()*self.stack_armor end
function modifier_goo_stack:GetModifierMoveSpeedBonus_Constant() return self.base_slow + self:GetStackCount()*self.stack_slow end
function modifier_goo_stack:OnCreated()
	self.base_armor = self:GetAbility():GetSpecialValueFor("base_armor")*-1
	self.stack_armor = self:GetAbility():GetSpecialValueFor("armor_per_stack")*-1
	self.base_slow = self:GetAbility():GetSpecialValueFor("base_move_slow")*-1
	self.stack_slow = self:GetAbility():GetSpecialValueFor("move_slow_per_stack")*-1
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_goo_stack:OnRefresh()
	if IsServer() then
		local limit = self:GetAbility():GetSpecialValueFor("stack_limit")
		self:SetStackCount( math.min( self:GetStackCount() + 1, limit)) 
	end
end



function modifier_goo_stack:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

