heroTalent_npc_dota_hero_witch_doctor = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_witch_doctor", "heroTalent/heroTalent_npc_dota_hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_witch_doctor:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_witch_doctor:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_witch_doctor:IsStealable() 				return true end
function heroTalent_npc_dota_hero_witch_doctor:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_witch_doctor:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_witch_doctor" end

---------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_witch_doctor = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_witch_doctor:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_witch_doctor:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_witch_doctor:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_witch_doctor:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_witch_doctor:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_witch_doctor:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
        local heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
        local heal_amp_lvl = self:GetAbility():GetSpecialValueFor("heal_amp_lvl")
        local heal_amp_all = heal_amp_lvl*self:GetParent():GetLevel() + heal_amp
        self:StartIntervalThink(1)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo_flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        -- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true )
        self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end

function modifier_heroTalent_npc_dota_hero_witch_doctor:OnIntervalThink()
    local heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
    local heal_amp_lvl = self:GetAbility():GetSpecialValueFor("heal_amp_lvl")
    local heal_amp_all = heal_amp_lvl*self:GetParent():GetLevel() + heal_amp
end


-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_witch_doctor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_witch_doctor:Advanced_GetModifierHealAMP_Percentage(keys)
    local heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
    local heal_amp_lvl = self:GetAbility():GetSpecialValueFor("heal_amp_lvl")
    local heal_amp_all = heal_amp_lvl*self:GetParent():GetLevel() + heal_amp
	return heal_amp_all
end
