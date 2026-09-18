item_chaotic_unrelenting_eye = class({})
LinkLuaModifier("modifier_item_chaotic_unrelenting_eye", "items/item_chaotic_unrelenting_eye", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_unrelenting_eye_active", "items/item_chaotic_unrelenting_eye", LUA_MODIFIER_MOTION_NONE)
function item_chaotic_unrelenting_eye:GetIntrinsicModifierName()
	return "modifier_item_chaotic_unrelenting_eye"
end
function item_chaotic_unrelenting_eye:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_life_stealer_rage.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", context )
end
---------------------------------
modifier_item_chaotic_unrelenting_eye = advanced_modifier({})
function modifier_item_chaotic_unrelenting_eye:IsDebuff() return false end
function modifier_item_chaotic_unrelenting_eye:IsHidden() return true end
function modifier_item_chaotic_unrelenting_eye:IsPurgable() return false end

function modifier_item_chaotic_unrelenting_eye:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_status_resist = self.ability:GetSpecialValueFor("bonus_status_resist")
	self.line = self.ability:GetSpecialValueFor("line")
    self.duration = self.ability:GetSpecialValueFor("duration")

    if IsServer() then 
        self:StartIntervalThink(0.2)
    end
end

function modifier_item_chaotic_unrelenting_eye:OnIntervalThink()
	if self.parent:IsAlive() and self.ability:IsCooldownReady() and self.parent:GetHealthPercent() <= self.line then
        self.ability:UseResources(true, true, true, true)

        EmitSoundOn( "Hero_LifeStealer.Rage", self.parent )
	    self.parent:Purge(false, true, false, true, true)  --强驱散

        local modifier = self.parent:FindModifierByName("modifier_item_chaotic_unrelenting_eye_active")
        local duration = self.duration*self.parent:GetModifierDurationGainIndex(0.4)
        if modifier then
            modifier:ForceRefresh()
            modifier:SetDuration(duration, true)
        else
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_item_chaotic_unrelenting_eye_active", {duration = duration})
        end  
    end
end

function modifier_item_chaotic_unrelenting_eye:ADDeclareFunctions()
	return {
        advanced_MODIFIER_PROPERTY_StatusResistance,
	}
end

function modifier_item_chaotic_unrelenting_eye:Advanced_GetModifier_StatusResistance()
    return self.bonus_status_resist
end

---------------------------------
modifier_item_chaotic_unrelenting_eye_active = advanced_modifier({})
function modifier_item_chaotic_unrelenting_eye_active:IsDebuff() return false end
function modifier_item_chaotic_unrelenting_eye_active:IsHidden() return false end
function modifier_item_chaotic_unrelenting_eye_active:IsPurgable() return false end
function modifier_item_chaotic_unrelenting_eye_active:GetStatusEffectName()return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end
function modifier_item_chaotic_unrelenting_eye_active:OnCreated()
    if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end
function modifier_item_chaotic_unrelenting_eye_active:CheckState()
    return {
        [ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
    }
end