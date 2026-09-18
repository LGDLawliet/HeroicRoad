item_hd_flower_locket = advanced_modifier({})

LinkLuaModifier("modifier_item_hd_flower_locket", "items/item_hd_flower_locket", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_flower_locket_active", "items/item_hd_flower_locket", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_flower_locket_thinker", "items/item_hd_flower_locket", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_flower_locket_thinker_buff", "items/item_hd_flower_locket", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_flower_locket_thinker_already", "items/item_hd_flower_locket", LUA_MODIFIER_MOTION_NONE)
-- Item Passive
function item_hd_flower_locket:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/flower_locket/effect_parent.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/flower_locket/wave.vpcf", context )
end
function item_hd_flower_locket:GetIntrinsicModifierName()
	return "modifier_item_hd_flower_locket"
end
function item_hd_flower_locket:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_hd_flower_locket:OnSpellStart()
	self.radius = self:GetSpecialValueFor("radius")
	self.duration = self:GetSpecialValueFor("duration")
	self.pos = self:GetCaster():GetCursorPosition()
	local thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_item_hd_flower_locket_thinker", { duration = self.duration , pos = self.pos }, self.pos, self:GetCaster():GetTeamNumber(), false)
	print(self:GetCaster())
end
----------------------

modifier_item_hd_flower_locket = advanced_modifier({})

function modifier_item_hd_flower_locket:IsDebuff() return false end
function modifier_item_hd_flower_locket:IsHidden() return true end
function modifier_item_hd_flower_locket:IsPurgable() return false end

