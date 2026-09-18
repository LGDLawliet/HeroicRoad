chaotic_not_falling_fortress = class({})
LinkLuaModifier("modifier_chaotic_not_falling_fortress", "chaotic_spell/class_8/chaotic_not_falling_fortress", LUA_MODIFIER_MOTION_NONE)

function chaotic_not_falling_fortress:GetIntrinsicModifierName() return "modifier_chaotic_not_falling_fortress" end



function chaotic_not_falling_fortress:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_not_falling_fortress/effect_pos/effect_defense.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_not_falling_fortress/buff/pangolier_ti8_immortal_shield_buff.vpcf", context )
end

function chaotic_not_falling_fortress:OnSpellStart()

    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local modifier = caster:FindModifierByName("modifier_chaotic_not_falling_fortress")
    EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
    modifier:SetDuration(duration, true)
end



modifier_chaotic_not_falling_fortress = advanced_modifier({})

function modifier_chaotic_not_falling_fortress:IsDebuff()			return false end
function modifier_chaotic_not_falling_fortress:IsHidden() 		return false end
function modifier_chaotic_not_falling_fortress:IsPurgable() 		return false end
function modifier_chaotic_not_falling_fortress:IsPurgeException() return false end
function modifier_chaotic_not_falling_fortress:DestroyOnExpire() return false end
function modifier_chaotic_not_falling_fortress:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_chaotic_not_falling_fortress:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction =  -self.ability:GetSpecialValueFor("damage_reduction")
    self.bonus_damage_reduction =  -self.ability:GetSpecialValueFor("bonus_damage_reduction")
    self.damage_threshold =  self.ability:GetSpecialValueFor("damage_threshold")*0.01
    self.bonus_armor =  self.ability:GetSpecialValueFor("bonus_armor")
    self.bonus_armor_record = 0
    self.bonus_armor_max =  self.ability:GetSpecialValueFor("bonus_armor_max")
    self.damage_record = 0
    self.bonus_damage =  self.ability:GetSpecialValueFor("bonus_damage")

    if IsServer() then
        self:SetHasCustomTransmitterData( true )
        self.damageTable = {
            -- victim = keys.attacker,
            attacker = self.parent,
            -- damage = self.parent:GetPhysicalArmorValue(false) * self.bonus_damage * self.ability:GetEffectGain(),
            damage_type = self.ability:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
            ability = self.ability,
        }
        self:StartIntervalThink(0.1)
    end
end

function modifier_chaotic_not_falling_fortress:OnRefresh() 
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction =  -self.ability:GetSpecialValueFor("damage_reduction")
    self.bonus_damage_reduction =  -self.ability:GetSpecialValueFor("bonus_damage_reduction")
    self.damage_threshold =  self.ability:GetSpecialValueFor("damage_threshold")*0.01
    self.bonus_armor =  self.ability:GetSpecialValueFor("bonus_armor")
    self.bonus_armor_max =  self.ability:GetSpecialValueFor("bonus_armor_max")
    self.bonus_damage =  self.ability:GetSpecialValueFor("bonus_damage")
end

-- function modifier_chaotic_not_falling_fortress:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
-- 	if IsClient() then
-- 		return 0
-- 	end
-- 	if keys.block_disabled then
--         return 0 
--     end
--     if self:GetParent():PassivesDisabled() then
--         return 0
--     end

-- 	local block = keys.damage * self.damage_reduction * 0.01

--     if self.duration_record > 0 then
--         block = keys.damage * self.bonus_damage_reduction * 0.01
--         local damageTable = {
-- 			victim = keys.attacker,
-- 			attacker = self.parent,
-- 			damage = self.parent:GetPhysicalArmorValue(false) * self.bonus_damage * self.ability:GetEffectGain(),
-- 			damage_type = self:GetAbility():GetAbilityDamageType(),
-- 			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
-- 			ability = self.ability,
-- 		}
--         ApplyDamage(damageTable)        
--     end

--     self.damage_record = self.damage_record + block

--     self:SetStackCount(self.damage_record)

