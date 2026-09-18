-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_nevermore_3", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_debuff", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_tracked", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_tracked2", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_tracked3", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_fear", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_model", "heroTalent/heroTalent_npc_dota_hero_nevermore_3", LUA_MODIFIER_MOTION_NONE)
-- heroTalent_npc_dota_hero_nevermore_3 = class({})

-- function heroTalent_npc_dota_hero_nevermore_3:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/legend_talent/nevermore_3/attack_projectile.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", context )
-- 	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/legend_talent/nevermore_3/requiem_sp.vpcf", context )
-- 	PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", context )
-- end
-- function heroTalent_npc_dota_hero_nevermore_3:GetAOERadius()
--     return self:GetSpecialValueFor("shadow_radius")
-- end

-- function heroTalent_npc_dota_hero_nevermore_3:GetIntrinsicModifierName()
--     return "modifier_heroTalent_npc_dota_hero_nevermore_3"
-- end
-- -- legend_talent_1
-- function heroTalent_npc_dota_hero_nevermore_3:Unlockachievement()
-- 	--print("成就已解锁")
-- 	self.customAchievement = true
-- end
-- function heroTalent_npc_dota_hero_nevermore_3:OnCustomDataSettlement()
-- 	if self.customAchievement then
-- 		local caster = self:GetCaster()
-- 		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
-- 		if modifier then
-- 			modifier:UnlockCustomData("legend_talent_1")
-- 		end
-- 	end
-- end
-- function heroTalent_npc_dota_hero_nevermore_3:IsRangedMode()
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if  _G.GAME_CHANLLENGE_Contest_Type == 1 or _G.GAME_CHANLLENGE_Contest_Type == 2 then
-- 		return true
-- 	end
-- 	return false
-- end
-- function heroTalent_npc_dota_hero_nevermore_3:OnAbilityPhaseStart()
-- 	self:PlayEffects1()
-- 	return true -- if success
-- end
-- function heroTalent_npc_dota_hero_nevermore_3:OnAbilityPhaseInterrupted()
-- 	self:StopEffects1( false )
-- end
-- -- 主动
-- function heroTalent_npc_dota_hero_nevermore_3:OnSpellStart()
-- 	self:SoulRequiem()
-- end
-- -- 奥义：魂之挽歌
-- function heroTalent_npc_dota_hero_nevermore_3:SoulRequiem()
-- 	if not IsServer() then return end
	
-- 	local caster = self:GetCaster()
-- 	local ability = self
-- 	local origin = caster:GetAbsOrigin()
	
-- 	-- 获取技能参数
-- 	local line_length = ability:GetSpecialValueFor("line_length") -- 建议设置为1200
-- 	local line_speed = ability:GetSpecialValueFor("line_speed")   -- 建议设置为900
-- 	local line_width = ability:GetSpecialValueFor("line_width")   -- 建议设置为150
-- 	local soul_num = ability:GetSpecialValueFor("soul_num")       -- 灵魂个数
	
-- 	local num_lines = soul_num
-- 	local angle_per_line = 360 / num_lines
	
-- 	-- 播放主特效
-- 	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", PATTACH_ABSORIGIN, caster)
-- 	ParticleManager:SetParticleControl(pfx, 0, origin)
-- 	ParticleManager:SetParticleControl(pfx, 1, Vector(num_lines, 0, 0))
-- 	ParticleManager:ReleaseParticleIndex(pfx)
	
-- 	-- 创建灵魂
-- 	for i = 0, num_lines-1 do
-- 		local angle = i * angle_per_line
-- 		local direction = Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0)
		
-- 		local info = {
-- 			Ability = ability,
-- 			EffectName = "particles/rebuild/legend_talent/nevermore_3/requiem_sp.vpcf",
-- 			vSpawnOrigin = origin,
-- 			fDistance = line_length,
-- 			fStartRadius = line_width,
-- 			fEndRadius = line_width,
-- 			Source = caster,
-- 			bHasFrontalCone = false,
-- 			bReplaceExisting = false,
-- 			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
-- 			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
-- 			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
-- 			fExpireTime = GameRules:GetGameTime() + 10.0,
-- 			bDeleteOnHit = false,
-- 			vVelocity = direction * line_speed,
-- 			bProvidesVision = false
-- 		}
		
-- 		ProjectileManager:CreateLinearProjectile(info)
-- 	end
	
-- 	-- 播放音效
-- 	EmitSoundOn("Hero_Nevermore.RequiemOfSouls", caster)
-- 	self:StopEffects1(true)
-- end

