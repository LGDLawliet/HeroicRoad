--特效优化 √
Advanced_elder_dragon_form = class({})
LinkLuaModifier("modifier_Advanced_elder_dragon_form_transform", "skills/Advanced_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_elder_dragon_form_transform_cd", "skills/Advanced_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_elder_dragon_form_transform_20", "skills/Advanced_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_elder_dragon_form_transform_debuff", "skills/Advanced_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_elder_dragon_passive", "skills/Advanced_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_elder_dragon_little_dragon", "skills/Advanced_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)

function Advanced_elder_dragon_form:CheckKV(key)
	local table = {
		fire_damage = 0.1,
		bonus_attack_range = 4,
		bonus_attack = 15,
		cleave_index = 0.5
	}
	local value = table[key] or -1
	return value
end

function Advanced_elder_dragon_form:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_elder_dragon_passive",{})
	return true
end

function Advanced_elder_dragon_form:UnlockSecondCore(key)
	return false
end

function Advanced_elder_dragon_form:UnlockThirdCore(key)

	return false
end

function Advanced_elder_dragon_form:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/elder_dragon_form/unlock1/dark_glow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost_mid.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_burning_hands/effect_flame/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_burning_hands/burn_efect/effect.vpcf", context )
end

function Advanced_elder_dragon_form:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function Advanced_elder_dragon_form:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end
	return UF_SUCCESS
end

function Advanced_elder_dragon_form:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function Advanced_elder_dragon_form:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos == caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction = (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* (self:GetSpecialValueFor("length") +self:GetSpecialValueFor("width_end")*0.5)
	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self:GetSpecialValueFor("width_end"),self:GetSpecialValueFor("width_start"),0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function Advanced_elder_dragon_form:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function Advanced_elder_dragon_form:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	local range = self:GetSpecialValueFor("length") - caster:GetCastRangeBonus()
	return range
end

function Advanced_elder_dragon_form:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local pos = self:GetCursorPosition()
	-- 喷火
	self:Fireshoot(pos,1,1)
	-- 注销老变身状态，并更换为新变身状态
	caster:GameTimer(0.2,function ()
		local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
		if modifier then
			modifier:SafeDestroy()
		end
		caster.Form_MODIFIER_NAME = "modifier_Advanced_elder_dragon_form_transform"
		-- 变龙
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		EmitSoundOn("Hero_DragonKnight.ElderDragonForm", caster)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 5, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local duration = ability:GetSpecialValueFor("duration")	
		caster:AddNewModifier(caster, ability, "modifier_Advanced_elder_dragon_form_transform", {duration = duration})
	end)
	-- 奥义2群体变龙
	-- if self.unlock2 then
	-- 	local particle = ParticleManager:CreateParticle("particles/rebuild/spell/elder_dragon_form/unlock2/effect/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_POINT_FOLLOW, caster)
	-- 	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	-- 	ParticleManager:SetParticleControl(particle, 1, Vector(500,0,0))
	-- 	ParticleManager:ReleaseParticleIndex(particle)
	-- 	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	-- 	for _, unit in ipairs(units) do
			
	-- 		if unit~=caster then
	-- 			local modifier = unit:FindModifierByName(unit.Form_MODIFIER_NAME)
	-- 			if not modifier then
	-- 				unit:AddNewModifier(caster, ability, "modifier_Advanced_elder_dragon_form_transform", {duration = duration})
	-- 				unit.Form_MODIFIER_NAME = "modifier_Advanced_elder_dragon_form_transform"
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function Advanced_elder_dragon_form:Fireshoot(pos, damage_index, radius_index)
	if not IsServer() then return end
	local caster = self:GetCaster()
	-- 传参，伤害，长度，宽度，速度
	local damage_index = damage_index or 1
	local radius_index = radius_index or 1
	local damage = self:GetSpecialValueFor("fire_damage")*caster:GetAverageTrueAttackDamage(nil)
	local length = self:GetSpecialValueFor("length")*radius_index
	local width_start = self:GetSpecialValueFor("width_start")*radius_index
	local width_end = self:GetSpecialValueFor("width_end")*radius_index
	local speed = 0.4*length
	-- 确认方向
	local pos = pos
	local caster_loc = caster:GetAbsOrigin()
	if pos == caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction = (pos - caster_loc):Normalized()
	direction.z = 0
	-- 音效和喷射特效
	caster:EmitSound("Hero_DragonKnight.BreathFire")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 5, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	-- 创建火焰
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
	    bDeleteOnHit = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    EffectName = "particles/rebuild/chaotic_spell/chaotic_burning_hands/effect_flame/effect.vpcf",
	    fDistance = length-(width_end*0.5),
	    fStartRadius = width_start,
	    fEndRadius = width_end,
		vVelocity = direction * speed,
		ExtraData = {
			damage = damage * damage_index
		}
	}
	ProjectileManager:CreateLinearProjectile(info)
end

function Advanced_elder_dragon_form:OnProjectileHit_ExtraData( target, location,keys )
	if not target then return end
	self:PlayEffect(target)

	local debuff_duration = self:GetSpecialValueFor("debuff_duration")
	if self:GetSpecialValueFor("advanced_level") >= 15 then
		debuff_duration = debuff_duration + 1
	end
	target:AddNewModifier(self:GetCaster(),self,"modifier_Advanced_elder_dragon_form_transform_debuff",{duration = debuff_duration})
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = keys.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damageTable)
end

function Advanced_elder_dragon_form:PlayEffect(target)
	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_burning_hands/burn_efect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle)
