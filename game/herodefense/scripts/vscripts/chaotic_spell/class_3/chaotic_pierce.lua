
chaotic_pierce = class({})

LinkLuaModifier("modifier_chaotic_pierce_caster_motion", "chaotic_spell/class_3/chaotic_pierce", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_pierce_debuff", "chaotic_spell/class_3/chaotic_pierce", LUA_MODIFIER_MOTION_NONE)

function chaotic_pierce:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_pierce/chaotic_pierce/effect_pos.vpcf.vpcf", context )
end

function chaotic_pierce:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function chaotic_pierce:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_pierce:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function chaotic_pierce:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL+ DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end


function chaotic_pierce:GetHealthCost(iLevel)
	local health_cost = self.BaseClass.GetHealthCost(self,iLevel)
	if self:GetRuneType()==1 and self:GetAutoCastState() then
		health_cost = health_cost + self:GetCaster():GetHealth() * self:GetSpecialValueFor("rune_1_health_cost")*0.01
	end

	return health_cost

end

function chaotic_pierce:UpdateCustomIndicator( loc )
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
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(0,self:GetSpecialValueFor("width"),0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_pierce:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_pierce:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("distance") - caster:GetCastRangeBonus()

end

function chaotic_pierce:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local distance = self:GetSpecialValueFor("distance")
	local direction = (pos - caster_loc):Normalized()
	local pos = caster_loc + direction * distance
	local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_pierce/chaotic_pierce/effect_pos.vpcf.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster_loc+Vector(0,0,64))
	ParticleManager:SetParticleControl(pfx, 1, pos+Vector(0,0,64))
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:AddNewModifier(caster, self, "modifier_chaotic_pierce_caster_motion", {duration = -1, direction_x = direction.x, direction_y = direction.y, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	caster:EmitSound("chaotic_pierce_cast")
end

modifier_chaotic_pierce_caster_motion = advanced_modifier({})

function modifier_chaotic_pierce_caster_motion:IsDebuff()					return false end
function modifier_chaotic_pierce_caster_motion:IsHidden() 				return true end
function modifier_chaotic_pierce_caster_motion:IsPurgable() 				return false end
function modifier_chaotic_pierce_caster_motion:IsPurgeException() 		return false end
function modifier_chaotic_pierce_caster_motion:CheckState() 
	return 
	{
		[MODIFIER_STATE_STUNNED] = true, 
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	} 
end
function modifier_chaotic_pierce_caster_motion:IsMotionController() return true end
function modifier_chaotic_pierce_caster_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_chaotic_pierce_caster_motion:OnCreated(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.caster_loc = self.caster:GetAbsOrigin()
		self.direction = Vector(keys.direction_x, keys.direction_y, 0)
		self.hitted = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.width = self:GetAbility():GetSpecialValueFor("width")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.ability = self:GetAbility()
		self.next_pos = 0
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_chaotic_pierce_caster_motion:OnIntervalThink()
	if not IsServer() then
		return
	end
	local distance = self.ability:GetSpecialValueFor("distance") / (0.1 / FrameTime())
	self.next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	if (self.next_pos - self.caster_loc):Length2D() > self.ability:GetSpecialValueFor("distance") + 50 then
		self:Destroy()
		return
	end	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.width = math.max(self.width - 25,10)
	self:GetParent():SetOrigin(self.next_pos)
	local damageTable = {
		attacker = self.caster,
		damage = self.caster:HDGetPrimaryStatValue() * self.bonus_damage * self.ability:GetEffectGain(),
		damage_type = self.ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, 
		ability = self.ability,
		hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE,
	}

	local arti_douqi = self.caster:FindAbilityByName("item_hd_douqi_effects")
	local arti_douqi_level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_douqi_effects")
	if arti_douqi and arti_douqi_level then
		if arti_douqi_level >= 40 then
			damageTable.hd_flags = HD_DAMAGE_FLAG_PHY_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		end
	end
	
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			table.insert(self.hitted, enemy)
			local ModifierStatusNegativeGain = self.caster:GetModifierStatusNegativeGainIndex()
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self.caster, self.ability, "modifier_chaotic_pierce_debuff", {duration = self.duration*StatusResistance})
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
end

function modifier_chaotic_pierce_caster_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self.pos, true)
	end
end

modifier_chaotic_pierce_debuff = advanced_modifier({})

function modifier_chaotic_pierce_debuff:IsDebuff()			return true end
function modifier_chaotic_pierce_debuff:IsHidden() 		return false end
function modifier_chaotic_pierce_debuff:IsPurgable() 		return false end
function modifier_chaotic_pierce_debuff:IsPurgeException() return false end

function modifier_chaotic_pierce_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_chaotic_pierce_debuff:OnCreated()
	local ability = self:GetAbility()
    self.armor_reduction = ability:GetSpecialValueFor("armor_reduction")
	if ability:GetRuneType()==1 and ability:GetAutoCastState() then
		self.armor_reduction =  self.armor_reduction * (1+ability:GetSpecialValueFor("rune_1_bonus")*0.01)
	end
end

function modifier_chaotic_pierce_debuff:OnRefresh() 
	local ability = self:GetAbility()
    self.armor_reduction = ability:GetSpecialValueFor("armor_reduction")
	if ability:GetRuneType()==1 and ability:GetAutoCastState() then
		self.armor_reduction =  self.armor_reduction * (1+ability:GetSpecialValueFor("rune_1_bonus")*0.01)
	end
end

function modifier_chaotic_pierce_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self.armor_reduction
end

function modifier_chaotic_pierce_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_pierce_debuff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

    if self._tooltip == 1 then
        return self.armor_reduction
	end
end