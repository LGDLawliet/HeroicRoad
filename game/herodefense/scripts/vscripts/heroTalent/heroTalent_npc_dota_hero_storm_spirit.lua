heroTalent_npc_dota_hero_storm_spirit = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_storm_spirit", "heroTalent/heroTalent_npc_dota_hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_storm_spirit_buff", "heroTalent/heroTalent_npc_dota_hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_storm_spirit_debuff", "heroTalent/heroTalent_npc_dota_hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_storm_spirit:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_storm_spirit:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_storm_spirit:IsStealable() 				return true end
function heroTalent_npc_dota_hero_storm_spirit:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_storm_spirit:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_storm_spirit" end


modifier_heroTalent_npc_dota_hero_storm_spirit = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_storm_spirit:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not IsServer() then return end
end


function modifier_heroTalent_npc_dota_hero_storm_spirit:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_storm_spirit:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self.parent then return end

	-- not for items
	if params.ability:IsItem() then return end
	if params.ability:GetCooldown(params.ability:GetLevel())<3 then
		return
	end
	if self.parent:PassivesDisabled() then return end
	if not self:GetParent():IsRealHero() then
		return false
	end
	-- add buff
	self.parent:AddNewModifier(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_heroTalent_npc_dota_hero_storm_spirit_buff", -- modifier name
		{} -- kv
	)
end







modifier_heroTalent_npc_dota_hero_storm_spirit_buff = class({})

function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:OnCreated(keys)
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
	end
end








function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker==self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local damageTable = {

				attacker = parent,
				damage = parent:GetIntellect(false)*1.5,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability, 
			}

			local enemies = FindUnitsInRadius(
			parent:GetTeamNumber(),	-- int, your team number
			keys.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
			)
			local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
			
			for _,enemy in pairs(enemies) do
				-- damage
				damageTable.victim = enemy
				ApplyDamage( damageTable )
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier(parent,ability, "modifier_heroTalent_npc_dota_hero_storm_spirit_debuff", { duration = 0.6*StatusResistance } )
			end
			self:PlayEffects( keys.target )
			self:SafeDestroy()
		end
	end
end


function modifier_heroTalent_npc_dota_hero_storm_spirit_buff:PlayEffects( target )
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









modifier_heroTalent_npc_dota_hero_storm_spirit_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:IsPurgable()	return true end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:GetModifierAttackSpeedBonus_Constant()
	return -20
end

function modifier_heroTalent_npc_dota_hero_storm_spirit_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -60
end