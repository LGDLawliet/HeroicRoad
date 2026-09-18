item_hd_lamb_divine_staff = class({})

LinkLuaModifier("modifier_item_hd_lamb_divine_staff", "items/item_hd_lamb_divine_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_lamb_divine_staff_active", "items/item_hd_lamb_divine_staff", LUA_MODIFIER_MOTION_NONE)

function item_hd_lamb_divine_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_lamb_divine_staff"
end


function item_hd_lamb_divine_staff:OnSpellStart()
	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	target:EmitSound("DOTA_Item.Sheepstick.Activate")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
	local StatusResistance = target:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
	local duration = math.min(self:GetSpecialValueFor("duration")*StatusResistance,10)
	duration = math.max(duration,3)
	target:AddNewModifier(caster, self, "modifier_item_hd_lamb_divine_staff_active", {duration = duration})
end

modifier_item_hd_lamb_divine_staff = advanced_modifier({})

function modifier_item_hd_lamb_divine_staff:IsDebuff() return false end
function modifier_item_hd_lamb_divine_staff:IsHidden() return true end
function modifier_item_hd_lamb_divine_staff:IsPurgable() return false end

function modifier_item_hd_lamb_divine_staff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")
end

function modifier_item_hd_lamb_divine_staff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,
    }
end
function modifier_item_hd_lamb_divine_staff:Advanced_GetModifierSpellAmplifyBonus(keys)
	return self.bonus_profic
end
function modifier_item_hd_lamb_divine_staff:Advanced_GetModifier_TalentEffectGain(keys)
	return self.bonus_spell_amp
end
function modifier_item_hd_lamb_divine_staff:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end






modifier_item_hd_lamb_divine_staff_active = class({})

function modifier_item_hd_lamb_divine_staff_active:IsDebuff() return true end
function modifier_item_hd_lamb_divine_staff_active:IsHidden() return false end
function modifier_item_hd_lamb_divine_staff_active:IsPurgable() return false end
function modifier_item_hd_lamb_divine_staff_active:IsPurgeException() return true end
function modifier_item_hd_lamb_divine_staff_active:GetTexture()return "item_lamb_divine_staff" end
function modifier_item_hd_lamb_divine_staff_active:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_item_hd_lamb_divine_staff_active:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_hd_lamb_divine_staff_active:CheckState()
	local state = 
	{
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
}
	return state
end



function modifier_item_hd_lamb_divine_staff_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_EVENT_ON_DEATH,                            --死亡
	}
end

function modifier_item_hd_lamb_divine_staff_active:GetModifierMoveSpeedOverride()return 100 end

function modifier_item_hd_lamb_divine_staff_active:GetModifierModelChange()	return "models/items/hex/sheep_hex/sheep_hex.vmdl" end



function modifier_item_hd_lamb_divine_staff_active:OnDeath(keys)
    if not IsServer() then
        return
    end
	if not self:GetAbility() then return end
    if keys.unit == self:GetParent() then
		local caster = self:GetCaster()
		local attacker = keys.attacker
		local heal = attacker:GetMaxHealth()*self:GetAbility():GetSpecialValueFor("heal")*0.01
		if heal<=0 then
			return
		end
		local healing = HealWithGain(heal,caster,attacker,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, healing, nil)
	

    end
   
end