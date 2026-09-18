chaotic_summon_sprite_king = class({})

LinkLuaModifier("modifier_chaotic_summon_sprite_king_buff", "chaotic_spell/class_super/chaotic_summon_sprite_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_sprite_king_buff_effect", "chaotic_spell/class_super/chaotic_summon_sprite_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_sprite_king_buff_fire", "chaotic_spell/class_super/chaotic_summon_sprite_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_sprite_king_buff_ice", "chaotic_spell/class_super/chaotic_summon_sprite_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_sprite_king_buff_lightning", "chaotic_spell/class_super/chaotic_summon_sprite_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_summon_sprite_king_buff_dark", "chaotic_spell/class_super/chaotic_summon_sprite_king", LUA_MODIFIER_MOTION_NONE)

function chaotic_summon_sprite_king:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", context )
end
function chaotic_summon_sprite_king:IsSummonSpell()return true end

function chaotic_summon_sprite_king:OnSpellStart()

	
	local count = self:GetSpecialValueFor("max_count")
	local caster =self:GetCaster()
	
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+ self:GetSpecialValueFor("base_damage")

	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 


    local effect_fire = ParticleManager:CreateParticle("particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effect_fire, 0, unit_pos)
	ParticleManager:SetParticleControl(effect_fire, 1, Vector(100, 100, 0))
	ParticleManager:ReleaseParticleIndex(effect_fire)
    local particle2 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle2, 0,unit_pos)
    ParticleManager:SetParticleControl( particle2, 3,unit_pos)
    EmitSoundOnLocationWithCaster(unit_pos, "Hero_Ancient_Apparition.IceBlast.Target", caster)

	local unit = caster:SummonUnit("npc_hd_chaotic_sprite_king",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)


	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_sprite_king_buff", {})
    unit:AddNewModifier(caster, self, "modifier_chaotic_summon_sprite_king_buff_fire", {})
    unit:AddNewModifier(caster, self, "modifier_chaotic_summon_sprite_king_buff_ice", {})
    unit:AddNewModifier(caster, self, "modifier_chaotic_summon_sprite_king_buff_lightning", {})
    unit:AddNewModifier(caster, self, "modifier_chaotic_summon_sprite_king_buff_dark", {})
	table.insert(self.summon_table,unit)
end
------------技能1
modifier_chaotic_summon_sprite_king_buff_fire = advanced_modifier({})

function modifier_chaotic_summon_sprite_king_buff_fire:IsDebuff() return false end
function modifier_chaotic_summon_sprite_king_buff_fire:IsHidden() return true end
function modifier_chaotic_summon_sprite_king_buff_fire:IsPurgable() 		return false end
function modifier_chaotic_summon_sprite_king_buff_fire:IsPurgeException() 	return false end
function modifier_chaotic_summon_sprite_king_buff_fire:RemoveOnDeath()  return false end

function modifier_chaotic_summon_sprite_king_buff_fire:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_flame_strike")
		self.interval = 10
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(10)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_sprite_king_buff_fire:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
            parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
		end
	end
end
------------技能2
modifier_chaotic_summon_sprite_king_buff_ice = advanced_modifier({})

function modifier_chaotic_summon_sprite_king_buff_ice:IsDebuff() return false end
function modifier_chaotic_summon_sprite_king_buff_ice:IsHidden() return true end
function modifier_chaotic_summon_sprite_king_buff_ice:IsPurgable() 		return false end
function modifier_chaotic_summon_sprite_king_buff_ice:IsPurgeException() 	return false end
function modifier_chaotic_summon_sprite_king_buff_ice:RemoveOnDeath()  return false end

function modifier_chaotic_summon_sprite_king_buff_ice:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_cone_of_cold")
		self.interval = 7
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(7)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_sprite_king_buff_ice:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
            parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
		end
	end
end
------------技能3
modifier_chaotic_summon_sprite_king_buff_lightning = advanced_modifier({})

function modifier_chaotic_summon_sprite_king_buff_lightning:IsDebuff() return false end
function modifier_chaotic_summon_sprite_king_buff_lightning:IsHidden() return true end
function modifier_chaotic_summon_sprite_king_buff_lightning:IsPurgable() 		return false end
function modifier_chaotic_summon_sprite_king_buff_lightning:IsPurgeException() 	return false end
function modifier_chaotic_summon_sprite_king_buff_lightning:RemoveOnDeath()  return false end

function modifier_chaotic_summon_sprite_king_buff_lightning:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_chain_lightning")
		self.interval = 13
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(13)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_sprite_king_buff_lightning:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnTarget(target, self.creep_ability, parent:GetPlayerOwnerID())
            parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
		end
	end
end
------------技能4
modifier_chaotic_summon_sprite_king_buff_dark = advanced_modifier({})

function modifier_chaotic_summon_sprite_king_buff_dark:IsDebuff() return false end
function modifier_chaotic_summon_sprite_king_buff_dark:IsHidden() return true end
function modifier_chaotic_summon_sprite_king_buff_dark:IsPurgable() 		return false end
function modifier_chaotic_summon_sprite_king_buff_dark:IsPurgeException() 	return false end
function modifier_chaotic_summon_sprite_king_buff_dark:RemoveOnDeath()  return false end

function modifier_chaotic_summon_sprite_king_buff_dark:OnCreated(keys)
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.creep_ability = self:GetParent():FindAbilityByName("chaotic_vaccum")
		self.interval = 5
		self.timer =  GameRules:GetGameTime()
		if self.creep_ability then
			self.creep_ability:StartCooldown(5)
			self.creep_ability:SetFrozenCooldown(true)
			self:StartIntervalThink(0.2)
		end
	end
