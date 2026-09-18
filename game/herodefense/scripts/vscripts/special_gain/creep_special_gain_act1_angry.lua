creep_special_gain_act1_angry = class({})

LinkLuaModifier("modifier_creep_special_gain_act1_angry", "special_gain/creep_special_gain_act1_angry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_act1_angry_effect", "special_gain/creep_special_gain_act1_angry", LUA_MODIFIER_MOTION_NONE)
function creep_special_gain_act1_angry:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_act1_angry"
end


modifier_creep_special_gain_act1_angry = advanced_modifier({})

function modifier_creep_special_gain_act1_angry:IsHidden()return false end
function modifier_creep_special_gain_act1_angry:IsDebuff()return false end
function modifier_creep_special_gain_act1_angry:IsPurgable()return false end
function modifier_creep_special_gain_act1_angry:IsPurgeException() 	return false end
function modifier_creep_special_gain_act1_angry:RemoveOnDeath() return false end
function modifier_creep_special_gain_act1_angry:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creep_special_gain_act1_angry:OnCreated(keys)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.attack = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.move = self:GetAbility():GetSpecialValueFor("move")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_creep_special_gain_act1_angry:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end


function modifier_creep_special_gain_act1_angry:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		local aiblity = self:GetAbility()
		local parent = self:GetParent()
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		local pfx_name1 = "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf"
		local sound_name = "Hero_Sven.WarCry"
		parent:EmitSound(sound_name)
		local pfx = ParticleManager:CreateParticle(pfx_name1, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 2, parent, PATTACH_POINT_FOLLOW, "attach_head", parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		for i, unit in pairs(units) do
			if unit~=parent and unit:IsAlive() then
				unit:AddNewModifier(unit, aiblity, "modifier_creep_special_gain_act1_angry_effect", {duration=self.duration})
			end 
		end
    end
   
end



modifier_creep_special_gain_act1_angry_effect = advanced_modifier({})
function modifier_creep_special_gain_act1_angry_effect:IsHidden()return false end
function modifier_creep_special_gain_act1_angry_effect:IsDebuff()return false end
function modifier_creep_special_gain_act1_angry_effect:IsPurgable()return false end
function modifier_creep_special_gain_act1_angry_effect:IsPurgeException() 	return false end
function modifier_creep_special_gain_act1_angry_effect:RemoveOnDeath() return false end
function modifier_creep_special_gain_act1_angry_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creep_special_gain_act1_angry_effect:GetTexture() return "furbolg_enrage_attack_speed" end
function modifier_creep_special_gain_act1_angry_effect:OnCreated(keys)
    self.attack = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.move = self:GetAbility():GetSpecialValueFor("move")
end
function modifier_creep_special_gain_act1_angry_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_creep_special_gain_act1_angry_effect:GetModifierMoveSpeedBonus_Percentage()	return self.move end
function modifier_creep_special_gain_act1_angry_effect:Advanced_GetModifierAttackSpeedPercentage()	return self.attack end

function modifier_creep_special_gain_act1_angry_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end