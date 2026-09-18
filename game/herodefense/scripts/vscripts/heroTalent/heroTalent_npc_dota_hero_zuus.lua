heroTalent_npc_dota_hero_zuus = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus", "heroTalent/heroTalent_npc_dota_hero_zuus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus_buff", "heroTalent/heroTalent_npc_dota_hero_zuus", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_zuus:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_zuus" end

----
modifier_heroTalent_npc_dota_hero_zuus = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_zuus:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_zuus:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_zuus:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_zuus:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_zuus:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_zuus:DestroyOnExpire() return false end
function modifier_heroTalent_npc_dota_hero_zuus:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage") 
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.cd = self.ability:GetSpecialValueFor("cd")

    self.max = self.ability:GetSpecialValueFor("max")   
    self.line = self.ability:GetSpecialValueFor("line")*0.01

    self.talentgain1 = self.ability:GetTalentGain(1)
    self.talentgain2 = self.ability:GetTalentGain(0.75)
    self.bonus_damage_t = self.bonus_damage*self.talentgain1
    self.chance_t = self.chance*self.talentgain1
    self.cd_t = self.cd*self.talentgain2

    if IsServer() then
        self:StartIntervalThink(0.1)

        self.damageTable = {
            --victim = unit,
            attacker = self.parent,
            ability = self.ability,
            damage_type = self.ability:GetAbilityDamageType(),
            --damage = self.parent:GetIntellect(false)*self.int_damage,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
        }
    end
end

function modifier_heroTalent_npc_dota_hero_zuus:OnIntervalThink()
    if not self.ability:IsCooldownReady() then return end
    if not self.parent:IsAlive() then return end

    local enemies = {}
    local allEnemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        10000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    -- 按生命值排序后取前几个
    table.sort(allEnemies, function(a,b) 
        return a:GetHealth() < b:GetHealth() 
    end)
    for i=1, math.min(self.max, #allEnemies) do
        table.insert(enemies, allEnemies[i])
    end

    if #enemies > 0 then
        for i, unit in ipairs(enemies) do
            self:PlayEffect(unit)

            self.talentgain1 = self.ability:GetTalentGain(1)
            self.talentgain2 = self.ability:GetTalentGain(0.75)
            self.bonus_damage_t = self.bonus_damage*self.talentgain1
            self.cd_t = self.cd*self.talentgain2

            self.damageTable.victim = unit
            self.damageTable.damage = self.parent:HDGetPrimaryStatValue() * self.bonus_damage_t
            ApplyDamage(self.damageTable)

            if unit:IsAlive() then
                unit:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = 0.1})
            end 
        end

        self.ability:UseResources(true, true, true, true)
        local buff = self.parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_zuus_buff")
        if buff and buff:GetStackCount() >= 1 then
            local buff_stack = buff:GetStackCount()--当前buff层数
            local cd_return_max = self.ability:GetCooldownTimeRemaining()--当前冷却时间
            local cost_buff_max = math.ceil(cd_return_max/self.cd_t)--计算可消耗的最大buff层数，向上取整，如刷新需要2.5层=可消耗3层

            -- 当前buff层数不低于最大消耗buff层数时，消耗buff并刷新。否则全部消耗并降低冷却时间
            if buff_stack >= cost_buff_max then
                buff:SetStackCount(buff_stack - cost_buff_max)
                self.ability:EndCooldown()
            else
                buff:Destroy()
                self.ability:EndCooldown()
                self.ability:StartCooldown(cd_return_max - buff_stack * self.cd_t)
            end
        end
    end
end

function modifier_heroTalent_npc_dota_hero_zuus:PlayEffect(target)
    if not IsServer() then return end
    if not target then return end

    local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, target)
    local pos = target:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+5000))
    ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
    ParticleManager:SetParticleControl(particle, 3, Vector(pos.x, pos.y, pos.z))
    target:EmitSound("Hero_Zuus.LightningBolt")
end

function modifier_heroTalent_npc_dota_hero_zuus:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_zuus:ADDeclareFunctions()
	return{
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
	}
end

function modifier_heroTalent_npc_dota_hero_zuus:OnTakeDamage(keys)
    if not IsServer() then return end
    if not self.parent:IsAlive() then return end
    if self:GetRemainingTime() > 0 then return end
    local attacker = keys.attacker
    local unit = keys.unit
    local damage = keys.damage
    if attacker ~= self.parent then return end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
    if keys.inflictor == self.ability then return end
    if damage < unit:GetMaxHealth()*self.line then return end

    local random = math.random
    if self.chance_t >= random(1,100) then
        local modifier = attacker:FindModifierByName("modifier_heroTalent_npc_dota_hero_zuus_buff") 
        if modifier then
            modifier:SetStackCount(modifier:GetStackCount() + 1)
        else
            local buff = attacker:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_zuus_buff", {})
            buff:SetStackCount(1)
        end
        self:SetDuration(0.2, true)
    end
end

function modifier_heroTalent_npc_dota_hero_zuus:OnTooltip()
    self.talentgain1 = self.ability:GetTalentGain(1)
    self.talentgain2 = self.ability:GetTalentGain(0.75)
    self.bonus_damage_t = self.bonus_damage*self.talentgain1
    self.chance_t = self.chance*self.talentgain1
    self.cd_t = self.cd*self.talentgain2
	
    self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self.bonus_damage_t
    end
    if self._tooltip == 2 then
        return self.chance_t
    end
    if self._tooltip == 3 then
        return self.cd_t
    end
end

----
modifier_heroTalent_npc_dota_hero_zuus_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_zuus_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_zuus_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_zuus_buff:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_zuus_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_zuus_buff:RemoveOnDeath() return false end
