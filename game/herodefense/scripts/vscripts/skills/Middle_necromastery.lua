

LinkLuaModifier("modifier_Middle_necromastery", "skills/Middle_necromastery", LUA_MODIFIER_MOTION_NONE)

Middle_necromastery = Middle_necromastery or  class({})
require('internal/timers')   --计时器功能

function Middle_necromastery:GetIntrinsicModifierName()
	return "modifier_Middle_necromastery"
end




modifier_Middle_necromastery = advanced_modifier({})


function modifier_Middle_necromastery:IsHidden()	return false end
function modifier_Middle_necromastery:IsDebuff()	return false end
function modifier_Middle_necromastery:IsPurgable()	return false end
function modifier_Middle_necromastery:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_Middle_necromastery:OnCreated( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			if self:GetParent().necromastery_stack then
				self:SetStackCount(self:GetParent().necromastery_stack )
			else
				self:SetStackCount(0)
			end
		end)

		
	end
end

function modifier_Middle_necromastery:OnRefresh( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
end



function modifier_Middle_necromastery:OnDestroy()
	if IsServer() then
		self:GetParent().necromastery_stack = self:GetStackCount()
	end
end
--------------------------------------------------------------------------------

function modifier_Middle_necromastery:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- soul release
function modifier_Middle_necromastery:OnDeath( params )
	if IsServer() then

		
		local unit = params.unit
		local attacker = params.attacker
		if unit==self:GetParent() and params.reincarnate==false then
			local after_death = math.floor(self:GetStackCount() * (1-self:GetAbility():GetSpecialValueFor("soul_lost")*0.01))
			self:SetStackCount(math.max(after_death,1))
			return
		elseif attacker and attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() and unit~=self:GetParent() and self:GetParent():IsAlive() then
			if self:GetParent():PassivesDisabled() then
				return 0 
			end
			self:AddStack(1)
			self:PlayEffects( unit )
		end

	end
end

function modifier_Middle_necromastery:GetModifierPreAttack_BonusDamage( params )
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage
	end
end


function modifier_Middle_necromastery:AddStack( value )
	local max_stack = self:GetAbility():GetSpecialValueFor("max_soul")
	if self:GetParent():HasAbility("heroTalent_npc_dota_hero_nevermore_2") then
		max_stack = math.floor(max_stack*1.6)
	end
	self:SetStackCount( math.min(self:GetStackCount()+value,max_stack) )
end

function modifier_Middle_necromastery:PlayEffects( target )
	-- Get Resources
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- CreateProjectile
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end



-- function modifier_Middle_necromastery:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if self:GetParent():PassivesDisabled() then
-- 		return 0 
-- 	end
-- 	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
-- 		return self:GetStackCount()*0.3
-- 	end
-- end



-- advanced_modifier
function modifier_Middle_necromastery:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Middle_necromastery:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then
		return 0
	end
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
		return self:GetStackCount()*0.3
	end
end

