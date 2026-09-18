heroTalent_npc_dota_hero_elder_titan = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan", "heroTalent/heroTalent_npc_dota_hero_elder_titan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_effect", "heroTalent/heroTalent_npc_dota_hero_elder_titan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_start", "heroTalent/heroTalent_npc_dota_hero_elder_titan", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_elder_titan:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_elder_titan"
end

function heroTalent_npc_dota_hero_elder_titan:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_elder_titan = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_elder_titan:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_elder_titan:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_elder_titan:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_elder_titan:IsAura()
	return true
end

function modifier_heroTalent_npc_dota_hero_elder_titan:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_elder_titan_effect" end
function modifier_heroTalent_npc_dota_hero_elder_titan:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_heroTalent_npc_dota_hero_elder_titan:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_elder_titan:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_elder_titan:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end

function modifier_heroTalent_npc_dota_hero_elder_titan:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_Wave_Start = {}
	}
end
function modifier_heroTalent_npc_dota_hero_elder_titan:OnWaveStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	self.radius = self:GetAbility():GetSpecialValueFor("radius") 
	self.max = self:GetAbility():GetSpecialValueFor("max") 
	self.duration = self:GetAbility():GetSpecialValueFor("duration") 
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  

   	for i, unit in pairs(units) do
		if unit ~= caster then
           unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_elder_titan_start", {duration = self.duration})
	   	    if i >= self.max then
			    break
		    end
		end
   	end
    caster:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_elder_titan_start", {duration = self.duration})
end

modifier_heroTalent_npc_dota_hero_elder_titan_effect = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_elder_titan_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_elder_titan_effect:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_elder_titan_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_elder_titan_effect:OnCreated(keys)
	self.down = self:GetAbility():GetSpecialValueFor("down")*0.01
	self.bonus_armor = -math.max(self:GetParent():GetPhysicalArmorValue(false)*self.down	,0)
	self.bonus_magic_resistance =-math.max(self:GetParent():Script_GetMagicalArmorValue(true,self:GetAbility())*self.down*100	,0)
	
	if IsServer() then

		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_magical.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( pfx, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		self:AddParticle( pfx, false, false, -1, true, false )
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( pfx, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		self:AddParticle( pfx, false, false, -1, true, false )
	end
end
function modifier_heroTalent_npc_dota_hero_elder_titan_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_elder_titan_effect:GetModifierMagicalResistanceBonus()	return self.bonus_magic_resistance end

function modifier_heroTalent_npc_dota_hero_elder_titan_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_elder_titan_effect:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_heroTalent_npc_dota_hero_elder_titan_start = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_elder_titan_start:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_start:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_start:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_start:OnCreated(keys)
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.magic_res = self:GetAbility():GetSpecialValueFor("magic_res")
end
function modifier_heroTalent_npc_dota_hero_elder_titan_start:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_elder_titan_start:GetModifierMagicalResistanceBonus()	return self.magic_res end

function modifier_heroTalent_npc_dota_hero_elder_titan_start:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_elder_titan_start:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end