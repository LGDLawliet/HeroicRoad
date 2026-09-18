heroTalent_npc_dota_hero_marci = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci", "heroTalent/heroTalent_npc_dota_hero_marci", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_marci_effect", "heroTalent/heroTalent_npc_dota_hero_marci", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_marci:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_marci:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_marci:IsStealable() 				return true end
function heroTalent_npc_dota_hero_marci:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_marci:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_marci" end
function heroTalent_npc_dota_hero_marci:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_marci = class({})

function modifier_heroTalent_npc_dota_hero_marci:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_marci:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_marci:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_marci:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_marci:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_marci:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.3)
	end
end



function modifier_heroTalent_npc_dota_hero_marci:OnIntervalThink(keys)
	local caster = self:GetCaster()
	if not caster:IsAlive() then
		return
	end
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, 
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local target = caster
	for _, unit in ipairs(units) do
		if unit~=caster then
			local modifier = unit:AddNewModifier(unit, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_marci_effect", {duration=0.35}) 
			modifier.target = caster
			target = unit
			break
		end
	end
	local modifier = caster:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_marci_effect", {duration=0.35}) 
	modifier.target = target
end




modifier_heroTalent_npc_dota_hero_marci_effect = class({})

function modifier_heroTalent_npc_dota_hero_marci_effect:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_marci_effect:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_marci_effect:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_marci_effect:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_marci_effect:RemoveOnDeath()  return false end
function modifier_heroTalent_npc_dota_hero_marci_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

function modifier_heroTalent_npc_dota_hero_marci_effect:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end
function modifier_heroTalent_npc_dota_hero_marci_effect:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end
function modifier_heroTalent_npc_dota_hero_marci_effect:OnCreated( kv )
	if not IsServer() then return end
	self:PlayEffects1()
end
function modifier_heroTalent_npc_dota_hero_marci_effect:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
	
		self.bonus_life_steal = 0.03
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * self.bonus_life_steal*gain
		self.target:Heal( flLifesteal, self:GetAbility() )
		self:PlayEffects2()
	end

	return 0.0

end
function modifier_heroTalent_npc_dota_hero_marci_effect:PlayEffects2()

	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


function modifier_heroTalent_npc_dota_hero_marci_effect:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
	if self:GetParent()~=self:GetCaster() then
		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
	end

	local sound_target = "Hero_Marci.Guardian.Applied"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
