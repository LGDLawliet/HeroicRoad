heroTalent_npc_dota_hero_axe = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe", "heroTalent/heroTalent_npc_dota_hero_axe", LUA_MODIFIER_MOTION_NONE )


-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_axe:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_axe"
end



modifier_heroTalent_npc_dota_hero_axe = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_axe:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_axe:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_axe:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_axe:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_axe:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_axe:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		
		if self:GetParent():PassivesDisabled() then
			return
		end
		local taget = keys.attacker
		if not taget:IsAlive() then
			return -50
		end
		if taget:GetHealthPercent()<=7 or taget:GetHealth()<=self:GetParent():GetMaxHealth()*(_G.GAME_ROUND/50) then
			-- print("免疫")
			return -100
		end
	end
	
	
	return 
end


function modifier_heroTalent_npc_dota_hero_axe:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
