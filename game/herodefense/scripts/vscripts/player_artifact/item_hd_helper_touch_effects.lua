-- 重做完成
item_hd_helper_touch_effects = class({})
LinkLuaModifier("modifier_item_hd_helper_touch_effects", "player_artifact/item_hd_helper_touch_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helper_touch_effects_attack", "player_artifact/item_hd_helper_touch_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_helper_touch_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_helper_touch_effects"
end
function item_hd_helper_touch_effects:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_chain_frost.vpcf", context )

end

modifier_item_hd_helper_touch_effects = advanced_modifier({})

function modifier_item_hd_helper_touch_effects:IsDebuff()			return false end
function modifier_item_hd_helper_touch_effects:IsHidden() 			return true end
function modifier_item_hd_helper_touch_effects:IsPurgable() 		    return false end
function modifier_item_hd_helper_touch_effects:IsPurgeException() return false end
function modifier_item_hd_helper_touch_effects:RemoveOnDeath() return false end
function modifier_item_hd_helper_touch_effects:AllowIllusionDuplicate() return false end


function modifier_item_hd_helper_touch_effects:OnCreated( kv )
	if not self:GetParent():IsRealHero() then
		return
	end
	self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.bonus_positive_amp = self.ability:GetArtifactSpecialValueFor("bonus_positive_amp")
	self.cast_range = self.ability:GetArtifactSpecialValueFor("cast_range")
	self.positive_amp_7 = self.ability:GetArtifactSpecialValueFor("positive_amp_7")
    -- 环绕位置和半径
	self.zero = Vector(0,0,0)
	self.revolution = 2.5
	self.rotate_radius = 240
	self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_helper_touch_effects")

	if self.level >= 70 then
		self.bonus_positive_amp = self.bonus_positive_amp + self.positive_amp_7
	end
	if not IsServer() then return end

	self.interval = 0.03
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	self.rotate_delta = 360/self.revolution * self.interval

	self.position = self.parent:GetOrigin() + self.relative_pos
	self.rotation = 0
	self.facing = self.base_facing

	-- 召唤魔方
	self.wisp = CreateUnitByName(
		"npc_dota_helper",
		self.position,
		true,
		self.parent,
		self.parent:GetOwner(),
		self.parent:GetTeamNumber()
	)
	self.wisp:SetForwardVector( self.facing )

	-- 魔方原理
	self.wispmodifier = self.wisp:AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_item_hd_helper_touch_effects_attack",
		{level = self.level}
	)

	self:StartIntervalThink( self.interval )
end

function modifier_item_hd_helper_touch_effects:OnRefresh()
	self.bonus_positive_amp = self.ability:GetArtifactSpecialValueFor("bonus_positive_amp")
	self.cast_range = self.ability:GetArtifactSpecialValueFor("cast_range")
	self.positive_amp_7 = self.ability:GetArtifactSpecialValueFor("positive_amp_7")
	if self.level >= 70 then
		self.bonus_positive_amp = self.bonus_positive_amp + self.positive_amp_7
	end
end

function modifier_item_hd_helper_touch_effects:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self.wisp )
end

function modifier_item_hd_helper_touch_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_DurationGain,
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end

function modifier_item_hd_helper_touch_effects:Advanced_GetModifier_DurationGain()
    return self.bonus_positive_amp
end

function modifier_item_hd_helper_touch_effects:Advanced_GetModifierCastRangeBonusStacking()
	return self.cast_range
end

function modifier_item_hd_helper_touch_effects:OnIntervalThink()
    -- 用于纠正位置的think
	self.rotation = self.rotation + self.rotate_delta
	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )

	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end

------------------------------------------------------------------------------------
modifier_item_hd_helper_touch_effects_attack = advanced_modifier({})


