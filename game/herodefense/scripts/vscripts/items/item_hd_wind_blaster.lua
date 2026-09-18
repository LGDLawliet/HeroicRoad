item_hd_wind_blaster = class({})

LinkLuaModifier("modifier_item_hd_wind_blaster", "items/item_hd_wind_blaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_blaster_no_armor", "items/item_hd_wind_blaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_blaster_active", "items/item_hd_wind_blaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_blaster_move", "items/item_hd_wind_blaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wind_blaster_sky", "items/item_hd_wind_blaster", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function item_hd_wind_blaster:GetIntrinsicModifierName()
	return "modifier_item_hd_wind_blaster"
end
function item_hd_wind_blaster:OnSpellStart()
	EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCaster())
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_wind_blaster_move", {duration = 0.3})
	local wind = self:GetCaster():FindModifierByName("modifier_item_hd_wind_blaster")
	if wind then
		wind:SetStackCount(0)
	end
	self:GetCaster():GameTimer(0.4,function()
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_hd_wind_blaster_active",{duration = self:GetSpecialValueFor("active_duration")})
	end)
end


-------------------------------------
modifier_item_hd_wind_blaster = advanced_modifier({})

function modifier_item_hd_wind_blaster:IsDebuff() return false end
function modifier_item_hd_wind_blaster:IsHidden() return false end
function modifier_item_hd_wind_blaster:IsPurgable() return false end 

function modifier_item_hd_wind_blaster:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_range = self.ability:GetSpecialValueFor("bonus_range")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.max = self.ability:GetSpecialValueFor("max")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.each = self.ability:GetSpecialValueFor("each")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.no_armor_normal = self.ability:GetSpecialValueFor("no_armor_normal")
	self.aoe_index_normal = self.ability:GetSpecialValueFor("aoe_index_normal")*0.01
	self.radius_normal = self.ability:GetSpecialValueFor("radius_normal")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_item_hd_wind_blaster:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_range = self.ability:GetSpecialValueFor("bonus_range")
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.max = self.ability:GetSpecialValueFor("max")
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.each = self.ability:GetSpecialValueFor("each")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.no_armor_normal = self.ability:GetSpecialValueFor("no_armor_normal")
	self.aoe_index_normal = self.ability:GetSpecialValueFor("aoe_index_normal")*0.01
	self.radius_normal = self.ability:GetSpecialValueFor("radius_normal")
end

function modifier_item_hd_wind_blaster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,         --移动速度上限
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,	--移动速度
		MODIFIER_PROPERTY_TOOLTIP,--描述
	}
end
function modifier_item_hd_wind_blaster:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,	--攻击距离
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,--全额攻击力百分比

		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
end
--基础属性
function modifier_item_hd_wind_blaster:Advanced_GetModifierPreAttack_BonusDamage()
	return self.bonus_damage 
end
function modifier_item_hd_wind_blaster:Advanced_GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self.bonus_range
	end
	return 0
end
function modifier_item_hd_wind_blaster:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move 
end
--唤风部分
function modifier_item_hd_wind_blaster:GetModifierMoveSpeedBonus_Percentage()
	return self.each * self:GetStackCount()
end
function modifier_item_hd_wind_blaster:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.each * self:GetStackCount()
end
function modifier_item_hd_wind_blaster:GetModifierIgnoreMovespeedLimit()
	if self:GetStackCount() >= self.max then
		return 1
	end
	return 0
end
function modifier_item_hd_wind_blaster:OnTooltip()
	return	self.each * self:GetStackCount()
end
--唤风叠加
function modifier_item_hd_wind_blaster:OnIntervalThink()
	self:SetStackCount(math.min(self:GetStackCount()+1,self.max))
end
--被动唤风烈击
function modifier_item_hd_wind_blaster:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and self.chance >= RandomInt(1,100) and not keys.attacker:IsInSpecialAttack() then
			keys.target:AddNewModifier(keys.attacker,self.ability,"modifier_item_hd_wind_blaster_no_armor",{duration = 0.1 , stack = self.no_armor_normal})
			keys.target:EmitSoundParams( "DOTA_Item.Cyclone.Activate", 0, 0.3, 0 )
			local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius_normal, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				self.damageTable = 
				{	victim 			= enemy,
					damage 			= keys.damage * self.aoe_index_normal,
					damage_type		= self.ability:GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
					attacker 		= keys.attacker,
					ability 		= self.ability,
					hd_flags 		= HD_DAMAGE_FLAG_NO_SPELL_CRIT,
				}
				enemy:AddNewModifier(keys.attacker,self.ability,"modifier_item_hd_wind_blaster_no_armor",{duration = 0.1 , stack = self.no_armor_normal})
				if enemy ~= keys.target then
					ApplyDamage(self.damageTable)
				end
			end

			--local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			--ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			--ParticleManager:SetParticleControlEnt(head_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
			--ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
			--ParticleManager:ReleaseParticleIndex(head_particle)
				
		end
	end
end
----------------------------------
-------------------------------------
modifier_item_hd_wind_blaster_active = advanced_modifier({})

function modifier_item_hd_wind_blaster_active:IsDebuff() return false end
function modifier_item_hd_wind_blaster_active:IsHidden() return false end
function modifier_item_hd_wind_blaster_active:IsPurgable() return false end 

function modifier_item_hd_wind_blaster_active:OnCreated(keys)
    self.ability = self:GetAbility()

	self.no_armor = self.ability:GetSpecialValueFor("no_armor")
	self.aoe_index = self.ability:GetSpecialValueFor("aoe_index")*0.01
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_item_hd_wind_blaster_active:OnRefresh(keys)
    self.ability = self:GetAbility()

	self.no_armor = self.ability:GetSpecialValueFor("no_armor")
	self.aoe_index = self.ability:GetSpecialValueFor("aoe_index")*0.01
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_item_hd_wind_blaster_active:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_BONUS_VISION,
	}
