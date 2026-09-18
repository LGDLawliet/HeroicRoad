heroTalent_npc_dota_hero_dark_seer_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dark_seer_2", "heroTalent/heroTalent_npc_dota_hero_dark_seer_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dark_seer_2_effect", "heroTalent/heroTalent_npc_dota_hero_dark_seer_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_dark_seer_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dark_seer_2"
end
function heroTalent_npc_dota_hero_dark_seer_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", context )

end

function heroTalent_npc_dota_hero_dark_seer_2:OnSpellStart()
	local target = self:GetCursorTarget()
    local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_dark_seer_2")
    if modifier then
        modifier.target = target
    end
end

modifier_heroTalent_npc_dota_hero_dark_seer_2 = class({})

function modifier_heroTalent_npc_dota_hero_dark_seer_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dark_seer_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_dark_seer_2:OnCreated()
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.target = self:GetParent()
        self:StartIntervalThink(1)
    end
end


function modifier_heroTalent_npc_dota_hero_dark_seer_2:OnIntervalThink()
    if not self.target:IsAlive() then
        self.target = self:GetParent()
        if not self:GetParent():IsAlive() then
            return
        end
    end
    local modifier = self.target:FindModifierByName("modifier_heroTalent_npc_dota_hero_dark_seer_2_effect")
    if modifier then
        modifier:SetDuration(1.5, true)
    else
        self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_dark_seer_2_effect", {duration = 1.5})
    end
end




modifier_heroTalent_npc_dota_hero_dark_seer_2_effect = class({})

function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:GetEffectName() return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf" end




function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:OnCreated(keys)
	if IsServer() then
        local parent = self:GetParent()
        parent:EmitSound("Hero_Dark_Seer.Surge")
	end
end


function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --技能伤害
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:GetModifierMoveSpeedBonus_Constant()
	return 300
end

function modifier_heroTalent_npc_dota_hero_dark_seer_2_effect:GetModifierIgnoreMovespeedLimit()             return   1  end