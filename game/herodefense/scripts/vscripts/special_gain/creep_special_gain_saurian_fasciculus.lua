creep_special_gain_saurian_fasciculus = class({})

LinkLuaModifier("modifier_creep_special_gain_saurian_fasciculus", "special_gain/creep_special_gain_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_saurian_fasciculus_active", "special_gain/creep_special_gain_saurian_fasciculus", LUA_MODIFIER_MOTION_NONE)



function creep_special_gain_saurian_fasciculus:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_saurian_fasciculus"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_saurian_fasciculus = class({})

function modifier_creep_special_gain_saurian_fasciculus:IsDebuff() return false end
function modifier_creep_special_gain_saurian_fasciculus:IsHidden() return false end
function modifier_creep_special_gain_saurian_fasciculus:IsPurgable() return false end
-- function modifier_creep_special_gain_saurian_fasciculus:GetEffectName() return "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_body_ambient.vpcf" end
-- function modifier_creep_special_gain_saurian_fasciculus:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_saurian_fasciculus:OnCreated(keys)
    self.ability = self:GetAbility()

	self:StartIntervalThink(0.2)

	
end


function modifier_creep_special_gain_saurian_fasciculus:OnIntervalThink()
	if IsServer() then
		if self.ability:IsCooldownReady() then
			local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	   if #units>=2 then
			units[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_saurian_fasciculus_active", {target=units[2]:entindex(),duration = 4})
			units[2]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_saurian_fasciculus_active", {target=units[1]:entindex(),duration = 4})
			self:GetAbility():StartCooldown(20)
			self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")
	   end
			
			  	   
		   
		end
		
	end
end




modifier_item_hd_saurian_fasciculus_active = class({})
-- Doesn't actually ignore status resist, but this is handled in the channel time function
function modifier_item_hd_saurian_fasciculus_active:IsDebuff()			return true end
function modifier_item_hd_saurian_fasciculus_active:IsHidden() 			return false end
function modifier_item_hd_saurian_fasciculus_active:IsPurgable()			return true end
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
	self.speed = 70
	self:StartIntervalThink(self.tick_interval)
end

function modifier_item_hd_saurian_fasciculus_active:OnIntervalThink()
	if not IsServer() then return end
	--目标死了 即可销毁
	if not self.target:IsAlive()then
		self:SafeDestroy()
		return
	end
	local modifiers = self.target:FindAllModifiersByName("modifier_item_hd_saurian_fasciculus_active")
	local modifier_on = false
	for _, modifier in ipairs(modifiers) do
		if modifier.target and modifier.target==self:GetParent() then
			modifier_on = true
			break
		end
	end
	--目标的此状态被销毁了 也可以销毁
	if not modifier_on then
		self:SafeDestroy()
		return
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



function modifier_item_hd_saurian_fasciculus_active:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_item_hd_saurian_fasciculus_active:GetModifierMoveSpeedBonus_Percentage() 
        return -10
end


