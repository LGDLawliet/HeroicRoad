item_hd_font_of_time = item_hd_font_of_time or class({})

LinkLuaModifier("modifier_item_hd_font_of_time", "items/item_hd_font_of_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_font_of_time_active", "items/item_hd_font_of_time", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_font_of_time:GetIntrinsicModifierName()
	return "modifier_item_hd_font_of_time"
end
function item_hd_font_of_time:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/font_of_time/effect.vpcf", context )

end




function item_hd_font_of_time:OnSpellStart()
	local caster    =   self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_item_hd_font_of_time_active", {duration = 20})
	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/items/font_of_time/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 1, caster:GetOrigin())
	DestroyParticleByDelay(nFXIndex,3)
	caster:EmitSound("Hero_Chen.PenitenceImpact")
	caster:ModifyHealth(caster:GetHealth()*0.5, self, false, 0)
end





modifier_item_hd_font_of_time = modifier_item_hd_font_of_time or class({})

function modifier_item_hd_font_of_time:IsDebuff() return false end
function modifier_item_hd_font_of_time:IsHidden() return true end
function modifier_item_hd_font_of_time:IsPurgable() return false end
function modifier_item_hd_font_of_time:IsPurgeException() return false end
function modifier_item_hd_font_of_time:RemoveOnDeath() return false end
function modifier_item_hd_font_of_time:OnCreated(keys)
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end
function modifier_item_hd_font_of_time:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
		MODIFIER_PROPERTY_HEALTH_BONUS,
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
end
function modifier_item_hd_font_of_time:GetModifierBonusStats_Strength()return self.bonus_str end
function modifier_item_hd_font_of_time:GetModifierHealthBonus()return self.bonus_health end




-- function modifier_item_hd_font_of_time:GetModifierPhysical_ConstantBlock(keys) 
-- 	-- if keys.target == self:GetParent() then
-- 		local chance = 15
-- 		if keys.target:HasModifier("modifier_item_hd_font_of_time_active") then
-- 			chance = 40
-- 		end
-- 		if chance>=RandomInt(1, 100) then
-- 			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
-- 			ParticleManager:SetParticleControl(nFXIndex, 10, keys.target:GetOrigin())
-- 			DestroyParticleByDelay(nFXIndex,0.5)

-- 			return keys.damage
-- 		end
-- 	-- end
-- 	-- return
-- end

function modifier_item_hd_font_of_time:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL
	}
end
function modifier_item_hd_font_of_time:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return 0
	end
	local chance = 15
	if keys.target:HasModifier("modifier_item_hd_font_of_time_active") then
		chance = 40
	end
	if chance>=RandomInt(1, 100) then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
		ParticleManager:SetParticleControl(nFXIndex, 10, keys.target:GetOrigin())
		DestroyParticleByDelay(nFXIndex,0.5)

		return keys.damage
	end
	return 0

end





modifier_item_hd_font_of_time_active = modifier_item_hd_font_of_time_active or class({})

function modifier_item_hd_font_of_time_active:IsDebuff() return false end
function modifier_item_hd_font_of_time_active:IsHidden() return false end
function modifier_item_hd_font_of_time_active:IsPurgable() return false end
function modifier_item_hd_font_of_time_active:IsPurgeException() return false end
function modifier_item_hd_font_of_time_active:RemoveOnDeath() return false end
function modifier_item_hd_font_of_time_active:GetTexture() return "item_font_of_time" end