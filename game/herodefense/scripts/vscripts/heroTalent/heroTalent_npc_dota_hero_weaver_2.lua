heroTalent_npc_dota_hero_weaver_2 = heroTalent_npc_dota_hero_weaver_2 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_weaver_2", "heroTalent/heroTalent_npc_dota_hero_weaver_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_weaver_2_effect", "heroTalent/heroTalent_npc_dota_hero_weaver_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_weaver_2_damage_block", "heroTalent/heroTalent_npc_dota_hero_weaver_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_weaver_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_weaver_2"
end

function heroTalent_npc_dota_hero_weaver_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_weaver/weaver_shukuchi_damage.vpcf", context )
end


modifier_heroTalent_npc_dota_hero_weaver_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_weaver_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_weaver_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_weaver_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_weaver_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_weaver_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_weaver_2:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self:GetParent():SetHullRadius(0.01)
	end
end

function modifier_heroTalent_npc_dota_hero_weaver_2:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
		local parent = self:GetParent()
		parent:AddNewModifier(parent,ability,"modifier_heroTalent_npc_dota_hero_weaver_2_effect",{})
	end
end




modifier_heroTalent_npc_dota_hero_weaver_2_effect = modifier_heroTalent_npc_dota_hero_weaver_2_effect or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_weaver_2_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_weaver_2_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_weaver_2_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_weaver_2_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_weaver_2_effect:GetEffectName() return "particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf" end


function modifier_heroTalent_npc_dota_hero_weaver_2_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.effect_target = {}
	end
end

function modifier_heroTalent_npc_dota_hero_weaver_2_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end

	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,
		150,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		0,	
		false
	)

	local caster = self:GetCaster()
	for _, unit in ipairs(units) do
		if not self.effect_target[unit] then
			self.effect_target[unit] = GameRules:GetGameTime()
		end
		if GameRules:GetGameTime()>=self.effect_target[unit] and not unit:IsAttackImmune() then
			self.effect_target[unit] = GameRules:GetGameTime()+5
			unit:AddNewModifier(unit,ability,"modifier_heroTalent_npc_dota_hero_weaver_2_damage_block",{duration = 0.5})
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(ability,modifier_keys)

			self.trigger = true
			caster:PerformAttack(unit, false, true, true, false, false, false, true)
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
			self.trigger = false
			self:PlayEffect(unit)
		end
	end

end

function modifier_heroTalent_npc_dota_hero_weaver_2_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,     
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		-- MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_weaver_2_effect:GetModifierMoveSpeedBonus_Constant()
	return 300
end

function modifier_heroTalent_npc_dota_hero_weaver_2_effect:GetModifierIgnoreMovespeedLimit()             return   1  end
function modifier_heroTalent_npc_dota_hero_weaver_2_effect:OnAttackStart(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then	
		if self.trigger then
			return
		end
		self:SafeDestroy()
		self:GetAbility():StartCooldown(9)	
	end
end
function modifier_heroTalent_npc_dota_hero_weaver_2_effect:PlayEffect(target)
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_weaver/weaver_shukuchi_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
	ParticleManager:ReleaseParticleIndex(effect_cast)

end


function modifier_heroTalent_npc_dota_hero_weaver_2_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker:HasModifier("modifier_heroTalent_npc_dota_hero_weaver_2_damage_block") then
		return -100
	end
	return 0
end


function modifier_heroTalent_npc_dota_hero_weaver_2_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



modifier_heroTalent_npc_dota_hero_weaver_2_damage_block = class({})

function modifier_heroTalent_npc_dota_hero_weaver_2_damage_block:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_weaver_2_damage_block:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_weaver_2_damage_block:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_weaver_2_damage_block:IsPurgeException() return false end
