
creeps_spell_Energy_Convergence = class({})
LinkLuaModifier("modifier_creeps_spell_Energy_Convergence", "creeps_spell/creeps_spell_Energy_Convergence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Energy_Convergence_debuff", "creeps_spell/creeps_spell_Energy_Convergence", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Energy_Convergence_death", "creeps_spell/creeps_spell_Energy_Convergence", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Energy_Convergence:GetIntrinsicModifierName()
	return "modifier_creeps_spell_Energy_Convergence"
end
function creeps_spell_Energy_Convergence:Spawn()
	if IsServer() then
		if self:GetCaster():GetUnitName()=="npc_monster_wave_22_1" then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creeps_spell_Energy_Convergence_death", {})
		end
		
	end
end



-- Fury swipes debuff
modifier_creeps_spell_Energy_Convergence_debuff = class({})


function modifier_creeps_spell_Energy_Convergence_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_creeps_spell_Energy_Convergence_debuff:IsDebuff() return true end
function modifier_creeps_spell_Energy_Convergence_debuff:IsHidden() return false end
function modifier_creeps_spell_Energy_Convergence_debuff:IsPurgable() 		return false end
function modifier_creeps_spell_Energy_Convergence_debuff:IsPurgeException() 	return false end
function modifier_creeps_spell_Energy_Convergence_debuff:RemoveOnDeath()  return false end

function modifier_creeps_spell_Energy_Convergence_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_creeps_spell_Energy_Convergence_debuff:OnTooltip()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_damage") 
end



-- Fury Swipes modifier buff
modifier_creeps_spell_Energy_Convergence = class({})
function modifier_creeps_spell_Energy_Convergence:IsDebuff()return false end
function modifier_creeps_spell_Energy_Convergence:IsHidden()return true end
function modifier_creeps_spell_Energy_Convergence:IsPurgable() return false end
function modifier_creeps_spell_Energy_Convergence:DeclareFunctions()
	return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}
end

function modifier_creeps_spell_Energy_Convergence:GetModifierProcAttack_BonusDamage_Physical( keys )
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local target = keys.target
		local ability = self:GetAbility()
		local fury_swipes_debuff = "modifier_creeps_spell_Energy_Convergence_debuff"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")
		-- Ability specials
		local damage_per_stack = ability:GetSpecialValueFor("bonus_damage") * caster:GetBaseDamageMax()*0.01
		local stack_duration = ability:GetSpecialValueFor("duration")
		-- If the caster is broken, do nothing
		if caster:PassivesDisabled() then
			return nil
		end
		-- If the caster is an illusion, do nothing
		if caster:IsIllusion() then
			return nil
		end
        if keys.attacker == caster then

			-- "Does not work against buildings, wards and allied units when attacking them."
			-- If the target is a building, do nothing
			if target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				return nil
			end
			
			-- Add debuff/increment stacks if already exists
			local fury_swipes_debuff_handler = target:AddNewModifier(caster, ability, fury_swipes_debuff, {duration = stack_duration})
			local fury_swipes_stacks = 0
			if fury_swipes_debuff_handler then
				fury_swipes_debuff_handler:IncrementStackCount()
                fury_swipes_debuff_handler:ForceRefresh()
                fury_swipes_stacks = fury_swipes_debuff_handler:GetStackCount()
			end

			-- Refresh stack duration
			

			-- Add fury swipe impact particle
			-- Get stack count
			

			-- Calculate damage
			local damage = damage_per_stack * fury_swipes_stacks

			return damage
		end
	end
end


require('internal/timers')   --计时器功能
modifier_creeps_spell_Energy_Convergence_death = class({})

function modifier_creeps_spell_Energy_Convergence_death:IsDebuff()			return false end
function modifier_creeps_spell_Energy_Convergence_death:IsHidden() 			return true end
function modifier_creeps_spell_Energy_Convergence_death:IsPurgable() 		return false end
function modifier_creeps_spell_Energy_Convergence_death:IsPurgeException() 	return false  end
function modifier_creeps_spell_Energy_Convergence_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_fire_death.vpcf", context )
end

function modifier_creeps_spell_Energy_Convergence_death:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_fire_death.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		local scale = parent:GetModelScale()
		local timer = 0
		Timers:CreateTimer(FrameTime(), function()
			timer = timer + FrameTime()
			if timer>=0.4 then
				parent:AddNoDraw()
				return nil
			end
			scale = scale*0.95
			parent:SetModelScale(scale)

			return FrameTime()
			
		end)
	end
end