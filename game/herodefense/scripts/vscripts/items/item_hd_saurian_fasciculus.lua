item_hd_saurian_fasciculus = class({})
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_arua", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_arua_effect", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_saurian_fasciculus", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_saurian_fasciculus_active", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_effect", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_effect2", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_active_standby", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_debuff", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_saurian_fasciculus_thinker", "items/item_hd_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_saurian_fasciculus:GetIntrinsicModifierName()
	return "modifier_item_hd_saurian_fasciculus"
end






modifier_item_hd_saurian_fasciculus = advanced_modifier({})

function modifier_item_hd_saurian_fasciculus:IsDebuff() return false end
function modifier_item_hd_saurian_fasciculus:IsHidden() return true end
function modifier_item_hd_saurian_fasciculus:IsPurgable() return false end



function modifier_item_hd_saurian_fasciculus:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")

	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")

	self.bonus_StatusNegativeGain = self.ability:GetSpecialValueFor("bonus_StatusNegativeGain")
	


    if IsServer() then
		self:StartIntervalThink(0.2)

	end
end
function modifier_item_hd_saurian_fasciculus:OnIntervalThink()
	if IsServer() then

	   if self:GetAbility():IsCooldownReady() then
			local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
			if #units>=2 then
				units[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_saurian_fasciculus_active", {target=units[2]:entindex(),duration = 7})
				units[2]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_saurian_fasciculus_active", {target=units[1]:entindex(),duration = 7})
				self:GetAbility():StartCooldown(15)
				self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")
				if #units>=4 then
					units[3]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_saurian_fasciculus_active", {target=units[4]:entindex(),duration = 7})
					units[4]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_saurian_fasciculus_active", {target=units[3]:entindex(),duration = 7})
					self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")
				end
			end
			
			
			
	   end

	end
end

function modifier_item_hd_saurian_fasciculus:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
	
		

	}
end


function modifier_item_hd_saurian_fasciculus:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_saurian_fasciculus:GetModifierManaBonus()	return self.bonus_mana end



-- advanced_modifier
function modifier_item_hd_saurian_fasciculus:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,
    }
end
function modifier_item_hd_saurian_fasciculus:Advanced_GetModifier_NegativeDurationGain(keys)
	return self.bonus_StatusNegativeGain
end





modifier_item_hd_saurian_fasciculus_active = class({})
-- Doesn't actually ignore status resist, but this is handled in the channel time function
function modifier_item_hd_saurian_fasciculus_active:IsDebuff()			return true end
function modifier_item_hd_saurian_fasciculus_active:IsHidden() 			return false end
function modifier_item_hd_saurian_fasciculus_active:IsPurgable()			return false end
function modifier_item_hd_saurian_fasciculus_active:IsPurgeException()	    return false end
function modifier_item_hd_saurian_fasciculus_active:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_saurian_fasciculus_active:OnCreated(keys)
	if not IsServer() then return end
	
	self.target			= EntIndexToHScript(keys.target)
	local parent = self:GetParent()
	local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/ss_fall20_tongue/shadowshaman_shackle_net_fall20.vpcf", PATTACH_POINT_FOLLOW, self.target)
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
	self.tick_interval			= 0.1
	self.speed = 300
	self:StartIntervalThink(self.tick_interval)
end

function modifier_item_hd_saurian_fasciculus_active:OnIntervalThink()
	if not IsServer() then return end
	if not self.target or  self.target:IsNull() or not self.target:IsAlive() then
		self:SafeDestroy()
	end
	local pos_caster = self:GetParent():GetAbsOrigin()  --获取自己
    local pos_target = self.target:GetAbsOrigin()  --获取敌人
    self.direction = (pos_target - pos_caster):Normalized()
    self.direction.z = 0  --初始化Z值

	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
end



function modifier_item_hd_saurian_fasciculus_active:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_item_hd_saurian_fasciculus_active:GetModifierMoveSpeedBonus_Constant() 
        return -180
end

