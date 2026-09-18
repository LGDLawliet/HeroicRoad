item_hd_risk_dice = class({})

LinkLuaModifier("modifier_item_hd_risk_dice", "items/item_hd_risk_dice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_risk_dice_active", "items/item_hd_risk_dice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_risk_dice_active_2", "items/item_hd_risk_dice", LUA_MODIFIER_MOTION_NONE)


function item_hd_risk_dice:OnSpellStart()

	local caster    =   self:GetCaster()
	local chance = 95
	local bonus = false
	local modifier = caster:FindModifierByName("modifier_Advanced_chaos_strike")
	if modifier and modifier:GetAbility().advanced_level>=15 then
		bonus = true
	end
	if caster:HasModifier("modifier_Shop_The_blessing_of_good_luck") or bonus then
		chance = 96
		-- print("luck bonus")
	end
	local modifier = caster:FindModifierByName("modifier_item_hd_risk_dice_active")
	if modifier and modifier:GetStackCount()<10 then
		chance = 98
		if caster:HasModifier("modifier_Shop_The_blessing_of_good_luck") or bonus then
			chance = 99
			-- print("luck bonus")
		end
	end
	if IsInToolsMode() then
		chance = 100
	end

	if chance>=RandomInt(1, 100) then
		caster:EmitSound("compendium_levelup")
		caster:AddNewModifier(caster, self, "modifier_item_hd_risk_dice_active", {})
		self.particle = ParticleManager:CreateParticle("particles/econ/events/ti10/hero_levelup_ti10_godray.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
	else
		caster:EmitSound("DOTA_Item.ComboBreaker")
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.particle, 5, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		local modifier = caster:FindAllModifiersByName("modifier_item_hd_risk_dice_active")
		if #modifier>0 then
			local stack = modifier[1]:GetStackCount()
			caster:AddNewModifier(caster, self, "modifier_item_hd_risk_dice_active_2", {index = stack})
			modifier[1]:SafeDestroy()
			if stack>=10 then
				caster:EmitSound("risk_dice_"..RandomInt(1, 2))
			end
		end
		self:Destroy()

	
	end
	
end





modifier_item_hd_risk_dice_active = class({})

function modifier_item_hd_risk_dice_active:IsDebuff() return false end
function modifier_item_hd_risk_dice_active:IsHidden() return false end
function modifier_item_hd_risk_dice_active:IsPurgable() return false end
function modifier_item_hd_risk_dice_active:IsPurgeException() return false end
function modifier_item_hd_risk_dice_active:GetTexture()return "item_risk_dice" end
function modifier_item_hd_risk_dice_active:RemoveOnDeath() return false end
function modifier_item_hd_risk_dice_active:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_item_hd_risk_dice_active:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_risk_dice_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_item_hd_risk_dice_active:GetModifierBonusStats_Strength()	return self:GetStackCount()*2 end
function modifier_item_hd_risk_dice_active:GetModifierBonusStats_Intellect()	return self:GetStackCount()*2 end
function modifier_item_hd_risk_dice_active:GetModifierBonusStats_Agility()	return self:GetStackCount()*2 end






modifier_item_hd_risk_dice_active_2 = class({})

function modifier_item_hd_risk_dice_active_2:IsDebuff() return true end
function modifier_item_hd_risk_dice_active_2:IsHidden() return false end
function modifier_item_hd_risk_dice_active_2:IsPurgable() return false end
function modifier_item_hd_risk_dice_active_2:GetTexture()return "item_risk_dice" end
function modifier_item_hd_risk_dice_active_2:RemoveOnDeath() return false end
function modifier_item_hd_risk_dice_active_2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end
function modifier_item_hd_risk_dice_active_2:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.index)
	end
end
function modifier_item_hd_risk_dice_active_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_item_hd_risk_dice_active_2:GetModifierBonusStats_Strength()	return -self:GetStackCount()*3 end
function modifier_item_hd_risk_dice_active_2:GetModifierBonusStats_Intellect()	return -self:GetStackCount()*3 end
function modifier_item_hd_risk_dice_active_2:GetModifierBonusStats_Agility()	return -self:GetStackCount()*3 end
