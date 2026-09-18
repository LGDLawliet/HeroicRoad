chaotic_Battle_Hunger = class({})

LinkLuaModifier("modifier_chaotic_Battle_Hunger_caster", "chaotic_spell/class_8/chaotic_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Battle_Hunger_enemy", "chaotic_spell/class_8/chaotic_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)

function chaotic_Battle_Hunger:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	return true
end

function chaotic_Battle_Hunger:OnAbilityPhaseInterrupted() self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_2) end
function chaotic_Battle_Hunger:GetIntrinsicModifierName() return "modifier_chaotic_Battle_Hunger_caster" end
function chaotic_Battle_Hunger:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	if self:GetRuneType() == 1 then
		radius = radius*(self:GetSpecialValueFor("rune_1_radius")*0.01)
	end
    return radius
end

function chaotic_Battle_Hunger:GetCastRange()
	if self:GetRuneType() == 1 then
		local radius = self:GetSpecialValueFor("radius")*(self:GetSpecialValueFor("rune_1_radius")*0.01)
		return radius
	end
    return 1000
end

function chaotic_Battle_Hunger:GetBehavior()
	if self:GetRuneType() == 1 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return self.BaseClass.GetBehavior( self )
end

function chaotic_Battle_Hunger:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

	if self:GetRuneType() == 1 then
		duration = duration + self:GetSpecialValueFor("rune_1_duration")
		target = caster
	end

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _ , enemy in pairs(enemies) do
        self:PlayEffects(enemy,duration)
    end
end

function chaotic_Battle_Hunger:PlayEffects(target,duration)
    if not target then return end
    local duration = duration or 10
    local caster = self:GetCaster()

	target:AddNewModifier(caster, self, "modifier_chaotic_Battle_Hunger_enemy", {duration = duration})
	target:EmitSound("Hero_Axe.Battle_Hunger")
end
-----------------------------------------------------
modifier_chaotic_Battle_Hunger_caster =advanced_modifier({})

function modifier_chaotic_Battle_Hunger_caster:IsDebuff()				return false end
function modifier_chaotic_Battle_Hunger_caster:IsPurgable() 			return false end
function modifier_chaotic_Battle_Hunger_caster:IsPurgeException() 		return false end
function modifier_chaotic_Battle_Hunger_caster:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

function modifier_chaotic_Battle_Hunger_caster:OnCreated()
    if not self:GetAbility() then self:Destroy() return end
    self.incoming_each =  self:GetAbility():GetSpecialValueFor("incoming_each")
    self.incoming_max =  self:GetAbility():GetSpecialValueFor("incoming_max")
end

function modifier_chaotic_Battle_Hunger_caster:OnRefresh()
    if not self:GetAbility() then self:Destroy() return end
    self.incoming_each =  self:GetAbility():GetSpecialValueFor("incoming_each")
    self.incoming_max =  self:GetAbility():GetSpecialValueFor("incoming_max")
end
function modifier_chaotic_Battle_Hunger_caster:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOOLTIP,}
end
function modifier_chaotic_Battle_Hunger_caster:ADDeclareFunctions()
	return {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,}
end

function modifier_chaotic_Battle_Hunger_caster:Advanced_GetModifierIncomingDamage_Percentage() 
    if not self:GetAbility() then self:Destroy() return end
    
    return -math.min(self:GetStackCount()*self.incoming_each ,self.incoming_max)
end
function modifier_chaotic_Battle_Hunger_caster:OnTooltip()
	return math.min(self:GetStackCount()*self.incoming_each ,self.incoming_max)
end
--------------------------------------------------------
modifier_chaotic_Battle_Hunger_enemy = advanced_modifier({})

function modifier_chaotic_Battle_Hunger_enemy:IsDebuff()				return true end
function modifier_chaotic_Battle_Hunger_enemy:IsPurgable() 			return true end
function modifier_chaotic_Battle_Hunger_enemy:IsPurgeException() 		return false end
function modifier_chaotic_Battle_Hunger_enemy:IsHidden()				return false end
function modifier_chaotic_Battle_Hunger_enemy:GetEffectName() return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf" end
function modifier_chaotic_Battle_Hunger_enemy:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_chaotic_Battle_Hunger_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_Battle_Hunger_enemy:ShouldUseOverheadOffset() return true end


function modifier_chaotic_Battle_Hunger_enemy:OnCreated()
	if not IsServer() then
		return 
	end
    if not self:GetAbility() then self:Destroy() return end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.extra_damage = self:GetAbility():GetSpecialValueFor("extra_damage")
    self.hp_damage = self:GetAbility():GetSpecialValueFor("hp_damage")*0.01

	self.dmg = self.damage + self:GetCaster():HDGetPrimaryStatValue()*self.extra_damage + self:GetCaster():GetMaxHealth()*self.hp_damage

	if self:GetCaster():HasModifier("modifier_chaotic_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_chaotic_Battle_Hunger_caster"):IncrementStackCount()
	end
	self:StartIntervalThink(1.0)
end

function modifier_chaotic_Battle_Hunger_enemy:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end

	local damageTable = {
							victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = self.dmg,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
							ability = ability, --Optional.
                            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
							}
	ApplyDamage(damageTable)
end

function modifier_chaotic_Battle_Hunger_enemy:OnDestroy()
	if not IsServer() then
		return 
	end
	if self:GetCaster():HasModifier("modifier_chaotic_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_chaotic_Battle_Hunger_caster"):DecrementStackCount()
	end
end
