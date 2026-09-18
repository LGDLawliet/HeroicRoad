heroTalent_npc_dota_hero_legion_commander = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_legion_commander", "heroTalent/heroTalent_npc_dota_hero_legion_commander", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_legion_commander_buff", "heroTalent/heroTalent_npc_dota_hero_legion_commander", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_legion_commander:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_hero.vpcf", context)
end

function heroTalent_npc_dota_hero_legion_commander:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_legion_commander" end



modifier_heroTalent_npc_dota_hero_legion_commander = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_legion_commander:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_legion_commander:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_legion_commander:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_legion_commander:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_legion_commander:OnCreated(table)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.move = self.ability:GetSpecialValueFor("move")
	self.duration = self.ability:GetSpecialValueFor("duration")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.attack_speed_t = self.attack_speed*self.talentgain
    self.move_t = self.move*self.talentgain

	if not IsServer() then return end
	self:StartIntervalThink(0.3)
end

function modifier_heroTalent_npc_dota_hero_legion_commander:OnRefresh(table)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.move = self.ability:GetSpecialValueFor("move")
	self.duration = self.ability:GetSpecialValueFor("duration")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.attack_speed_t = self.attack_speed*self.talentgain
    self.move_t = self.move*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_legion_commander:OnIntervalThink()
	if not self.parent:IsAlive() then return end
	if not self.ability:IsCooldownReady() then return end
	if not self.ability:GetAutoCastState() then return end
	self.ability:UseResources(true,true,true, true)
	self:AddPress(self.caster)
end

function modifier_heroTalent_npc_dota_hero_legion_commander:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},  
    }
end

function modifier_heroTalent_npc_dota_hero_legion_commander:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_legion_commander:OnModifierAdded(keys)
	if not IsServer() then return end
	local unit = keys.unit
	local buff = keys.added_buff
	local Ability = buff:GetAbility()
	local Caster = buff:GetCaster()

	if not self.caster:IsAlive() then return end
	if not self.ability:IsCooldownReady() then return end
	--目标为其自己
	if unit ~= self.caster then return end
	--覆面状态
	if not (buff:IsDebuff() and (buff:IsPurgeException() or buff:IsPurgable())) then return end
		
	self.ability:UseResources(true,true,true, true)
	self:AddPress(self.caster)
end

function modifier_heroTalent_npc_dota_hero_legion_commander:AddPress(unit)
	if not IsServer() then return end
	if not unit then return end
	local duration = self.duration*self.caster:GetModifierDurationGainIndex(0.7)
	unit:Purge(false, true, false, true, true)
	unit:AddNewModifier(unit, self.ability, "modifier_heroTalent_npc_dota_hero_legion_commander_buff", {duration = duration})
end

function modifier_heroTalent_npc_dota_hero_legion_commander:OnTooltip()
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.move = self.ability:GetSpecialValueFor("move")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.attack_speed_t = self.attack_speed*self.talentgain
    self.move_t = self.move*self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.attack_speed_t
    elseif self._tooltip == 2 then
        return self.move_t
	end
end



modifier_heroTalent_npc_dota_hero_legion_commander_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_buff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_buff:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_buff:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_buff:RemoveOnDeath()  return false end
function modifier_heroTalent_npc_dota_hero_legion_commander_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.move = self.ability:GetSpecialValueFor("move")
	self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.attack_speed_t = self.attack_speed*self.talentgain
    self.move_t = self.move*self.talentgain

	if IsServer() then
		local nCastFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlForward(nCastFX, 0, self.parent:GetForwardVector())
		ParticleManager:ReleaseParticleIndex(nCastFX)
		-- local nBuffFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControl(nBuffFX, 1, self.parent:GetOrigin())
		-- ParticleManager:SetParticleControlEnt(nBuffFX, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
		-- ParticleManager:SetParticleControl(nBuffFX, 3, self.parent:GetAbsOrigin())
		-- self:AddParticle(nBuffFX, false, false, -1, false, false)
		self.parent:EmitSoundParams("Hero_LegionCommander.PressTheAttack", 0, 0.3, 0)

		local particleName1 = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
		local pfx1 = ParticleManager:CreateParticle( particleName1, PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt(pfx1,1,self.parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		self:AddParticle(pfx1, false, false, -1, false, false)
	end
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:OnRefresh(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.move = self.ability:GetSpecialValueFor("move")
	self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")

	self.talentgain = self.ability:GetTalentGain(0.7)
    self.attack_speed_t = self.attack_speed*self.talentgain
    self.move_t = self.move*self.talentgain
	if IsServer() then
		local nCastFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlForward(nCastFX, 0, self.parent:GetForwardVector())
		ParticleManager:ReleaseParticleIndex(nCastFX)
		self.parent:EmitSoundParams("Hero_LegionCommander.PressTheAttack", 0, 0.3, 0)
	end
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_t
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.hp_regen
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:Advanced_GetModifierAttackSpeedPercentage()
	return self.attack_speed_t
end

function modifier_heroTalent_npc_dota_hero_legion_commander_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()
    elseif self._tooltip == 2 then
        return self:GetModifierMoveSpeedBonus_Percentage()
	elseif self._tooltip == 3 then
		return self:AdvancedGetModifierConstantHealthRegenPercentage()
	end
end