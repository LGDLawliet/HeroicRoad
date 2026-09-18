
chaotic_soul_transfer = class({})
LinkLuaModifier("modifier_chaotic_soul_transfer", "chaotic_spell/class_3/chaotic_soul_transfer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_soul_transfer_buff", "chaotic_spell/class_3/chaotic_soul_transfer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_soul_transfer_rune_2_buff", "chaotic_spell/class_3/chaotic_soul_transfer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_soul_transfer_rune_3_debuff", "chaotic_spell/class_3/chaotic_soul_transfer", LUA_MODIFIER_MOTION_NONE)

function chaotic_soul_transfer:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_target/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_debuff/effect.vpcf", context )

end

function chaotic_soul_transfer:GetIntrinsicModifierName(  )
	return "modifier_chaotic_soul_transfer"
end
function chaotic_soul_transfer:GetCustomCastErrorTarget(target)
	return "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
end

function chaotic_soul_transfer:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
				return UF_FAIL_CUSTOM
			end
		end
		return UF_SUCCESS
	end
end
function chaotic_soul_transfer:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	caster:EmitSound("chaotic_feeblemind_cast")  
	local duration = self:GetSpecialValueFor("duration")
	self:ApplyModifier(target, duration)
end

function chaotic_soul_transfer:ApplyModifier(target, duration)
	if not IsServer() then
		return
	end
	self.crit = false
	self.auto = false
	self.mp = self:GetSpecialValueFor("mp")*0.01*target:GetMaxMana()

	local iPtclID = ParticleManager:CreateParticle('particles/rebuild/chaotic_spell/chaotic_feeblemind/effect_target/effect.vpcf', PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt( iPtclID, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlForward(iPtclID,0,target:GetForwardVector())
	-- ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
	ParticleManager:ReleaseParticleIndex(iPtclID)

	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "damage_pct" )*0.01 * target:GetMaxHealth()
	local chance = self:GetSpecialValueFor("chance")

	local modifier = self:GetCaster():FindModifierByName("modifier_chaotic_soul_transfer")
	if modifier then
		if modifier:GetStackCount() >= 1 and self:GetAutoCastState() then
			chance = 100
			modifier:SetStackCount(modifier:GetStackCount()-1)
			self.auto = true
		end
	end

	local random = math.random
	if chance >= random(1,100) then
		self.crit = true
	end
	if self.crit == true then
		damage = damage*2
		self.mp = self.mp*2
	end
	if self.auto == true then
		damage = 0
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION,
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT,
	}

	if self:GetRuneType()==3 then
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_REFLECTION
	end
	ApplyDamage(damageTable)

	local gain = caster:GetModifierDurationGainIndex(0.8)
	if IsValid(target) then
		
	 	if target:IsAlive() then
			target:AddNewModifier(caster, self, "modifier_chaotic_soul_transfer_buff", {duration = duration*gain})
			target:GiveMana(self.mp)

			if not self:GetRuneType()==3 then
				if self.crit == true then
					target:AddNewModifier(caster, self, "modifier_chaotic_soul_transfer_buff", {duration = duration*gain})
				end
			else
				local random = math.random
				if self.crit == true then
					if self:GetSpecialValueFor("rune_3_chance") >= random(1,100) then
						target:AddNewModifier(caster, self, "modifier_chaotic_soul_transfer_buff", {duration = duration*gain})
					end
				end
			end
		else
			self:EndCooldown()

			local modifier = caster:FindModifierByName("modifier_chaotic_soul_transfer")
			if modifier then
				
				if self:GetRuneType()==1 then
					modifier:SetStackCount(modifier:GetStackCount() + self:GetSpecialValueFor("rune_1_count"))
				else
					modifier:SetStackCount(modifier:GetStackCount() + 1)
				end
			end

			if self:GetRuneType()==2 and self.crit == true then
				caster:AddNewModifier(caster, self, "modifier_chaotic_soul_transfer_buff", {duration = duration*gain})
				caster:AddNewModifier(caster, self, "modifier_chaotic_soul_transfer_buff", {duration = duration*gain})
			end
		end
	end
end
----------------------------------------------

modifier_chaotic_soul_transfer =advanced_modifier({})

