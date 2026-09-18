chaotic_wish = class({})
LinkLuaModifier("modifier_chaotic_wish", "chaotic_spell/class_9/chaotic_wish", LUA_MODIFIER_MOTION_NONE)

function chaotic_wish:GetIntrinsicModifierName() return "modifier_chaotic_wish" end



-- function chaotic_wish:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_wish/effect_cast/kalia_swordcraft.vpcf", context )

-- end



modifier_chaotic_wish = advanced_modifier({})

function modifier_chaotic_wish:IsDebuff()			return false end
function modifier_chaotic_wish:IsHidden() 		return true end
function modifier_chaotic_wish:IsPurgable() 		return false end
function modifier_chaotic_wish:IsPurgeException() return false end
function modifier_chaotic_wish:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_spell_count = ability:GetSpecialValueFor("bonus_spell_count")
	self.bonus_item_count = ability:GetSpecialValueFor("bonus_item_count")
	self.bonus_rune = ability:GetSpecialValueFor("bonus_rune")
end

function modifier_chaotic_wish:OnRefresh(keys)
	local ability = self:GetAbility()
	self.bonus_spell_count = ability:GetSpecialValueFor("bonus_spell_count")
	self.bonus_item_count = ability:GetSpecialValueFor("bonus_item_count")
	self.bonus_rune = ability:GetSpecialValueFor("bonus_rune")
end



function modifier_chaotic_wish:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount,
		advanced_MODIFIER_PROPERTY_Chaotic_Era_Item_GenerateCount,
		advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus,
	
	
    }
end


function modifier_chaotic_wish:Advanced_GetChaotic_Era_Spell_GenerateCount()
	local count = self.bonus_spell_count
	return count
end
function modifier_chaotic_wish:Advanced_GetChaotic_Era_Item_GenerateCount()
	local count = self.bonus_item_count
	if count%1>0 then
		local chance = (count%1)*100
		if chance>=RandomInt(1, 100) then
			count = count + 1
		end
	end
	return count
end
function modifier_chaotic_wish:Advanced_GetChaotic_Era_BountyBonus()
	return self.bonus_rune
end