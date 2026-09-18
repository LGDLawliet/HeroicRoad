LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abaddon_3", "heroTalent/heroTalent_npc_dota_hero_abaddon_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abaddon_3_active", "heroTalent/heroTalent_npc_dota_hero_abaddon_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom", "heroTalent/heroTalent_npc_dota_hero_abaddon_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation", "heroTalent/heroTalent_npc_dota_hero_abaddon_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown", "heroTalent/heroTalent_npc_dota_hero_abaddon_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heroTalent_npc_dota_hero_abaddon_3 == nil then
	heroTalent_npc_dota_hero_abaddon_3 = class({})
end


function heroTalent_npc_dota_hero_abaddon_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/abaddon_3/effect_hadowshaman_shackle_net_fall20.vpcf", context )

end




function heroTalent_npc_dota_hero_abaddon_3:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_abaddon_3_active" end


function heroTalent_npc_dota_hero_abaddon_3:Spawn()
	if IsServer() then
		self.killCount = 0
		self.unit_list = {}
		local caster = self:GetCaster()
		for _, unit in ipairs(self.unit_list) do
			if not unit:IsNull() then
				local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom")
				if modifier then
					modifier:SafeDestroy()
				end
			end
		end
		self:CallPhantom()
		caster:EmitSound("Hero_PhantomAssassin.Strike.End")
	end
	

end
-- function heroTalent_npc_dota_hero_abaddon_3:OnSpellStart()
-- 	local caster = self:GetCaster()


-- 	caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_abaddon_3_active", {duration=25})
-- 	for _, unit in ipairs(self.unit_list) do
-- 		if not unit:IsNull() then
-- 			local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom")
-- 			if modifier then
-- 				modifier:SafeDestroy()
-- 			end
-- 		end
-- 	end
-- 	self:CallPhantom()
-- 	caster:EmitSound("Hero_PhantomAssassin.Strike.End")
-- end

function heroTalent_npc_dota_hero_abaddon_3:CallPhantom()
	local caster = self:GetCaster()
	local ability = self

	local forward = caster:GetForwardVector()
	local duration = 15

	local parent = caster
	for i = 1, 5, 1 do
		local pos = parent:GetOrigin() - parent:GetForwardVector() *100
		local unit  = CreateUnitByName("npc_hd_abaddon_horse_ghost", pos, true, caster, caster, caster:GetTeamNumber())
		local modifier = unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom", {})
		if modifier then
			modifier:InitParent(parent)
		end
		unit:SetForwardVector(parent:GetForwardVector())
		parent = unit
		table.insert(self.unit_list,unit)
	end


end


function heroTalent_npc_dota_hero_abaddon_3:Unlockachievement()
	-- print("oooooooooooook")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_abaddon_3:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("horse_trainer_1")
			-- modifier:UnlockCustomDataWithValue("horse_trainer_1",self.killCount)
		end
	end

end

function heroTalent_npc_dota_hero_abaddon_3:AddKill()
	self.killCount = self.killCount + 1
	if not self.customAchievement and self.killCount>=150 then
		self:Unlockachievement()
	end
end


modifier_heroTalent_npc_dota_hero_abaddon_3_active = modifier_heroTalent_npc_dota_hero_abaddon_3_active or class({})
function modifier_heroTalent_npc_dota_hero_abaddon_3_active:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_abaddon_3_active:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_active:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_active:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_abaddon_3_active:OnCreated(keys)
-- 	if IsServer() then
-- 		self.moveDisList = {}
-- 		self.moveDis = 0
-- 		self.currentPos = self:GetParent():GetOrigin()
-- 		self.timer = 0
-- 		self:StartIntervalThink(0.03)
-- 	end
-- end

-- modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown

modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom = modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom or class({})
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:OnCreated(keys)
	if IsServer() then
		self.bonus_move = 0
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"horse_trainer_1") then
			self.horse_trainer_1 = true
		end
	end
