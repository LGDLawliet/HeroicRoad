heroTalent_npc_dota_hero_lone_druid = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lone_druid", "heroTalent/heroTalent_npc_dota_hero_lone_druid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_lone_druid_active", "heroTalent/heroTalent_npc_dota_hero_lone_druid",LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_lone_druid:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_lone_druid:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_lone_druid:IsStealable() 				return true end
function heroTalent_npc_dota_hero_lone_druid:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_lone_druid:GetIntrinsicModifierName()		return "modifier_heroTalent_npc_dota_hero_lone_druid" end
function heroTalent_npc_dota_hero_lone_druid:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function heroTalent_npc_dota_hero_lone_druid:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for i ,unit in pairs(units)do
		unit:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_lone_druid_active", {duration = duration})
		if i>=self:GetSpecialValueFor("limit") then
			break
		end
	end
end

modifier_heroTalent_npc_dota_hero_lone_druid_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lone_druid_active:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lone_druid_active:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_lone_druid_active:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_lone_druid_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_lone_druid_active:GetEffectName() return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_hero_heal.vpcf" end
function modifier_heroTalent_npc_dota_hero_lone_druid_active:OnCreated()
	self.heal = self:GetParent():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("maxhp_heal")*0.01
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	if IsServer() then
		local cd_index = self:GetAbility():GetSpecialValueFor("cd_index")
		local rate_gain =1-((1-self:GetCaster():GetCooldownReduction())*cd_index*0.01)
		self:StartIntervalThink(-1)
		self:StartIntervalThink(self.interval*rate_gain)
		--print("冷却缩减读取值"..self:GetParent():GetCooldownReduction())
		--print("实际跳速"..self.interval*rate_gain)
	end
end

function modifier_heroTalent_npc_dota_hero_lone_druid_active:OnRefresh()
	self.heal = self:GetParent():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("maxhp_heal")*0.01
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	if IsServer() then
		local cd_index = self:GetAbility():GetSpecialValueFor("cd_index")
		local rate_gain =1-((1-self:GetCaster():GetCooldownReduction())*cd_index*0.01)
		self:StartIntervalThink(-1)
		self:StartIntervalThink(self.interval*rate_gain)
		--print("冷却缩减读取值"..self:GetParent():GetCooldownReduction())
		--print("实际跳速"..self.interval*rate_gain)
	end
end

function modifier_heroTalent_npc_dota_hero_lone_druid_active:OnIntervalThink()
	self.heal = self:GetParent():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("maxhp_heal")*0.01
	HealWithGain(self.heal,self:GetCaster(),self:GetParent(),self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self:GetParent(), self.heal, nil) 
end
---------------------
modifier_heroTalent_npc_dota_hero_lone_druid = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_lone_druid:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_lone_druid:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_lone_druid:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_lone_druid:OnCreated()
	self:SetStackCount(0)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_heroTalent_npc_dota_hero_lone_druid:OnIntervalThink()
	local heal_amp = self:GetCaster():GetSpellAmplification(false)*100
	self:SetStackCount(math.max(heal_amp,0))
end

function modifier_heroTalent_npc_dota_hero_lone_druid:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
	}
end

function modifier_heroTalent_npc_dota_hero_lone_druid:Advanced_GetModifierHealAMP_Percentage()
	return self:GetStackCount()
end