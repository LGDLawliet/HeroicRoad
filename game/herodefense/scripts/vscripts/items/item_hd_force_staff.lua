item_hd_force_staff = class({})

LinkLuaModifier("modifier_item_hd_force_staff", "items/item_hd_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_force_staff_active", "items/item_hd_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_force_staff_effect", "items/item_hd_force_staff", LUA_MODIFIER_MOTION_NONE)


function item_hd_force_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_force_staff"
end

function item_hd_force_staff:OnSpellStart()
	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	--[[if target:TriggerSpellAbsorb(self) then
		return nil
	end]] --林肯cy
	
	EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_force_staff_effect", {duration = duration})
	end
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_force_staff_active", {duration = 0.4})
end

-------------------------------------------------------------

modifier_item_hd_force_staff = class({})

function modifier_item_hd_force_staff:IsDebuff() return false end
function modifier_item_hd_force_staff:IsHidden() return true end
function modifier_item_hd_force_staff:IsPurgable() return false end


function modifier_item_hd_force_staff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
end


function modifier_item_hd_force_staff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
	}
end

function modifier_item_hd_force_staff:GetModifierBonusStats_Strength()	return self.bonus_atb end
function modifier_item_hd_force_staff:GetModifierBonusStats_Intellect()	return self.bonus_atb end
function modifier_item_hd_force_staff:GetModifierBonusStats_Agility()	return self.bonus_atb end

-----------------------------------------------------------------


modifier_item_hd_force_staff_active = class({})

function modifier_item_hd_force_staff_active:IsDebuff() return false end
function modifier_item_hd_force_staff_active:IsHidden() return true end
function modifier_item_hd_force_staff_active:IsMotionController()  return true end
function modifier_item_hd_force_staff_active:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end


function modifier_item_hd_force_staff_active:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:SafeDestroy() end
		self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self:StartIntervalThink(FrameTime())
		self.angle = self:GetParent():GetForwardVector():Normalized()
		self.distance =self:GetAbility():GetSpecialValueFor("long") / ( self:GetDuration() / FrameTime())
    end
end

function modifier_item_hd_force_staff_active:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
end

function modifier_item_hd_force_staff_active:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not self:CheckMotionControllers() then
		self:SafeDestroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_hd_force_staff_active:HorizontalMotion(unit, time)
	if not IsServer() then return end

	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

-----------------------------------------------------------------


modifier_item_hd_force_staff_effect = advanced_modifier({})

function modifier_item_hd_force_staff_effect:IsDebuff() return false end
function modifier_item_hd_force_staff_effect:IsHidden() return true end
function modifier_item_hd_force_staff_effect:IsPurgable() return false end
function modifier_item_hd_force_staff_effect:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_item_hd_force_staff_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self:GetAbility():GetSpecialValueFor("incoming")
end