end
function modifier_item_hd_wind_blaster_active:CheckState()
	return{
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true,
	}
end
function modifier_item_hd_wind_blaster_active:Advanced_GetBonusVision()
	return 100000
end
--全装填唤风烈击
function modifier_item_hd_wind_blaster_active:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.attacker :IsInSpecialAttack() then
			keys.target:AddNewModifier(keys.attacker,self.ability,"modifier_item_hd_wind_blaster_no_armor",{duration = 0.1 , stack = self.no_armor})
			keys.target:EmitSound("DOTA_Item.Cyclone.Activate")
			local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				self.damageTable = 
				{	victim 			= enemy,
					damage 			= keys.damage * self.aoe_index,
					damage_type		= self.ability:GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
					attacker 		= keys.attacker,
					ability 		= self.ability,
					hd_flags 		= HD_DAMAGE_FLAG_NO_SPELL_CRIT,
				}
				enemy:AddNewModifier(keys.attacker,self.ability,"modifier_item_hd_wind_blaster_no_armor",{duration = 0.1 , stack = self.no_armor})
				enemy:AddNewModifier(keys.attacker,self.ability,"modifier_item_hd_wind_blaster_sky",{duration = 2.2})
				if enemy ~= keys.target then
					ApplyDamage(self.damageTable)
				end
			end
			self:SafeDestroy()
			--local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			--ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			--ParticleManager:SetParticleControlEnt(head_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
			--ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
			--ParticleManager:ReleaseParticleIndex(head_particle)
				
		end
	end
end
----------------------------------
modifier_item_hd_wind_blaster_no_armor = advanced_modifier({})

function modifier_item_hd_wind_blaster_no_armor:IsHidden()		return true end
function modifier_item_hd_wind_blaster_no_armor:IsPurgable()		return false end
function modifier_item_hd_wind_blaster_no_armor:RemoveOnDeath()	return false end
function modifier_item_hd_wind_blaster_no_armor:GetEffectName() return "particles/items_fx/cyclone.vpcf" end
function modifier_item_hd_wind_blaster_no_armor:GetEffectAttachType() return PATTACH_POINT end


function modifier_item_hd_wind_blaster_no_armor:OnCreated(keys)
	if IsServer() then
		self.no_armor = keys.stack
	end
end

function modifier_item_hd_wind_blaster_no_armor:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,         --护甲
	}
end

function modifier_item_hd_wind_blaster_no_armor:Advanced_GetModifierPhysicalArmorBonus() return -self.no_armor end
-----------------------------------
modifier_item_hd_wind_blaster_move = advanced_modifier({})

function modifier_item_hd_wind_blaster_move:IsDebuff() return false end
function modifier_item_hd_wind_blaster_move:IsHidden() return true end
function modifier_item_hd_wind_blaster_move:IsMotionController()  return true end
function modifier_item_hd_wind_blaster_move:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_hd_wind_blaster_move:GetEffectName() return "particles/items_fx/cyclone.vpcf" end
function modifier_item_hd_wind_blaster_move:GetEffectAttachType() return PATTACH_POINT end


function modifier_item_hd_wind_blaster_move:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:SafeDestroy() end
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self:StartIntervalThink(FrameTime())
		self.angle = -self:GetParent():GetForwardVector():Normalized()
		self.distance = 300 / ( self:GetDuration() / FrameTime())
    end
end

function modifier_item_hd_wind_blaster_move:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.05}) --提供相位，防止卡位
end

function modifier_item_hd_wind_blaster_move:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not self:CheckMotionControllers() then
		self:SafeDestroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_hd_wind_blaster_move:HorizontalMotion(unit, time)
	if not IsServer() then return end

	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end
-------------------------------------
modifier_item_hd_wind_blaster_sky = advanced_modifier({})

function modifier_item_hd_wind_blaster_sky:IsDebuff()				return true end
function modifier_item_hd_wind_blaster_sky:IsHidden() 			return true end
function modifier_item_hd_wind_blaster_sky:IsPurgable() 			return false end
function modifier_item_hd_wind_blaster_sky:IsPurgeException() 	return true end
function modifier_item_hd_wind_blaster_sky:IsStunDebuff() 		return true end
function modifier_item_hd_wind_blaster_sky:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_item_hd_wind_blaster_sky:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_item_hd_wind_blaster_sky:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_item_hd_wind_blaster_sky:OnRefresh(keys) self:OnCreated(keys) end
function modifier_item_hd_wind_blaster_sky:IsMotionController() return true end
function modifier_item_hd_wind_blaster_sky:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_item_hd_wind_blaster_sky:GetEffectName() return "particles/items_fx/cyclone.vpcf" end
function modifier_item_hd_wind_blaster_sky:GetEffectAttachType() return PATTACH_POINT end

function modifier_item_hd_wind_blaster_sky:OnCreated(keys)
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end

function modifier_item_hd_wind_blaster_sky:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 1000
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_item_hd_wind_blaster_sky:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

		self.pos = nil
		self.distance = nil 
	end
end