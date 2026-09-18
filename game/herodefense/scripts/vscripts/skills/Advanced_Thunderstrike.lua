Advanced_Thunderstrike = class({})
LinkLuaModifier("modifier_Advanced_Thunderstrike_effect", "skills/Advanced_Thunderstrike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thunderstrike_ready", "skills/Advanced_Thunderstrike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thunderstrike_delay", "skills/Advanced_Thunderstrike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thunderstrike_unlock2", "skills/Advanced_Thunderstrike", LUA_MODIFIER_MOTION_NONE)

--Abilities
function Advanced_Thunderstrike:GetIntrinsicModifierName() return "modifier_Advanced_Thunderstrike_effect" end
function Advanced_Thunderstrike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Advanced_Thunderstrike:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zeus/zeus_cloud.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", context )
end

function Advanced_Thunderstrike:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_Thunderstrike:UnlockSecondCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Thunderstrike_unlock2",{})
	
	return true
end
function Advanced_Thunderstrike:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Thunderstrike_unlock2",{})
	
	return true
end



function Advanced_Thunderstrike:CheckKV(key)
	local table = {

		base_damage =10,
		bonus_damage_min = 0.1,
	}
	local value = table[key] or -1
	return value

end
function Advanced_Thunderstrike:GetCooldown(iLevel)
    if self.unlock1 then
        return 0
    end
    return self.BaseClass.GetCooldown(self,iLevel)
end

function Advanced_Thunderstrike:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")


	if advanced_level>=15 then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

    return self.BaseClass.GetBehavior(self)
end










modifier_Advanced_Thunderstrike_effect = class({})
function modifier_Advanced_Thunderstrike_effect:IsHidden() return true end
function modifier_Advanced_Thunderstrike_effect:IsDebuff() return false end
function modifier_Advanced_Thunderstrike_effect:IsPurgable() return false end
function modifier_Advanced_Thunderstrike_effect:IsPurgeException() return false end
function modifier_Advanced_Thunderstrike_effect:IsStunDebuff() return false end
function modifier_Advanced_Thunderstrike_effect:AllowIllusionDuplicate() return false end

function modifier_Advanced_Thunderstrike_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_Advanced_Thunderstrike_effect:OnRefresh()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end




function modifier_Advanced_Thunderstrike_effect:OnIntervalThink()
    if not IsServer() then
        return
    end
    local ability =self:GetAbility()
    -- if ability.unlock2 then
    --     self:StartIntervalThink(-1)
    --     return
    -- end
    
	if ability:IsCooldownReady() then
		self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_Advanced_Thunderstrike_ready", {})
	end
    
end

