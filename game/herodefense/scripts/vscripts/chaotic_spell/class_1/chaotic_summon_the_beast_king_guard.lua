chaotic_summon_the_beast_king_guard = class({})

LinkLuaModifier("modifier_chaotic_summon_the_beast_king_guard_buff", "chaotic_spell/class_1/chaotic_summon_the_beast_king_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_the_beast_king_guard_debuff", "chaotic_spell/class_1/chaotic_summon_the_beast_king_guard", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_the_beast_king_guard:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf", context )
end


function chaotic_summon_the_beast_king_guard:IsSummonSpell()return true end

function chaotic_summon_the_beast_king_guard:OnSpellStart()

	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	
	local caster =self:GetCaster()
	
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local unit = caster:SummonUnit("npc_hd_Beast_King_Guard",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	-- ParticleManager:SetParticleControl(infest_particle, 1, unit_pos)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_Beastmaster.Call.Boar")

	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_the_beast_king_guard_buff", {})

end


modifier_chaotic_summon_the_beast_king_guard_buff = advanced_modifier({})

function modifier_chaotic_summon_the_beast_king_guard_buff:IsDebuff() return false end
function modifier_chaotic_summon_the_beast_king_guard_buff:IsHidden() return false end
function modifier_chaotic_summon_the_beast_king_guard_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_the_beast_king_guard_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_the_beast_king_guard_buff:RemoveOnDeath()  return false end

function modifier_chaotic_summon_the_beast_king_guard_buff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if IsServer() then
		if self:GetAbility():GetRuneType()==1 then
			self.rune_1_duration = self:GetAbility():GetSpecialValueFor("rune_1_duration")
		end


		self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
		self.crit_damage = self.ability:GetSpecialValueFor("crit_damage")-100
		self.crit_damage = (self.crit_damage * self:GetCaster():GetSummonIntensityIndex(1)*self:GetAbility():GetEffectGain())+100
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end

end

function modifier_chaotic_summon_the_beast_king_guard_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end


function modifier_chaotic_summon_the_beast_king_guard_buff:Advanced_GetModifierCriticalStrike(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	
	if self.crit_chance >= RandomInt(1,100) then
		if self.rune_1_duration then
			local ability = self:GetAbility()
			if ability then
				keys.target:AddNewModifier(self:GetCaster(), ability, "modifier_chaotic_summon_the_beast_king_guard_debuff", {duration = self.rune_1_duration})
			end
			
		end
	

		
		return self.crit_damage
	end
end

function modifier_chaotic_summon_the_beast_king_guard_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_the_beast_king_guard_buff:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.crit_chance
	end
	if self._tooltip == 2 then
		return self.crit_damage
	end	
end


function modifier_chaotic_summon_the_beast_king_guard_buff:AddCustomTransmitterData( )
	return
	{
		crit_chance = self.crit_chance,
		crit_damage = self.crit_damage,
	}
end

function modifier_chaotic_summon_the_beast_king_guard_buff:HandleCustomTransmitterData( data )
	self.crit_chance = data.crit_chance
	self.crit_damage = data.crit_damage
end





modifier_chaotic_summon_the_beast_king_guard_debuff = advanced_modifier({})

function modifier_chaotic_summon_the_beast_king_guard_debuff:IsDebuff() return true end
function modifier_chaotic_summon_the_beast_king_guard_debuff:IsHidden() return false end
function modifier_chaotic_summon_the_beast_king_guard_debuff:IsPurgable() 		return false end
function modifier_chaotic_summon_the_beast_king_guard_debuff:IsPurgeException() 	return false end
function modifier_chaotic_summon_the_beast_king_guard_debuff:RemoveOnDeath()  return false end

function modifier_chaotic_summon_the_beast_king_guard_debuff:OnCreated(keys)
	self.rune_1_bouns_damage = self:GetAbility():GetSpecialValueFor("rune_1_bouns_damage")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
	end
end
function modifier_chaotic_summon_the_beast_king_guard_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 40 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end
function modifier_chaotic_summon_the_beast_king_guard_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_chaotic_summon_the_beast_king_guard_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET,
    }
end


function modifier_chaotic_summon_the_beast_king_guard_debuff:Advanced_GetModifierCriticalStrikeDamageTarget(keys)
	return self.rune_1_bouns_damage * self:GetStackCount()
end


function modifier_chaotic_summon_the_beast_king_guard_debuff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_chaotic_summon_the_beast_king_guard_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierCriticalStrikeDamageTarget()
	end
end

-- advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET = "Advanced_GetModifierCriticalStrikeDamageTarget", 