-- function heroTalent_npc_dota_hero_nevermore_3:OnProjectileHit(target, location)
--     if target then
-- 		local pos = target:GetAbsOrigin()
-- 		local index = self:GetSpecialValueFor("index_active")
-- 		self:ShadowStrike(pos,index)
-- 		target:AddNewModifier(
--             self:GetCaster(),
--             self,
--             "modifier_heroTalent_npc_dota_hero_nevermore_3_fear",
--             {duration = self:GetSpecialValueFor("fear_duration")}
--         )
--     end
--     return false -- 不删除投射物，允许穿透
-- end

-- -- 技能：毁灭阴影
-- function heroTalent_npc_dota_hero_nevermore_3:ShadowStrike(pos,index)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	local caster = self:GetCaster()
--     local point = pos
-- 	local index = index*0.01
--     local radius = self:GetSpecialValueFor("shadow_radius")
--     local duration = self:GetSpecialValueFor("shadow_duration")
--     local base_incoming = self:GetSpecialValueFor("shadow_incoming")*index
--     local per_target_bonus = self:GetSpecialValueFor("shadow_index")*index
    
--     local enemies = FindUnitsInRadius(
--         caster:GetTeamNumber(),
--         point,
--         nil,
--         radius,
--         DOTA_UNIT_TARGET_TEAM_ENEMY,
--         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
--         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
--         FIND_ANY_ORDER,
--         false
--     )
    
--     -- 根据命中单位数量计算增伤
--     local hit_count = #enemies
--     local total_incoming = base_incoming + (hit_count - 1)*per_target_bonus
-- 	total_incoming = math.floor(total_incoming)
-- 	--print("增伤倍率为"..total_incoming)
    
--     -- 对所有命中单位施加debuff
--     for _, enemy in pairs(enemies) do
--         enemy:AddNewModifier(
--             caster,
--             self,
--             "modifier_heroTalent_npc_dota_hero_nevermore_3_debuff",
--             {
--                 duration = duration,
--                 damage_amp = total_incoming
--             }
--         )
--     end

-- 	local sound_cast = "Hero_Nevermore.Shadowraze.Arcana"
-- 	local particle_caster_ground = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf" -- 特效1：毁灭阴影至宝
-- 	caster:EmitSoundParams(sound_cast,0, 0.3, 0 )
-- 	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, caster)
-- 	local target_point = point
-- 	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
-- 	ParticleManager:SetParticleControl(particle_caster_ground_fx, 3, Vector(150, 0, 0))
-- 	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)

-- end

-- function heroTalent_npc_dota_hero_nevermore_3:PlayEffects1()
-- 	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"
-- 	EmitSoundOn(sound_precast, self:GetCaster())
-- end
-- function heroTalent_npc_dota_hero_nevermore_3:StopEffects1( success )
-- 	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"
-- 	if not success then
-- 		StopSoundOn(sound_precast, self:GetCaster())
-- 	end
-- end
-- -- 主要被动modifier

-- modifier_heroTalent_npc_dota_hero_nevermore_3 = advanced_modifier({})


-- function modifier_heroTalent_npc_dota_hero_nevermore_3:IsHidden() return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:IsPurgable() return false end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:GetPriority()return MODIFIER_PRIORITY_ULTRA end -- 因为涉及到传奇弹道
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:OnCreated(table)
-- 	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
-- 	self.status = self:GetAbility():GetSpecialValueFor("status")
-- 	self.radius = self:GetAbility():GetSpecialValueFor("radius")
-- 	self.bonus = 1 + self:GetAbility():GetSpecialValueFor("legend_bonus")*0.01
-- 	if IsServer() then
-- 		local pos = self:GetParent():GetAbsOrigin() + (self:GetParent():GetForwardVector() * -1) * 135
-- 		self.unit  = CreateUnitByName("npc_hd_sf_legend", pos, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
-- 		self.unit:SetOrigin(pos)
-- 		self.unit:SetForwardVector(self:GetParent():GetForwardVector())
-- 		self.unit:SetParent(self:GetParent(),nil)
-- 		self.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_nevermore_3_model", {})

-- 		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 特效4：红光
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )


