--特效优化 √
Advanced_shield_crash = Advanced_shield_crash or class({})
LinkLuaModifier( "modifier_Advanced_shield_crash_motion", "skills/Advanced_shield_crash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_shield_crash", "skills/Advanced_shield_crash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_shield_crash_debuff", "skills/Advanced_shield_crash", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_Advanced_shield_crash_unlock3", "skills/Advanced_shield_crash", LUA_MODIFIER_MOTION_NONE )
function Advanced_shield_crash:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_pangolier_shield.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf", context )

end
function Advanced_shield_crash:CheckKVFixedOverride(key)
	if key=="AbilityCharges" then
		if self:GetSpecialValueFor("advanced_level")>=5 then
			return 4
		end
	end
	-- if key=="AbilityChargeRestoreTime" then
	-- 	if self:GetUnlock(1)==1 then
	-- 		return 2
	-- 	end
	-- end

	return -999999

end
function Advanced_shield_crash:CheckKV(key)
	local table = {
		damage = 10,
		bonus_damage = 0.005,
		buff_block = 0.3,


	}
	local value = table[key] or -1
	return value

end

function Advanced_shield_crash:UnlockFirstCore(key)
	return true
end
function Advanced_shield_crash:UnlockSecondCore(key)
	return true
end
function Advanced_shield_crash:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_shield_crash_unlock3",{})
	return true
end








function Advanced_shield_crash:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")


	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function Advanced_shield_crash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local cast = 0
	if self.unlock2 then
		cast = 3
	end
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_shield_crash_motion", -- modifier name
		{
			cast = cast,
			duration = 10,
		} 
	)
end
function Advanced_shield_crash:CauseSpellEffect(unlock2_cast,pos)
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "damage" ) +  self:GetSpecialValueFor( "bonus_damage" ) * caster:GetMaxHealth()
	damage = damage + caster:GetPhysicalArmorValue(false)*10
	local radius = self:GetSpecialValueFor( "radius" )
	local buff_duration = self:GetSpecialValueFor( "buff_duration" )
	local debuff_duration = self:GetSpecialValueFor( "debuff_duration" )
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
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

	if unlock2_cast>0 then
		for i,enemy in pairs(enemies) do
			if i<=8 then
				damageTable.victim = enemy
				ApplyDamage(damageTable)
				self:PlayEffects4( enemy )
				if enemy:IsAlive() then
					local StatusResistance = enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					enemy:AddNewModifier(caster, self, "modifier_Advanced_shield_crash_debuff", {duration =debuff_duration*StatusResistance })
					if math.min( caster:GetRandomEffect(7,INT_TYPE,1),15)  > RandomInt(1, 100) then
						enemy:AddNewModifier(
							caster, -- player source
							self, -- ability source
							"modifier_Advanced_shield_crash_motion", -- modifier name
							{
								cast = unlock2_cast-1,
								duration = 5,
							} 
						)
					end
				end
				
			end
			
			stack = stack + 1
			
		end
	else
		for i,enemy in pairs(enemies) do
			if i<=8 then
				damageTable.victim = enemy
				ApplyDamage(damageTable)
				self:PlayEffects4( enemy )
				if enemy:IsAlive() then
					local StatusResistance = enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					enemy:AddNewModifier(caster, self, "modifier_Advanced_shield_crash_debuff", {duration =debuff_duration*StatusResistance })

				end
				
			end
			
			stack = stack + 1
			
		end
	end



	if stack>0 then
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_shield_crash", -- modifier name
			{
				duration = buff_duration*caster:GetModifierDurationGainIndex(1),
				stack = stack,
			} -- kv
		)
	end

	self:PlayEffects2(pos)
	if stack>0 then
		self:PlayEffects3(pos)
	end
end
function Advanced_shield_crash:PlayEffects1( modifier )
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

function Advanced_shield_crash:PlayEffects2(pos)
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, pos)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Advanced_shield_crash:PlayEffects3(pos)
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump.Shield"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Advanced_shield_crash:PlayEffects4( target )
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end






modifier_Advanced_shield_crash =modifier_Advanced_shield_crash or advanced_modifier({})
function modifier_Advanced_shield_crash:IsHidden()	return false end
function modifier_Advanced_shield_crash:IsDebuff()	return false end
function modifier_Advanced_shield_crash:IsPurgable()	return true end
function modifier_Advanced_shield_crash:OnCreated( kv )
	self.armor_index = 0.05
	local ability = self:GetAbility()
	if ability:GetSpecialValueFor("advanced_level")>=10 then
		self.armor_index = 1/15
	end
	if not IsServer() then return end
	local stack_pct = self:GetAbility():GetSpecialValueFor( "buff_block" )
	self.reduction = kv.stack * stack_pct
	self:SetStackCount( self.reduction )
	self:PlayEffects()
end

function modifier_Advanced_shield_crash:OnRefresh( kv )
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

function modifier_Advanced_shield_crash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_Advanced_shield_crash:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierTotalBlockConstantMaximum()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end

function modifier_Advanced_shield_crash:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_Advanced_shield_crash:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if keys.block_disabled then
        return 0 
    end
    return self:GetStackCount()
end

