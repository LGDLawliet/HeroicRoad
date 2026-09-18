item_hd_blood_bug_barrier = class({})

LinkLuaModifier("modifier_item_hd_blood_bug_barrier", "items/item_hd_blood_bug_barrier", LUA_MODIFIER_MOTION_NONE)

function item_hd_blood_bug_barrier:GetIntrinsicModifierName()
	return "modifier_item_hd_blood_bug_barrier"
end





function item_hd_blood_bug_barrier:Precache( context )
	-- PrecacheResource( "particle", "models/items/razor/razor_arcana/debut/particles/razor_arcana_debut_strike_top_sword.vpcf", context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", context )
end



modifier_item_hd_blood_bug_barrier = modifier_item_hd_blood_bug_barrier or advanced_modifier({})

function modifier_item_hd_blood_bug_barrier:IsDebuff() return false end
function modifier_item_hd_blood_bug_barrier:IsHidden() return false end
function modifier_item_hd_blood_bug_barrier:IsPurgable() return false end
function modifier_item_hd_blood_bug_barrier:OnCreated(keys)
    local parent = self:GetParent()

	local ability = self:GetAbility()
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_lifesteal_gain =ability:GetSpecialValueFor( "bonus_lifesteal_gain" ) 
	self.bonus_health_regeneration_amplification =ability:GetSpecialValueFor( "bonus_health_regeneration_amplification" ) 
	if IsServer() then

		self:StartIntervalThink(FrameTime())
	end
end


function modifier_item_hd_blood_bug_barrier:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end


function modifier_item_hd_blood_bug_barrier:GetModifierHealthBonus() return self.bonus_health end
function modifier_item_hd_blood_bug_barrier:AdvancedGetModifierConstantHealthRegenAmpPercentage() return self.bonus_health_regeneration_amplification end

function modifier_item_hd_blood_bug_barrier:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierPhysicalArmorBonus()
	end
end

function modifier_item_hd_blood_bug_barrier:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	if parent:GetHealthPercent()>80 then
		local save_health = parent:GetHealth()-parent:GetMaxHealth()*0.8
		local max_stack = parent:GetMaxHealth()*20
		if self:GetStackCount()>=max_stack then
			return
		else
			parent:ModifyHealth(parent:GetMaxHealth()*0.8,self:GetParent(),false, 0 )
			self:SetStackCount(math.min(self:GetStackCount()+save_health,max_stack))
		end
	elseif parent:GetHealthPercent()<40 then
		if self:GetStackCount()>0 then
			local health_regen = parent:GetMaxHealth()*0.4-parent:GetHealth()
			health_regen = math.min(health_regen,self:GetStackCount())
			parent:ModifyHealth(parent:GetHealth()+health_regen,self:GetParent(),false, 0 )
			self:SetStackCount(self:GetStackCount()-health_regen)
			

		end
	end

end
-- advanced_modifier
function modifier_item_hd_blood_bug_barrier:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE
    }
end
function modifier_item_hd_blood_bug_barrier:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return self.bonus_lifesteal_gain
end

function modifier_item_hd_blood_bug_barrier:Advanced_GetModifierPhysicalArmorBonus()
	local maxHealth = self:GetParent():GetMaxHealth()
	local bonus = math.floor(self:GetStackCount()/maxHealth)*3
	return math.min(bonus,60)
end