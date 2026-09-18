Middle_Overload =Middle_Overload or class({})

LinkLuaModifier("modifier_Middle_Overload", "skills/Middle_Overload", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Overload_buff", "skills/Middle_Overload", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Overload_debuff", "skills/Middle_Overload", LUA_MODIFIER_MOTION_NONE)

function Middle_Overload:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", context )

	

end

function Middle_Overload:IsHiddenWhenStolen() 		return false end
function Middle_Overload:IsRefreshable() 			return true end
function Middle_Overload:IsStealable() 				return true end
function Middle_Overload:IsNetherWardStealable()		return true end
function Middle_Overload:GetIntrinsicModifierName() return "modifier_Middle_Overload" end


modifier_Middle_Overload =modifier_Middle_Overload or  class({})

function modifier_Middle_Overload:IsHidden()	return true end
function modifier_Middle_Overload:IsDebuff()	return false end
function modifier_Middle_Overload:IsStunDebuff()	return false end
function modifier_Middle_Overload:IsPurgable()	return false end
function modifier_Middle_Overload:IsPurgeException() return false end
function modifier_Middle_Overload:RemoveOnDeath() return false end
function modifier_Middle_Overload:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not IsServer() then return end
end


function modifier_Middle_Overload:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_Middle_Overload:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self.parent then return end
	if params.ability:IsItem() then return end
	if params.ability:GetCooldown(params.ability:GetLevel())<2 then
		return
	end
	if self.parent:PassivesDisabled() then return end
	self.parent:AddNewModifier(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_Middle_Overload_buff", -- modifier name
		{} -- kv
	)
end







modifier_Middle_Overload_buff = modifier_Middle_Overload_buff or class({})

function modifier_Middle_Overload_buff:IsHidden()	return false end
function modifier_Middle_Overload_buff:IsDebuff()	return false end
function modifier_Middle_Overload_buff:IsStunDebuff()	return false end
function modifier_Middle_Overload_buff:IsPurgable()	return false end

function modifier_Middle_Overload_buff:OnCreated(keys)
	if IsServer() then
		local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack1",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
		self:SetStackCount(1)
	end
end

function modifier_Middle_Overload_buff:OnRefresh()
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,10))
	end
end






function modifier_Middle_Overload_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_Middle_Overload_buff:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker==self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local damageTable = {

				attacker = parent,
				damage = parent:HDGetPrimaryStatValue()*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"),
				damage_type = ability:GetAbilityDamageType(),
				ability = ability, 
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
			}

			local enemies = FindUnitsInRadius(
			parent:GetTeamNumber(),	-- int, your team number
			keys.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
			)
			local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
			local duration = ability:GetSpecialValueFor("duration")
			

			damageTable.victim = keys.target
			ApplyDamage( damageTable )
			local StatusResistance =keys.target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
			keys.target:AddNewModifier(parent,ability, "modifier_Middle_Overload_debuff", { duration =math.max( duration*StatusResistance,0.1) } )
			local count = 3
			for _,enemy in pairs(enemies) do
				if enemy~=keys.target then
					count = count - 1
					damageTable.victim = enemy
					ApplyDamage( damageTable )
					local StatusResistance =enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					enemy:AddNewModifier(parent,ability, "modifier_Middle_Overload_debuff", { duration =math.max( duration*StatusResistance,0.1) } )
					if count<=0 then
						break
					end
				end
				
			end
			self:PlayEffects( keys.target )
			self:DecrementStackCount()
			if self:GetStackCount()<=0 then
				self:SafeDestroy()
			end
		end
	end
end


function modifier_Middle_Overload_buff:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
	local sound_cast = "Hero_StormSpirit.Overload"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end









modifier_Middle_Overload_debuff =modifier_Middle_Overload_debuff or  class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Overload_debuff:IsHidden()	return false end
function modifier_Middle_Overload_debuff:IsDebuff()	return true end
function modifier_Middle_Overload_debuff:IsStunDebuff()	return false end
function modifier_Middle_Overload_debuff:IsPurgable()	return true end
function modifier_Middle_Overload_debuff:OnCreated()
	local ability = self:GetAbility()
	self.move_slow = -ability:GetSpecialValueFor("move_slow")
	self.attack_slow = -ability:GetSpecialValueFor("attack_slow")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_Overload_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Middle_Overload_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end

function modifier_Middle_Overload_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.move_slow
end