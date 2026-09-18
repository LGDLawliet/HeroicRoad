LinkLuaModifier( "modifier_chaotic_queenbee_attack", "chaotic_spell/class_7/chaotic_queenbee_attack.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_queenbee_attack_effect", "chaotic_spell/class_7/chaotic_queenbee_attack.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_queenbee_attack_rune_1", "chaotic_spell/class_7/chaotic_queenbee_attack.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_queenbee_attack = class({})
function chaotic_queenbee_attack:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_r.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/ti4/blink_dagger_start_sparkles_ti4.vpcf", context )
end
function chaotic_queenbee_attack:GetIntrinsicModifierName()
	return "modifier_chaotic_queenbee_attack"
end

function chaotic_queenbee_attack:OnSpellStart()
	if IsServer() then
		if self:GetCaster():IsRangedAttacker() then
			return
		end
		local modifier = self:GetCaster():FindModifierByName("modifier_chaotic_queenbee_attack")
		if modifier then
			modifier:SetStackCount(self:GetSpecialValueFor("count"))
		end
	end
end
---------------------------------------------------------------------
modifier_chaotic_queenbee_attack = advanced_modifier({})

function modifier_chaotic_queenbee_attack:IsDebuff()			return false end
function modifier_chaotic_queenbee_attack:IsHidden() 		return self:GetStackCount()<=0 end
function modifier_chaotic_queenbee_attack:IsPurgable() 		return false end
function modifier_chaotic_queenbee_attack:IsPurgeException() return false end
function modifier_chaotic_queenbee_attack:OnCreated() 
	if not IsServer() then
		return
	end
	self.crit = {} 
	self.rune_1 = {}
	self.rune_2 = {}
end
function modifier_chaotic_queenbee_attack:OnDestroy() 
	self.crit = nil 
	self.rune_1 = nil
	self.rune_2 = nil
end
function modifier_chaotic_queenbee_attack:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	} 
end
function modifier_chaotic_queenbee_attack:GetModifierAttackSpeedBonus_Constant()
	return math.min(self:GetStackCount()*1000,1000)
end
function modifier_chaotic_queenbee_attack:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
    }
end
function modifier_chaotic_queenbee_attack:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		local ability = self:GetAbility()
		local random = math.random
		local pct = ability:GetSpecialValueFor("crit_chance")
		if self:GetStackCount()>0 then
			pct = 2*pct
		end
		if self:GetAbility():GetRuneType()==1 then
			pct = pct * (1-ability:GetSpecialValueFor("rune_1_chance")*0.01)
			self.rune_1 = true
		end
	
		if pct > random(0,100) then
			local crit_damage =  ability:GetSpecialValueFor("crit_index")
			local damage_mul = crit_damage
			if self:GetStackCount()>0 then
				damage_mul = 2*damage_mul
			end
			if self:GetAbility():GetRuneType()==2 then
				damage_mul = damage_mul * (1+ability:GetSpecialValueFor("rune_2_damage")*0.01)
				self.rune_2 = true
			end
			self.crit[keys.record] = true
			
			return damage_mul 
		end
	end
end

function modifier_chaotic_queenbee_attack:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	local caster = self:GetParent()

	if self.crit[keys.record] then
		local pfx_name = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_r.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
		self:GetParent():EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, keys.target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx)
		local pfx_name2 = "particles/econ/events/ti4/blink_dagger_start_sparkles_ti4.vpcf"
		local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN, keys.target)
		ParticleManager:SetParticleControlEnt(pfx2, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx2, 1, keys.target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx2, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx2)

		if self.rune_1 then
			local modifier_rune_1 = keys.target:FindModifierByName("modifier_chaotic_queenbee_attack_rune_1")
			if modifier_rune_1 then
				modifier_rune_1:ForceRefresh()
				modifier_rune_1:SetDuration(self:GetAbility():GetSpecialValueFor("rune_1_duration"), true)
			else
				keys.target:AddNewModifier(caster, self:GetAbility(), "modifier_chaotic_queenbee_attack_rune_1", {duration = self:GetAbility():GetSpecialValueFor("rune_1_duration")})
			end
			self.rune_1 = nil
		end

		if self:GetAbility():GetRuneType()==3 and not self:GetAbility():IsCooldownReady() then
			local newcooldown = math.max(0,self:GetAbility():GetCooldownTimeRemaining() - self:GetAbility():GetSpecialValueFor("rune_3_cd"))
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(newcooldown)
		end

		self.crit[keys.record] = nil
	end

	
	
end

function modifier_chaotic_queenbee_attack:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if self:GetStackCount()>0 then
		self:SetStackCount(self:GetStackCount()-1)
	end
end


--------------------------------------------------------------------------------------------------------------------------------------
modifier_chaotic_queenbee_attack_rune_1 = modifier_chaotic_queenbee_attack_rune_1 or class({})
function modifier_chaotic_queenbee_attack_rune_1:IsHidden()	return false end
function modifier_chaotic_queenbee_attack_rune_1:IsDebuff()	return true end
function modifier_chaotic_queenbee_attack_rune_1:IsPurgable()	return false end
function modifier_chaotic_queenbee_attack_rune_1:IsPurgeException()	return false end
function modifier_chaotic_queenbee_attack_rune_1:IsStunDebuff()	return false end
function modifier_chaotic_queenbee_attack_rune_1:DeclareFunctions()	return {MODIFIER_PROPERTY_DISABLE_HEALING} end
function modifier_chaotic_queenbee_attack_rune_1:GetDisableHealing() return 1 end