--     if self.damage_record >= self.parent:GetMaxHealth() * self.damage_threshold  then
--         self.bonus_armor_record = math.min(self.bonus_armor_record + self.bonus_armor,self.bonus_armor_max)
--         self:SetStackCount(0)
--         self.damage_record = 0
--     end

--     return math.min(keys.damage,block) 

-- end

function modifier_chaotic_not_falling_fortress:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()

	local reduce =   self.damage_reduction
    if self:GetRemainingTime()>0 then
        reduce = self.bonus_damage_reduction
    else
        if parent:PassivesDisabled() or parent:IsIllusion() then	
            return 0
        end
    end
    


	if IsClient() then
		return reduce
	end
	--不反弹刃甲
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	--生命丢失不减免
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
    if self:GetRemainingTime()>0 and keys.damage >=10 and keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK   then
        if IsEnemy(keys.attacker,self.parent) then
            -- local passive = self:GetAbility()
            local armor = self.parent:GetPhysicalArmorValue(false)
            if armor>5 then
                self.damageTable.victim = keys.attacker
                self.damageTable.damage =armor * self.bonus_damage * self.ability:GetEffectGain()
                if self.damageTable.damage>0 then
                    ApplyDamage(self.damageTable)
                end
                
            end
        end
        
        
    end
    local block = keys.damage * (-reduce) * 0.01
    self.damage_record = self.damage_record + block

    self:SetStackCount(self.damage_record)
    if self.damage_record >= self.parent:GetMaxHealth() * self.damage_threshold  then
        self.bonus_armor_record = math.min(self.bonus_armor_record + self.bonus_armor,self.bonus_armor_max)
        self:SetStackCount(0)
        self.damage_record = 0
        self:SendBuffRefreshToClients()
    end

	return reduce
end


function modifier_chaotic_not_falling_fortress:OnIntervalThink()
    local duration = self:GetRemainingTime()
    if duration<= 0 then
        if self.effect_cast then
            ParticleManager:DestroyParticle(self.effect_cast, true)
            self.effect_cast = nil
        end
        if self.effect_buff then
            ParticleManager:DestroyParticle(self.effect_buff, true)
            self.effect_buff = nil
        end        
        return
    end
    if not self.effect_cast then
        self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_not_falling_fortress/effect_pos/effect_defense.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( self.effect_cast,10, self.parent:GetOrigin() )
        ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW,nil , self.parent:GetOrigin(), true )
        ParticleManager:SetParticleControlForward(self.effect_cast, 0,self.parent:GetForwardVector())
        self:AddParticle(self.effect_cast, false, false, -1, false, false)
        self.parent:EmitSound("Hero_Mars.Spear.Root")
    end
    if not self.effect_buff then
        self.effect_buff = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_not_falling_fortress/buff/pangolier_ti8_immortal_shield_buff.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( self.effect_buff,3, Vector(150,1,1) )
        ParticleManager:SetParticleControlEnt( self.effect_buff, 1, self.parent, PATTACH_POINT_FOLLOW,nil , self.parent:GetOrigin(), true )
        self:AddParticle(self.effect_buff, false, false, -1, false, false)

        self.parent:EmitSound("Hero_Mars.Shield.Block")
    end
end

function modifier_chaotic_not_falling_fortress:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor_record
end

function modifier_chaotic_not_falling_fortress:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_not_falling_fortress:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 2 + 1

    if self._tooltip == 1 then
        return self:Advanced_GetModifierIncomingDamage_Percentage()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierPhysicalArmorBonus()
    end     
    
end

function modifier_chaotic_not_falling_fortress:AddCustomTransmitterData()
	return
	{

		bonus_armor_record = self.bonus_armor_record,
	}
end

function modifier_chaotic_not_falling_fortress:HandleCustomTransmitterData(data)
	self.bonus_armor_record = data.bonus_armor_record
end

function modifier_chaotic_not_falling_fortress:CheckState()

    if self.effect_buff then
        if self:GetAbility():GetRuneType()==1 then
            return
        end
        local state = {
            [MODIFIER_STATE_ROOTED] = true,
            [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
            [MODIFIER_STATE_DISARMED] = true,
            [MODIFIER_STATE_SILENCED] = true,
            [MODIFIER_STATE_FROZEN] = true,
        }
        return state
    end
    return
end