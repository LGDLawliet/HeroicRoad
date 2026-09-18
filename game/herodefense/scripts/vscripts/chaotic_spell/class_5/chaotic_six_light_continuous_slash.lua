
LinkLuaModifier( "modifier_chaotic_six_light_continuous_slash", "chaotic_spell/class_5/chaotic_six_light_continuous_slash", LUA_MODIFIER_MOTION_NONE )

chaotic_six_light_continuous_slash = class({})


function chaotic_six_light_continuous_slash:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_six_light_continuous_slash:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end
function chaotic_six_light_continuous_slash:GetCastPoint()
	local time = 0
	if self:GetRuneType()==2 then
		time =self:GetSpecialValueFor("rune_2_time")
	end
	return time
end
function chaotic_six_light_continuous_slash:GetBehavior()
	if self:GetRuneType()==2 then
		return DOTA_ABILITY_BEHAVIOR_POINT
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function chaotic_six_light_continuous_slash:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_six_light_continuous_slash:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = distance * (1+self:GetSpecialValueFor("rune_2_diswid")*0.01)
	end
	local target_pos = caster_loc + direction* distance

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(200,200,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_six_light_continuous_slash:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_six_light_continuous_slash:GetCastRange()
	if IsClient() then
		local caster = self:GetCaster()
		local distance = self:GetSpecialValueFor("distance")
		if self:GetRuneType()==2 then
			distance = distance * (1+self:GetSpecialValueFor("rune_2_diswid")*0.01)
		end
		
		return distance - caster:GetCastRangeBonus()
	end
	if IsServer() then
		return 30000
	end
end

function chaotic_six_light_continuous_slash:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/effect_cast/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_8.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_6.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_5.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/blood_grudge_dagger/unlock1/effect_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
end

function chaotic_six_light_continuous_slash:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_six_light_continuous_slash:GetManaCostGain()
	local caster = self:GetCaster()
	local keys = {
		ability=self,
		caster = caster,
	}
	local value = GetChaoticSpellManaCostGain(caster,keys)
	return value
end

function chaotic_six_light_continuous_slash:OnSpellStart()

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
		distance = distance * (1+self:GetSpecialValueFor("rune_2_diswid")*0.01)
	end
	local target_pos = caster_loc + direction* distance

	caster:SetAbsOrigin(Vector(target_pos.x, target_pos.y, GetGroundPosition(target_pos, caster).z))
	caster:Purge(false, true, true, true, true)
	caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.01})

	local current_pos = caster:GetAbsOrigin()
	local dir = CalculateDirection(current_pos, caster_loc)

	local pfx_max = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_6.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_max, 0, caster_loc)

	ParticleManager:SetParticleControl(pfx_max, 1, current_pos)
	ParticleManager:SetParticleControlForward(pfx_max, 1,dir)  --方向
	ParticleManager:ReleaseParticleIndex(pfx_max)

	caster:EmitSound("chaotic_six_light_continuous_slash_cast")
	local width = self:GetSpecialValueFor("width")
	if self:GetRuneType()==2 then
		width = width * (1+self:GetSpecialValueFor("rune_2_diswid")*0.01)
	end
	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, current_pos,nil, width,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	self:PlayEffect(caster_loc,current_pos)

	local gain = self:GetEffectGain()

	local count = self:GetSpecialValueFor("effect_count")
	local duration = self:GetSpecialValueFor("duration")*gain
	for i, unit in pairs(tTargets) do

		self:PlayEffect(caster_loc,unit:GetOrigin())

		unit:AddNewModifier(caster, self, "modifier_chaotic_six_light_continuous_slash", {duration = duration,gain=gain})
		count = count - 1
		if count<=0 then
			break
		end
	
	end

	if self:GetRuneType()==1 then
		caster:GameTimer(0.1,function()
			caster:SetAbsOrigin(Vector(caster_loc.x, caster_loc.y, GetGroundPosition(caster_loc, caster).z))
			caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.01})
		end)
		
	end

end

function chaotic_six_light_continuous_slash:PlayEffect(source,target)
	local iPtclID = ParticleManager:CreateParticle('particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/effect_cast/effect.vpcf', PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iPtclID, 0, source)
	ParticleManager:SetParticleControl(iPtclID, 1, target)
	ParticleManager:SetParticleControl( iPtclID, 60, Vector(255,0,0) )
	ParticleManager:SetParticleControl( iPtclID, 61, Vector(1,0,0) )
	ParticleManager:ReleaseParticleIndex(iPtclID)
