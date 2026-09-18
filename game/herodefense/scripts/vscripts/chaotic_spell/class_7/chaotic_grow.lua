LinkLuaModifier("modifier_chaotic_grow", "chaotic_spell/class_7/chaotic_grow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_grow_bonus_buff", "chaotic_spell/class_7/chaotic_grow", LUA_MODIFIER_MOTION_NONE)

chaotic_grow = chaotic_grow or class({})

function chaotic_grow:GetIntrinsicModifierName()
	return "modifier_chaotic_grow" 
end

function chaotic_grow:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_grow/eff_all.vpcf", context )
end

modifier_chaotic_grow = advanced_modifier({})

function modifier_chaotic_grow:IsPurgable() 		return false end
function modifier_chaotic_grow:IsPurgeException() 	return false end
function modifier_chaotic_grow:IsHidden() return true end
function modifier_chaotic_grow:RemoveOnDeath()  return false end

function modifier_chaotic_grow:OnCreated()
	if not IsServer() then
		return
	end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

    self.count = 0
	self.max = self.ability:GetSpecialValueFor("max")
	self.time_require = self.ability:GetSpecialValueFor("time_require")
    self.attack = self.ability:GetSpecialValueFor("bonus_attack")
    self.speed = self.ability:GetSpecialValueFor("attack_speed_down")
    self.armor = self.ability:GetSpecialValueFor("bonus_armor")
    self.range = self.ability:GetSpecialValueFor("bonus_attack_range_melee")
    self.incoming = self.ability:GetSpecialValueFor("max_incoming")
    self.outgoing = self.ability:GetSpecialValueFor("max_attack_outgoing")

	self:StartIntervalThink(self.time_require)
	self.GetDieTime = self:GetDieTime()
	self:SetHasCustomTransmitterData( true )
end

function modifier_chaotic_grow:OnIntervalThink()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    if IsValid(ability) then
        local pfx = ParticleManager:CreateParticle("particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_death_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(pfx)
        parent:EmitSound("Tiny.Grow")

		parent:AddNewModifier(parent,ability, "modifier_chaotic_grow_bonus_buff", {stack = 1, speed = self.speed, attack = self.attack, armor = self.armor, range = self.range, incoming = self.incoming, outgoing = self.outgoing, max = self.max})
        self.count = self.count + 1
        if self.count < self.max then return end
        
        self:SetDuration(0.1, true)
    end
end

function modifier_chaotic_grow:OnDestroy()
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	local ability =self:GetAbility()
	

	parent:GameTimer(0.1,function()
		if IsValid(ability) then
			if not parent:IsAlive() then
				return 0.1
			end
            
			chaotic_era:InSertDisableAbility(parent:GetPlayerOwnerID(),ability:GetAbilityName())
			parent:RemoveAbility("chaotic_grow")
			local pfx = ParticleManager:CreateParticle("particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_death_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(pfx)
            parent:EmitSound("Tiny.Grow")
		end
	end)
end


------------------------------------------------------
modifier_chaotic_grow_bonus_buff = advanced_modifier({})

function modifier_chaotic_grow_bonus_buff:IsPurgable() 		return false end
function modifier_chaotic_grow_bonus_buff:IsPurgeException() 	return false end
function modifier_chaotic_grow_bonus_buff:IsHidden() return false end
function modifier_chaotic_grow_bonus_buff:RemoveOnDeath()  return false end
function modifier_chaotic_grow_bonus_buff:GetTexture() return "tiny_grow" end

function modifier_chaotic_grow_bonus_buff:OnCreated(keys)
    if IsServer() then
       self.stack = keys.stack
       self.speed = keys.speed
       self.attack = keys.attack
       self.armor = keys.armor
       self.range = keys.range
       self.incoming = keys.incoming
       self.outgoing = keys.outgoing
       self.max = keys.max
       self:SetStackCount(self.stack)
       self:SetHasCustomTransmitterData( true ) 
    end
end

function modifier_chaotic_grow_bonus_buff:OnRefresh(keys)
    if IsServer() then
        self.stack = keys.stack
        self.speed = keys.speed
        self.attack = keys.attack
        self.armor = keys.armor
        self.range = keys.range
        self.incoming = keys.incoming
        self.outgoing = keys.outgoing
        self.max = keys.max
       self:SetStackCount(self:GetStackCount() + self.stack) 
    end
end

function modifier_chaotic_grow_bonus_buff:AddCustomTransmitterData( )
	return
	{
		speed = self.speed,
		attack = self.attack,
		armor = self.armor,
        range = self.range,
		incoming = self.incoming,
		outgoing = self.outgoing,
        max = self.max,
	}
end

function modifier_chaotic_grow_bonus_buff:HandleCustomTransmitterData( data )
    self.speed = data.speed
    self.attack = data.attack
    self.armor = data.armor
    self.range = data.range
    self.incoming = data.incoming
    self.outgoing = data.outgoing
    self.max = data.max
end

function modifier_chaotic_grow_bonus_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_chaotic_grow_bonus_buff:Advanced_GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount()*self.attack
end

function modifier_chaotic_grow_bonus_buff:Advanced_GetModifierAttackSpeedPercentage()	
	return -self:GetStackCount()*self.speed
end
function modifier_chaotic_grow_bonus_buff:Advanced_GetModifierPhysicalArmorBonus()	
	return self:GetStackCount()*self.armor
end
function modifier_chaotic_grow_bonus_buff:Advanced_GetModifierAttackRangeBonus()	
    if self:GetParent():IsRangedAttacker() then return end
	return self:GetStackCount()*self.range
end
function modifier_chaotic_grow_bonus_buff:Advanced_GetModifierIncomingDamage_Percentage()	
    if self:GetStackCount() >= self.max then
	    return -self.incoming
    end
end
function modifier_chaotic_grow_bonus_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
    if not IsServer() then return end
    if self:GetStackCount() >= self.max and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
	    return self.outgoing
    end
    return 
end
function modifier_chaotic_grow_bonus_buff:GetModifierModelScale()
    return self:GetStackCount()*25
end

function modifier_chaotic_grow_bonus_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
        MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_chaotic_grow_bonus_buff:OnTooltip() 
    self._tooltip = (self._tooltip or 0) % 6 + 1
	if self._tooltip == 1 then
        return self:Advanced_GetModifierAttackSpeedPercentage()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierDamageOutgoing_Percentage()
    end
    if self._tooltip == 3 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
    end
	if self._tooltip == 4 then
        return self:GetStackCount()*self.range
    end
    if self._tooltip == 5 then
        if self:GetStackCount() >= self.max then
            return self.incoming
        end
    end
    if self._tooltip == 6 then
        if self:GetStackCount() >= self.max then
            return self.outgoing
        end
    end
end