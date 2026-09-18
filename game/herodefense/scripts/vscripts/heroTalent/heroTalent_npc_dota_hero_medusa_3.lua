
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_3", "heroTalent/heroTalent_npc_dota_hero_medusa_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_3_effect", "heroTalent/heroTalent_npc_dota_hero_medusa_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_3_stone", "heroTalent/heroTalent_npc_dota_hero_medusa_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_3_delay", "heroTalent/heroTalent_npc_dota_hero_medusa_3", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
heroTalent_npc_dota_hero_medusa_3 = heroTalent_npc_dota_hero_medusa_3 or class({})
function heroTalent_npc_dota_hero_medusa_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_medusa_3"
end

function heroTalent_npc_dota_hero_medusa_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/medusa_3/effect_stone/effect_lvl1_death.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", context )


	
end

function heroTalent_npc_dota_hero_medusa_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
				}
				skillshop:LearnTalentDefaultAbility(caster,"split_shot",costKeys)
			end
		end)
	
	end

end




modifier_heroTalent_npc_dota_hero_medusa_3 = modifier_heroTalent_npc_dota_hero_medusa_3 or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_medusa_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_medusa_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_medusa_3:OnCreated( kv )

	if not IsServer() then return end
	local ability = self:GetAbility()
	self.radius = ability:GetSpecialValueFor("radius")
	self.damage_require = ability:GetSpecialValueFor("damage_require")*0.01
	self.duration = ability:GetSpecialValueFor("duration")
	self.cooldown= ability:GetSpecialValueFor("cooldown")
end

function modifier_heroTalent_npc_dota_hero_medusa_3:OnRefresh( kv )

	if not IsServer() then return end
	local ability = self:GetAbility()
	self.radius = ability:GetSpecialValueFor("radius")
	self.damage_require = ability:GetSpecialValueFor("damage_require")*0.01
	self.duration = ability:GetSpecialValueFor("duration")
	self.cooldown= ability:GetSpecialValueFor("cooldown")
end


function modifier_heroTalent_npc_dota_hero_medusa_3:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},

    }
end



function modifier_heroTalent_npc_dota_hero_medusa_3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	
	if self:GetSplitShot() then
		local caster = self:GetParent()
		if keys.target.medusa_talent then
			return
		end
		if keys.target:GetHealth()<=caster:GetDamageMax()*self.damage_require then
			TrueKill(caster, keys.target, self:GetAbility())
			if not keys.target:IsAlive() then
				local particle_cast = "particles/rebuild/talent/medusa_3/effect_stone/effect_lvl1_death.vpcf"
				local sound_cast = "Hero_Medusa.StoneGaze.Stun"
				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt(effect_cast,0,keys.target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector( 0,0,0 ),true)
				keys.target:EmitSound(sound_cast)
				keys.target.medusa_talent  = true

				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				-- print("enemies=",#enemies)
				for _, unit in ipairs(enemies) do
					if not unit:HasModifier("modifier_heroTalent_npc_dota_hero_medusa_3_delay") then
						unit:AddNewModifier(caster, self:GetAbility(),"modifier_heroTalent_npc_dota_hero_medusa_3_stone", {duration = self.duration} )	
						unit:AddNewModifier(caster, self:GetAbility(),"modifier_heroTalent_npc_dota_hero_medusa_3_delay", {duration = self.cooldown} )	
					end
					
				end
			end
		end

	end
end
-- "DOTA_Tooltip_ability_heroTalent_npc_dota_hero_medusa_3_Description"	"分裂箭的分裂数加%bonus_split%，携带中阶以上分裂箭时，当你的附带攻击特效的箭矢命中目标时如果目标的生命值低于你攻击力的%damage_require%%%，那么可以对其造成即死效果，且目标将会被变为碎石碎开，并对以其为中心的%radius%范围内的敌人会被石化%duration%秒，期间承受额外%bonus_damage_index%%%的物理伤害。"



function modifier_heroTalent_npc_dota_hero_medusa_3:GetSplitShot()

	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_split_shot")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_split_shot")
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_split_shot")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_split_shot")
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end



modifier_heroTalent_npc_dota_hero_medusa_3_stone = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_medusa_3_stone:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_3_stone:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_3_stone:IsStunDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_3_stone:IsPurgable()	return true end


function modifier_heroTalent_npc_dota_hero_medusa_3_stone:OnCreated( kv )
	self.physical_bonus = self:GetAbility():GetSpecialValueFor("bonus_damage_index")
	if not IsServer() then return end
	
	self.center_unit = self:GetCaster()
	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_medusa_3_stone:OnRefresh( kv )
	self.physical_bonus = self:GetAbility():GetSpecialValueFor("bonus_damage_index")
	if not IsServer() then return end

	-- references
	


	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_medusa_3_stone:Advanced_GetModifierIncomingDamage_Percentage( params )
	if IsClient() then
		return 0
	end
	if params.damage_type==DAMAGE_TYPE_PHYSICAL then
		return self.physical_bonus
	end
end

function modifier_heroTalent_npc_dota_hero_medusa_3_stone:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end


function modifier_heroTalent_npc_dota_hero_medusa_3_stone:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_heroTalent_npc_dota_hero_medusa_3_stone:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_heroTalent_npc_dota_hero_medusa_3_stone:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
	local sound_cast = "Hero_Medusa.StoneGaze.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.center_unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector( 0,0,0 ), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:GetParent():EmitSound(sound_cast)
end


function modifier_heroTalent_npc_dota_hero_medusa_3_stone:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


function modifier_heroTalent_npc_dota_hero_medusa_3_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_heroTalent_npc_dota_hero_medusa_3_stone:OnTooltip() return self.physical_bonus end




modifier_heroTalent_npc_dota_hero_medusa_3_delay = class({})

function modifier_heroTalent_npc_dota_hero_medusa_3_delay:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_3_delay:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_3_delay:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_3_delay:IsPurgeException() return false end
