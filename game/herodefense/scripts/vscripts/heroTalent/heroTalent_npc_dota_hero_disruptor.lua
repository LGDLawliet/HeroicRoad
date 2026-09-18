heroTalent_npc_dota_hero_disruptor = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_disruptor", "heroTalent/heroTalent_npc_dota_hero_disruptor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_disruptor_effect", "heroTalent/heroTalent_npc_dota_hero_disruptor", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_disruptor:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_disruptor"
end



modifier_heroTalent_npc_dota_hero_disruptor = class({})

function modifier_heroTalent_npc_dota_hero_disruptor:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_disruptor:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_disruptor:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_disruptor:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_disruptor:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_disruptor:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end
function modifier_heroTalent_npc_dota_hero_disruptor:OnCreated()
	self.cd_index = (100-self:GetAbility():GetSpecialValueFor("cd_index"))*0.01
end

function modifier_heroTalent_npc_dota_hero_disruptor:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_heroTalent_npc_dota_hero_disruptor:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker ~= self:GetParent() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if not self:GetAbility():IsCooldownReady() then
		local cooldown = self:GetAbility():GetCooldownTimeRemaining()
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(cooldown*self.cd_index)
		return
	end
	if keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()  then	

		if keys.target:IsMagicImmune() then
			return
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		ability:UseResources(true, true, true, true)
		keys.target:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_disruptor_effect", {})
		
	end
end





modifier_heroTalent_npc_dota_hero_disruptor_effect = class({})

function modifier_heroTalent_npc_dota_hero_disruptor_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:IsPurgable()	return true end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:RemoveOnDeath()	return false end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:DestroyOnExpire()	return false end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_disruptor_effect:OnCreated( kv )
	-- references
	self.count = self:GetAbility():GetSpecialValueFor("count")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	local interval = self:GetAbility():GetSpecialValueFor("interval")
	local damage = self:GetAbility():GetSpecialValueFor("int_damage")*self:GetCaster():GetIntellect(false)

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		local duration = (self.count-1) * interval
		self:SetDuration( duration, true )

		self:StartIntervalThink( interval )
		self:OnIntervalThink()

		self.sound_loop = "Hero_Disruptor.ThunderStrike.Thunderator"
		EmitSoundOn( self.sound_loop, self:GetParent() )
	end
end


function modifier_heroTalent_npc_dota_hero_disruptor_effect:OnRemoved()
end

function modifier_heroTalent_npc_dota_hero_disruptor_effect:OnDestroy()
	if not IsServer() then return end
	StopSoundOn( self.sound_loop, self:GetParent() )
end



function modifier_heroTalent_npc_dota_hero_disruptor_effect:OnIntervalThink()
	-- find units in radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- for every unit
	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	-- calculate counter
	self.count = self.count-1
	if self.count<1 then
		self:SafeDestroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_heroTalent_npc_dota_hero_disruptor_effect:GetEffectName()
	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_disruptor_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_heroTalent_npc_dota_hero_disruptor_effect:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf"
	local sound_cast = "Hero_Disruptor.ThunderStrike.Target"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	-- ParticleManager:SetParticleControlEnt(
	-- 	effect_cast,
	-- 	1,
	-- 	self:GetParent(),
	-- 	PATTACH_POINT_FOLLOW,
	-- 	"attach_hitloc",
	-- 	Vector(0,0,0), -- unknown
	-- 	true -- unknown, true
	-- )
	local pos = self:GetParent():GetOrigin()
	
	ParticleManager:SetParticleControl( effect_cast, 2, pos )
	ParticleManager:SetParticleControl( effect_cast, 5, pos )
	pos.z = pos.z +300
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:SetParticleControl( effect_cast, 7, Vector(self.radius,0,0))
	
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	-- EmitSoundOn( sound_cast, self:GetParent() )
end