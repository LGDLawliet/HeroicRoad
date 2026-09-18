


Primary_Void_time_walk = class({})

LinkLuaModifier("modifier_Primary_Void_time_walk_motion", "skills/Primary_Void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Void_time_walk_damage", "skills/Primary_Void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Void_time_walk_damage_counter", "skills/Primary_Void_time_walk", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Primary_Void_time_walk_Chronosphere_thinker", "skills/Primary_Void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Void_time_walk_Chronosphere_debuff", "skills/Primary_Void_time_walk", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Primary_Void_time_walk_talent_bonus", "skills/Primary_Void_time_walk", LUA_MODIFIER_MOTION_NONE)


--关于direction的需要调整。
function Primary_Void_time_walk:GetCastRange(vLocation, hTarget)
	if IsServer() then return 900000 end
	return self:GetSpecialValueFor( "range" )
end
function Primary_Void_time_walk:IsHiddenWhenStolen() 		return false end
function Primary_Void_time_walk:IsRefreshable() 			return true  end
function Primary_Void_time_walk:IsStealable() 			return true  end
function Primary_Void_time_walk:IsNetherWardStealable() 	return true end
function Primary_Void_time_walk:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self,iLevel) /(math.max(self:GetCaster():GetCooldownReduction(),0.001))
end
--[[该项为判断是否有神杖
function Primary_Void_time_walk:GetCastRange(location , target)   
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return self:GetSpecialValueFor("range") + self:GetSpecialValueFor("range_scepter") 
		else
			return self:GetSpecialValueFor("range")	
		end
	end
end




function Primary_Void_time_walk:GetCooldown(i) return (self:GetCaster():HasScepter() and (self.BaseClass.GetCooldown(self, i) + self:GetSpecialValueFor("cooldown_scepter")) or self.BaseClass.GetCooldown(self, i)) end
]]--
function Primary_Void_time_walk:GetIntrinsicModifierName() return "modifier_Primary_Void_time_walk_damage" end

function Primary_Void_time_walk:OnSpellStart()  --施法开始
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()  --获取鼠标位置

	direction = (pos - caster:GetAbsOrigin()):Normalized()    --GetAbsOrigin()应该是施法点  	Normalized()返回单位矢量
	direction.z = 0  --初始化Z值


	local max_distance = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()  --返回施法距离 后面的奖励值无视
	max_distance = math.max(max_distance,100)
	max_distance = math.min(max_distance,2000)
	--[[神杖
	if self:GetCaster():HasScepter() then
		max_distance = max_distance + self:GetSpecialValueFor("range_scepter")
	end
	]]--
	--local max_distance = self:GetCastRange(caster:GetAbsOrigin(),caster)
	local distance = math.min(max_distance, (caster:GetAbsOrigin() - pos):Length2D())    --Length2D()矢量XY平面上长度（模） 该项为 如果释放点大于施法距离则取最大施法距离 否则则取施法点到自身的距离
	local tralve_duration = distance / self:GetSpecialValueFor("speed")   --计算移动时间 为距离/速度(键值)
	local sound_name = "Hero_FacelessVoid.TimeWalk"      
	--[[拥有某个道具
	if HeroItems:UnitHasItem(caster, "jewel_of_aeons") then
		sound_name = "Hero_FacelessVoid.TimeWalk.Aeons"
	end
		]]--
	caster:AddNewModifier(caster, self, "modifier_Primary_Void_time_walk_motion", {duration = tralve_duration})  --添加冲刺修饰器 传入时间与一个点
	local buffs = caster:FindAllModifiersByName("modifier_Primary_Void_time_walk_damage_counter")  --启用伤害回溯修饰器
	local heal = 0 
	for _, buff in pairs(buffs) do
		heal = heal + buff:GetStackCount() / 10
	end
	caster:EmitSound(sound_name)
	if heal>0 then
		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_faceless_void_2") then
			local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_faceless_void_2")
			local duration = ability:GetSpecialValueFor("duration")
			caster:AddNewModifier(caster, self, "modifier_Primary_Void_time_walk_talent_bonus", {duration = duration,bonus_damage = heal}) 
			caster:Purge(false, true, false, false,true)
		end
		caster:Heal(heal, caster)  --	治疗该单位
	end


end
function Primary_Void_time_walk:CreateChronosphere(caster, position, radius, duration, ally_behavior)  --创造缝隙的函数
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, self, "modifier_Primary_Void_time_walk_Chronosphere_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	return thinker
end
modifier_Primary_Void_time_walk_motion = class({})

