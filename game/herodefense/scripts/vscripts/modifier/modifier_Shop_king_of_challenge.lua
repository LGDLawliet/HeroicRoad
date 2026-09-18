
--------------------------------------------------------------------------------
modifier_Shop_king_of_challenge1 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_king_of_challenge1:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_king_of_challenge1:IsDebuff()return false end
function modifier_Shop_king_of_challenge1:IsStunDebuff()return false end
function modifier_Shop_king_of_challenge1:IsPurgable()return false end
function modifier_Shop_king_of_challenge1:GetTexture() return "queen_of_pain/arcana/queenofpain_scream_of_pain_alt1" end
function modifier_Shop_king_of_challenge1:IsPurgeException() 	return false end
function modifier_Shop_king_of_challenge1:RemoveOnDeath() return false end

function modifier_Shop_king_of_challenge1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end

function modifier_Shop_king_of_challenge1:GetModifierBonusStats_Strength()	return 6 end
function modifier_Shop_king_of_challenge1:GetModifierBonusStats_Intellect()	return 6 end
function modifier_Shop_king_of_challenge1:GetModifierBonusStats_Agility()	return 6 end

function modifier_Shop_king_of_challenge1:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_king_of_challenge1:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end


modifier_Shop_king_of_challenge2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_king_of_challenge2:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_king_of_challenge2:IsDebuff()return false end
function modifier_Shop_king_of_challenge2:IsStunDebuff()return false end
function modifier_Shop_king_of_challenge2:IsPurgable()return false end
function modifier_Shop_king_of_challenge2:GetTexture() return "queen_of_pain/arcana/queenofpain_scream_of_pain_alt1" end
function modifier_Shop_king_of_challenge2:IsPurgeException() 	return false end
function modifier_Shop_king_of_challenge2:RemoveOnDeath() return false end

function modifier_Shop_king_of_challenge2:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

		

	}
end


function modifier_Shop_king_of_challenge2:GetModifierMagicalResistanceBonus() return 8 end

function modifier_Shop_king_of_challenge2:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_king_of_challenge2:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

modifier_Shop_king_of_challenge3 = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Shop_king_of_challenge3:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_king_of_challenge3:IsDebuff()return false end
function modifier_Shop_king_of_challenge3:IsStunDebuff()return false end
function modifier_Shop_king_of_challenge3:IsPurgable()return false end
function modifier_Shop_king_of_challenge3:GetTexture() return "queen_of_pain/arcana/queenofpain_scream_of_pain_alt1" end
function modifier_Shop_king_of_challenge3:IsPurgeException() 	return false end
function modifier_Shop_king_of_challenge3:RemoveOnDeath() return false end

function modifier_Shop_king_of_challenge3:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_Shop_king_of_challenge3:Advanced_GetModifierSpellAmplifyBonus()   return 4 end
function modifier_Shop_king_of_challenge3:OnCreated(keys)
	if IsServer() then
		print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_king_of_challenge3:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end