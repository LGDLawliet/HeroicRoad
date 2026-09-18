

heroTalent_npc_dota_hero_lich_3 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lich_3", "heroTalent/heroTalent_npc_dota_hero_lich_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lich_3_buff", "heroTalent/heroTalent_npc_dota_hero_lich_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lich_3_speed", "heroTalent/heroTalent_npc_dota_hero_lich_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_lich_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_lich_3"
end
function heroTalent_npc_dota_hero_lich_3:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end


modifier_heroTalent_npc_dota_hero_lich_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lich_3:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lich_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_lich_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_lich_3:IsAura() return true end
function modifier_heroTalent_npc_dota_hero_lich_3:GetAuraDuration() return 0.5 end
function modifier_heroTalent_npc_dota_hero_lich_3:GetModifierAura() return "modifier_heroTalent_npc_dota_hero_lich_3_buff" end
function modifier_heroTalent_npc_dota_hero_lich_3:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_heroTalent_npc_dota_hero_lich_3:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_lich_3:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_lich_3:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_heroTalent_npc_dota_hero_lich_3:OnCreated(keys)
    self.ability = self:GetAbility()
	self.ice_outgoing = self.ability:GetSpecialValueFor("ice_outgoing")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.interval = self.ability:GetSpecialValueFor("interval")
	
    if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_heroTalent_npc_dota_hero_lich_3:OnIntervalThink()
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	for i, hero in pairs(heroes) do
		local damageTable = {
	   	victim = hero,
	   	attacker = caster,
	   	damage = self:GetAbility():GetSpecialValueFor("damage"),
	   	damage_type = self:GetAbility():GetAbilityDamageType(),
	   	damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
		}
		ApplyDamage(damageTable)	
		local modifier = hero:FindModifierByName("modifier_heroTalent_npc_dota_hero_lich_3_buff")
		if modifier then
			local duration = self.ability:GetSpecialValueFor("duration")
			local gain = caster:GetModifierDurationGainIndex(1)
			hero:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_lich_3_speed", {duration = duration*gain})
		end
	end

	local self_buff = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_lich_3_buff")
	if self_buff then
		self_buff:ForceRefresh()
	end
end


modifier_heroTalent_npc_dota_hero_lich_3_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lich_3_buff:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lich_3_buff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_lich_3_buff:IsPurgable() return false end
-- function modifier_heroTalent_npc_dota_hero_lich_3_buff:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_lich_3_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_lich_3_buff:OnCreated(table)
	self.ice_outgoing = self:GetAbility():GetSpecialValueFor("ice_outgoing")*self:GetCaster():GetLevel()
end

function modifier_heroTalent_npc_dota_hero_lich_3_buff:OnRefresh(table)
	self.ice_outgoing = self:GetAbility():GetSpecialValueFor("ice_outgoing")*self:GetCaster():GetLevel()
end

function modifier_heroTalent_npc_dota_hero_lich_3_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_heroTalent_npc_dota_hero_lich_3_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_heroTalent_npc_dota_hero_lich_3_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not IsIceDamage(keys) then return end
	
	return self.ice_outgoing
end
function modifier_heroTalent_npc_dota_hero_lich_3_buff:OnTooltip()
	return self.ice_outgoing
end


modifier_heroTalent_npc_dota_hero_lich_3_speed = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lich_3_speed:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lich_3_speed:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_lich_3_speed:IsPurgable() return false end
-- function modifier_heroTalent_npc_dota_hero_lich_3_speed:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_lich_3_speed:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_heroTalent_npc_dota_hero_lich_3_speed:OnCreated(table)
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_heroTalent_npc_dota_hero_lich_3_speed:OnRefresh(table)
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_heroTalent_npc_dota_hero_lich_3_speed:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
end
function modifier_heroTalent_npc_dota_hero_lich_3_speed:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_heroTalent_npc_dota_hero_lich_3_speed:Advanced_GetModifierAttackSpeedPercentage()
	return self.speed
end
function modifier_heroTalent_npc_dota_hero_lich_3_speed:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end