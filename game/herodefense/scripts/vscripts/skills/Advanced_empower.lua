--特效优化 √
Advanced_empower = class({})
LinkLuaModifier( "modifier_Advanced_empower", "skills/Advanced_empower", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_empower_unlock3", "skills/Advanced_empower", LUA_MODIFIER_MOTION_NONE )
require("internal/timers")

--------------------------------------------------------------------------------
-- Init Abilities
function Advanced_empower:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_hit.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context )
end
function Advanced_empower:CheckKV(key)
	local table = {

		bonus_damage_pct =0.7,
		cleave_damage_pct = 0.4,



	}
	local value = table[key] or -1
	return value

end

function Advanced_empower:UnlockFirstCore(key)
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_rubick" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock1 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true
end
function Advanced_empower:UnlockSecondCore(key)
	return true
end
function Advanced_empower:UnlockThirdCore(key)
	-- if not self:GetCaster():HasAbility("heroTalent_npc_dota_hero_riki") then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_empower_unlock3",{})
	
	return true
end





function Advanced_empower:OnAbilityPhaseStart()
	-- play Advanced_empower
	if self:GetSpecialValueFor("advanced_level")>=15 then
		local target = self:GetCursorTarget()
		-- print(target)
		self:PlayEffects1(target)
	end
	

	return true -- if success
end

function Advanced_empower:OnAbilityPhaseInterrupted()
	self:StopEffects( true )
end
function Advanced_empower:SpellLV15Effect(target,radius)
	local caster = self:GetCaster()
	local radius = radius

	local duration = 1.5
	local range = 150

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

	local pos = target:GetOrigin() + target:GetForwardVector() * range
	for _,enemy in pairs(enemies) do
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		local origin = enemy:GetOrigin()
		
		FindClearSpaceForUnit( enemy, pos, true )
		enemy:AddNewModifier(caster, self,"modifier_stunned",{ duration = duration *StatusResistance})
		self:PlayEffects2( enemy, origin )
	end

	local sound_cast = "Hero_Magnataur.ReversePolarity.Cast"
	EmitSoundOn( sound_cast, caster )
end

function Advanced_empower:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	duration = duration*ModifierStatusGain
	if self.unlock1 then
		duration = -1
	end
	target:AddNewModifier(caster, self, "modifier_Advanced_empower", { duration = duration } )

	-- play effects
	local sound_cast = "Hero_Magnataur.Empower.Cast"
	local sound_target = "Hero_Magnataur.Empower.Target"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )

	if self.advanced_level>=15 then
		self:StopEffects( false )
		self:SpellLV15Effect(target,500)
	end

	if self.advanced_level>=20 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if unit~=target then
				unit:AddNewModifier(caster, self, "modifier_Advanced_empower", { duration = duration } )
				break
			end
		end
	end
end


function Advanced_empower:AddStack()
	if self.stack then
		self.stack = self.stack + 1
	else
		self.stack = 1
	end
end
function Advanced_empower:RemoveStack()
	self.stack = self.stack - 1
end

function Advanced_empower:GetStackBonus()
	local max = 5
	if not self or self:IsNull() then
		return
	end
	if self:GetSpecialValueFor("advanced_level")>=10 then
		max = 8
	end
	return (math.min(self.stack,max)*0.08)+1
end


function Advanced_empower:PlayEffects1(target)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	local radius = 500
	local castpoint = self:GetCastPoint()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( castpoint, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, target:GetForwardVector() )

	self.effect_cast = effect_cast

	EmitSoundOn( sound_cast, target )
end
function Advanced_empower:StopEffects( interrupted )

	if self.effect_cast then
		ParticleManager:DestroyParticle( self.effect_cast, interrupted )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
		local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
		StopSoundOn( sound_cast, self:GetCaster() )
		self.effect_cast = nil
	end
	
end

function Advanced_empower:PlayEffects2( target, origin )

	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Stun"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, target )
end

function Advanced_empower:PlayUnlockEffects(target,radius)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
	local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"

	local radius = radius
	-- local castpoint = self:GetCastPoint()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 0.2, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, target:GetForwardVector() )



	EmitSoundOn( sound_cast, target )
	Timers:CreateTimer(0.2, function()
		if effect_cast then
			ParticleManager:DestroyParticle( effect_cast, false )
			ParticleManager:ReleaseParticleIndex( effect_cast )
			local sound_cast = "Hero_Magnataur.ReversePolarity.Anim"
			StopSoundOn( sound_cast, self:GetParent() )
		end
	end)
end



modifier_Advanced_empower = class({})

function modifier_Advanced_empower:IsHidden()	return false end
function modifier_Advanced_empower:IsDebuff()	return false end
function modifier_Advanced_empower:IsPurgable()	return true end


