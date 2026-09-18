item_hd_creed_of_omniscience_2 = class({})

LinkLuaModifier("modifier_item_hd_creed_of_omniscience_2", "items/item_hd_creed_of_omniscience_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_creed_of_omniscience_2_active", "items/item_hd_creed_of_omniscience_2", LUA_MODIFIER_MOTION_NONE)


function item_hd_creed_of_omniscience_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ultimate_scepter/effect.vpcf", context )
end

function item_hd_creed_of_omniscience_2:GetIntrinsicModifierName()
	return "modifier_item_hd_creed_of_omniscience_2"
end

function item_hd_creed_of_omniscience_2:OnSpellStart()

	self:OnWaveEndTrigger()
end
function item_hd_creed_of_omniscience_2:OnWaveEndTrigger()
	if not self.count then
		self.count = 0
	end
	self.count = self.count  + 1
	if self.count>=6 then
		self.count = 0
		local caster = self:GetCaster()
		caster:SetAbilityPoints(caster:GetAbilityPoints()+1)
		local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/hero_levelup_ti7.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
		DestroyParticleByDelay(particle,3)
		caster:EmitSound("ui.badge_levelup")
	end

	return self.count
end
modifier_item_hd_creed_of_omniscience_2 = advanced_modifier({})

function modifier_item_hd_creed_of_omniscience_2:IsDebuff() return false end
function modifier_item_hd_creed_of_omniscience_2:IsHidden() return false end
function modifier_item_hd_creed_of_omniscience_2:IsPurgable() return false end
function modifier_item_hd_creed_of_omniscience_2:IsPurgeException() return false end
function modifier_item_hd_creed_of_omniscience_2:OnWaveEnd()
	self:SetStackCount(self:GetAbility():OnWaveEndTrigger())
    return 1
end

function modifier_item_hd_creed_of_omniscience_2:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end

