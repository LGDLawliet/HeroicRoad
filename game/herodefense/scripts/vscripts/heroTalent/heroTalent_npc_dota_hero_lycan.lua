heroTalent_npc_dota_hero_lycan = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lycan_passive", "heroTalent/heroTalent_npc_dota_hero_lycan", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_lycan:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_lycan_passive"
end
----------------------

modifier_heroTalent_npc_dota_hero_lycan_passive = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lycan_passive:IsHidden()return true end
function modifier_heroTalent_npc_dota_hero_lycan_passive:IsDebuff()return false end
function modifier_heroTalent_npc_dota_hero_lycan_passive:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_lycan_passive:RemoveOnDeath()return false end

function modifier_heroTalent_npc_dota_hero_lycan_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
		--MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_lycan_passive:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_StatusResistance,
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
	return funcs
end

function modifier_heroTalent_npc_dota_hero_lycan_passive:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() then
		if keys.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if keys.attacker ~= self:GetParent() then
			return
		end

		local pct = self:GetAbility():GetSpecialValueFor("chance")
		local random = math.random
		if pct > random(0,100) then
			self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit" )
			self.record = keys.record
			return self.crit_mult
		end
	end
end
function modifier_heroTalent_npc_dota_hero_lycan_passive:OnAttackLanded( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
		end
	end
end

function modifier_heroTalent_npc_dota_hero_lycan_passive:GetModifierModelChange()
    return "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"
end


function modifier_heroTalent_npc_dota_hero_lycan_passive:Advanced_GetModifier_StatusResistance()
    return self:GetAbility():GetSpecialValueFor("status")
end

function modifier_heroTalent_npc_dota_hero_lycan_passive:GetModifierMoveSpeed_AbsoluteMin()
    return self:GetAbility():GetSpecialValueFor("move_min")
end

function modifier_heroTalent_npc_dota_hero_lycan_passive:OnDeath(params)
    if params.attacker == self:GetParent() then
        local allies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetOrigin(),
            nil,
            self:GetAbility():GetSpecialValueFor("radius"),
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
            FIND_ANY_ORDER,
            false
        )

        for _, ally in pairs(allies) do
            local heal_amount = ally:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("heal")*0.01
            local fhealing = ally:Heal(heal_amount, self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,ally, heal_amount, nil) 
        end
    end
end