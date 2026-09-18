
Advanced_Luminosity = class({})

LinkLuaModifier( "modifier_Advanced_Luminosity", "skills/Advanced_Luminosity", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Luminosity_buff", "skills/Advanced_Luminosity", LUA_MODIFIER_MOTION_NONE )

function Advanced_Luminosity:GetIntrinsicModifierName()
	return "modifier_Advanced_Luminosity"
end

function Advanced_Luminosity:CheckKV(key)
	local table = {
		crit_mult = 7.2,
		crit_heal = 0.5,
	}
	local value = table[key] or -1
	return value
end
function Advanced_Luminosity:UnlockFirstCore(key)
	return false
end
function Advanced_Luminosity:UnlockSecondCore(key)
	return false
end
function Advanced_Luminosity:UnlockThirdCore(key)
	return false
end
--------------------------------------------------------------------------------
modifier_Advanced_Luminosity = advanced_modifier({})

function modifier_Advanced_Luminosity:IsHidden()return false end
function modifier_Advanced_Luminosity:IsDebuff()return false end
function modifier_Advanced_Luminosity:IsPurgable()return false end

function modifier_Advanced_Luminosity:OnCreated( kv )
	if not IsServer() then
		return 
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.crit_line = self:GetAbility():GetSpecialValueFor( "crit_line" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.crit_heal = self:GetAbility():GetSpecialValueFor( "crit_heal" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.full_attack = self:GetAbility():GetSpecialValueFor( "full_attack" )
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
end

function modifier_Advanced_Luminosity:OnRefresh( kv )
	if not IsServer() then
		return 
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.crit_line = self:GetAbility():GetSpecialValueFor( "crit_line" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.crit_heal = self:GetAbility():GetSpecialValueFor( "crit_heal" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.full_attack = self:GetAbility():GetSpecialValueFor( "full_attack" )
end

function modifier_Advanced_Luminosity:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_Advanced_Luminosity:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() then
		if keys.target:GetTeamNumber()==self.parent:GetTeamNumber() then
			return
		end
		if self:GetStackCount() >= self.crit_line then
			self.damage_mul = self.crit_mult
			self:SetStackCount(0)
		else
			self:SetStackCount(self:GetStackCount() + 1)
			self.damage_mul = 0
		end
		return self.damage_mul
	end
end

function modifier_Advanced_Luminosity:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent then
		return
	end
	if self.damage_mul == 0 then
		return
	end
	if not self.parent:IsRealHero() then
		return
	end
	if self.ability.advanced_level >= 15 then
		self.duration = 45
	end
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.crit_heal = self:GetAbility():GetSpecialValueFor( "crit_heal" )
	EmitSoundOn( "Hero_Dawnbreaker.Luminosity.PowerUp", self.parent)
	EmitSoundOn( "Hero_Dawnbreaker.Luminosity.Strike", keys.target)
	--local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity_attack_buff.vpcf"
	--local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	--ParticleManager:SetParticleControlEnt(effect_cast,1,self.parent,PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)
	--ParticleManager:SetParticleControlEnt(effect_cast,2,self.parent,PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)		
	--self:AddParticle(effect_cast,false,false,-1,false,false)
	if self.parent:GetHealthPercent() < 100 then
		self.heal = keys.damage * self.crit_heal*0.01
		local fhealing = HealWithGain(self.heal,self.parent,self.parent,self.ability) --返回治疗的数值
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,self.parent,fhealing,self.parent:GetPlayerOwner())
	else
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_Advanced_Luminosity_buff", {duration = self.duration})
	end
	keys.target:Purge(true, false, false, false, false) --敌人弱驱散
	--新LV20纯净武器+
	if self.ability.advanced_level >= 20 then
		local modifiers1 = self.parent:FindAllModifiers()
		self.parent:Purge(false, true, false, false, false) --弱驱散
		local modifiers = self.parent:FindAllModifiers()
		local stack = #modifiers1 - #modifiers --得出被驱散的正面状态数量
		if stack>0 then
			self:SetStackCount(math.min((self:GetStackCount()+2),self.crit_line))
		end
	else
		self.parent:Purge(false, true, false, false, false) --弱驱散
	end
	
	if self.ability.advanced_level >= 5 then
		local heroes = GetAllRealHeroes()
		for _, hero in pairs(heroes) do
			if hero~=self.parent then
				hero:Purge(false, true, false, false, false)--弱驱散
				break
			end
		end
	end

	if self.ability.advanced_level >= 10 then
		if keys.target:GetHealthPercent() <= 5 then
			TrueKill(keys.attacker , keys.target , self.ability)
		end
	end
end
---------------------
modifier_Advanced_Luminosity_buff = advanced_modifier({})

function modifier_Advanced_Luminosity_buff:IsHidden()	return false end
function modifier_Advanced_Luminosity_buff:IsDebuff()	return false end
function modifier_Advanced_Luminosity_buff:IsPurgable()	return false end
function modifier_Advanced_Luminosity_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.ability.advanced_level = self.ability:GetSpecialValueFor("advanced_level")
	self.full_attack = self:GetAbility():GetSpecialValueFor( "full_attack" )
	self.full_attack_max = self:GetAbility():GetSpecialValueFor( "full_attack_max" )
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Luminosity_buff:OnRefresh(keys)
	self.full_attack = self:GetAbility():GetSpecialValueFor( "full_attack" )
	self.full_attack_max = self:GetAbility():GetSpecialValueFor( "full_attack_max" )
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= (self.full_attack_max) then
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

function modifier_Advanced_Luminosity_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_Advanced_Luminosity_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_Luminosity_buff:OnTooltip()
    return math.min(self.full_attack*self:GetStackCount(),self.full_attack_max)
end

function modifier_Advanced_Luminosity_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_Advanced_Luminosity_buff:Advanced_GetModifierDamageOutgoing_Percentage()
    return math.min(self.full_attack*self:GetStackCount(),self.full_attack_max)
end