end

function Advanced_elder_dragon_form:GetBehavior()
	-- 奥义1被动化
	if self:GetCaster():HasModifier("modifier_Advanced_elder_dragon_passive") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
		
	end
	return  self.BaseClass.GetBehavior(self)
end

----------------------------------------------------------------------------------------
modifier_Advanced_elder_dragon_form_transform = advanced_modifier({})
function modifier_Advanced_elder_dragon_form_transform:IsHidden()	return false end
function modifier_Advanced_elder_dragon_form_transform:IsPurgable()	return false end
function modifier_Advanced_elder_dragon_form_transform:IsDebuff()	return false end
function modifier_Advanced_elder_dragon_form_transform:CheckState()
	local state = {}
	if self.level >= 10 then
		state = {[MODIFIER_STATE_FLYING] = true,}
	end

	return state
end


function modifier_Advanced_elder_dragon_form_transform:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_PROJECTILE_NAME,
			MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
			-- MODIFIER_EVENT_ON_ATTACK,
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
		}
		if self:GetAbility():GetUnlock(3)==3 then
			table.insert(decFuncs,MODIFIER_EVENT_ON_ATTACK)
		end
		
		return decFuncs	
end
-- 更改形态，更换弹道和攻击声音
function modifier_Advanced_elder_dragon_form_transform:GetModifierModelScale() 
    return 40
end
function modifier_Advanced_elder_dragon_form_transform:GetAttackSound()
	return "Hero_DragonKnight.ElderDragonShoot2.Attack"
end
function modifier_Advanced_elder_dragon_form_transform:GetModifierModelChange()
	return "models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl"
end
function modifier_Advanced_elder_dragon_form_transform:GetModifierProjectileName()
	-- 毒龙"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
end

