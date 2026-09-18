--特效优化 √
Advanced_enchant_totem = class({})
LinkLuaModifier( "modifier_Advanced_enchant_totem", "skills/Advanced_enchant_totem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_enchant_totem_buff", "skills/Advanced_enchant_totem", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_enchant_totem_unlock1", "skills/Advanced_enchant_totem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_enchant_totem_unlock3", "skills/Advanced_enchant_totem", LUA_MODIFIER_MOTION_NONE )
function Advanced_enchant_totem:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf", context )


	PrecacheResource( "particle", "particles/units/heroes/hero_ursa/ursa_earthshock_soil.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ursa/ursa_earthshock_rocks.vpcf", context )

	
	PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2.vpcf", context )








	
end
function Advanced_enchant_totem:CheckKV(key)
	local table = {
		bonus_damage =20,
	}
	local value = table[key] or -1
	return value

end
function Advanced_enchant_totem:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_enchant_totem:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_enchant_totem:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_enchant_totem_unlock3",{})
	
	return true
end
function Advanced_enchant_totem:GetCastRange()
	local caster = self:GetCaster()
	return math.min(2000,950 + caster:GetCastRangeBonus())-caster:GetCastRangeBonus()

end

function Advanced_enchant_totem:GetCastPoint()
	if not IsServer() then
		return 0.5
	end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target~=caster then
		return 1
	end

	return self.BaseClass.GetCastPoint( self )
end



--------------------------------------------------------------------------------
-- Ability Phase Start
function Advanced_enchant_totem:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	if target==caster then return true end

	if target then
		point = target:GetAbsOrigin()
	end
	-- load data
	local duration = 1
	local height = 900
	local distance = (point - caster:GetOrigin()):Length2D()
	if self.unlock1 then
		height = 5000
		self.unlock1_modifier = caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_enchant_totem_unlock1", -- modifier name
			{
				duration = duration+0.03,
			}
		)
	end
	-- add arc modifier
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = point.x,
			target_y = point.y,
			distance = distance,
			duration = duration,
			height = height,
			fix_end = false,
			isForward = true,
			-- isRestricted = true,
		} -- kv
	)
	
	arc:SetEndCallback(function()
		if not self.interrupted then return end
		self.interrupted = nil

		-- do normal
		self:OnSpellStart()
		self:UseResources( true, false, true,true )
	end)

	return true
end
function Advanced_enchant_totem:OnAbilityPhaseInterrupted()
	self.interrupted = true
	if self.unlock1_modifier and not self.unlock1_modifier:IsNull() then
		self.unlock1_modifier:PhaseInterruptedDestroy()
	end
end
--------------------------------------------------------------------------------
-- Ability Start
function Advanced_enchant_totem:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	-- if self.unlock1_modifier and not self.unlock1_modifier:IsNull() then
	-- 	self.unlock1_modifier:NormalDestroy()
	-- end
	-- load data
	local duration = self:GetSpecialValueFor("duration")


	local Gain = caster:GetModifierDurationGainIndex(1)
	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_enchant_totem", -- modifier name
		{ duration = duration*Gain } -- kv
	)

	-- Effects
	local sound_cast = "Hero_EarthShaker.Totem"
	EmitSoundOn( sound_cast, caster )
end





modifier_Advanced_enchant_totem = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_enchant_totem:IsHidden()	return false end
function modifier_Advanced_enchant_totem:IsDebuff()	return false end
function modifier_Advanced_enchant_totem:IsPurgable()	return false end
function modifier_Advanced_enchant_totem:OnCreated( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) 
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) 
	if IsServer() then
		self.deelay = false
		self:PlayEffects()
	end
end

function modifier_Advanced_enchant_totem:OnRefresh( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) 
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" )
end

function modifier_Advanced_enchant_totem:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_enchant_totem:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

	}
	if self:GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE)
	end

	return funcs
end
function modifier_Advanced_enchant_totem:GetModifierDamageOutgoing_Percentage()
	return 50
end
function modifier_Advanced_enchant_totem:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end
function modifier_Advanced_enchant_totem:GetActivityTranslationModifiers( params )
	return "enchant_totem"
end

function modifier_Advanced_enchant_totem:GetModifierProcAttack_Feedback( keys )
	if IsServer() then
		if self.deelay then
			return
		end
		if keys.damage<=0 then
			return
		end
		local ability = self:GetAbility()
		if not keys.attacker:IsDisableCleave() then
			local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			table.remove(enemies,1)  --移除目标

		
			local damage_index = 0.5
			local radius = 500
			if ability.advanced_level>=5 then
				damage_index = 0.8
				if ability.advanced_level>=10 then
					radius = 700
				end
			end
			local damage =  keys.damage*damage_index
			local damageTable = {
				attacker = keys.attacker,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
			}
			for _, enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)	
			end
			
			-- effects
			local sound_cast = "Hero_EarthShaker.Totem.Attack"
			EmitSoundOn( sound_cast, keys.target )
			if not keys.attacker.enchant_totem then
				keys.attacker.enchant_totem = true
				local units = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.attacker:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
				local count = 0
				local max = 3
				for _, unit in ipairs(units) do
					if unit~=keys.attacker and not unit:IsDisarmed() then
						count = count + 1
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =0,
							iDisableSplit = 0,
					
						}
						local attackEffectRecord = unit:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
						unit.enchant_totem = true
						local modifier = unit:AddNewModifier(keys.attacker, ability, "modifier_Advanced_enchant_totem_buff", {duration = 1})
						unit:PerformAttack( keys.target, true, true, true, true, false, false, true )
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						unit.enchant_totem = false
						if modifier then
							modifier:SafeDestroy()
						end
						if count>=max then
							break					
						end
					end
				end
				keys.attacker.enchant_totem = false
			end
	
	
		end

		if ability.advanced_level>=15 and 20>=RandomInt(1, 100) then
			return
		end
	

		if not self.deelay then
			self.deelay = true
			if ability.advanced_level>=20 then
				if ability.unlock2 then

					self:GetCaster():GameTimer(1, function()
						if IsValid(self) then
							self:Destroy()
						end
					end)
				else
					self:GetCaster():GameTimer(0.03, function()
						if IsValid(self) then
							self:Destroy()
						end
					end)
				end
				
			else
				self:Destroy()
			end
		end
	
		


		
	end
