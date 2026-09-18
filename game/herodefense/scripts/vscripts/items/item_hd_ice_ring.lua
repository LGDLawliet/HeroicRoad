item_hd_ice_ring = class({})
-- LinkLuaModifier("modifier_item_hd_ice_ring_arua", "items/item_hd_ice_ring", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_ring_arua_effect", "items/item_hd_ice_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_ring", "items/item_hd_ice_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_ring_buff", "items/item_hd_ice_ring", LUA_MODIFIER_MOTION_NONE)

function item_hd_ice_ring:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ice_ring/frozen_effect_round.vpcf", context )

end

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ice_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_ice_ring"
end


-- function item_hd_ice_ring:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return math.min(2000,1500 + caster:GetCastRangeBonus())-caster:GetCastRangeBonus()

-- end



function item_hd_ice_ring:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Crystal.CrystalNova.Yulsaria")

	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(400,0,0))
	ParticleManager:ReleaseParticleIndex( effect_cast )

	target:AddNewModifier(caster, self, "modifier_item_hd_ice_ring_buff", {duration = 15})
	self:StartCooldown(60)
end


modifier_item_hd_ice_ring = class({})

function modifier_item_hd_ice_ring:IsDebuff() return false end
function modifier_item_hd_ice_ring:IsHidden() return true end
function modifier_item_hd_ice_ring:IsPurgable() return false end


function modifier_item_hd_ice_ring:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = ability:GetSpecialValueFor("bonus_mana")
end



function modifier_item_hd_ice_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值

	}
end
function modifier_item_hd_ice_ring:GetModifierHealthBonus()return self.bonus_health end
function modifier_item_hd_ice_ring:GetModifierManaBonus()return self.bonus_mana end




modifier_item_hd_ice_ring_buff = class({})

function modifier_item_hd_ice_ring_buff:IsDebuff() return false end
function modifier_item_hd_ice_ring_buff:IsHidden() return false end
function modifier_item_hd_ice_ring_buff:IsPurgable() return false end
function modifier_item_hd_ice_ring_buff:IsPurgeException() return false end
function modifier_item_hd_ice_ring_buff:GetTexture() return "item_ice_ring" end
function modifier_item_hd_ice_ring_buff:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/ice_ring/frozen_effect_round.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		
		-- ParticleManager:SetParticleControl( self.nFXIndex, 0, parent:GetOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 10, parent:GetOrigin() )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )



	end
end
function modifier_item_hd_ice_ring_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end

function modifier_item_hd_ice_ring_buff:CheckState()
	return  {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,

	}



end

function modifier_item_hd_ice_ring_buff:DeclareFunctions()
	local funcs = {
	
	}
	if self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		table.insert(funcs,MODIFIER_EVENT_ON_ORDER)
	end
	return funcs
end

function modifier_item_hd_ice_ring_buff:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then

		if keys.order_type==DOTA_UNIT_ORDER_HOLD_POSITION    then
			self:SafeDestroy()
		end


	end
end
