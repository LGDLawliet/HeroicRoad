LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_nevermore_3", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_fear", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_model", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_nevermore_3 = class({})

function heroTalent_npc_dota_hero_nevermore_3:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/legend_talent/nevermore_3/attack_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/legend_talent/nevermore_3/requiem_sp.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", context )
end

function heroTalent_npc_dota_hero_nevermore_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_nevermore_3"
end
-- legend_talent_1成就解锁判断
function heroTalent_npc_dota_hero_nevermore_3:Unlockachievement()
	--print("成就已解锁")
	self.customAchievement = true
end
-- 发送数据包，解锁成就
function heroTalent_npc_dota_hero_nevermore_3:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("legend_talent_1")
		end
	end
end
-- 判断是否是排行榜难度
function heroTalent_npc_dota_hero_nevermore_3:IsRangedMode()
	if not IsServer() then
		return
	end
	if  _G.GAME_CHANLLENGE_Contest_Type == 1 or _G.GAME_CHANLLENGE_Contest_Type == 2 then
		return true
	end
	return false
end
-- 预释放释放特效
function heroTalent_npc_dota_hero_nevermore_3:OnAbilityPhaseStart()
	self:PlayEffects1()
	return true -- if success
end
-- 打断特效
function heroTalent_npc_dota_hero_nevermore_3:OnAbilityPhaseInterrupted()
	self:StopEffects1( false )
end
-- 主动
function heroTalent_npc_dota_hero_nevermore_3:OnSpellStart()
	self:SoulRequiem()
