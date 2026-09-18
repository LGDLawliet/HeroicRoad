
Middle_Ghost_Rocha = class({})

LinkLuaModifier("modifier_Middle_Ghost_Rocha_thinker", "skills/Middle_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ghost_Rocha_effect", "skills/Middle_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_noheal", "skills/Middle_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_losevision", "skills/Middle_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)

function Middle_Ghost_Rocha:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/rochaghost_purimn/ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_rocha/rochaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", context )
end

function Middle_Ghost_Rocha:IsHiddenWhenStolen() 	return false end
function Middle_Ghost_Rocha:IsRefreshable() 		return false end
function Middle_Ghost_Rocha:IsStealable() 			return true end

function Middle_Ghost_Rocha:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Middle_Ghost_Rocha:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Middle_Ghost_Rocha_thinker",
		{
			duration = self:GetSpecialValueFor("duration"),
			radius = self:GetSpecialValueFor("radius"),
		},
		pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")	
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
end

------------------------------------------------------
modifier_Middle_Ghost_Rocha_thinker = advanced_modifier({})

function modifier_Middle_Ghost_Rocha_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/rochaghost_purimn/ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:SetParticleControl( self.effect_cast, 60, Vector(153, 8, 153) )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(1,0, 0) )
    
		self.effect_cast2 = ParticleManager:CreateParticle( "particles/rebuild/spell/ghost_rocha/rochaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_Ghost_Rocha_thinker:OnIntervalThink()
	if not IsServer() then
        return
    end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	
		FIND_ANY_ORDER,	
		false	
	)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Ghost_Rocha_effect", {duration = 1.1})
	end
end

function modifier_Middle_Ghost_Rocha_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	ParticleManager:DestroyParticle(self.effect_cast2, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast2)
	UTIL_Remove( self:GetParent() )
end


------------------------------------------------------
modifier_Middle_Ghost_Rocha_effect = advanced_modifier({})

function modifier_Middle_Ghost_Rocha_effect:IsHidden() 	return false end
function modifier_Middle_Ghost_Rocha_effect:IsDebuff() 		return true end
function modifier_Middle_Ghost_Rocha_effect:IsPurgable() 			return false end

function modifier_Middle_Ghost_Rocha_effect:OnCreated()
    self.move_down = self:GetAbility():GetSpecialValueFor("move_down")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.nega_duration = self:GetAbility():GetSpecialValueFor("nega_duration")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end 
function modifier_Middle_Ghost_Rocha_effect:OnIntervalThink()
	if self.chance >= RandomInt(1, 100) then
		self:Randomnega()
	end
end
function modifier_Middle_Ghost_Rocha_effect:Randomnega()
	local random = RandomInt(1, 6)
	if random == 1 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_stunned",{duration = self.nega_duration*StatusResistance})
	end
	if random == 2 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_rooted",{duration = self.nega_duration*StatusResistance})
	end
	if random == 3 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_silence",{duration = self.nega_duration*StatusResistance})
	end
	if random == 4 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_disarmed",{duration = self.nega_duration*StatusResistance})
	end
	if random == 5 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_noheal",{duration = self.nega_duration*StatusResistance})
	end
	if random == 6 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_losevision",{duration = self.nega_duration*StatusResistance})
	end
end

function modifier_Middle_Ghost_Rocha_effect:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_Middle_Ghost_Rocha_effect:GetModifierMoveSpeedBonus_Constant()
    return -self.move_down
end

------------------------------------------------------
modifier_noheal = advanced_modifier({})

function modifier_noheal:IsHidden() 	return false end
function modifier_noheal:IsDebuff() 	return true end
function modifier_noheal:IsPurgable() 	return false end
function modifier_noheal:DeclareFunctions() 	return {MODIFIER_PROPERTY_DISABLE_HEALING} end
function modifier_noheal:GetDisableHealing()	return 1 end

------------------------------------------------------
modifier_losevision = advanced_modifier({})

function modifier_losevision:IsHidden() 	return false end
function modifier_losevision:IsDebuff() 	return true end
function modifier_losevision:IsPurgable() 	return false end
function modifier_losevision:ADDeclareFunctions() 	return {advanced_MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE} end
function modifier_losevision:Advanced_GetBonusVisionPercentage()	return -80 end
function modifier_losevision:Advanced_GetModifierAttackRangeBonusPercentage()	return -80 end