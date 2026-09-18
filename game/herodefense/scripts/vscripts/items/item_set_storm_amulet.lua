LinkLuaModifier("modifier_item_set_storm_amulet_thinker", "items/item_set_storm_amulet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_set_storm_amulet", "items/item_set_storm_amulet.lua", LUA_MODIFIER_MOTION_NONE)
item_set_storm_amulet = class({})

function item_set_storm_amulet:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/chaotic_set_storm/amulet_rain.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context )
end

function item_set_storm_amulet:GetIntrinsicModifierName()
    return "modifier_item_set_storm_amulet"
end

function item_set_storm_amulet:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function item_set_storm_amulet:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_item_set_storm_amulet_thinker", {duration = self:GetSpecialValueFor("rain_duration")}, pos, caster:GetTeamNumber(), false)
end


modifier_item_set_storm_amulet_thinker = advanced_modifier({})

function modifier_item_set_storm_amulet_thinker:IsAura()return true end
function modifier_item_set_storm_amulet_thinker:OnCreated(keys)
	if IsServer() then
        self.duration = self:GetAbility():GetSpecialValueFor("duration")
        self.lightning_incoming = self:GetAbility():GetSpecialValueFor("lightning_incoming")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()

		parent:EmitSound("Hero_Oracle.RainOfDestiny.Cast")
		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_era/chaotic_set_storm/amulet_rain.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,1,1))
		self:AddParticle(self.particle, false, false, -1, false, false)

		self:StartIntervalThink(1)
	end
end

function modifier_item_set_storm_amulet_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end

function modifier_item_set_storm_amulet_thinker:OnIntervalThink(index)
	local ability = self:GetAbility()
	if not ability then
		self:Destroy()
		return
	end

	local parent = self:GetParent()
	local caster = self:GetCaster()

	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, unit in ipairs(enemies) do
		if IsValid(unit) and unit:IsAlive() then
            if not unit:HasModifier("modifier_item_set_storm_active") then
                local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
                ParticleManager:SetParticleControlEnt(pfx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
                ParticleManager:SetParticleControlForward(pfx, 1, unit:GetForwardVector())  --方向
                ParticleManager:ReleaseParticleIndex(pfx)
                unit:EmitSound("Hero_Morphling.AdaptiveStrikeAgi.Target")
            end
            unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_set_storm_active", {duration = self.duration , stack = self.lightning_incoming})
		end
	end
end



-----

modifier_item_set_storm_amulet = advanced_modifier({})

function modifier_item_set_storm_amulet:IsDebuff()return false end
function modifier_item_set_storm_amulet:IsHidden()return true end
function modifier_item_set_storm_amulet:IsPurgable()return false end
function modifier_item_set_storm_amulet:RemoveOnDeath()return false end
function modifier_item_set_storm_amulet:DestroyOnExpire()	return false end

function modifier_item_set_storm_amulet:OnCreated(params)
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_set_storm_amulet:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_set_storm_amulet:AdvancedGetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_set_storm_amulet:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_amp
end






