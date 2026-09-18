LinkLuaModifier("modifier_chaotic_sunbeam_buff", "chaotic_spell/class_6/chaotic_sunbeam", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_sunbeam_debuff", "chaotic_spell/class_6/chaotic_sunbeam", LUA_MODIFIER_MOTION_NONE)

chaotic_sunbeam = class({})

function chaotic_sunbeam:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_sunbeam/effect_beam/lucent_beam_moonfall_gold.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_sunbeam/effect_beam/lucent_beam_impact_bits_ti_5_gold.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_sunbeam/effect_beam_buff/sprites.vpcf", context )
end

function chaotic_sunbeam:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function chaotic_sunbeam:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetRuneType()==1 and self:GetAutoCastState() and not self:GetCaster():HasModifier("modifier_chaotic_sunbeam_buff") then
		local bonus_cost = self:GetSpecialValueFor("rune_1_bonus_cost")*0.01
		cost = cost * (1+bonus_cost)
	end
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_sunbeam:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end

function chaotic_sunbeam:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end

function chaotic_sunbeam:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function chaotic_sunbeam:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = 30000 - caster:GetCastRangeBonus()
	end

	local target_pos = caster_loc + direction*distance
	
	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(200,200,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_sunbeam:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function chaotic_sunbeam:GetCastRange()
	if IsClient() then
		return 30000
	end
	local caster = self:GetCaster()
	local distance = self:GetSpecialValueFor("distance") - caster:GetCastRangeBonus()
	if self:GetRuneType()==2 then
		distance = 30000 - caster:GetCastRangeBonus()
	end
	return distance
end

function chaotic_sunbeam:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_chaotic_sunbeam_buff") then
		return self:GetSpecialValueFor("cooldown_override")
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end

function chaotic_sunbeam:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = 30000 - caster:GetCastRangeBonus()
		if 25 >= math.random(1,100) then
			local messages = {
				"都亮起来吧！",
				"我胱QR秒了！",
				"如果我道歉，你会原谅我吗？",
				"道歉的对象，是你唷！",
			}
			Say(caster, messages[math.random(1,#messages)], true)
		end
	end
	local target_pos = caster_loc + direction* distance+ Vector(0,0,64) 

	local gain = self:GetEffectGain()
	self:ApplyEffect(caster_loc,target_pos,gain)
	if self:GetRuneType()==1 and self:GetAutoCastState() and not caster:HasModifier("modifier_chaotic_sunbeam_buff") then
		local count = self:GetSpecialValueFor("rune_1_count")
		for i = 1, count, 1 do
			caster:GameTimer(i*0.15, function()
				if IsValid(self) then
					self:ApplyEffect(caster_loc,target_pos,gain)
				end
				
			end)
			
		end
		return
	end

	if not caster:HasModifier("modifier_chaotic_sunbeam_buff") then
		local cooldown_record = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("cooldown_override"))
		caster:AddNewModifier(caster, self, "modifier_chaotic_sunbeam_buff", {duration =self:GetSpecialValueFor("duration"),cooldown_record=cooldown_record})
	end
end


function chaotic_sunbeam:ApplyEffect(source_pos,target_pos,gain)
	local caster = self:GetCaster()
	local burning = caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("burning")
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_sunbeam/effect_beam/lucent_beam_moonfall_gold.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 0, source_pos  )

	local damageTable = {
		attacker	= self:GetCaster(),
		-- victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"))*gain,
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
		hd_flags 	= HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE
	}
	local debuff_duration = self:GetSpecialValueFor("debuff_duration")*caster:GetModifierStatusNegativeGainIndex(0.7)

	ParticleManager:SetParticleControlEnt( pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControl( pfx, 1, target_pos)
	ParticleManager:SetParticleControl( pfx, 2, target_pos)
	ParticleManager:SetParticleControl( pfx, 5, target_pos)
	ParticleManager:SetParticleControl( pfx, 6, target_pos)
	-- ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("Hero_Luna.LucentBeam.Cast")

	local team = DOTA_UNIT_TARGET_TEAM_ENEMY
	if self:GetRuneType() == 3 then
		team = DOTA_UNIT_TARGET_TEAM_BOTH
	end
	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), source_pos, target_pos,nil, self:GetSpecialValueFor("width"),
	team,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)

	for i, unit in pairs(tTargets) do
		self:PlayEffect(unit)
		if team == DOTA_UNIT_TARGET_TEAM_BOTH and not IsEnemy(unit, caster) then
			local fhealing =  HealWithGain(damageTable.damage*0.4, caster,unit,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil) 
			-- 弱驱散
			unit:Purge(false, true, false, false, false)
		else
			damageTable.victim = unit
			ApplyDamage(damageTable)
			if IsValid(unit) and unit:IsAlive() then
				unit:Burning(caster, self, burning)
				unit:AddNewModifier(caster, self, "modifier_chaotic_sunbeam_debuff", {duration =debuff_duration*unit:GetHDStatusResistanceIndex(0.7)})
			end
		end
	end
end

function chaotic_sunbeam:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_sunbeam/effect_beam/lucent_beam_impact_bits_ti_5_gold.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	-- target:EmitSound("chaotic_mass_cure_wounds_target")
end
--------------

modifier_chaotic_sunbeam_buff = advanced_modifier({})

function modifier_chaotic_sunbeam_buff:IsHidden() return false end
function modifier_chaotic_sunbeam_buff:IsPurgable() return false end
function modifier_chaotic_sunbeam_buff:IsDebuff() return false end
function modifier_chaotic_sunbeam_buff:OnCreated(keys)
	self.sunbeam_bonus_day_vison = self:GetAbility():GetSpecialValueFor("sunbeam_bonus_day_vison")
	self.rune_2_outgoing = self:GetAbility():GetSpecialValueFor("rune_2_outgoing")
	if IsServer() then
		self.cooldown_record = keys.cooldown_record
		self:PlayEffect(self:GetParent())
	end
end
function modifier_chaotic_sunbeam_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability then
			ability:StartCooldown(self.cooldown_record)
		end
		ParticleManager:DestroyParticle(self.effect_cast1,false)
	end
end

function modifier_chaotic_sunbeam_buff:PlayEffect(target)
	self.effect_cast1 = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_sunbeam/effect_beam_buff/sprites.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( self.effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	self:AddParticle(
		self.effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end

function modifier_chaotic_sunbeam_buff:Advanced_GetBonusDayVision()   return self.sunbeam_bonus_day_vison  end
function modifier_chaotic_sunbeam_buff:Advanced_GetForceDayState()   return 1  end

function modifier_chaotic_sunbeam_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_BONUS_DAY_VISION,
		advanced_MODIFIER_PROPERTY_FORCE_DAY_STATE,
	}
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
	end
    return funcs
end

function modifier_chaotic_sunbeam_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	
	if IsFireDamage(keys) or IsHolyDamage(keys) then
		return self.rune_2_outgoing
	end
end



modifier_chaotic_sunbeam_debuff = advanced_modifier({})

function modifier_chaotic_sunbeam_debuff:IsHidden() 			return false end
function modifier_chaotic_sunbeam_debuff:IsPurgable() 			return false end
function modifier_chaotic_sunbeam_debuff:IsPurgeException() 	return false end
function modifier_chaotic_sunbeam_debuff:IsDebuff() return true end

function modifier_chaotic_sunbeam_debuff:OnCreated(keys)
	self.miss = self:GetAbility():GetSpecialValueFor("miss_chance")
end

function modifier_chaotic_sunbeam_debuff:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_sunbeam_debuff:GetModifierMiss_Percentage()
	return self.miss
end

function modifier_chaotic_sunbeam_debuff:OnTooltip()
	return self:GetModifierMiss_Percentage()
end