item_hd_force_boots = class({})
-- LinkLuaModifier("modifier_item_hd_force_boots_arua", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_force_boots_arua_effect", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_force_boots", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_force_boots_active", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_force_boots_effect", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_force_boots_effect2", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_force_boots_active_standby", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_force_boots_debuff", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_force_boots_thinker", "items/item_hd_force_boots", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_force_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_force_boots"
end



function item_hd_force_boots:OnSpellStart()

	local target = self:GetCursorTarget()
	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:TriggerSpellAbsorb(self) then
		return nil
	end
	
	EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_force_boots_active", {duration = 0.4})

end


modifier_item_hd_force_boots = advanced_modifier({})

function modifier_item_hd_force_boots:IsDebuff() return false end
function modifier_item_hd_force_boots:IsHidden() return true end
function modifier_item_hd_force_boots:IsPurgable() return false end


function modifier_item_hd_force_boots:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
end



function modifier_item_hd_force_boots:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
	

	}
end


function modifier_item_hd_force_boots:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_item_hd_force_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_hd_force_boots:GetModifierIgnoreMovespeedLimit() return 1 end

function modifier_item_hd_force_boots:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,


    }
end



modifier_item_hd_force_boots_active = class({})

function modifier_item_hd_force_boots_active:IsDebuff() return false end
function modifier_item_hd_force_boots_active:IsHidden() return true end
function modifier_item_hd_force_boots_active:IsMotionController()  return true end
function modifier_item_hd_force_boots_active:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end


function modifier_item_hd_force_boots_active:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:SafeDestroy() end
		self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self:StartIntervalThink(FrameTime())
		self.angle = self:GetParent():GetForwardVector():Normalized()
		self.distance =1000 / ( self:GetDuration() / FrameTime())
    end
end

function modifier_item_hd_force_boots_active:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.05}) --提供相位，防止卡位
end

function modifier_item_hd_force_boots_active:OnIntervalThink()
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

function modifier_item_hd_force_boots_active:HorizontalMotion(unit, time)
	if not IsServer() then return end

	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end
