item_hd_dust = class({})
-- LinkLuaModifier("modifier_item_hd_dust_arua", "items/item_hd_dust", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_dust_arua_effect", "items/item_hd_dust", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dust", "items/item_hd_dust", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dust2", "items/item_hd_dust", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dust_active", "items/item_hd_dust", LUA_MODIFIER_MOTION_NONE)

function item_hd_dust:GetIntrinsicModifierName()
	return "modifier_item_hd_dust"
end
function item_hd_dust:OnSpellStart()
	if self:GetCurrentCharges()<50 then
		self:StartCooldown(2)
		return
	end

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	caster:EmitSound("DOTA_Item.EssenceRing.Cast")
	for itemSlot = 0, 5 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() and item:GetCurrentCharges()>=50 then
			UTIL_RemoveImmediate(item) --removeitem的暂时替代
			break
		end
	end
	target:AddNewModifier(caster, self, "modifier_item_hd_dust_active", {})
end


item_hd_dust2 =  item_hd_dust2 or class({})
function item_hd_dust2:GetIntrinsicModifierName()
	return "modifier_item_hd_dust2"
end
function item_hd_dust2:OnSpellStart()
	if self:GetCurrentCharges()<50 then
		self:StartCooldown(2)
		return
	end

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	caster:EmitSound("DOTA_Item.EssenceRing.Cast")
	for itemSlot = 0, 5 do
		local item = self:GetCaster():GetItemInSlot(itemSlot)
		if item and item:GetName() == self:GetName() and item:GetCurrentCharges()>=50 then
			UTIL_RemoveImmediate(item) --removeitem的暂时替代
			break
		end
	end
	target:AddNewModifier(caster, self, "modifier_item_hd_dust_active", {})
	target:AddNewModifier(caster, self, "modifier_item_hd_dust_active", {})
end



modifier_item_hd_dust = class({})

function modifier_item_hd_dust:IsDebuff() return false end
function modifier_item_hd_dust:IsHidden() return true end
function modifier_item_hd_dust:IsPurgable() return false end
function modifier_item_hd_dust:IsPurgeException() return false end
function modifier_item_hd_dust:RemoveOnDeath() return false end


function modifier_item_hd_dust:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
    if IsServer() then
	end
end


function modifier_item_hd_dust:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_DEATH,                          --单位死亡

	}
end

function modifier_item_hd_dust:OnDeath(keys)
	-- First check: Is the unit within capture range and an enemy and not reincarnating?
	if keys.attacker and  keys.attacker.GetPlayerOwnerID and keys.attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() then
		for itemSlot = 0, 5 do
			local item = self:GetCaster():GetItemInSlot(itemSlot)
		
			if item and item:GetName() == self:GetAbility():GetName() then
				-- 2 charges if current count is 0, 1 charge otherwise
				item:SetCurrentCharges(item:GetCurrentCharges() + 1)
				break
			end
		end
	
		
		
	end
end


modifier_item_hd_dust2 = class({})

function modifier_item_hd_dust2:IsDebuff() return false end
function modifier_item_hd_dust2:IsHidden() return true end
function modifier_item_hd_dust2:IsPurgable() return false end
function modifier_item_hd_dust2:IsPurgeException() return false end
function modifier_item_hd_dust2:RemoveOnDeath() return false end
function modifier_item_hd_dust2:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_DEATH,                          --单位死亡

	}
end

function modifier_item_hd_dust2:OnDeath(keys)
	-- First check: Is the unit within capture range and an enemy and not reincarnating?
	if keys.attacker and  keys.attacker.GetPlayerOwnerID and keys.attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() then
		for itemSlot = 0, 5 do
			local item = self:GetCaster():GetItemInSlot(itemSlot)
	
			if item and item:GetName() == self:GetAbility():GetName() then
				-- 2 charges if current count is 0, 1 charge otherwise
				item:SetCurrentCharges(item:GetCurrentCharges() + 1)
				break
			end
		end
	
		
		
	end
