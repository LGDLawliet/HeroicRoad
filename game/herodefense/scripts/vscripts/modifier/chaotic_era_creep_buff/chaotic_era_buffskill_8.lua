chaotic_era_buffskill_8 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_8", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_8", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_8_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_8", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_8_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_8", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_8:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_8"
end

modifier_chaotic_era_buffskill_8 = advanced_modifier({})

function modifier_chaotic_era_buffskill_8:IsDebuff() return false end
function modifier_chaotic_era_buffskill_8:IsHidden() return false end
function modifier_chaotic_era_buffskill_8:IsPurgable() return false end

function modifier_chaotic_era_buffskill_8:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.mana = self.ability:GetSpecialValueFor("mana")*0.01
    self.hp = self.ability:GetSpecialValueFor("hp")*0.01
end

function modifier_chaotic_era_buffskill_8:ADDeclareFunctions()
	local funcs = {
	}
	return funcs
end

function modifier_chaotic_era_buffskill_8:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_chaotic_era_buffskill_8:OnAbilityExecuted(params)
    if not IsServer() then return end
    local unit = params.unit
    if not IsEnemy(unit,self.parent) then return end
    if not self.ability:IsCooldownReady() then return end
    local ability = params.ability
    local radius = self.radius
    if not unit:IsAlive() then return end
    if ability and ability:IsItem() then return end
    
    self.ability:UseResources(true, true, true, true)
    if self.parent:PassivesDisabled() then
        radius = radius*0.5
    end
    if CalculateDistance(unit,self.parent) > radius then return end
    
    local cut_hp = unit:GetHealth()*self.hp
    local cut_mp = unit:GetMana()*self.mana
    if unit:IsMagicImmune() then
        cut_hp = cut_hp*0.5
        cut_mp = cut_mp*0.5
    end
    unit:ModifyHealth(unit:GetHealth()-cut_hp, self.ability, false, 0)
    unit:Script_ReduceMana(cut_mp, self.ability)

    local pfx = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:ReleaseParticleIndex(pfx)
    unit:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
end
