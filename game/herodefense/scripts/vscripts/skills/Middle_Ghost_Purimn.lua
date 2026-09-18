
Middle_Ghost_Purimn = class({})

LinkLuaModifier("modifier_Middle_Ghost_Purimn_thinker", "skills/Middle_Ghost_Purimn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ghost_Purimn_effect", "skills/Middle_Ghost_Purimn", LUA_MODIFIER_MOTION_NONE)

function Middle_Ghost_Purimn:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_purimn/ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_purimn/purimnecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", context )
end

function Middle_Ghost_Purimn:IsHiddenWhenStolen() 	return false end
function Middle_Ghost_Purimn:IsRefreshable() 		return true end
function Middle_Ghost_Purimn:IsStealable() 			return true end

function Middle_Ghost_Purimn:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Middle_Ghost_Purimn:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Middle_Ghost_Purimn_thinker",
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
modifier_Middle_Ghost_Purimn_thinker = advanced_modifier({})

function modifier_Middle_Ghost_Purimn_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/ghost_purimn/ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:SetParticleControl( self.effect_cast, 60, Vector(8, 169, 51) )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(1,0, 0) )
    
		self.effect_cast2 = ParticleManager:CreateParticle( "particles/rebuild/spell/ghost_purimn/purimnecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_Ghost_Purimn_thinker:OnIntervalThink()
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
		enemy:AddNewModifier(self:GetCaster(), ability, "modifier_Middle_Ghost_Purimn_effect", {duration = 1.1})
	end
end

function modifier_Middle_Ghost_Purimn_thinker:OnDestroy(params)
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
modifier_Middle_Ghost_Purimn_effect = advanced_modifier({})

function modifier_Middle_Ghost_Purimn_effect:IsHidden() 	return false end
function modifier_Middle_Ghost_Purimn_effect:IsDebuff() 		return true end
function modifier_Middle_Ghost_Purimn_effect:IsPurgable() 			return false end

function modifier_Middle_Ghost_Purimn_effect:OnCreated()
    self.status_down = self:GetAbility():GetSpecialValueFor("status_down")
    self.posi_down = self:GetAbility():GetSpecialValueFor("posi_down")
	self.control_damage_up = self:GetAbility():GetSpecialValueFor("control_damage_up")
end 

function modifier_Middle_Ghost_Purimn_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_StatusResistance,
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_Middle_Ghost_Purimn_effect:Advanced_GetModifier_StatusResistance()
    return -self.status_down
end
function modifier_Middle_Ghost_Purimn_effect:Advanced_GetModifier_DurationGain()
    return -self.posi_down
end
function modifier_Middle_Ghost_Purimn_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self:GetParent():IsStunned() or self:GetParent():IsFrozen() or self:GetParent():IsRooted() or self:GetParent():IsHexed() then
		--print("生效了")
		return self.control_damage_up
	end
	--print("没生效")
    return 0
end