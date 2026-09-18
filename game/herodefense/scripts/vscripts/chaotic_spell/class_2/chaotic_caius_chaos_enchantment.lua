LinkLuaModifier("modifier_chaotic_caius_chaos_enchantment", "chaotic_spell/class_2/chaotic_caius_chaos_enchantment", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_caius_chaos_enchantment_bonus_damage", "chaotic_spell/class_2/chaotic_caius_chaos_enchantment", LUA_MODIFIER_MOTION_NONE)

chaotic_caius_chaos_enchantment = chaotic_caius_chaos_enchantment or class({})

function chaotic_caius_chaos_enchantment:GetIntrinsicModifierName()return "modifier_chaotic_caius_chaos_enchantment" end

function chaotic_caius_chaos_enchantment:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_caius_chaos_enchantment/chaotic_caius_chaos_enchantment_2buff.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_caius_chaos_enchantment/chaotic_caius_chaos_enchantmentbuff.vpcf", context )
end

modifier_chaotic_caius_chaos_enchantment = advanced_modifier({})

function modifier_chaotic_caius_chaos_enchantment:IsPurgable() 		return false end
function modifier_chaotic_caius_chaos_enchantment:IsPurgeException() 	return false end
function modifier_chaotic_caius_chaos_enchantment:IsHidden() return true end

function modifier_chaotic_caius_chaos_enchantment:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.time_require = self.ability:GetSpecialValueFor("time_require")
	self.bonus_magical_damage = self.ability:GetSpecialValueFor("bonus_magical_damage")
	self.bonus_physcial_damage = self.ability:GetSpecialValueFor("bonus_physcial_damage")
end

function modifier_chaotic_caius_chaos_enchantment:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
	}
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE)
	end
	return funcs
end

function modifier_chaotic_caius_chaos_enchantment:DeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT)
	end
	return funcs
end

function modifier_chaotic_caius_chaos_enchantment:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("rune_2_attack_speed")
end

function modifier_chaotic_caius_chaos_enchantment:AdvancedGetModifierExtraHealthPercentage()
	return -self:GetAbility():GetSpecialValueFor("rune_2_hp_down")
end

function modifier_chaotic_caius_chaos_enchantment:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if keys.attacker ~= self.parent then
		return
	end
	if self.parent:PassivesDisabled() then
		return
	end
	if self:GetAbility():GetRuneType()==1 then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_caius_chaos_enchantment_bonus_damage", {duration = self.time_require , bonus_magical_damage = self.bonus_magical_damage})
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_caius_chaos_enchantment_bonus_damage", {duration = self.time_require , bonus_physcial_damage = self.bonus_physcial_damage})
		return
	end
	if self:GetAbility():GetRuneType()==3 and keys.damage_type==DAMAGE_TYPE_PURE then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_caius_chaos_enchantment_bonus_damage", {duration = self.time_require , bonus_magical_damage = self.bonus_magical_damage})
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_caius_chaos_enchantment_bonus_damage", {duration = self.time_require , bonus_physcial_damage = self.bonus_physcial_damage})
		return
	end
	if keys.damage_type==DAMAGE_TYPE_MAGICAL then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_caius_chaos_enchantment_bonus_damage", {duration = self.time_require , bonus_magical_damage = self.bonus_magical_damage})
	end
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_chaotic_caius_chaos_enchantment_bonus_damage", {duration = self.time_require , bonus_physcial_damage = self.bonus_physcial_damage})
	end
	
end


modifier_chaotic_caius_chaos_enchantment_bonus_damage = modifier_chaotic_caius_chaos_enchantment_bonus_damage or advanced_modifier({})


