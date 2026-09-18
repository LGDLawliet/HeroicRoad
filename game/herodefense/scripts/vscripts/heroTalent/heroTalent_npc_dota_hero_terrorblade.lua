--推荐系数150，上限敏捷1200
heroTalent_npc_dota_hero_terrorblade = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade", "heroTalent/heroTalent_npc_dota_hero_terrorblade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_effect", "heroTalent/heroTalent_npc_dota_hero_terrorblade", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_terrorblade:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_terrorblade"
end



modifier_heroTalent_npc_dota_hero_terrorblade = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_terrorblade:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.count = self.ability:GetSpecialValueFor("count")
	self.mirror_attack = self.ability:GetSpecialValueFor("mirror_attack")*0.01
	self.talent_gain = self.ability:GetTalentGain(0.6)
	self.mirror_attack_t = self.mirror_attack*self.talent_gain

	self.limit = 1200
	self.index = 150

	if IsServer() then
		self.damagetable = {
			apply_damage_init = false,
			apply_damage_interval = 0.06,
			ability = self.ability,
			attacker = self.caster,
			damage_type = self.ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE,
		}
	end
end

function modifier_heroTalent_npc_dota_hero_terrorblade:ADDeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},} 
end

function modifier_heroTalent_npc_dota_hero_terrorblade:DeclareFunctions()
    return {MODIFIER_PROPERTY_TOOLTIP}
end


function modifier_heroTalent_npc_dota_hero_terrorblade:OnAttackLanded(keys)
    if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target
	if not target or not target:IsAlive() then return end
	if target:IsMagicImmune() then return end

	self.attack_num = (self.attack_num or 0) + 1

	local target_attack = target:GetAverageTrueAttackDamage(target)
	if target_attack <= 0 then return end
	if self.attack_num >= self.count then 
		self.talent_gain = self.ability:GetTalentGain(0.6)
		self.mirror_attack_t = self.mirror_attack*self.talent_gain

		local keys = {
			origin = target_attack*self.mirror_attack_t,
			limit = self.limit*attacker:GetAgility(),
			index = self.index
		}
		self.damagetable.damage = SqrtPercentage(keys)
		
		target:ApplyMergeDamage(self.damagetable)
		self:PlayEffects(target)
		self.attack_num = 0
	end
end

function modifier_heroTalent_npc_dota_hero_terrorblade:OnTooltip( params )
	self.talent_gain = self.ability:GetTalentGain(0.6)
	self.mirror_attack_t = self.mirror_attack*self.talent_gain

	return self.mirror_attack_t*100
end

function modifier_heroTalent_npc_dota_hero_terrorblade:PlayEffects( target )
	local particle_id = ParticleManager:CreateParticle("particles/rebuild/spell/talent/terrorblade/effect.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle_id, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_id)
end