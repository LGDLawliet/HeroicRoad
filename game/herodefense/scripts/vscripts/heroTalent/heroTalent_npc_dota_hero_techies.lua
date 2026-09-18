heroTalent_npc_dota_hero_techies = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_techies", "heroTalent/heroTalent_npc_dota_hero_techies", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_techies:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_techies:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_techies:IsStealable() 				return true end
function heroTalent_npc_dota_hero_techies:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_techies:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_techies" end
function heroTalent_npc_dota_hero_techies:GetCastRange()
	local caster = self:GetCaster()
	return 700 - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_techies = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_techies:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_techies:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_techies:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_techies:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_techies:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_techies:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
--寒霜传送门 测试用
function modifier_heroTalent_npc_dota_hero_techies:OnCreated()
    if not IsServer() then
        return
    end
end


function modifier_heroTalent_npc_dota_hero_techies:OnDeath(keys)
    if not IsServer() then
        return
    end
    
    if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and keys.unit:IsRealHero() then
        local pos = keys.unit:GetAbsOrigin()
        local caster = self:GetParent()
        if not self:GetParent():IsRealHero() then
            return false
        end
        Timers:CreateTimer(1, function()
            local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
            ParticleManager:SetParticleControl( effect_cast, 0, pos )
            ParticleManager:SetParticleControl( effect_cast, 1, Vector(700,0,0) )
            caster:EmitSound("Hero_Techies.Suicide")
            ParticleManager:ReleaseParticleIndex( effect_cast )
            local enemies = FindUnitsInRadius(
                caster:GetTeamNumber(),	-- int, your team number
                pos,	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                700,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
                FIND_CLOSEST,	-- int, order filter
                false	-- bool, can grow cache
            )
            local damage = caster:GetMaxHealth()*0.5
            local damageTable = {
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
                ability = self:GetAbility(), --Optional.
                }
            for i,enemy in pairs(enemies) do
                damageTable.victim = enemy
                ApplyDamage(damageTable)
            end
		end)
	
       



    end
end
function modifier_heroTalent_npc_dota_hero_techies:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},
    } 
end
--寒霜传送门 测试用
function modifier_heroTalent_npc_dota_hero_techies:AdvancedOnDeathAgain(keys)
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    local pos = caster:GetAbsOrigin()
    --print("哈哈哈哈哈我完成辣!!")
    local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControl( effect_cast, 0, pos )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(700,0,0) )
    caster:EmitSound("Hero_Techies.Suicide")
    ParticleManager:ReleaseParticleIndex( effect_cast )
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),	-- int, your team number
        pos,	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        700,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
        FIND_CLOSEST,	-- int, order filter
        false	-- bool, can grow cache
    )
    local damage = caster:GetMaxHealth()*0.5 * keys.mul_index
    local damageTable = {
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
        ability = self:GetAbility(), --Optional.
        }
    for i,enemy in pairs(enemies) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)
        --print("哈哈哈哈哈全部杀掉辣!!")
    end


end