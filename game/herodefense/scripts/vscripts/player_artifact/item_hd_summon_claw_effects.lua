item_hd_summon_claw_effects = class({})
LinkLuaModifier("modifier_item_hd_summon_claw_effects", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_claw_effects_both", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_claw_effects_i", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_claw_effects_s", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_claw_effects_lv70", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_claw_effects_lv30", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_summon_claw_effects_lv40", "player_artifact/item_hd_summon_claw_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_summon_claw_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_summon_claw_effects"
end
function item_hd_summon_claw_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_crystal_nova/effect.vpcf", context )
end
modifier_item_hd_summon_claw_effects = advanced_modifier({})

function modifier_item_hd_summon_claw_effects:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects:IsHidden() return true end
function modifier_item_hd_summon_claw_effects:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.attack = self.ability:GetArtifactSpecialValueFor("attack")*0.01
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")*0.01
    self.armor_2 = self.ability:GetArtifactSpecialValueFor("armor_2")*0.01
    self.stack_3 = self.ability:GetArtifactSpecialValueFor("stack_3")
    -- self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.need_4 = self.ability:GetArtifactSpecialValueFor("need_4")
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
    self.base_attack_7 = self.ability:GetArtifactSpecialValueFor("base_attack_7")*0.01
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_summon_claw_effects")
	
    if self.level >= 20 then
        self.attack = self.attack_2
    end
    if IsServer() then
        self:SetStackCount(0)
    end
end

function modifier_item_hd_summon_claw_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.attack = self.ability:GetArtifactSpecialValueFor("attack")*0.01
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")*0.01
    self.armor_2 = self.ability:GetArtifactSpecialValueFor("armor_2")*0.01
    self.stack_3 = self.ability:GetArtifactSpecialValueFor("stack_3")
    -- self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.need_4 = self.ability:GetArtifactSpecialValueFor("need_4")
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
    self.base_attack_7 = self.ability:GetArtifactSpecialValueFor("base_attack_7")*0.01
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_summon_claw_effects")
	
    if self.level >= 20 then
        self.attack = self.attack_2
    end
end

function modifier_item_hd_summon_claw_effects:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
        advanced_MODIFIER_PROPERTY_Summon_Intensity
	}
end

function modifier_item_hd_summon_claw_effects:Advanced_GetModifier_Summon_Intensity()
	return self.bonus_summon_intensity
end

function modifier_item_hd_summon_claw_effects:OnSummonUnitFinished(keys)
    if not IsServer() then return end
    local summoner = self.parent
    local target = keys.target
    if not IsValid(target) then return end
    -- 基础效果，lv20
    local attack = summoner:GetAverageTrueAttackDamage(nil)*self.attack
    local armor = self.level >=20 and summoner:GetPhysicalArmorValue(false)*self.armor_2 or 0
    target:AddNewModifier(summoner, self.ability, "modifier_item_hd_summon_claw_effects_both", {attack = attack, armor = armor})
    -- 类型效果，lv10效果
    if target:IsIndentureSummon() then
        target:AddNewModifier(summoner, self.ability, "modifier_item_hd_summon_claw_effects_i")
    end
    if target:IsSpriteSummon() then
        target:AddNewModifier(summoner, self.ability, "modifier_item_hd_summon_claw_effects_s")
    end
    -- lv30效果
    if self.level >= 30 then
        target:AddNewModifier(summoner, self.ability, "modifier_item_hd_summon_claw_effects_lv30",{stack = self.stack_3})

    end
    -- lv40效果
    if self.level >= 40 then
        local outgoing = math.floor(summoner:HDGetPrimaryStatValue()/self.need_4) *self.outgoing_4
        if not target:IsIndentureSummon() and not target:IsSpriteSummon() then
            outgoing = 2*outgoing
        end
        target:AddNewModifier(summoner, self.ability, "modifier_item_hd_summon_claw_effects_lv40",{outgoing = outgoing})
    end
    --lv70效果
    if self.level >= 70 then
        local base_attack = summoner:GetBaseDamageMax()*self.base_attack_7
        target:AddNewModifier(summoner, self.ability, "modifier_item_hd_summon_claw_effects_lv70", {duration = self.duration_7, base_attack = base_attack})
    end
end
---------
modifier_item_hd_summon_claw_effects_both = advanced_modifier({})
function modifier_item_hd_summon_claw_effects_both:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects_both:IsHidden() return true end
function modifier_item_hd_summon_claw_effects_both:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects_both:OnCreated(keys) 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    
    if IsServer() then
        self.attack = keys.attack
        self.armor = keys.armor
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end
function modifier_item_hd_summon_claw_effects_both:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_summon_claw_effects_both:Advanced_GetModifierPreAttack_BonusDamage()
    return self.attack
end
function modifier_item_hd_summon_claw_effects_both:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end

function modifier_item_hd_summon_claw_effects_both:AddCustomTransmitterData( )
	return
	{
		attack = self.attack,
		armor = self.armor,
	}
end
function modifier_item_hd_summon_claw_effects_both:HandleCustomTransmitterData( data )
	self.attack = data.attack
	self.armor = data.armor
end
---------
modifier_item_hd_summon_claw_effects_s = advanced_modifier({})

function modifier_item_hd_summon_claw_effects_s:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects_s:IsHidden() return true end
function modifier_item_hd_summon_claw_effects_s:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects_s:RemoveOnDeath() return false end
function modifier_item_hd_summon_claw_effects_s:OnCreated(keys)
    if not self:GetAbility() then return end
    self.ability = self:GetAbility()
    self.chance_2 = self:GetAbility():GetArtifactSpecialValueFor("chance_2")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_summon_claw_effects")
    self.spell_amp_1 = self.ability:GetArtifactSpecialValueFor("spell_amp_1")
    if IsServer() then
        self:StartIntervalThink(1)
    end
