heroTalent_npc_dota_hero_puck = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_puck", "heroTalent/heroTalent_npc_dota_hero_puck", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_puck_effect", "heroTalent/heroTalent_npc_dota_hero_puck", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_puck:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_puck"
end



modifier_heroTalent_npc_dota_hero_puck = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_puck:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_puck:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_puck:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_puck:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_puck:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_puck:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.5)
	end
end

function modifier_heroTalent_npc_dota_hero_puck:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() and self:GetParent():IsAlive() then
		self:GetAbility():UseResources(true, true, true,true)
		self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_heroTalent_npc_dota_hero_puck_effect",
			{	duration = 60})
	end
end

function modifier_heroTalent_npc_dota_hero_puck:OnWaveStart()
	if not self:GetParent():IsRealHero() then
		return false
	end
	self:GetAbility():UseResources(true, true, true,true)
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_heroTalent_npc_dota_hero_puck_effect",
		{	duration = 60})
end

function modifier_heroTalent_npc_dota_hero_puck:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end




modifier_heroTalent_npc_dota_hero_puck_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_puck_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_puck_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_puck_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_puck_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_puck_effect:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_puck.vpcf"  end
function modifier_heroTalent_npc_dota_hero_puck_effect:StatusEffectPriority() return 999 end
function modifier_heroTalent_npc_dota_hero_puck_effect:GetEffectName() return "particles/rebuild/puck_telent/puckof_the_light_spirit_form_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_puck_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_puck_effect:OnCreated(table)
	if IsServer() then
		self.bonus_int = self:GetParent():GetIntellect(false)*0.15
	end
end

function modifier_heroTalent_npc_dota_hero_puck_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_puck_effect:GetModifierBonusStats_Intellect()
	return self.bonus_int
end


function modifier_heroTalent_npc_dota_hero_puck_effect:Advanced_GetModifierSpellAmplifyBonus()
	return 30
end



-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_puck_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_heroTalent_npc_dota_hero_puck_effect:Advanced_GetModifierCastRangeBonusStacking(keys)
    return 350
end

