LinkLuaModifier("modifier_item_rattletrap_2", "items/item_rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_rattletrap_2_assault_damage", "items/item_rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_rattletrap_2_rocket_damage", "items/item_rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
item_rattletrap_2 = class({})
function item_rattletrap_2:Precache(context)
    --ACT_DOTA_FLAIL
    PrecacheResource("particle", "particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", context)
end
function item_rattletrap_2:GetCustomCastError()
	return "#DOTA_CUSTOM_NO_CHARGE"
end
function item_rattletrap_2:CastFilterResult()
	if IsServer() then
		local caster = self:GetCaster()
		if caster.GetPlayerOwnerID then
			local charge_need = self:GetSpecialValueFor("cost")
            if self:GetCurrentCharges() < charge_need then
                return UF_FAIL_CUSTOM
			end
		end
		return UF_SUCCESS
	end
end
function item_rattletrap_2:OnSpellStart()
    local caster = self:GetCaster()
    local charge_need = self:GetSpecialValueFor("cost")
    if self:GetCurrentCharges() < charge_need then return end
    if self.stage and self.stage >= 4 then return end

    self:SetCurrentCharges(self:GetCurrentCharges() - charge_need)
    self:SetDroppable(false)
    self.stage = (self.stage or 0) + 1
    print("升级完成，当前第"..self.stage.."阶段")
    caster:EmitSound("DOTA_Item.HavocHammer.Cast")

    local self_modifier = caster:FindModifierByName("modifier_item_rattletrap_2")
    if IsValid(self_modifier) then
        self_modifier:ForceRefresh()
    end
end
function item_rattletrap_2:GetIntrinsicModifierName()
    return "modifier_item_rattletrap_2"
end
----
modifier_item_rattletrap_2_assault_damage = advanced_modifier({})

function modifier_item_rattletrap_2_assault_damage:IsHidden() return true end
function modifier_item_rattletrap_2_assault_damage:IsDebuff() return true end
function modifier_item_rattletrap_2_assault_damage:IsPurgable() return false end
function modifier_item_rattletrap_2_assault_damage:OnCreated(kv) 
    if IsServer() then
        self:StartIntervalThink(0.3)
        self:SetStackCount(kv.damage)
    end
end
function modifier_item_rattletrap_2_assault_damage:OnRefresh(kv) 
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + kv.damage)
    end
end
function modifier_item_rattletrap_2_assault_damage:OnIntervalThink() 

    local damage = self:GetStackCount()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self:GetAbility(),
    })
    if IsValid(self) then
        self:SetStackCount(0)
        self:Destroy()
    end
end
----
modifier_item_rattletrap_2_rocket_damage = advanced_modifier({})

function modifier_item_rattletrap_2_rocket_damage:IsHidden() return true end
function modifier_item_rattletrap_2_rocket_damage:IsDebuff() return true end
function modifier_item_rattletrap_2_rocket_damage:IsPurgable() return false end
function modifier_item_rattletrap_2_rocket_damage:OnCreated(kv) 
    if IsServer() then
        self:StartIntervalThink(0.3)
        self:SetStackCount(kv.damage)
    end
end
function modifier_item_rattletrap_2_rocket_damage:OnRefresh(kv) 
    if IsServer() then
        self:SetStackCount(self:GetStackCount() + kv.damage)
    end
end
function modifier_item_rattletrap_2_rocket_damage:OnIntervalThink() 

    local damage = self:GetStackCount()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
    })
    if IsValid(self) then
        self:SetStackCount(0)
        self:Destroy()
    end
end
----
modifier_item_rattletrap_2 = advanced_modifier({})

function modifier_item_rattletrap_2:IsHidden() return true end
function modifier_item_rattletrap_2:IsDebuff() return false end
function modifier_item_rattletrap_2:IsPurgable() return false end
function modifier_item_rattletrap_2:RemoveOnDeath() return false end

function modifier_item_rattletrap_2:OnCreated()    
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")

    if IsServer() then
        self.stage = (self.ability.stage) or 0
    end
end
function modifier_item_rattletrap_2:OnRefresh()    
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")

    if IsServer() then
        self.stage = (self.ability.stage) or 0
    end
end

function modifier_item_rattletrap_2:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},
    }
    self.stage = self:GetAbility().stage or 0
    if self.stage >= 1 then
        self.assault_line = self:GetAbility():GetSpecialValueFor("line")*0.01
        self.assault_radius = self:GetAbility():GetSpecialValueFor("radius")
        self.assault_max = self:GetAbility():GetSpecialValueFor("max")
        self.assault_damage_atk = 1
        self.assault_damage_atb = 5
    end
    if self.stage >= 2 then
        self.rocket_interval = self:GetAbility():GetSpecialValueFor("interval")
        self.rocker_radius = self:GetAbility():GetSpecialValueFor("radius_2")
        self.rocket_damage_atk = 4
        self.rocket_damage_atb = 20
        self.rocket_num = 1
        self:StartIntervalThink(self.rocket_interval)
    end
    if self.stage >= 3 then

    end
    if self.stage >= 4 then
        self.assault_radius = self.assault_radius + self:GetAbility():GetSpecialValueFor("bonus_radius")
        self.assault_max = self.assault_max + self:GetAbility():GetSpecialValueFor("bonus_max")
    end
    return funcs
