chaotic_heavy_fortress = class({})
LinkLuaModifier("modifier_chaotic_heavy_fortress", "chaotic_spell/class_5/chaotic_heavy_fortress", LUA_MODIFIER_MOTION_NONE)

function chaotic_heavy_fortress:GetIntrinsicModifierName() return "modifier_chaotic_heavy_fortress" end

function chaotic_heavy_fortress:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_not_falling_fortress/buff/pangolier_ti8_immortal_shield_buff.vpcf", context )
end

function chaotic_heavy_fortress:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local modifier = caster:FindModifierByName("modifier_chaotic_heavy_fortress")
    EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
    modifier:SetDuration(duration, true)

    self.type = self:GetRuneType()
    if self.type == 1 then
        caster:Purge(false, true, false, true, true)
    end
end



modifier_chaotic_heavy_fortress = advanced_modifier({})

function modifier_chaotic_heavy_fortress:IsDebuff()			return false end
function modifier_chaotic_heavy_fortress:IsHidden() 		return false end
function modifier_chaotic_heavy_fortress:IsPurgable() 		return false end
function modifier_chaotic_heavy_fortress:IsPurgeException() return false end
function modifier_chaotic_heavy_fortress:DestroyOnExpire() return false end
function modifier_chaotic_heavy_fortress:ADDeclareFunctions()
    local funcs =
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        
    }
    if self.type == 1 then
       table.insert(funcs,advanced_MODIFIER_PROPERTY_StatusResistance) 
    end
    return funcs
end

function modifier_chaotic_heavy_fortress:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction =  -self.ability:GetSpecialValueFor("damage_reduction")
    self.bonus_damage_reduction =  -self.ability:GetSpecialValueFor("bonus_damage_reduction")
    self.bonus_damage =  self.ability:GetSpecialValueFor("bonus_damage")
    self.duration = 0
    self.duration_record = 0
    self.type = self.ability:GetRuneType()
    self.rune_1_status = self.ability:GetSpecialValueFor("rune_1_status")
    if IsServer() then
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

function modifier_chaotic_heavy_fortress:OnRefresh() 
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction =  -self.ability:GetSpecialValueFor("damage_reduction")
    self.bonus_damage_reduction =  -self.ability:GetSpecialValueFor("bonus_damage_reduction")
    self.bonus_damage =  self.ability:GetSpecialValueFor("bonus_damage")
    self.type = self.ability:GetRuneType()
    self.rune_1_status = self.ability:GetSpecialValueFor("rune_1_status")
end
function modifier_chaotic_heavy_fortress:Advanced_GetModifier_StatusResistance()
    if not self.ability then return end
    return self.rune_1_status
end
function modifier_chaotic_heavy_fortress:Advanced_GetModifierIncomingDamage_Percentage(keys)
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
	return reduce
end



function modifier_chaotic_heavy_fortress:OnIntervalThink()
    local duration = self:GetRemainingTime()
    if duration<= 0 then
        if self.effect_buff then
            ParticleManager:DestroyParticle(self.effect_buff, true)
            self.effect_buff = nil
        end
        return
    end
    if not self.effect_buff then
        self.effect_buff = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_not_falling_fortress/buff/pangolier_ti8_immortal_shield_buff.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( self.effect_buff,3, Vector(150,1,1) )
        ParticleManager:SetParticleControlEnt( self.effect_buff, 1, self.parent, PATTACH_POINT_FOLLOW,nil , self.parent:GetOrigin(), true )
        self.parent:EmitSound("Hero_Mars.Shield.Block")
        self:AddParticle(self.effect_buff, false, false, -1, false, false)

    end
end

function modifier_chaotic_heavy_fortress:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_heavy_fortress:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 1 + 1

    if self._tooltip == 1 then

        return self:Advanced_GetModifierIncomingDamage_Percentage()
    end   
end



function modifier_chaotic_heavy_fortress:CheckState()
    if self.effect_buff then
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