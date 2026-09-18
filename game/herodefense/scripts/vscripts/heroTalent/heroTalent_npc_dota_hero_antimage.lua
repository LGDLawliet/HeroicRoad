heroTalent_npc_dota_hero_antimage = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_antimage", "heroTalent/heroTalent_npc_dota_hero_antimage", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能

function heroTalent_npc_dota_hero_antimage:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_antimage", {duration = self:GetSpecialValueFor("duration")})
end


modifier_heroTalent_npc_dota_hero_antimage = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_antimage:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_antimage:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_antimage:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_antimage:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_antimage:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_antimage:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
function modifier_heroTalent_npc_dota_hero_antimage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_antimage:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER = {self:GetParent(), nil},
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_antimage:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_heroTalent_npc_dota_hero_antimage:OnOrder( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return
	end

	if params.unit~=self:GetParent() then
		return
	end

	-- right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		
		self:SpellToTarget( params.new_pos )
	end
	if 	params.order_type==DOTA_UNIT_ORDER_ATTACK_MOVE then
		self:SpellToTarget( params.new_pos )
	end
	if 	params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET then
		local pos = params.target:GetAbsOrigin()
		self:SpellToTarget( pos )
	end
end
function modifier_heroTalent_npc_dota_hero_antimage:SpellToTarget(pos)
	if IsServer() then
		local caster = self:GetCaster()
		local point = pos
		local origin = caster:GetOrigin()
		local min_dist = 1
		local max_dist = 100000 --不能用-1
		local direction = (point-origin)
		local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
		direction.z = 0
		direction = direction:Normalized()
	
		local target = GetGroundPosition( origin + direction*dist, nil )
		FindClearSpaceForUnit( caster, target, true )
		
		ProjectileManager:ProjectileDodge(self:GetParent()) --弹道躲闪
		self:PlayEffects1( origin, target ,direction)
	end
end


function modifier_heroTalent_npc_dota_hero_antimage:PlayEffects1( origin, target ,direction)
	
	local particle_cast = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
	local particle_end = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
	local sound_start = "Hero_Antimage.Blink_in"
	local sound_end = "Hero_Antimage.Blink_out"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward(effect_cast, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex( effect_cast )


	local effect_cast = ParticleManager:CreateParticle( particle_end, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end