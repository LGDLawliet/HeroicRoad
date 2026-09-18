
Primary_Luminosity = class({})

LinkLuaModifier( "modifier_Primary_Luminosity", "skills/Primary_Luminosity", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Luminosity_buff", "skills/Primary_Luminosity", LUA_MODIFIER_MOTION_NONE )

function Primary_Luminosity:GetIntrinsicModifierName()
	return "modifier_Primary_Luminosity"
end

--------------------------------------------------------------------------------
modifier_Primary_Luminosity = advanced_modifier({})

function modifier_Primary_Luminosity:IsHidden()
	return self:GetStackCount()<1
end
function modifier_Primary_Luminosity:IsDebuff()return false end
function modifier_Primary_Luminosity:IsPurgable()return false end

function modifier_Primary_Luminosity:OnCreated( kv )
	if not IsServer() then
		return 
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.crit_line = self:GetAbility():GetSpecialValueFor( "crit_line" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.crit_heal = self:GetAbility():GetSpecialValueFor( "crit_heal" )
end

function modifier_Primary_Luminosity:OnRefresh( kv )
	if not IsServer() then
		return 
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.crit_line = self:GetAbility():GetSpecialValueFor( "crit_line" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.crit_heal = self:GetAbility():GetSpecialValueFor( "crit_heal" )
end

function modifier_Primary_Luminosity:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_Primary_Luminosity:Advanced_GetModifierCriticalStrike(keys)
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

function modifier_Primary_Luminosity:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent then
		return
	end
	if self.damage_mul == 0 then
		return
	end
	EmitSoundOn( "Hero_Dawnbreaker.Luminosity.PowerUp", self.parent)
	EmitSoundOn( "Hero_Dawnbreaker.Luminosity.Strike", keys.target)
	--local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity_attack_buff.vpcf"
	--local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	--ParticleManager:SetParticleControlEnt(effect_cast,1,self.parent,PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)
	--ParticleManager:SetParticleControlEnt(effect_cast,2,self.parent,PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)		
	--self:AddParticle(effect_cast,false,false,-1,false,false)
	self.heal = keys.damage * self.crit_heal*0.01
	--print(keys.damage)
	local fhealing = HealWithGain(self.heal,self.parent,self.parent,self.ability) --返回治疗的数值
	SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,self.parent,fhealing,self.parent:GetPlayerOwner())
	self.parent:Purge(false, true, false, false, false) --弱驱散
end
