      
item_chaotic_sword_of_seven = class({})
LinkLuaModifier("modifier_item_chaotic_sword_of_seven", "items/item_chaotic_sword_of_seven", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_sword_of_seven_debuff", "items/item_chaotic_sword_of_seven", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_sword_of_seven_active_debuff", "items/item_chaotic_sword_of_seven", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_sword_of_seven_active", "items/item_chaotic_sword_of_seven", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_sword_of_seven:GetIntrinsicModifierName()
	return "modifier_item_chaotic_sword_of_seven"
end
function item_chaotic_sword_of_seven:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/elemental_weapon/cast_effect/effect.vpcf", context )
end
function item_chaotic_sword_of_seven:OnSpellStart()
	local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster, self, "modifier_item_chaotic_sword_of_seven_active", {duration = duration})

    local particle_cast = "particles/rebuild/chaotic_spell/elemental_weapon/cast_effect/effect.vpcf"

	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
	ParticleManager:SetParticleControl(particle_cast_fx, 2, caster:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
end

---------------------------------
modifier_item_chaotic_sword_of_seven = advanced_modifier({})
function modifier_item_chaotic_sword_of_seven:IsDebuff() return false end
function modifier_item_chaotic_sword_of_seven:IsHidden() return true end
function modifier_item_chaotic_sword_of_seven:IsPurgable() return false end
function modifier_item_chaotic_sword_of_seven:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.duration = self.ability:GetSpecialValueFor("duration_p")
    self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
end
function modifier_item_chaotic_sword_of_seven:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_chaotic_sword_of_seven:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end
function modifier_item_chaotic_sword_of_seven:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_item_chaotic_sword_of_seven:OnAttackLanded(keys)
	if not IsServer() then return end
    if not self:GetAbility() then return end
    
    local attacker = keys.attacker
    local target = keys.target                                                                                  
    if attacker ~= self.parent or not target:IsAlive() then return end

    --local ModifierStatusNegativeGain = attacker:GetModifierStatusNegativeGainIndex(1)
    --local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
    local modifier = target:FindModifierByName("modifier_item_chaotic_sword_of_seven_debuff")
    if modifier then
        modifier:ForceRefresh()
        modifier:SetDuration(self.duration, true)
    else
        target:AddNewModifier(attacker, self.ability, "modifier_item_chaotic_sword_of_seven_debuff", {duration = self.duration})
    end
end
---------------------------------
modifier_item_chaotic_sword_of_seven_active = advanced_modifier({})
function modifier_item_chaotic_sword_of_seven_active:IsDebuff() return false end
function modifier_item_chaotic_sword_of_seven_active:IsHidden() return false end
function modifier_item_chaotic_sword_of_seven_active:IsPurgable() return false end
function modifier_item_chaotic_sword_of_seven_active:GetTexture() return "item_dark_sword" end
function modifier_item_chaotic_sword_of_seven_active:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.freezing = self.ability:GetSpecialValueFor("freezing")
end

function modifier_item_chaotic_sword_of_seven_active:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
end

function modifier_item_chaotic_sword_of_seven_active:OnAttackLanded(keys)
	if not IsServer() then return end
    if not self:GetAbility() then return end
    
    local attacker = keys.attacker
    local target = keys.target                                                                                  
    if attacker ~= self.parent or not target:IsAlive() then return end

    local freezing = self.freezing*attacker:HDGetPrimaryStatValue()
    target:Freezing(attacker, self.ability, freezing)
    local modifier = target:FindModifierByName("modifier_item_chaotic_sword_of_seven_active_debuff")
    if modifier then
        modifier:ForceRefresh()
        modifier:SetDuration(0.5, true)
    else
        target:AddNewModifier(attacker, self.ability, "modifier_item_chaotic_sword_of_seven_active_debuff", {duration = 0.5})
    end
end

----------------------------------
modifier_item_chaotic_sword_of_seven_debuff = advanced_modifier({})

function modifier_item_chaotic_sword_of_seven_debuff:IsDebuff() return true end
function modifier_item_chaotic_sword_of_seven_debuff:IsHidden() return false end
function modifier_item_chaotic_sword_of_seven_debuff:IsPurgable() return false end
function modifier_item_chaotic_sword_of_seven_debuff:GetTexture() return "item_dark_sword" end
function modifier_item_chaotic_sword_of_seven_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.hp_recive_down = self.ability:GetSpecialValueFor("hp_recive_down")
end
function modifier_item_chaotic_sword_of_seven_debuff:OnRefresh()
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
	self.hp_recive_down = self.ability:GetSpecialValueFor("hp_recive_down")
end

function modifier_item_chaotic_sword_of_seven_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE
    }
end

function modifier_item_chaotic_sword_of_seven_debuff:AdvancedGetModifierConstantHealthRegenAmpPercentage(keys)
	if not self:GetAbility() then self:Destroy() return end
	return -self.hp_recive_down
end
function modifier_item_chaotic_sword_of_seven_debuff:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	if not self:GetAbility() then self:Destroy() return end
	return -self.hp_recive_down
end
----------------------------------
modifier_item_chaotic_sword_of_seven_active_debuff = advanced_modifier({})

function modifier_item_chaotic_sword_of_seven_active_debuff:IsDebuff() return true end
function modifier_item_chaotic_sword_of_seven_active_debuff:IsHidden() return false end
function modifier_item_chaotic_sword_of_seven_active_debuff:IsPurgable() return false end
function modifier_item_chaotic_sword_of_seven_active_debuff:GetTexture() return "item_dark_sword" end
function modifier_item_chaotic_sword_of_seven_active_debuff:CheckState(keys)
	return{
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end





    