end





modifier_item_hd_dust_active = class({})

function modifier_item_hd_dust_active:IsDebuff() return false end
function modifier_item_hd_dust_active:IsHidden() return false end
function modifier_item_hd_dust_active:IsPurgable() return true end
-- function modifier_item_hd_dust_active:IsPurgeException() return false end
function modifier_item_hd_dust_active:GetTexture()return "item_dust" end
function modifier_item_hd_dust_active:RemoveOnDeath() return false end
function modifier_item_hd_dust_active:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_item_hd_dust_active:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_item_hd_dust_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,           --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,            --敏捷
	}
end

function modifier_item_hd_dust_active:GetModifierBonusStats_Strength()	
	if IsClient() then
		return
	end
	local main = self:GetParent():GetPrimaryAttribute()
	if main==DOTA_ATTRIBUTE_ALL  then
		return self:GetStackCount()*4.5
	end
	return main==0 and self:GetStackCount()*10 or 0 
end
function modifier_item_hd_dust_active:GetModifierBonusStats_Intellect()	
	if IsClient() then
		return
	end
	local main = self:GetParent():GetPrimaryAttribute()
	if main==DOTA_ATTRIBUTE_ALL  then
		return self:GetStackCount()*4.5
	end
	return main==2 and self:GetStackCount()*10 or 0 
end
function modifier_item_hd_dust_active:GetModifierBonusStats_Agility()	
	if IsClient() then
		return
	end
	local main = self:GetParent():GetPrimaryAttribute()
	if main==DOTA_ATTRIBUTE_ALL  then
		return self:GetStackCount()*4.5
	end
	return main==1 and self:GetStackCount()*10 or 0 
end



-- modifier_item_hd_dust_active_standby = class({})

-- function modifier_item_hd_dust_active_standby:IsDebuff() return false end
-- function modifier_item_hd_dust_active_standby:IsHidden() return false end
-- function modifier_item_hd_dust_active_standby:DestroyOnExpire()	return false end
-- function modifier_item_hd_dust_active_standby:RemoveOnDeath()	return false end
-- function modifier_item_hd_dust_active_standby:GetTexture()return "item_bloodthorn" end



-- if modifier_item_hd_dust_thinker == nil then
--     modifier_item_hd_dust_thinker = class({})
-- end
-- function modifier_item_hd_dust_thinker:IsHidden()return false end
-- function modifier_item_hd_dust_thinker:IsDebuff()return false end
-- function modifier_item_hd_dust_thinker:IsPurgable()return false end
-- function modifier_item_hd_dust_thinker:IsPurgeException()return false end

-- function modifier_item_hd_dust_thinker:OnCreated(params)

--     if IsServer() then
--         local hParent = self:GetParent()
-- 		local hCaster = self:GetCaster()
-- 		-- self:GetParent():AddNoDraw()
--         hParent:SetOriginalModel(hCaster:GetModelName())
--         hParent:SetModelScale(hCaster:GetModelScale())
--         hParent:SetShouldDoFlyHeightVisual(false)
-- 		hParent:SetForwardVector(hCaster:GetForwardVector())
--         -- local vRBG = Vector(128, 128, 204)
--         -- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)

--         local hModel = hCaster:FirstMoveChild()
--         while hModel ~= nil do
--             if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
--                 local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hParent:GetAbsOrigin() })
--                 -- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
--                 hWearable:FollowEntity(hParent, true)
--             end
--             hModel = hModel:NextMovePeer()
--         end
--         hParent:StartGesture(ACT_DOTA_ATTACK)

-- 		local iParticleID = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_bloodthorn_magic_2.vpcf", PATTACH_ABSORIGIN, hParent)
--         ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
--         self:AddParticle(iParticleID, false, false, -1, false, false)
--     end
-- end

-- function modifier_item_hd_dust_thinker:OnDestroy()
--     if IsServer() then
--         local hParent = self:GetParent()

--         hParent:RemoveSelf()
--     end
-- end

