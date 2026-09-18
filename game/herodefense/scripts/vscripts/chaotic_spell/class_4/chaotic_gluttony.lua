chaotic_gluttony = class({})
LinkLuaModifier("modifier_chaotic_gluttony", "chaotic_spell/class_4/chaotic_gluttony", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_gluttony_rune_1", "chaotic_spell/class_4/chaotic_gluttony", LUA_MODIFIER_MOTION_NONE)

function chaotic_gluttony:GetIntrinsicModifierName() return "modifier_chaotic_gluttony" end

function chaotic_gluttony:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_gluttony/effect_main/effect.vpcf", context )
end

function chaotic_gluttony:GetCooldown(iLevel)
	if self:GetRuneType()==1 then
		return self:GetSpecialValueFor("rune_1_cooldown")
	end
	return 0
end


function chaotic_gluttony:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return self.BaseClass.GetBehavior(self)
end

function chaotic_gluttony:OnSpellStart()


	local caster =self:GetCaster()

	-- local infest_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_summon_wild_bear/effects.vpcf", PATTACH_POINT, caster)
	-- ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	-- ParticleManager:ReleaseParticleIndex(infest_particle)
	if self:GetRuneType()==1 then
		caster:EmitSound("Hero_LifeStealer.Rage")
		local gain = caster:GetModifierDurationGainIndex(1)
		caster:AddNewModifier(caster, self, "modifier_chaotic_gluttony_rune_1", {duration=self:GetSpecialValueFor("rune_1_duration")*gain})
	end
	



end




modifier_chaotic_gluttony = advanced_modifier({})

function modifier_chaotic_gluttony:IsDebuff()			return false end
function modifier_chaotic_gluttony:IsHidden() 		return true end
function modifier_chaotic_gluttony:IsPurgable() 		return false end
function modifier_chaotic_gluttony:IsPurgeException() return false end
function modifier_chaotic_gluttony:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
    }
end

function modifier_chaotic_gluttony:OnCreated() 
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal") * 0.01
	self.chance =  self.ability:GetSpecialValueFor("chance")
	self.life_steal_rate =  self.ability:GetSpecialValueFor("life_steal_rate")* 0.01
end

function modifier_chaotic_gluttony:OnRefresh() 
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal") * 0.01
	self.chance =  self.ability:GetSpecialValueFor("chance")
	self.life_steal_rate =  self.ability:GetSpecialValueFor("life_steal_rate")* 0.01
end

function modifier_chaotic_gluttony:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	-- print("00000")
	if self.parent ~= keys.attacker then
		return
	end
	if self.parent:PassivesDisabled() then
        return 
    end   
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK  then
		return
	end
	local pass = false
	local life_steal = self.bonus_life_steal
	if keys.unit:GetHealth()<= 0 then
		pass = true
	end
	if not pass then
		if self.parent:HasModifier("modifier_chaotic_gluttony_rune_1") or self.chance>=RandomInt(1, 100) then
			pass = true
			life_steal= life_steal * self.life_steal_rate
		end
	end
	if pass then
		
		local bonus_life_steal = keys.damage * life_steal
		local fhealing =  HealWithGain(bonus_life_steal,self.parent,self.parent,nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.parent, fhealing, nil)
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_gluttony/effect_main/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt(effect_cast, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",self.parent:GetOrigin(), false)
		DestroyParticleByDelay(effect_cast,1)
	end
end


modifier_chaotic_gluttony_rune_1 = advanced_modifier({})

function modifier_chaotic_gluttony_rune_1:IsDebuff()			return false end
function modifier_chaotic_gluttony_rune_1:IsHidden() 		return false end
function modifier_chaotic_gluttony_rune_1:IsPurgable() 		return false end
function modifier_chaotic_gluttony_rune_1:IsPurgeException() return false end
function modifier_chaotic_gluttony_rune_1:GetEffectName() return "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds.vpcf" end
