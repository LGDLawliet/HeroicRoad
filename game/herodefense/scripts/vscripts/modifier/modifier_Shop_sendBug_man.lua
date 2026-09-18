
--------------------------------------------------------------------------------
modifier_Shop_sendBug_man = class({})

function modifier_Shop_sendBug_man:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_sendBug_man:IsDebuff()return false end
function modifier_Shop_sendBug_man:IsStunDebuff()return false end
function modifier_Shop_sendBug_man:IsPurgable()return false end
function modifier_Shop_sendBug_man:GetTexture() return "beastmaster_primal_roar" end
function modifier_Shop_sendBug_man:IsPurgeException() 	return false end
function modifier_Shop_sendBug_man:RemoveOnDeath() return false end

function modifier_Shop_sendBug_man:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Shop_sendBug_man:GetModifierBonusStats_Strength()	return 5 end
function modifier_Shop_sendBug_man:GetModifierBonusStats_Intellect()	return 5 end
function modifier_Shop_sendBug_man:GetModifierBonusStats_Agility()	return 5 end

function modifier_Shop_sendBug_man:OnCreated(keys)
	if IsServer() then
		-- print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_sendBug_man:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end



modifier_Shop_sendBug_man_2 = class({})

function modifier_Shop_sendBug_man_2:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_sendBug_man_2:IsDebuff()return false end
function modifier_Shop_sendBug_man_2:IsStunDebuff()return false end
function modifier_Shop_sendBug_man_2:IsPurgable()return false end
function modifier_Shop_sendBug_man_2:GetTexture() return "beastmaster_primal_roar" end
function modifier_Shop_sendBug_man_2:IsPurgeException() 	return false end
function modifier_Shop_sendBug_man_2:RemoveOnDeath() return false end

function modifier_Shop_sendBug_man_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Shop_sendBug_man_2:GetModifierBonusStats_Strength()	return 6 end
function modifier_Shop_sendBug_man_2:GetModifierBonusStats_Intellect()	return 6 end
function modifier_Shop_sendBug_man_2:GetModifierBonusStats_Agility()	return 6 end

function modifier_Shop_sendBug_man_2:OnCreated(keys)
	if IsServer() then
		-- print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_sendBug_man_2:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end

modifier_Shop_sendBug_man_3 = class({})

function modifier_Shop_sendBug_man_3:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_sendBug_man_3:IsDebuff()return false end
function modifier_Shop_sendBug_man_3:IsStunDebuff()return false end
function modifier_Shop_sendBug_man_3:IsPurgable()return false end
function modifier_Shop_sendBug_man_3:GetTexture() return "beastmaster_primal_roar" end
function modifier_Shop_sendBug_man_3:IsPurgeException() 	return false end
function modifier_Shop_sendBug_man_3:RemoveOnDeath() return false end

function modifier_Shop_sendBug_man_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Shop_sendBug_man_3:GetModifierBonusStats_Strength()	return 7 end
function modifier_Shop_sendBug_man_3:GetModifierBonusStats_Intellect()	return 7 end
function modifier_Shop_sendBug_man_3:GetModifierBonusStats_Agility()	return 7 end

function modifier_Shop_sendBug_man_3:OnCreated(keys)
	if IsServer() then
		-- print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_sendBug_man_3:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end








modifier_Shop_sendBug_man_4 = class({})

function modifier_Shop_sendBug_man_4:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_sendBug_man_4:IsDebuff()return false end
function modifier_Shop_sendBug_man_4:IsStunDebuff()return false end
function modifier_Shop_sendBug_man_4:IsPurgable()return false end
function modifier_Shop_sendBug_man_4:GetTexture() return "beastmaster_primal_roar" end
function modifier_Shop_sendBug_man_4:IsPurgeException() 	return false end
function modifier_Shop_sendBug_man_4:RemoveOnDeath() return false end

function modifier_Shop_sendBug_man_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Shop_sendBug_man_4:GetModifierBonusStats_Strength()	return 8 end
function modifier_Shop_sendBug_man_4:GetModifierBonusStats_Intellect()	return 8 end
function modifier_Shop_sendBug_man_4:GetModifierBonusStats_Agility()	return 8 end

function modifier_Shop_sendBug_man_4:OnCreated(keys)
	if IsServer() then
		-- print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_sendBug_man_4:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end







modifier_Shop_sendBug_man_5 = class({})

function modifier_Shop_sendBug_man_5:IsHidden()
	if self:GetStackCount()>0 then
		return true
	end
	return false
end
function modifier_Shop_sendBug_man_5:IsDebuff()return false end
function modifier_Shop_sendBug_man_5:IsStunDebuff()return false end
function modifier_Shop_sendBug_man_5:IsPurgable()return false end
function modifier_Shop_sendBug_man_5:GetTexture() return "beastmaster_primal_roar" end
function modifier_Shop_sendBug_man_5:IsPurgeException() 	return false end
function modifier_Shop_sendBug_man_5:RemoveOnDeath() return false end

function modifier_Shop_sendBug_man_5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Shop_sendBug_man_5:GetModifierBonusStats_Strength()	return 10 end
function modifier_Shop_sendBug_man_5:GetModifierBonusStats_Intellect()	return 10 end
function modifier_Shop_sendBug_man_5:GetModifierBonusStats_Agility()	return 10 end

function modifier_Shop_sendBug_man_5:OnCreated(keys)
	if IsServer() then
		-- print(keys.hide)
		self.hide = false
		if keys.hide==1 then
			self.hide=true
		end
		self:StartIntervalThink(3)
	end
end

function modifier_Shop_sendBug_man_5:OnIntervalThink()
	local parent = self:GetParent()
	local id = parent:GetPlayerID()+1
	local type = _G.GAME_SHOP_HIDDEN[id]
	if type=="1" or type==1 then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end
