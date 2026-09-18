
chaotic_disintegrate = class({})
LinkLuaModifier("modifier_chaotic_disintegrate", "chaotic_spell/class_6/chaotic_disintegrate", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_disintegrate_debuff", "chaotic_spell/class_1/chaotic_disintegrate", LUA_MODIFIER_MOTION_NONE)



function chaotic_disintegrate:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_disintegrate/effect_cast/effect.vpcf", context )

end



function chaotic_disintegrate:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end
function chaotic_disintegrate:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetRuneType()==1 and self:GetAutoCastState() then
		local bonus_cost = self:GetSpecialValueFor("rune_1_bonus_cost")*0.01
		cost = cost * (1+bonus_cost)
	end
	cost = cost * self:GetManaCostGain()
	return cost
end




function chaotic_disintegrate:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function chaotic_disintegrate:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	if target:TriggerSpellAbsorb(self) then
		return
	end
	self:PlayEffect(target)
	   



	-- self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_disintegrate:PlayEffect(target)
	EmitSoundOn("chaotic_disintegrate_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_disintegrate/effect_cast/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(head_particle)
	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local magic_res = target:Script_GetMagicalArmorValue(true,self)
	local value = magic_res*self:GetSpecialValueFor("magic_res_reduce_to_reduce")
	if self:GetRuneType()==1 and self:GetAutoCastState() then
		value = value +self:GetSpecialValueFor("rune_1_bonus")
	end
	if value>0 then
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_disintegrate", {duration = self:GetSpecialValueFor("duration"),stack=value})
	end


	ApplyDamage(damageTable)
	if not IsValid(target) or not target:IsAlive() then
		self:EndCooldown()
	end

end





modifier_chaotic_disintegrate = class({})

function modifier_chaotic_disintegrate:IsDebuff()			return true end
function modifier_chaotic_disintegrate:IsHidden() 			return false end
function modifier_chaotic_disintegrate:IsPurgable() 		return true end
function modifier_chaotic_disintegrate:IsPurgeException() 	return true end
function modifier_chaotic_disintegrate:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end	
function modifier_chaotic_disintegrate:DeclareFunctions() return
	 {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	} 
end
function modifier_chaotic_disintegrate:GetModifierMagicalResistanceBonus() 
	return -self:GetStackCount() 
end

function modifier_chaotic_disintegrate:OnTooltip()
	return self:GetModifierMagicalResistanceBonus()
end