
creep_special_gain_Expansion_flame = class({})

LinkLuaModifier("modifier_creep_special_gain_Expansion_flame_passive", "special_gain/creep_special_gain_Expansion_flame", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Expansion_flame_effect", "special_gain/creep_special_gain_Expansion_flame", LUA_MODIFIER_MOTION_NONE)




function creep_special_gain_Expansion_flame:GetIntrinsicModifierName() return "modifier_creep_special_gain_Expansion_flame_passive" end

modifier_creep_special_gain_Expansion_flame_passive = class({})

function modifier_creep_special_gain_Expansion_flame_passive:IsHidden() return true end
function modifier_creep_special_gain_Expansion_flame_passive:IsAura() return true end
function modifier_creep_special_gain_Expansion_flame_passive:GetAuraDuration() return 0.5 end
function modifier_creep_special_gain_Expansion_flame_passive:GetModifierAura() return "modifier_creep_special_gain_Expansion_flame_effect" end
function modifier_creep_special_gain_Expansion_flame_passive:GetAuraRadius() return self.radius end
function modifier_creep_special_gain_Expansion_flame_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_creep_special_gain_Expansion_flame_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creep_special_gain_Expansion_flame_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creep_special_gain_Expansion_flame_passive:OnCreated(table)
	if IsServer() then
		self.radius = 100
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/expansion_flame/flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector(self.radius,1,1) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(1)
	end
end

function modifier_creep_special_gain_Expansion_flame_passive:OnIntervalThink()
	self.radius = self.radius +6
	ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector(self.radius,1,1) )
end


modifier_creep_special_gain_Expansion_flame_effect = class({})

function modifier_creep_special_gain_Expansion_flame_effect:IsDebuff()			return true end
function modifier_creep_special_gain_Expansion_flame_effect:IsHidden() 			return true end
function modifier_creep_special_gain_Expansion_flame_effect:IsPurgable() 			return false end
function modifier_creep_special_gain_Expansion_flame_effect:IsPurgeException() 	return false end
function modifier_creep_special_gain_Expansion_flame_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_creep_special_gain_Expansion_flame_effect:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_creep_special_gain_Expansion_flame_effect:OnIntervalThink()
    local ability = self:GetAbility()
	if not ability  then
		return
	end
	local caster = self:GetCaster()
	local damage = caster:GetDamageMax()*0.02
	local damageType = self:GetAbility():GetAbilityDamageType()
	local target = self:GetParent()
	if target:IsMagicImmune() then
		damageType = DAMAGE_TYPE_PURE
		damage = damage*0.1
	end
	local index = 5
	local modifier = target:FindAbilityByName("Advanced_feast")
	if modifier and modifier.unlock2 then
		index = index * 3
	end
	local skeleton_king_4 = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff")
		if skeleton_king_4 and skeleton_king_4.limit then
			index = index * (1+skeleton_king_4.limit)
		end
	if target:GetHealth()*index <= damage then
		TrueKill(caster, target, ability)
		target:EmitSound("Hero_Axe.Culling_Blade_Success")
		local culling_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
		ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)

	end
			
			
	local damage_table = {
		victim = target,
		attacker = caster,
		ability = self:GetAbility(),
		damage = damage,
		damage_type = damageType,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	}
	ApplyDamage(damage_table)
	
end

