
Middle_elder_dragon_form = class({})
LinkLuaModifier("modifier_Middle_elder_dragon_form_transform", "skills/Middle_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_elder_dragon_form_transform_cd", "skills/Middle_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
-- 指示器
function Middle_elder_dragon_form:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_burning_hands/effect_flame/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_burning_hands/burn_efect/effect.vpcf", context )
end

function Middle_elder_dragon_form:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function Middle_elder_dragon_form:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end
	return UF_SUCCESS
end

function Middle_elder_dragon_form:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function Middle_elder_dragon_form:UpdateCustomIndicator( loc )
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

function Middle_elder_dragon_form:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function Middle_elder_dragon_form:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	local range = self:GetSpecialValueFor("length") - caster:GetCastRangeBonus()
	return range
end
-- 施法效果
function Middle_elder_dragon_form:OnSpellStart()
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
		caster.Form_MODIFIER_NAME = "modifier_Middle_elder_dragon_form_transform"
		-- 变龙
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		EmitSoundOn("Hero_DragonKnight.ElderDragonForm", caster)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 5, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local duration = ability:GetSpecialValueFor("duration")	
		caster:AddNewModifier(caster, ability, "modifier_Middle_elder_dragon_form_transform", {duration = duration})
	end)
end

function Middle_elder_dragon_form:Fireshoot(pos, damage_index, radius_index)
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

function Middle_elder_dragon_form:OnProjectileHit_ExtraData( target, location,keys )
	if not target then return end
	self:PlayEffect(target)

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

function Middle_elder_dragon_form:PlayEffect(target)
	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_burning_hands/burn_efect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle)
end
-------------------------------------------------------------------------------------------------------------------------------
modifier_Middle_elder_dragon_form_transform = advanced_modifier({})
function modifier_Middle_elder_dragon_form_transform:IsHidden()	return false end
function modifier_Middle_elder_dragon_form_transform:IsPurgable()	return false end
function modifier_Middle_elder_dragon_form_transform:IsDebuff()	return false end
function modifier_Middle_elder_dragon_form_transform:GetPriority() return MODIFIER_PRIORITY_ULTRA-1 end
function modifier_Middle_elder_dragon_form_transform:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
		
	return decFuncs	
end
-- 更改形态，更换弹道和攻击声音
function modifier_Middle_elder_dragon_form_transform:GetModifierModelScale() 
    return 40
end
function modifier_Middle_elder_dragon_form_transform:GetAttackSound()
	return "Hero_DragonKnight.ElderDragonShoot2.Attack"
end
function modifier_Middle_elder_dragon_form_transform:GetModifierModelChange()
	return "models/items/dragon_knight/oblivion_blazer_dragon/oblivion_blazer_dragon.vmdl"
end
function modifier_Middle_elder_dragon_form_transform:GetModifierProjectileName()
	-- 毒龙"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
end
-- 改变攻击形态
function modifier_Middle_elder_dragon_form_transform:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	if self.caster:Script_GetAttackRange() <= 500 then
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	else
		self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")*0.2
	end
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.cleave_index = self:GetAbility():GetSpecialValueFor("cleave_index")*0.01
	self.cleave_radius = self:GetAbility():GetSpecialValueFor("cleave_radius")

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
    end
end
-- 退出变身，属性复原
function modifier_Middle_elder_dragon_form_transform:OnDestroy()
    if IsServer() then    	
		local caster =self:GetCaster()
		--如果单位不是远程单位 则改变为远程
		if caster.IsRanger==false then
			caster.RangerFrom = caster.RangerFrom -  1   --变更为远程形态的状态数减一
			--如果没有远程形态状态了变回近战
			if caster.RangerFrom==0 then
				caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end	
		end
    end
end
-- 攻击力，攻击距离，弹道速度
function modifier_Middle_elder_dragon_form_transform:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_Middle_elder_dragon_form_transform:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_attack end
function modifier_Middle_elder_dragon_form_transform:Advanced_GetModifierAttackRangeBonus() return  self.bonus_attack_range end
function modifier_Middle_elder_dragon_form_transform:GetModifierProjectileSpeedBonus() return 200 end
function modifier_Middle_elder_dragon_form_transform:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	if keys.attacker ~= self:GetParent() then return end
	if not IsFireDamage(keys) then return end
	
	return self:GetAbility():GetSpecialValueFor("fire_outgoing")
end
-- 火焰A
function modifier_Middle_elder_dragon_form_transform:OnAttack(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then return end
	if keys.attacker:HasModifier("modifier_Middle_elder_dragon_form_transform_cd") then return end
	if not keys.target then return end
	local cd = self:GetAbility():GetSpecialValueFor("cd")
	local damage_index = self:GetAbility():GetSpecialValueFor("damage_index")*0.01
	self:GetAbility():Fireshoot(keys.target:GetAbsOrigin(), damage_index, 1)
	keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_Middle_elder_dragon_form_transform_cd",{duration = cd})
end
-- 溅射攻击
function modifier_Middle_elder_dragon_form_transform:OnAttackLanded(keys)
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

-------------------------------------------------------------------------------------------------------------------------------
modifier_Middle_elder_dragon_form_transform_cd = advanced_modifier({})
function modifier_Middle_elder_dragon_form_transform_cd:IsHidden()	return true end
function modifier_Middle_elder_dragon_form_transform_cd:IsPurgable()	return false end
function modifier_Middle_elder_dragon_form_transform_cd:IsDebuff()	return false end