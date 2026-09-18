
LinkLuaModifier("modifier_item_hd_courier_radiant", "items/item_hd_courier_radiant", LUA_MODIFIER_MOTION_NONE)


item_hd_courier_radiant = class({})

--------------------------------------------------------------------------------

-- function item_hd_courier_radiant:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_courier_radiant:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )

		local nTeamNumber = self:GetCaster():GetTeamNumber()

				
		-- local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		-- ParticleManager:ReleaseParticleIndex( nFXIndex )
		local Heroes = GetAllRealHeroes()

		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == nTeamNumber then
				Hero:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_courier_radiant", {})
			
			end
		end

		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_courier_radiant = class({})

function modifier_item_hd_courier_radiant:IsDebuff() return false end
function modifier_item_hd_courier_radiant:IsHidden() return false end
function modifier_item_hd_courier_radiant:IsPurgable() return false end
function modifier_item_hd_courier_radiant:IsPurgeException() return false end
function modifier_item_hd_courier_radiant:GetTexture()return "item_courier_radiant" end
function modifier_item_hd_courier_radiant:RemoveOnDeath() return false end
function modifier_item_hd_courier_radiant:OnCreated()
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_item_hd_courier_radiant:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end


function modifier_item_hd_courier_radiant:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度

	}
end

function modifier_item_hd_courier_radiant:GetModifierMoveSpeedBonus_Constant()return self:GetStackCount()*5 end