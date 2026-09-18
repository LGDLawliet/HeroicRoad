Middle_Time_Drain = class({})
LinkLuaModifier( "modifier_Middle_Time_Drain", "skills/Middle_Time_Drain", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Time_Drain_time_controler", "skills/Middle_Time_Drain", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function Middle_Time_Drain:GetIntrinsicModifierName()
	return "modifier_Middle_Time_Drain"
end

-- function Middle_Time_Drain:GetCooldown(iLevel)
-- 	return 1.5 /self:GetCaster():GetCooldownReduction()
-- end
function Middle_Time_Drain:IsRefreshable() return false end


modifier_Middle_Time_Drain = class({})

-----------------------------------------------------------------------------------------

function modifier_Middle_Time_Drain:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_Middle_Time_Drain:IsPurgable() 		return false end
function modifier_Middle_Time_Drain:IsPurgeException() 	return false end
function modifier_Middle_Time_Drain:RemoveOnDeath()  return false end
function modifier_Middle_Time_Drain:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------

function modifier_Middle_Time_Drain:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_Middle_Time_Drain:OnCreated( kv )
end

-----------------------------------------------------------------------------------------

function modifier_Middle_Time_Drain:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------

function modifier_Middle_Time_Drain:OnAttackLanded( params )
	local Attacker = params.attacker
	local Target = params.target
	if not IsServer() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end

	--自己是攻击者
	if Attacker == self:GetParent() then
		if self:GetAbility():GetSpecialValueFor( "chance" ) > RandomInt(0,100)  then
			if self:GetRemainingTime()>0 then
				return
			end
			self.cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction" )
			self.healthRegen_index = self:GetAbility():GetSpecialValueFor( "healthRegen_index" )
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

			local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_end.vpcf", PATTACH_ROOTBONE_FOLLOW, Attacker)

			local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse_b.vpcf", PATTACH_ROOTBONE_FOLLOW, Target)
			--后期需调整
			for i=0, self:GetParent():GetAbilityCount() - 1 do
				local Ability = self:GetParent():GetAbilityByIndex(i)
				if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility() and  Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
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
				if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()and not Ability:IsCooldownReady()  then
					local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduction
					self.cooldown_reduction = self.cooldown_reduction *0.8
					Ability:EndCooldown()
					if newCooldown>=0 then
						Ability:StartCooldown(newCooldown)
					end
				end
			end
			ParticleManager:ReleaseParticleIndex(particle1)
			ParticleManager:ReleaseParticleIndex(particle2)
			EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster())
			-- self:GetAbility():UseResources(false, false, true)
			self:SetDuration(1.5, true)
			--self:GetAbility():CastAbility()
		end
		
	end

	--自己是被攻击者
	if Target==self:GetParent() and 10>=RandomInt(1, 100)  then
		if not Target:HasModifier("modifier_Middle_Time_Drain_time_controler") then
			EmitSoundOn( "Hero_FacelessVoid.TimeWalk", Target)
			Target:AddNewModifier(Target, self:GetAbility(), "modifier_Middle_Time_Drain_time_controler", {duration = 0.1})
		end
	end

	-- if Target==self:GetParent() and RandomInt(1, 100)<=10  then
	-- 	EmitSoundOn( "Hero_FacelessVoid.TimeWalk", Target)
	-- 	Target:AddNewModifier(Target, self:GetAbility(), "modifier_Middle_Time_Drain_time_controler", {duration = 0.1})
	-- end

end


modifier_Middle_Time_Drain_time_controler = advanced_modifier({})  

function modifier_Middle_Time_Drain_time_controler:IsDebuff()			return false end
function modifier_Middle_Time_Drain_time_controler:IsHidden() 			return true end
function modifier_Middle_Time_Drain_time_controler:IsPurgable() 		return false end
function modifier_Middle_Time_Drain_time_controler:IsPurgeException() 	return false end
-- function modifier_Middle_Time_Drain_time_controler:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Middle_Time_Drain_time_controler:CheckState() return { [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Middle_Time_Drain_time_controler:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -100
end


function modifier_Middle_Time_Drain_time_controler:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
