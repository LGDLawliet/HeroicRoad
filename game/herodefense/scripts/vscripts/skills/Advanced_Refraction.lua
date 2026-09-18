--特效优化 √
Advanced_Refraction = Advanced_Refraction or class({})
LinkLuaModifier( "modifier_Advanced_Refraction_buff_block", "skills/Advanced_Refraction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Refraction_buff_attribute", "skills/Advanced_Refraction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Refraction_buff_damage", "skills/Advanced_Refraction", LUA_MODIFIER_MOTION_NONE )

function Advanced_Refraction:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_loadout.vpcf", context )

end

function Advanced_Refraction:CheckKV(key)
	local table = {
		instances = 0.4,
		bonus_attribute = 0.8,

	}
	local value = table[key] or -1
	return value

end
function Advanced_Refraction:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_rage_unlock1",{})
	return true
end
function Advanced_Refraction:UnlockSecondCore(key)
	-- self.count = 100
	return true
end
function Advanced_Refraction:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_reincarnation_unlock3",{})
	return true
end




function Advanced_Refraction:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	if self:GetUnlock(2)==2 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end
function Advanced_Refraction:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local modifier1 =  caster:AddNewModifier(caster,self,"modifier_Advanced_Refraction_buff_block",{	duration = duration})
	if not self.unlock3 then
		local modifier2 =  caster:AddNewModifier(caster,self,"modifier_Advanced_Refraction_buff_attribute",{	duration = duration})
		if modifier1 and modifier2 then
			modifier1.agi_bonus_modifier = modifier2
		end
	end
	
	caster:EmitSound("Hero_TemplarAssassin.Refraction")
	caster:StartGesture(ACT_DOTA_CAST_REFRACTION)
end

function Advanced_Refraction:PlayEffects()
	if self.effect_cast then
		return
	end
	local caster = self:GetCaster()
	
	local particle_cast = "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf"
	local effect = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effect,0,caster,PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect,1,caster,PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect,5,caster,PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true )
	
	self.effect_cast = effect
end
function Advanced_Refraction:DestroySpellParticle(type)
	local caster = self:GetCaster()
	if type==1 then
		if caster:HasModifier("modifier_Advanced_Refraction_buff_attribute") then
			return
		end
	else
		if caster:HasModifier("modifier_Advanced_Refraction_buff_block") then
			return
		end
	end
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast,false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end

end



modifier_Advanced_Refraction_buff_block =modifier_Advanced_Refraction_buff_block or advanced_modifier({})
function modifier_Advanced_Refraction_buff_block:IsHidden()	return false end
function modifier_Advanced_Refraction_buff_block:IsDebuff()	return false end
function modifier_Advanced_Refraction_buff_block:IsPurgable()	return true end
function modifier_Advanced_Refraction_buff_block:OnCreated( kv )


	if not IsServer() then return end
	local ability = self:GetAbility()
	self.stack = ability:GetSpecialValueFor( "instances" )
	local interval = 1.5
	if ability.unlock3 then
		self.unlock3 = true
		interval = 0.4
		self.stack = self.stack +50
	end
	self:SetStackCount( self.stack )
	ability:PlayEffects()
	self:StartIntervalThink(interval)

	if ability.advanced_level>=10 then
		self.lv10 = true
		if  ability.advanced_level>=15 then
			self.lv15 = true
			if  ability.advanced_level>=20 then
				self.lv20 = true
			end
		end
	end
end

