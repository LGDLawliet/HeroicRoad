chaotic_era_buffskill_7 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_7", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_7_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_7_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_7", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_7:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_7"
end

modifier_chaotic_era_buffskill_7 = advanced_modifier({})

function modifier_chaotic_era_buffskill_7:IsDebuff() return false end
function modifier_chaotic_era_buffskill_7:IsHidden() return false end
function modifier_chaotic_era_buffskill_7:IsPurgable() return false end

function modifier_chaotic_era_buffskill_7:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.cut = self.ability:GetSpecialValueFor("cut")*0.01
	self.heal = self.ability:GetSpecialValueFor("heal")*0.01

    local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_swoop_parent.vpcf", PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self.parent, PATTACH_CENTER_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
end

function modifier_chaotic_era_buffskill_7:ADDeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
	return funcs
end

function modifier_chaotic_era_buffskill_7:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_7:OnAttackLanded(keys)
	if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
	if attacker ~= self.parent then return end
    if not target:IsAlive() then return end

	local cut = target:GetMaxHealth()*self.cut
    local current_health = target:GetHealth()
    local heal = attacker:GetMaxHealth()*self.heal
    if attacker:PassivesDisabled() then
        cut = cut*0.5
    end

    if current_health <= cut then
        if attacker:PassivesDisabled() then
            return
        end
        attacker:Heal(heal, self.ability) 
    else
        target:ModifyHealth(target:GetHealth()-cut, self.ability, false, 0)
    end
end