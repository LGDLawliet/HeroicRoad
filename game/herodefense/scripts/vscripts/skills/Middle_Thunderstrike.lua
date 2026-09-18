Middle_Thunderstrike = class({})
LinkLuaModifier("modifier_Middle_Thunderstrike_effect", "skills/Middle_Thunderstrike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Thunderstrike_ready", "skills/Middle_Thunderstrike", LUA_MODIFIER_MOTION_NONE)

--Abilities
function Middle_Thunderstrike:GetIntrinsicModifierName() return "modifier_Middle_Thunderstrike_effect" end
function Middle_Thunderstrike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Middle_Thunderstrike:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zeus/zeus_cloud.vpcf", context )

	
	

end


modifier_Middle_Thunderstrike_effect = class({})
function modifier_Middle_Thunderstrike_effect:IsHidden() return true end
function modifier_Middle_Thunderstrike_effect:IsDebuff() return false end
function modifier_Middle_Thunderstrike_effect:IsPurgable() return false end
function modifier_Middle_Thunderstrike_effect:IsPurgeException() return false end
function modifier_Middle_Thunderstrike_effect:IsStunDebuff() return false end
function modifier_Middle_Thunderstrike_effect:AllowIllusionDuplicate() return false end

function modifier_Middle_Thunderstrike_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_Middle_Thunderstrike_effect:OnRefresh()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end




function modifier_Middle_Thunderstrike_effect:OnIntervalThink()
    if not IsServer() then
        return
    end
	if self:GetAbility():IsCooldownReady() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Middle_Thunderstrike_ready", {})
	end
    
end

modifier_Middle_Thunderstrike_ready = class({})
function modifier_Middle_Thunderstrike_ready:IsHidden() return true end
function modifier_Middle_Thunderstrike_ready:IsDebuff() return false end
function modifier_Middle_Thunderstrike_ready:IsPurgable() return false end
function modifier_Middle_Thunderstrike_ready:IsPurgeException() return false end
function modifier_Middle_Thunderstrike_ready:IsStunDebuff() return false end
function modifier_Middle_Thunderstrike_ready:AllowIllusionDuplicate() return false end
function modifier_Middle_Thunderstrike_ready:RemoveOnDeath() return false end
function modifier_Middle_Thunderstrike_ready:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.2)
end
require('internal/timers')
function modifier_Middle_Thunderstrike_ready:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster =self:GetParent()
	if caster:PassivesDisabled() then
		return
	end
	local ability = self:GetAbility()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,
    ability:GetSpecialValueFor("radius"),
     DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
       DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
       if #enemies <1 then
           return
       end
       self:StartIntervalThink(-1)
 
       local pos = enemies[1]:GetAbsOrigin()
       local radius = 280
       enemies[1]:EmitSound("Hero_Zuus.Cloud.Cast")
       ability:UseResources(true, true, true, true)
       local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_WORLDORIGIN, nil)
       ParticleManager:SetParticleControlEnt(iParticleID, 0, nil, PATTACH_ABSORIGIN_FOLLOW, nil, pos, true)
       ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius,radius, radius))


       local zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, caster)
       ParticleManager:SetParticleControl(zuus_nimbus_particle, 0, Vector(pos.x, pos.y, pos.z))
       ParticleManager:SetParticleControl(zuus_nimbus_particle, 1, Vector(radius+64, 0, 0))
       ParticleManager:SetParticleControl(zuus_nimbus_particle, 2, Vector(pos.x, pos.y, pos.z + 450))	


       Timers:CreateTimer(2, function()

		--延迟0.5秒销毁特效与状态
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
		if not ability or ability:IsNull() then
			return
		end

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

           for i, unit in ipairs(units) do
                local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
                pos = unit:GetAbsOrigin()
				ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x, pos.y, 5000))
				ParticleManager:SetParticleControl(pfx, 1, pos)
                ParticleManager:ReleaseParticleIndex(pfx)
                damageTable.victim = unit
				ApplyDamage(damageTable)
                unit:EmitSound("Hero_Zuus.GodsWrath")
                if i>=3 then
                    break
                end


           end
    end)
end


