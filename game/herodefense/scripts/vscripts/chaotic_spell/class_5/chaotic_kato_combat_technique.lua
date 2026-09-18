chaotic_kato_combat_technique = class({})
LinkLuaModifier("modifier_chaotic_kato_combat_technique_passive", "chaotic_spell/class_5/chaotic_kato_combat_technique", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_kato_combat_technique_rune_1_active", "chaotic_spell/class_5/chaotic_kato_combat_technique", LUA_MODIFIER_MOTION_NONE)

function chaotic_kato_combat_technique:GetIntrinsicModifierName()
	return "modifier_chaotic_kato_combat_technique_passive"
end


function chaotic_kato_combat_technique:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return self.BaseClass.GetBehavior(self)
end
function chaotic_kato_combat_technique:Spawn()
	if IsServer() and self:GetRuneType()==1 then
		self:GetCaster():GameTimer(0.1, function()
			self:SetActivated(false)
		end)
		
	end
end
function chaotic_kato_combat_technique:OnSpellStart()
	local caster = self:GetCaster()

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, caster )


	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("rune_1_duration")
	caster:AddNewModifier(caster, self, "modifier_chaotic_kato_combat_technique_rune_1_active", {duration = duration*gain})
	local modifier = caster:FindModifierByName("modifier_chaotic_kato_combat_technique_passive")
	if modifier then
		modifier:SetStackCount(0)
	end
end

modifier_chaotic_kato_combat_technique_passive = advanced_modifier({})

function modifier_chaotic_kato_combat_technique_passive:IsHidden() 	return false end
function modifier_chaotic_kato_combat_technique_passive:IsPurgable() 		    return false end
function modifier_chaotic_kato_combat_technique_passive:IsPurgeException() return false end
function modifier_chaotic_kato_combat_technique_passive:RemoveOnDeath() return false end

function modifier_chaotic_kato_combat_technique_passive:OnCreated( keys )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage_per_stack = self:GetAbility():GetSpecialValueFor("bonus_damage_per_stack")
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
	self.max_stack = math.floor(self:GetAbility():GetSpecialValueFor("max_stack"))


	if IsServer() then
		self.currentAttackTarget = self:GetParent()
  
        self.stack_reduction = self:GetAbility():GetSpecialValueFor("stack_reduction")*0.01

    end
end
function modifier_chaotic_kato_combat_technique_passive:OnRefresh( keys )
	self:OnCreated(keys)
end

function modifier_chaotic_kato_combat_technique_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_chaotic_kato_combat_technique_passive:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierAttackSpeedPercentage()
	elseif self._tooltip == 2 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end



function modifier_chaotic_kato_combat_technique_passive:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end



function modifier_chaotic_kato_combat_technique_passive:OnAttackLanded( params )
	if IsServer() then
        if params.attacker==self:GetParent() then
			if params.attacker:IsRangedAttacker() then
				return
			end
			if params.target~=self.currentAttackTarget then
				self.currentAttackTarget = params.target
				self:SetStackCount(math.floor(self:GetStackCount() * (1-self.stack_reduction)))
			else
				self:SetStackCount(math.min( self.max_stack,self:GetStackCount()+1))
			end

			if self:GetAbility():GetRuneType()==1 then
				if self:GetStackCount()>=self.max_stack then
					self:GetAbility():SetActivated(true)
				else
					self:GetAbility():SetActivated(false)
				end
			end
            

			

        end
    end
end



function modifier_chaotic_kato_combat_technique_passive:Advanced_GetModifierAttackSpeedPercentage()	
	if self:GetParent():PassivesDisabled() then
		return
	end
	if self:GetParent():IsRangedAttacker() then
		return 0
	end
	if self:GetParent():HasModifier("modifier_chaotic_kato_combat_technique_rune_1_active") then
		return self.bonus_attack_speed * self.rune_1_bonus
	end
	return self.bonus_attack_speed
end

function modifier_chaotic_kato_combat_technique_passive:Advanced_GetModifierPreAttack_BonusDamage(keys)
	if self:GetParent():PassivesDisabled() then
		return
	end

	if self:GetParent():IsRangedAttacker() then
		return 0
	end
	if self:GetParent():HasModifier("modifier_chaotic_kato_combat_technique_rune_1_active") then
		return self.bonus_damage_per_stack * self.rune_1_bonus*self.max_stack
	end
	return self.bonus_damage_per_stack*self:GetStackCount()
end









modifier_chaotic_kato_combat_technique_rune_1_active = advanced_modifier({})

function modifier_chaotic_kato_combat_technique_rune_1_active:IsHidden() 	return false end
function modifier_chaotic_kato_combat_technique_rune_1_active:IsPurgable() 		    return false end
function modifier_chaotic_kato_combat_technique_rune_1_active:IsPurgeException() return false end
function modifier_chaotic_kato_combat_technique_rune_1_active:RemoveOnDeath() return false end