function modifier_Advanced_Refraction_buff_block:OnRefresh( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()
	self.stack = ability:GetSpecialValueFor( "instances" )
	if ability.unlock3 then
		self.unlock3 = true
		self.stack = self.stack +50
	end
	self:SetStackCount( self.stack )
	if ability.advanced_level>=10 then
		self.lv10 = true
		if  ability.advanced_level>=15 then
			self.lv15 = true
			if  ability.advanced_level>=20 then
				self.lv20 = true
			end
		end
	end
end
function modifier_Advanced_Refraction_buff_block:OnDestroy( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()
	if ability then
		ability:DestroySpellParticle(1)
	end
	-- self:GetAbility():DestroySpellParticle(1)

end
function modifier_Advanced_Refraction_buff_block:OnIntervalThink()
	self:SetStackCount(math.min(self:GetStackCount()+1,self.stack))
end


function modifier_Advanced_Refraction_buff_block:DeclareFunctions()
	local funcs = {

	}
	if self:GetAbility().unlock1 then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end

	return funcs
end

function modifier_Advanced_Refraction_buff_block:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			if self:GetCaster():GetRandomEffect(18,INT_TYPE,1)  > RandomInt(1, 100) then
				if not keys.attacker:IsApplyModifier()  then
					return
				end
				self:IncrementStackCount()
			end
		end
	end
end




function modifier_Advanced_Refraction_buff_block:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end


function modifier_Advanced_Refraction_buff_block:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled and not self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
        return 0 
    end
	if keys.damage<=20 then
		return 0
	end
	local parent = self:GetParent()


	local stack = self:GetStackCount()
	local ability = self:GetAbility()

	if ability:GetAutoCastState() and stack<=0 then
		if ability:GetCooldownTimeRemaining()>=30 then
			return 0 
		end
		ability:StartCooldown(ability:GetCooldownTimeRemaining()+0.2)
		stack = 1
	end
	if stack>=1 then

		local health = parent:GetMaxHealth()
		if keys.damage>=health*0.05 then
			if self.agi_bonus_modifier and not self.agi_bonus_modifier:IsNull() then
				self.agi_bonus_modifier:IncrementStackCount()
			end
		end
		self:DecrementStackCount()
		if self.lv20 and not self.unlock3 then
			parent:AddNewModifier(parent,ability,"modifier_Advanced_Refraction_buff_damage",{	duration = 25*parent:GetModifierDurationGainIndex(1)})
		end
		if not self.unlock3 then
			if self.lv15 then
				if keys.damage>=health*2 and not self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
					return keys.damage *0.7
				end
			else
				if keys.damage>=health*0.5 and not self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
					return keys.damage *0.7
				end
			end
		end
		
		
		return keys.damage
	else
		if self.lv10 then
			return 0
		end
		self:SafeDestroy()
		return 0
	end

end



modifier_Advanced_Refraction_buff_attribute =modifier_Advanced_Refraction_buff_attribute or class({})
function modifier_Advanced_Refraction_buff_attribute:IsHidden()	return false end
function modifier_Advanced_Refraction_buff_attribute:IsDebuff()	return false end
function modifier_Advanced_Refraction_buff_attribute:IsPurgable()	return true end
function modifier_Advanced_Refraction_buff_attribute:OnCreated( kv )
	local ability = self:GetAbility()
	if IsServer() then
		self.bonus_attribute = self:GetAbility():GetSpecialValueFor("bonus_attribute")
		if self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
			self.bonus_attribute = 2*self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
	
		self.max_bonus_index = 1
		if ability:GetSpecialValueFor("advanced_level")>=5 then
			self.max_bonus_index = 1.5
		end
	end
end
function modifier_Advanced_Refraction_buff_attribute:OnRefresh( kv )
	if IsServer() then
		local ability = self:GetAbility()
		self.bonus_attribute =ability:GetSpecialValueFor("bonus_attribute")
		if self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
			self.bonus_attribute = 2*self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
		self.max_bonus_index = 1
		if ability:GetSpecialValueFor("advanced_level")>=5 then
			self.max_bonus_index = 1.5
		end
	
		if ability.advanced_level>=20 then
			return
		end
		self:SetStackCount(0)
	end
end

function modifier_Advanced_Refraction_buff_attribute:OnDestroy( kv )
	if not IsServer() then return end
	self:GetAbility():DestroySpellParticle(2)

end

function modifier_Advanced_Refraction_buff_attribute:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_TOOLTIP
	}
	if IsServer()  then
		local attribute = self:GetParent():GetPrimaryAttribute()
		if attribute==DOTA_ATTRIBUTE_STRENGTH  then
			table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
		elseif attribute==DOTA_ATTRIBUTE_AGILITY  then
			table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS )
		else
			table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS  )
		end
	end
	return funcs
end


function modifier_Advanced_Refraction_buff_attribute:OnTooltip()	
	local bonus_index = 1+math.min(self:GetStackCount()*0.04,self.max_bonus_index)
	return self.bonus_attribute *bonus_index
end
function modifier_Advanced_Refraction_buff_attribute:GetModifierBonusStats_Strength()	
	local bonus_index = 1+math.min(self:GetStackCount()*0.04,self.max_bonus_index)
	return self.bonus_attribute *bonus_index
end
function modifier_Advanced_Refraction_buff_attribute:GetModifierBonusStats_Agility()	
	local bonus_index = 1+math.min(self:GetStackCount()*0.04,self.max_bonus_index)
	return self.bonus_attribute *bonus_index
end
function modifier_Advanced_Refraction_buff_attribute:GetModifierBonusStats_Intellect()	
	local bonus_index = 1+math.min(self:GetStackCount()*0.04,self.max_bonus_index)
	return self.bonus_attribute *bonus_index
end













modifier_Advanced_Refraction_buff_damage = modifier_Advanced_Refraction_buff_damage or class({})

function modifier_Advanced_Refraction_buff_damage:IsHidden()	return false end
function modifier_Advanced_Refraction_buff_damage:IsDebuff()	return false end
function modifier_Advanced_Refraction_buff_damage:IsPurgable()	return false end
function modifier_Advanced_Refraction_buff_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_Advanced_Refraction_buff_damage:GetModifierPreAttack_BonusDamage()	return math.min(self:GetStackCount()*self.bonus_per_stack,self.max) end






function modifier_Advanced_Refraction_buff_damage:OnCreated(params)
	self.ability = self:GetAbility()
	self.max = 1000
	self.bonus_per_stack = 15
	if self.ability:GetUnlock()==1 then
		self.unlock1 = true
		self.max = 3000
		self.bonus_per_stack = 25
	end
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		self:PlayEffect()
	end
end
function modifier_Advanced_Refraction_buff_damage:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 150 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
			self:PlayEffect()
		end
	end
end

function modifier_Advanced_Refraction_buff_damage:PlayEffect()
	local unit = self:GetParent()
	local particle_death_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_loadout.vpcf", PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleControl(particle_death_fx, 0, unit:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_death_fx)
end

function modifier_Advanced_Refraction_buff_damage:OnIntervalThink()
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


