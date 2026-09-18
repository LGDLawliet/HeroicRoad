heroTalent_npc_dota_hero_faceless_void = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void", "heroTalent/heroTalent_npc_dota_hero_faceless_void", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void_move", "heroTalent/heroTalent_npc_dota_hero_faceless_void", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_faceless_void_inv", "heroTalent/heroTalent_npc_dota_hero_faceless_void", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_faceless_void:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_faceless_void"
end
function heroTalent_npc_dota_hero_faceless_void:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_v2_pentagon_jewel.vpcf", context )
end

modifier_heroTalent_npc_dota_hero_faceless_void = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_faceless_void:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_faceless_void:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_faceless_void:OnCreated(table)
	self.ability = self:GetAbility()
	self.line = self.ability:GetSpecialValueFor("line")*0.01
	self.heal = self.ability:GetSpecialValueFor("heal")*0.01
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.attack_radius = self.ability:GetSpecialValueFor("attack_radius")
	self.max = self.ability:GetSpecialValueFor("max")

	self.talentgain = self.ability:GetTalentGain(0.7)
	self.heal_t = self.heal*self.talentgain
	self.attack_radius_t = self.attack_radius*self.talentgain
	self.max_t = self.max*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_faceless_void:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_faceless_void:Advanced_GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then return end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if ability:IsCooldownReady() and params.damage >= parent:GetMaxHealth()*self.line then
		self:SpellToTarget()
		ability:UseResources(true, true, true, true)
		return -100
	end
end

function modifier_heroTalent_npc_dota_hero_faceless_void:SpellToTarget()
	if IsServer() then
		self.talentgain = self.ability:GetTalentGain(0.7)
		self.heal_t = self.heal*self.talentgain
		self.attack_radius_t = self.attack_radius*self.talentgain
		self.max_t = self.max*self.talentgain

		local caster = self:GetCaster()
		local losthp = caster:GetMaxHealth() - caster:GetHealth()
		caster:Heal(losthp*self.heal_t, self.ability)

		local pos = caster:GetAbsOrigin()-Vector(RandomInt(-self.radius, self.radius),RandomInt(-self.radius, self.radius),0)
		if pos==caster:GetAbsOrigin() then
			pos = pos+caster:GetForwardVector()
		end
		local direction = (pos - caster:GetAbsOrigin()):Normalized()    --GetAbsOrigin()应该是施法点  	Normalized()返回单位矢量
		direction.z = 0  --初始化Z值

		pos = caster:GetAbsOrigin()+direction*150
		local distance = math.min(300, (caster:GetAbsOrigin() - pos):Length2D())    --Length2D()矢量XY平面上长度（模） 该项为 如果释放点大于施法距离则取最大施法距离 否则则取施法点到自身的距离
		local tralve_duration = distance / 1000   --计算移动时间 为距离/速度(键值)
		caster:EmitSound( "Hero_FacelessVoid.TimeWalk" )
		caster:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_faceless_void_move", {duration = tralve_duration,dir = direction})  --添加冲刺修饰器 传入时间与一个点
		caster:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_faceless_void_inv", {duration = self.duration + tralve_duration})

		caster:GameTimer(tralve_duration,function ()
			if caster:IsAlive() then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.attack_radius_t, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
				for i, enemy in ipairs(enemies) do
					self:PlayEffects(enemy)

					local modifier_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave =1,
						iDisableSplit = 1,
					}
					local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
					caster:PerformAttack(enemy, true, true, true, false, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end
					if i >= self.max_t then
						break
					end
				end
			end
			-- 第二次
			caster:GameTimer(tralve_duration,function ()
				if caster:IsAlive() then
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.attack_radius_t, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					for i, enemy in ipairs(enemies) do
						self:PlayEffects(enemy)

						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =1,
							iDisableSplit = 1,
						}
						local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
						caster:PerformAttack(enemy, true, true, true, false, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						if i >= self.max_t then
							break
						end
					end
				end
			end)
		end)
		-- self:PlayEffects1( origin, target ,direction)
	end
end

function modifier_heroTalent_npc_dota_hero_faceless_void:PlayEffects(target)
    local particle_name = "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf"
    local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:ReleaseParticleIndex(particle)
    target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
end

function modifier_heroTalent_npc_dota_hero_faceless_void:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_TOOLTIP}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_faceless_void:OnTooltip(keys)
	self.talentgain = self.ability:GetTalentGain(0.7)
	self.heal_t = self.heal*self.talentgain
	self.attack_radius_t = self.attack_radius*self.talentgain
	self.max_t = self.max*self.talentgain

	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.heal_t*100
	end
	if self._tooltip == 2 then
		return  self.attack_radius_t
	end
	if self._tooltip == 3 then
		return  self.max_t
	end
end
---
modifier_heroTalent_npc_dota_hero_faceless_void_move = class({})

function modifier_heroTalent_npc_dota_hero_faceless_void_move:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_v2_pentagon_jewel.vpcf" end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:CheckState() return {[MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_STUNNED] = true} end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:IsMotionController() return true end
function modifier_heroTalent_npc_dota_hero_faceless_void_move:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_heroTalent_npc_dota_hero_faceless_void_move:OnCreated(keys)
	if IsServer() then
		--self.direction = StringToVector(keys.direction)
		self.direction =StringToVector( keys.dir)
		self.speed = 1000
		self.MotionControll = 1
		if not self.MotionControll then
			self:SafeDestroy()
		else
			self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
		end
	end
end

function modifier_heroTalent_npc_dota_hero_faceless_void_move:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	local me = self:GetParent()
	local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  --需要debug确认作用
	new_pos = GetGroundPosition(new_pos, nil)   --返回移动到提供的position的地面位置。第二个参数是一个NPC，用于测量碰撞体积
	me:SetOrigin(new_pos)  --Sets the location of this entity
	
	self.MotionControll = 0
end



function modifier_heroTalent_npc_dota_hero_faceless_void_move:OnDestroy()   --当时间漫游结束时
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true) 
		self.direction = nil
		self.speed = nil
	end
end
---
modifier_heroTalent_npc_dota_hero_faceless_void_inv = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_faceless_void_inv:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_faceless_void_inv:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_inv:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_inv:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_faceless_void_inv:CheckState()
	return{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end