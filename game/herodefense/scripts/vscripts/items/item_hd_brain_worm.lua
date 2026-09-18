
LinkLuaModifier("modifier_item_hd_brain_worm_buff", "items/item_hd_brain_worm.lua", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
item_hd_brain_worm=class({})
function item_hd_brain_worm:GetIntrinsicModifierName() 
    return "modifier_item_hd_brain_worm_buff" 
end
function item_hd_brain_worm:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/claszureme_hourglass/effect.vpcf", context )
end





modifier_item_hd_brain_worm_buff= modifier_item_hd_brain_worm_buff or class({})

-- function modifier_item_hd_brain_worm_buff:IsPassive()			return true end
function modifier_item_hd_brain_worm_buff:IsDebuff() return false end
function modifier_item_hd_brain_worm_buff:IsHidden() 		return true end
function modifier_item_hd_brain_worm_buff:IsPurgable() 		return false end
function modifier_item_hd_brain_worm_buff:IsPurgeException() return false end
function modifier_item_hd_brain_worm_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_brain_worm_buff:DestroyOnExpire() return false end
function modifier_item_hd_brain_worm_buff:OnCreated()
    
    local ability=self:GetAbility()
    self.bonus_health= ability:GetSpecialValueFor("bonus_health") 
	self.bonus_mana= ability:GetSpecialValueFor("bonus_mana") 
    if IsServer() then
        self:StartIntervalThink(0.03)
		self.timer =  GameRules:GetGameTime()+18
		self.trigger = false
		self.endTimer = GameRules:GetGameTime()

    end
end
function modifier_item_hd_brain_worm_buff:OnIntervalThink()
	local time =  GameRules:GetGameTime()
	local ability = self:GetAbility()
	if time>=self.timer then
		self.timer =  GameRules:GetGameTime()+15
		-- self:SetStackCount(math.min(self:GetStackCount()+1,3))
		ability:SetCurrentCharges(math.min(ability:GetCurrentCharges()+1,3))
	end
	if ability:GetCurrentCharges()>=1 then
		if self:GetParent():PassivesDisabled() then
			self.trigger = true
			ability:SetCurrentCharges(ability:GetCurrentCharges()-1)
			self.endTimer = GameRules:GetGameTime() +4
		end
	end

	if time>=self.endTimer then
		self.trigger  = false 
	end
   
end
function modifier_item_hd_brain_worm_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS
    } 
end


function modifier_item_hd_brain_worm_buff:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_hd_brain_worm_buff:GetModifierManaBonus()
    return self.bonus_mana
end


function modifier_item_hd_brain_worm_buff:CheckState()
	local state = {}
	if self.trigger then  
		state = {[MODIFIER_STATE_PASSIVES_DISABLED] = false}
	end

	return state
end

function modifier_item_hd_brain_worm_buff:GetPriority()
	return 10
end