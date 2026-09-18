
Middle_Ghost_Saya = class({})

LinkLuaModifier("modifier_Middle_Ghost_Saya_thinker", "skills/Middle_Ghost_Saya", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ghost_Saya_frozen", "skills/Middle_Ghost_Saya", LUA_MODIFIER_MOTION_NONE)

function Middle_Ghost_Saya:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/sayaghost_purimn/ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_saya/Sayaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_frozen.vpcf", context )
end

function Middle_Ghost_Saya:IsHiddenWhenStolen() 	return false end
function Middle_Ghost_Saya:IsRefreshable() 		return false end
function Middle_Ghost_Saya:IsStealable() 			return true end

function Middle_Ghost_Saya:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Middle_Ghost_Saya:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Middle_Ghost_Saya_thinker",
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
modifier_Middle_Ghost_Saya_thinker = advanced_modifier({})

function modifier_Middle_Ghost_Saya_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")

		

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/sayaghost_purimn/ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:SetParticleControl( self.effect_cast, 60, Vector(0, 234, 230) )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(1,0, 0) )
    
		self.effect_cast2 = ParticleManager:CreateParticle( "particles/rebuild/spell/ghost_saya/Sayaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )

		self:StartIntervalThink(self.interval)
	end
end

function modifier_Middle_Ghost_Saya_thinker:OnIntervalThink()
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
		if self.chance >= RandomInt(1, 100) then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.3)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.8)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Ghost_Saya_frozen", {duration = self:GetAbility():GetSpecialValueFor("frozen_duration")*StatusResistance})
		end

		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			--hd_flags = HD_DAMAGE_FLAG_
		}
		ApplyDamage(self.damageTable)
	end
end

function modifier_Middle_Ghost_Saya_thinker:OnDestroy(params)
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
------------------------------------------------------
modifier_Middle_Ghost_Saya_frozen = advanced_modifier({})

function modifier_Middle_Ghost_Saya_frozen:IsHidden() 	return false end
function modifier_Middle_Ghost_Saya_frozen:IsDebuff() 		return true end
function modifier_Middle_Ghost_Saya_frozen:IsPurgable() 			return false end
function modifier_Middle_Ghost_Saya_frozen:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Middle_Ghost_Saya_frozen:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Middle_Ghost_Saya_frozen:CheckState()
    return{
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end 


