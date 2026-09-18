creep_special_gain_soul_transfer = class({})

LinkLuaModifier("modifier_creep_special_gain_soul_transfer", "special_gain/creep_special_gain_soul_transfer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_soul_transfer_active", "special_gain/creep_special_gain_soul_transfer", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_soul_transfer:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_soul_transfer"
end

-------------------------------------------------
modifier_creep_special_gain_soul_transfer = advanced_modifier({})
function modifier_creep_special_gain_soul_transfer:IsHidden() return false end
function modifier_creep_special_gain_soul_transfer:IsPurgable() return false end
function modifier_creep_special_gain_soul_transfer:IsDebuff() return false end
function modifier_creep_special_gain_soul_transfer:OnCreated() 
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
end
function modifier_creep_special_gain_soul_transfer:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
end

function modifier_creep_special_gain_soul_transfer:OnDeath(keys)
    if not IsServer() then
        return
    end
	local modifier = self:GetParent():FindModifierByName("modifier_Advanced_Ghost_Rocha_nosoul")
	if modifier then
		return
	end
    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
        -- keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Evil_debuff", {duration = 10})
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for i, unit in pairs(units) do
			if unit~=parent and unit:IsAlive() then
				local particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_soul_move.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				local aiblity = self:GetAbility()
				local fbonus_health = aiblity:GetSpecialValueFor("bonus_health")*parent:GetMaxHealth()*0.01
				local fbonus_damage = aiblity:GetSpecialValueFor("bonus_damage")*parent:GetDamageMax()*0.01


				unit:AddNewModifier(unit, aiblity, "modifier_creep_special_gain_soul_transfer_active", {bonus_health=fbonus_health,bonus_damage=fbonus_damage})
				if not unit:HasAbility("creep_special_gain_soul_transfer") then
					local ability = unit:AddAbility("creep_special_gain_soul_transfer")
					ability:SetLevel(1)
				end
				break
			end
		end
    end
end





-------------------

modifier_creep_special_gain_soul_transfer_active = advanced_modifier({})

function modifier_creep_special_gain_soul_transfer_active:IsDebuff() return false end
function modifier_creep_special_gain_soul_transfer_active:IsHidden() return false end
function modifier_creep_special_gain_soul_transfer_active:IsPurgable() return false end
function modifier_creep_special_gain_soul_transfer_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creep_special_gain_soul_transfer_active:RemoveOnDeath() return false end
function modifier_creep_special_gain_soul_transfer_active:GetTexture() return "lone_druid/ld_2021_immortal_ability_icon/ld_2021_immortal_spirit_link" end
function modifier_creep_special_gain_soul_transfer_active:OnCreated(keys)
	self.bonus_health = 10
	self.bonus_damage = 1
	local parent = self:GetParent()
	self.bonus_damage = keys.bonus_damage

	if IsServer() then
		parent:EmitSound("Hero_Visage.SoulAssumption.Cast")
		IncreaseHealth(parent,keys.bonus_health)
	end
end

function modifier_creep_special_gain_soul_transfer_active:ADDeclareFunctions()
	return {

		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_creep_special_gain_soul_transfer_active:Advanced_GetModifierBaseAttack_BonusDamage()	return self.bonus_damage end
