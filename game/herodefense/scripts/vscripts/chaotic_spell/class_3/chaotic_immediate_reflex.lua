LinkLuaModifier("modifier_chaotic_immediate_reflex", "chaotic_spell/class_3/chaotic_immediate_reflex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_immediate_reflex_buff", "chaotic_spell/class_3/chaotic_immediate_reflex", LUA_MODIFIER_MOTION_NONE)

chaotic_immediate_reflex = class({})
function chaotic_immediate_reflex:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_immediate_reflex/chaotic_immediate_reflex.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_immediate_reflex/chaotic_immediate_reflex_2.vpcf", context )
end

function chaotic_immediate_reflex:GetIntrinsicModifierName()
	return "modifier_chaotic_immediate_reflex_buff"
end

-- function chaotic_immediate_reflex:GetManaCost(iLevel)
-- 	local cost = self.BaseClass.GetManaCost(self,iLevel)
-- 	cost = cost * self:GetManaCostGain()
-- 	return cost
-- end


function chaotic_immediate_reflex:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end




function chaotic_immediate_reflex:OnSpellStart()

	local caster = self:GetCaster()

	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * gain

	caster:AddNewModifier(caster, self, "modifier_chaotic_immediate_reflex", {duration = duration})

	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_immediate_reflex/chaotic_immediate_reflex_2.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
	DestroyParticleByDelay(effect_cast1,2)

	caster:EmitSound("chaotic_immediate_reflex_cast")
	
end


modifier_chaotic_immediate_reflex = advanced_modifier({})

function modifier_chaotic_immediate_reflex:IsHidden() return false end
function modifier_chaotic_immediate_reflex:IsPurgable() return true end
function modifier_chaotic_immediate_reflex:IsDebuff() return false end

function modifier_chaotic_immediate_reflex:OnCreated()

	if not IsServer() then
		return
	end

	local ability =  self:GetAbility()
	local stack = ability:GetSpecialValueFor("miss_number")*ability:GetEffectGain()
	if ability:GetRuneType()==1 then
		local gain =( self:GetCaster():GetModifierDurationGainIndex(1)-1)*100/ability:GetSpecialValueFor("rune_1_require")
		if gain>=1 then
			stack = stack + math.min(math.floor(gain),ability:GetSpecialValueFor("rune_1_max"))
		end
	end
	self:SetStackCount(stack)



end

function modifier_chaotic_immediate_reflex:OnRefresh()

	if not IsServer() then
		return
	end
	local ability =  self:GetAbility()
	local stack = ability:GetSpecialValueFor("miss_number")*ability:GetEffectGain()
	self:SetStackCount(stack)

end

function modifier_chaotic_immediate_reflex:OnStackCountChanged(iStackCount)
	if self:GetStackCount()<=0 then
		self:Destroy()
	end
end



modifier_chaotic_immediate_reflex_buff = modifier_chaotic_immediate_reflex_buff or advanced_modifier({})

function modifier_chaotic_immediate_reflex_buff:IsPassive()          return true end
function modifier_chaotic_immediate_reflex_buff:IsBuff()				return true end
function modifier_chaotic_immediate_reflex_buff:IsPurgable()     	return false end
function modifier_chaotic_immediate_reflex_buff:IsPurgeException() 	return false end
function modifier_chaotic_immediate_reflex_buff:IsHidden()			return true end

function modifier_chaotic_immediate_reflex_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
 
function modifier_chaotic_immediate_reflex_buff:OnCreated(keys)
	self.miss = self:GetAbility():GetSpecialValueFor("miss_chance")
	self.counterattack_chance = self:GetAbility():GetSpecialValueFor("counterattack_chance")
	self.counterattack_range = self:GetAbility():GetSpecialValueFor("counterattack_range") * 0.01
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.counterattack_cooldown =  self:GetAbility():GetSpecialValueFor("counterattack_cooldown")
	end
	

end
function modifier_chaotic_immediate_reflex_buff:OnRefresh(keys)
	self.miss = self:GetAbility():GetSpecialValueFor("miss_chance")
	self.counterattack_chance = self:GetAbility():GetSpecialValueFor("counterattack_chance")
	self.counterattack_range = self:GetAbility():GetSpecialValueFor("counterattack_range") * 0.01
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.counterattack_cooldown =  self:GetAbility():GetSpecialValueFor("counterattack_cooldown")
	end
end

function modifier_chaotic_immediate_reflex_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		local parent = self:GetParent()

		local modifier = parent:FindModifierByName("modifier_chaotic_immediate_reflex")
		local applyAttack = false
		local evade_damage = false
		if modifier then
			applyAttack = true
			evade_damage = true
			modifier:DecrementStackCount()
		end
		if not applyAttack then
			if self.timer>=GameRules:GetGameTime() then
				return
			end

			local distance = (keys.attacker:GetOrigin() - parent:GetOrigin()):Length2D()
			if parent:Script_GetAttackRange() * (1 + self.counterattack_range) >= distance then
				if self.counterattack_chance >= RandomInt(1, 100) then
					applyAttack = true
					
					self.timer = GameRules:GetGameTime() +self.counterattack_cooldown
				end
			end
		end
		if not evade_damage then
			if self.miss >= RandomInt(1, 100) then
				evade_damage = true
			end
		end

		if applyAttack and IsEnemy(keys.attacker,parent) then
			-- parent:SetForwardVector(keys.attacker:GetOrigin() - parent:GetOrigin())
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
			}
			local attackEffectRecord = parent:AddAttackEffectModifier( self:GetAbility(),modifier_keys)
			parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0, 0.3, 4)
			parent:PerformAttack(keys.attacker, false, true, true, false, true, false, true)
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		end
		if evade_damage then
			if modifier then
				local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_immediate_reflex/chaotic_immediate_reflex.vpcf", PATTACH_CUSTOMORIGIN, parent )
				-- ParticleManager:SetParticleControl( effect_cast1, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControlEnt( effect_cast1, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
				DestroyParticleByDelay(effect_cast1,2)
				parent:EmitSound("Hero_PhantomAssassin.Blur.Break")
			end
			return -100
		end


	end

	return 0
end