
LinkLuaModifier("modifier_creeps_spell_Light_And_Dark_passive", "creeps_spell/creeps_spell_Light_And_Dark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Light", "creeps_spell/creeps_spell_Light_And_Dark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Dark", "creeps_spell/creeps_spell_Light_And_Dark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Dark_sheild", "creeps_spell/creeps_spell_Light_And_Dark", LUA_MODIFIER_MOTION_NONE)
creeps_spell_Light_And_Dark =  class({})



function creeps_spell_Light_And_Dark:GetIntrinsicModifierName()
	return "modifier_creeps_spell_Light_And_Dark_passive"
end

-- Mana break modifier
modifier_creeps_spell_Light_And_Dark_passive = class({})

function modifier_creeps_spell_Light_And_Dark_passive:IsHidden()return false end
function modifier_creeps_spell_Light_And_Dark_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Light_And_Dark_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Light_And_Dark_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Light_And_Dark_passive:OnCreated()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Light", {})
		self:StartIntervalThink(1)
	end
end

function modifier_creeps_spell_Light_And_Dark_passive:OnIntervalThink()
	if IsServer() then
		local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Dark_sheild")
		if self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Light") and #buffs > 0 then
			self:IncrementStackCount()
			if self:GetStackCount()>=15 then
				local buffs2 = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Light") 
				buffs2[1]:SafeDestroy()
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Dark", {})
				self:SetStackCount(0)
			end
			
		end
	end
end


modifier_creeps_spell_Light = class({})

function modifier_creeps_spell_Light:IsHidden() return false end
function modifier_creeps_spell_Light:IsPurgable() return false end
function modifier_creeps_spell_Light:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf" end
function modifier_creeps_spell_Light:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creeps_spell_Light:OnCreated()
	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.add_damage = 0
	end
end

function modifier_creeps_spell_Light:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_creeps_spell_Light:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If target has break, do nothing
		if attacker:PassivesDisabled() then
			return nil
		end

		-- If there isn't a valid target, do nothing
		if target:GetMaxMana() == 0 or target:IsMagicImmune() then
			return nil
		end

		-- Only apply on caster attacking enemies
		if self.parent == attacker and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then

			-- Play sound
			target:EmitSound("Hero_Antimage.ManaBreak")

			-- Add hit particle effects
			local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(manaburn_pfx)
			-- Calculate and burn mana
			local target_mana_burn = target:GetMana()
			if (target_mana_burn > (target:GetMaxMana() * self:GetAbility():GetSpecialValueFor("mana_break") * 0.01)) then
				target_mana_burn = (target:GetMaxMana() * self:GetAbility():GetSpecialValueFor("mana_break") * 0.01)
			end
			target:Script_ReduceMana(target_mana_burn,self.ability)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, target_mana_burn, nil)
			self.add_damage = target_mana_burn *5
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_creeps_spell_Dark_sheild", {
				stack = target_mana_burn*5,
			})
		end
	end
end
function modifier_creeps_spell_Light:GetModifierBaseAttack_BonusDamage(params)
	if IsServer() then
		return self.add_damage
	end
end
function modifier_creeps_spell_Light:GetModifierAttackSpeedBonus_Constant() 
    return 300
end



modifier_creeps_spell_Dark_sheild = class({})

function modifier_creeps_spell_Dark_sheild:IsHidden() return false end
function modifier_creeps_spell_Dark_sheild:IsPurgable() return false end

function modifier_creeps_spell_Dark_sheild:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_creeps_spell_Dark_sheild:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

--暗影态护盾
modifier_creeps_spell_Dark = advanced_modifier({})

function modifier_creeps_spell_Dark:IsHidden() return false end
function modifier_creeps_spell_Dark:IsPurgable() return false end
function modifier_creeps_spell_Dark:GetEffectName() return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf" end
function modifier_creeps_spell_Dark:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_creeps_spell_Dark:GetModifierBaseDamageOutgoing_Percentage() 
    return 500
end
function modifier_creeps_spell_Dark:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

function modifier_creeps_spell_Dark:OnCreated(table)
	if not IsServer() then
		return
	end
	local buff = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Dark_sheild")
	self:SetStackCount(buff[1]:GetStackCount()+2000)
	buff[1]:SafeDestroy()
	self:StartIntervalThink(0.3)
end
function modifier_creeps_spell_Dark:OnIntervalThink()
	if not IsServer() then
		return
	end
	if self:GetStackCount()==0 then
		self:SafeDestroy()
	end
end

function modifier_creeps_spell_Dark:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Light", {
	})
end

-- function  modifier_creeps_spell_Dark:GetModifierTotal_ConstantBlock(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if self:GetParent():IsBlockDisabled() then
--         return
--     end
-- 	local stack = self:GetStackCount()
--     --计算护盾值
-- 	if keys.damage >  self:GetStackCount()then
-- 		self:SetStackCount(0)
-- 	else
--         self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
--         stack=keys.damage+1
-- 	end
-- 	return stack
-- end




function modifier_creeps_spell_Dark:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_creeps_spell_Dark:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
		-- return 0 
	end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage+1
	end
	return stack

end