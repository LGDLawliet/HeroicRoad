chaotic_taunt_constitution = class({})
LinkLuaModifier("modifier_chaotic_taunt_constitution", "chaotic_spell/class_7/chaotic_taunt_constitution", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_taunt_constitution_debuff", "chaotic_spell/class_7/chaotic_taunt_constitution", LUA_MODIFIER_MOTION_NONE)

function chaotic_taunt_constitution:GetIntrinsicModifierName() return "modifier_chaotic_taunt_constitution" end



function chaotic_taunt_constitution:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_taunt_constitution/chaotic_taunt_constitution_1shoutmask.vpcf", context )

end


function chaotic_taunt_constitution:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end


modifier_chaotic_taunt_constitution = advanced_modifier({})

function modifier_chaotic_taunt_constitution:IsDebuff()			return false end
function modifier_chaotic_taunt_constitution:IsHidden() 		return true end
function modifier_chaotic_taunt_constitution:IsPurgable() 		return false end
function modifier_chaotic_taunt_constitution:IsPurgeException() return false end

function modifier_chaotic_taunt_constitution:OnCreated() 
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.health_regen = self.ability:GetSpecialValueFor("health_regen")*0.01
	self.effect_count = self.ability:GetSpecialValueFor("effect_count")
	self:StartIntervalThink(0.5)
end

function modifier_chaotic_taunt_constitution:OnRefresh()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.health_regen = self.ability:GetSpecialValueFor("health_regen")*0.01
	self.effect_count = self.ability:GetSpecialValueFor("effect_count")
	self:StartIntervalThink(0.5)
end

function modifier_chaotic_taunt_constitution:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self.ability:IsCooldownReady() then
		return
	end
	if not self.parent:IsAlive() then
		return
	end

	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
	self.parent:GetAbsOrigin(),
	nil,
	self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	FIND_ANY_ORDER,
	false)

	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(1)

	local duration = self.ability:GetSpecialValueFor("duration")
	local effect_count = 0

	for i, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_chaotic_taunt_constitution_debuff") then
			effect_count = effect_count + 1
			local StatusResistance = self.parent:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self.parent, self.ability, "modifier_chaotic_taunt_constitution_debuff", {duration = duration * StatusResistance})
			if i >= self.effect_count then
				break
			end
		end
		
	end
	if effect_count>=1 then
		local heal = self.parent:GetHealth() * self.health_regen
		if self:GetAbility():GetRuneType()==1 then
			local fhealing =  HealWithGain(heal*effect_count,self.parent,self.parent,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.parent, fhealing, nil) 
		else
			self.parent:Heal(heal*effect_count, ability)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.parent, heal*effect_count, nil) 
		end
		
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_taunt_constitution/chaotic_taunt_constitution_1shoutmask.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin())
		ParticleManager:SetParticleControl( effect_cast, 2, Vector(self.radius,0,0))
		ParticleManager:SetParticleControlEnt( effect_cast, 3, self.parent, PATTACH_POINT_FOLLOW, nil , self.parent:GetOrigin(), true )
		DestroyParticleByDelay(effect_cast,2)
	
		self.parent:EmitSound("Hero_Axe.BerserkersCall.Start")
	
	
	
		self.ability:UseResources(true,true,true,true)
	end

end



modifier_chaotic_taunt_constitution_debuff = advanced_modifier({})

function modifier_chaotic_taunt_constitution_debuff:IsDebuff()			return true end
function modifier_chaotic_taunt_constitution_debuff:IsHidden() 		return false end
function modifier_chaotic_taunt_constitution_debuff:IsPurgable() 		return false end
function modifier_chaotic_taunt_constitution_debuff:IsPurgeException() return false end

function modifier_chaotic_taunt_constitution_debuff:OnCreated()
	self.damage_reduction = -self:GetAbility():GetSpecialValueFor("damage_reduction")
	if not IsServer() then
		return
	end
	

	self.caster = self:GetCaster()

	self.parent = self:GetParent()

	if not self.caster:IsAttackImmune() and not self.caster:IsInvulnerable() and not self.parent:ImmuneForceAttack() then
		self.parent:SetForceAttackTarget( self.caster ) 
		self.parent:MoveToTargetToAttack( self.caster )
	end

	self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_taunt_constitution/chaotic_taunt_constitution_1d_shoutmask_3.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.parent, PATTACH_OVERHEAD_FOLLOW, nil , self.parent:GetOrigin(), true )
	DestroyParticleByDelay(self.effect_cast,3)

end

function modifier_chaotic_taunt_constitution_debuff:OnDestroy()
	if not IsServer() then
		return
	end
	self.parent:SetForceAttackTarget( nil )
	self.parent:Stop()
end


function modifier_chaotic_taunt_constitution_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_chaotic_taunt_constitution_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
		if keys.target==self.caster then
			return self.damage_reduction
		end
	end
	return 0
end

function modifier_chaotic_taunt_constitution_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_taunt_constitution_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  -self.damage_reduction
	end
end