function modifier_Advanced_empower:OnCreated( kv )
	self.ability = self:GetAbility()

	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" )


	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )
	if self:GetCaster()==self:GetParent() and self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_magnataur_2") then
		self.damage = self.damage *2.5
		self.cleave = self.cleave *2.5
	end

	self.ability:AddStack()
	if not IsServer() then return end
	self.unlock2_chance = 0
	if self.ability.unlock2 then
		local parent = self:GetParent()
		
		if parent:IsRangedAttacker() then
			if parent:IsRealHero() then
				self.unlock2_chance = 2
			else
				self.unlock2_chance = 0.7
			end
		else
			if parent:IsRealHero() then
				self.unlock2_chance = 7
			else
				self.unlock2_chance = 2
			end
		end
	end

end

function modifier_Advanced_empower:OnRefresh( kv )
	self.ability:RemoveStack()
	self:OnCreated(kv)
end
function modifier_Advanced_empower:OnDestroy()
	self.ability:RemoveStack()
end

function modifier_Advanced_empower:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end

	return funcs
end



function modifier_Advanced_empower:OnTooltip()
	return self.cleave*self.ability:GetStackBonus() 
end

function modifier_Advanced_empower:GetModifierProcAttack_Feedback( keys )
	if not IsServer() then return end
	if keys.attacker:IsRangedAttacker() then return end
	if not self.ability or self.ability:IsNull() then
		return
	end
	if keys.attacker:IsDisableCleave() then
		return
	end
	local damage = keys.damage*self.cleave  *self.ability:GetStackBonus() /100

	
	local units = DoHDCleaveAttack(keys.attacker, keys.target, self.ability, damage, 
	self.radius_start,
	self.radius_end, 
	self.radius_dist, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf")

	for _, unit in ipairs(units) do
		if unit~=keys.target then
			local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
			-- ParticleManager:SetParticleControlEnt( pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(pfx, 1,Vector(0,0,1))
			ParticleManager:SetParticleControlEnt( pfx,2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end

	self:SetStackCount(math.min(math.max(0,#units-1),15))

end

function modifier_Advanced_empower:GetModifierBaseDamageOutgoing_Percentage()	
	if not self.ability or self.ability:IsNull() then
		return
	end
	return self.damage*self.ability:GetStackBonus() 
end
function modifier_Advanced_empower:GetEffectName()	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf" end
function modifier_Advanced_empower:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end



function modifier_Advanced_empower:GetModifierPreAttack_BonusDamage(keys)
	if keys.attacker == self:GetParent() and keys.target then	
		if not self.ability or self.ability:IsNull() then
			return
		end
		local index = 15
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
			index = 23
		end
		return self:GetStackCount()*index*self.ability:GetStackBonus()
	end
end




function modifier_Advanced_empower:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if self.unlock2_chance   > RandomFloat(1, 100) then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end
		
		ability:SpellLV15Effect(keys.target,350)
		ability:PlayUnlockEffects(keys.target,350)

				
		
	end

	
end






modifier_Advanced_empower_unlock3 = class({})

function modifier_Advanced_empower_unlock3:IsHidden()	return true end
function modifier_Advanced_empower_unlock3:IsDebuff()	return false end
function modifier_Advanced_empower_unlock3:IsPurgable()	return false end
function modifier_Advanced_empower_unlock3:IsPurgeException() return false end
function modifier_Advanced_empower_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_empower_unlock3:OnCreated()
	if IsServer() then
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "dota_on_summon", Dynamic_Wrap( self, 'OnSummonTrigger' ),self )
	end
end
function modifier_Advanced_empower_unlock3:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		end
	end
end

function modifier_Advanced_empower_unlock3:OnSummonTrigger(keys)

	if IsServer() then
		local unit =  EntIndexToHScript(keys.unit)
		local target =  EntIndexToHScript(keys.target)
		if not IsEnemy(unit,self:GetParent()) then

			
			local ability 					= self:GetAbility()
			local caster = self:GetCaster()
			local duration = keys.duration
			if not duration or duration<=0 then
				duration = -1
			else
				local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
				duration = duration *0.5*ModifierStatusGain
			end

			target:AddNewModifier(caster, ability, "modifier_Advanced_empower", { duration = duration } )
		
			-- play effects
			local sound_cast = "Hero_Magnataur.Empower.Cast"
			local sound_target = "Hero_Magnataur.Empower.Target"
			EmitSoundOn( sound_cast, caster )
			EmitSoundOn( sound_target, target )
		
			ability:SpellLV15Effect(target,500)
			ability:PlayUnlockEffects(target,500)

		end
	end
end