function modifier_item_hd_flower_locket:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
    self.bonus_heal_amp = self.ability:GetSpecialValueFor("bonus_heal_amp")
	self.heal_duration = self.ability:GetSpecialValueFor("heal_duration")
	self.refresh_line = self:GetAbility():GetSpecialValueFor("refresh_line")
	self.hp_regen_per = self:GetAbility():GetSpecialValueFor("hp_regen_per")
	self.chance = self.ability:GetSpecialValueFor("chance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_item_hd_flower_locket:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
    self.bonus_heal_amp = self.ability:GetSpecialValueFor("bonus_heal_amp")
	self.heal_duration = self.ability:GetSpecialValueFor("heal_duration")
	self.refresh_line = self:GetAbility():GetSpecialValueFor("refresh_line")
	self.hp_regen_per = self:GetAbility():GetSpecialValueFor("hp_regen_per")
end
function modifier_item_hd_flower_locket:OnIntervalThink(keys)
    self:SetStackCount(self:GetParent():GetLevel())
end
-- advanced_modifier
function modifier_item_hd_flower_locket:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_hd_flower_locket:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		if keys.target==self:GetParent() then
			return
		end
        if not keys.target:IsRealHero() then
            return
        end
        if keys.target:GetTeamNumber() ~= keys.unit:GetTeamNumber() then
            return
        end
        keys.target:AddNewModifier(keys.unit, self:GetAbility(), "modifier_item_hd_flower_locket_active", {duration = self.heal_duration})
		
		if self.chance >= RandomInt(1, 100) then
			for i=0, keys.target:GetAbilityCount() - 1 do
				local Ability = keys.target:GetAbilityByIndex(i)
				if Ability ~= nil and not Ability:IsCooldownReady() and Ability:GetCooldownTimeRemaining() <= self.refresh_line then
					Ability:EndCooldown()
					break
				end
			end
		end
	end
end

function modifier_item_hd_flower_locket:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amp 
end

function modifier_item_hd_flower_locket:Advanced_GetModifierBonusStats_Strength(keys)
	return self.bonus_atb 
end
function modifier_item_hd_flower_locket:Advanced_GetModifierBonusStats_Agility(keys)
	return self.bonus_atb 
end
function modifier_item_hd_flower_locket:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.bonus_atb 
end
function modifier_item_hd_flower_locket:AdvancedGetModifierConstantHealthRegenPercentage(keys)
	return self.hp_regen_per * self:GetStackCount() 
end
---------------
modifier_item_hd_flower_locket_active = advanced_modifier({})

function modifier_item_hd_flower_locket_active:IsDebuff() return false end
function modifier_item_hd_flower_locket_active:IsHidden() return true end
function modifier_item_hd_flower_locket_active:IsPurgable() return false end
function modifier_item_hd_flower_locket_active:GetEffectName() return "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf" end
function modifier_item_hd_flower_locket_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_flower_locket_active:OnCreated(keys)
	if not IsServer() then
		return
	end
    
    self.ability = self:GetAbility()
	self.active_agi = self.ability:GetSpecialValueFor("heal_atb")*0.01 *self:GetCaster():GetBaseAgility()
    self.active_int = self.ability:GetSpecialValueFor("heal_atb")*0.01 *self:GetCaster():GetBaseIntellect()
    self.active_str = self.ability:GetSpecialValueFor("heal_atb")*0.01 *self:GetCaster():GetBaseStrength()

end
function modifier_item_hd_flower_locket_active:OnRefresh(keys)
	if not IsServer() then
		return
	end
    
    self.ability = self:GetAbility()
	self.active_agi = self.ability:GetSpecialValueFor("heal_atb")*0.01 *self:GetCaster():GetBaseAgility()
    self.active_int = self.ability:GetSpecialValueFor("heal_atb")*0.01 *self:GetCaster():GetBaseIntellect()
    self.active_str = self.ability:GetSpecialValueFor("heal_atb")*0.01 *self:GetCaster():GetBaseStrength()

end

function modifier_item_hd_flower_locket_active:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end

function modifier_item_hd_flower_locket_active:Advanced_GetModifierBonusStats_Strength()
    return self.active_str
end
function modifier_item_hd_flower_locket_active:Advanced_GetModifierBonusStats_Agility()
    return self.active_agi
end
function modifier_item_hd_flower_locket_active:Advanced_GetModifierBonusStats_Intellect()
    return self.active_int
end


----------------------
modifier_item_hd_flower_locket_thinker = advanced_modifier({})

function modifier_item_hd_flower_locket_thinker:IsAura()return true end
function modifier_item_hd_flower_locket_thinker:RemoveOnDeath() return true end

function modifier_item_hd_flower_locket_thinker:OnCreated(keys)
	if IsServer() then
		self.thinker = self:GetParent()
		self.radius	= self:GetAbility():GetSpecialValueFor("radius")
		self.thinker:EmitSound("Hero_DarkWillow.Bramble.Spawn")
		self.pos = self.thinker:GetAbsOrigin()

		self.particle = ParticleManager:CreateParticle("particles/rebuild/items/flower_locket/effect_parent.vpcf", PATTACH_POINT_FOLLOW, self.thinker)
		ParticleManager:SetParticleControlEnt( self.particle, 0, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 2, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 3, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 5, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 9, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControl(self.particle, 10, (Vector(self.radius, 0, 0)))
		self:StartIntervalThink(1)
	end
end
function modifier_item_hd_flower_locket_thinker:OnIntervalThink()
	if self.thinker:HasModifier("modifier_item_hd_flower_locket_thinker_already") then
		return
	end
	local heroes = FindUnitsInRadius(self.thinker:GetTeamNumber(), self.pos , nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,hero in pairs(heroes)do
		hero:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_hd_flower_locket_thinker_buff",{duration = 1.1 , thinker = self:GetParent()})
	end
end
function modifier_item_hd_flower_locket_thinker:OnDestroy(keys)
	if IsServer() then
		local heroes = FindUnitsInRadius(self.thinker:GetTeamNumber(), self.pos , nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _,hero in pairs(heroes)do
			hero:RemoveModifierByName("modifier_item_hd_flower_locket_thinker_buff")
		end
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self.thinker)
	end
end


---------------
modifier_item_hd_flower_locket_thinker_buff = advanced_modifier({})

function modifier_item_hd_flower_locket_thinker_buff:IsDebuff() return false end
function modifier_item_hd_flower_locket_thinker_buff:IsHidden() return true end
function modifier_item_hd_flower_locket_thinker_buff:IsPurgable() return false end

function modifier_item_hd_flower_locket_thinker_buff:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.heal = self.ability:GetSpecialValueFor("heal")
    self.bonus_heal = self.ability:GetSpecialValueFor("bonus_heal")
end
function modifier_item_hd_flower_locket_thinker_buff:OnRefresh()
	if not IsServer() then
		return
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.heal = self.ability:GetSpecialValueFor("heal")
    self.bonus_heal = self.ability:GetSpecialValueFor("bonus_heal")
end

function modifier_item_hd_flower_locket_thinker_buff:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
    }
    return funcs
end

function modifier_item_hd_flower_locket_thinker_buff:OnTakeDamage(keys)
    if not IsServer() then
		return
	end
	if self:GetParent() ~= keys.unit then
		return
	end
	local thinkers = Entities:FindAllByClassnameWithin("npc_dota_thinker", self:GetParent():GetAbsOrigin(), 100000)
	for _, unit in ipairs(thinkers) do
		if unit:HasModifier("modifier_item_hd_flower_locket_thinker") then
			self.thinker = unit
			self.pos = unit:GetAbsOrigin()
			unit:AddNewModifier(unit,self:GetAbility(),"modifier_item_hd_flower_locket_thinker_already",{duration = 3})
		end
	end
	if self.pos == nil then
		return
	end
	if self.thinker == nil then
		return
	end
	if not keys.unit:IsAlive() then
		keys.unit:SetHealth(1)
	end
	self:HealEffect(self.pos , self.radius)
end


function modifier_item_hd_flower_locket_thinker_buff:HealEffect(point, radius)

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	for _,unit in pairs(units) do
		local heal = self.heal + self.bonus_heal*self:GetCaster():GetHealthRegen()
		local healing = HealWithGain(heal, self:GetCaster() ,unit ,self.ability)
		print(self:GetCaster())
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_HEAL,unit,healing,self.parent:GetPlayerOwner())
	end

	local particle_cast = "particles/rebuild/items/flower_locket/wave.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Damage"
	point = GetGroundPosition( point, self.parent )

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( point, sound_cast, self.parent )
end

---------------------------
modifier_item_hd_flower_locket_thinker_already = advanced_modifier({})

function modifier_item_hd_flower_locket_thinker_already:IsDebuff() return false end
function modifier_item_hd_flower_locket_thinker_already:IsHidden() return true end
function modifier_item_hd_flower_locket_thinker_already:IsPurgable() return false end