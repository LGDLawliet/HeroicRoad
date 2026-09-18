--
heroTalent_npc_dota_hero_slardar = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_slardar", "heroTalent/heroTalent_npc_dota_hero_slardar", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_slardar:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_slardar"
end



modifier_heroTalent_npc_dota_hero_slardar = class({})

function modifier_heroTalent_npc_dota_hero_slardar:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_slardar:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_slardar:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_slardar:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_slardar:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_slardar:GetEffectName() return "particles/units/heroes/hero_slardar/slardar_sprint_river.vpcf" end
function modifier_heroTalent_npc_dota_hero_slardar:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_slardar:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_slardar:OnCreated(keys)
	if IsServer() then
		self:GetParent():SetHullRadius(0.01)
	end
end


function modifier_heroTalent_npc_dota_hero_slardar:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return 30
end
function modifier_heroTalent_npc_dota_hero_slardar:GetActivityTranslationModifiers( params )
	return "sprint"
end

function modifier_heroTalent_npc_dota_hero_slardar:CheckState()
	if not self:GetParent():IsRealHero() then
		return 
	end
	local state = {
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
	

end


