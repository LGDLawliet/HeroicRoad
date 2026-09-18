item_hd_alluvion_prophecy = class({})
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_arua", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_arua_effect", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_alluvion_prophecy", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_alluvion_prophecy_active1", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_alluvion_prophecy_active2", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_alluvion_prophecy_active3", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_effect", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_effect2", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_active_standby", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_debuff", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_alluvion_prophecy_thinker", "items/item_hd_alluvion_prophecy", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_alluvion_prophecy:GetIntrinsicModifierName()
	return "modifier_item_hd_alluvion_prophecy"
end



function item_hd_alluvion_prophecy:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- target:AddNewModifier(caster, self, "modifier_item_hd_alluvion_prophecy_active2", {duration = 7*ModifierStatusNegativeGain})
	if target:GetHealthPercent()<=50 then
		caster:AddNewModifier(caster, self, "modifier_item_hd_alluvion_prophecy_active1", {duration = 60*ModifierStatusNegativeGain})
	else
		if target:GetManaPercent()<=50 then
			target:AddNewModifier(caster, self, "modifier_item_hd_alluvion_prophecy_active2", {duration = 60*ModifierStatusNegativeGain})
		else
			target:AddNewModifier(caster, self, "modifier_item_hd_alluvion_prophecy_active3", {duration = 60*ModifierStatusNegativeGain})
		end
	end
	target:EmitSound("Hero_Oracle.FortunesEnd.Target")

	local particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe_vortex_core.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)


end





modifier_item_hd_alluvion_prophecy = advanced_modifier({})

function modifier_item_hd_alluvion_prophecy:IsDebuff() return false end
function modifier_item_hd_alluvion_prophecy:IsHidden() return true end
function modifier_item_hd_alluvion_prophecy:IsPurgable() 		return false end
function modifier_item_hd_alluvion_prophecy:IsPurgeException() 	return false end
function modifier_item_hd_alluvion_prophecy:RemoveOnDeath()  return false end


function modifier_item_hd_alluvion_prophecy:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")

end


function modifier_item_hd_alluvion_prophecy:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
	
		

	}
end


function modifier_item_hd_alluvion_prophecy:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_alluvion_prophecy:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_alluvion_prophecy:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_alluvion_prophecy:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end


-- advanced_modifier
function modifier_item_hd_alluvion_prophecy:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end


modifier_item_hd_alluvion_prophecy_active1 = class({})

function modifier_item_hd_alluvion_prophecy_active1:IsDebuff() return false end
function modifier_item_hd_alluvion_prophecy_active1:IsHidden() return false end
function modifier_item_hd_alluvion_prophecy_active1:IsPurgable() return false end
function modifier_item_hd_alluvion_prophecy_active1:GetTexture()return "item_alluvion_prophecy" end
-- function modifier_item_hd_alluvion_prophecy_active1:GetEffectName() return "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf" end
-- function modifier_item_hd_alluvion_prophecy_active1:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_alluvion_prophecy_active1:OnCreated(keys)
	if IsServer() then

		self.caster = self:GetCaster()
		self.heal = self.caster:GetIntellect(false)*1.5
		self.parent = self:GetParent()
		self:StartIntervalThink(1)


		local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(shackle_particle, 2, Vector(2000,0,0))
		ParticleManager:SetParticleControlEnt(shackle_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.parent, PATTACH_CENTER_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(shackle_particle, true, false, -1, true, false)





	end
end

function modifier_item_hd_alluvion_prophecy_active1:OnIntervalThink()
	if IsServer() then
		local healing =  HealWithGain(self.heal,self.caster,self.parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
	end
end





modifier_item_hd_alluvion_prophecy_active2 = class({})

function modifier_item_hd_alluvion_prophecy_active2:IsDebuff() return false end
function modifier_item_hd_alluvion_prophecy_active2:IsHidden() return false end
function modifier_item_hd_alluvion_prophecy_active2:IsPurgable() return false end
function modifier_item_hd_alluvion_prophecy_active2:GetTexture()return "item_alluvion_prophecy" end

function modifier_item_hd_alluvion_prophecy_active2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(4)
		self.parent=self:GetParent()
		local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(shackle_particle, 2, Vector(2000,0,0))
		ParticleManager:SetParticleControlEnt(shackle_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.parent, PATTACH_CENTER_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(shackle_particle, true, false, -1, true, false)

	end
end


function modifier_item_hd_alluvion_prophecy_active2:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(3)
	end
end



function modifier_item_hd_alluvion_prophecy_active2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法
	}
end

function modifier_item_hd_alluvion_prophecy_active2:GetModifierPercentageManacost()	return 100 end
function modifier_item_hd_alluvion_prophecy_active2:OnAbilityFullyCast(keys)
	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		if keys.ability==self:GetAbility() then
			return
		end
		if keys.ability:GetManaCost(keys.ability:GetLevel())>=20 then
			self:DecrementStackCount()
			if self:GetStackCount()<=0 then
				self:SafeDestroy()
			end
		end
	end
end















modifier_item_hd_alluvion_prophecy_active3 = class({})

function modifier_item_hd_alluvion_prophecy_active3:IsDebuff() return false end
function modifier_item_hd_alluvion_prophecy_active3:IsHidden() return false end
function modifier_item_hd_alluvion_prophecy_active3:IsPurgable() return false end
function modifier_item_hd_alluvion_prophecy_active3:GetTexture()return "item_alluvion_prophecy" end

function modifier_item_hd_alluvion_prophecy_active3:OnCreated(keys)
	if IsServer() then
		self.parent=self:GetParent()
		local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(shackle_particle, 2, Vector(2000,0,0))
		ParticleManager:SetParticleControlEnt(shackle_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.parent, PATTACH_CENTER_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:AddParticle(shackle_particle, true, false, -1, true, false)

	end
end




function modifier_item_hd_alluvion_prophecy_active3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end

function modifier_item_hd_alluvion_prophecy_active3:GetModifierBonusStats_Strength()	return 30 end
function modifier_item_hd_alluvion_prophecy_active3:GetModifierBonusStats_Intellect()	return 30 end
function modifier_item_hd_alluvion_prophecy_active3:GetModifierBonusStats_Agility()	return 30 end