-- 		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
-- 		self:GetAbility():Unlockachievement()
-- 	end
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3:ADDeclareFunctions()
--     return {
--         MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,nil},
-- 		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
-- 		advanced_MODIFIER_PROPERTY_StatusResistance,
--     }
-- end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:DeclareFunctions()
--     return {
--         MODIFIER_PROPERTY_PROJECTILE_NAME
--     }
-- end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:GetModifierProjectileName()
-- 	return	"particles/rebuild/legend_talent/nevermore_3/attack_projectile.vpcf" -- 特效2：普通攻击弹道
-- end
-- -- 灵魂御守
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:Advanced_GetModifierIncomingDamage_Percentage(keys)
-- 	if self:GetAbility():IsRangedMode() then
-- 		return
-- 	end
-- 	return -self.incoming
-- end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:Advanced_GetModifier_StatusResistance(keys)
-- 	if self:GetAbility():IsRangedMode() then
-- 		return
-- 	end
-- 	return self.status
-- end
-- -- 追魂影杀，破灭魂躯
-- function modifier_heroTalent_npc_dota_hero_nevermore_3:OnTakeDamage(event)
--     if not IsServer() then return end
--     local parent = self:GetParent()
--     local ability = self:GetAbility()
    
--     if event.unit == parent then
-- 		--print(self:GetAbility():IsRangedMode())
-- 		if self:GetAbility():IsRangedMode() == true then
-- 			return
-- 		end
--         -- 破灭魂躯强驱散检测
--         local current_hp_pct = parent:GetHealthPercent()
--         local purge_threshold = ability:GetSpecialValueFor("purge_line")
--         local damage_taken = event.damage
        
--         self.accumulated_damage = (self.accumulated_damage or 0) + damage_taken
--         if self.accumulated_damage >= parent:GetMaxHealth() * (purge_threshold / 100) then
--             parent:Purge(false, true, false, true, false)
-- 			parent:GameTimer(0.03,function()
-- 				parent:Purge(false, true, false, true, false)
-- 			end)
-- 			--print("超过自身最大生命值的8%，净化触发")
-- 			if event.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
-- 				local pos = event.attacker:GetAbsOrigin()
-- 				local index = ability:GetSpecialValueFor("index_3")
-- 				ability:ShadowStrike(pos,index)
-- 				self.unit:StartGestureWithPlaybackRate(ACT_DOTA_RAZE_3,1.1)
-- 			end
--             self.accumulated_damage = 0
--         end
--     end
    
--     -- 追魂影杀，灵魂构装体
--     if event.unit:GetTeamNumber() ~= parent:GetTeamNumber() then
--         local tri_threshold = ability:GetSpecialValueFor("tri_line")
-- 		local tri_threshold2 = ability:GetSpecialValueFor("tri_line2")
--         local current_hp_pct = event.unit:GetHealthPercent()

-- 		local distance = (self:GetParent():GetOrigin()-event.unit:GetOrigin()):Length2D()
-- 		if distance > self.radius then
-- 			return 
-- 		end

--         if current_hp_pct <= tri_threshold and not event.unit:HasModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_tracked") then
--             event.unit:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_nevermore_3_tracked", {})
-- 			local pos = event.unit:GetAbsOrigin()
-- 			local index = ability:GetSpecialValueFor("index")
--             ability:ShadowStrike(pos,index)
-- 			self.unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
-- 			--print("目标生命值低于60%，追击触发")
--         end

-- 		if current_hp_pct <= tri_threshold2 and not event.unit:HasModifier("modifier_heroTalent_npc_dota_hero_nevermore_3_tracked2") then
--             event.unit:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_nevermore_3_tracked2", {})
-- 			local pos = event.unit:GetAbsOrigin()
-- 			local index = ability:GetSpecialValueFor("index")
--             ability:ShadowStrike(pos,index)
-- 			self.unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
-- 			--print("目标生命值低于60%，追击触发")
--         end
		
-- 		if event.attacker == self:GetParent() then
-- 			local chance = self:GetAbility():GetSpecialValueFor("chance")
-- 			local random = math.random
-- 			local cd = self:GetParent():FindModifierByName("modifier_heroTalent_npc_dota_hero_nevermore_3_tracked3")
-- 			if chance >= random(1,100) then
-- 				if not cd then
-- 					event.attacker:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_nevermore_3_tracked3", {duration = 0.03})
-- 					local pos = event.unit:GetAbsOrigin()
-- 					local index = ability:GetSpecialValueFor("index_4")
-- 					ability:ShadowStrike(pos,index)
-- 					self.unit:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2,1.1)
-- 				end
-- 			end
-- 		end
--     end
-- end

