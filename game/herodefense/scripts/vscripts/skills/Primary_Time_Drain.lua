Primary_Time_Drain = class({})
LinkLuaModifier( "modifier_Primary_Time_Drain", "skills/Primary_Time_Drain", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function Primary_Time_Drain:GetIntrinsicModifierName()
	return "modifier_Primary_Time_Drain"
end

-- function Primary_Time_Drain:GetCooldown(iLevel)
-- 	return 1.5 /self:GetCaster():GetCooldownReduction()
-- end
function Primary_Time_Drain:IsRefreshable() return false end




modifier_Primary_Time_Drain = class({})

-----------------------------------------------------------------------------------------

function modifier_Primary_Time_Drain:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_Primary_Time_Drain:IsPurgable() 		return false end
function modifier_Primary_Time_Drain:IsPurgeException() 	return false end
function modifier_Primary_Time_Drain:RemoveOnDeath()  return false end
function modifier_Primary_Time_Drain:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------

function modifier_Primary_Time_Drain:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_Primary_Time_Drain:OnCreated( kv )
end

-----------------------------------------------------------------------------------------

function modifier_Primary_Time_Drain:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------

function modifier_Primary_Time_Drain:OnAttackLanded( params )
	if self:GetParent():PassivesDisabled() then
		return
	end

	if IsServer() and self:GetAbility():GetSpecialValueFor( "chance" ) > RandomInt(0,100)  then
		if self:GetRemainingTime()>0 then
			return
		end
		self.cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction" )
		self.healthRegen_index = self:GetAbility():GetSpecialValueFor( "healthRegen_index" )
		local Attacker = params.attacker
		local Target = params.target
		if Target == nil or Attacker == nil or Attacker ~= self:GetParent() then
			return 0
		end
		local HealthRegen_damage = self.healthRegen_index * Target:GetHealthRegen() 
		if HealthRegen_damage < 0 then
			HealthRegen_damage = HealthRegen_damage * -1 
		end

		local damagetable =
		{
			victim = Target,
			attacker = Attacker,
			damage = HealthRegen_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
		--ApplyDamage( damagetable )	
		local particle = "particles/units/heroes/hero_abaddon/abaddon_borrowed_time_end.vpcf"
		ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, Attacker)
		particle = "particles/units/heroes/hero_weaver/weaver_timelapse_b.vpcf"
        ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, Target)
		--后期需调整
		for i=0, self:GetParent():GetAbilityCount() - 1 do
			local Ability = self:GetParent():GetAbilityByIndex(i)
			if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()  and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
				local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduction
				self.cooldown_reduction = self.cooldown_reduction *0.8
				Ability:EndCooldown()
				if newCooldown>=0 then
					Ability:StartCooldown(newCooldown)
				end
			end
		end
		
		for i=0, 9 do
			local Ability = self:GetParent():GetItemInSlot(i)
			if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility() and not Ability:IsCooldownReady()  then
				local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduction
				self.cooldown_reduction = self.cooldown_reduction *0.8
				Ability:EndCooldown()
				if newCooldown>=0 then
					Ability:StartCooldown(newCooldown)
				end
			end
		end
		
		EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster())
		-- self:GetAbility():UseResources(false, false, true)
		self:SetDuration(1.5, true)
		--self:GetAbility():CastAbility()
	end
end