end

function modifier_Advanced_enchant_totem:Advanced_GetModifierAttackRangeBonus()
	return self.range
end

function modifier_Advanced_enchant_totem:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_enchant_totem:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end
function modifier_Advanced_enchant_totem:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	
    }
end

function modifier_Advanced_enchant_totem:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return 
	end

	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return -60
	end
end



modifier_Advanced_enchant_totem_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_enchant_totem_buff:IsHidden()	return true end
function modifier_Advanced_enchant_totem_buff:IsDebuff()	return false end
function modifier_Advanced_enchant_totem_buff:IsPurgable()	return true end
function modifier_Advanced_enchant_totem_buff:OnCreated( kv )
	-- references
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
		self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) *0.75
	else
		self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) *0.5
	end

end
function modifier_Advanced_enchant_totem_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_Advanced_enchant_totem_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end






modifier_Advanced_enchant_totem_unlock1 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_enchant_totem_unlock1:IsHidden()	return true end
function modifier_Advanced_enchant_totem_unlock1:IsDebuff()	return false end
function modifier_Advanced_enchant_totem_unlock1:IsPurgable()	return false end
function modifier_Advanced_enchant_totem_unlock1:OnCreated()
	if IsServer() then
		-- self.scale = 1
		-- self:StartIntervalThink(FrameTime())
	end
end

function modifier_Advanced_enchant_totem_unlock1:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if self.no_damage then
			return
		end
		local radius = 600
		local pos = GetGroundPosition(parent:GetOrigin(),nil)
		local particle_cast = "particles/units/heroes/hero_ursa/ursa_earthshock_soil.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
		-- ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		-- ParticleManager:SetParticleControl( effect_cast, 2, Vector( 0.2, 0, 0 ) )
		ParticleManager:SetParticleControl( effect_cast, 0,pos)
		ParticleManager:ReleaseParticleIndex(effect_cast)

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ursa/ursa_earthshock_rocks.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0,pos)
		ParticleManager:ReleaseParticleIndex(effect_cast)

		-- local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_WORLDORIGIN, nil )
		-- ParticleManager:SetParticleControl( effect_cast, 0,pos)
		-- ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		-- ParticleManager:ReleaseParticleIndex(effect_cast)


		
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0,pos)
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( effect_cast, 3, Vector( 0, 0, 0 ) )
		ParticleManager:SetParticleControl( effect_cast, 10, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( effect_cast, 11, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex(effect_cast)
		
		parent:EmitSound("Greevil.EchoSlam")


		local enemies = FindUnitsInRadius(
			parent:GetTeamNumber(),	-- int, your team number
			parent:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = parent:GetAverageTrueAttackDamage(nil) * 2
		local damageTable = {
			attacker = parent,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
			}



		for i,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
	end
end
-- function modifier_Advanced_enchant_totem_unlock1:OnIntervalThink()
-- 	local parent = self:GetParent()
-- 	parent:SetModelScale(self.scale)
-- 	self.scale = math.min(self.scale +0.6,15)
-- end
function modifier_Advanced_enchant_totem_unlock1:DeclareFunctions() return 
	{

		MODIFIER_PROPERTY_MODEL_SCALE,

	} 
end

function modifier_Advanced_enchant_totem_unlock1:GetModifierModelScale() 
    return 1000
end


-- function modifier_Advanced_enchant_totem_unlock1:NormalDestroy()
-- 	self:SafeDestroy()
-- end
function modifier_Advanced_enchant_totem_unlock1:PhaseInterruptedDestroy()
	self.no_damage = true
	self:SafeDestroy()
end




modifier_Advanced_enchant_totem_unlock3 = class({})


function modifier_Advanced_enchant_totem_unlock3:IsHidden()	return true end
function modifier_Advanced_enchant_totem_unlock3:IsDebuff()	return false end
function modifier_Advanced_enchant_totem_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_enchant_totem_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_enchant_totem_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_enchant_totem_unlock3:IsPurgable() 		return false end
function modifier_Advanced_enchant_totem_unlock3:IsPurgeException() 	return false end

function modifier_Advanced_enchant_totem_unlock3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_enchant_totem_unlock3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if self:GetCaster():GetRandomEffect(10,INT_TYPE,0.5)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end
		ability:OnSpellStart()
	end
end