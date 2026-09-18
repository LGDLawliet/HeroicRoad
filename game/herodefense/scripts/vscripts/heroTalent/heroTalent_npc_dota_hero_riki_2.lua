LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_riki_2", "heroTalent/heroTalent_npc_dota_hero_riki_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chaotic_fog_cloud_thinker", "chaotic_spell/class_1/chaotic_fog_cloud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_fog_cloud_buff", "chaotic_spell/class_1/chaotic_fog_cloud", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_riki_2 = class({})

function heroTalent_npc_dota_hero_riki_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_riki_2"
end
function heroTalent_npc_dota_hero_riki_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local ability = self:GetCaster():AddAbility("chaotic_fog_cloud")
				ability:SetLevel(1)
			end
		end)
	end
end
---------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_riki_2 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_riki_2:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_riki_2:IsDebuff() return false end	
function modifier_heroTalent_npc_dota_hero_riki_2:IsPurgable() return false end	
function modifier_heroTalent_npc_dota_hero_riki_2:RemoveOnDeath() return false end	
function modifier_heroTalent_npc_dota_hero_riki_2:OnCreated(params)
	self.crit = self:GetAbility():GetSpecialValueFor("crit")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	self:SetStackCount(0)
	if IsServer() then
		
	end
end

function modifier_heroTalent_npc_dota_hero_riki_2:CheckState()
	if self:GetParent():HasModifier("modifier_chaotic_fog_cloud_buff") then
		return{
			[MODIFIER_STATE_CANNOT_MISS] = true
		}
	end
end
function modifier_heroTalent_npc_dota_hero_riki_2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_heroTalent_npc_dota_hero_riki_2:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
function modifier_heroTalent_npc_dota_hero_riki_2:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():HasModifier("modifier_chaotic_fog_cloud_buff") then
		self:SetStackCount(self.attack_speed)
	else
		self:SetStackCount(0)
	end
	return self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_riki_2:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.attacker:HasModifier("modifier_chaotic_fog_cloud_buff") then
		return self.crit
	end
end
function modifier_heroTalent_npc_dota_hero_riki_2:OnTakeDamage(keys)

	if IsServer() and keys.attacker == self:GetParent() and keys.attacker:HasModifier("modifier_chaotic_fog_cloud_buff") then
		if not keys.unit:IsAlive() then
			local ability = keys.attacker:FindAbilityByName("chaotic_fog_cloud")
			if ability then
				CreateModifierThinker(keys.attacker, ability, "modifier_chaotic_fog_cloud_thinker", {duration = self:GetAbility():GetSpecialValueFor("duration")}, keys.unit:GetAbsOrigin(), keys.attacker:GetTeamNumber(), false)
			end
		end
	end
end