end
function modifier_item_hd_summon_claw_effects_s:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
    return funcs
end
function modifier_item_hd_summon_claw_effects_s:Advanced_GetModifierSpellAmplify_Percentage()
    return self.level >= 10 and self.spell_amp_1 or 0
end

function modifier_item_hd_summon_claw_effects_s:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
    local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local random = math.random
    if self.chance_2 >= random(1,100) then
	    for i=0, parent:GetAbilityCount() - 1 do
		    local Ability = parent:GetAbilityByIndex(i)
		    if Ability ~= nil and Ability ~= self  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
			    Ability:EndCooldown()
		    end
        end

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, parent)
        ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(particle, 1, parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
        parent:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
	end
end

---------
modifier_item_hd_summon_claw_effects_i = advanced_modifier({})

function modifier_item_hd_summon_claw_effects_i:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects_i:IsHidden() return true end
function modifier_item_hd_summon_claw_effects_i:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects_i:RemoveOnDeath() return false end
function modifier_item_hd_summon_claw_effects_i:OnCreated(keys)
    if not self:GetAbility() then return end
    self.ability = self:GetAbility()
    self.crit = {}
    self.chance_1 = self:GetAbility():GetArtifactSpecialValueFor("chance_1")
    self.crit_1 = self:GetAbility():GetArtifactSpecialValueFor("mult_1")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_summon_claw_effects")
    self.attack_speed_1 = self.ability:GetArtifactSpecialValueFor("attack_speed_1")
end
function modifier_item_hd_summon_claw_effects_i:OnDestroy() self.crit = nil end
function modifier_item_hd_summon_claw_effects_i:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
    return funcs
end
function modifier_item_hd_summon_claw_effects_i:DeclareFunctions() 
    return{
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    } 
end
function modifier_item_hd_summon_claw_effects_i:GetModifierAttackSpeedBonus_Constant()
    return self.level >= 10 and self.attack_speed_1 or 0
end
function modifier_item_hd_summon_claw_effects_i:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() then
		local pct = self.chance_1
		local random = math.random
		if pct > random(0,100) then
			self.crit[keys.record] = true
			local damage_mul = self.crit_1
			return damage_mul 
		else		
			return 0
		end
	end
end
function modifier_item_hd_summon_claw_effects_i:OnAttackFail(keys) self.crit[keys.record] = nil end
function modifier_item_hd_summon_claw_effects_i:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end
	self.crit[keys.record] = nil
end
---------
modifier_item_hd_summon_claw_effects_lv30 = advanced_modifier({})
function modifier_item_hd_summon_claw_effects_lv30:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects_lv30:IsHidden() return false end
function modifier_item_hd_summon_claw_effects_lv30:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects_lv30:GetTexture() return "item_artifact_28" end
function modifier_item_hd_summon_claw_effects_lv30:OnCreated(keys) 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.line_3 = self:GetAbility():GetArtifactSpecialValueFor("line_3")*0.01
    if IsServer() then
        self:SetStackCount(keys.stack)
    end
end
function modifier_item_hd_summon_claw_effects_lv30:ADDeclareFunctions() 
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_summon_claw_effects_lv30:DeclareFunctions() 
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_summon_claw_effects_lv30:OnTooltip(keys) 
    return self:GetStackCount()
end
function modifier_item_hd_summon_claw_effects_lv30:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if not self:GetAbility() then self:Destroy() return end
    if self:GetStackCount() > 0 and keys.damage >= self.parent:GetMaxHealth()*self.line_3 then
        self:SetStackCount(self:GetStackCount()-1)
        return -200
    end
end
---------
modifier_item_hd_summon_claw_effects_lv40 = advanced_modifier({})
function modifier_item_hd_summon_claw_effects_lv40:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects_lv40:IsHidden() return false end
function modifier_item_hd_summon_claw_effects_lv40:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects_lv40:GetTexture() return "item_artifact_28" end
function modifier_item_hd_summon_claw_effects_lv40:OnCreated(keys) 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    if IsServer() then
        self:SetStackCount(keys.outgoing)
    end
end
function modifier_item_hd_summon_claw_effects_lv40:ADDeclareFunctions() 
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_item_hd_summon_claw_effects_lv40:DeclareFunctions() 
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_hd_summon_claw_effects_lv40:OnTooltip(keys) 
    return self:GetStackCount()
end
function modifier_item_hd_summon_claw_effects_lv40:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys) 
    if not self:GetAbility() then self:Destroy() return end
    return self:GetStackCount()
end
---------
modifier_item_hd_summon_claw_effects_lv70 = advanced_modifier({})
function modifier_item_hd_summon_claw_effects_lv70:IsDebuff() return false end
function modifier_item_hd_summon_claw_effects_lv70:IsHidden() return true end
function modifier_item_hd_summon_claw_effects_lv70:IsPurgable() return false end
function modifier_item_hd_summon_claw_effects_lv70:OnCreated(keys) 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    if IsServer() then
        self:SetStackCount(keys.base_attack)
    end
end
function modifier_item_hd_summon_claw_effects_lv70:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end
function modifier_item_hd_summon_claw_effects_lv70:Advanced_GetModifierBaseAttack_BonusDamage()
    if not self:GetAbility() then self:Destroy() return end
    return self:GetStackCount()*(self:GetRemainingTime()/self.duration_7)
end