function modifier_chaotic_caius_chaos_enchantment_bonus_damage:IsHidden() return false end
function modifier_chaotic_caius_chaos_enchantment_bonus_damage:IsDebuff()return false end
function modifier_chaotic_caius_chaos_enchantment_bonus_damage:IsPurgable()return false end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.magic_time = -1
	self.physics_time = -1
	self.bonus_magical_damage_max = self.ability:GetSpecialValueFor("bonus_magical_damage_max")
	self.bonus_physcial_damage_max = self.ability:GetSpecialValueFor("bonus_physcial_damage_max")
	self.bonus_magical_damage_record = keys.bonus_magical_damage or 0
	self.bonus_physcial_damage_record = keys.bonus_physcial_damage or 0

	if keys.bonus_magical_damage then

		self.magic_time = self:GetDieTime()

		self.particle_magic = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_caius_chaos_enchantment/chaotic_caius_chaos_enchantment_2buff.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt( self.particle_magic, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,self.parent:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle_magic, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,self.parent:GetOrigin(), true )
		self:AddParticle(self.particle_magic, false, false, -1, false, false)

	end

	if keys.bonus_physcial_damage then

		self.physics_time = self:GetDieTime()

		self.particle_physics = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_caius_chaos_enchantment/chaotic_caius_chaos_enchantmentbuff.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt( self.particle_physics, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,self.parent:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle_physics, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,self.parent:GetOrigin(), true )
		self:AddParticle(self.particle_physics, false, false, -1, false, false)

	end
	self.bonus_all_damage = 0
	self:SetHasCustomTransmitterData( true )
	self:StartIntervalThink(0.1)
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:OnRefresh(keys)
	if not IsServer() then
		return
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if keys.bonus_magical_damage then
		self.magic_time = self:GetDieTime()
		if not self.particle_magic then
			self.particle_magic = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_caius_chaos_enchantment/chaotic_caius_chaos_enchantment_2buff.vpcf", PATTACH_POINT_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt( self.particle_magic, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1"  ,self.parent:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.particle_magic, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1"  ,self.parent:GetOrigin(), true )
			self:AddParticle(self.particle_magic, false, false, -1, false, false)	
		end
		self.bonus_magical_damage_record = math.min(self.bonus_magical_damage_record+keys.bonus_magical_damage,self.bonus_magical_damage_max)
	end

	if keys.bonus_physcial_damage then
		self.physics_time = self:GetDieTime()
		if not self.particle_physics then
			self.particle_physics = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_caius_chaos_enchantment/chaotic_caius_chaos_enchantmentbuff.vpcf", PATTACH_POINT_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt( self.particle_physics, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,self.parent:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.particle_physics, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,self.parent:GetOrigin(), true )
			self:AddParticle(self.particle_physics, false, false, -1, false, false)
		end
		self.bonus_physcial_damage_record = math.min(self.bonus_physcial_damage_record+keys.bonus_physcial_damage,self.bonus_physcial_damage_max)
	end



	if self.bonus_magical_damage_record >= self.bonus_magical_damage_max and self.bonus_physcial_damage_record >= self.bonus_physcial_damage_max then
		local bonus_all_damage = self.ability:GetSpecialValueFor("bonus_all_damage")
		if self:GetAbility():GetRuneType()==1 then
			bonus_all_damage = bonus_all_damage * (1-self:GetAbility():GetSpecialValueFor("rune_1_index")*0.01)
		end
		self.bonus_all_damage = bonus_all_damage
	end

end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		if self.magic_time~=-1 and fGameTime >= self.magic_time then
			self.magic_time = -1
			self.bonus_magical_damage_record = 0
			self.bonus_all_damage = 0
			if self.particle_magic then
				ParticleManager:DestroyParticle(self.particle_magic, true)
			end
			self:SendBuffRefreshToClients()
		end

		if self.physics_time~=-1 and fGameTime >= self.physics_time then
			self.physics_time = -1
			self.bonus_physcial_damage_record = 0
			self.bonus_all_damage = 0
			if self.particle_physics then
				ParticleManager:DestroyParticle(self.particle_physics, true)
			end
			self:SendBuffRefreshToClients()
		end
	end
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:ADDeclareFunctions()
    
    return{
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
    
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:AddCustomTransmitterData()
	return
	{
		bonus_magical_damage_record = self.bonus_magical_damage_record,
		bonus_physcial_damage_record = self.bonus_physcial_damage_record,
		bonus_all_damage = self.bonus_all_damage,
	}
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:HandleCustomTransmitterData(data)
	self.bonus_magical_damage_record = data.bonus_magical_damage_record
	self.bonus_physcial_damage_record = data.bonus_physcial_damage_record
	self.bonus_all_damage = data.bonus_all_damage
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_magical_damage_record
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then
			return 0
		end
		return self.bonus_physcial_damage_record
	end
	return 0
end


function modifier_chaotic_caius_chaos_enchantment_bonus_damage:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.bonus_all_damage
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_caius_chaos_enchantment_bonus_damage:OnTooltip() 
    self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.bonus_magical_damage_record
    end
    if self._tooltip == 2 then
        return self.bonus_physcial_damage_record
    end
	if self._tooltip == 3 then
        return self.bonus_all_damage
    end
end




