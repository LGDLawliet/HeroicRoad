heroTalent_npc_dota_hero_shadow_demon_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_demon_2", "heroTalent/heroTalent_npc_dota_hero_shadow_demon_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff", "heroTalent/heroTalent_npc_dota_hero_shadow_demon_2", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_shadow_demon_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_shadow_demon_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_shadow_demon_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_shadow_demon_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_shadow_demon_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_shadow_demon_2" end
function heroTalent_npc_dota_hero_shadow_demon_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/shadow_demon_2/effect.vpcf", context )
end

modifier_heroTalent_npc_dota_hero_shadow_demon_2 = class({})

function modifier_heroTalent_npc_dota_hero_shadow_demon_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_shadow_demon_2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff", {})
	end
end



modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff = modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff or class({})

function modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shadow_demon_2_buff:OnDestroy()
	if IsServer() then
		local unit = self:GetParent()
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/talent/shadow_demon_2/effect.vpcf", PATTACH_ABSORIGIN, unit)
        local pos = unit:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		DestroyParticleByDelay(particle_cast_fx,3)
		unit:EmitSound("Hero_ShadowDemon.DemonicPurge.Damage")

		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = unit:GetMaxHealth()*0.45
		local damageTable = {
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
			ability = self:GetAbility(), --Optional.
			}
		for i,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end
	end
end	