heroTalent_npc_dota_hero_skywrath_mage_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skywrath_mage_2", "heroTalent/heroTalent_npc_dota_hero_skywrath_mage_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff", "heroTalent/heroTalent_npc_dota_hero_skywrath_mage_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_skywrath_mage_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_skywrath_mage_2"
end
function heroTalent_npc_dota_hero_skywrath_mage_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/skywrath_mage_2/effect_ambient_hit.vpcf", context )
end




modifier_heroTalent_npc_dota_hero_skywrath_mage_2 = class({})

function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,

	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=2 then

		local pos = keys.unit:GetCursorPosition()
		if keys.target then
			pos = keys.target:GetOrigin()
        end
		if pos==Vector(0,0,0) then
			pos = keys.unit:GetOrigin()
		end

		local duration =math.max(math.floor(keys.unit:GetIntellect(false)/50),2)
		local index = 1
		if duration>=20 then
			index = duration/20
			duration = 20
		end

		CreateModifierThinker(keys.unit, self, "modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff", {duration = duration,index=index}, pos, keys.unit:GetTeamNumber(), false)

	end
  
    
end












modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff = class({})

function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
		self.particle =  ParticleManager:CreateParticle("particles/rebuild/talent/skywrath_mage_2/effect_ambient_hit.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetOrigin())
		self.indxe = keys.index
	end
end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
	end
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage_2_buff:OnIntervalThink()
	if IsServer() then
		local pos = self:GetParent():GetOrigin()
		local caster = self:GetCaster()
		-- find enemies
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			150,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damageTable = {
			-- victim = target,
			attacker =caster,
			damage =caster:GetMaxMana()*0.15*self.indxe,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		for _,enemy in pairs(enemies) do
			-- damage
			damageTable.victim = enemy
			ApplyDamage( damageTable )
		end
		self:GetParent():EmitSound("Hero_SkywrathMage.MysticFlare.Target")

	end
end


