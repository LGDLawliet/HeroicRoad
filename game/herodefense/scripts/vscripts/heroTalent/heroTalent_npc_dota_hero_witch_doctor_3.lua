LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_witch_doctor_3", "heroTalent/heroTalent_npc_dota_hero_witch_doctor_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_heroTalent_witch_doctor_3_voodoo_totem", "heroTalent/heroTalent_npc_dota_hero_witch_doctor_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_witch_doctor_3_fury_totem", "heroTalent/heroTalent_npc_dota_hero_witch_doctor_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_witch_doctor_3_death_ward", "heroTalent/heroTalent_npc_dota_hero_witch_doctor_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_witch_doctor_3_ward_buff", "heroTalent/heroTalent_npc_dota_hero_witch_doctor_3", LUA_MODIFIER_MOTION_NONE)

heroTalent_npc_dota_hero_witch_doctor_3 = class({})

function heroTalent_npc_dota_hero_witch_doctor_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_witch_doctor/witch_doctor_death_ward.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_witch_doctor/witch_doctor_death_ward_attack.vpcf", context )

end

function heroTalent_npc_dota_hero_witch_doctor_3:GetBehavior()
	if self:GetCaster():GetLevel() < self:GetSpecialValueFor("level") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function heroTalent_npc_dota_hero_witch_doctor_3:GetAOERadius()
	return self:GetSpecialValueFor("s_range") + self:GetCaster():GetLevel()*self:GetSpecialValueFor("s_bonus_range")
end

function heroTalent_npc_dota_hero_witch_doctor_3:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local type = 0
	if caster:GetLevel() >= self:GetSpecialValueFor("level") then
		type = 1
		if self:GetAutoCastState() then
			type = 2
		end
	end
	self:CreateDeathWard(point,type)
end

function heroTalent_npc_dota_hero_witch_doctor_3:CreateDeathWard(position, ward_type)
	if not IsServer() then return end
	if not position then return end
	
	local count = self:GetSpecialValueFor("s_max")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	
	local caster = self:GetCaster()
	local caster_attack = Game_State:IsInChaoticEra() and math.min(caster:GetAverageTrueAttackDamage(nil), caster:GetBaseDamageMax()*5) or caster:GetBaseDamageMax()

	local life_duration = self:GetSpecialValueFor("s_duration") 
	local damage = caster_attack*(self:GetSpecialValueFor("s_attack")*0.01 + caster:GetLevel()*self:GetSpecialValueFor("s_bonus_attack")*0.01)
	local range = self:GetSpecialValueFor("s_range") + caster:GetLevel()*self:GetSpecialValueFor("s_bonus_range")
	local summon_index = ward_type == 1 and self:GetSpecialValueFor("summon_index")*0.01 or 1
	
	local unit_pos = position + self:GetCaster():GetForwardVector()
	local unit = caster:SummonUnit("npc_witch_doctor_3_ward",life_duration,unit_pos,caster:GetForwardVector(),self,0,100,nil,damage,0,summon_index,1)
	table.insert(self.summon_table,unit)

	unit:AddNewModifier(caster, self, "modifier_heroTalent_witch_doctor_3_death_ward", {range = range})
	if ward_type == 1 then
		unit:AddNewModifier(caster, self, "modifier_heroTalent_witch_doctor_3_fury_totem", {})
	elseif ward_type == 2 then
		unit:AddNewModifier(caster, self, "modifier_heroTalent_witch_doctor_3_voodoo_totem", {range = range})
	end
end

function heroTalent_npc_dota_hero_witch_doctor_3:GlaiveAttck(srouce, target, bounce, attacker)
	if not IsServer() then return end
	
	local level = self:GetCaster():GetLevel()
	local line = self:GetSpecialValueFor("level")
	local attach_point = srouce:ScriptLookupAttachment( "attach_hitloc" )
	local effect = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf"
	local effect_speed = 2000
	
	local info = 
	{
		Target = target,
		-- Source = srouce,
		vSourceLoc = srouce:GetAttachmentOrigin(attach_point),
		Ability = self,	
		EffectName = effect,
		iMoveSpeed = effect_speed,
		bDrawsOnMinimap = false,  --？？
		bDodgeable = level < line,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {
			bounce = bounce-1, 
			attacker_entindex = attacker:entindex()  -- 使用entindex来传递攻击者
			}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function heroTalent_npc_dota_hero_witch_doctor_3:OnProjectileHit_ExtraData(target, location, keys)
	if not IsServer() then return end
	if not target then return end
	-- 从entindex恢复攻击者
	local attacker = nil
	if keys.attacker_entindex then
		attacker = EntIndexToHScript(keys.attacker_entindex)
	end
	if not attacker or not attacker:IsAlive() then return end
	-- 确保攻击者是守卫
	local ward = nil
	if attacker:GetUnitName() == "npc_witch_doctor_3_ward" then
		ward = attacker
	else
		-- 如果攻击者不是守卫，尝试找到守卫
		local wards = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(wards) do
			if unit:GetUnitName() == "npc_witch_doctor_3_ward" and unit:IsAlive() then
				ward = unit
				break
			end
		end
	end
	
	if not ward then return end
	
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 1,
		iDisableCleave =1,
		iDisableSplit = 1,
	}
	local attackEffectRecord = ward:AddAttackEffectModifier(self,modifier_keys)
	ward:PerformAttack(target, false, false, true, true, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	
	local bounce = keys.bounce
	if bounce > 0 and IsValid(target) then
			local search_range = ward:Script_GetAttackRange() + 50
	local enemies = FindUnitsInRadius(ward:GetTeamNumber(), target:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local newTarget
	for _, unit in ipairs(enemies) do
		if unit:IsAlive() and unit ~= target then
			newTarget = unit
			break
		end
	end
		if newTarget then
			self:GlaiveAttck(target, newTarget, bounce, ward)
		end
	end
end
-- 死亡守卫modifier
modifier_heroTalent_witch_doctor_3_death_ward = advanced_modifier({})

function modifier_heroTalent_witch_doctor_3_death_ward:IsHidden() return true end
function modifier_heroTalent_witch_doctor_3_death_ward:IsDebuff() return false end
function modifier_heroTalent_witch_doctor_3_death_ward:IsPurgable() return false end

function modifier_heroTalent_witch_doctor_3_death_ward:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if IsServer() then
		EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_WitchDoctor.Maledict_Cast", self.parent)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(150, 0, 0))
		ParticleManager:DestroyParticle(particle, false)

		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0,self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(0,0,0))
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		self:SetStackCount(keys.range)
	end
end

function modifier_heroTalent_witch_doctor_3_death_ward:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end

function modifier_heroTalent_witch_doctor_3_death_ward:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	} 
end

