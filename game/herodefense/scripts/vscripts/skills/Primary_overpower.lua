Primary_overpower = class({})
LinkLuaModifier( "modifier_Primary_overpower", "skills/Primary_overpower", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function Primary_overpower:OnSpellStart()
	-- get references
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local bonus_duration = self:GetSpecialValueFor("duration")

	-- Add buff modifier
	caster:AddNewModifier(
		caster,
		self,
		"modifier_Primary_overpower",
		{ duration = bonus_duration *gain}
	)

	caster:EmitSound("Hero_Ursa.Overpower")
end





modifier_Primary_overpower = class({})

--------------------------------------------------------------------------------

function modifier_Primary_overpower:IsDebuff()	return false end
function modifier_Primary_overpower:IsPurgable() return true end
--------------------------------------------------------------------------------

function modifier_Primary_overpower:OnCreated( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

	-- Increase stack

	if IsServer() then
		self:SetStackCount(self.max_attacks)

		-- self:AddEffects()
	end
end

function modifier_Primary_overpower:OnRefresh( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

	-- Increase stack
	if IsServer() then
		self:SetStackCount(self.max_attacks)
	end
end

function modifier_Primary_overpower:OnDestroy( kv )
	if IsServer() then
		-- self:RemoveEffects()
	end
end
--------------------------------------------------------------------------------

function modifier_Primary_overpower:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Primary_overpower:GetModifierAttackSpeedBonus_Constant()
	return self.bonus
end


function modifier_Primary_overpower:OnAttack( params )
	if params.attacker~=self:GetParent() then
		return
	end
	if self:GetParent() :IsInSpecialAttack() then
		return
	end

	self:DecrementStackCount()

	if self:GetStackCount()<=0 then
		self:SafeDestroy()

	end

end
function modifier_Primary_overpower:GetEffectName() return "particles/units/heroes/hero_ursa/ursa_overpower_rebuildmohawk.vpcf" end
function modifier_Primary_overpower:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
