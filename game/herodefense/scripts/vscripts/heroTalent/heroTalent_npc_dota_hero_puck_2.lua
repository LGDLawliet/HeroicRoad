heroTalent_npc_dota_hero_puck_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_puck_2", "heroTalent/heroTalent_npc_dota_hero_puck_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_puck_2_effect", "heroTalent/heroTalent_npc_dota_hero_puck_2", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_puck_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_puck_2"
end
function heroTalent_npc_dota_hero_puck_2:OnSpellStart()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_puck_2")
	if modifier then
		modifier:OnWaveEnd()
	end
end



modifier_heroTalent_npc_dota_hero_puck_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_puck_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_puck_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_puck_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_puck_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_puck_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_puck_2:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_puck.vpcf"  end
function modifier_heroTalent_npc_dota_hero_puck_2:StatusEffectPriority() return 999 end
function modifier_heroTalent_npc_dota_hero_puck_2:GetEffectName() return "particles/rebuild/puck_telent/puckof_the_light_spirit_form_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_puck_2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_puck_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		-- self:StartIntervalThink(0.5)
	end
end

function modifier_heroTalent_npc_dota_hero_puck_2:OnWaveEnd()
	if not self:GetParent():IsRealHero() then
		return false
	end
	Timers:CreateTimer(2, function()
		local parent = self:GetParent()
		local bonus_int =math.max( math.min(parent:GetIntellect(false)*0.02,20),1)
		fHDSendCustomOverheadEventMessage("msg_damage", parent, bonus_int, nil, nil, Vector(27, 221, 247), 0)
		self:SetStackCount(self:GetStackCount()+bonus_int)
	end)
	
end

function modifier_heroTalent_npc_dota_hero_puck_2:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_puck_2:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end



function modifier_heroTalent_npc_dota_hero_puck_2:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end
