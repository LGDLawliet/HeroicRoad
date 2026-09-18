heroTalent_npc_dota_hero_doom_bringer_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_doom_bringer_2", "heroTalent/heroTalent_npc_dota_hero_doom_bringer_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_doom_bringer_2_buff", "heroTalent/heroTalent_npc_dota_hero_doom_bringer_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Treasure1_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)



function heroTalent_npc_dota_hero_doom_bringer_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_doom_bringer_2" end
function heroTalent_npc_dota_hero_doom_bringer_2:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_doom_bringer_2")
	if modifier then
		modifier:LevelUpGain()
	end
end

function heroTalent_npc_dota_hero_doom_bringer_2:OnSpellStart()
    self.caster = self:GetCaster()
    local caster = self.caster
    caster:AddNewModifier(caster,self,"modifier_item_hd_Treasure1_oblation",{})
end
--------------------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_doom_bringer_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_doom_bringer_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:ADDeclareFunctions()
	return{
		MODIFIER_PROPERTY_BECOME_UNIVERSAL,
	}
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:GetModifierBecomeUniversal()
	return 1
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:OnCreated(keys)
    local parent = self:GetParent()
	local level = parent:GetLevel()-1
	parent:SetBaseStrength(37+level*3.7)
	parent:SetBaseAgility(37+level*3.7)
	parent:SetBaseIntellect(37+level*3.7)
end
function modifier_heroTalent_npc_dota_hero_doom_bringer_2:LevelUpGain()
	local parent = self:GetParent()
	local str_gain = parent:GetStrengthGain()
	local agi_gain = parent:GetAgilityGain()
	local int_gain = parent:GetIntellectGain()
	parent:SetBaseStrength(parent:GetBaseStrength() + (3.7-str_gain))
	parent:SetBaseAgility(parent:GetBaseAgility() + (3.7-agi_gain))
	parent:SetBaseIntellect(parent:GetBaseIntellect() + (3.7-int_gain))
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
