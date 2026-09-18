LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kez", "heroTalent/heroTalent_npc_dota_hero_kez", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_kez = class({})

function heroTalent_npc_dota_hero_kez:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_kez"
end

--------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_kez = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_kez:IsHidden()return true end
function modifier_heroTalent_npc_dota_hero_kez:IsDebuff()return false end
function modifier_heroTalent_npc_dota_hero_kez:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_kez:RemoveOnDeath()return false end
function modifier_heroTalent_npc_dota_hero_kez:OnCreated()
    self.attack = self:GetAbility():GetSpecialValueFor("attack")
    self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
    self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
end
function modifier_heroTalent_npc_dota_hero_kez:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_kez:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if keys.damage_category~= DOTA_DAMAGE_CATEGORY_ATTACK then
        return
    end
    return self.attack +  self.bonus_attack*self:GetParent():GetLevel()
end

function modifier_heroTalent_npc_dota_hero_kez:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsAttacking() then
			return -self.incoming
		end
	end
	return 
end