modifier_Advanced_Thunderstrike_ready = class({})
function modifier_Advanced_Thunderstrike_ready:IsHidden() return true end
function modifier_Advanced_Thunderstrike_ready:IsDebuff() return false end
function modifier_Advanced_Thunderstrike_ready:IsPurgable() return false end
function modifier_Advanced_Thunderstrike_ready:IsPurgeException() return false end
function modifier_Advanced_Thunderstrike_ready:IsStunDebuff() return false end
function modifier_Advanced_Thunderstrike_ready:AllowIllusionDuplicate() return false end
function modifier_Advanced_Thunderstrike_ready:RemoveOnDeath() return false end
function modifier_Advanced_Thunderstrike_ready:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.2)
end
require('internal/timers')
function modifier_Advanced_Thunderstrike_ready:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster =self:GetParent()
	if caster:PassivesDisabled() then
		return
	end
	local ability = self:GetAbility()
    -- if ability.unlock2 then
    --     self:StartIntervalThink(-1)
    --     self:SafeDestroy()
    --     return
    -- end
    if self.lv20_effect then 
        return
    end
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,
    ability:GetSpecialValueFor("radius"),
     DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
       if #enemies <1 then
           return
       end
       self:StartIntervalThink(-1)

 
    if ability:GetAutoCastState() and not ability.unlock3 then
        ability:StartCooldown(ability:GetCooldown(ability:GetLevel())* self:GetParent():GetCooldownReduction()*2 )
        local bonus = 3
        if ability.unlock1 then
            bonus = 2
        end
        for i = 1, bonus, 1 do
            
            Timers:CreateTimer(RandomFloat(0, 0.3), function()
                self:Thunder(enemies[RandomInt(1, #enemies)])
            end)
        end

        
    else
        ability:UseResources(true, true, true, true)
        self:Thunder(enemies[1])
    end
      
end




function modifier_Advanced_Thunderstrike_ready:Thunder(target)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local pos = target:GetAbsOrigin()
    local target_pos = target:GetAbsOrigin()
    local radius = 280
       
    local delay = 2
    local bonus_damage_index = 2
    if ability.advanced_level>=5 then
        radius = 400
        if ability.advanced_level>=10 then
            bonus_damage_index = 3
        end
    end
    target:EmitSound("Hero_Zuus.Cloud.Cast")
    ability:UseResources(true, true, true, true)
    local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControlEnt(iParticleID, 0, nil, PATTACH_ABSORIGIN_FOLLOW, nil, pos, true)
    ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius,radius, radius))


    local zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(zuus_nimbus_particle, 0, Vector(pos.x, pos.y, pos.z))
    ParticleManager:SetParticleControl(zuus_nimbus_particle, 1, Vector(radius+64, 0, 0))
    ParticleManager:SetParticleControl(zuus_nimbus_particle, 2, Vector(pos.x, pos.y, pos.z + 450))	


    local unlock3_cost = 100
    local unlock3_count = ability.unlock3 and 2 or 0

    Timers:CreateTimer(delay, function()
        if not caster or caster:IsNull() or not caster:IsAlive() then
            self:DestroyBuff(iParticleID,zuus_nimbus_particle)
            return
        end
        if not target or target:IsNull() then
            self:DestroyBuff(iParticleID,zuus_nimbus_particle)
            return
        end
        if not ability or ability:IsNull() then
            self:DestroyBuff(iParticleID,zuus_nimbus_particle)
            return
        end
        --  :UseResources(true, true, true, true)
 
        local units = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
        if #units == 0 then
            self:DestroyBuff(iParticleID,zuus_nimbus_particle)
            return
        end
        local damageTable = {
            attacker = caster,
            damage = caster:GetIntellect(false) * ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("base_damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            ability = ability, --Optional.
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
        }
        local unit_table = {}

        for i, unit in ipairs(units) do
            local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
            pos = unit:GetAbsOrigin()
            ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x, pos.y, 5000))
            ParticleManager:SetParticleControl(pfx, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx)
            damageTable.victim = unit
            ApplyDamage(damageTable)
            unit:EmitSound("Hero_Zuus.GodsWrath")
            if target:IsAlive() then
            table.insert(unit_table,unit)
            end
            if i>=3 then
                break
            end


        end


        if  target:IsAlive() then
            local damage = 0
            for _, unit in ipairs(unit_table) do
                 local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,unit)
                 ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                 ParticleManager:SetParticleControlEnt(pfx, 1,target, PATTACH_POINT_FOLLOW, "attach_hitloc",  target:GetAbsOrigin(), true)
                 ParticleManager:ReleaseParticleIndex(pfx)
                 unit:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
                 damage = damage + 1
            end
            if damage>=1 then
                local tDamage = {
                    ability = self:GetAbility(),
                    attacker =caster,
                    victim = target,
                    damage = caster:GetIntellect(false)*bonus_damage_index*damage,
                    damage_type = self:GetAbility():GetAbilityDamageType(),
                    hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
                }
                ApplyDamage(tDamage)
            end
        end

        if unlock3_count>0 or (ability.unlock3 and ability:GetAutoCastState() and caster:GetMana()>=unlock3_cost) then
            if unlock3_count>0 then
                unlock3_count = unlock3_count - 1
            else
                caster:SpendMana( unlock3_cost, ability )
                unlock3_cost = unlock3_cost +20
            end
          
            return 0.2
        else
            self:DestroyBuff(iParticleID,zuus_nimbus_particle)
            return
        end
 end)


 if ability.advanced_level>=20 then
    local timer = 0
    -- local dummy = CreateUnitByName("npc_attack_unit", pos, true, caster, caster, caster:GetTeamNumber())
	-- local modifier = dummy:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 2.5})
	
    local dummy = CreateModifierThinker(
        caster, -- player source
        self, -- ability source
        "modifier_Advanced_Thunderstrike_delay", 
        {duration = 2.5}, -- kv
        Vector(pos.x, pos.y, 5000),
        caster:GetTeamNumber(),
        false
    )
    dummy:SetOrigin(Vector(pos.x, pos.y, 2000))
    Timers:CreateTimer(0.4, function()
        if not ability or ability:IsNull() then
            -- modifier:SafeDestroy()
            -- dummy:ForceKill(false)
            dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration =0.01})
            return
        end
        timer = timer +0.4
        local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, unit in ipairs(units) do
            local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,dummy)
            -- ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x, pos.y, 5000))
            ParticleManager:SetParticleControlEnt(pfx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc",  unit:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(pfx)
            unit:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
            local tDamage = {
                ability = ability,
                attacker =caster,
                victim = unit,
                damage = caster:GetIntellect(false)*1.7,
                damage_type = ability:GetAbilityDamageType(),
                hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
            }
            ApplyDamage(tDamage)
            break
        end

        if timer>=2 then
            -- modifier:SafeDestroy()
            dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration =0.01})
            -- dummy:ForceKill(false)
            return
        else
            return 0.4
        end

        end)
    end