function modifier_Advanced_shield_crash:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetStackCount()*self.armor_index 
end









function modifier_Advanced_shield_crash:GetStatusEffectName()
	return "particles/status_fx/status_effect_pangolier_shield.vpcf"
end

function modifier_Advanced_shield_crash:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end
function modifier_Advanced_shield_crash:PlayEffects()
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



modifier_Advanced_shield_crash_debuff = modifier_Advanced_shield_crash_debuff or class({})

function modifier_Advanced_shield_crash_debuff:IsDebuff()			return true end
function modifier_Advanced_shield_crash_debuff:IsHidden() 			return false end
function modifier_Advanced_shield_crash_debuff:IsPurgable() 			return true end
function modifier_Advanced_shield_crash_debuff:OnCreated()
	self.move_slow = -self:GetAbility():GetSpecialValueFor("debuff_slow")
end
function modifier_Advanced_shield_crash_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

	} 
end

function modifier_Advanced_shield_crash_debuff:GetModifierMoveSpeedBonus_Constant() return self.move_slow end





modifier_Advanced_shield_crash_motion = modifier_Advanced_shield_crash_motion  or class({})

function modifier_Advanced_shield_crash_motion:IsDebuff()			return false end
function modifier_Advanced_shield_crash_motion:IsHidden() 			return true end
function modifier_Advanced_shield_crash_motion:IsPurgable() 			return false end
function modifier_Advanced_shield_crash_motion:IsPurgeException() return false end
function modifier_Advanced_shield_crash_motion:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		self.distance = 225
		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_pangolier_check") then
			self.distance = 400
		end
		self.duration = 0.5
		self.height = 350
		self.v15Chance = 0
		if ability.unlock1 then
			self.unlock1 = true
			self.height = self.height + math.min(caster:GetPhysicalArmorValue(false)*1.5,1000)
		end
		if ability.advanced_level>=15 then
			self.lv15Chance = 35
			if ability:GetAutoCastState() then
				self.lv15Chance = 100
				self.height = self.height * 2
				self.distance = 225*3
			end
		end
		if keys.unlock3 and keys.unlock3==1 then
			self.distance = 10
			self.duration = 0.15
		end
		if self:GetParent()~=caster then
			self.distance = 50
		end
		self.unlock2_cast = 0
		if keys.cast then
			self.unlock2_cast = keys.cast
		end
		
		self:Trigger()
	end
end

function modifier_Advanced_shield_crash_motion:Trigger()
	
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local arc = parent:AddNewModifier(
		parent, -- player source
		ability, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			distance = self.distance,
			duration = self.duration,
			height = self.height,
			fix_duration = true,
			isForward = true,
			isStun = true,
			activity = ACT_DOTA_CAST_ABILITY_2,
		} -- kv
	)
	arc:SetEndCallback(function()
		-- find enemies
		if not ability then
			self:SafeDestroy()
			return
		end
		ability:CauseSpellEffect(self.unlock2_cast,parent:GetOrigin())
		if not parent:IsAlive() then
			self:SafeDestroy()
			return
		end
		if self.unlock1 and self.height>150 then
			self.height = self.height *0.9 -50
			self.distance = self.distance *0.5
			self:Trigger()
		else
			self:SafeDestroy()
			return
		end
	end)
	if self.lv15Chance and self.lv15Chance>0 and caster:GetRandomEffect(self.lv15Chance,INT_TYPE,1)  > RandomInt(1, 100) then
		ability:CauseSpellEffect(self.unlock2_cast,parent:GetOrigin())
	end

	ability:PlayEffects1( arc )


	
end








modifier_Advanced_shield_crash_unlock3 = modifier_Advanced_shield_crash_unlock3  or class({})

function modifier_Advanced_shield_crash_unlock3:IsDebuff()			return false end
function modifier_Advanced_shield_crash_unlock3:IsHidden() 			return true end
function modifier_Advanced_shield_crash_unlock3:IsPurgable() 			return false end
function modifier_Advanced_shield_crash_unlock3:IsPurgeException() return false end
function modifier_Advanced_shield_crash_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_shield_crash_unlock3:DestroyOnExpire() return false end
function modifier_Advanced_shield_crash_unlock3:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.dis = 0
        self.currentPos = self.parent:GetAbsOrigin()
        self:StartIntervalThink(0.06)     

    end
end
function modifier_Advanced_shield_crash_unlock3:OnIntervalThink()
	if self.parent:HasModifier("modifier_Advanced_shield_crash_motion") then
		return
	end
    self.dis =self.dis+ CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    self.currentPos = self.parent:GetAbsOrigin()
	local need = math.max(1000 - self.parent:GetPhysicalArmorValue(false),500)
	if self:GetRemainingTime()>0 then
		return
	end
    if self.dis>=need then
		if not self:GetAbility():GetAutoCastState() then
			return
		end
		self.dis = 0
        self:SetDuration(0.4, false)
		self.parent:AddNewModifier(
			self.parent, -- player source
			self:GetAbility(), -- ability source
			"modifier_Advanced_shield_crash_motion", -- modifier name
			{
				cast = 0,
				duration = 10,
				unlock3 = 1,
			} 
		)
    end

end