end
function modifier_item_rattletrap_2:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetCurrentCharges() * self.armor
end
function modifier_item_rattletrap_2:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self:GetAbility():GetCurrentCharges() * self.outgoing
end

function modifier_item_rattletrap_2:OnTakeDamage(keys)
    if not IsServer() then return end
    if self.stage <1 then return end
    local victim = keys.unit
    local attacker = keys.attacker
    if victim ~= self.parent or not self.parent:IsAlive() then return end

    self.damage_calculate = (self.damage_calculate or 0) + keys.damage
    local assault_need = victim:GetMaxHealth() * self.assault_line
    if self.damage_calculate >= assault_need then
        local num = math.floor(self.damage_calculate / assault_need)
        self.damage_calculate = self.damage_calculate - assault_need * num
        for i = 1, num do
            self:Assault(victim:GetAbsOrigin())
        end
    end
end

function modifier_item_rattletrap_2:Assault(center_pos)
	if not IsServer() then return end
    if not self.stage or self.stage < 1 then return end
    self.parent:Purge(false, true, false, false, false)
    local adaptdamagetable = GetAdaptDamage(self.caster:GetAverageTrueAttackDamage(nil), self.assault_damage_atk, self.caster:HDGetPrimaryStatValue(), self.assault_damage_atb)
    local damage = adaptdamagetable.damage * (1+self.ability:GetCurrentCharges()*0.08)
    local damage_type = DAMAGE_TYPE_PHYSICAL

	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), center_pos, nil, self.assault_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for i, enemy in ipairs(enemies) do
            if i > self.assault_max then break end
            self:PlayEffects_Assault(enemy)

            enemy:AddNewModifier(self.caster, self.ability, "modifier_item_rattletrap_2_assault_damage", {damage = damage})
            if enemy and enemy:IsAlive() then
                enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = 0.2})
            end
        end
    end
end

function modifier_item_rattletrap_2:PlayEffects_Assault(target)
    local particle_cast = "particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf"
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_glow", self.caster:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex(effect_cast)
    local sound_cast = "Hero_Rattletrap.Battery_Assault_Impact"
    EmitSoundOn(sound_cast, self.caster)
end

function modifier_item_rattletrap_2:OnIntervalThink()
    if not IsServer() then return end
    if not self.parent:IsAlive() then return end
    
    local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, 10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
    if #enemies > 0 then
        for i, enemy in ipairs(enemies) do
            self:Rocket(enemy:GetAbsOrigin(), enemy)
            if i >= self.rocket_num then break end
        end
    end
end

function modifier_item_rattletrap_2:Rocket(pos, target)
    if not IsServer() then return end
    local caster = self.caster
    if not caster:IsAlive() then return end
    caster:EmitSound("Hero_Rattletrap.Rocket_Flare.Fire")
    local rocket = {
        Target 				= target,
        Source 				= caster,
        Ability 			= self.ability,
        EffectName 			= "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", 
        iMoveSpeed			= 2000,
        vSourceLoc 			= caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_rocket")),
        bDrawsOnMinimap 	= true,
        bDodgeable 			= true,
        bIsAttack 			= false,
        bVisibleToEnemies 	= true,
        bReplaceExisting 	= false,
        flExpireTime 		= GameRules:GetGameTime() + 20,
        bProvidesVision 	= true,
        iVisionRadius 		= self.rocker_radius,
        iVisionTeamNumber 	= caster:GetTeamNumber(),
        ExtraData = {}
    }
    ProjectileManager:CreateTrackingProjectile(rocket)

    local adaptdamagetable = GetAdaptDamage(self.caster:GetAverageTrueAttackDamage(nil), self.rocket_damage_atk, self.caster:HDGetPrimaryStatValue(), self.rocket_damage_atb)
    local damage = adaptdamagetable.damage * (1+self.ability:GetCurrentCharges()*0.08)
    local travel_time = CalculateDistance(pos, caster:GetAbsOrigin()) / 2000

    caster:GameTimer(travel_time, function()
        if target and target:IsAlive() then
            pos = target:GetAbsOrigin()
        end
        local illumination_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_illumination.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(illumination_particle, 0, pos)
        ParticleManager:SetParticleControl(illumination_particle, 1, Vector(10, 0, 0))
        ParticleManager:ReleaseParticleIndex(illumination_particle)
        EmitSoundOnLocationWithCaster(pos, "Hero_Rattletrap.Rocket_Flare.Explode", caster)
        
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self.rocker_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                enemy:AddNewModifier(caster, self.ability, "modifier_item_rattletrap_2_rocket_damage", {damage = damage})
            end
        end
        AddFOWViewer(caster:GetTeamNumber(), pos, self.rocker_radius, 10, false)

        if self.stage >= 4 then
            self:Assault(pos)
        end
    end)
end