end

function modifier_chaotic_summon_sprite_king_buff_dark:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	
	local time =  GameRules:GetGameTime()
	if time>=self.timer or self.creep_ability:IsCooldownReady() then
		
		local target = parent:GetAggroTarget()
		if target then
			self.creep_ability:EndCooldown()
			self.timer = time + self.interval

			parent:CastAbilityOnPosition(target:GetAbsOrigin(), self.creep_ability, parent:GetPlayerOwnerID())
            parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
		end
	end
end

modifier_chaotic_summon_sprite_king_buff_effect = advanced_modifier({})

function modifier_chaotic_summon_sprite_king_buff_effect:IsDebuff() return false end
function modifier_chaotic_summon_sprite_king_buff_effect:IsHidden() return (not self:GetParent():IsSpriteSummon()) end
function modifier_chaotic_summon_sprite_king_buff_effect:IsPurgable() 		return false end
function modifier_chaotic_summon_sprite_king_buff_effect:IsPurgeException() 	return false end
function modifier_chaotic_summon_sprite_king_buff_effect:OnCreated(keys)
	self.ability = self:GetAbility()
	self.ally_attack = self.ability:GetSpecialValueFor("ally_attack")
    self.ally_attack_speed = self.ability:GetSpecialValueFor("ally_attack_speed")
    self.ally_armor = self.ability:GetSpecialValueFor("ally_armor")

    self.type = self.ability:GetRuneType()
    self.rune_1_bonus = self.ability:GetSpecialValueFor("rune_1_bonus")*0.01

    if self.type == 1 then
        self.ally_attack = self.ally_attack* (1+self.rune_1_bonus)
        self.ally_attack_speed = self.ally_attack_speed* (1+self.rune_1_bonus)
        self.ally_armor = self.ally_armor* (1+self.rune_1_bonus)
    end
end



function modifier_chaotic_summon_sprite_king_buff_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
    }
end
function modifier_chaotic_summon_sprite_king_buff_effect:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if not self:GetAbility() then return end
    if not self:GetParent():IsSpriteSummon() then return end
    return self.ally_attack
end
function modifier_chaotic_summon_sprite_king_buff_effect:Advanced_GetModifierAttackSpeedPercentage()
    if not self:GetAbility() then return end
    if not self:GetParent():IsSpriteSummon() then return end
    return self.ally_attack_speed
end
function modifier_chaotic_summon_sprite_king_buff_effect:Advanced_GetModifierPhysicalArmorBonusPercentage()
    if not self:GetAbility() then return end
    if not self:GetParent():IsSpriteSummon() then return end
    return self.ally_armor
end

function modifier_chaotic_summon_sprite_king_buff_effect:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_sprite_king_buff_effect:OnTooltip() 
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	end
    if self._tooltip == 2 then
		return self:Advanced_GetModifierAttackSpeedPercentage()
	end
    if self._tooltip == 3 then
		return self:Advanced_GetModifierPhysicalArmorBonusPercentage()
	end
end


modifier_chaotic_summon_sprite_king_buff = advanced_modifier({})

function modifier_chaotic_summon_sprite_king_buff:IsDebuff() return false end
function modifier_chaotic_summon_sprite_king_buff:IsHidden() return false end
function modifier_chaotic_summon_sprite_king_buff:IsPurgable() 		return false end
function modifier_chaotic_summon_sprite_king_buff:IsPurgeException() 	return false end
function modifier_chaotic_summon_sprite_king_buff:GetEffectName() return "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_taunt_lightbeams_blue.vpcf" end
function modifier_chaotic_summon_sprite_king_buff:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
    
function modifier_chaotic_summon_sprite_king_buff:IsAura() return true end
function modifier_chaotic_summon_sprite_king_buff:GetModifierAura()	return "modifier_chaotic_summon_sprite_king_buff_effect" end
function modifier_chaotic_summon_sprite_king_buff:GetAuraRadius()	return self.ally_radius end
function modifier_chaotic_summon_sprite_king_buff:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_chaotic_summon_sprite_king_buff:GetAuraSearchType()	return DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_summon_sprite_king_buff:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
    
function modifier_chaotic_summon_sprite_king_buff:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.ally_self = self.ability:GetSpecialValueFor("ally_self")
	self.ally_radius = self.ability:GetSpecialValueFor("ally_radius")

    self.type = self.ability:GetRuneType()
    self.rune_1_incoming = self.ability:GetSpecialValueFor("rune_1_incoming")
    if IsServer() then 
        self:StartIntervalThink(5)
    end
end

function modifier_chaotic_summon_sprite_king_buff:OnIntervalThink()
    local caster = self:GetParent()
    self:SetStackCount(0)
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.ally_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    for _ , unit in pairs(units) do
        if unit:IsSpriteSummon() then
            self:SetStackCount(self:GetStackCount() + 1)
        end
    end
end
function modifier_chaotic_summon_sprite_king_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,

    }
    if self.type == 1 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
    end
    return funcs
end

function modifier_chaotic_summon_sprite_king_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_chaotic_summon_sprite_king_buff:OnTooltip() 
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()*self.ally_self
	end
    if self._tooltip == 2 then
		return self:GetStackCount()*self.rune_1_incoming
	end
end

function modifier_chaotic_summon_sprite_king_buff:Advanced_GetModifierDamageOutgoing_Percentage()
    if not self.ability then return end
    return self:GetStackCount()*self.ally_self
end
function modifier_chaotic_summon_sprite_king_buff:Advanced_GetModifierIncomingDamage_Percentage()
    if not self.ability then return end
    return -self:GetStackCount()*self.rune_1_incoming
end