end



function modifier_Advanced_Thunderstrike_ready:DestroyBuff(iParticleID,zuus_nimbus_particle)
    Timers:CreateTimer(0.5, function()
        ParticleManager:DestroyParticle(iParticleID, false)
        ParticleManager:ReleaseParticleIndex(iParticleID)
        ParticleManager:DestroyParticle(zuus_nimbus_particle, false)
        ParticleManager:ReleaseParticleIndex(zuus_nimbus_particle)
        self:SafeDestroy()
    end)
end



modifier_Advanced_Thunderstrike_delay= modifier_Advanced_Thunderstrike_delay or class({})

function modifier_Advanced_Thunderstrike_delay:IsHidden()		return true end
function modifier_Advanced_Thunderstrike_delay:IsPurgable()		return false end
function modifier_Advanced_Thunderstrike_delay:RemoveOnDeath()	return false end

function modifier_Advanced_Thunderstrike_delay:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end







modifier_Advanced_Thunderstrike_unlock2 = class({})


function modifier_Advanced_Thunderstrike_unlock2:IsHidden()	return true end
function modifier_Advanced_Thunderstrike_unlock2:IsDebuff()	return false end
function modifier_Advanced_Thunderstrike_unlock2:IsStunDebuff()	return false end
function modifier_Advanced_Thunderstrike_unlock2:RemoveOnDeath()	return false end
function modifier_Advanced_Thunderstrike_unlock2:DestroyOnExpire()	return false end
function modifier_Advanced_Thunderstrike_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Thunderstrike_unlock2:IsPurgeException() 	return false end

