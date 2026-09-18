chaotic_tri_icemountain = class({})

LinkLuaModifier("modifier_chaotic_tri_icemountain", "chaotic_spell/class_7/chaotic_tri_icemountain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_icemountain_debuff", "chaotic_spell/class_7/chaotic_tri_icemountain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_icemountain_rune_3", "chaotic_spell/class_7/chaotic_tri_icemountain", LUA_MODIFIER_MOTION_NONE)

function chaotic_tri_icemountain:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_icemountain"
end

function chaotic_tri_icemountain:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
end

function chaotic_tri_icemountain:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function chaotic_tri_icemountain:GetCooldown(iLevel)
    if self:GetRuneType() == 1 then
        return self:GetSpecialValueFor("cooldown")*(1+ self:GetSpecialValueFor("rune_1_cd_up")*0.01)
    end
    return  self:GetSpecialValueFor("cooldown")
end
function chaotic_tri_icemountain:GetBehavior(vLocation, hTarget)
    if self:GetRuneType() == 3 then
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function chaotic_tri_icemountain:OnSpellStart()
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local location = self:GetCaster():GetAbsOrigin()
    local cost = self:GetSpecialValueFor("cost")
    if self:GetRuneType() == 1 then 
        self:IceMountain(location,radius,duration)
        return
    end

    local trigger = self:GetCaster():FindModifierByName("modifier_hd_trigger")
    if (trigger and trigger:GetStackCount() >= cost) then
        trigger:SetStackCount(trigger:GetStackCount()-cost)
        self:IceMountain(location,radius,duration)
        if self:GetRuneType() == 2 then
            self:GetCaster():GameTimer(self:GetSpecialValueFor("rune_2_delay"),function ()
            self:IceMountain(location,self:GetSpecialValueFor("rune_2_index")*0.01*radius,self:GetSpecialValueFor("rune_2_index_2")*0.01*duration)
            end)
        end
    end
end

function chaotic_tri_icemountain:IceMountain(location,radius,duration)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do 
        local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.3)
	    local StatusResistance = enemy:GetHDStatusResistanceIndex(0.8)*ModifierStatusNegativeGain
        enemy:AddNewModifier(caster,self,"modifier_chaotic_tri_icemountain_debuff",{duration = duration*StatusResistance})
    end

    -- 播放音效
    EmitSoundOnLocationWithCaster(location, "Hero_Crystal.CrystalNova", caster)
    -- 创建特效
    local particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",PATTACH_WORLDORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0, location)
    ParticleManager:SetParticleControl(particle, 1, Vector(1.5*radius, 300, radius))

    caster:GameTimer(2.2,function()
        ParticleManager:DestroyParticle(particle, true)
    end)
    
end
-------------------
modifier_chaotic_tri_icemountain = advanced_modifier({})

function modifier_chaotic_tri_icemountain:IsDebuff() return false end
function modifier_chaotic_tri_icemountain:IsHidden() return true end
function modifier_chaotic_tri_icemountain:IsPurgable() 		return false end
function modifier_chaotic_tri_icemountain:IsPurgeException() 	return false end
function modifier_chaotic_tri_icemountain:RemoveOnDeath()  return false end
function modifier_chaotic_tri_icemountain:OnCreated(keys)
    self.ability = self:GetAbility()
    self.cost = self:GetAbility():GetSpecialValueFor("cost") 
    self.cost_get = self:GetAbility():GetSpecialValueFor("cost_get") 
    self.duration = self:GetAbility():GetSpecialValueFor("duration")

    
end

function modifier_chaotic_tri_icemountain:ADDeclareFunctions()
    local funcs =  
    {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
    }
    if self:GetAbility():GetRuneType()==3 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL)
    end
    return funcs
end

function modifier_chaotic_tri_icemountain:OnTakeDamage(keys)
	if not IsServer() then return end
    local attacker = keys.attacker
    local unit = keys.unit
    if attacker ~= self:GetParent() then return end
    if not IsIceDamage(keys) then return end
    
    attacker:AddNewModifier(attacker,self:GetAbility(),"modifier_hd_trigger",{cost_get = self.cost_get})
end


function modifier_chaotic_tri_icemountain:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() then return end
    if not IsIceDamage(keys) then return end
    
    return self:GetAbility():GetSpecialValueFor("magic_res")*self:GetAbility():GetSpecialValueFor("rune_3_index")*0.01
end
-------------------

modifier_chaotic_tri_icemountain_debuff = advanced_modifier({})

function modifier_chaotic_tri_icemountain_debuff:IsDebuff() return true end
function modifier_chaotic_tri_icemountain_debuff:IsHidden() return false end
function modifier_chaotic_tri_icemountain_debuff:IsPurgable() return false end
-- function modifier_chaotic_tri_icemountain_debuff:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
-- function modifier_chaotic_tri_icemountain_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_tri_icemountain_debuff:OnCreated(keys)
    self.magic_res = self:GetAbility():GetSpecialValueFor("magic_res")
    if IsServer() then
	    self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	    ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	    self:AddParticle( self.nFXIndex, false, false, -1, true, false )
    end
end
function modifier_chaotic_tri_icemountain_debuff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end
function modifier_chaotic_tri_icemountain_debuff:OnRefresh(keys)
    self.magic_res = self:GetAbility():GetSpecialValueFor("magic_res")
end

function modifier_chaotic_tri_icemountain_debuff:CheckState()
    return{
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
    }
end
function modifier_chaotic_tri_icemountain_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end
function modifier_chaotic_tri_icemountain_debuff:GetModifierMagicalResistanceBonus()
    return -self.magic_res
end

-------------------

modifier_chaotic_tri_icemountain_rune_3 = advanced_modifier({})

function modifier_chaotic_tri_icemountain_rune_3:IsDebuff() return true end
function modifier_chaotic_tri_icemountain_rune_3:IsHidden() return true end
function modifier_chaotic_tri_icemountain_rune_3:IsPurgable() return false end
function modifier_chaotic_tri_icemountain_rune_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_chaotic_tri_icemountain_rune_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self:GetAbility():GetSpecialValueFor("rune_3_outgoing")
end

