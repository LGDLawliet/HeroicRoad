
Advanced_Ghost_Purimn = class({})
require("internal/timers")
LinkLuaModifier("modifier_Advanced_Ghost_Purimn_thinker", "skills/Advanced_Ghost_Purimn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Purimn_effect", "skills/Advanced_Ghost_Purimn", LUA_MODIFIER_MOTION_NONE)


function Advanced_Ghost_Purimn:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_purimn/ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_purimn/purimnecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", context )
end
function Advanced_Ghost_Purimn:UnlockFirstCore(key)
	return false
end
function Advanced_Ghost_Purimn:UnlockSecondCore(key)
	return false
end
function Advanced_Ghost_Purimn:UnlockThirdCore(key)
	return false
end
function Advanced_Ghost_Purimn:CheckKV(key)
	local table = {
		status_down = 0.5,
        posi_down = 0.3,
        control_damage_up = 1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Ghost_Purimn:IsRefreshable() 		return true end
function Advanced_Ghost_Purimn:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Advanced_Ghost_Purimn:OnSpellStart()
    if not IsServer() then
        return
    end

	local caster = self:GetCaster()
	self.pos = self:GetCursorPosition()
    self.radius = self:GetSpecialValueFor("radius")
    --LV20御鬼之极
    if self.advanced_level >= 20 then
        self.radius = self.radius*1.3

        self:GetCaster():GameTimer(1.7,function()
            local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),	
            self.pos,
            nil,	
            self.radius,	
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	
            FIND_ANY_ORDER,	
            false	
            )
            for _,enemy in pairs(enemies) do
                enemy:AddNewModifier(self:GetCaster(), ability, "modifier_stunned", {duration = 3})
            end
        end)
    end

	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Advanced_Ghost_Purimn_thinker",
		{
			duration = self:GetSpecialValueFor("duration"),
			radius = self.radius,
		},
		self.pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")	
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
end

------------------------------------------------------
modifier_Advanced_Ghost_Purimn_thinker = advanced_modifier({})

function modifier_Advanced_Ghost_Purimn_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius
        self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

        

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

function modifier_Advanced_Ghost_Purimn_thinker:OnIntervalThink()
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
		enemy:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Ghost_Purimn_effect", {duration = 1.1})
	end
end

function modifier_Advanced_Ghost_Purimn_thinker:OnDestroy(params)
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
modifier_Advanced_Ghost_Purimn_effect = advanced_modifier({})

function modifier_Advanced_Ghost_Purimn_effect:IsHidden() 	return false end
function modifier_Advanced_Ghost_Purimn_effect:IsDebuff() 		return true end
function modifier_Advanced_Ghost_Purimn_effect:IsPurgable() 			return false end

function modifier_Advanced_Ghost_Purimn_effect:OnCreated()
    self.status_down = self:GetAbility():GetSpecialValueFor("status_down")
    self.posi_down = self:GetAbility():GetSpecialValueFor("posi_down")
	self.control_damage_up = self:GetAbility():GetSpecialValueFor("control_damage_up")
    self.advanced_index = self:GetAbility():GetSpecialValueFor("advanced_index")*0.01
    self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

     --LV10背水诅咒+
    if self.advanced_level >= 10 then
        self.advanced_index = 1
    end
    --self.ad_posi_down = self.advanced_index*((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())/self:GetParent():GetMaxHealth())*100

end 

function modifier_Advanced_Ghost_Purimn_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_StatusResistance,
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
    }
end

function modifier_Advanced_Ghost_Purimn_effect:Advanced_GetModifier_StatusResistance()
    return -self.status_down
end
function modifier_Advanced_Ghost_Purimn_effect:Advanced_GetModifier_DurationGain()
    return -(self.posi_down + self.advanced_index*((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())/self:GetParent():GetMaxHealth())*100)
end
function modifier_Advanced_Ghost_Purimn_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self:GetParent():IsStunned() or self:GetParent():IsFrozen() or self:GetParent():IsRooted() or self:GetParent():IsHexed() then
        --LV15封印解除+
        if self.advanced_level >= 15 then
            return self.control_damage_up + 25
        end
		return self.control_damage_up
	end
    return 0
end
function modifier_Advanced_Ghost_Purimn_effect:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	--LV5完杀诅咒
	if self.advanced_level >= 5 then
    	return -70
	end
	return 0
end

------------------------------------------------------
