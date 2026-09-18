

LinkLuaModifier("modifier_Primary_necromastery", "skills/Primary_necromastery", LUA_MODIFIER_MOTION_NONE)

Primary_necromastery = Primary_necromastery or  class({})


function Primary_necromastery:GetIntrinsicModifierName()
	return "modifier_Primary_necromastery"
end




modifier_Primary_necromastery = class({})


function modifier_Primary_necromastery:IsHidden()	return false end
function modifier_Primary_necromastery:IsDebuff()	return false end
function modifier_Primary_necromastery:IsPurgable()	return false end
function modifier_Primary_necromastery:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_Primary_necromastery:OnCreated( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_Primary_necromastery:OnRefresh( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
end

function modifier_Primary_necromastery:OnDestroy()
	if IsServer() then
		self:GetParent().necromastery_stack = self:GetStackCount()
	end
end

--------------------------------------------------------------------------------

function modifier_Primary_necromastery:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- soul release
function modifier_Primary_necromastery:OnDeath( params )
	if IsServer() then


		local unit = params.unit
		local attacker = params.attacker
		if unit==self:GetParent() and params.reincarnate==false then
			local after_death = math.floor(self:GetStackCount() * (1-self:GetAbility():GetSpecialValueFor("soul_lost")*0.01))
			self:SetStackCount(math.max(after_death,1))
			return
		elseif attacker and attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() and unit~=self:GetParent() and self:GetParent():IsAlive() then
			if self:GetParent():PassivesDisabled() then
				return 
			end
			self:AddStack(1)
			self:PlayEffects( unit )
		end

	end
end

function modifier_Primary_necromastery:GetModifierPreAttack_BonusDamage( params )
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage
	end
end


function modifier_Primary_necromastery:AddStack( value )
	local max_stack = self:GetAbility():GetSpecialValueFor("max_soul")
	if self:GetParent():HasAbility("heroTalent_npc_dota_hero_nevermore_2") then
		max_stack = math.floor(max_stack*1.6)
	end
	self:SetStackCount( math.min(self:GetStackCount()+value,max_stack) )
end

function modifier_Primary_necromastery:PlayEffects( target )
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