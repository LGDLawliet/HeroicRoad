chaotic_ice_age = class({})
LinkLuaModifier("modifier_chaotic_ice_age", "chaotic_spell/class_super/chaotic_ice_age", LUA_MODIFIER_MOTION_NONE)
function chaotic_ice_age:Precache( context )
	PrecacheResource( "particle", "particles/rebuid/chaotic_spell/chaotic_ice_age/effect.vpcf", context )
end
function chaotic_ice_age:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function chaotic_ice_age:GetManaCost(iLevel)
    if self:GetRuneType()==3 then
        return 0
    end
    return self.BaseClass.GetManaCost(self,iLevel)
end
function chaotic_ice_age:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    caster:AddNewModifier(caster, self, "modifier_chaotic_ice_age", {duration = duration})
end

modifier_chaotic_ice_age = advanced_modifier({})

function modifier_chaotic_ice_age:IsHidden()return false end
function modifier_chaotic_ice_age:IsDebuff()return false end
function modifier_chaotic_ice_age:IsPurgable()return false end

function modifier_chaotic_ice_age:OnCreated()
    self.interval = self:GetAbility():GetSpecialValueFor("interval")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.mana_cost = self:GetAbility():GetSpecialValueFor("mana_cost")*0.01
    self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get")*0.01
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_chaotic_ice_age:OnRefresh()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.mana_cost = self:GetAbility():GetSpecialValueFor("mana_cost")*0.01
    self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get")*0.01
end

function modifier_chaotic_ice_age:OnIntervalThink()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
	local target_pos = caster:GetAbsOrigin()
    self:ApplySpellEffect(target_pos,caster_pos,0.1)
    local ability_ice_storm = caster:FindAbilityByName("chaotic_ice_storm")
    if self:GetAbility():GetRuneType()==2 and ability_ice_storm then
        local chance = self:GetAbility():GetSpecialValueFor("rune_2_chance")
        local random = math.random
        if chance >= random(1,100) then
            ability_ice_storm:ApplySpellEffect(target_pos,caster_pos,0.1)
        end
    end
    
end


function modifier_chaotic_ice_age:ApplySpellEffect(target_pos,caster_pos,delay)
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local ability = self:GetAbility()
	local damage = self.damage + self.bonus_damage * caster:HDGetPrimaryStatValue()
    -- 消耗自身最大魔法值的20%
    local mana_cost = caster:GetMaxMana()*self.mana_cost
    if ability:GetRuneType() == 1 then
        mana_cost = caster:GetMana()*(self.mana_cost + ability:GetSpecialValueFor("rune_1_mana_cost")*0.01)
    end
    if ability:GetRuneType() == 3 then
        mana_cost = mana_cost*(1-ability:GetSpecialValueFor("rune_3_mana")*0.01)
    end
    if caster:GetMana() < mana_cost then
        self:Destroy()
        return
    end
    caster:SpendMana(mana_cost, ability)
    EmitSoundOnLocationWithCaster(target_pos, "chaotic_ice_storm_cast", caster)
	local dir = CalculateDirection(target_pos,caster_pos)
	if caster_pos==target_pos then
		dir = caster:GetForwardVector()
	end

	local radius =self:GetAbility():GetSpecialValueFor("radius")
	local count = 7
	caster:GameTimer(delay, function()
		if not IsValid(self) then
			return
		end
		local speed = 3000

		for i = 1, 6, 1 do
			local end_pos = target_pos + Vector(RandomInt(-radius, radius),RandomInt(-radius, radius),0)
			end_pos = GetGroundPosition( end_pos, nil )
			local spawn_pos = end_pos - dir *350 + Vector(0,0,1500 + RandomInt(-300, 1200)) 
	
			local effect_cast = ParticleManager:CreateParticle( "particles/rebuid/chaotic_spell/chaotic_ice_age/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, spawn_pos )
			ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
			ParticleManager:SetParticleControl( effect_cast, 2, Vector(speed,0,0) )
			local delay = CalculateDistance3D(spawn_pos, end_pos)/speed+0.03
			ParticleManager:SetParticleControl( effect_cast, 4, Vector(delay,0,0) )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			speed = speed +500
		end
		count = count - 1
		EmitSoundOnLocationWithCaster(target_pos, "chaotic_ice_storm_target", caster)

		if count<=0 then

			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local damageTable = {
				--victim = enemy,
                attacker = caster,
                damage = damage,
                damage_type = ability:GetAbilityDamageType(),
                ability = ability,
                hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
            }
            if ability:GetRuneType() == 1 then
                damageTable.hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE
            end

			for _, unit in ipairs(enemies) do
                if ability:GetRuneType() == 3 then
                    if unit:HasModifier("modifier_hd_freezing_frozen") then
                        damageTable.damage = damageTable.damage* (1+ability:GetSpecialValueFor("rune_3_index")*0.01)
                    end
                end

				damageTable.victim = unit
				ApplyDamage(damageTable)
                if not unit:IsAlive() then
                    -- 敌人被击杀，恢复英雄的魔法值
                    local mana_get = caster:GetMaxMana() * self.mana_get
                    if ability:GetRuneType() == 1 then
                        mana_get = mana_get * (1 + ability:GetSpecialValueFor("rune_1_mana_get")*0.01)
                        self:SetDuration((self:GetRemainingTime() + ability:GetSpecialValueFor("rune_1_duration")),true)
                    end

                    if ability:GetRuneType() == 2 then
                        local ability_ice_storm = caster:FindAbilityByName("chaotic_ice_storm")
                        if not ability_ice_storm then
                            local newcooldown = ability:GetCooldownTimeRemaining() - ability:GetSpecialValueFor("rune_2_cooldown_self")
                            ability:EndCooldown()
                            ability:StartCooldown(newcooldown)
                        end

                    end

                    caster:GiveMana(mana_get)
                else
                    unit:Freezing(caster, ability, damageTable.damage*0.5)
                end
			end
			return nil
		end
		return 0.03
	end)
end