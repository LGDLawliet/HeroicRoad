


creeps_Void_time_walk = class({})
require('internal/timers')   --计时器功能
LinkLuaModifier("modifier_creeps_Void_time_walk_motion", "creeps_spell/creeps_Void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_Void_time_walk_damage", "creeps_spell/creeps_Void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_Void_time_walk_damage_counter", "creeps_spell/creeps_Void_time_walk", LUA_MODIFIER_MOTION_NONE)

function creeps_Void_time_walk:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/void_time_walk_arc_1/effectarcana/faceless_void_arcana_time_walk_preimage_combined.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_ambient.vpcf", context )
end

function creeps_Void_time_walk:GetCastRange(vLocation, hTarget)
	if IsServer() then return 900000 end
	return self:GetSpecialValueFor( "range" )
end
function creeps_Void_time_walk:IsHiddenWhenStolen() 		return false end
function creeps_Void_time_walk:IsRefreshable() 			return true  end
function creeps_Void_time_walk:IsStealable() 			return true  end
function creeps_Void_time_walk:IsNetherWardStealable() 	return true end
-- function creeps_Void_time_walk:GetCooldown(iLevel)
-- 	return self.BaseClass.GetCooldown(self,iLevel) /(math.max(self:GetCaster():GetCooldownReduction(),0.001))
-- end
--[[该项为判断是否有神杖
function creeps_Void_time_walk:GetCastRange(location , target)   
	if IsClient() then 
		if self:GetCaster():HasScepter() then
			return self:GetSpecialValueFor("range") + self:GetSpecialValueFor("range_scepter") 
		else
			return self:GetSpecialValueFor("range")	
		end
	end
end
function creeps_Void_time_walk:GetCooldown(i) return (self:GetCaster():HasScepter() and (self.BaseClass.GetCooldown(self, i) + self:GetSpecialValueFor("cooldown_scepter")) or self.BaseClass.GetCooldown(self, i)) end
]]--
function creeps_Void_time_walk:GetIntrinsicModifierName() return "modifier_creeps_Void_time_walk_damage" end

Spell_sound = {
	"faceless_void_fv_arc_ability_timewalk_01",
	"faceless_void_fv_arc_ability_timewalk_02",
	"faceless_void_fv_arc_ability_timewalk_03",
	"faceless_void_fv_arc_ability_timewalk_04",
	"faceless_void_fv_arc_ability_timewalk_05",
	"faceless_void_fv_arc_ability_timewalk_06",
	"faceless_void_fv_arc_ability_timewalk_07",
	"faceless_void_fv_arc_ability_timewalk_08",
	"faceless_void_fv_arc_ability_timewalk_09",
	"faceless_void_fv_arc_ability_timewalk_10",
	"faceless_void_fv_arc_ability_timewalk_11",
	"faceless_void_fv_arc_ability_timewalk_12",
	"faceless_void_fv_arc_ability_timewalk_13",
	"faceless_void_fv_arc_ability_timewalk_14",
	"faceless_void_fv_arc_ability_timewalk_15",

}




