item_hd_bogduggs_lucky_femur = class({})

LinkLuaModifier("modifier_item_hd_bogduggs_lucky_femur", "items/item_hd_bogduggs_lucky_femur", LUA_MODIFIER_MOTION_NONE)


function item_hd_bogduggs_lucky_femur:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf", context )
end

function item_hd_bogduggs_lucky_femur:GetIntrinsicModifierName()
	return "modifier_item_hd_bogduggs_lucky_femur"
end


modifier_item_hd_bogduggs_lucky_femur = advanced_modifier({})

function modifier_item_hd_bogduggs_lucky_femur:IsDebuff() return false end
function modifier_item_hd_bogduggs_lucky_femur:IsHidden() return true end
function modifier_item_hd_bogduggs_lucky_femur:IsPurgable() return false end
function modifier_item_hd_bogduggs_lucky_femur:IsPurgeException() return false end
function modifier_item_hd_bogduggs_lucky_femur:RemoveOnDeath() return false end

function modifier_item_hd_bogduggs_lucky_femur:OnCreated(keys)
	self.bonus_all_attribute = self:GetAbility():GetSpecialValueFor("bonus_attribute")
	self.bonus = self:GetAbility():GetSpecialValueFor("probability")
	if IsServer() then

	end
end
function modifier_item_hd_bogduggs_lucky_femur:OnDestroy(keys)
	if IsServer() then

	end
end
function modifier_item_hd_bogduggs_lucky_femur:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷            
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST      

	}
end
function modifier_item_hd_bogduggs_lucky_femur:GetModifierBonusStats_Strength()return self.bonus_all_attribute end
function modifier_item_hd_bogduggs_lucky_femur:GetModifierBonusStats_Intellect()return self.bonus_all_attribute end
function modifier_item_hd_bogduggs_lucky_femur:GetModifierBonusStats_Agility()return self.bonus_all_attribute end


function modifier_item_hd_bogduggs_lucky_femur:OnAbilityFullyCast(keys)
	local chance = self:GetAbility():GetSpecialValueFor("refresh_chance") + 1
	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
			return
		end
		if  not keys.ability:IsRefreshable() then
			return
		end
		local ability = self:GetAbility()
		if not ability:IsCooldownReady()  then
			return
		end
		if not keys.ability:IsCooldownReady() and chance >=RandomInt(1, 100) then
			local time = keys.ability:GetCooldownTimeRemaining()
			self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.x1")
			keys.ability:EndCooldown()
			local p_name = "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf"
			local nFXIndex = ParticleManager:CreateParticle( p_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			ability:UseResources(true, true, true, true)
		end
	
	
		
	end
end

-- advanced_modifier
function modifier_item_hd_bogduggs_lucky_femur:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
    }
end
function modifier_item_hd_bogduggs_lucky_femur:Advanced_GetModifier_RandomEffectGain(keys)
	return self.bonus
end
