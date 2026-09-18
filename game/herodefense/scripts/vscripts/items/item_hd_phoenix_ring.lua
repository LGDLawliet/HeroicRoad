item_hd_phoenix_ring = item_hd_phoenix_ring or class({})
-- LinkLuaModifier("modifier_item_hd_phoenix_ring_arua", "items/item_hd_phoenix_ring", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_phoenix_ring_arua_effect", "items/item_hd_phoenix_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phoenix_ring", "items/item_hd_phoenix_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phoenix_ring_active", "items/item_hd_phoenix_ring", LUA_MODIFIER_MOTION_NONE)

function item_hd_phoenix_ring:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/fall_2022/bottle/bottle_fall2022.vpcf", context )

end

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_phoenix_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_phoenix_ring"
end
function item_hd_phoenix_ring:IsRefreshable() return false end

function item_hd_phoenix_ring:OnSpellStart()
	local caster    =   self:GetCaster()
	if caster:HasModifier("modifier_item_hd_phoenix_ring_active") then
		return
	end
	caster:EmitSound("ui.npe_objective_given")
	caster:AddNewModifier(caster, self, "modifier_item_hd_phoenix_ring_active", {})
	self:SpendCharge(0)
end


-- function item_hd_phoenix_ring:OnSpellStart()
-- 	local caster = self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	caster:EmitSound("Hero_Crystal.CrystalNova.Yulsaria")

-- 	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_WORLDORIGIN, caster )
-- 	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
-- 	ParticleManager:SetParticleControl( effect_cast, 1, Vector(400,0,0))
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	target:AddNewModifier(caster, self, "modifier_item_hd_phoenix_ring_buff", {duration = 15})
-- 	self:StartCooldown(60)
-- end


modifier_item_hd_phoenix_ring = modifier_item_hd_phoenix_ring or class({})

function modifier_item_hd_phoenix_ring:IsDebuff() return false end
function modifier_item_hd_phoenix_ring:IsHidden() return false end
function modifier_item_hd_phoenix_ring:IsPurgable() return false end
function modifier_item_hd_phoenix_ring:DestroyOnExpire() return false end

function modifier_item_hd_phoenix_ring:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = ability:GetSpecialValueFor("bonus_mana")
	if IsServer() then
		self:SetDuration(25, true)
		local caster = self:GetCaster()
		if caster.hd_bottle_water==nil then
			caster.hd_bottle_water = 1
		end
		caster.hd_bottle_water = caster.hd_bottle_water +1
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_hd_phoenix_ring:OnDestroy(keys)
    local ability = self:GetAbility()
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = ability:GetSpecialValueFor("bonus_mana")
	if IsServer() then
		local caster = self:GetCaster()
		if caster.hd_bottle_water==nil then
			caster.hd_bottle_water = 2
		end
		caster.hd_bottle_water = caster.hd_bottle_water - 1
	end
end


function modifier_item_hd_phoenix_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值

	}
end
function modifier_item_hd_phoenix_ring:GetModifierHealthBonus()return self.bonus_health end
function modifier_item_hd_phoenix_ring:GetModifierManaBonus()return self.bonus_mana end

function modifier_item_hd_phoenix_ring:OnIntervalThink()
	-- local ability = self:GetAbility()
	if self:GetRemainingTime()<=0  then
		local parent = self:GetParent()
		local item = parent:FindItemInInventory("item_new_bottle")
		if item ~=nil then
			local charge = item:GetCurrentCharges()
			if charge<item:GetBottleMaxCharge() then
				item:SetCurrentCharges(charge+1)
				self:SetDuration(25, true)
				parent:EmitSound("Hero_Phoenix.FireSpirits.Launch")

				local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, parent )
				ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector(128,0,0))
				ParticleManager:ReleaseParticleIndex( effect_cast )
				-- particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf
			end

		end
	end
	

end








modifier_item_hd_phoenix_ring_active = modifier_item_hd_phoenix_ring_active or class({})

function modifier_item_hd_phoenix_ring_active:IsDebuff() return false end
function modifier_item_hd_phoenix_ring_active:IsHidden() return false end
function modifier_item_hd_phoenix_ring_active:IsPurgable() return false end
function modifier_item_hd_phoenix_ring_active:IsPurgeException() return false end
function modifier_item_hd_phoenix_ring_active:RemoveOnDeath() return false end
function modifier_item_hd_phoenix_ring_active:DestroyOnExpire() return false end
function modifier_item_hd_phoenix_ring_active:GetTexture() return "item_phoenix_ring" end



function modifier_item_hd_phoenix_ring_active:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		if caster.hd_bottle_water==nil then
			caster.hd_bottle_water = 1
		end
		caster.hd_bottle_water = caster.hd_bottle_water +1
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_hd_phoenix_ring_active:OnDestroy(keys)
	if IsServer() then
		local caster = self:GetCaster()
		if caster.hd_bottle_water==nil then
			caster.hd_bottle_water = 2
		end
		caster.hd_bottle_water = caster.hd_bottle_water - 1
	end
end


function modifier_item_hd_phoenix_ring_active:OnIntervalThink()
	-- local ability = self:GetAbility()
	if self:GetRemainingTime()<=0 then
		local parent = self:GetParent()
		local item = parent:FindItemInInventory("item_new_bottle")
		if item ~=nil then
			local charge = item:GetCurrentCharges()
			if charge<item:GetBottleMaxCharge() then
				item:SetCurrentCharges(charge+1)
				self:SetDuration(25, true)
				parent:EmitSound("Hero_Phoenix.FireSpirits.Launch")

				local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, parent )
				ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector(128,0,0))
				ParticleManager:ReleaseParticleIndex( effect_cast )
				-- particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf
			end

		end
	end
	

end
