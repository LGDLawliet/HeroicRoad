LinkLuaModifier("modifier_chaotic_concentration_of_War_qi", "chaotic_spell/class_4/chaotic_concentration_of_War_qi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_concentration_of_War_qi_buff", "chaotic_spell/class_4/chaotic_concentration_of_War_qi", LUA_MODIFIER_MOTION_NONE)

chaotic_concentration_of_War_qi = class({})
function chaotic_concentration_of_War_qi:Precache( context )
	PrecacheResource( "particle", "particles/world_shrine/dire_shrine_active.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_concentration_of_war_qi/chaotic_concentration_of_war_qi.vpcf", context )


	
end

function chaotic_concentration_of_War_qi:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function chaotic_concentration_of_War_qi:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function chaotic_concentration_of_War_qi:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end



function chaotic_concentration_of_War_qi:OnToggle()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if self:GetToggleState() then
		
		
		caster:AddNewModifier(caster, self, "modifier_chaotic_concentration_of_War_qi", {})
		caster:EmitSound("chaotic_concentration_of_war_qi_start")


		local effect_cast1 = ParticleManager:CreateParticle( "particles/world_shrine/dire_shrine_active.vpcf", PATTACH_CUSTOMORIGIN, caster )
	
		-- ParticleManager:SetParticleControl( effect_cast1, 0, caster:GetOrigin()+Vector(0,0,64) )
		ParticleManager:SetParticleControlEnt( effect_cast1, 0, caster, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		DestroyParticleByDelay(effect_cast1,0.3)
		
	else

		caster:RemoveModifierByName("modifier_chaotic_concentration_of_War_qi")
		caster:EmitSound("chaotic_concentration_of_war_qi_end")
	end
	
end

function chaotic_concentration_of_War_qi:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end




function chaotic_concentration_of_War_qi:GetManaCostGain()
	local caster = self:GetCaster()
	local keys = {
		ability=self,
		caster = caster,
	}
	local value = GetChaoticSpellManaCostGain(caster,keys)
	return value
end


modifier_chaotic_concentration_of_War_qi = advanced_modifier({})

function modifier_chaotic_concentration_of_War_qi:IsHidden() return false end
function modifier_chaotic_concentration_of_War_qi:IsPurgable() return true end
function modifier_chaotic_concentration_of_War_qi:IsDebuff() return false end
-- function modifier_chaotic_concentration_of_War_qi:GetEffectName() return "particles/rebuild/spell/chaotic_concentration_of_war_qi/chaotic_concentration_of_war_qi.vpcf" end
-- function modifier_chaotic_concentration_of_War_qi:CheckState()
-- 	local state = {
-- 		-- [MODIFIER_STATE_SILENCED] = true
-- 	}
-- 	if self:GetAbility():GetRuneType()==1 and self:GetAbility():GetAutoCastState() then
-- 		state[MODIFIER_STATE_SILENCED] = true
-- 	end
-- 	return state
-- end








function modifier_chaotic_concentration_of_War_qi:OnCreated()
	
	self.parent = self:GetParent()

	self.attack_damage = self:GetAbility():GetSpecialValueFor("attack_damage") * 0.01
	self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if self:GetAbility():GetRuneType()==1 and self:GetAbility():GetAutoCastState() then
		local gain = self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01+1
		self.attack_damage = self.attack_damage * gain
		self.bonus_attack_damage = self.bonus_attack_damage * gain
		self.bonus_attack_speed = self.bonus_attack_speed * gain
	end





	if IsServer() then
		self.parent:SetMana(0)


	end

end

function modifier_chaotic_concentration_of_War_qi:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	} 
end


function modifier_chaotic_concentration_of_War_qi:Advanced_GetModifierPreAttack_BonusDamage(keys)
	return self.bonus_attack_damage+self.parent:GetMaxMana() * self.attack_damage
end
function modifier_chaotic_concentration_of_War_qi:GetModifierAttackSpeedBonus_Constant(keys)
	return self.bonus_attack_speed
end

function modifier_chaotic_concentration_of_War_qi:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
	elseif self._tooltip == 2 then
		return self:GetModifierAttackSpeedBonus_Constant()
	end
end



function modifier_chaotic_concentration_of_War_qi:ADDeclareFunctions()
	local funcs ={
		advanced_MODIFIER_PROPERTY_MANA_REGEN_Zero_Override,
		-- advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,


    }
	if self:GetAbility():GetRuneType()==1 and self:GetAbility():GetAutoCastState() then
		self.rune_1_bonus_incoming_damage = self:GetAbility():GetSpecialValueFor("rune_1_bonus_incoming_damage")
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
    return funcs
    
end


function modifier_chaotic_concentration_of_War_qi:AdvancedGetModifierConstantManaRegen_Zero_Override()
	return 1
end

function modifier_chaotic_concentration_of_War_qi:Advanced_GetModifierBonusStats_Intellect()
	return -99999
end

function modifier_chaotic_concentration_of_War_qi:Advanced_GetModifierIncomingDamage_Percentage()
	return self.rune_1_bonus_incoming_damage
end

