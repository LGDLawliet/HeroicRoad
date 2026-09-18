LinkLuaModifier("modifier_chaotic_mass_healing_word_rune1_buff", "chaotic_spell/class_3/chaotic_mass_healing_word", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_mass_healing_word_rune2_buff", "chaotic_spell/class_3/chaotic_mass_healing_word", LUA_MODIFIER_MOTION_NONE)

chaotic_mass_healing_word = class({})
function chaotic_mass_healing_word:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_mass_healing_word/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_mass_healing_word/target/effect.vpcf", context )
end
function chaotic_mass_healing_word:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_mass_healing_word:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_mass_healing_word:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("chaotic_mass_healing_word_cast")  
	local pos = caster:GetOrigin()+Vector(0,0,64)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_mass_healing_word/cast_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,5)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local heal =  (self:GetSpecialValueFor("base_heal")+self:GetSpecialValueFor("bonus_heal") * caster:HDGetPrimaryStatValue())*self:GetEffectGain()
	local count = self:GetSpecialValueFor("count")

	if self:GetRuneType() == 3 then
		if not self.line then
			self.line = 1 
		else
			self.line = self.line + 1
			if self.line >= self:GetSpecialValueFor("rune_3_line") then
				self.line = nil
				heal = heal * (1+self:GetSpecialValueFor("rune_3_index")*0.01)
			end
		end
	end

	local rune_1_duration = self:GetSpecialValueFor("rune_1_duration")
	local rune_1_bonus = heal*self:GetSpecialValueFor("rune_1_bonus")*0.01

	for _, unit in ipairs(units) do
		if self:GetRuneType() == 2 and unit:GetHealthPercent() >= 100 then
			self:PlayEffect(unit)
			local rune_2_duration = self:GetSpecialValueFor("rune_2_duration")
			unit:AddNewModifier(caster, self, "modifier_chaotic_mass_healing_word_rune2_buff", {duration =rune_2_duration})
			count = count - 1
			if count<=0 then
				break
			end
		end


		if unit:GetHealthPercent()<100 then
			self:PlayEffect(unit)
			local fhealing =  HealWithGain(heal,caster,unit,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil) 
			count = count - 1
			if self:GetRuneType()==1 then
				unit:AddNewModifier(caster, self, "modifier_chaotic_mass_healing_word_rune1_buff", {duration =rune_1_duration,heal = rune_1_bonus})
			end
			if count<=0 then
				break
			end
		end
	end

	if count>0 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do

			if self:GetRuneType() == 2 and unit:GetHealthPercent() >= 100 then
				self:PlayEffect(unit)
				local rune_2_duration = self:GetSpecialValueFor("rune_2_duration")
				unit:AddNewModifier(caster, self, "modifier_chaotic_mass_healing_word_rune2_buff", {duration =rune_2_duration})
				count = count - 1
				if count<=0 then
					break
				end
			end


			if unit:GetHealthPercent()<100 then
				self:PlayEffect(unit)
				local fhealing =  HealWithGain(heal,caster,unit,self)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil) 
				count = count - 1
				if self:GetRuneType()==1 then
					unit:AddNewModifier(caster, self, "modifier_chaotic_mass_healing_word_rune1_buff", {duration =rune_1_duration,heal = rune_1_bonus})
				end
				if count<=0 then
					break
				end
			end
		end
	end





	
end


function chaotic_mass_healing_word:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_mass_healing_word/target/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_mass_healing_word_target")
end



modifier_chaotic_mass_healing_word_rune1_buff = advanced_modifier({})

function modifier_chaotic_mass_healing_word_rune1_buff:IsHidden() return false end
function modifier_chaotic_mass_healing_word_rune1_buff:IsPurgable() return false end
function modifier_chaotic_mass_healing_word_rune1_buff:IsDebuff() return false end

function modifier_chaotic_mass_healing_word_rune1_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.heal)
		self:StartIntervalThink(1)
	end
end


function modifier_chaotic_mass_healing_word_rune1_buff:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local fhealing =  HealWithGain(self:GetStackCount(),caster,parent,self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent, fhealing, nil) 
end

modifier_chaotic_mass_healing_word_rune2_buff = advanced_modifier({})

function modifier_chaotic_mass_healing_word_rune2_buff:IsHidden() return false end
function modifier_chaotic_mass_healing_word_rune2_buff:IsPurgable() return false end
function modifier_chaotic_mass_healing_word_rune2_buff:IsDebuff() return false end

function modifier_chaotic_mass_healing_word_rune2_buff:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.rune_2_outgoing = self:GetAbility():GetSpecialValueFor("rune_2_outgoing")
end

function modifier_chaotic_mass_healing_word_rune2_buff:OnRefresh(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.rune_2_outgoing = self:GetAbility():GetSpecialValueFor("rune_2_outgoing")
end

function modifier_chaotic_mass_healing_word_rune2_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end

function modifier_chaotic_mass_healing_word_rune2_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	if not self:GetAbility() then self:Destroy() return end
	return self.rune_2_outgoing
end