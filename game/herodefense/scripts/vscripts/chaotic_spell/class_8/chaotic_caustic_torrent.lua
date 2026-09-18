
LinkLuaModifier("modifier_chaotic_caustic_torrent_thinker", "chaotic_spell/class_8/chaotic_caustic_torrent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_caustic_torrent_rune_2_debuff", "chaotic_spell/class_8/chaotic_caustic_torrent", LUA_MODIFIER_MOTION_NONE)

chaotic_caustic_torrent = class({})


function chaotic_caustic_torrent:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_caustic_torrent:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_caustic_torrent:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	local radius = self:GetSpecialValueFor("radius")
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(radius,radius,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end


function chaotic_caustic_torrent:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("distance")



	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)

end

function chaotic_caustic_torrent:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_caustic_torrent:GetCastRange()
	if IsClient() then
		return 30000
	end
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("distance") - caster:GetCastRangeBonus()

end


function chaotic_caustic_torrent:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_caustic_torren/effect_main/effect_rebuild/tinker_laser.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_caustic_torrent/path_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_caustic_torren/effect_main/effect_rebuild/laser_cutter_sparks_k.vpcf", context )

	
end




function chaotic_caustic_torrent:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("distance")
	local target_pos = caster_loc + direction* distance+ Vector(0,0,64) 
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_caustic_torren/effect_main/effect_rebuild/tinker_laser.vpcf", PATTACH_CUSTOMORIGIN, caster )
	-- ParticleManager:SetParticleControl( pfx, 1, caster_loc  )

	local startPos = caster:GetAttachmentOrigin( caster:ScriptLookupAttachment( "attach_attack1" ) )
	ParticleManager:SetParticleControl( pfx, 9, startPos)
	ParticleManager:SetParticleControl( pfx, 1, target_pos)
	-- ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("chaotic_caustic_torrent_target")

	
	local gain = self:GetEffectGain()

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, target_pos,nil, self:GetSpecialValueFor("radius"),
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local stun_duration = self:GetSpecialValueFor("duration")

	local damageTable = {
		attacker	= caster,
		-- victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"))*gain,
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
	}

	local duration = self:GetSpecialValueFor("thinker_duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_chaotic_caustic_torrent_thinker", {duration = duration}, startPos, caster:GetTeamNumber(), false)
	if thinker then
		local modifier = thinker:FindModifierByName("modifier_chaotic_caustic_torrent_thinker")
		if modifier then
			modifier:InitEffect(startPos,target_pos)
		end
	end


	local poison_apply = (self:GetSpecialValueFor("poison_apply") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_poison_apply"))*gain
	-- local debuff_duration = self:GetSpecialValueFor("debuff_duration")*caster:GetModifierStatusNegativeGainIndex(1)
	local rune_1_bonus = self:GetSpecialValueFor("rune_1_bonus")
	for i, unit in pairs(tTargets) do
		self:PlayEffect(unit)
		damageTable.victim = unit
		ApplyDamage(damageTable)
		if IsValid(unit) and unit:IsAlive() then
			if self:GetRuneType()==1 then
				unit:ActivePoison(caster, self, rune_1_bonus,0)
			end
			unit:Poison(caster, self,poison_apply)
		end
	
	end


end




function chaotic_caustic_torrent:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_caustic_torren/effect_main/effect_rebuild/laser_cutter_sparks_k.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	-- print("check")
	-- target:EmitSound("chaotic_mass_cure_wounds_target")
end



















modifier_chaotic_caustic_torrent_thinker = advanced_modifier({})

function modifier_chaotic_caustic_torrent_thinker:IsAura()return true end

function modifier_chaotic_caustic_torrent_thinker:InitEffect(startPos,endPos,dir)
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self.path_bonus_poison_apply = self:GetAbility():GetSpecialValueFor("path_bonus_poison_apply")


		self.height = 300
		self.effect = 1
		local parent = self:GetParent()

		self.dir = dir
		self.startPos = startPos
		self.endPos = endPos

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_caustic_torrent/path_effect/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particle,1,startPos)
		ParticleManager:SetParticleControl(self.particle,9,endPos)
		ParticleManager:SetParticleControl(self.particle,10,Vector(self.radius,self:GetRemainingTime(),0))
		
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end





function modifier_chaotic_caustic_torrent_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end



function modifier_chaotic_caustic_torrent_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:Destroy()
	end
	if self.effect<=0 then
		self:Destroy()
		return
	end
	local caster = self:GetCaster()

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), self.startPos, self.endPos,nil, self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

	local parent = self:GetParent()

	local poison_apply =caster:HDGetPrimaryStatValue()*self.path_bonus_poison_apply


	for index, unit in ipairs(tTargets) do
		unit:AddNewModifier(caster, ability, "modifier_chaotic_caustic_torrent_rune_2_debuff", {duration =1.5})
		unit:Poison(caster, self,poison_apply)
		
	end

end









modifier_chaotic_caustic_torrent_rune_2_debuff = advanced_modifier({})

function modifier_chaotic_caustic_torrent_rune_2_debuff:IsHidden()	return false end
function modifier_chaotic_caustic_torrent_rune_2_debuff:IsDebuff()	return true end
function modifier_chaotic_caustic_torrent_rune_2_debuff:IsPurgable()	return false end
function modifier_chaotic_caustic_torrent_rune_2_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_chaotic_caustic_torrent_rune_2_debuff:Advanced_GetModifierIncomingPoisonDamagePercentage()	return self.bonus end
function modifier_chaotic_caustic_torrent_rune_2_debuff:OnCreated(keys)
	self.bonus = self:GetAbility():GetSpecialValueFor("rune_2_bonus")
end





function modifier_chaotic_caustic_torrent_rune_2_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_chaotic_caustic_torrent_rune_2_debuff:OnTooltip()
	return self:Advanced_GetModifierIncomingPoisonDamagePercentage()
end




