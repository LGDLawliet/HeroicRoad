LinkLuaModifier( "modifier_item_hd_poison_fog", "items/item_hd_poison_fog.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_poison_fog_active", "items/item_hd_poison_fog.lua", LUA_MODIFIER_MOTION_NONE )


--Abilities
if item_hd_poison_fog == nil then
	item_hd_poison_fog = class({})
end

function item_hd_poison_fog:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
end

function item_hd_poison_fog:GetIntrinsicModifierName()
	return "modifier_item_hd_poison_fog"
end

function item_hd_poison_fog:GetCastRange()
	return self:GetSpecialValueFor("radius")-self:GetCaster():GetCastRangeBonus()
end

---------------------------------------------------------------------
--Modifiers
modifier_item_hd_poison_fog = advanced_modifier({})
function modifier_item_hd_poison_fog:IsDebuff() return true end
function modifier_item_hd_poison_fog:IsHidden() return true end
function modifier_item_hd_poison_fog:IsPurgable() return false end

function modifier_item_hd_poison_fog:OnCreated(params)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bonus_atb = self:GetAbility():GetSpecialValueFor("bonus_atb")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.bonus_poison_res = self:GetAbility():GetSpecialValueFor("bonus_poison_res")
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end

function modifier_item_hd_poison_fog:OnIntervalThink()
	if Game_State:IsInBattle() then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #enemies >= 1 and self:GetAbility():IsCooldownReady() then

			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:ReleaseParticleIndex(pfx)
			local name = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
		
			local pfx2 = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControl(pfx2, 1, Vector(self.radius, 1.5, self.radius))
			ParticleManager:ReleaseParticleIndex(pfx2)

			local pfx3 = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControl(pfx3, 1, Vector(self.radius, 1, self.radius/2))
			ParticleManager:ReleaseParticleIndex(pfx3)

			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self.caster, self.ability, "modifier_item_hd_poison_fog_active", {duration = self.duration})
			end
			self.ability:UseResources(true, true, true, true)
		end
	end
end

function modifier_item_hd_poison_fog:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
	}
end
function modifier_item_hd_poison_fog:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_atb
end
function modifier_item_hd_poison_fog:Advanced_GetModifierBonusStats_Agility()
	return self.bonus_atb
end
function modifier_item_hd_poison_fog:Advanced_GetModifierBonusStats_Intellect()
	return self.bonus_atb
end
function modifier_item_hd_poison_fog:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return -self.bonus_poison_res
end
-----------------------
modifier_item_hd_poison_fog_active = advanced_modifier({})
function modifier_item_hd_poison_fog_active:IsDebuff() return true end
function modifier_item_hd_poison_fog_active:IsHidden() return false end
function modifier_item_hd_poison_fog_active:IsPurgable() return false end


function modifier_item_hd_poison_fog_active:OnCreated(params)
	self.poison_res_down = self:GetAbility():GetSpecialValueFor("poison_res_down")
end

function modifier_item_hd_poison_fog_active:OnRefresh(params)
	self.poison_res_down = self:GetAbility():GetSpecialValueFor("poison_res_down")
end

function modifier_item_hd_poison_fog_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
	}
end
function modifier_item_hd_poison_fog_active:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return self.poison_res_down
end