function creeps_Void_time_walk:OnSpellStart()  --施法开始
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()  --获取鼠标位置

	local direction = (pos - caster:GetAbsOrigin()):Normalized()    --GetAbsOrigin()应该是施法点  	Normalized()返回单位矢量
	direction.z = 0  --初始化Z值
	local max_distance = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()  --返回施法距离 后面的奖励值无视
	max_distance = math.min(max_distance,2000)
	local distance = math.min(max_distance, (caster:GetAbsOrigin() - pos):Length2D())   
	local tralve_duration = math.min(distance / self:GetSpecialValueFor("speed"),0.5)   --计算移动时间 为距离/速度(键值)
	local speed = distance/tralve_duration
	local sound_name = "Hero_FacelessVoid.TimeWalk"      
	--[[拥有某个道具
	if HeroItems:UnitHasItem(caster, "jewel_of_aeons") then
		sound_name = "Hero_FacelessVoid.TimeWalk.Aeons"
	end
		]]--
	caster:AddNewModifier(caster, self, "modifier_creeps_Void_time_walk_motion", {duration = tralve_duration,speed=speed,direction_x = direction.x,direction_y=direction.y})  
	local buffs = caster:FindAllModifiersByName("modifier_creeps_Void_time_walk_damage_counter")  --启用伤害回溯
	local heal = 0 
	for _, buff in pairs(buffs) do
		heal = heal + buff:GetStackCount() / 10
	end
	caster:EmitSound(sound_name)
	local healing = HealWithGain(heal,caster,caster,self)

	if caster:GetUnitName()=="npc_hd_Claszian_Apostasy" then
		EmitGlobalSound(Spell_sound[RandomInt(1, #Spell_sound)])
	end

end

modifier_creeps_Void_time_walk_motion = class({})

function modifier_creeps_Void_time_walk_motion:IsDebuff()			return false end
function modifier_creeps_Void_time_walk_motion:IsHidden() 			return true end
function modifier_creeps_Void_time_walk_motion:IsPurgable() 		return false end
function modifier_creeps_Void_time_walk_motion:IsPurgeException() 	return false end
function modifier_creeps_Void_time_walk_motion:GetEffectName() return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf" end
function modifier_creeps_Void_time_walk_motion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creeps_Void_time_walk_motion:CheckState() return {[MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_STUNNED] = true} end
function modifier_creeps_Void_time_walk_motion:IsMotionController() return true end
function modifier_creeps_Void_time_walk_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_creeps_Void_time_walk_motion:OnCreated(keys)
	if IsServer() then
		self.direction = Vector(keys.direction_x,keys.direction_y,0)
		-- self.direction = direction

		self.speed = keys.speed
		self.effected_enemies = {}
		self.MotionControll = 1
		if not self.MotionControll then
			self:SafeDestroy()
		else
			self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
		end
		local caster = self:GetCaster()
		local pos = caster:GetOrigin()
		local pos_end = pos + self.direction * self.speed*self:GetDuration()

		local particle_cast = "particles/rebuild/creeps_spell/void_time_walk_arc_1/effectarcana/faceless_void_arcana_time_walk_preimage_combined.vpcf"

		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(self.effect_cast,0,pos )
		ParticleManager:SetParticleControl(self.effect_cast,1,pos_end )
		ParticleManager:SetParticleControlEnt(self.effect_cast,2,caster,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
		local phantom_delay = math.max(self:GetDuration()-0.05,0)
		ParticleManager:SetParticleControl(self.effect_cast,10,Vector(phantom_delay,0,0) )
		ParticleManager:ReleaseParticleIndex(self.effect_cast)

		caster:AddActivityModifier("haste")
		-- caster:AddActivityModifier("mask_of_madness")
		caster:StartGesture(ACT_DOTA_RUN)
		caster:ClearActivityModifiers()


	end
end

function modifier_creeps_Void_time_walk_motion:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	local me = self:GetParent()
	local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  --需要debug确认作用
	new_pos = GetGroundPosition(new_pos, nil)   --返回移动到提供的position的地面位置。第二个参数是一个NPC，用于测量碰撞体积
	me:SetOrigin(new_pos)  --Sets the location of this entity
	self.MotionControll = 0
end
function modifier_creeps_Void_time_walk_motion:OnDestroy()   --当时间漫游结束时
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)  --Place a unit somewhere not already occupied.
		self.direction = nil
		self.speed = nil
		-- ParticleManager:DestroyParticle(effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self:GetCaster():RemoveGesture(ACT_DOTA_RUN)
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1_END)

		local ability = self:GetCaster():FindAbilityByName("creeps_spell_time_dilation")
		if ability then
			ability:OnSpellStart(1)
		end

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


modifier_creeps_Void_time_walk_damage_counter = class({})

function modifier_creeps_Void_time_walk_damage_counter:IsDebuff()				return false end
function modifier_creeps_Void_time_walk_damage_counter:IsHidden() 				return true end
function modifier_creeps_Void_time_walk_damage_counter:IsPurgable() 			return false end
function modifier_creeps_Void_time_walk_damage_counter:IsPurgeException() 		return false end
function modifier_creeps_Void_time_walk_damage_counter:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_Void_time_walk_damage_counter:RemoveOnDeath() return false end

modifier_creeps_Void_time_walk_damage = class({})

function modifier_creeps_Void_time_walk_damage:IsDebuff()				return false end
function modifier_creeps_Void_time_walk_damage:IsHidden() 				return true end
function modifier_creeps_Void_time_walk_damage:IsPurgable() 			return false end
function modifier_creeps_Void_time_walk_damage:IsPurgeException() 		return false end
function modifier_creeps_Void_time_walk_damage:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_creeps_Void_time_walk_damage:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_ambient.vpcf" end
function modifier_creeps_Void_time_walk_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW  end

-- function modifier_creeps_Void_time_walk_damage:OnCreated(keys)
-- 	if IsServer() then
-- 		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
-- 		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_back_mouth_fx", self:GetCaster():GetAbsOrigin(), true )
	
-- 		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

-- 	end
-- end





function modifier_creeps_Void_time_walk_damage:OnTakeDamage(keys)
	if not IsServer() then 
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end
	local duration = 3.5
	local buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_Void_time_walk_damage_counter", {duration = duration})
	if buff then 
		local damage = keys.damage-keys.damage%1
		buff:SetStackCount(damage * 10)
	end
end