-- -- 增伤独立叠加
-- modifier_heroTalent_npc_dota_hero_nevermore_3_debuff = advanced_modifier({})

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:IsDebuff() return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:IsPurgable() return false end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:OnCreated(keys)
-- 	self.ability = self:GetAbility()
-- 	if IsServer() then
-- 		self.tData = {}
-- 		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.damage_amp})
-- 		self:SetStackCount(keys.damage_amp)
-- 		self:StartIntervalThink(0.1)
-- 	end
-- end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:OnRefresh(keys)
-- 	if IsServer() then
-- 		-- local dieTime = self:GetDieTime()
-- 		local dieTime = GameRules:GetGameTime()+keys.damage_amp

		
-- 		table.insert(self.tData, {dieTime = dieTime,stack= keys.damage_amp })
-- 		self:SetStackCount( self:GetStackCount()+ keys.damage_amp)
-- 	end
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:OnIntervalThink()
-- 	if IsServer() then
-- 		-- local hParent = self:GetParent()
-- 		local fGameTime = GameRules:GetGameTime()

-- 		for i = #self.tData, 1, -1 do
-- 			if fGameTime >= self.tData[i].dieTime then
-- 				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
-- 				table.remove(self.tData, i)
				
-- 			end
-- 		end
-- 	end
-- end


-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:ADDeclareFunctions()
--     return {
--         advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
--     }
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
--     return self:GetStackCount()
-- end


-- -- 追魂影杀标记
-- modifier_heroTalent_npc_dota_hero_nevermore_3_tracked = class({})


-- function modifier_heroTalent_npc_dota_hero_nevermore_3_tracked:IsHidden() return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_tracked:IsPurgable() return false end
-- -- 追魂影杀标记
-- modifier_heroTalent_npc_dota_hero_nevermore_3_tracked2 = class({})


-- function modifier_heroTalent_npc_dota_hero_nevermore_3_tracked2:IsHidden() return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_tracked2:IsPurgable() return false end

-- -- 传说模型
-- modifier_heroTalent_npc_dota_hero_nevermore_3_model = modifier_heroTalent_npc_dota_hero_nevermore_3_model or class({})
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsHidden()	return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsDebuff()	return false end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:IsPurgeException()	return false end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetStatusEffectName() return "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf" end -- 特效3：未知
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:OnCreated(keys)
-- 	if IsServer() then

-- 		self:GetParent():SetHullRadius(0)
-- 		self.caster = self:GetCaster()
-- 		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 特效4：红光
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_arm_L", self:GetParent():GetAbsOrigin(), true )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_arm_R", self:GetParent():GetAbsOrigin(), true )
-- 		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), true )

-- 		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
-- 		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
-- 		self:StartIntervalThink(1)
-- 	end
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:OnDestroy()
-- 	if IsServer() then
-- 		-- self:GetParent():ForceKill(false)
-- 		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
-- 		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
-- 		ParticleManager:ReleaseParticleIndex( pfx )
-- 		UTIL_Remove(self:GetParent())
-- 	end
-- end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:OnIntervalThink()
-- 	self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
-- end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:CheckState()
-- 	return {
-- 		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
-- 		[MODIFIER_STATE_INVULNERABLE] = true,
-- 		[MODIFIER_STATE_OUT_OF_GAME] = true,
-- 		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
-- 		[MODIFIER_STATE_DISARMED] = true,
-- 		[MODIFIER_STATE_UNSELECTABLE] = true,
-- 	}
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
-- 		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
-- 		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
-- 		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
-- 		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
-- 	}
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetVisualZDelta( params )

-- 	return -130
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetOverrideAnimation(params)
-- 	return ACT_DOTA_IDLE_STATUE
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_model:GetModifierInvisibilityLevel()return 1 end


-- ------ 恐慌

-- modifier_heroTalent_npc_dota_hero_nevermore_3_fear = class({})

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsHidden() return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsDebuff() return true end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsStunDebuff() return false end
-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:IsPurgable() return false end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetEffectName()
--     return "particles/generic_gameplay/generic_feared.vpcf"
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetEffectAttachType()
--     return PATTACH_OVERHEAD_FOLLOW
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:CheckState()
--     return {
--         [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
--         [MODIFIER_STATE_FEARED] = true
--     }
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:DeclareFunctions()
--     return {
--         MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
--         MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
--     }
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetOverrideAnimation()
--     return ACT_DOTA_FLAIL
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:GetModifierMoveSpeed_Absolute()
--     return 100 -- 恐慌移动速度
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:OnCreated(kv)
--     if IsServer() then
--         self:StartIntervalThink(FrameTime())
--         self.direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
--     end
-- end

-- function modifier_heroTalent_npc_dota_hero_nevermore_3_fear:OnIntervalThink()
--     if IsServer() then
--         local parent = self:GetParent()
--         if parent:IsNull() or not parent:IsAlive() then return end
        
--         -- 更新逃跑方向
--         self.direction = (parent:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
--         parent:MoveToPosition(parent:GetAbsOrigin() + self.direction * 100)
--     end
-- end