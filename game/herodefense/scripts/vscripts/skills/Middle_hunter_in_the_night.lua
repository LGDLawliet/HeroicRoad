Middle_hunter_in_the_night = class({})

LinkLuaModifier("modifier_Middle_hunter_in_the_night", "skills/Middle_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_hunter_in_the_night_active", "skills/Middle_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_hunter_in_the_night_debuff", "skills/Middle_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function Middle_hunter_in_the_night:GetIntrinsicModifierName() return "modifier_Middle_hunter_in_the_night" end


modifier_Middle_hunter_in_the_night= advanced_modifier({})

function modifier_Middle_hunter_in_the_night:IsDebuff()			return false end
function modifier_Middle_hunter_in_the_night:IsHidden() 			return true end
function modifier_Middle_hunter_in_the_night:IsPurgable() 		return false end
function modifier_Middle_hunter_in_the_night:IsPurgeException() 	return false end

function modifier_Middle_hunter_in_the_night:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.spattack = (self:GetAbility():GetSpecialValueFor("spattack") - 100)
	
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	

	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Middle_hunter_in_the_night:OnDestroy()
	if not IsServer() then
		return
	end
	-- 清除重击标记
	local caster = self:GetParent()
	local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        100000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByNameAndCaster("modifier_Middle_hunter_in_the_night_debuff",caster)
        if modifier then
			modifier:SafeDestroy()
		end
    end
end

function modifier_Middle_hunter_in_the_night:OnIntervalThink()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.spattack = (self:GetAbility():GetSpecialValueFor("spattack") - 100)

	local caster = self:GetParent()

	-- 重击标记
	local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, nil, "modifier_Middle_hunter_in_the_night_debuff", {duration = self.interval})
        break
    end

	-- 黑夜白天判断
	if not self:GetParent():IsInNightTime() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_night_stalker_2") then
		self:SetStackCount(1)
	end
end

function modifier_Middle_hunter_in_the_night:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	} 
end

function modifier_Middle_hunter_in_the_night:ADDeclareFunctions() 
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	} 
end

function modifier_Middle_hunter_in_the_night:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()==1 and self:GetAbility():GetSpecialValueFor("bonus_move_speed") or 0 end
function modifier_Middle_hunter_in_the_night:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()==1 and self:GetAbility():GetSpecialValueFor("bonus_attack_speed") or 0 end

function modifier_Middle_hunter_in_the_night:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target
	local modifier = target:FindModifierByName("modifier_Middle_hunter_in_the_night_debuff")
	if not modifier then
		return
	end
	if attacker ~= self:GetParent() then
		return
	end
	local night = self:GetParent():IsInNightTime()
	if not night and target:GetHealthPercent() > self.line then
		return
	end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then
        return
    end
	
	local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/hunter_in_the_night/spattack.vpcf", PATTACH_ABSORIGIN, keys.target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, keys.target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	return self.spattack
end
-------------------------------------

modifier_Middle_hunter_in_the_night_debuff= advanced_modifier({})

function modifier_Middle_hunter_in_the_night_debuff:IsDebuff()			return true end
function modifier_Middle_hunter_in_the_night_debuff:IsHidden() 			return false end
function modifier_Middle_hunter_in_the_night_debuff:IsPurgable() 		return false end
function modifier_Middle_hunter_in_the_night_debuff:IsPurgeException() 	return false end
function modifier_Middle_hunter_in_the_night_debuff:GetEffectName()	return "particles/rebuild/spell/hunter_in_the_night/debuff.vpcf" end
function modifier_Middle_hunter_in_the_night_debuff:GetEffectAttachType()  return PATTACH_ABSORIGIN_FOLLOW end




