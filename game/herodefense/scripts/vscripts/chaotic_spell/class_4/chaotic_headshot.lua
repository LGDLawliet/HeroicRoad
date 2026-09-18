LinkLuaModifier( "modifier_chaotic_headshot", "chaotic_spell/class_4/chaotic_headshot.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_headshot_debuff", "chaotic_spell/class_4/chaotic_headshot.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_headshot = class({})
function chaotic_headshot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
end
function chaotic_headshot:GetIntrinsicModifierName()
	return "modifier_chaotic_headshot"
end
-----
modifier_chaotic_headshot = advanced_modifier({})
function modifier_chaotic_headshot:IsHidden()	return self.type ~= 1 end
function modifier_chaotic_headshot:IsPurgable()	return false end
function modifier_chaotic_headshot:DestroyOnExpire()	return false end
function modifier_chaotic_headshot:RemoveOnDeath()	return false end

function modifier_chaotic_headshot:OnCreated( kv )
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.chance = self.ability:GetSpecialValueFor("chance") 
    self.attack = self.ability:GetSpecialValueFor("attack")
    self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.duration = self.ability:GetSpecialValueFor("duration") 

    self.type = self.ability:GetRuneType()
    self.rune_1_chance = self.ability:GetSpecialValueFor("rune_1_chance")
    self.rune_1_index = self.ability:GetSpecialValueFor("rune_1_index")*0.01
    self.rune_1_cd = self.ability:GetSpecialValueFor("rune_1_cd")
end

function modifier_chaotic_headshot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
	}
	return funcs
end

function modifier_chaotic_headshot:GetModifierPreAttack_BonusDamagePostCrit(keys)
	if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
    if attacker ~= self.parent then return end
    if not attacker:IsAlive() or not target:IsAlive() or target:IsMagicImmune() or attacker:PassivesDisabled() then return end

    local random = math.random
    if self.chance >= random(1,100) then
		
        local debuff = target:FindModifierByName("modifier_chaotic_headshot_debuff")
		if debuff then
            debuff:ForceRefresh()
            debuff:SetDuration(self.duration, true)
        else
			target:AddNewModifier(attacker, self.ability, "modifier_chaotic_headshot_debuff", {duration = self.duration})
		end
        target:EmitSound("Hero_Sniper.MKG_impact")
        local attack = self.attack + self.bonus_attack*attacker:GetAverageTrueAttackDamage(nil)

        if self.type == 1 and self:GetRemainingTime() <= 0 and target:IsChaoticEraElite() then
            if self.rune_1_chance >= random(1,100) then
                attack = attack * self.rune_1_index
                self:SetDuration(self.rune_1_cd, true)
                attacker:EmitSound("Ability.Assassinate")
                fSendCustomOverheadEventMessage("crit", attacker, attack, nil, nil, Vector(255, 201, 66), 4)
            end
        end

		return attack
    end
end







modifier_chaotic_headshot_debuff = advanced_modifier({})
function modifier_chaotic_headshot_debuff:IsHidden()	return false end
function modifier_chaotic_headshot_debuff:IsDebuff()	return true end
function modifier_chaotic_headshot_debuff:IsPurgable()	return false end
function modifier_chaotic_headshot_debuff:OnCreated( kv )
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.move_slow = self.ability:GetSpecialValueFor("move_slow") 
    self.crit_incoming = self.ability:GetSpecialValueFor("crit_incoming")
end
function modifier_chaotic_headshot_debuff:OnRefresh( kv )
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.move_slow = self.ability:GetSpecialValueFor("move_slow") 
    self.crit_incoming = self.ability:GetSpecialValueFor("crit_incoming")
end
function modifier_chaotic_headshot_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_chaotic_headshot_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET,
    }
end
function modifier_chaotic_headshot_debuff:Advanced_GetModifierCriticalStrikeDamageTarget(keys)
    if not self.ability then self:Destroy() return end
	return self.crit_incoming
end
function modifier_chaotic_headshot_debuff:GetModifierMoveSpeedBonus_Constant()
    if not self.ability then self:Destroy() return end
	return -self.move_slow
end
function modifier_chaotic_headshot_debuff:GetEffectName()
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end
function modifier_chaotic_headshot_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end