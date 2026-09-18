
chaotic_vashak_prophecy = class({})
LinkLuaModifier("modifier_chaotic_vashak_prophecy", "chaotic_spell/class_1/chaotic_vashak_prophecy", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_vashak_prophecy_debuff", "chaotic_spell/class_1/chaotic_vashak_prophecy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_vashak_prophecy_buff", "chaotic_spell/class_1/chaotic_vashak_prophecy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_vashak_prophecy_shield", "chaotic_spell/class_1/chaotic_vashak_prophecy", LUA_MODIFIER_MOTION_NONE)


function chaotic_vashak_prophecy:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_vashak_prophecy/effect_buff/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/holy_light_shield/effect_abaddon_aphotic_shield_explosion_alliance_trail.vpcf", context )
end

function chaotic_vashak_prophecy:GetManaCost(iLevel)
 	local cost = self.BaseClass.GetManaCost(self,iLevel)
 	if self:GetRuneType()==2 then
		cost = cost * (1-self:GetSpecialValueFor("rune_2_mana_cost")*0.01)
	end
 	return cost
end

function chaotic_vashak_prophecy:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end

function chaotic_vashak_prophecy:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = caster 
	-- local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")
	self:ApplyModifier(target, duration)
	
	if self:GetRuneType()==2 then
		local heroes = GetAllRealHeroes()
		for _ , hero in pairs(heroes) do
			if hero~=caster then
				self:ApplyModifier(hero, duration)
			end
		end
	end

end

function chaotic_vashak_prophecy:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	target:AddNewModifier(caster, self, "modifier_chaotic_vashak_prophecy", {duration = duration})
	target:EmitSound("chaotic_vashak_prophecy_target") 
end




modifier_chaotic_vashak_prophecy = modifier_chaotic_vashak_prophecy or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_vashak_prophecy:IsHidden()	return false end
function modifier_chaotic_vashak_prophecy:IsDebuff()	return false end
function modifier_chaotic_vashak_prophecy:IsStunDebuff()	return false end
function modifier_chaotic_vashak_prophecy:IsPurgable()	return false end
function modifier_chaotic_vashak_prophecy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_vashak_prophecy:OnCreated( kv )
	if IsServer() then
		local require = self:GetAbility():GetSpecialValueFor("checkline")
		self:SetStackCount(require)

		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_vashak_prophecy/effect_buff/effect.vpcf",PATTACH_POINT_FOLLOW,parent)
        ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
        self:AddParticle(pfx, false, false, 15, false, false)
	end

end
function modifier_chaotic_vashak_prophecy:OnRefresh( kv )
	if IsServer() then
		local require = self:GetAbility():GetSpecialValueFor("checkline")
		self:SetStackCount(require)
	end
end

function modifier_chaotic_vashak_prophecy:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:IsAlive() then
			return
		end
		local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        100000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    	)
		local number = #enemies
		local ability = self:GetAbility()
		local caster = self:GetCaster()

		if self:GetAbility() and self:GetAbility():GetRuneType()==3 then
			local bonus = ability:GetSpecialValueFor("bonus_attribute")
			local max_stack = ability:GetSpecialValueFor("bonus_attribute_max")
			parent:AddNewModifier(caster, nil, "modifier_chaotic_vashak_prophecy_buff", {bonus=bonus,max_stack=max_stack})

			parent:SetHealth(1)
			parent:SetMana(1)
			
			local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/spell/holy_light_shield/effect_abaddon_aphotic_shield_explosion_alliance_trail.vpcf", PATTACH_CUSTOMORIGIN, parent )
			ParticleManager:SetParticleControlEnt(effect_cast1, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			DestroyParticleByDelay(effect_cast1,4)
			parent:EmitSound("chaotic_vashak_prophecy_fail") 
			return
		end

		if number > self:GetStackCount() then
			-- ok
			local bonus = ability:GetSpecialValueFor("bonus_attribute")
			local max_stack = ability:GetSpecialValueFor("bonus_attribute_max")
			parent:AddNewModifier(caster, nil, "modifier_chaotic_vashak_prophecy_buff", {bonus=bonus,max_stack=max_stack})
			
			if self:GetAbility():GetRuneType()==1 then
				parent:AddNewModifier(caster, ability, "modifier_chaotic_vashak_prophecy_shield", {duration = ability:GetSpecialValueFor("shield_duration"),index = 0.5})
			end
			local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/spell/holy_light_shield/effect_abaddon_aphotic_shield_explosion_alliance_trail.vpcf", PATTACH_CUSTOMORIGIN, parent )
			ParticleManager:SetParticleControlEnt(effect_cast1, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			DestroyParticleByDelay(effect_cast1,4)
			parent:EmitSound("chaotic_vashak_prophecy_target") 
		else	
			parent:AddNewModifier(caster, ability, "modifier_chaotic_vashak_prophecy_shield", {duration = ability:GetSpecialValueFor("shield_duration"),index = 1})
			if ability and not ability:IsCooldownReady() then
				local newcooldown = ability:GetCooldownTimeRemaining()*0.5
				ability:EndCooldown()
				ability:StartCooldown(newcooldown)
			end
		end
	end
end




modifier_chaotic_vashak_prophecy_debuff = modifier_chaotic_vashak_prophecy_debuff or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_vashak_prophecy_debuff:IsHidden()	return false end
function modifier_chaotic_vashak_prophecy_debuff:IsDebuff()	return true end
function modifier_chaotic_vashak_prophecy_debuff:IsStunDebuff()	return false end
function modifier_chaotic_vashak_prophecy_debuff:IsPurgable()	return false end
function modifier_chaotic_vashak_prophecy_debuff:RemoveOnDeath() return false end
function modifier_chaotic_vashak_prophecy_debuff:GetTexture() return "bane_enfeeble" end

function modifier_chaotic_vashak_prophecy_debuff:OnCreated(keys)
	if IsServer() then
		self.bonus = -keys.bonus
		self:SetStackCount(math.min(keys.max_stack, self:GetStackCount()+1))
		self:SetHasCustomTransmitterData( true )
	end
end
function modifier_chaotic_vashak_prophecy_debuff:OnRefresh(keys)
	if IsServer() then
		self.bonus = -keys.bonus
		self:SetStackCount(math.min(keys.max_stack, self:GetStackCount()+1))
	end
end


function modifier_chaotic_vashak_prophecy_debuff:AddCustomTransmitterData( )
	return
	{
		bonus = self.bonus
	}
end

function modifier_chaotic_vashak_prophecy_debuff:HandleCustomTransmitterData( data )
	self.bonus = data.bonus
end


function modifier_chaotic_vashak_prophecy_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_chaotic_vashak_prophecy_debuff:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus * self:GetStackCount()
end
function modifier_chaotic_vashak_prophecy_debuff:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus * self:GetStackCount()
end

function modifier_chaotic_vashak_prophecy_debuff:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus * self:GetStackCount()
end

function modifier_chaotic_vashak_prophecy_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end



function modifier_chaotic_vashak_prophecy_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus * self:GetStackCount()
	end
end















modifier_chaotic_vashak_prophecy_buff = modifier_chaotic_vashak_prophecy_buff or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_vashak_prophecy_buff:IsHidden()	return false end
function modifier_chaotic_vashak_prophecy_buff:IsDebuff()	return false end
function modifier_chaotic_vashak_prophecy_buff:IsStunDebuff()	return false end
function modifier_chaotic_vashak_prophecy_buff:IsPurgable()	return false end
function modifier_chaotic_vashak_prophecy_buff:RemoveOnDeath() return false end
function modifier_chaotic_vashak_prophecy_buff:GetTexture() return "dawnbreaker_solar_guardian" end

function modifier_chaotic_vashak_prophecy_buff:OnCreated(keys)
	if IsServer() then
		self.bonus = keys.bonus
		self:SetStackCount(math.min(keys.max_stack, self:GetStackCount()+1))
		self:SetHasCustomTransmitterData( true )
	end
end
function modifier_chaotic_vashak_prophecy_buff:OnRefresh(keys)
	if IsServer() then
		self.bonus = keys.bonus
		self:SetStackCount(math.min(keys.max_stack, self:GetStackCount()+1))
	end
end


function modifier_chaotic_vashak_prophecy_buff:AddCustomTransmitterData( )
	return
	{
		bonus = self.bonus
	}
end

function modifier_chaotic_vashak_prophecy_buff:HandleCustomTransmitterData( data )
	self.bonus = data.bonus
end


function modifier_chaotic_vashak_prophecy_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_chaotic_vashak_prophecy_buff:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus * self:GetStackCount()
end
function modifier_chaotic_vashak_prophecy_buff:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus * self:GetStackCount()
end

function modifier_chaotic_vashak_prophecy_buff:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus * self:GetStackCount()
end

function modifier_chaotic_vashak_prophecy_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end



function modifier_chaotic_vashak_prophecy_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus * self:GetStackCount()
	end
end









modifier_chaotic_vashak_prophecy_shield = advanced_modifier({})

function modifier_chaotic_vashak_prophecy_shield:IsDebuff()          return false end
function modifier_chaotic_vashak_prophecy_shield:IsHidden()          return false end
function modifier_chaotic_vashak_prophecy_shield:IsPurgable()        return false end
function modifier_chaotic_vashak_prophecy_shield:IsPurgeException()  return false end
function modifier_chaotic_vashak_prophecy_shield:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_vashak_prophecy_shield:OnCreated(keys)
    if IsServer() then
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        local parent = self:GetParent()
		local index = keys.index
        local shield = ability:GetSpecialValueFor("shield_index")*parent:GetMaxHealth()*0.01*index
        self:SetStackCount(shield)

    end
end

function modifier_chaotic_vashak_prophecy_shield:OnRefresh(keys)
    if IsServer() then
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        local parent = self:GetParent()
		local index = keys.index
        local shield = ability:GetSpecialValueFor("shield_index")*parent:GetMaxHealth()*0.01*index
        self:SetStackCount(shield)

    end
end



function modifier_chaotic_vashak_prophecy_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_chaotic_vashak_prophecy_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

    local stack = self:GetStackCount()
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack
end