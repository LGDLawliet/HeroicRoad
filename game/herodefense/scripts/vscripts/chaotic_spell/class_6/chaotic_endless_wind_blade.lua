LinkLuaModifier("modifier_chaotic_endless_wind_blade_buff", "chaotic_spell/class_6/chaotic_endless_wind_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_endless_wind_blade_debuff", "chaotic_spell/class_6/chaotic_endless_wind_blade", LUA_MODIFIER_MOTION_NONE)

chaotic_endless_wind_blade = class({})


function chaotic_endless_wind_blade:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_endless_wind_blade:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_endless_wind_blade:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_endless_wind_blade:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("length")
	local width = self:GetSpecialValueFor("width")
	if self:GetRuneType()==1 then
		width = width * (1-self:GetSpecialValueFor("rune_1_bonus")*0.01)
	end
	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(width,width,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_endless_wind_blade:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end
function chaotic_endless_wind_blade:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end



function chaotic_endless_wind_blade:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("length") - caster:GetCastRangeBonus()

end

function chaotic_endless_wind_blade:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_endless_wind_blade/chaotic_endless_wind_blade_1.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_endless_wind_blade/chaotic_endless_wind_blade_3_arc.vpcf", context )
end

function chaotic_endless_wind_blade:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_endless_wind_blade:OnSpellStart()

	local caster = self:GetCaster()

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * ModifierStatusGain

	caster:AddNewModifier(caster, self, "modifier_chaotic_endless_wind_blade_buff", {duration = duration+self:GetSpecialValueFor("delay_time")})

end


function chaotic_endless_wind_blade:OnProjectileHit_ExtraData(target, location, kv)
	
	if target~=nil then
		local ability = self
		local caster = ability:GetCaster()

		local damageTable = {
			victim = target,
			attacker = caster,
			damage =  kv.damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = ability,
			hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE
			}

		target:ApplyMergeDamage(damageTable)

		--target:EmitSound("Hero_Mars.Attack")
		target:EmitSound("Hero_Juggernaut.Attack")
	end
end


modifier_chaotic_endless_wind_blade_buff = advanced_modifier({})

function modifier_chaotic_endless_wind_blade_buff:IsHidden() return false end
function modifier_chaotic_endless_wind_blade_buff:IsPurgable() return false end

function modifier_chaotic_endless_wind_blade_buff:OnCreated(keys)

	if not IsServer() then
		return
	end

	local Ability = self:GetAbility()

	self.gain = Ability:GetEffectGain()
	self.width = Ability:GetSpecialValueFor("width")
	if Ability:GetRuneType()==1 then
		self.width = self.width * (1-Ability:GetSpecialValueFor("rune_1_bonus")*0.01)
	end
	self.length = Ability:GetSpecialValueFor("length")
	self.width_damage = Ability:GetSpecialValueFor("width_damage")
	self.length_damage = Ability:GetSpecialValueFor("length_damage")
	self.number = Ability:GetSpecialValueFor("number")
	if Ability:GetRuneType()==2 then
		self.number = math.floor(self.number * (1+Ability:GetSpecialValueFor("rune_2_number")*0.01))
	end
	if Ability:GetRuneType()==3 then
		self.gold =  math.floor(self:GetCaster():GetGold()/Ability:GetSpecialValueFor("rune_3_gold"))*Ability:GetSpecialValueFor("rune_3_bonus")
		self.number = math.floor(self.number * (1+self.gold*0.01))
		print(self.number)
	end
	self.move_speed = Ability:GetSpecialValueFor("move_speed")

	local parent = self:GetParent()

	self.ForwardVector = parent:GetForwardVector()

	parent:AddNewModifier(parent, Ability, "modifier_chaotic_endless_wind_blade_debuff", {duration =Ability:GetSpecialValueFor("delay_time")})

	self.effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_endless_wind_blade/chaotic_endless_wind_blade_1.vpcf", PATTACH_CUSTOMORIGIN, parent )
	ParticleManager:SetParticleControl( self.effect_cast1, 0, parent:GetAbsOrigin() + parent:GetForwardVector() * 150)
	ParticleManager:SetParticleControlForward(self.effect_cast1, 0, parent:GetForwardVector())
	ParticleManager:SetParticleControl( self.effect_cast1, 1, Vector(3,0,0))
	ParticleManager:SetParticleControl( self.effect_cast1, 2, Vector(0,0,200))
	ParticleManager:SetParticleControlEnt( self.effect_cast1, 3, parent, PATTACH_POINT_FOLLOW, "" , parent:GetOrigin(), true )
	-- DestroyParticleByDelay(self.effect_cast1,1.5)

	parent:EmitSound("Hero_Mars.Spear")

	parent:GameTimer(1.5,function()
		if not IsValid(self) then
			return
		end

		self:StartIntervalThink(1/self.number)
	end)

end

function modifier_chaotic_endless_wind_blade_buff:OnDestroy()
	if IsServer() then
		DestroyParticleByDelay(self.effect_cast1,0.1)
	end
end

function modifier_chaotic_endless_wind_blade_buff:OnIntervalThink()

	local random_height = RandomInt(200, 400)
	local random_pos = RandomInt(-self.width, self.width)
	local parent = self:GetParent()
	local parent_pos = parent:GetAbsOrigin() + parent:GetForwardVector() * 150
	local Ability = self:GetAbility()
	local damage = (parent:HDGetPrimaryStatValue() * Ability:GetSpecialValueFor("bonus_damage")) * self.gain
	if Ability:GetRuneType()==3 then
		self.gold =  math.floor(self:GetCaster():GetGold()/Ability:GetSpecialValueFor("rune_3_gold"))*Ability:GetSpecialValueFor("rune_3_bonus")
		damage = math.floor(damage * (1+self.gold*0.01))
		print(damage)
	end
	-- parent:SetForwardVector(self.ForwardVector)

	-- self.effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_endless_wind_blade/chaotic_endless_wind_blade_4.vpcf", PATTACH_CUSTOMORIGIN, parent )
	-- ParticleManager:SetParticleControl( self.effect_cast1, 0, parent:GetAbsOrigin() + parent:GetForwardVector() * 150)
	-- ParticleManager:SetParticleControlForward(self.effect_cast1, 0, parent:GetForwardVector())
	-- ParticleManager:SetParticleControl( self.effect_cast1, 1, Vector(3,0,0))
	-- ParticleManager:SetParticleControl( self.effect_cast1, 2, Vector(0,0,200))
	-- DestroyParticleByDelay(self.effect_cast1,1.5/self.number)

	local projectileTable =
	{
		EffectName ="particles/rebuild/chaotic_spell/chaotic_endless_wind_blade/chaotic_endless_wind_blade_3.vpcf",
		Ability = Ability,
		vSpawnOrigin = Vector(parent_pos.x + random_pos,parent_pos.y + random_pos, parent_pos.z + random_height),
		vVelocity = parent:GetForwardVector() * 3000,
		fDistance = self.length,
		fStartRadius = self.width_damage,
		fEndRadius = self.width_damage,
		Source = parent,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
		bProvidesVision = false,
		ExtraData = {damage = damage}   --额外的数据
	}

	parent:EmitSound("Hero_Mars.Spear.Cast")

	ProjectileManager:CreateLinearProjectile( projectileTable )

end

function modifier_chaotic_endless_wind_blade_buff:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED]   = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function modifier_chaotic_endless_wind_blade_buff:DeclareFunctions()   
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	} 
end


function modifier_chaotic_endless_wind_blade_buff:GetModifierMoveSpeedBonus_Percentage() 
    return self.move_speed
end


function modifier_chaotic_endless_wind_blade_buff:GetModifierIgnoreMovespeedLimit()             return   1  end

function modifier_chaotic_endless_wind_blade_buff:GetModifierDisableTurning()
	return 1
end
function modifier_chaotic_endless_wind_blade_buff:GetModifierIgnoreCastAngle()
    return 1
end




modifier_chaotic_endless_wind_blade_debuff = advanced_modifier({})

function modifier_chaotic_endless_wind_blade_debuff:IsHidden() return false end
function modifier_chaotic_endless_wind_blade_debuff:IsPurgable() return false end
function modifier_chaotic_endless_wind_blade_debuff:IsDebuff() return true end

function modifier_chaotic_endless_wind_blade_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end