function modifier_Primary_Void_time_walk_motion:IsDebuff()			return false end
function modifier_Primary_Void_time_walk_motion:IsHidden() 			return true end
function modifier_Primary_Void_time_walk_motion:IsPurgable() 		return false end
function modifier_Primary_Void_time_walk_motion:IsPurgeException() 	return false end
function modifier_Primary_Void_time_walk_motion:GetEffectName() return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf" end
function modifier_Primary_Void_time_walk_motion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Void_time_walk_motion:CheckState() return {[MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_STUNNED] = true} end
function modifier_Primary_Void_time_walk_motion:IsMotionController() return true end
function modifier_Primary_Void_time_walk_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_Primary_Void_time_walk_motion:OnCreated(keys)
	if IsServer() then
		--self.direction = StringToVector(keys.direction)
		self.direction = direction

		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.effected_enemies = {}
		self.MotionControll = 1
		if not self.MotionControll then

			self:SafeDestroy()
		else
			self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
		end
	end
end

function modifier_Primary_Void_time_walk_motion:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	local me = self:GetParent()
	local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  --需要debug确认作用
	new_pos = GetGroundPosition(new_pos, nil)   --返回移动到提供的position的地面位置。第二个参数是一个NPC，用于测量碰撞体积
	me:SetOrigin(new_pos)  --Sets the location of this entity
	--创建时间结界
	self:GetAbility():CreateChronosphere(me, me:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("chrono_radius"), self:GetAbility():GetSpecialValueFor("chrono_linger"), 6)
	local enemy = FindUnitsInRadius(me:GetTeamNumber(), me:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("chrono_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	--self.effected_enemies = nil
	--self.effected_enemies = {}
	--PrintTable(enemy)
	
	for i=1, #enemy do
		
		--PrintTable(enemy[i])
		if not IsInTable(enemy[i], self.effected_enemies) then  --如果前面的单位不在后面的单位表里
			self.effected_enemies[#self.effected_enemies + 1] = enemy[i]  --则将其添加在单位表里
		end
	end
	--PrintTable(self.effected_enemies)
	self.MotionControll = 0
end
---------------------------------------------------------------------
function IsInTable(enemy,enemies)
	 for i=1, #enemies do	
		if enemy== enemies[i] then
			return true
		end
  end
  return false
end

------------------------------------------------------------------------------------------



function modifier_Primary_Void_time_walk_motion:OnDestroy()   --当时间漫游结束时
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)  --Place a unit somewhere not already occupied.
		self.direction = nil
		self.speed = nil
		--PrintTable(self.effected_enemies)
		

		
		--05-09 add by MysteryBug
		--[[  神杖效果
		if self:GetCaster():HasScepter() then 
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				CreateChronosphere(self:GetParent(), self:GetAbility(), enemy:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius_scepter"), 1, 2)
				--self:GetParent().splitattack = false
				self:GetParent():PerformAttack(enemy, false, true, true, true, false, false, false)
				--self:GetParent().splitattack = true
			end
		end
		]]--
	end
end


modifier_Primary_Void_time_walk_damage_counter = class({})

function modifier_Primary_Void_time_walk_damage_counter:IsDebuff()				return false end
function modifier_Primary_Void_time_walk_damage_counter:IsHidden() 				return true end
function modifier_Primary_Void_time_walk_damage_counter:IsPurgable() 			return false end
function modifier_Primary_Void_time_walk_damage_counter:IsPurgeException() 		return false end
function modifier_Primary_Void_time_walk_damage_counter:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Void_time_walk_damage_counter:RemoveOnDeath() return false end

modifier_Primary_Void_time_walk_damage = class({})

function modifier_Primary_Void_time_walk_damage:IsDebuff()				return false end
function modifier_Primary_Void_time_walk_damage:IsHidden() 				return true end
function modifier_Primary_Void_time_walk_damage:IsPurgable() 			return false end
function modifier_Primary_Void_time_walk_damage:IsPurgeException() 		return false end
function modifier_Primary_Void_time_walk_damage:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_Primary_Void_time_walk_damage:OnTakeDamage(keys)
	if not IsServer() then 
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end
	local duration = self:GetAbility():GetSpecialValueFor("damage_time")
	if keys.unit:HasModifier("modifier_heroTalent_npc_dota_hero_faceless_void_2") then
		duration = duration +3
	end
	local buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Primary_Void_time_walk_damage_counter", {duration = duration})
	if buff ~= nil then 
		local damage = keys.damage-keys.damage%1
		buff:SetStackCount(damage * 10)
	end
end


modifier_Primary_Void_time_walk_Chronosphere_thinker = class({})

function modifier_Primary_Void_time_walk_Chronosphere_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
		--[[
		if HeroItems:UnitHasItem(self:GetCaster(), "mace_of_aeons") and self.radius < 3000 then
			pfx_name = "particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf"
		end
		if HeroItems:UnitHasCustomItem(self:GetCaster()) and self.radius < 3000 then
			pfx_name = "particles/face/mace_of_aeons_ult/gold/fv_chronosphere_aeons_gold.vpcf"
		end
		if HeroItems:UnitHasCustomFemaleItem(self:GetCaster()) and self.radius < 3000 then
			pfx_name = "particles/face/mace_of_aeons_ult/red/fv_chronosphere_aeons_red.vpcf"
		end
		if HeroItems:UnitHasItem(self:GetCaster(), "rubick_arcana") and self.radius < 3000 then
			pfx_name = "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf"
		end
		if tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID()))) == 76561198054050405 and self.radius < 3000 then 
			pfx_name = "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf"
		end
]]--
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_thinker:IsAura() return true end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetAuraDuration() return 0.1 end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetModifierAura() return "modifier_Primary_Void_time_walk_Chronosphere_debuff" end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetAuraRadius() return self.radius end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_Void_time_walk_Chronosphere_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end



