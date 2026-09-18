
LinkLuaModifier("modifier_item_hd_rubick_cube_buff", "items/item_hd_rubick_cube", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rubick_cube_active", "items/item_hd_rubick_cube", LUA_MODIFIER_MOTION_NONE)


item_hd_rubick_cube = item_hd_rubick_cube or class({})
function item_hd_rubick_cube:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_item_hd_rubick_cube_active") then
			return
		end
		self:GetCaster():EmitSoundParams( "Hero_ShadowDemon.Soul_Catcher", 0, 0.5, 0 )
		local modifier = caster:FindModifierByName("modifier_item_hd_rubick_cube_buff")
		if modifier then
			modifier:SafeDestroy()
			caster:AddNewModifier(caster, self, "modifier_item_hd_rubick_cube_active", {})
		else
			caster:AddNewModifier(caster, self, "modifier_item_hd_rubick_cube_buff", {})
		end

		self:SpendCharge(0)
	end
end



modifier_item_hd_rubick_cube_buff =  modifier_item_hd_rubick_cube_buff or class({})

function modifier_item_hd_rubick_cube_buff:IsDebuff() return false end
function modifier_item_hd_rubick_cube_buff:IsHidden() return false end
function modifier_item_hd_rubick_cube_buff:IsPurgable() return false end
function modifier_item_hd_rubick_cube_buff:IsPurgeException() return false end
function modifier_item_hd_rubick_cube_buff:GetTexture()return "item_rubick_cube" end
function modifier_item_hd_rubick_cube_buff:RemoveOnDeath() return false end





modifier_item_hd_rubick_cube_active = modifier_item_hd_rubick_cube_active or class({})

function modifier_item_hd_rubick_cube_active:IsDebuff() return false end
function modifier_item_hd_rubick_cube_active:IsHidden() return false end
function modifier_item_hd_rubick_cube_active:IsPurgable() return false end
function modifier_item_hd_rubick_cube_active:IsPurgeException() return false end
function modifier_item_hd_rubick_cube_active:GetTexture()return "item_rubick_cube" end
function modifier_item_hd_rubick_cube_active:RemoveOnDeath() return false end










LinkLuaModifier("modifier_item_hd_rubick_cube2_buff", "items/item_hd_rubick_cube", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rubick_cube2_active", "items/item_hd_rubick_cube", LUA_MODIFIER_MOTION_NONE)


item_hd_rubick_cube2 = item_hd_rubick_cube2 or class({})
function item_hd_rubick_cube2:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_item_hd_rubick_cube2_active") then
			return
		end
		self:GetCaster():EmitSoundParams( "Hero_ShadowDemon.Soul_Catcher", 0, 0.5, 0 )
		local modifier = caster:FindModifierByName("modifier_item_hd_rubick_cube2_buff")
		if modifier then
			modifier:SafeDestroy()
			caster:AddNewModifier(caster, self, "modifier_item_hd_rubick_cube2_active", {})
		else
			caster:AddNewModifier(caster, self, "modifier_item_hd_rubick_cube2_buff", {})
		end

		self:SpendCharge(0)
	end
end



modifier_item_hd_rubick_cube2_buff =  modifier_item_hd_rubick_cube2_buff or class({})

function modifier_item_hd_rubick_cube2_buff:IsDebuff() return false end
function modifier_item_hd_rubick_cube2_buff:IsHidden() return false end
function modifier_item_hd_rubick_cube2_buff:IsPurgable() return false end
function modifier_item_hd_rubick_cube2_buff:IsPurgeException() return false end
function modifier_item_hd_rubick_cube2_buff:GetTexture()return "item_rubick_cube2" end
function modifier_item_hd_rubick_cube2_buff:RemoveOnDeath() return false end





modifier_item_hd_rubick_cube2_active =modifier_item_hd_rubick_cube2_active or class({})

function modifier_item_hd_rubick_cube2_active:IsDebuff() return false end
function modifier_item_hd_rubick_cube2_active:IsHidden() return false end
function modifier_item_hd_rubick_cube2_active:IsPurgable() return false end
function modifier_item_hd_rubick_cube2_active:IsPurgeException() return false end
function modifier_item_hd_rubick_cube2_active:GetTexture()return "item_rubick_cube2" end
function modifier_item_hd_rubick_cube2_active:RemoveOnDeath() return false end
function modifier_item_hd_rubick_cube2_active:OnCreated( kv )
	if not IsServer() then return end
	self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
end


function modifier_item_hd_rubick_cube2_active:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end


function modifier_item_hd_rubick_cube2_active:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	-- print("2")
	if data.order_type == 19 and (data.entindex_target==16 or EntIndexToHScript(data.entindex_ability):GetItemSlot()==16) then
		-- print("3")
		if data.entindex_target==15 or EntIndexToHScript(data.entindex_ability):GetItemSlot()==15 then
			-- print("4")
			return false
		end
		-- print("5")
		EntIndexToHScript(data.entindex_ability):GetParent():SwapItems(EntIndexToHScript(data.entindex_ability):GetItemSlot(),data.entindex_target)
        return false
    end
	-- print("6")
	return true
end