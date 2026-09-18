chaotic_overcharge = class({})

LinkLuaModifier("modifier_chaotic_overcharge_active", "chaotic_spell/class_9/chaotic_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_overcharge_active_ally", "chaotic_spell/class_9/chaotic_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_overcharge_active_rune1", "chaotic_spell/class_9/chaotic_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_overcharge_active_rune2", "chaotic_spell/class_9/chaotic_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_overcharge_active_rune3", "chaotic_spell/class_9/chaotic_overcharge", LUA_MODIFIER_MOTION_NONE)
function chaotic_overcharge:GetAOERadius()
    return 1000 + self:GetCaster():GetCastRangeBonus()
end
function chaotic_overcharge:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", context )

end
function chaotic_overcharge:OnSpellStart()
	
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(0.3)
	local duration = self:GetSpecialValueFor("duration")*gain
	local modifier = caster:FindModifierByName("modifier_chaotic_overcharge_active")
	local modifier2 = caster:FindModifierByName("modifier_chaotic_overcharge_active_ally")

	self.rune_1_duration = self:GetSpecialValueFor("rune_1_duration")*0.01*duration
	self.rune_2_duration = self:GetSpecialValueFor("rune_2_duration")*0.01*duration
	self.rune_3_duration = self:GetSpecialValueFor("rune_2_duration")*0.01*duration
	self.rune_1_max = self:GetSpecialValueFor("rune_1_max")+1
	self.rune_2_max = self:GetSpecialValueFor("rune_2_max")+1
	self.rune_3_max = self:GetSpecialValueFor("rune_3_max")+1

	self.runetype = self:GetRuneType()
	self.table = {
		[1] = {"modifier_chaotic_overcharge_active_rune1",self.rune_1_duration,self.rune_1_max},
		[2] = {"modifier_chaotic_overcharge_active_rune2",self.rune_2_duration,self.rune_2_max},
		[3] = {"modifier_chaotic_overcharge_active_rune3",self.rune_3_duration,self.rune_3_max},
	}

	if modifier then
		modifier:Destroy()
	end
	if modifier2  then
		modifier2:Destroy()
	end
    -- 自己的buff
	caster:AddNewModifier(caster, self, "modifier_chaotic_overcharge_active", {duration = duration})
	-- 选取一个友军施加状态
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  self:GetAOERadius(),
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)  

	for _, unit in pairs(units) do
        if unit ~= caster then
	        self:Overcharge(unit)
			break
        end
	end

	if self.runetype < 1 then return end
	local type = self.table[self.runetype]
	if type then
		local modifier_name = type[1]
		local duration = type[2]
		local max = type[3]
		local i = 0

		for _, unit in pairs(units) do
			unit:AddNewModifier(self:GetCaster(), self, modifier_name, {duration = duration})
			
			i = i + 1
			if i >= max then
				break
			end
		end
	end

	self:RuneEffects(caster, self.runetype)
	
end

function chaotic_overcharge:RuneEffects(unit, type)
	if not IsServer() then return end
	if not type or not unit then return end
	if type == 1 then 
		local particalId = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(particalId, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true)
		ParticleManager:SetParticleControl(particalId, 1, Vector(0, 0, 0))
		DestroyParticleByDelay(particalId, 3)
	end
end

function chaotic_overcharge:Overcharge(unit)
	if not IsServer() then return end
	if not unit then return end
	
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(0.3)
	local duration = self:GetSpecialValueFor("duration")*gain

	local buff = unit:FindModifierByName("modifier_chaotic_overcharge_active")
	local buff2 = unit:FindModifierByName("modifier_chaotic_overcharge_active_ally")
	
	if buff	then
		buff:Destroy()
	end
	if buff2 then
		buff2:Destroy()
	end
	unit:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_overcharge_active_ally", {duration = duration})	

end
-------------------------------------------------------------
modifier_chaotic_overcharge_active = advanced_modifier({})

function modifier_chaotic_overcharge_active:IsDebuff() return false end
function modifier_chaotic_overcharge_active:IsHidden() return false end
function modifier_chaotic_overcharge_active:IsPurgable() return false end

function modifier_chaotic_overcharge_active:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() return end
    
	if not self.overcharge_pfx then
		self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	end

	self.outgoing_mult = self.ability:GetSpecialValueFor("outgoing_mult")
	self.incoming = self.ability:GetSpecialValueFor("incoming")

	if IsServer() then
		self:GetParent():EmitSound("Hero_Wisp.Overcharge")
	end
end