function modifier_item_hd_helper_touch_effects_attack:IsHidden()	return true end
function modifier_item_hd_helper_touch_effects_attack:IsDebuff()	return false end
function modifier_item_hd_helper_touch_effects_attack:IsStunDebuff()	return false end
function modifier_item_hd_helper_touch_effects_attack:IsPurgable()	return false end
function modifier_item_hd_helper_touch_effects_attack:GetEffectName() return "particles/units/heroes/hero_wisp/wisp_ambient.vpcf" end
function modifier_item_hd_helper_touch_effects_attack:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_helper_touch_effects_attack:OnCreated( kv )
    self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.cost_get_4 = self.ability:GetArtifactSpecialValueFor("cost_get_4")
	self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
	self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
	self.index_2 = self.ability:GetArtifactSpecialValueFor("index_2")*0.01
	self.duration_10 = self.ability:GetArtifactSpecialValueFor("duration_10")
	if not IsServer() then return end
    self:SetStackCount(0)
	self:StartIntervalThink(self.ability:GetArtifactSpecialValueFor("interval_4"))
	self.level = kv.level
	-- self:PlayEffects()
end

function modifier_item_hd_helper_touch_effects_attack:OnIntervalThink()
	if not self.caster:IsAlive() then
		return
	end
    self.level = GetArtifactLevel(self.caster:GetPlayerOwnerID(),"item_hd_helper_touch_effects")

	if self.level >= 10 then
        self:lvl10()
    end
	if self.level >= 30 then
        self:lvl30()
    end
    if self.level >= 40 then
        self:lvl40()
    end
	if self.level >= 100 then
		if GetChaoticEraClass(self.caster) == 4 then
			self:lvl100()
		end
	end
end
function modifier_item_hd_helper_touch_effects_attack:lvl100()
	if not IsServer() then return end
	local heroes = GetAllRealHeroes()
	for _, hero in pairs(heroes) do
		if hero:IsAlive() and GetChaoticEraClass(hero) ~= 4 then
			local buff_r = hero:FindModifierByName("modifier_item_chaotic_class_ass_active")
			if buff_r then
				buff_r:ForceRefresh()
				buff_r:SetDuration(buff_r:GetRemainingTime() + self.duration_10)
			else
				hero:AddNewModifier(self.caster, self.ability, "modifier_item_chaotic_class_ass_active", {duration = self.duration_10})
			end
		end
	end
end
function modifier_item_hd_helper_touch_effects_attack:lvl40()
    -- 判定范围，找到最远的英雄
    local caster = self.caster
    local parent = self.parent
    local radius = 100000
	local targettable = {}
    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
    for i , hero in pairs(heroes) do
		table.insert(targettable, hero)
		if self.level < 70 then
        	break
		else
			if i >= 2 then
				break
			end
		end
    end
	
	-- 对表中的每个英雄重复效果
	for _, target in pairs(targettable) do
		if not target then return end
		-- 弹道赋予
		self:CreateProjectile(target,3)
		-- 弹道无法实现，因此通过距离和弹道速度拟似实现
		local time = CalculateDistance(target,self:GetParent())/1400
		parent:GameTimer(time,function ()
			if not target then
				return
			end
			target:EmitSound("Hero_ObsidianDestroyer.projectileImpact")
			target:AddNewModifier(caster, self:GetAbility(), "modifier_hd_trigger", {cost_get = self.cost_get_4})
		end)
	end
end

function modifier_item_hd_helper_touch_effects_attack:lvl10()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = 100000
	local index = 0
	local targettable = {}

    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
    for i , hero in pairs(heroes) do
		local stone = hero:FindModifierByName("modifier_chaotic_stoneskin")
		local aid = hero:FindModifierByName("modifier_chaotic_aid")
		if stone or aid then
			table.insert(targettable, {hero = hero, stone = stone, aid = aid})
        	if self.level < 70 then
				break
			else
				if i >= 2 then
					break
				end
			end
		end
    end

    -- 对表中的每个英雄重复效果
    for _, targetData in pairs(targettable) do
		local target = targetData.hero
		local stone = targetData.stone
		local aid = targetData.aid
		
		if not target then return end
		-- 弹道赋予
		self:CreateProjectile(target,1)
		-- 弹道无法实现，因此通过距离和弹道速度拟似实现
		local time = CalculateDistance(target,self:GetParent())/1400
		self:GetParent():GameTimer(time,function ()
			if not target then
				return
			end
			target:EmitSound("Hero_Oracle.FortunesEnd.Attack")
			local duration = self.duration_1

			if self.level >= 20 then
				index = self.index_2
			end

			local gain = caster:GetModifierDurationGainIndex(index)
			if stone then
				stone:SetDuration(stone:GetRemainingTime() + duration*gain, true)
			end
			if aid then
				aid:SetDuration(aid:GetRemainingTime() + duration*gain, true)
			end
		end)
    end