function modifier_Primary_Void_time_walk_Chronosphere_thinker:OnDestroy()
	if IsServer() then
		
		UTIL_Remove(self:GetParent())
		
	end
end
modifier_Primary_Void_time_walk_Chronosphere_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Ally_Scepter = 3
Chronosphere_Enemy = 4
Chronosphere_Enemy_Ability = 5

function modifier_Primary_Void_time_walk_Chronosphere_debuff:OnCreated()
	self.buff_type = 0
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()then
		self.buff_type = Chronosphere_Caster
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally_Scepter
	else
		self.buff_type = Chronosphere_Enemy
	end
	self.ms = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * (1 - (self:GetAbility():GetSpecialValueFor("slow_scepter") / 100))
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:OnIntervalThink()

	self:GetParent():InterruptMotionControllers(false)
	self:GetParent():SetOrigin(self.abs)
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:IsHidden() 			return false end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:IsPurgable() 			return false end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:IsPurgeException() 	return false end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:StatusEffectPriority() return 16 end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:CheckState()
	if self:IsMotionController() then
		return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_FROZEN] = true}
	elseif self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN, MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMin()
	if self.buff_type == Chronosphere_Caster then
		return self:GetAbility():GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMax()
	if self.buff_type ==  Chronosphere_Caster then
		return self:GetAbility():GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetModifierTurnRate_Percentage()
	if self.buff_type == Chronosphere_Ally_Scepter then
		return (0 -self:GetAbility():GetSpecialValueFor("slow_scepter"))
	else
		return nil
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:GetModifierAttackSpeedBonus_Constant()
	if self.buff_type == Chronosphere_Caster then
		return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_as"))
	else
		return nil
	end
end

function modifier_Primary_Void_time_walk_Chronosphere_debuff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetCaster() or self:GetAbility() ~= self:GetParent():FindAbilityByName("Primary_Void_time_walk_Chronosphere") then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:HasModifier("modifier_Primary_Void_time_walk_Chronosphere_debuff") or not keys.target:IsAlive() then
		return
	end
	self:IncrementStackCount()
end
 



modifier_Primary_Void_time_walk_talent_bonus =  modifier_Primary_Void_time_walk_talent_bonus or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Void_time_walk_talent_bonus:IsHidden()	return false end
function modifier_Primary_Void_time_walk_talent_bonus:IsDebuff()	return false end
function modifier_Primary_Void_time_walk_talent_bonus:IsPurgable()	return false end
function modifier_Primary_Void_time_walk_talent_bonus:OnCreated( keys )
	if IsServer() then
		self.deelay = false
		local ability = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_faceless_void_2")
		if ability then
			self.index = ability:GetSpecialValueFor("index")*0.01
		end
		self:SetStackCount(math.min(keys.bonus_damage*self.index,8000))
	end
end

function modifier_Primary_Void_time_walk_talent_bonus:OnRefresh( keys )
	if IsServer() then
		self:SetStackCount(math.min(keys.bonus_damage*self.index,8000))
	end
end

function modifier_Primary_Void_time_walk_talent_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end
function modifier_Primary_Void_time_walk_talent_bonus:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end
