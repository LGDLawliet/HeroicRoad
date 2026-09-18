heroTalent_npc_dota_hero_visage_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_visage_2", "heroTalent/heroTalent_npc_dota_hero_visage_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_visage_2_debuff", "heroTalent/heroTalent_npc_dota_hero_visage_2", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_visage_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_visage_2"
end

function heroTalent_npc_dota_hero_visage_2:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end
function heroTalent_npc_dota_hero_visage_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/visage_talent/talent_2/effect_group.vpcf", context )

end


modifier_heroTalent_npc_dota_hero_visage_2 = class({})
function modifier_heroTalent_npc_dota_hero_visage_2:IsDebuff()      return false end
function modifier_heroTalent_npc_dota_hero_visage_2:IsHidden()      return false end
function modifier_heroTalent_npc_dota_hero_visage_2:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_visage_2:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_visage_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_visage_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


function modifier_heroTalent_npc_dota_hero_visage_2:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.chance = ability:GetSpecialValueFor("chance")
		self.radius = ability:GetSpecialValueFor("radius")
		self.damage_index = ability:GetSpecialValueFor("damage_index")*0.01
		self.stun_duration = ability:GetSpecialValueFor("stun_duration") 
		self.count = ability:GetSpecialValueFor("count")
	end
end
function modifier_heroTalent_npc_dota_hero_visage_2:OnRefresh(keys)
	self:OnCreated()
end

-- particles/rebuild/spell/visage_talent/talent_2/effect_group.vpcf

function modifier_heroTalent_npc_dota_hero_visage_2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	local caster = self:GetCaster()
	if not caster:IsApplyModifier() then
		return
	end
	local pass = false

	if caster:GetRandomEffect(self.chance,INT_TYPE,1)>=RandomInt(1, 100) then
		pass = true
	end

	if pass then

		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/visage_talent/talent_2/effect_group.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
		ParticleManager:SetParticleControl(effect_cast,0,keys.target:GetOrigin())
		ParticleManager:SetParticleControl(effect_cast,1,caster:GetOrigin()-caster:GetForwardVector()*1000+Vector(0,0,1000))
		DestroyParticleByDelay(effect_cast,3)
		-- caster:EmitSound("Hero_NagaSiren.RipTide.Precast")
		caster:EmitSound("Visage_Familar.StoneForm.Stun")
		local units = FindUnitsInRadius(caster:GetTeamNumber(),  keys.target:GetAbsOrigin(), nil, self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #units<=0 then
			return
		end
		local damage = caster:GetAverageTrueAttackDamage(nil)*self.damage_index

	
		local damageTable = {
			-- victim =keys.target,
			attacker = caster,
			damage =damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, 
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, 
		}
	

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
 
		for i, unit in ipairs(units) do
			damageTable.victim = unit
			ApplyDamage( damageTable )
			if unit:IsAlive() then
				local resistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				unit:AddNewModifier(caster, ability, "modifier_stunned", {duration=self.stun_duration*resistance}) 
			end

			if i>=self.count then
				break
			end
		end


	end

	
end