end

function modifier_item_hd_helper_touch_effects_attack:lvl30()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = 100000
	local targettable = {}

    local heroes = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
    for i , hero in pairs(heroes) do
		local element_weapon = hero:FindModifierByName("modifier_chaotic_elemental_weapon")
		local giant = hero:FindModifierByName("modifier_chaotic_enlarge")
		if element_weapon or giant then
			table.insert(targettable, {hero = hero, element_weapon = element_weapon, giant = giant})
        	if self.level < 70 then
				break
			else
				if i >= 2 then
					break
				end
			end
		end
    end

    -- 对表中的每个英雄重复效果
    for _, targetData in pairs(targettable) do
		local target = targetData.hero
		local element_weapon = targetData.element_weapon
		local giant = targetData.giant
		
		if not target then return end
		-- 声音特效
		caster:EmitSound("Hero_Alchemist.UnstableConcoction.Throw")
		-- 弹道赋予
		self:CreateProjectile(target,2)
		-- 弹道无法实现，因此通过距离和弹道速度拟似实现
		local time = CalculateDistance(target,self:GetParent())/1400
		self:GetParent():GameTimer(time,function ()
			if not target then
				return
			end
			target:EmitSound("Hero_Alchemist.ChemicalRage.Cast")
			local duration = self.duration_3
			local index = self.index_2
			local gain = caster:GetModifierDurationGainIndex(index)

			if element_weapon and element_weapon:GetRemainingTime() then
				local element_weapon_rune1 = target:FindModifierByName("modifier_chaotic_elemental_weapon_rune_1")
				local element_weapon_rune2 = target:FindModifierByName("modifier_chaotic_elemental_weapon_rune_2")
				local element_weapon_rune3 = target:FindModifierByName("modifier_chaotic_elemental_weapon_rune_3")
				element_weapon:SetDuration(element_weapon:GetRemainingTime() + duration*gain, true)

				if element_weapon_rune1 and element_weapon_rune1:GetRemainingTime() then
					element_weapon_rune1:SetDuration(element_weapon_rune1:GetRemainingTime() + duration*gain, true)
				end
				if element_weapon_rune2 and element_weapon_rune2:GetRemainingTime() then
					element_weapon_rune2:SetDuration(element_weapon_rune2:GetRemainingTime() + duration*gain, true)
				end
				if element_weapon_rune3 and element_weapon_rune3:GetRemainingTime() then
					element_weapon_rune3:SetDuration(element_weapon_rune3:GetRemainingTime() + duration*gain, true)
				end
			end
			
			if giant then
				giant:SetDuration(giant:GetRemainingTime() + duration*gain, true)
			end
		end)
    end
end

function modifier_item_hd_helper_touch_effects_attack:CreateProjectile(target,type)
    local effects = {
        "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
        "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
        "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
    } 

	local info = 
	{
		Target =target,
		Source = self:GetParent(),
		vSourceLoc = self:GetParent():GetAbsOrigin(),
		Ability = self:GetAbility(),	
		EffectName = effects[type],
		iMoveSpeed = 1400,
		bDrawsOnMinimap = false,  --？？
		bDodgeable = false,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 30, --存在时间
		bProvidesVision = true, --提供视野
		ExtraData = {}   --额外的数据
	}
	
	ProjectileManager:CreateTrackingProjectile(info)
end

function modifier_item_hd_helper_touch_effects_attack:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end

function modifier_item_hd_helper_touch_effects_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_item_hd_helper_touch_effects_attack:GetOverrideAnimation(params)
	if self:GetStackCount()==0 then
		return ACT_DOTA_IDLE
	end
	return ACT_DOTA_CAST_ABILITY_5
end