function modifier_Advanced_elder_dragon_form_transform:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.level = self:GetAbility():GetSpecialValueFor("advanced_level")
	
	if self.caster:Script_GetAttackRange() <= 500 then
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	else
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")*0.2
	end
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.cleave_index = self:GetAbility():GetSpecialValueFor("cleave_index")*0.01
	self.cleave_radius = self:GetAbility():GetSpecialValueFor("cleave_radius")
	self.fire_outgoing = self:GetAbility():GetSpecialValueFor("fire_outgoing")
	self.cd = self:GetAbility():GetSpecialValueFor("cd")
	self.damage_index = self:GetAbility():GetSpecialValueFor("damage_index")*0.01
	if self.level >= 5 then
		self.cd = self.cd -0.5
	end
    if IsServer() then
		-- 如果单位不是远程单位 则改变为远程
		if self.caster.IsRanger==false then
			self.caster.RangerFrom = self.caster.RangerFrom +  1   --变更为远程形态的状态数加一
			self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
		-- 更改龙的形态为火龙
		self:GetCaster():GameTimer(0.01, function()
			self.caster:SetSkin(1)
		end)
		-- 奥义1和3特效，3会创造小龙
		-- if self.ability.unlock1 then
		-- 	self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/elder_dragon_form/unlock1/dark_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		-- 	ParticleManager:SetParticleControlEnt(self.effect_cast,0,caster,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
		-- 	self:AddParticle(self.effect_cast,false, false, -1, false,false)
		-- end
	
		-- if self.ability.unlock3 then
		-- 	self:CallLittleDragon()
		-- end
	end
end

function modifier_Advanced_elder_dragon_form_transform:OnDestroy()
    if IsServer() then    	
		local caster  = self:GetParent()
		--如果单位不是远程单位 则改变为远程
		if caster.IsRanger==false then
			caster.RangerFrom = caster.RangerFrom -  1   --变更为远程形态的状态数减一
			--如果没有远程形态状态了变回近战
			if caster.RangerFrom==0 then
				caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end	
		end
		local modifier = self:GetParent():FindModifierByName("modifier_Advanced_elder_dragon_form_transform_20")
		if modifier then 
			modifier:Destroy()
		end
		-- 奥义3小龙注销
		-- if self.unit1 and self.unit2 and self.unit3 and not self.unit1:IsNull() and not self.unit2:IsNull() and not self.unit3:IsNull()  then
		-- 	self.unit1:FindModifierByName("modifier_Advanced_elder_dragon_little_dragon"):GoDie()
		-- 	self.unit2:FindModifierByName("modifier_Advanced_elder_dragon_little_dragon"):GoDie()
		-- 	self.unit3:FindModifierByName("modifier_Advanced_elder_dragon_little_dragon"):GoDie()
		-- end
    end
end

-- 攻击力，攻击距离，弹道速度
function modifier_Advanced_elder_dragon_form_transform:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}
    return funcs
end

function modifier_Advanced_elder_dragon_form_transform:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_attack end
function modifier_Advanced_elder_dragon_form_transform:Advanced_GetModifierAttackRangeBonus() return  self.bonus_attack_range end
function modifier_Advanced_elder_dragon_form_transform:GetModifierProjectileSpeedBonus() return 200 end
function modifier_Advanced_elder_dragon_form_transform:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	if keys.attacker ~= self:GetParent() then return end
	if not IsFireDamage(keys) then return end
	
	if self.level >= 5 then
		self.fire_outgoing = 30
	end
	return self.fire_outgoing
end
function modifier_Advanced_elder_dragon_form_transform:AdvancedGetModifierExtraHealthPercentage()
	if self.level < 15 then return end
	return 25
