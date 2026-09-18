chaotic_era_buffskill_9 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_9", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_9", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_9_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_9", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_9_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_9", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_9:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_9"
end

modifier_chaotic_era_buffskill_9 = advanced_modifier({})

function modifier_chaotic_era_buffskill_9:IsDebuff() return false end
function modifier_chaotic_era_buffskill_9:IsHidden() return false end
function modifier_chaotic_era_buffskill_9:IsPurgable() return false end
function modifier_chaotic_era_buffskill_9:GetEffectName() return "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf" end
function modifier_chaotic_era_buffskill_9:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_era_buffskill_9:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.incoming_max = self.ability:GetSpecialValueFor("incoming_max")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.stack = self.ability:GetSpecialValueFor("stack")
end

function modifier_chaotic_era_buffskill_9:ADDeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        MODIFIER_EVENT_ON_DEATH = {nil,nil}
	}
	return funcs
end

function modifier_chaotic_era_buffskill_9:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_9:OnAttackLanded(keys)
	if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
	if attacker ~= self.parent then return end
    if not target:IsAlive() then return end

    local ModifierStatusNegativeGain = attacker:GetModifierStatusNegativeGainIndex(0.6)
    local StatusResistance = target:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
    local duration_f = self.duration*StatusResistance
    if target:IsMagicImmune() then 
        duration_f = duration_f *0.25
    end

    local modifier = target:FindModifierByName("modifier_chaotic_era_buffskill_9_debuff")
    if modifier then
        modifier:SetStackCount(math.min(modifier:GetStackCount()+self.incoming, self.incoming_max))
        modifier:SetDuration(duration_f, true)
    else
        local debuff = target:AddNewModifier(attacker, self.ability, "modifier_chaotic_era_buffskill_9_debuff", {duration = duration_f})
        debuff:SetStackCount(self.incoming)
    end
end

function modifier_chaotic_era_buffskill_9:OnDeath(keys)
	if not IsServer() then return end
    local unit = keys.unit
    local parent = self:GetParent()
    if unit ~= parent then return end
    
    local units = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil,  self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)  
	for i, ally in pairs(units) do
        local modifier = ally:FindModifierByName("modifier_chaotic_era_buffskill_9_debuff")
        if modifier then
            modifier:SetStackCount(math.max(modifier:GetStackCount()-self.stack, 0))
            if keys.attacker and ally == keys.attacker then
               modifier:Destroy() 
            end
        end
    end
end

modifier_chaotic_era_buffskill_9_debuff = advanced_modifier({})

function modifier_chaotic_era_buffskill_9_debuff:IsDebuff() return true end
function modifier_chaotic_era_buffskill_9_debuff:IsHidden() return false end
function modifier_chaotic_era_buffskill_9_debuff:IsPurgable() return false end
function modifier_chaotic_era_buffskill_9_debuff:GetEffectName() return "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_dot.vpcf" end
function modifier_chaotic_era_buffskill_9_debuff:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_9_debuff:GetTexture() return "witch_doctor_maledict" end
function modifier_chaotic_era_buffskill_9_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

	}
	return funcs
end

function modifier_chaotic_era_buffskill_9_debuff:Advanced_GetModifierIncomingDamage_Percentage() 
    return self:GetStackCount()
end

function modifier_chaotic_era_buffskill_9_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_9_debuff:OnTooltip()
	return self:GetStackCount()
end

