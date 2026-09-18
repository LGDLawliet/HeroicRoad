heroTalent_npc_dota_hero_beastmaster = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_beastmaster", "heroTalent/heroTalent_npc_dota_hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_beastmaster_passive", "heroTalent/heroTalent_npc_dota_hero_beastmaster", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_beastmaster:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_beastmaster:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_beastmaster:IsStealable() 				return true end
function heroTalent_npc_dota_hero_beastmaster:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_beastmaster:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_beastmaster" end
-- function heroTalent_npc_dota_hero_beastmaster:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_beastmaster")
--     if modifier then
--         modifier.count = modifier.count +1
--     end
-- end


modifier_heroTalent_npc_dota_hero_beastmaster = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_beastmaster:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_beastmaster:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_beastmaster:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_beastmaster:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_beastmaster:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_beastmaster:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
        local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/beastmaster/summon_trgt.vpcf", PATTACH_ABSORIGIN, unit)
        local pos = unit:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
        ParticleManager:SetParticleControlForward(particle_cast_fx, 0,unit:GetForwardVector())  --方向
        pos.z = pos.z + 300
        ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
        ParticleManager:ReleaseParticleIndex(particle_cast_fx)
        unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_beastmaster_passive", {})
	end
end

function modifier_heroTalent_npc_dota_hero_beastmaster:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
		--advanced_MODIFIER_PROPERTY_SummonTime_Intensity
    }
end

function modifier_heroTalent_npc_dota_hero_beastmaster:Advanced_GetModifier_Summon_Intensity(keys)
	return self:GetAbility():GetSpecialValueFor("summon") + self:GetAbility():GetSpecialValueFor("bonus_summon")*self:GetCaster():GetLevel()
end

modifier_heroTalent_npc_dota_hero_beastmaster_passive = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_beastmaster_passive:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_passive:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_beastmaster_passive:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_passive:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_passive:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
		--advanced_MODIFIER_PROPERTY_SummonTime_Intensity
    }
end
function modifier_heroTalent_npc_dota_hero_beastmaster_passive:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit ~= self:GetParent() then
        return
    end
    local mana_return = self:GetCaster():GetMaxMana()*self:GetAbility():GetSpecialValueFor("mana_get")*0.01
    self:GetCaster():GiveMana(mana_return) 
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetCaster(), mana_return, nil)
end