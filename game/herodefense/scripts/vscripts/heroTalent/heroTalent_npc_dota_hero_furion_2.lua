heroTalent_npc_dota_hero_furion_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_furion_2", "heroTalent/heroTalent_npc_dota_hero_furion_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_furion_2_effect", "heroTalent/heroTalent_npc_dota_hero_furion_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_furion_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_furion_2"
end

function heroTalent_npc_dota_hero_furion_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_wrath_of_nature_old.vpcf", context )

end


modifier_heroTalent_npc_dota_hero_furion_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_furion_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_furion_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_furion_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_furion_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_furion_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_furion_2:OnCreated(table)
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.heal = self:GetAbility():GetSpecialValueFor("heal")
	self.bonus_heal = self:GetAbility():GetSpecialValueFor("bonus_heal")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_heroTalent_npc_dota_hero_furion_2:OnIntervalThink()
	local heroes = GetAllRealHeroes()
	for _ , parent in pairs(heroes) do

		local heal = parent:GetHealthRegen()*self.heal + self:GetCaster():GetIntellect(false)*self.bonus_heal
		local healing = HealWithGain(heal,self:GetCaster(),parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
	end
end
function modifier_heroTalent_npc_dota_hero_furion_2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_furion_2_effect", {})
		local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature_old.vpcf", PATTACH_ABSORIGIN_FOLLOW , caster)
		ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		unit:EmitSound("Hero_Furion.WrathOfNature_Damage")
	end
end

modifier_heroTalent_npc_dota_hero_furion_2_effect = class({})

function modifier_heroTalent_npc_dota_hero_furion_2_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_furion_2_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_furion_2_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_furion_2_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_heroTalent_npc_dota_hero_furion_2_effect:OnCreated(keys)
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.heal = self:GetAbility():GetSpecialValueFor("heal")
	self.bonus_heal = self:GetAbility():GetSpecialValueFor("bonus_heal")
	if IsServer() then
		self:StartIntervalThink(self.interval)

	end
end



function modifier_heroTalent_npc_dota_hero_furion_2_effect:OnIntervalThink(keys)
	local parent = self:GetParent()
	local heal = parent:GetHealthRegen()*self.heal + self:GetCaster():GetIntellect(false)*self.bonus_heal
	local healing = HealWithGain(heal,self:GetCaster(),parent,self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
end