end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:InitParent(parent)
	if IsServer() then
		self.followTarget = parent
		self.refresh_timer = 0


		self.moveDisList = {}
		self.moveDis = 0
		self.currentPos = self:GetParent():GetOrigin()
		self.timer = 0
		self:StartIntervalThink(0.03)

		parent = self:GetParent()
		local shackle_particle = ParticleManager:CreateParticle("particles/rebuild/talent/abaddon_3/effect_hadowshaman_shackle_net_fall20.vpcf", PATTACH_POINT_FOLLOW,self.followTarget)
		ParticleManager:SetParticleControlEnt(shackle_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 1, self.followTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.followTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 4, self.followTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.followTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 5, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(shackle_particle, 6, self.followTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		self:AddParticle(shackle_particle, true, false, -1, true, false)
	end
end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end





function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end


function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster then
		self:SafeDestroy()
		return
	end
	if not caster:HasModifier("modifier_heroTalent_npc_dota_hero_abaddon_3_active") then
		self:SafeDestroy()
		return
	end
	
	self.bonus_move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
	local parent = self:GetParent()
	local target = self:GetTarget()
	local pos =target:GetAbsOrigin()
	local forward = target:GetForwardVector()
	local target_pos = pos-forward*150
	-- target_pos.z = target_pos.z+128
	local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
	if dis>=2000 then
		parent:SetForwardVector(forward)
		parent:SetAbsOrigin(target_pos)
		return
	end
	if dis>=150 then
		parent:MoveToPosition(target_pos)
	end
	-- parent:SetForwardVector(forward)
	-- parent:SetAbsOrigin(target_pos)


	-- if parent:IsMoving() then
	-- 	local modifier = parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation")
	-- 	self.refresh_timer = self.refresh_timer+FrameTime()
	-- 	if modifier and self.refresh_timer<=5.7 then
	-- 		modifier:SetDuration(0.3, false)
	-- 	else
	-- 		self.refresh_timer = 0
	-- 		parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation", {duration=0.3}) 
	-- 	end
		
	-- end
	
	self:SearchDamage()
end



function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:SearchDamage()
	local parent = self:GetParent()
	local dis = CalculateDistance(parent,self.currentPos)
	self.currentPos = parent:GetOrigin()
	self.moveDis = self.moveDis + dis
	table.insert(self.moveDisList,dis)
	--计算过去1秒的移动距离
	if #self.moveDisList>=31 then
		self.moveDis = self.moveDis - self.moveDisList[1]
		table.remove(self.moveDisList,1)
	end
	-- print(self.moveDis)
	-- 过去1秒移动距离超过300
	if self.moveDis>=300 then
		self.timer = self.timer - FrameTime()
		local ability = self:GetAbility()
		local modifier = parent:FindModifierByName("modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation")
		self.refresh_timer = self.refresh_timer+FrameTime()
		if modifier and self.refresh_timer<=5.7 then
			modifier:SetDuration(0.3, false)
		else
			self.refresh_timer = 0
			parent:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation", {duration=0.3}) 
		end
		
		if self.timer<=0 then
			self.timer = 0.1
			local caster  =self:GetCaster()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 175, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local base_damage = self:GetAbility():GetSpecialValueFor("damage")
			local str_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
			local turn_damage = self:GetAbility():GetSpecialValueFor("turn_index")*0.01
			local damage = caster:GetStrength()*str_damage + self.moveDis*base_damage
			if self.horse_trainer_1 then
				damage = damage * 1.1
			end
			damage = damage * ((_G.GAME_ROUND-1)*turn_damage+1)
			
			local damageTable = {
	
				attacker =caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = ability, --Optional.
			}
			local knockBack_kv = 
			{
				center_x = self.currentPos.x,
				center_y = self.currentPos.y,
				center_z = self.currentPos.z,
				duration = 0.15,
				should_stun = true, 
				knockback_duration = 0.15,
				knockback_distance = 200,
				knockback_height = 15,
			}
			for _, unit in ipairs(units) do
				if not unit:HasModifier("modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown") then
					unit:AddNewModifier( caster, ability, "modifier_knockback", knockBack_kv )
					unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown", {duration=3}) 
					unit:EmitSound("Hero_Mars.Spear.Knockback")
					damageTable.victim = unit
					ApplyDamage(damageTable)
					if not unit:IsAlive() then
						ability:AddKill()
					end
				end
				

					
				
			end
		end
	end
end


function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}
end



function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:GetModifierMoveSpeed_AbsoluteMin()
	local caster = self:GetTarget()
	local index =  (self:GetParent():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()/500
	return math.max( caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true),self.bonus_move*index)
end

function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:GetTarget()
	if self.followTarget and not self.followTarget:IsNull() then
		return self.followTarget
	end
	return self:GetCaster()
end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:GetModifierIgnoreMovespeedLimit( params )
	return 1
end


-- function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom:GetOverrideAnimation()
-- 	return ACT_DOTA_TAUNT
-- end




modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:IsPurgable()	return false end


function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,

	}

	return funcs
end

-- function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:GetActivityTranslationModifiers( params )
-- 	return "throne"
-- end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_animation:GetOverrideAnimation()
	return ACT_DOTA_TAUNT
end







modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown = modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown or class({})
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_abaddon_3_Phantom_damage_cooldown:IsPurgeException()	return false end