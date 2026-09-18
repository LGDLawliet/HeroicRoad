heroTalent_npc_dota_hero_enigma_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_enigma_2", "heroTalent/heroTalent_npc_dota_hero_enigma_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_enigma_2_effect", "heroTalent/heroTalent_npc_dota_hero_enigma_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_enigma_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_enigma_2"
end
function heroTalent_npc_dota_hero_enigma_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/enigma/enigma_ambient_warp.vpcf", context )
end
function heroTalent_npc_dota_hero_enigma_2:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_enigma_2")
	if modifier then
		modifier:LevelUpGain()
	end
end


modifier_heroTalent_npc_dota_hero_enigma_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_enigma_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_enigma_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_enigma_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_enigma_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_enigma_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_enigma_2:GetEffectName() return "particles/rebuild/spell/enigma/enigma_ambient_warp.vpcf" end
function modifier_heroTalent_npc_dota_hero_enigma_2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_enigma_2:OnCreated(keys)
	if IsClient() then
		return
	end

	--智力不用改
	local parent = self:GetParent()
	local level = parent:GetLevel()-1
	parent:SetBaseStrength(50+level*5)
	parent:SetBaseAgility(50+level*5)
	parent:SetBaseIntellect(50+level*5)
	self:StartIntervalThink(1)
end

function modifier_heroTalent_npc_dota_hero_enigma_2:OnIntervalThink()
	local parent = self:GetParent()
	-- local level = parent:GetLevel()
	-- local attribute = level*4+40
	-- parent:SetBaseStrength(attribute)
	-- parent:SetBaseAgility(attribute)
	-- parent:SetBaseIntellect(attribute)


	local str = parent:GetStrength()
	local agi = parent:GetAgility()
	local int = parent:GetIntellect(false)
	
	if str>=agi and str>=int then
		-- parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH )
		self:SetStackCount(DOTA_ATTRIBUTE_STRENGTH)
		return
	end
	if agi>=str and agi>=int then
		-- parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY  )
		self:SetStackCount(DOTA_ATTRIBUTE_AGILITY)
		return
	end
	if int>=str and int>=agi then
		-- parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT   )
		self:SetStackCount(DOTA_ATTRIBUTE_INTELLECT)
		return
	end
end

function modifier_heroTalent_npc_dota_hero_enigma_2:LevelUpGain()
	local parent = self:GetParent()
	local str_gain = parent:GetStrengthGain()
	local agi_gain = parent:GetAgilityGain()
	local int_gain = parent:GetIntellectGain()
	parent:SetBaseStrength(parent:GetBaseStrength() + (5-str_gain))
	parent:SetBaseAgility(parent:GetBaseAgility() + (5-agi_gain))
	parent:SetBaseIntellect(parent:GetBaseIntellect() + (5-int_gain))

end


function modifier_heroTalent_npc_dota_hero_enigma_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_STR,
		advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_AGI,
		advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_INT,
    }
end

function modifier_heroTalent_npc_dota_hero_enigma_2:Advanced_GetModifier_PrimaryAttributeOverride_Str()
    return self:GetStackCount()==DOTA_ATTRIBUTE_STRENGTH and 1 or 0
end
function modifier_heroTalent_npc_dota_hero_enigma_2:Advanced_GetModifier_PrimaryAttributeOverride_Agi()
    return self:GetStackCount()==DOTA_ATTRIBUTE_AGILITY and 1 or 0
end
function modifier_heroTalent_npc_dota_hero_enigma_2:Advanced_GetModifier_PrimaryAttributeOverride_Int()
    return self:GetStackCount()==DOTA_ATTRIBUTE_INTELLECT and 1 or 0
end