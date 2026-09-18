
chaotic_feeblemind = class({})
LinkLuaModifier("modifier_chaotic_feeblemind", "chaotic_spell/class_8/chaotic_feeblemind", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_chaotic_feeblemind_rune_2_buff", "chaotic_spell/class_8/chaotic_feeblemind", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_feeblemind_rune_3_debuff", "chaotic_spell/class_8/chaotic_feeblemind", LUA_MODIFIER_MOTION_NONE)

function chaotic_feeblemind:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_target/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_debuff/effect.vpcf", context )

end
function chaotic_feeblemind:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end
function chaotic_feeblemind:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_feeblemind:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		local bonus_cost = self:GetSpecialValueFor("extra_mana_cost")*0.01
		if self:GetRuneType()==1 then
			bonus_cost = bonus_cost * (100-self:GetSpecialValueFor("rune_1_cost_reduce"))*0.01
		end
		cost = cost * (1+bonus_cost)
	end
	return cost
end


function chaotic_feeblemind:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_feeblemind_cast")  

	local duration = self:GetSpecialValueFor("duration")
	
	self:ApplyModifier(target, duration)
	if self:GetAutoCastState() then
		local count = self:GetSpecialValueFor("count")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(enemies) do
			if unit~=target then
				count = count - 1
				self:ApplyModifier(unit, duration)
				if count<=0 then
					break
				end
			end
		end
	end



	
end

function chaotic_feeblemind:ApplyModifier(target, duration)


	local iPtclID = ParticleManager:CreateParticle('particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_target/effect.vpcf', PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt( iPtclID, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlForward(iPtclID,0,target:GetForwardVector())
	-- ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
	ParticleManager:ReleaseParticleIndex(iPtclID)



	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*caster:HDGetPrimaryStatValue()
	-- print("damage=",damage)
	if target:HasModifier("modifier_chaotic_feeblemind") or self:GetRuneType()==3 then
		damage = damage * (1+self:GetSpecialValueFor("bonus_spell_damage")*0.01)
		if self:GetRuneType()==3 then
			-- print("damage=",damage)
			damage = damage + self:GetSpecialValueFor("rune_3_bonus")*0.01*caster:GetMana()
			-- print("damage=",damage)
		end
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
	}
	ApplyDamage(damageTable)
	if IsValid(target) and target:IsAlive() then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.3)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_chaotic_feeblemind", {duration = duration*StatusResistance})
	end


	if self:GetRuneType()==2 then
		local duration = self:GetSpecialValueFor("rune_2_duration")
		local modifier = caster:FindModifierByName("modifier_chaotic_feeblemind_rune_2_buff")
		if modifier then
			local rune_2_stack = self:GetSpecialValueFor("rune_2_stack")
			duration = duration-math.floor(modifier:GetStackCount()/rune_2_stack)
		end
		if duration>0 then
			local stack = self:GetSpecialValueFor("rune_2_bonus")
			caster:AddNewModifier(
			caster,
			self,
			"modifier_chaotic_feeblemind_rune_2_buff",
			{	duration = duration,stack_time = duration,stack=stack}  
    	)
		end
		
	end
	if self:GetRuneType()==3 then
		local duration = self:GetSpecialValueFor("rune_3_duration")
		local stack = self:GetSpecialValueFor("rune_3_reduction")
		caster:AddNewModifier(
			caster,
			self,
			"modifier_chaotic_feeblemind_rune_3_debuff",
			{	duration = duration,stack_time = duration,stack=stack}  
		)
	end


end




modifier_chaotic_feeblemind = modifier_chaotic_feeblemind or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_feeblemind:IsHidden()	return false end
function modifier_chaotic_feeblemind:IsDebuff()	return true end
function modifier_chaotic_feeblemind:IsStunDebuff()	return true end
function modifier_chaotic_feeblemind:IsPurgable()	return true end
function modifier_chaotic_feeblemind:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_feeblemind:OnCreated( kv )
	

	if not IsServer() then return end
	self:PlayEffects()
end


function modifier_chaotic_feeblemind:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end


function modifier_chaotic_feeblemind:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_debuff/effect.vpcf"
	-- self:GetParent():EmitSound("chaotic_feeblemind_target")
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	
	-- ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin()+Vector(0,0,64) )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "" ,Vector(0,0,0), true )
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end







modifier_chaotic_feeblemind_rune_2_buff = advanced_modifier({})

function modifier_chaotic_feeblemind_rune_2_buff:IsHidden()	return false end
function modifier_chaotic_feeblemind_rune_2_buff:IsDebuff()	return false end
function modifier_chaotic_feeblemind_rune_2_buff:IsPurgable()	return false end
function modifier_chaotic_feeblemind_rune_2_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		

	}

	return funcs
end

function modifier_chaotic_feeblemind_rune_2_buff:Advanced_GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_chaotic_feeblemind_rune_2_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { 
			dieTime = self:GetDieTime(),
			stack = keys.stack,
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_chaotic_feeblemind_rune_2_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		table.insert(self.tData, {
			dieTime = dieTime,
			stack = keys.stack,
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

function modifier_chaotic_feeblemind_rune_2_buff:OnIntervalThink()
	if IsServer() then

		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				-- self:DecrementStackCount()
			end
		end
	end
end




function modifier_chaotic_feeblemind_rune_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_chaotic_feeblemind_rune_2_buff:OnTooltip()
	return self:Advanced_GetModifierBonusStats_Intellect()
end















modifier_chaotic_feeblemind_rune_3_debuff = advanced_modifier({})

function modifier_chaotic_feeblemind_rune_3_debuff:IsHidden()	return false end
function modifier_chaotic_feeblemind_rune_3_debuff:IsDebuff()	return false end
function modifier_chaotic_feeblemind_rune_3_debuff:IsPurgable()	return false end
function modifier_chaotic_feeblemind_rune_3_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		

	}

	return funcs
end

function modifier_chaotic_feeblemind_rune_3_debuff:Advanced_GetModifierBonusStats_Intellect()	return -self:GetStackCount() end
function modifier_chaotic_feeblemind_rune_3_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { 
			dieTime = self:GetDieTime(),
			stack = keys.stack,
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_chaotic_feeblemind_rune_3_debuff:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		table.insert(self.tData, {
			dieTime = dieTime,
			stack = keys.stack,
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

function modifier_chaotic_feeblemind_rune_3_debuff:OnIntervalThink()
	if IsServer() then

		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				-- self:DecrementStackCount()
			end
		end
	end
end




function modifier_chaotic_feeblemind_rune_3_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_chaotic_feeblemind_rune_3_debuff:OnTooltip()
	return self:Advanced_GetModifierBonusStats_Intellect()
end