function modifier_chaotic_soul_transfer:IsHidden()	return false end
function modifier_chaotic_soul_transfer:IsDebuff()	return false end
function modifier_chaotic_soul_transfer:IsStunDebuff()	return false end
function modifier_chaotic_soul_transfer:IsPurgable()	return false end
function modifier_chaotic_soul_transfer:RemoveOnDeath()	return false end

----------------------------------------------

modifier_chaotic_soul_transfer_buff =advanced_modifier({})

function modifier_chaotic_soul_transfer_buff:IsHidden()	return false end
function modifier_chaotic_soul_transfer_buff:IsDebuff()	return true end
function modifier_chaotic_soul_transfer_buff:IsStunDebuff()	return false end
function modifier_chaotic_soul_transfer_buff:IsPurgable()	return false end
function modifier_chaotic_soul_transfer_buff:RemoveOnDeath()	return false end
function modifier_chaotic_soul_transfer_buff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_soul_transfer_buff:OnCreated( kv )
	if not IsServer() then return end
	self.atb_lvl = self:GetAbility():GetSpecialValueFor("atb_lvl")
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
	self.atb = self.atb_lvl*self:GetCaster():GetLevel()
end

function modifier_chaotic_soul_transfer_buff:OnRefresh( kv )
	if not IsServer() then return end
	self.atb_lvl = self:GetAbility():GetSpecialValueFor("atb_lvl")
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
	self.atb = self.atb_lvl*self:GetCaster():GetLevel()
end

function modifier_chaotic_soul_transfer_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_chaotic_soul_transfer_buff:Advanced_GetModifierBonusStats_Strength()
	return self.atb
end
function modifier_chaotic_soul_transfer_buff:Advanced_GetModifierBonusStats_Agility()
	return self.atb
end
function modifier_chaotic_soul_transfer_buff:Advanced_GetModifierBonusStats_Intellect()
	return self.atb
end
function modifier_chaotic_soul_transfer_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("outgoing")
end


---------------------------------------------------------------------------------------------
modifier_chaotic_soul_transfer_rune_2_buff = advanced_modifier({})

function modifier_chaotic_soul_transfer_rune_2_buff:IsHidden()	return false end
function modifier_chaotic_soul_transfer_rune_2_buff:IsDebuff()	return false end
function modifier_chaotic_soul_transfer_rune_2_buff:IsPurgable()	return false end
function modifier_chaotic_soul_transfer_rune_2_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		

	}

	return funcs
end

function modifier_chaotic_soul_transfer_rune_2_buff:Advanced_GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_chaotic_soul_transfer_rune_2_buff:OnCreated(keys)
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
function modifier_chaotic_soul_transfer_rune_2_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		table.insert(self.tData, {
			dieTime = dieTime,
			stack = keys.stack,
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

function modifier_chaotic_soul_transfer_rune_2_buff:OnIntervalThink()
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




function modifier_chaotic_soul_transfer_rune_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_chaotic_soul_transfer_rune_2_buff:OnTooltip()
	return self:Advanced_GetModifierBonusStats_Intellect()
end















modifier_chaotic_soul_transfer_rune_3_debuff = advanced_modifier({})

function modifier_chaotic_soul_transfer_rune_3_debuff:IsHidden()	return false end
function modifier_chaotic_soul_transfer_rune_3_debuff:IsDebuff()	return false end
function modifier_chaotic_soul_transfer_rune_3_debuff:IsPurgable()	return false end
function modifier_chaotic_soul_transfer_rune_3_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		

	}

	return funcs
end

function modifier_chaotic_soul_transfer_rune_3_debuff:Advanced_GetModifierBonusStats_Intellect()	return -self:GetStackCount() end
function modifier_chaotic_soul_transfer_rune_3_debuff:OnCreated(keys)
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
function modifier_chaotic_soul_transfer_rune_3_debuff:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		table.insert(self.tData, {
			dieTime = dieTime,
			stack = keys.stack,
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

function modifier_chaotic_soul_transfer_rune_3_debuff:OnIntervalThink()
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




function modifier_chaotic_soul_transfer_rune_3_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function modifier_chaotic_soul_transfer_rune_3_debuff:OnTooltip()
	return self:Advanced_GetModifierBonusStats_Intellect()
end