function modifier_heroTalent_witch_doctor_3_death_ward:Advanced_GetModifierAttackRangeOverride()
	return self:GetStackCount()
end

function modifier_heroTalent_witch_doctor_3_death_ward:OnAttackLanded(keys)
	if not IsServer() then return end

	local attacker = keys.attacker
	local first_target = keys.target
	if attacker ~= self.parent then return end
	
	local bounce = 1
	if attacker:HasModifier("modifier_heroTalent_witch_doctor_3_fury_totem") then
		bounce = bounce + 1
	end

	local search_range = self:GetStackCount() + 50
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), first_target:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local target
	for _, unit in ipairs(enemies) do
		if unit ~= first_target and unit:IsAlive() then
			target = unit
			break
		end
	end
	if target then
		self.ability:GlaiveAttck(first_target, target, bounce, attacker)
	end
end


-- 狂怒图腾觉醒
modifier_heroTalent_witch_doctor_3_fury_totem = advanced_modifier({})

function modifier_heroTalent_witch_doctor_3_fury_totem:IsHidden() return true end
function modifier_heroTalent_witch_doctor_3_fury_totem:IsDebuff() return false end
function modifier_heroTalent_witch_doctor_3_fury_totem:IsPurgable() return false end
function modifier_heroTalent_witch_doctor_3_fury_totem:RemoveOnDeath() return false end
function modifier_heroTalent_witch_doctor_3_fury_totem:OnCreated()
	self.parent = self:GetParent()
	self.no_armor = self:GetAbility():GetSpecialValueFor("no_armor")
end
function modifier_heroTalent_witch_doctor_3_fury_totem:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
end
function modifier_heroTalent_witch_doctor_3_fury_totem:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE
	}
end
function modifier_heroTalent_witch_doctor_3_fury_totem:Advanced_GetModifierAttackArmor_Ignore()
	return self.no_armor
end

-- 巫毒图腾觉醒
modifier_heroTalent_witch_doctor_3_voodoo_totem = advanced_modifier({})

function modifier_heroTalent_witch_doctor_3_voodoo_totem:IsHidden() return true end
function modifier_heroTalent_witch_doctor_3_voodoo_totem:IsDebuff() return false end
function modifier_heroTalent_witch_doctor_3_voodoo_totem:IsPurgable() return false end
function modifier_heroTalent_witch_doctor_3_voodoo_totem:RemoveOnDeath() return false end

function modifier_heroTalent_witch_doctor_3_voodoo_totem:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_heroTalent_witch_doctor_3_voodoo_totem:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.heal = self.ability:GetSpecialValueFor("heal")*0.01
	if IsServer() then
		self:SetStackCount(keys.range)
		self:StartIntervalThink(1)
	end
end

function modifier_heroTalent_witch_doctor_3_voodoo_totem:OnIntervalThink()
	local allies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.parent:Script_GetAttackRange() ,DOTA_UNIT_TARGET_TEAM_FRIENDLY ,DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, ally in ipairs(allies) do
		if ally:IsAlive() and ally ~= self.parent then
			
			local heal = ally:GetMaxHealth()*self.heal
			if ally:IsHero() then
				heal = heal*0.5
			end
			HealWithGain(heal,self.caster,ally,self.ability)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal, nil) 

			local modifier = ally:FindModifierByName("modifier_heroTalent_witch_doctor_3_ward_buff")
			if modifier then
				modifier:ForceRefresh()
				modifier:SetDuration(1, true)
			else
				ally:AddNewModifier(self.caster, self.ability, "modifier_heroTalent_witch_doctor_3_ward_buff", {duration = 1})
			end
		end
	end
end


-- 巫毒图腾光环效果
modifier_heroTalent_witch_doctor_3_ward_buff = advanced_modifier({})

function modifier_heroTalent_witch_doctor_3_ward_buff:IsHidden() return false end
function modifier_heroTalent_witch_doctor_3_ward_buff:IsDebuff() return false end
function modifier_heroTalent_witch_doctor_3_ward_buff:IsPurgable() return false end

function modifier_heroTalent_witch_doctor_3_ward_buff:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")

	if self.parent:IsHero() then
		self.attack = self.attack*0.5
		self.attack_speed = self.attack_speed*0.5
		self.spell_amp = self.spell_amp*0.5
	end
end

function modifier_heroTalent_witch_doctor_3_ward_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end

function modifier_heroTalent_witch_doctor_3_ward_buff:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.attack
end

function modifier_heroTalent_witch_doctor_3_ward_buff:Advanced_GetModifierAttackSpeedPercentage()
	return self.attack_speed
end

function modifier_heroTalent_witch_doctor_3_ward_buff:Advanced_GetModifierSpellAmplifyBonus()
	return self.spell_amp
end
