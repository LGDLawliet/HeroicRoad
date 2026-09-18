Primary_Corrosive_Skin = class({})
LinkLuaModifier( "modifier_Primary_Corrosive_Skin", "skills/Primary_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Corrosive_Skin_debuff", "skills/Primary_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )


function Primary_Corrosive_Skin:GetIntrinsicModifierName()
	return "modifier_Primary_Corrosive_Skin"
end

function Primary_Corrosive_Skin:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end


modifier_Primary_Corrosive_Skin = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Corrosive_Skin:IsHidden()	return true end
function modifier_Primary_Corrosive_Skin:IsPurgable()	return false end
function modifier_Primary_Corrosive_Skin:IsPurgeException() return false end
function modifier_Primary_Corrosive_Skin:RemoveOnDeath() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Corrosive_Skin:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Primary_Corrosive_Skin:OnRefresh( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Primary_Corrosive_Skin:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
	}
	return funcs
end

function modifier_Primary_Corrosive_Skin:OnTakeDamage( params )
	if not IsServer() then return end

	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end
	if params.attacker:IsMagicImmune() then return end

	local distance = (params.attacker:GetOrigin()-params.unit:GetOrigin()):Length2D()
	if distance>self.max_range then return end

	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = params.attacker:GetHDStatusResistanceIndex(0.2)*ModifierStatusNegativeGain--修复与描述说明不符的bug

	params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Primary_Corrosive_Skin_debuff", { duration = self.duration*StatusResistance } )

	local sound_cast = "hero_viper.CorrosiveSkin"
	EmitSoundOn( sound_cast, params.attacker )
end

------------------------------------------------

modifier_Primary_Corrosive_Skin_debuff = advanced_modifier({})


function modifier_Primary_Corrosive_Skin_debuff:IsHidden()	return false end
function modifier_Primary_Corrosive_Skin_debuff:IsDebuff()	return true end
function modifier_Primary_Corrosive_Skin_debuff:IsPoisonDeBuff()	return true end
function modifier_Primary_Corrosive_Skin_debuff:IsPurgable()	return false end

function modifier_Primary_Corrosive_Skin_debuff:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "attack_speed_down" )
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_Primary_Corrosive_Skin_debuff:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "attack_speed_down" )
end


function modifier_Primary_Corrosive_Skin_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_Primary_Corrosive_Skin_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.slow
end

function modifier_Primary_Corrosive_Skin_debuff:OnIntervalThink()
	if not self:GetAbility() then
		return
	end
	local poison = self:GetAbility():GetSpecialValueFor( "poison" )+self:GetAbility():GetSpecialValueFor( "bonus_poison" )*self:GetCaster():GetStrength()
	self:GetParent():Poison(self:GetCaster(), self:GetAbility(), poison)
end


function modifier_Primary_Corrosive_Skin_debuff:GetEffectName()	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf" end
function modifier_Primary_Corrosive_Skin_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end