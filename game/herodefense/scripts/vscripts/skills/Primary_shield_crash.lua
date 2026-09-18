
Primary_shield_crash = Primary_shield_crash or class({})
LinkLuaModifier( "modifier_Primary_shield_crash", "skills/Primary_shield_crash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_shield_crash_debuff", "skills/Primary_shield_crash", LUA_MODIFIER_MOTION_NONE )

function Primary_shield_crash:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_pangolier_shield.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf", context )

end


function Primary_shield_crash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) +  self:GetSpecialValueFor( "bonus_damage" ) * caster:GetMaxHealth()
	local radius = self:GetSpecialValueFor( "radius" )
	local distance = 225
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_pangolier_check") then
		distance = 400
	end
	local duration = 0.5
	local height = 350
	local buff_duration = self:GetSpecialValueFor( "buff_duration" )
	local debuff_duration = self:GetSpecialValueFor( "debuff_duration" )
	-- arc
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			distance = distance,
			duration = duration,
			height = height,
			fix_duration = false,
			isForward = true,
			isStun = true,
			activity = ACT_DOTA_CAST_ABILITY_2,
		} -- kv
	)
	arc:SetEndCallback(function()
		-- find enemies
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- precache damage
		local damageTable = {
			-- victim = target,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		local stack = 0
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	
		for i,enemy in pairs(enemies) do
			if i<=8 then
				damageTable.victim = enemy
				ApplyDamage(damageTable)
				self:PlayEffects4( enemy )
				if enemy:IsAlive() then
					local StatusResistance = enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					enemy:AddNewModifier(caster, self, "modifier_Primary_shield_crash_debuff", {duration =debuff_duration*StatusResistance })
				end
				
			end
			
			stack = stack + 1
			
		end

		-- add buff
		if stack>0 then
			caster:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_Primary_shield_crash", -- modifier name
				{
					duration = buff_duration*caster:GetModifierDurationGainIndex(1),
					stack = stack,
				} -- kv
			)
		end

		self:PlayEffects2()
		if stack>0 then
			self:PlayEffects3()
		end
	end)

	self:PlayEffects1( arc )
end

function Primary_shield_crash:PlayEffects1( modifier )
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Primary_shield_crash:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Primary_shield_crash:PlayEffects3()
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump.Shield"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Primary_shield_crash:PlayEffects4( target )
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end






modifier_Primary_shield_crash =modifier_Primary_shield_crash or advanced_modifier({})
function modifier_Primary_shield_crash:IsHidden()	return false end
function modifier_Primary_shield_crash:IsDebuff()	return false end
function modifier_Primary_shield_crash:IsPurgable()	return true end
function modifier_Primary_shield_crash:OnCreated( kv )
	if not IsServer() then return end
	local stack_pct = self:GetAbility():GetSpecialValueFor( "buff_block" )
	self.reduction = kv.stack * stack_pct
	self:SetStackCount( self.reduction )
	self:PlayEffects()
end

function modifier_Primary_shield_crash:OnRefresh( kv )
	if not IsServer() then return end
	local stack_pct = self:GetAbility():GetSpecialValueFor( "buff_block" )
	-- get stronger value
	local reduction = kv.stack * stack_pct
	if self.reduction<reduction then
		self.reduction = reduction
		self:PlayEffects()
	end

	self:SetStackCount( self.reduction )
end

function modifier_Primary_shield_crash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end
function modifier_Primary_shield_crash:OnTooltip()
    return self:Advanced_GetModifierTotalBlockConstantMaximum()
end


-- function modifier_Primary_shield_crash:GetModifierTotal_ConstantBlock()	return self:GetStackCount() end

function modifier_Primary_shield_crash:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Primary_shield_crash:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if keys.block_disabled then
        return 0 
    end
    return self:GetStackCount()
end



function modifier_Primary_shield_crash:GetStatusEffectName()
	return "particles/status_fx/status_effect_pangolier_shield.vpcf"
end

function modifier_Primary_shield_crash:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end
function modifier_Primary_shield_crash:PlayEffects()
	if self.effect_cast then
		ParticleManager:DestroyParticle( self.effect_cast, false )
	end
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
	local parent = self:GetParent()
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(effect_cast,1,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.reduction, 0, 0 ) )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	
	self.effect_cast = effect_cast
end



modifier_Primary_shield_crash_debuff = modifier_Primary_shield_crash_debuff or class({})

function modifier_Primary_shield_crash_debuff:IsDebuff()			return true end
function modifier_Primary_shield_crash_debuff:IsHidden() 			return false end
function modifier_Primary_shield_crash_debuff:IsPurgable() 			return true end
function modifier_Primary_shield_crash_debuff:OnCreated()
	self.move_slow = -self:GetAbility():GetSpecialValueFor("debuff_slow")
end
function modifier_Primary_shield_crash_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

	} 
end

function modifier_Primary_shield_crash_debuff:GetModifierMoveSpeedBonus_Constant() return self.move_slow end