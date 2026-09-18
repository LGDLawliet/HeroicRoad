heroTalent_npc_dota_hero_batrider = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_batrider", "heroTalent/heroTalent_npc_dota_hero_batrider", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_batrider_effect", "heroTalent/heroTalent_npc_dota_hero_batrider", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_batrider_thinker", "heroTalent/heroTalent_npc_dota_hero_batrider", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_batrider:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_batrider"
end





modifier_heroTalent_npc_dota_hero_batrider = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_batrider:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_batrider:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_batrider:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_batrider:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_batrider:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_batrider:ADDeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_heroTalent_npc_dota_hero_batrider:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then	
		local caster = self:GetCaster()
		local pos = keys.target:GetAbsOrigin()
		CreateModifierThinker(caster, self, "modifier_heroTalent_npc_dota_hero_batrider_thinker", 
		{duration = self:GetAbility():GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
	
		caster:EmitSoundParams("Hero_Batrider.Flamebreak", 0, 0.55, 0)
		self:GetAbility():UseResources(true, true, true,true)
		
		
		
	end
end




modifier_heroTalent_npc_dota_hero_batrider_thinker = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_batrider_thinker:IsHidden()     return false  end
function modifier_heroTalent_npc_dota_hero_batrider_thinker:IsDebuff()     return false  end
function modifier_heroTalent_npc_dota_hero_batrider_thinker:IsStunDebuff() return false end
function modifier_heroTalent_npc_dota_hero_batrider_thinker:IsPurgable()   return false end

function modifier_heroTalent_npc_dota_hero_batrider_thinker:OnCreated( kv )	
	
	if IsServer() then 
		self.timer = 0
		self:StartIntervalThink(1)
		self:PlayEffects()
	end
end
function modifier_heroTalent_npc_dota_hero_batrider_thinker:OnRefresh( kv ) end
function modifier_heroTalent_npc_dota_hero_batrider_thinker:OnRemoved()     end
function modifier_heroTalent_npc_dota_hero_batrider_thinker:OnDestroy()
	if not IsServer() then return end
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end
	-- StopSoundOn( "hero_jakiro.macropyre", self:GetParent() )
	UTIL_Remove( self:GetParent() )
end


function modifier_heroTalent_npc_dota_hero_batrider_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = (caster:GetIntellect(false)+caster:GetStrength()+caster:GetAgility()) *1.2
	local damageTable = {
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability, --Optional.
	}
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
 
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_heroTalent_npc_dota_hero_batrider_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/batrider_talent/batrider.vpcf"
	

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	
	local pos = self:GetParent():GetAbsOrigin()
	ParticleManager:SetParticleControl( self.effect_cast, 0, pos)
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(525, 0, 0 ) )
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:GetParent():EmitSoundParams("Hero_Batrider.Flamebreak.Impact", 0, 0.4, 0)

end
