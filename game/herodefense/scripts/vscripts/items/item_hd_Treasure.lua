
LinkLuaModifier("modifier_item_hd_Treasure5_shop", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Treasure1_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Treasure2_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Treasure3_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Treasure4_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Treasure5_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)




item_hd_Treasure1 = class({})

function item_hd_Treasure1:OnSpellStart()
	if IsServer() then

		
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,1)

		self:SpendCharge(0)
	end
end




item_hd_Treasure2 = class({})

function item_hd_Treasure2:OnSpellStart()
	if IsServer() then

		
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,2)

		self:SpendCharge(0)
	end
end



item_hd_Treasure3 = class({})

function item_hd_Treasure3:OnSpellStart()
	if IsServer() then

		
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,3)

		self:SpendCharge(0)
	end
end




item_hd_Treasure4 = class({})

function item_hd_Treasure4:OnSpellStart()
	if IsServer() then

		local bounuslevel = (_G.GAME_ROUND-1) /3.5 +1
        bounuslevel = bounuslevel - bounuslevel%1
        bounuslevel = math.min(bounuslevel,6)
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,math.max(bounuslevel,4))

		self:SpendCharge(0)
	end
end




item_hd_Treasure1_shop = class({})

function item_hd_Treasure1_shop:OnSpellStart()
	if IsServer() then

		
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,1)

		self:SpendCharge(0)
	end
end




item_hd_Treasure2_shop = class({})

function item_hd_Treasure2_shop:OnSpellStart()
	if IsServer() then

		
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,2)

		self:SpendCharge(0)
	end
end



item_hd_Treasure3_shop = class({})

function item_hd_Treasure3_shop:OnSpellStart()
	if IsServer() then

		
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,3)

		self:SpendCharge(0)
	end
end




item_hd_Treasure4_shop = class({})

function item_hd_Treasure4_shop:OnSpellStart()
	if IsServer() then

		local bounuslevel = (_G.GAME_ROUND-1) /3.5 +1
        bounuslevel = bounuslevel - bounuslevel%1
        bounuslevel = math.min(bounuslevel,6)
		local nPlayerID = self:GetCaster():GetPlayerID()
		BonusItems:SpawnBonusItems(nPlayerID,math.max(bounuslevel,4))

		self:SpendCharge(0)
	end
end




item_hd_Treasure5_shop = class({})

function item_hd_Treasure5_shop:OnSpellStart()
	if IsServer() then

	
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_item_hd_Treasure5_oblation", {})

		self:SpendCharge(0)
	end
end





modifier_item_hd_Treasure5_shop = class({})

function modifier_item_hd_Treasure5_shop:IsHidden()	return false end
function modifier_item_hd_Treasure5_shop:IsDebuff()	return false end
function modifier_item_hd_Treasure5_shop:IsPurgable()	return false end
function modifier_item_hd_Treasure5_shop:IsPurgeException()	return false end
function modifier_item_hd_Treasure5_shop:RemoveOnDeath()	return false end
function modifier_item_hd_Treasure5_shop:GetTexture() return "item_Treasure5" end

function modifier_item_hd_Treasure5_shop:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure5_shop:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_item_hd_Treasure5_shop:OnCost()
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return true
	else
		return false
	end
end




item_hd_Treasure1_oblation = class({})
function item_hd_Treasure1_oblation:CastFilterResult( vLoc )
	if IsServer() then
		if self:GetCaster():GetGold()<2000 then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end
function item_hd_Treasure1_oblation:GetCustomCastError( vLoc )
	if IsServer() then
		return "#dota_hud_greevils_not_enough_gold"
	end

end
function item_hd_Treasure1_oblation:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:ModifyGoldFiltered(-2000,true,DOTA_ModifyGold_PurchaseItem  )
		caster:AddNewModifier(caster, self, "modifier_item_hd_Treasure1_oblation", {})
		self:SpendCharge(0)
	end
end




item_hd_Treasure2_oblation = class({})
function item_hd_Treasure2_oblation:CastFilterResult( vLoc )
	if IsServer() then
		if self:GetCaster():GetGold()<4000 then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end
function item_hd_Treasure2_oblation:GetCustomCastError( vLoc )
	if IsServer() then
		return "#dota_hud_greevils_not_enough_gold"
	end

end
function item_hd_Treasure2_oblation:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:ModifyGoldFiltered(-4000,true,DOTA_ModifyGold_PurchaseItem  )
		caster:AddNewModifier(caster, self, "modifier_item_hd_Treasure2_oblation", {})
		self:SpendCharge(0)
	end
end



item_hd_Treasure3_oblation = class({})
function item_hd_Treasure3_oblation:CastFilterResult( vLoc )
	if IsServer() then
		if self:GetCaster():GetGold()<8000 then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end
function item_hd_Treasure3_oblation:GetCustomCastError( vLoc )
	if IsServer() then
		return "#dota_hud_greevils_not_enough_gold"
	end

end
function item_hd_Treasure3_oblation:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:ModifyGoldFiltered(-8000,true,DOTA_ModifyGold_PurchaseItem  )
		caster:AddNewModifier(caster, self, "modifier_item_hd_Treasure3_oblation", {})
		self:SpendCharge(0)
	end