end
function chaotic_six_light_continuous_slash:PlayHitEffect(target)
	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_2.vpcf", PATTACH_ABSORIGIN_FOLLOW,target )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, nil,target:GetAbsOrigin(), true )	
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, nil,target:GetAbsOrigin(), true )	
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, nil,target:GetAbsOrigin(), true )	
	DestroyParticleByDelay(nFXIndex,1)
end


modifier_chaotic_six_light_continuous_slash = modifier_chaotic_six_light_continuous_slash or advanced_modifier({})


function modifier_chaotic_six_light_continuous_slash:IsHidden()  return false end


function modifier_chaotic_six_light_continuous_slash:OnCreated(keys)

	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local ability_gain =  keys.gain
	self.damage_record_index = ability:GetSpecialValueFor("damage_record")*0.01
	self.damage = ability:GetSpecialValueFor("damage")*ability_gain
	self.damage_max = ability:GetSpecialValueFor("damage_max")*ability_gain
	self.damage_record_total = 0
	self.interval = ability:GetSpecialValueFor("damage_interval")
	if ability:GetRuneType()==2 then
		self.interval = self.interval *(1-ability:GetSpecialValueFor("rune_2_interval")*0.01)
	end
	local source = self:GetParent():GetAbsOrigin()
	local caster = self:GetCaster()

	local caster_pos = caster:GetAbsOrigin()
	caster:GameTimer(0.1,function()
		if IsValid(ability) then
			ability:PlayEffect(source,caster_pos)
		end
	end)
	self:StartIntervalThink(self.interval)
end
function modifier_chaotic_six_light_continuous_slash:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	ability:PlayHitEffect(parent)
	parent:EmitSound("Hero_Juggernaut.Attack")
	local caster = self:GetCaster()
	local damage = ability:GetSpecialValueFor("damage")*caster:HDGetPrimaryStatValue()
	local damageTable = {
		victim      = parent,
		attacker	= caster,
		damage		= damage,
		damage_type	= ability:GetAbilityDamageType(),
		ability		= ability,
		hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE,
	}
	ApplyDamage(damageTable)
	if self:GetAbility():GetRuneType()==3 then
		local modifier_keys = {
			duration  =0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
		}
		local attackEffectRecord =caster:AddAttackEffectModifier(ability,modifier_keys)
		caster:PerformAttack( parent, true, true, true, false, false, false, true )
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
	end
end



function modifier_chaotic_six_light_continuous_slash:OnDestroy()

	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	if not IsValid(parent) then
		return
	end

	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/blood_grudge_dagger/unlock1/effect_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN, parent)
	ParticleManager:SetParticleControl(pfx, 0, parent:GetOrigin())
	ParticleManager:SetParticleControlForward(pfx, 0, Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),RandomFloat(-1, 1)))  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	parent:EmitSound("hero_bloodseeker.rupture.cast")

	if not parent:IsAlive() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_six_light_continuous_slash/chaotic_six_light_continuous_slash_5.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc",parent:GetAbsOrigin(), true )	
	parent:EmitSound("Hero_Pudge.Dismember")
	DestroyParticleByDelay(nFXIndex,1)

	local attack_damage = caster:HDGetPrimaryStatValue()
	local damage = math.min(self.damage_record_total*self.damage_record_index+attack_damage*self.damage ,attack_damage*self.damage_max)

	local damageTable = {
		victim      = parent,
		attacker	= caster,
		damage		= damage,
		damage_type	= ability:GetAbilityDamageType(),
		ability		= ability,
		hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE,
	}
	ApplyDamage(damageTable)
end

function modifier_chaotic_six_light_continuous_slash:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	
	return decFuncs	
end

function modifier_chaotic_six_light_continuous_slash:GetVisualZDelta( params )

	return 200
end

function modifier_chaotic_six_light_continuous_slash:CheckState()

	local state = {

		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_DISARMED] = true,
		
	}

	return state

end



function modifier_chaotic_six_light_continuous_slash:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},
	}

	return funcs
end

function modifier_chaotic_six_light_continuous_slash:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if unit~=self:GetParent() then
			return
		end
	
		self.damage_record_total = self.damage_record_total + keys.damage
 
    end 
end
