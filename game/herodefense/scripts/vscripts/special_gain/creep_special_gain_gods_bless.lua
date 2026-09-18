creep_special_gain_gods_bless = class({})

LinkLuaModifier("modifier_creep_special_gain_gods_bless", "special_gain/creep_special_gain_gods_bless", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_gods_bless_buff", "special_gain/creep_special_gain_gods_bless", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_gods_bless:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_gods_bless"
end
-----------------------------------------------------

modifier_creep_special_gain_gods_bless = advanced_modifier({})

function modifier_creep_special_gain_gods_bless:IsDebuff() return false end
function modifier_creep_special_gain_gods_bless:IsHidden() return false end
function modifier_creep_special_gain_gods_bless:IsPurgable() return false end

function modifier_creep_special_gain_gods_bless:OnCreated(keys)
    self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.max = self.ability:GetSpecialValueFor("max")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_creep_special_gain_gods_bless:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_creep_special_gain_gods_bless:OnDeath(keys)
	if IsServer() then

		if keys.unit ~= self:GetParent() then
			return
		end

		local parent = self:GetParent()
		if self:GetParent():PassivesDisabled() then
			self.duration = 0.5*self.duration
		end

		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,  400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
		   for i, unit in pairs(units) do
				--
				unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creep_special_gain_gods_bless_buff", {duration = self.duration})
				if i>=5 then
					break
				end
		   end
	end
end

-----------------------------------------------------

modifier_creep_special_gain_gods_bless_buff = advanced_modifier({})

function modifier_creep_special_gain_gods_bless_buff:IsDebuff() return false end
function modifier_creep_special_gain_gods_bless_buff:IsHidden() return false end
function modifier_creep_special_gain_gods_bless_buff:IsPurgable() return false end

function modifier_creep_special_gain_gods_bless_buff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.heal_lose_hp = self.ability:GetSpecialValueFor("heal_lose_hp")
	self:StartIntervalThink(1)
end

function modifier_creep_special_gain_gods_bless_buff:OnIntervalThink()
	if IsServer() then

		local parent = self:GetParent()
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_divine_favor.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		parent:Purge(false, true, false, false, false)  --弱驱散
		local heal = self.heal_lose_hp*0.01 * (parent:GetMaxHealth() - parent:GetHealth())
		parent:Heal(heal,self:GetAbility())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)
	end
end