function modifier_Advanced_Thunderstrike_unlock2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_Advanced_Thunderstrike_unlock2:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=3 then
        if keys.target then
            self:Thunder(keys.target)
        else
            local pos = keys.unit:GetCursorPosition()
            if pos== Vector(0,0,0) then
                pos= keys.unit:GetOrigin()
            end
            local units = FindUnitsInRadius(keys.unit:GetTeamNumber(), pos, nil,
            600,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
            for _, unit in ipairs(units) do
                self:Thunder(unit)
                break
            end
        end

    end
  
    
end

function modifier_Advanced_Thunderstrike_unlock2:Thunder(target)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local radius = 400
    local pos = target:GetAbsOrigin()
    local delay = 2
    local bonus_damage_index = 3
    target:EmitSound("Hero_Zuus.Cloud.Cast")
    ability:UseResources(true, true, true, true)
    local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControlEnt(iParticleID, 0, nil, PATTACH_ABSORIGIN_FOLLOW, nil, pos, true)
    ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius,radius, radius))


    local zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(zuus_nimbus_particle, 0, Vector(pos.x, pos.y, pos.z))
    ParticleManager:SetParticleControl(zuus_nimbus_particle, 1, Vector(radius+64, 0, 0))
    ParticleManager:SetParticleControl(zuus_nimbus_particle, 2, Vector(pos.x, pos.y, pos.z + 450))	
    Timers:CreateTimer(delay, function()
        --延迟0.5秒销毁特效与状态
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(iParticleID, false)
            ParticleManager:ReleaseParticleIndex(iParticleID)
            ParticleManager:DestroyParticle(zuus_nimbus_particle, false)
            ParticleManager:ReleaseParticleIndex(zuus_nimbus_particle)
            -- self:SafeDestroy()
        end)
        if not caster or caster:IsNull() or not caster:IsAlive() then
            return
        end
        if not target or target:IsNull() then
            return
        end
        if not ability or ability:IsNull() then
            return
        end
        ability:UseResources(true, true, true, true)
        local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
        if #units == 0 then
            return
        end
        local damageTable = {
            attacker = caster,
            damage = caster:GetIntellect(false) * ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("base_damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            ability = ability, --Optional.
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
        }
        local unit_table = {}

        for i, unit in ipairs(units) do
            local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
            pos = unit:GetAbsOrigin()
            ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x, pos.y, 5000))
            ParticleManager:SetParticleControl(pfx, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx)
            damageTable.victim = unit
            ApplyDamage(damageTable)
            unit:EmitSound("Hero_Zuus.GodsWrath")
            if  target:IsAlive() then
                table.insert(unit_table,unit)
            end
            if i>=3 then
                break
            end


        end


        if  target:IsAlive() then
            local damage = 0
            for _, unit in ipairs(unit_table) do
                 local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,unit)
                 ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                 ParticleManager:SetParticleControlEnt(pfx, 1,target, PATTACH_POINT_FOLLOW, "attach_hitloc",  target:GetAbsOrigin(), true)
                 ParticleManager:ReleaseParticleIndex(pfx)
                 unit:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
                 damage = damage + 1
            end
            if damage>=1 then
                local tDamage = {
                    ability = self:GetAbility(),
                    attacker =caster,
                    victim = target,
                    damage = caster:GetIntellect(false)*bonus_damage_index*damage,
                    damage_type = self:GetAbility():GetAbilityDamageType(),
                    hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
                }
                ApplyDamage(tDamage)
            end
        end
    end)


    local timer = 0
    -- local dummy = CreateUnitByName("npc_attack_unit", pos, true, caster, caster, caster:GetTeamNumber())
    -- local modifier = dummy:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 2.5})
    
    local dummy = CreateModifierThinker(
        caster, -- player source
        self, -- ability source
        "modifier_Advanced_Thunderstrike_delay", 
        {duration = 2.5}, -- kv
        Vector(pos.x, pos.y, 5000),
        caster:GetTeamNumber(),
        false
    )
    dummy:SetOrigin(Vector(pos.x, pos.y, 2000))
    Timers:CreateTimer(0.4, function()
        if not ability or ability:IsNull() then
            -- modifier:SafeDestroy()
            -- dummy:ForceKill(false)
            dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration =0.01})
            return
        end
        timer = timer +0.4
        local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, unit in ipairs(units) do
            local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,dummy)
            -- ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x, pos.y, 5000))
            ParticleManager:SetParticleControlEnt(pfx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc",  unit:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(pfx)
            unit:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
            local tDamage = {
                ability = ability,
                attacker =caster,
                victim = unit,
                damage = caster:GetIntellect(false)*1.7,
                damage_type = ability:GetAbilityDamageType(),
                hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
            }
            ApplyDamage(tDamage)
            break
        end

        if timer>=2 then
            -- modifier:SafeDestroy()
            dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration =0.01})
            -- dummy:ForceKill(false)
            return
        else
            return 0.4
        end

        end)
end