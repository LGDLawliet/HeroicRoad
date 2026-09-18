item_hd_mango_tree = class({})
-- LinkLuaModifier("modifier_item_hd_mango_tree_arua", "items/item_hd_mango_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mango_tree_arua_effect", "items/item_hd_mango_tree", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mango_tree", "items/item_hd_mango_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mango_tree_active", "items/item_hd_mango_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mango_tree_active_standby", "items/item_hd_mango_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mango_tree_active_debuff", "items/item_hd_mango_tree", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_mango_tree:GetIntrinsicModifierName()
	return "modifier_item_hd_mango_tree"
end




modifier_item_hd_mango_tree = class({})

function modifier_item_hd_mango_tree:IsDebuff() return false end
function modifier_item_hd_mango_tree:IsHidden() return true end
function modifier_item_hd_mango_tree:IsPurgable() return false end
-- function modifier_item_hd_mango_tree:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_mango_tree:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_mango_tree:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()

    if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_mango_tree_active_standby", {duration = 20})
		self:StartIntervalThink(0.2)

	end
end
function modifier_item_hd_mango_tree:OnIntervalThink()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() and Game_State:IsInBattle() then
			local newItem = CreateItem( "item_mana_potion", nil, nil )
			-- newItem:SetPurchaseTime( 0 )
			-- if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then  --这一段可有可无
			-- 	item:SetStacksWithOtherOwners( true )
			-- end
			local drop = CreateItemOnPositionSync( self:GetCaster():GetAbsOrigin(), newItem )
			local dropTarget = self:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 200, 500 ) ) --产生一个新坐标
			newItem:LaunchLootInitialHeight( false, 0,300, 1, dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
			self:GetAbility():StartCooldown(15)
			local item = newItem:GetContainer()
			-- PrintTable(item)
			
			Timers:CreateTimer(60, function()
				-- print("kill?")
				if item and not item:IsNull() then
					local hContainedItem = item:GetContainedItem()  --由绑定单位获取到道具实体
					if hContainedItem  then
						local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/spring_2021/blink_dagger_spring_2021_start_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil ) 
						ParticleManager:SetParticleControl( nFXIndex, 0, item:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
						EmitSoundOn( "Hero_QueenOfPain.Blink_in", item )
						UTIL_Remove( item )
						-- print("kill")
					end
				end
			end)
		end
		-- self:SetHasCustomTransmitterData(true)
	end
end