end
-- 奥义：魂之挽歌
function heroTalent_npc_dota_hero_nevermore_3:SoulRequiem()
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	local ability = self
	local origin = caster:GetAbsOrigin()
	
	-- 获取技能参数
	local line_length = ability:GetSpecialValueFor("line_length") -- 建议设置为1200
	local line_speed = ability:GetSpecialValueFor("line_speed")   -- 建议设置为900
	local line_width = ability:GetSpecialValueFor("line_width")   -- 建议设置为150
	local soul_num = ability:GetSpecialValueFor("soul_num")       -- 灵魂个数

	self.damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetAgility()
	self.caster = self:GetCaster()
	local num_lines = soul_num
	local angle_per_line = 360 / num_lines
	
	-- 播放主特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, origin)
	ParticleManager:SetParticleControl(pfx, 1, Vector(num_lines, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	
	-- 创建灵魂
	for i = 0, num_lines-1 do
		local angle = i * angle_per_line
		local direction = Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0)
		local info = {
			Ability = ability,
			EffectName = "particles/rebuild/legend_talent/nevermore_3/requiem_sp.vpcf",
			vSpawnOrigin = origin,
			fDistance = line_length,
			fStartRadius = line_width,
			fEndRadius = line_width,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = direction * line_speed,
			bProvidesVision = false
		}
		
		ProjectileManager:CreateLinearProjectile(info)
	end
	EmitSoundOn("Hero_Nevermore.RequiemOfSouls", caster)
	self:StopEffects1(true)
end
-- 魂之挽歌灵魂命中
function heroTalent_npc_dota_hero_nevermore_3:OnProjectileHit(target, location)
    if target then
		-- 首先施加恐惧
		target:AddNewModifier(
            self.caster,
            self,
            "modifier_heroTalent_npc_dota_hero_nevermore_3_fear",
            {duration = self:GetSpecialValueFor("fear_duration")}
        )
		-- 判断毁灭阴影种类
		local z = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz")
		local x = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx")
		local c = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc")
		local index = 100
		if z then
			index = index + self:GetSpecialValueFor("index")
		end
		if x then
			index = index + self:GetSpecialValueFor("index")
		end
		if c then
			index = index + self:GetSpecialValueFor("index")
		end
		--print("伤害修正"..index)
		-- 判断伤害和是否最大叠加
		local damage = self.damage * index*0.01
		local max = self:MaxRemove(target)
		local damageTable = {
			attacker = self.caster,
			victim = target,
			damage = damage,
			damage_type =  self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
		self:GetCaster():GameTimer(0.1,function()
			if z then
				z:SafeDestroy()
			end
			if x then
				x:SafeDestroy()
			end
			if c then
				c:SafeDestroy()
			end
			if max then
				max:SafeDestroy()
			end
		end)
    end
    return false -- 不删除投射物，允许穿透
end
-- 检测是否三种毁灭阴影
function heroTalent_npc_dota_hero_nevermore_3:MaxRemove(target)
	local down = 0
	local caster = self:GetCaster()

	local magic_res = target:Script_GetMagicalArmorValue(true,self)
	if magic_res>0 then
		down = magic_res*100
	end

	if down>0 then
		
		return  target:AddNewModifier(caster, self, "heroTalent_npc_dota_hero_nevermore_3_debuffall", {
			duration = 0.1,stack = down
		})
	end
	return nil
end
-- 技能：毁灭阴影（传回毁灭阴影类型、目标
function heroTalent_npc_dota_hero_nevermore_3:ShadowStrike(type,point)
	if not IsServer() then
		return
	end
	if self:IsRangedMode() then
		self.range = true
	end

	local caster = self:GetCaster()
    local point = point
    local duration = self:GetSpecialValueFor("duration")
	local unit = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_nevermore_3")
	

	-- 毁灭阴影Z
    if type == 1 then
		-- 这里传回的时候应该传回单体位置
		local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        point,
        nil,
        self:GetSpecialValueFor("radius_z"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,
        false
    	)
		local i = 0
		local max_z = self:GetSpecialValueFor("max_z")
		for _, enemy in pairs(enemies) do
			self:ShadowEffect(enemy)
			enemy:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz",{duration = duration})
			if not self.range then
				local hp_remove = enemy:GetHealth() * (self:GetSpecialValueFor("cut_z")*0.01)
				if Game_State:IsInChaoticEra() then
					hp_remove = hp_remove*0.2
				end
				local hp = enemy:GetHealth() - hp_remove
				enemy:ModifyHealth(hp, self, false, 0)
			end
			i = i + 1
			if i >= max_z then
				break
			end
		end
		unit.unit:StartGestureWithPlaybackRate(ACT_DOTA_RAZE_2,1.1)
	end

	-- 毁灭阴影X
    if type == 2 then
		-- 这里传回的时候应该传回点目标技能的施法位置
		local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        point,
        nil,
        self:GetSpecialValueFor("radius_x"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    	)
		local max_x = self:GetSpecialValueFor("max_x")
		local i = 0
		for _, enemy in pairs(enemies) do
			self:ShadowEffect(enemy)
			enemy:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx",{duration = duration})
			if not self.range then
				local hp_remove = (enemy:GetMaxHealth() - enemy:GetHealth()) * (self:GetSpecialValueFor("cut_x")*0.01)
				local hp = enemy:GetHealth() - hp_remove
				enemy:ModifyHealth(hp, self, false, 0)
			end

			i = i + 1
			if i >= max_x then
				break
			end
		end

		if unit then
			unit.unit:StartGestureWithPlaybackRate(ACT_DOTA_RAZE_3,1.1)
		end
	end

	-- 毁灭阴影C
    if type == 3 then
		-- 这里传回的时候应该传回自己的位置，其实我觉得也不用传回，哈哈
		local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        point,
        nil,
        self:GetSpecialValueFor("radius_c"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    	)
		local i = 0
		local max_c = self:GetSpecialValueFor("max_c")
		for _, enemy in pairs(enemies) do
			self:ShadowEffect(enemy)
			enemy:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc",{duration = duration})
			if not self.range then
				local hp_remove = enemy:GetMaxHealth() * (self:GetSpecialValueFor("cut_c")*0.01)
				local hp = enemy:GetHealth() - hp_remove
				enemy:ModifyHealth(hp, self, false, 0)
			end
			i = i + 1
			if i >= max_c then
				break
			end
		end

		if unit then
			unit.unit:StartGestureWithPlaybackRate(ACT_DOTA_RAZE_1,1.1)
		end
	end
end
-- 播放特效(target)
function heroTalent_npc_dota_hero_nevermore_3:ShadowEffect(target)
	local sound_cast = "Hero_Nevermore.Shadowraze.Arcana"
	local particle_caster_ground = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf" -- 特效1：毁灭阴影至宝
	self:GetCaster():EmitSoundParams(sound_cast,0, 0.3, 0 )
	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, self:GetCaster())
	local target_point = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 3, Vector(150, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
end
-- 声音特效开始
function heroTalent_npc_dota_hero_nevermore_3:PlayEffects1()
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"
	EmitSoundOn(sound_precast, self:GetCaster())
end
-- 声音特效结束
function heroTalent_npc_dota_hero_nevermore_3:StopEffects1( success )
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"
	if not success then
		StopSoundOn(sound_precast, self:GetCaster())
	end
end

-- 主要被动modifier-----------------------------------------------

modifier_heroTalent_npc_dota_hero_nevermore_3 = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_nevermore_3:RemoveOnDeath()return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3:GetPriority()return MODIFIER_PRIORITY_ULTRA end -- 因为涉及到传奇弹道
function modifier_heroTalent_npc_dota_hero_nevermore_3:OnCreated(table)
	self.bonus = 1 + self:GetAbility():GetSpecialValueFor("legend_bonus")*0.01
	if IsServer() then
		local pos = self:GetParent():GetAbsOrigin() + (self:GetParent():GetForwardVector() * -1) * 135
		self.unit  = CreateUnitByName("npc_hd_sf_legend", pos, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
		self.unit:SetOrigin(pos)
		self.unit:SetForwardVector(self:GetParent():GetForwardVector())
		self.unit:SetParent(self:GetParent(),nil)
		self.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_nevermore_3_model", {})
		self.unit:SetHealth(self.unit:GetMaxHealth())

		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 特效4：红光
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self:GetAbility():Unlockachievement()
	end
end

function modifier_heroTalent_npc_dota_hero_nevermore_3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_heroTalent_npc_dota_hero_nevermore_3:GetModifierProjectileName()
	return	"particles/rebuild/legend_talent/nevermore_3/attack_projectile.vpcf" -- 特效2：普通攻击弹道
end

function modifier_heroTalent_npc_dota_hero_nevermore_3:OnAbilityExecuted(keys)
	if not IsServer() then return end
	if keys.unit ~= self:GetParent() then return end
	local ability = keys.ability
	-- 不能是物品，不能是切换类
	if ability ~= nil and ( not ability:IsItem() ) and ( not ability:IsToggle() ) and ability:GetCooldown(ability:GetLevel()) > 3 then
		local caster = self:GetCaster()
		local behavior = ability:GetBehaviorInt()
		local range
		local cursorPosition = self:GetAbility():GetCursorPosition()
		local casterPosition = caster:GetAbsOrigin()
		local newPositon = cursorPosition
		--单位目标技能--
		if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
			if keys.target then
				self:GetAbility():ShadowStrike(1,keys.target:GetAbsOrigin())
			end
		end	
		--点目标技能--
		if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
			self:GetAbility():ShadowStrike(2,newPositon)
		end	
		--无目标技能--
		if bit.band(behavior,DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			self:GetAbility():ShadowStrike(3,casterPosition)
		end
		if not self:GetAbility():IsRangedMode() then
			caster:Purge(false, true, false, true, true)  --强驱散
		end
	end
end


-- 毁灭阴影Z
modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz:OnCreated(keys)
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing_z")
end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz:OnRefresh(keys)
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing_z")
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffz:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    return -self.outgoing
end
-- 毁灭阴影C
modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc:OnCreated(keys)
	self.posi_c = self:GetAbility():GetSpecialValueFor("posi_c")
end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc:OnRefresh(keys)
	self.posi_c = self:GetAbility():GetSpecialValueFor("posi_c")
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_DurationGain
    }
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffc:Advanced_GetModifier_DurationGain(keys)
    return -self.posi_c
end
-- 毁灭阴影X
modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx:OnCreated(keys)
	self.incoming_x = self:GetAbility():GetSpecialValueFor("incoming_x")
end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx:OnRefresh(keys)
	self.incoming_x = self:GetAbility():GetSpecialValueFor("incoming_x")
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffx:Advanced_GetModifierIncomingDamage_Percentage(keys)
    return self.incoming_x
end

-- 传说模型
modifier_heroTalent_npc_dota_hero_nevermore_3_model = modifier_heroTalent_npc_dota_hero_nevermore_3_model or class({})
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetStatusEffectName() return "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf" end -- 特效3：未知
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:OnCreated(keys)
	if IsServer() then

		self:GetParent():SetHullRadius(0)
		self.caster = self:GetCaster()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 特效4：红光
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_arm_L", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_arm_R", self:GetParent():GetAbsOrigin(), true )
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), true )

		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		self:StartIntervalThink(1)
	end
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_model:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:OnIntervalThink()
	self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
end
function modifier_heroTalent_npc_dota_hero_nevermore_3_model:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_model:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetVisualZDelta( params )

	return -130
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetOverrideAnimation(params)
	return ACT_DOTA_CAPTURE
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetModifierInvisibilityLevel()return 1 end


------ 恐慌
modifier_heroTalent_npc_dota_hero_nevermore_3_fear = class({})

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsStunDebuff() return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetEffectName()
    return "particles/generic_gameplay/generic_feared.vpcf"
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_FEARED] = true
    }
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetModifierMoveSpeed_Absolute()
    return 100 -- 恐慌移动速度
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(FrameTime())
        self.direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
    end
end

function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsNull() or not parent:IsAlive() then return end
        
        -- 更新逃跑方向
        self.direction = (parent:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
        parent:MoveToPosition(parent:GetAbsOrigin() + self.direction * 100)
    end
end

-- 全中无视魔法抗性modifier

modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall = class({})

function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:IsDebuff()			return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end	
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_heroTalent_npc_dota_hero_nevermore_3_debuffall:GetModifierMagicalResistanceBonus() return -self:GetStackCount() end