function modifier_chaotic_overcharge_active:OnRefresh(keys)
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() return end
    
	if not self.overcharge_pfx then
		self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	end
	self.outgoing_mult = self.ability:GetSpecialValueFor("outgoing_mult")
	self.incoming = self.ability:GetSpecialValueFor("incoming")
end

function modifier_chaotic_overcharge_active:OnDestroy(keys)
    ParticleManager:DestroyParticle(self.overcharge_pfx, false)
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Overcharge")
	end

end

function modifier_chaotic_overcharge_active:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul() 
    if not self.ability then self:Destroy() return end
    return self.outgoing_mult
end
function modifier_chaotic_overcharge_active:Advanced_GetModifierIncomingDamage_Percentage() 	
    if not self.ability then self:Destroy() return end
    return -self.incoming
end

function modifier_chaotic_overcharge_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end


-------------------------------------------------------------
modifier_chaotic_overcharge_active_ally = advanced_modifier({})

function modifier_chaotic_overcharge_active_ally:IsDebuff() return false end
function modifier_chaotic_overcharge_active_ally:IsHidden() return false end
function modifier_chaotic_overcharge_active_ally:IsPurgable() return false end

function modifier_chaotic_overcharge_active_ally:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() return end
    
	if not self.overcharge_pfx then
		self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	end
    self.ally_index = self.ability:GetSpecialValueFor("ally_index")*0.01
	self.outgoing_mult = self.ability:GetSpecialValueFor("outgoing_mult")*self.ally_index
	self.incoming = self.ability:GetSpecialValueFor("incoming")*self.ally_index
    

	if IsServer() then
		self:GetParent():EmitSound("Hero_Wisp.Overcharge")
	end
end

function modifier_chaotic_overcharge_active_ally:OnRefresh(keys)
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() return end
    
	if not self.overcharge_pfx then
		self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	end
	self.ally_index = self.ability:GetSpecialValueFor("ally_index")*0.01
	self.outgoing_mult = self.ability:GetSpecialValueFor("outgoing_mult")*self.ally_index
	self.incoming = self.ability:GetSpecialValueFor("incoming")*self.ally_index
end

function modifier_chaotic_overcharge_active_ally:OnDestroy(keys)
    ParticleManager:DestroyParticle(self.overcharge_pfx, false)
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Overcharge")
	end

end

function modifier_chaotic_overcharge_active_ally:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul() 
    if not self.ability then self:Destroy() return end
    return self.outgoing_mult
end
function modifier_chaotic_overcharge_active_ally:Advanced_GetModifierIncomingDamage_Percentage() 	
    if not self.ability then self:Destroy() return end
    return -self.incoming
end

function modifier_chaotic_overcharge_active_ally:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

-------------------------------------------------------------
modifier_chaotic_overcharge_active_rune1 = advanced_modifier({})

function modifier_chaotic_overcharge_active_rune1:IsDebuff() return false end
function modifier_chaotic_overcharge_active_rune1:IsHidden() return false end
function modifier_chaotic_overcharge_active_rune1:IsPurgable() return false end

function modifier_chaotic_overcharge_active_rune1:OnCreated(keys)
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() return end
	self.rune_1_bonus = self.ability:GetSpecialValueFor("rune_1_bonus")
	self.parent = self:GetParent()

	if IsServer() then
		local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"

		if not self.effect_cast then
			self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent )
		end
		ParticleManager:SetParticleControl( self.effect_cast, 1, self.parent:GetOrigin() )
		self:GetParent():EmitSound("Hero_Wisp.Overcharge")
	end
end

function modifier_chaotic_overcharge_active_rune1:OnRefresh(keys)
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() return end
	self.rune_1_bonus = self.ability:GetSpecialValueFor("rune_1_bonus")
	self.parent = self:GetParent()
	if not self.effect_cast then
		self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
	end
end

function modifier_chaotic_overcharge_active_rune1:OnDestroy(keys)
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast, true)
	end
	if IsServer() then
		if self.effect_cast then
			ParticleManager:DestroyParticle(self.effect_cast, true)
		end
		self:GetParent():StopSound("Hero_Wisp.Overcharge")
	end
end

function modifier_chaotic_overcharge_active_rune1:Advanced_GetModifierDamageOutgoing_Percentage() 
    if not self.ability then self:Destroy() return end
    return self.rune_1_bonus
end
function modifier_chaotic_overcharge_active_rune1:Advanced_GetModifierSpellAmplifyBonusPercentageMUL() 	
    if not self.ability then self:Destroy() return end
    return self.rune_1_bonus
end

function modifier_chaotic_overcharge_active_rune1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_PERCENTAGE_MUL
    }
end