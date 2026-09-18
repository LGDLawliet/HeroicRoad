LinkLuaModifier("modifier_chaotic_gaias_prayer", "chaotic_spell/class_2/chaotic_gaias_prayer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_gaias_prayer_buff", "chaotic_spell/class_2/chaotic_gaias_prayer", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chaotic_gaias_prayer_mana_regen", "chaotic_spell/class_2/chaotic_gaias_prayer", LUA_MODIFIER_MOTION_NONE)


chaotic_gaias_prayer = chaotic_gaias_prayer or class({})
function chaotic_gaias_prayer:GetIntrinsicModifierName()return "modifier_chaotic_gaias_prayer" end

function chaotic_gaias_prayer:GetAOERadius()return self:GetSpecialValueFor("radius") end

function chaotic_gaias_prayer:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/ti10/agh_aura_03.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_gaias_prayer/chaotic_gaias_prayer_13.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_gaias_prayer/chaotic_gaias_prayer_23.vpcf", context )
end

modifier_chaotic_gaias_prayer = advanced_modifier({})

function modifier_chaotic_gaias_prayer:IsPurgable() 		return false end
function modifier_chaotic_gaias_prayer:IsPurgeException() 	return false end
function modifier_chaotic_gaias_prayer:IsHidden()return true end
function modifier_chaotic_gaias_prayer:RemoveOnDeath()  return false end
function modifier_chaotic_gaias_prayer:GetAuraEntityReject(target)
	return false
end

function modifier_chaotic_gaias_prayer:GetAuraRadius()return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_chaotic_gaias_prayer:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_gaias_prayer:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_chaotic_gaias_prayer:GetAuraSearchType()return DOTA_UNIT_TARGET_HERO  end
function modifier_chaotic_gaias_prayer:GetModifierAura()return "modifier_chaotic_gaias_prayer_buff" end

function modifier_chaotic_gaias_prayer:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

modifier_chaotic_gaias_prayer_buff = advanced_modifier({})

function modifier_chaotic_gaias_prayer_buff:IsPurgable() 		return false end
function modifier_chaotic_gaias_prayer_buff:IsPurgeException() 	return false end
function modifier_chaotic_gaias_prayer_buff:IsHidden()return false end
function modifier_chaotic_gaias_prayer_buff:RemoveOnDeath()  return false end

function modifier_chaotic_gaias_prayer_buff:OnCreated()

	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.time_require = self.ability:GetSpecialValueFor("time_require")
	
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
	self.health_regen = self.ability:GetSpecialValueFor("health_regen")
	self.additional_enhancement = self.ability:GetSpecialValueFor("additional_enhancement")*0.01+1

	self.timer_damage = GameRules:GetGameTime()
	self.timer_damage_taken = GameRules:GetGameTime()
	if IsServer() then
		self:StartIntervalThink(0.5)
		self:SetHasCustomTransmitterData( true )
	end

	


end
function modifier_chaotic_gaias_prayer_buff:OnIntervalThink()
	local parent = self:GetParent()
	if self:CheckHealthRegen() then
		if self:CheckManaRegen() then
			-- 双通道
			if not self.all_regen_particle then

				self.all_regen_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_gaias_prayer/chaotic_gaias_prayer_23.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControlEnt( self.all_regen_particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
				self:AddParticle(self.all_regen_particle, false, false, -1, false, false)
				
			end
			return
		else
			-- 单生命恢复
			if not self.health_regen_particle then

				self.health_regen_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_gaias_prayer/chaotic_gaias_prayer_13.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControlEnt( self.health_regen_particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
				self:AddParticle(self.health_regen_particle, false, false, -1, false, false)
				
			end
			return
		end
	else
		if self:CheckManaRegen() then
			-- 魔法恢复
			if not self.mana_regen_particle then

				self.mana_regen_particle = ParticleManager:CreateParticle("particles/econ/events/ti10/agh_aura_03.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControlEnt( self.mana_regen_particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
				self:AddParticle(self.mana_regen_particle, false, false, -1, false, false)
				
			end
			return

		end
	end
	if self.mana_regen_particle then
		ParticleManager:DestroyParticle(self.mana_regen_particle,true)
		self.mana_regen_particle = nil
	end
	if self.health_regen_particle then
		ParticleManager:DestroyParticle(self.health_regen_particle,true)
		self.health_regen_particle = nil
	end
	if self.all_regen_particle then
		ParticleManager:DestroyParticle(self.all_regen_particle,true)
		self.all_regen_particle = nil
	end

end

function modifier_chaotic_gaias_prayer_buff:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, nil},
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
	}

	return funcs
end

function modifier_chaotic_gaias_prayer_buff:OnTakeDamage(keys)
	if IsClient() then
		return
	end
	if keys.unit ~= self.parent and keys.attacker == self.parent then
		self.timer_damage = GameRules:GetGameTime()+self.time_require
		self:SendBuffRefreshToClients()
	end
	if keys.unit == self.parent and keys.attacker ~= self.parent then
		self.timer_damage_taken = GameRules:GetGameTime()+self.time_require
		self:SendBuffRefreshToClients()
	end
	
end

function modifier_chaotic_gaias_prayer_buff:AddCustomTransmitterData()
	return
	{
		timer_damage = self.timer_damage,
		timer_damage_taken = self.timer_damage_taken,
	}
end

function modifier_chaotic_gaias_prayer_buff:HandleCustomTransmitterData(data)
	self.timer_damage = data.timer_damage
	self.timer_damage_taken = data.timer_damage_taken
end

function modifier_chaotic_gaias_prayer_buff:CheckHealthRegen()
	if  GameRules:GetGameTime()>=self.timer_damage then
		return true
	end
end

function modifier_chaotic_gaias_prayer_buff:CheckManaRegen()
	if  GameRules:GetGameTime()>=self.timer_damage_taken then
		return true
	end
end


function modifier_chaotic_gaias_prayer_buff:AdvancedGetModifierConstantManaRegenAmpPercentage()
	if self:CheckManaRegen() then
		local regen = self.mana_regen
		if self:CheckHealthRegen() then
			regen = regen * self.additional_enhancement
		end
		return regen
	end
	return 0

end
function modifier_chaotic_gaias_prayer_buff:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	if self:CheckHealthRegen() then
		local regen = self.health_regen
		if self:CheckManaRegen() then
			regen = regen * self.additional_enhancement
		end
		return regen
	end
	return 0

end
function modifier_chaotic_gaias_prayer_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_gaias_prayer_buff:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 2 + 1

    if self._tooltip == 1 then
        return self:AdvancedGetModifierConstantManaRegenAmpPercentage()
    end

    if self._tooltip == 2 then
        return self:AdvancedGetModifierConstantHealthRegenAmpPercentage()
    end
    
end


