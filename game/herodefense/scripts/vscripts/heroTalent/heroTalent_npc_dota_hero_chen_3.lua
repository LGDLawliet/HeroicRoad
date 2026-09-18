heroTalent_npc_dota_hero_chen_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chen_3", "heroTalent/heroTalent_npc_dota_hero_chen_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chen_3_effect", "heroTalent/heroTalent_npc_dota_hero_chen_3", LUA_MODIFIER_MOTION_NONE )






function heroTalent_npc_dota_hero_chen_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_weaver/weaver_shukuchi_damage.vpcf", context )

end

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_chen_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_chen_3"
end



modifier_heroTalent_npc_dota_hero_chen_3 = class({})

function modifier_heroTalent_npc_dota_hero_chen_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_chen_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chen_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_chen_3:OnSummonUnit(keys)
	if IsServer() then
		-- local unit = keys.target
		local caster = self:GetCaster()
		if caster:PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		if ability:IsCooldownReady() then
			ability:UseResources(true, true, true, true)
			ability:StartCooldown(0.1)  --为了防止无CD导致的bug
			local life_duration = ability:GetSpecialValueFor("duration")
			local heal = caster:GetMaxHealth()*ability:GetSpecialValueFor("bonus_health")*0.01
			local armor = 5
			local damage = caster:GetAverageTrueAttackDamage(nil)*ability:GetSpecialValueFor("bonus_attack")*0.01
			
			local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 
			EmitSoundOn("Hero_Chen.DivineFavor.Cast", caster)	
		
			local unit = caster:SummonUnit("npc_hd_the_wings_of_oberis",life_duration,
			unit_pos,
			caster:GetForwardVector(),self:GetAbility(),0,heal,nil,damage,armor,1,1)
			local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_WORLDORIGIN , unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			DestroyParticleByDelay(particle_cast_fx,3)

			unit:EmitSound("Hero_Chen.DivineFavor.Cast")
		end


	end
end


modifier_heroTalent_npc_dota_hero_chen_3_effect = class({})

function modifier_heroTalent_npc_dota_hero_chen_3_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_chen_3_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen_3_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen_3_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chen_3_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_chen_3_effect:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_chen_3_effect:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=50 then
		parent:Purge(false, true, false, true, false)
		local healing = HealWithGain(parent:GetMaxHealth()*0.35,self:GetCaster(),parent,self:GetAbility())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		self:PlayEffect(parent)
		self:SafeDestroy()
	end

end

function modifier_heroTalent_npc_dota_hero_chen_3_effect:PlayEffect(unit)
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControl(effect_cast,0,unit:GetOrigin() )
	ParticleManager:SetParticleControl(effect_cast,1,unit:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	unit:EmitSound("Hero_Chen.HandOfGodHealHero")

end