end
item_hd_Treasure4_oblation = class({})
function item_hd_Treasure4_oblation:CastFilterResult( vLoc )
	if IsServer() then
		if self:GetCaster():GetGold()<12000 then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end
function item_hd_Treasure4_oblation:GetCustomCastError( vLoc )
	if IsServer() then
		return "#dota_hud_greevils_not_enough_gold"
	end

end
function item_hd_Treasure4_oblation:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:ModifyGoldFiltered(-12000,true,DOTA_ModifyGold_PurchaseItem  )
		caster:AddNewModifier(caster, self, "modifier_item_hd_Treasure4_oblation", {})
		self:SpendCharge(0)
	end
end
item_hd_Treasure5_oblation = class({})
function item_hd_Treasure5_oblation:CastFilterResult( vLoc )
	if IsServer() then
		if self:GetCaster():GetGold()<25000 then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end
function item_hd_Treasure5_oblation:GetCustomCastError( vLoc )
	if IsServer() then
		return "#dota_hud_greevils_not_enough_gold"
	end

end
function item_hd_Treasure5_oblation:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:ModifyGoldFiltered(-25000,true,DOTA_ModifyGold_PurchaseItem  )
		caster:AddNewModifier(caster, self, "modifier_item_hd_Treasure5_oblation", {})
		self:SpendCharge(0)
	end
end




modifier_item_hd_Treasure1_oblation =  modifier_item_hd_Treasure1_oblation or class({})
function modifier_item_hd_Treasure1_oblation:IsHidden()	return false end
function modifier_item_hd_Treasure1_oblation:IsDebuff()	return false end
function modifier_item_hd_Treasure1_oblation:IsPurgable()	return false end
function modifier_item_hd_Treasure1_oblation:IsPurgeException()	return false end
function modifier_item_hd_Treasure1_oblation:RemoveOnDeath()	return false end
function modifier_item_hd_Treasure1_oblation:GetTexture() return "item_Treasure_oblation_1" end
function modifier_item_hd_Treasure1_oblation:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure1_oblation:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure1_oblation:OnCost()
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return true
	else
		return false
	end
end



modifier_item_hd_Treasure2_oblation =  modifier_item_hd_Treasure2_oblation or class({})
function modifier_item_hd_Treasure2_oblation:IsHidden()	return false end
function modifier_item_hd_Treasure2_oblation:IsDebuff()	return false end
function modifier_item_hd_Treasure2_oblation:IsPurgable()	return false end
function modifier_item_hd_Treasure2_oblation:IsPurgeException()	return false end
function modifier_item_hd_Treasure2_oblation:RemoveOnDeath()	return false end
function modifier_item_hd_Treasure2_oblation:GetTexture() return "item_Treasure_oblation_2" end
function modifier_item_hd_Treasure2_oblation:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure2_oblation:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure2_oblation:OnCost()
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return true
	else
		return false
	end
end





modifier_item_hd_Treasure3_oblation =  modifier_item_hd_Treasure3_oblation or class({})
function modifier_item_hd_Treasure3_oblation:IsHidden()	return false end
function modifier_item_hd_Treasure3_oblation:IsDebuff()	return false end
function modifier_item_hd_Treasure3_oblation:IsPurgable()	return false end
function modifier_item_hd_Treasure3_oblation:IsPurgeException()	return false end
function modifier_item_hd_Treasure3_oblation:RemoveOnDeath()	return false end
function modifier_item_hd_Treasure3_oblation:GetTexture() return "item_Treasure_oblation_3" end
function modifier_item_hd_Treasure3_oblation:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure3_oblation:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure3_oblation:OnCost()
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return true
	else
		return false
	end
end




modifier_item_hd_Treasure4_oblation =  modifier_item_hd_Treasure4_oblation or class({})
function modifier_item_hd_Treasure4_oblation:IsHidden()	return false end
function modifier_item_hd_Treasure4_oblation:IsDebuff()	return false end
function modifier_item_hd_Treasure4_oblation:IsPurgable()	return false end
function modifier_item_hd_Treasure4_oblation:IsPurgeException()	return false end
function modifier_item_hd_Treasure4_oblation:RemoveOnDeath()	return false end
function modifier_item_hd_Treasure4_oblation:GetTexture() return "item_Treasure_oblation_4" end
function modifier_item_hd_Treasure4_oblation:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure4_oblation:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure4_oblation:OnCost()
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return true
	else
		return false
	end
end




modifier_item_hd_Treasure5_oblation =  modifier_item_hd_Treasure5_oblation or class({})
function modifier_item_hd_Treasure5_oblation:IsHidden()	return false end
function modifier_item_hd_Treasure5_oblation:IsDebuff()	return false end
function modifier_item_hd_Treasure5_oblation:IsPurgable()	return false end
function modifier_item_hd_Treasure5_oblation:IsPurgeException()	return false end
function modifier_item_hd_Treasure5_oblation:RemoveOnDeath()	return false end
function modifier_item_hd_Treasure5_oblation:GetTexture() return "item_Treasure_oblation_5" end
function modifier_item_hd_Treasure5_oblation:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure5_oblation:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_Treasure5_oblation:OnCost()
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		return true
	else
		return false
	end
end
