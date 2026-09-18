heroTalent_npc_dota_hero_void_spirit = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_void_spirit", "heroTalent/heroTalent_npc_dota_hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_void_spirit_effect", "heroTalent/heroTalent_npc_dota_hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_void_spirit_break", "heroTalent/heroTalent_npc_dota_hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_void_spirit:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_void_spirit:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_void_spirit:IsStealable() 				return true end
function heroTalent_npc_dota_hero_void_spirit:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_void_spirit:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_void_spirit" end



modifier_heroTalent_npc_dota_hero_void_spirit = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_void_spirit:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_void_spirit:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_void_spirit:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_void_spirit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_void_spirit:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_void_spirit:OnCreated()
	self.atb_shield = self:GetAbility():GetSpecialValueFor("atb_shield")
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.caster = self:GetCaster()
		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(100, 1, 1))
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)

		self:StartIntervalThink(0.5)
	end
end
function modifier_heroTalent_npc_dota_hero_void_spirit:OnIntervalThink()
	if self:GetParent():IsBlockDisabled() or not self:GetParent():IsAlive() or not self:GetAbility():IsCooldownReady() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
			return
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(100, 1, 1))
			self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		end
	end

	if self:GetAbility():IsCooldownReady() and self:GetStackCount()<=0 then
		self:SetStackCount((self.caster:GetIntellect(false)+self.caster:GetStrength()+self.caster:GetAgility())*self.atb_shield)
	end
	if self:GetStackCount() <= 0 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_void_spirit_break", {duration = 0.6})
	end
end
function modifier_heroTalent_npc_dota_hero_void_spirit:OnWaveStart(table)
    self:SetStackCount((self.caster:GetIntellect(false)+self.caster:GetStrength()+self.caster:GetAgility())*self.atb_shield)
end




function modifier_heroTalent_npc_dota_hero_void_spirit:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
		MODIFIER_EVENT_ON_Wave_Start = {},
	}
end


function modifier_heroTalent_npc_dota_hero_void_spirit:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
		-- return 0 
	end
    if keys.block_disabled then
        return 0 
    end
	local stack = self:GetStackCount()
	if stack<=0 then
		return 0
	end



    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
		self:GetAbility():UseResources(true, true, true,true)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage+1
	end
	return stack

end


modifier_heroTalent_npc_dota_hero_void_spirit_break = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_void_spirit_break:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_break:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_break:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_break:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_break:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_void_spirit_break:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	} 
end
function modifier_heroTalent_npc_dota_hero_void_spirit_break:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_pct")
end