
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_2", "heroTalent/heroTalent_npc_dota_hero_medusa_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_2_effect", "heroTalent/heroTalent_npc_dota_hero_medusa_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_2_stone", "heroTalent/heroTalent_npc_dota_hero_medusa_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_medusa_2_delay", "heroTalent/heroTalent_npc_dota_hero_medusa_2", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
heroTalent_npc_dota_hero_medusa_2 = heroTalent_npc_dota_hero_medusa_2 or class({})
function heroTalent_npc_dota_hero_medusa_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_medusa_2"
end

function heroTalent_npc_dota_hero_medusa_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_medusa_stone_gaze.vpcf", context )



	
end
function heroTalent_npc_dota_hero_medusa_2:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	target:AddNewModifier(self:GetCaster(), self,"modifier_heroTalent_npc_dota_hero_medusa_2_stone", {duration = 2,physical_bonus = 80,} )
	
end


modifier_heroTalent_npc_dota_hero_medusa_2 = modifier_heroTalent_npc_dota_hero_medusa_2 or class({})

function modifier_heroTalent_npc_dota_hero_medusa_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_medusa_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_medusa_2:OnCreated( kv )

	if not IsServer() then return end
	if not self:GetParent():IsRealHero() then
		return false
	end


end

function modifier_heroTalent_npc_dota_hero_medusa_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_medusa_2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	
	local caster = self:GetParent()
	if caster:GetRandomEffect(13,INT_TYPE,1)  > RandomInt(1, 100) then
		if keys.target:HasModifier("modifier_heroTalent_npc_dota_hero_medusa_2_delay") then
			return
		end
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end

		local ability = self:GetAbility()
		local info = 
		{
			Target = keys.target,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf",
			iMoveSpeed =2000,
			-- vSourceLoc = vPos,
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = false, --提供视野
		}
		ProjectileManager:CreateTrackingProjectile(info)

		keys.target:AddNewModifier(caster, ability,"modifier_heroTalent_npc_dota_hero_medusa_2_delay", {duration = 7} )	
		
	end

	
end





modifier_heroTalent_npc_dota_hero_medusa_2_stone = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_medusa_2_stone:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_2_stone:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_2_stone:IsStunDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_2_stone:IsPurgable()	return true end


function modifier_heroTalent_npc_dota_hero_medusa_2_stone:OnCreated( kv )
	if not IsServer() then return end
	self.physical_bonus = kv.physical_bonus
	self.center_unit = self:GetCaster()
	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_medusa_2_stone:OnRefresh( kv )
	if not IsServer() then return end

	-- references
	self.physical_bonus = kv.physical_bonus


	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_medusa_2_stone:Advanced_GetModifierIncomingDamage_Percentage( params )
	if IsClient() then
		return 0
	end
	if params.damage_type==DAMAGE_TYPE_PHYSICAL then
		return self.physical_bonus
	end
end

function modifier_heroTalent_npc_dota_hero_medusa_2_stone:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end


function modifier_heroTalent_npc_dota_hero_medusa_2_stone:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_heroTalent_npc_dota_hero_medusa_2_stone:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_heroTalent_npc_dota_hero_medusa_2_stone:PlayEffects()
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


function modifier_heroTalent_npc_dota_hero_medusa_2_stone:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




modifier_heroTalent_npc_dota_hero_medusa_2_delay = class({})

function modifier_heroTalent_npc_dota_hero_medusa_2_delay:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_2_delay:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_medusa_2_delay:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_medusa_2_delay:IsPurgeException() return false end
