heroTalent_npc_dota_hero_techies_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_techies_2", "heroTalent/heroTalent_npc_dota_hero_techies_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_techies_2_passive", "heroTalent/heroTalent_npc_dota_hero_techies_2", LUA_MODIFIER_MOTION_NONE)



require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_techies_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_techies_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_techies_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", context )
end

function heroTalent_npc_dota_hero_techies_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_techies_2_passive" end

function heroTalent_npc_dota_hero_techies_2:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()
end

function heroTalent_npc_dota_hero_techies_2:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local pos = self:GetCursorPosition()
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_heroTalent_npc_dota_hero_techies_2", -- modifier name
		{duration = 5} -- kv
	)

    -- local new_modifier = caster:FindModifierByName("pszScriptName")
    if modifier then
        modifier:InitModifier(pos,5)
    end
end

function heroTalent_npc_dota_hero_techies_2:InitDamage(pos,damageSelf)
    local caster = self:GetCaster()
    local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_CUSTOMORIGIN,nil )
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
    local damage = caster:GetMaxMana()*0.03*_G.GAME_ROUND+10
    local damageTable = {
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
        ability = self, --Optional.
        }
    for i,enemy in pairs(enemies) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)
    end
    if damageSelf then
        damageTable.damage_flags =   damageTable.damage_flags +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
        damageTable.victim = caster
        ApplyDamage(damageTable)
    end

end



modifier_heroTalent_npc_dota_hero_techies_2 =  modifier_heroTalent_npc_dota_hero_techies_2 or class({})

function modifier_heroTalent_npc_dota_hero_techies_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_techies_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_techies_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_techies_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_techies_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_techies_2:InitModifier(pos,count)
    self.pos = pos
    self.count = count
    self.ability = self:GetAbility()
    local caster = self:GetCaster()
    local target_pos = self.pos
	local arc = caster:AddNewModifier(
		caster, -- player source
        self.ability, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = target_pos.x,
			target_y = target_pos.y,
			distance = CalculateDistance(caster,target_pos),
			duration = 0.75,
			height = 800,
			fix_end = false,
			-- isForward = true,
            activity = ACT_DOTA_FLAIL,
			-- isRestricted = true,
		} -- kv
	)
	arc:SetEndCallback(function()
        if not caster:IsAlive() then
            self:SafeDestroy()
            return
        end
        self:InitDamage(pos)
        self:CheckNextJump()
	end)
end

function modifier_heroTalent_npc_dota_hero_techies_2:InitDamage(pos)
    self.count =  self.count - 1
    self:GetAbility():InitDamage(pos,true)
end

function modifier_heroTalent_npc_dota_hero_techies_2:CheckNextJump()
    local caster = self:GetCaster()
    if not caster:IsAlive() then
        self:SafeDestroy()
        return
    end
    if  self.count>=1 then

        local target_pos = self.pos + Vector(RandomInt(-400, 400),RandomInt(-400, 400),0)
        caster:FaceTowards(target_pos)
        local arc = caster:AddNewModifier(
            caster, -- player source
            self.ability, -- ability source
            "modifier_generic_arc_lua", -- modifier name
            {
                target_x = target_pos.x,
                target_y = target_pos.y,
                distance = CalculateDistance(caster,target_pos),
                duration = 0.3,
                height = 800,
                fix_end = false,
                -- isForward = true,
                activity = ACT_DOTA_FLAIL,
                -- isRestricted = true,
            } -- kv
        )
        arc:SetEndCallback(function()
            if not caster:IsAlive() then
                self:SafeDestroy()
                return
            end
            self:InitDamage(target_pos)
            self:CheckNextJump()
        end)
    else
        self:SafeDestroy()
    end
end

function modifier_heroTalent_npc_dota_hero_techies_2:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end




modifier_heroTalent_npc_dota_hero_techies_2_passive = class({})

function modifier_heroTalent_npc_dota_hero_techies_2_passive:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_techies_2_passive:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_techies_2_passive:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_techies_2_passive:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_techies_2_passive:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_techies_2_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_techies_2_passive:OnDeath(keys)
    if not IsServer() then
        return
    end

	local parent = self:GetParent()
	if parent==keys.unit then
		return
	end
	if parent:PassivesDisabled() then
		return
	end
	if keys.attacker==parent and IsEnemy(keys.unit,parent) then
        if 1>=RandomInt(1, 10) then
            self:GetAbility():InitDamage(keys.unit:GetOrigin(),false)
        end
    end

	
end