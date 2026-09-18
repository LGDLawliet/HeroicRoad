heroTalent_npc_dota_hero_spectre_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_spectre_4", "heroTalent/heroTalent_npc_dota_hero_spectre_4", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_spectre_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_spectre_4"
end

function heroTalent_npc_dota_hero_spectre_4:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Desolate",costKeys)
			end
		end)
	
	end

end

-------------------------
modifier_heroTalent_npc_dota_hero_spectre_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spectre_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spectre_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spectre_4:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spectre_4:OnCreated()
    if not IsServer() then
        return
    end
    self.attack_down = self:GetAbility():GetSpecialValueFor("attack_down")
end

function modifier_heroTalent_npc_dota_hero_spectre_4:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_spectre_4:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then
        return
    end
    if not self:GetAbility():GetAutoCastState() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then
        return
    end

    return -self.attack_down
end

function modifier_heroTalent_npc_dota_hero_spectre_4:OnTakeDamage(keys)
    if not IsServer() then
        return
    end
    if not self:GetAbility():GetAutoCastState() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then
        return
    end
    if not keys.unit:IsAlive() then
        print("击杀了敌方，改变结果")
        keys.unit:SetHealth(1)
    end
end