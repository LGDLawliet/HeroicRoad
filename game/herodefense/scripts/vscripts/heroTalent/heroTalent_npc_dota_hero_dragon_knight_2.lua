heroTalent_npc_dota_hero_dragon_knight_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dragon_knight_2", "heroTalent/heroTalent_npc_dota_hero_dragon_knight_2", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_dragon_knight_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dragon_knight_2"
end


function heroTalent_npc_dota_hero_dragon_knight_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/dragon_knight/dragon_knight_2/effect.vpcf", context )

end

function heroTalent_npc_dota_hero_dragon_knight_2:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"elder_dragon_form",costKeys)
			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_dragon_knight_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_dragon_knight_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:OnCreated(table)
	self.str_speed = self:GetAbility():GetSpecialValueFor("str_speed")
	self.str_hp = self:GetAbility():GetSpecialValueFor("str_hp")
end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS
	}
end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():HasModifier("modifier_Primary_elder_dragon_form_transform") or self:GetParent():HasModifier("modifier_Middle_elder_dragon_form_transform") or self:GetParent():HasModifier("modifier_Advanced_elder_dragon_form_transform") then
		return self:GetParent():GetStrength()*self.str_speed
	end
	return 0
end
function modifier_heroTalent_npc_dota_hero_dragon_knight_2:AdvancedGetModifierHealthBonus()
	if self:GetParent():HasModifier("modifier_Primary_elder_dragon_form_transform") or self:GetParent():HasModifier("modifier_Middle_elder_dragon_form_transform") or self:GetParent():HasModifier("modifier_Advanced_elder_dragon_form_transform") then
		return self:GetParent():GetStrength()*self.str_hp
	end
	return 0
end
