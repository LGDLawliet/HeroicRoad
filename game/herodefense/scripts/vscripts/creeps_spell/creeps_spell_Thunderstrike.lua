creeps_spell_Thunderstrike = class({})
LinkLuaModifier("modifier_creeps_spell_Thunderstrike_effect", "creeps_spell/creeps_spell_Thunderstrike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Thunderstrike_ready", "creeps_spell/creeps_spell_Thunderstrike", LUA_MODIFIER_MOTION_NONE)

--Abilities
function creeps_spell_Thunderstrike:GetIntrinsicModifierName() return "modifier_creeps_spell_Thunderstrike_effect" end
function creeps_spell_Thunderstrike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


modifier_creeps_spell_Thunderstrike_effect = class({})
function modifier_creeps_spell_Thunderstrike_effect:IsHidden() return true end
function modifier_creeps_spell_Thunderstrike_effect:IsDebuff() return false end
function modifier_creeps_spell_Thunderstrike_effect:IsPurgable() return false end
function modifier_creeps_spell_Thunderstrike_effect:IsPurgeException() return false end
function modifier_creeps_spell_Thunderstrike_effect:IsStunDebuff() return false end
function modifier_creeps_spell_Thunderstrike_effect:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Thunderstrike_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end

function modifier_creeps_spell_Thunderstrike_effect:OnRefresh()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end




function modifier_creeps_spell_Thunderstrike_effect:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Thunderstrike_ready", {})
    self:StartIntervalThink(-1)
end

modifier_creeps_spell_Thunderstrike_ready = class({})
function modifier_creeps_spell_Thunderstrike_ready:IsHidden() return false end
function modifier_creeps_spell_Thunderstrike_ready:IsDebuff() return false end
function modifier_creeps_spell_Thunderstrike_ready:IsPurgable() return false end
function modifier_creeps_spell_Thunderstrike_ready:IsPurgeException() return false end
function modifier_creeps_spell_Thunderstrike_ready:IsStunDebuff() return false end
function modifier_creeps_spell_Thunderstrike_ready:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_Thunderstrike_ready:RemoveOnDeath() return false end
function modifier_creeps_spell_Thunderstrike_ready:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end
require('internal/timers')
function modifier_creeps_spell_Thunderstrike_ready:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster =self:GetParent()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,
    self:GetAbility():GetSpecialValueFor("radius"),
     DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
       if #enemies <1 then
           return
       end
       --寻获单位成功，开始施法
       if self.trigger ~= nil then
           return
       end
       self.trigger = 1
 
       local pos = enemies[1]:GetAbsOrigin()
       local radius = self:GetAbility():GetSpecialValueFor("radius_damage")
       enemies[1]:EmitSound("Hero_Zuus.Cloud.Cast")
       local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_WORLDORIGIN, nil)
       ParticleManager:SetParticleControlEnt(iParticleID, 0, nil, PATTACH_ABSORIGIN_FOLLOW, nil, pos, true)
       ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius,radius, 1))


       local zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, caster)
       -- Position of ground effect
       ParticleManager:SetParticleControl(zuus_nimbus_particle, 0, Vector(pos.x, pos.y, pos.z))
       -- Radius of ground effect
       ParticleManager:SetParticleControl(zuus_nimbus_particle, 1, Vector(radius+64, 0, 0))
       -- Position of cloud 
       ParticleManager:SetParticleControl(zuus_nimbus_particle, 2, Vector(pos.x, pos.y, pos.z + 450))	


       Timers:CreateTimer(3, function()

        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(iParticleID, false)
            ParticleManager:ReleaseParticleIndex(iParticleID)
            ParticleManager:DestroyParticle(zuus_nimbus_particle, false)
            ParticleManager:ReleaseParticleIndex(zuus_nimbus_particle)
            self:SafeDestroy()
        end)
        if not caster or caster:IsNull() or not caster:IsAlive() then
            return
        end
        local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,
        self:GetAbility():GetSpecialValueFor("radius_damage"),
         DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
           DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
           if #units == 0 then
               return
           end
           --检测搜寻到的单位表里是否有目标单位，并做判定，如果单位表单位数量大于1，则造成额外伤害
           for _, unit in ipairs(units) do
               if unit == enemies[1] then
                --单位在范围里，添加伤害与特效
                local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(pfx, 0, pos)
                ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
                ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
                ParticleManager:ReleaseParticleIndex(pfx)
                Timers:CreateTimer(0.5, function()
                    if #units>1 then
                        local damageTable = {
                            victim = enemies[1],
                            attacker = caster,
                            damage = caster:GetBaseDamageMax() * self:GetAbility():GetSpecialValueFor("bonus_damage"),
                            damage_type = DAMAGE_TYPE_PHYSICAL,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = self, --Optional.
                            }
                        ApplyDamage(damageTable)
                       end
                       local damageTable = {
                        victim = enemies[1],
                        attacker = caster,
                        damage =caster:GetBaseDamageMax() * self:GetAbility():GetSpecialValueFor("basic_damage"),
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                        ability = self, --Optional.
                        }
                    ApplyDamage(damageTable)
                    -- ParticleManager:DestroyParticle(self.iParticleID, false)
                    enemies[1]:EmitSound("Hero_Zuus.GodsWrath")
                    -- self:SafeDestroy()
                end)
               end
           end
    end)
end


function modifier_creeps_spell_Thunderstrike_ready:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Thunderstrike_effect", {})
end