end
-- 火焰A
function modifier_Advanced_elder_dragon_form_transform:OnAttack(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then return end
	if keys.attacker:HasModifier("modifier_Advanced_elder_dragon_form_transform_cd") then return end
	if not keys.target then return end
	
	self:GetAbility():Fireshoot(keys.target:GetAbsOrigin(), self.damage_index, 1)
	keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_Advanced_elder_dragon_form_transform_cd",{duration = self.cd})
end
--溅射攻击
function modifier_Advanced_elder_dragon_form_transform:OnAttackLanded(keys)
	if not IsServer() then return end
	if not self:GetAbility() then return end
	
	local attacker = keys.attacker
	local caster = self:GetCaster()
	local target = keys.target
	local ability = self:GetAbility()

	if attacker ~= caster then return end
	if attacker:IsInSpecialAttack() then return end
	
	local cleave_damage = keys.damage *self.cleave_index
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self.cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			AttackCleaveDelay(caster, enemy, ability, cleave_damage)
		end
	end
end

function modifier_Advanced_elder_dragon_form_transform:OnTakeDamage(keys)
	if not IsServer() then return end
	if self.level < 20 then return end
	if keys.damage <= 0 then return end
	if keys.unit ~= self:GetParent() then return end
	
	local modifier = self:GetParent():FindModifierByName("modifier_Advanced_elder_dragon_form_transform_20")
	if modifier then
		modifier:SetStackCount(math.min(modifier:GetStackCount()+keys.damage*0.12, 2000))
	else
		self:GetParent():AddNewModifier(keys.unit, self:GetAbility(), "modifier_Advanced_elder_dragon_form_transform_20",{stack = keys.damage*0.12})
	end
end

-- --奥义3小龙攻击
-- function modifier_Advanced_elder_dragon_form_transform:Littledragonattack(target)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if not self.ability or self.ability:IsNull() then
-- 		self:SafeDestroy()
-- 		return
-- 	end
-- 	if not target then return end
-- 	-- 奥义3调动小龙
-- 	if self.unit1 and self.unit2 and self.unit3 and not self.unit1:IsNull() and not self.unit2:IsNull() and not self.unit3:IsNull()  then
-- 		local parent = self:GetParent()
-- 		local ability = self:GetAbility()
-- 		local info = 
-- 		{
-- 			Target = target,
-- 			-- Source = caster,
-- 			Ability = ability,	
-- 			-- EffectName = parent:GetRangedProjectileName(),
-- 			iMoveSpeed = parent:GetProjectileSpeed(),
-- 			-- sourceloc = pos,
-- 			-- caster:GetProjectileSpeed()
-- 			-- vSourceLoc = pos,
-- 			bDrawsOnMinimap = false,  --？？
-- 			bDodgeable = true,   --可躲闪
-- 			bIsAttack = false,   --攻击效果
-- 			bVisibleToEnemies = true,  --对敌人可视
-- 			bReplaceExisting = false, --替换现有的
-- 			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
-- 			bProvidesVision = false, --提供视野
-- 			ExtraData = {}   --额外的数据
-- 		}
-- 		info.Source = self.unit1
-- 		info.EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
-- 		ProjectileManager:CreateTrackingProjectile(info)
-- 		info.Source = self.unit2
-- 		info.EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
-- 		ProjectileManager:CreateTrackingProjectile(info)
-- 		info.Source = self.unit3
-- 		info.EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost_mid.vpcf"
-- 		ProjectileManager:CreateTrackingProjectile(info)
-- 	end
-- end
-- --奥义3小龙
-- function modifier_Advanced_elder_dragon_form_transform:CallLittleDragon()
-- 	local caster = self:GetParent()
-- 	local ability = self:GetAbility()
-- 	self.unit1 = CreateUnitByName("npc_hd_elder_little_dragon", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
-- 	self.unit1:AddNewModifier(caster, ability, "modifier_Advanced_elder_dragon_little_dragon", {type=0})
-- 	self.unit2 = CreateUnitByName("npc_hd_elder_little_dragon", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
-- 	self.unit2:AddNewModifier(caster, ability, "modifier_Advanced_elder_dragon_little_dragon", {type=1})
-- 	self.unit3 = CreateUnitByName("npc_hd_elder_little_dragon", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
-- 	self.unit3:AddNewModifier(caster, ability, "modifier_Advanced_elder_dragon_little_dragon", {type=2})
-- end
modifier_Advanced_elder_dragon_form_transform_20 = advanced_modifier({})
function modifier_Advanced_elder_dragon_form_transform_20:IsHidden()	return false end
function modifier_Advanced_elder_dragon_form_transform_20:IsPurgable()	return false end
function modifier_Advanced_elder_dragon_form_transform_20:IsDebuff()	return false end
function modifier_Advanced_elder_dragon_form_transform_20:OnCreated(keys)
	if not IsServer() then return end
	self.stack = self.stack or 0
	self.stack = self.stack + keys.stack
	if not self:GetAbility() then self:Destroy() return end
	self:SetStackCount(math.min(self.stack , 2000))
end
function modifier_Advanced_elder_dragon_form_transform_20:OnRefresh(keys)
	if not IsServer() then return end
	self.stack = self.stack or 0
	self.stack = self.stack + keys.stack
	if not self:GetAbility() then self:Destroy() return end
	self:SetStackCount(math.min(self.stack , 2000))
end
function modifier_Advanced_elder_dragon_form_transform_20:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_Advanced_elder_dragon_form_transform_20:Advanced_GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end
-------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_elder_dragon_form_transform_cd = advanced_modifier({})
function modifier_Advanced_elder_dragon_form_transform_cd:IsHidden()	return true end
function modifier_Advanced_elder_dragon_form_transform_cd:IsPurgable()	return false end
function modifier_Advanced_elder_dragon_form_transform_cd:IsDebuff()	return false end
----------------------------------------------------------------------------------------
modifier_Advanced_elder_dragon_form_transform_debuff = advanced_modifier({})
function modifier_Advanced_elder_dragon_form_transform_debuff:IsHidden()	return false end
function modifier_Advanced_elder_dragon_form_transform_debuff:IsPurgable()	return false end
function modifier_Advanced_elder_dragon_form_transform_debuff:IsDebuff()	return true end
function modifier_Advanced_elder_dragon_form_transform_debuff:OnCreated()
	if not self:GetAbility() then return end
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
end
function modifier_Advanced_elder_dragon_form_transform_debuff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_Advanced_elder_dragon_form_transform_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then return end
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 15 then
		self.incoming = 30
	end
	return self.incoming
end
----------------------------------------被动
modifier_Advanced_elder_dragon_passive = class({})

function modifier_Advanced_elder_dragon_passive:IsDebuff()			return false end
function modifier_Advanced_elder_dragon_passive:IsHidden() 			return true end
function modifier_Advanced_elder_dragon_passive:IsPurgable() 		return false end
function modifier_Advanced_elder_dragon_passive:IsPurgeException() 	return false end
function modifier_Advanced_elder_dragon_passive:RemoveOnDeath() return false end
function modifier_Advanced_elder_dragon_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_elder_dragon_passive:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_elder_dragon_passive:OnIntervalThink()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if not modifier then
		self:GetAbility():OnSpellStart()
	end
end
-------------------------------------小龙

modifier_Advanced_elder_dragon_little_dragon = modifier_Advanced_elder_dragon_little_dragon or class({})
function modifier_Advanced_elder_dragon_little_dragon:IsHidden()	return true end
function modifier_Advanced_elder_dragon_little_dragon:IsDebuff()	return false end
function modifier_Advanced_elder_dragon_little_dragon:IsPurgable()	return false end
function modifier_Advanced_elder_dragon_little_dragon:IsPurgeException()	return false end
function modifier_Advanced_elder_dragon_little_dragon:IsStunDebuff()	return false end
function modifier_Advanced_elder_dragon_little_dragon:AllowIllusionDuplicate()	return false end
function modifier_Advanced_elder_dragon_little_dragon:OnCreated(keys)
	
	self.height_offect = 128
	self.bonus_move = 0
	if IsServer() then
		self.type = keys.type
		self:GetParent():SetHullRadius(0)
		self:GetParent():SetModelScale(0.9)
		Timers:CreateTimer(0.05, function()
			self:GetParent():SetSkin(self.type)
		end)
		self.caster = self:GetCaster()
		self:StartIntervalThink(0.01)
		self:SetStackCount(self.type)
		
	end
	if self:GetStackCount()==2 then
		self.height_offect = 300
	end
end
function modifier_Advanced_elder_dragon_little_dragon:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_elder_dragon_little_dragon:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,

	}
end

function modifier_Advanced_elder_dragon_little_dragon:OnIntervalThink()
	if self.go_to_destroy then
		self.pos.z = self.pos.z+3
		self.pos =self.pos +self.forward*3
		-- print(self.pos)
		self:GetParent():SetAbsOrigin(self.pos)
		self:GetParent():SetForwardVector(self.forward)
		self.timer = self.timer +1
		if self.timer>=1000 then
			-- self:GetParent():AddNoDraw()
			-- UTIL_Remove(self:GetParent())
			self:GetParent():SetAbsOrigin(Vector(-6815,7931,769))
			self:SafeDestroy()
			return
		end
		return
	end
	local caster = self:GetCaster()

	if not caster then
		self:SafeDestroy()
		return
	end
	

	if not caster:HasModifier("modifier_Advanced_elder_dragon_form_transform") then
		-- self:SafeDestroy()
		self:GoDie()
		return
	end
	self.bonus_move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
	local parent = self:GetParent()
	local pos
	if self.type==0 then

		pos = caster:GetAbsOrigin()
		local forward = caster:GetForwardVector()
		-- pos = pos + forward*10
		local newpos = RotatePosition(pos, QAngle(0, 90, 0), pos + forward)
		local dir = (newpos-pos):Normalized()
		local target_pos = pos+dir*200
		-- target_pos.z = target_pos.z+128
		local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
		if dis>=2000 then
			parent:SetForwardVector(forward)
			parent:SetAbsOrigin(target_pos)
			return
		end
		if dis>=100 then
			parent:MoveToPosition(target_pos)
		else
			parent:SetForwardVector(forward)
		end
		-- parent:SetForwardVector(forward)
		-- parent:SetAbsOrigin(target_pos)
	elseif self.type==1 then

		pos = caster:GetAbsOrigin()
		local forward = caster:GetForwardVector()
		-- pos = pos + forward*10
		local newpos = RotatePosition(pos, QAngle(0, -90, 0), pos + forward)
		local dir = (newpos-pos):Normalized()
		local target_pos = pos+dir*200
		-- target_pos.z = target_pos.z+128
		local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
		if dis>=2000 then
			parent:SetForwardVector(forward)
			parent:SetAbsOrigin(target_pos)
			return
		end
		if dis>=100 then
			parent:MoveToPosition(target_pos)
		else
			parent:SetForwardVector(forward)
		end
		-- parent:SetForwardVector(forward)
		-- parent:SetAbsOrigin(target_pos)

	elseif self.type==2 then
		local attachment = caster:ScriptLookupAttachment( "attach_head" )
		pos = caster:GetAttachmentOrigin(attachment)
		-- pos.z = pos.z + 128
		local forward = caster:GetForwardVector()
		pos = pos - forward*50
		local dis = CalculateDistance(pos,parent:GetAbsOrigin())
		if dis>=2000 then
			parent:SetForwardVector(forward)
			parent:SetAbsOrigin(pos)
			return
		end
		if dis>=100 then
			parent:MoveToPosition(pos)
		else
			parent:SetForwardVector(forward)
		end
		-- parent:SetForwardVector(forward)
		-- parent:SetAbsOrigin(pos)
	end
end
function modifier_Advanced_elder_dragon_little_dragon:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_MODEL_CHANGE,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
	}
end
function modifier_Advanced_elder_dragon_little_dragon:GetVisualZDelta( params )
	-- if IsClient() then
	-- 	return
	-- end
	return self.height_offect
end
function modifier_Advanced_elder_dragon_little_dragon:GetModifierMoveSpeedBonus_Constant( params )
	local index =  (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()/500
	return self.bonus_move*index
end
function modifier_Advanced_elder_dragon_little_dragon:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

function modifier_Advanced_elder_dragon_little_dragon:GoDie()
	self.go_to_destroy = true
	self.pos = self:GetParent():GetAbsOrigin()
	self.timer = 0
	self.forward  = self:GetParent():GetForwardVector()
	-- self.forward = (-1*self.pos):Normalized()
	-- self.forward.z = 0
end
-- function modifier_Advanced_elder_dragon_little_dragon:GetModifierModelChange(params)
-- 	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
-- 	return self:GetCaster():GetModelName()
-- end
-- function modifier_Advanced_elder_dragon_little_dragon:GetOverrideAnimation(params)
-- 	return ACT_DOTA_RUN
-- end
-- function modifier_Advanced_elder_dragon_little_dragon:GetActivityTranslationModifiers()	
-- 	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then
-- 		return "haste"
-- 	end
-- 	return "run_fast" 
-- end
