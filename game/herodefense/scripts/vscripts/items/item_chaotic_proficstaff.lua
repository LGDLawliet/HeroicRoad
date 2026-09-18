      
item_chaotic_proficstaff = class({})
LinkLuaModifier("modifier_item_chaotic_proficstaff", "items/item_chaotic_proficstaff", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_proficstaff:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ultimate_scepter/effect.vpcf", context )
end
function item_chaotic_proficstaff:GetIntrinsicModifierName()
	return "modifier_item_chaotic_proficstaff"
end
function item_chaotic_proficstaff:OnSpellStart()
	local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local modifier = caster:FindModifierByName("modifier_item_chaotic_proficstaff")
    if modifier then
        modifier:SetStackCount(1)
        caster:GameTimer(duration, function()
            if self ~= nil then
               modifier:SetStackCount(0) 
            end
        end)
    end

    local particle = ParticleManager:CreateParticle("particles/rebuild/items/ultimate_scepter/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,500))
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	DestroyParticleByDelay(particle,3)
    caster:EmitSound("hud.equip.agh_scepter")
end

---------------------------------
modifier_item_chaotic_proficstaff = advanced_modifier({})
function modifier_item_chaotic_proficstaff:IsDebuff() return false end
function modifier_item_chaotic_proficstaff:IsHidden() return self:GetStackCount() ~= 1 end
function modifier_item_chaotic_proficstaff:IsPurgable() return false end
function modifier_item_chaotic_proficstaff:GetTexture() return "item_ultimate_scepter" end
function modifier_item_chaotic_proficstaff:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
    self.profic_a = self.ability:GetSpecialValueFor("profic_a")
end

function modifier_item_chaotic_proficstaff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
	}
end

function modifier_item_chaotic_proficstaff:Advanced_GetModifier_TalentEffectGain()
    if self:GetStackCount() == 1 then
        return self.profic_a
    else
        return self.bonus_profic
    end
end
